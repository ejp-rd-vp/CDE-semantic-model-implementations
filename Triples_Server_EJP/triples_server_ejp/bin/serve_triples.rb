require 'sinatra'

get '/' do
  files = Dir["/data/triples/*.nt"]
  
  files.each do |f|
    puts f.read
  end
end
