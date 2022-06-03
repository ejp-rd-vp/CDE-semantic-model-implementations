require './CDE_Transform'
require 'sinatra'
require 'rest-client'
require './http_utils'
require 'open3'

include HTTPUtils

get '/' do
  update
  execute
  cleanup
  metadata_update
  "Execution complete.  See docker log for errors (if any)\n\n"
end

def update
  warn 'first open3 git pull'
  o, e, _s = Open3.capture3('cd CDE-semantic-model-implementations && git pull')
  warn "second open3 copy yarrrml #{o}  #{e}"
  o, e, _s = Open3.capture3('cp -rf ./CDE-semantic-model-implementations/YARRRML_Transform_Templates/templates/*.yaml  /config')
  warn "second open3 complete #{o} #{e}"
end

def metadata_update
  warn 'calling metadata updater image'
  resp = RestClient.get('http://updater:4567/update')
  warn resp
  warn "\n\nMetadata Update complete\n\n"
end

def cleanup
  warn 'closing cleanup open3'
  _o, _s = Open3.capture2('rm -rf /data/triplesstats.csv')
end

def execute
  purge_nt
  datatype_list = Dir['/data/*.csv']
  # datatype_list = %w{personal}
  cde = CDE_Transform.new
  datatype_list.each do |d|
    d =~ %r{.+/([^.]+)\.csv}
    datatype = Regexp.last_match(1)
    next unless datatype

    cde.transform(datatype)
  end

  files = Dir['/data/triples/*.nt']
  concatenated = ''
  files.each do |f|
    content = File.open(f, 'r').read
    concatenated += content
  end
  write_to_graphdb(concatenated)
end

def write_to_graphdb(concatenated)
  user = ENV['GraphDB_User']
  pass = ENV['GraphDB_Pass']
  network = ENV['networkname'] || 'graphdb'
  url = "http://#{network}:7200/repositories/cde/statements"
  headers = { content_type: 'application/n-triples' }

  HTTPUtils.put(url, headers, concatenated, user, pass)
end

def purge_nt
  File.delete('/data/triples/*.nt')
rescue StandardError
  warn ''
ensure
  warn 'looks like it is already clean in here!'
end
