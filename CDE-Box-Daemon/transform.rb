
require './CDE_Transform'
require 'sinatra'
require 'rest-client'
require './http_utils'

include HTTPUtils


get '/' do
  execute()
  "Execution complete.  See docker log for errors (if any)"

end

def execute
  
  datatype_list = Dir["/data/*.csv"]
  
  #datatype_list = %w{personal}
  
  cde = CDE_Transform.new()
    
  datatype_list.each do |d|
    d =~ /.+\/([^\.]+)\.csv/
    datatype = $1
    next unless datatype
#    d.gsub!(/\/data\//, "")  # remove /data/ path
#    d.gsub!(/\.csv/, "")  # remove trailing file format
    cde.transform(datatype)
  end
  
  files = Dir["/data/triples/*.nt"]
  concatenated = ""
  files.each {|f| content = File.open(f, "r").read; concatenated += content}
  f =File.open("/data/triples/concatenated.nt", "w")  # overwrite
  f.write concatenated
  f.close
  
  user = ENV['GraphDB_User']
  pass = ENV['GraphDB_Pass']
  network = "graphdb"
  network = ENV['networkname'] if ENV['networkname']
  url = "http://#{network}:7200/repositories/cde/statements"
  headers = { :content_type => "application/n-triples" }

  HTTPUtils.put(url, headers, concatenated, user, pass)

end
