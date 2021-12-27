
require './CDE_Transform'
require 'sinatra'
require 'rest-client'
require './http_utils'
require 'open3'

include HTTPUtils


get '/' do
  update()
  execute()
  cleanup()
  metadata_update()
  "Execution complete.  See docker log for errors (if any)\n\n"

end

def update
  $stderr.puts "first open3 git pull"
  o, e, s = Open3.capture3("cd CDE-semantic-model-implementations && git pull")
  $stderr.puts "second open3 copy yarrrml #{o}  #{e}"
  s = s
  o, e, s = Open3.capture3("cp -rf ./CDE-semantic-model-implementations/YARRRML_Transform_Templates/templates/*.yaml  /config")
  $stderr.puts "second open3 complete #{o} #{e}"
    
end

def metadata_update
  $stderr.puts "calling metadata updater image"
  resp = RestClient.get("http://updater:4567/update")
  $stderr.puts resp
  $stderr.puts "\n\nMetadata Update complete\n\n"    
end


def cleanup
  $stderr.puts "closing cleanup open3"
      o, s = Open3.capture2("rm -rf /data/triplesstats.csv")
      o = o; s = s
end

def execute
  
  datatype_list = Dir["/data/*.csv"]
  
  #datatype_list = %w{personal}
  
  cde = CDE_Transform.new()
    
  datatype_list.each do |d|
    d =~ /.+\/([^\.]+)\.csv/
    datatype = $1
    next unless datatype
    cde.transform(datatype)
  end


  begin
    File.delete("/data/triples/*.nt")
  rescue
    $stderr.puts ""
  ensure
    $stderr.puts "looks like it is already clean in here!"
  end
  
  files = Dir["/data/triples/*.nt"]
  concatenated = ""
  files.each {|f| content = File.open(f, "r").read; concatenated += content}
  #f =File.open("/data/triples/concatenated.nt", "w") 
  #f.write concatenated
  #f.close
  #
  user = ENV['GraphDB_User']
  pass = ENV['GraphDB_Pass']
  network = "graphdb"
  network = ENV['networkname'] if ENV['networkname']
  url = "http://#{network}:7200/repositories/cde/statements"
  headers = { :content_type => "application/n-triples" }

  HTTPUtils.put(url, headers, concatenated, user, pass)

end
