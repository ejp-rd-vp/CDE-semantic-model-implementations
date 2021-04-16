
require './CDE_Transform'
require 'sinatra'

get '/' do
  execute()
end

def execute

  puts "Content-type: text/plain\n\n"
  puts "executing transformation"
  
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
  
  `curl -v -L -X PUT -H "Content-type: application/n-triples" --data-binary @/data/triples/concatenated.nt http://graphdb:7200/repositories/cde/statements`
end
