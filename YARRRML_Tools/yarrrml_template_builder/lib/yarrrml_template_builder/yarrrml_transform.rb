require 'tempfile'
require 'rest-client'

# note that SDMrdfizer needs to be running on port 4000 with the ./data folder mounted as /data
# docker run --name rdfizer --rm -d -p 4000:4000 -v $PWD/data:/data fairdatasystems/sdmrdfizer:0.1.0

class YARRRML_Transform
  
  attr_accessor :datafile
  attr_accessor :datatype_tag
  attr_accessor :yarrrmltemplate
  attr_accessor :yarrrmlfilename
  attr_accessor :configfilename
  attr_accessor :outputrmlfile
  attr_accessor :outputrdffolder
  attr_accessor :formulation
  attr_accessor :inifile
  attr_accessor :inifilename
  

# Creates the YARRRML Transformer object
#
# all params are passed as a hash, and retrieved by params.fetch(paramName).  the ini file used by yarrrml transform is auto-generated
#
# @param datafile [string]  (required) the path and filename to the file mounted in ./data (e.g. ./data/myfile.csv)
# @param datatype_tag [string]   (required) a one-word indicator of the data type.  This is considered the "base" for all other filenames (see below)
# @param outputrmlfile [string]  (optional - is auto-constructed from the datatype-tag (see below))
# @param outputrdffolder [string]  (optional - defaults to /data/triples - this folder must exist, even if left to default.  NOTE - this path is not relative to the host, it is relative to the docker rdfizer, so it begins with /data not ./data)
# @param formulation [string]  for the yarrrml transformer, what is the input file format (default 'csv')
#
# @return [YARRRML_Transform]
#
#  the datatype_tag is used to construct other input/output filenames.  e.g. a tag of "height" will
# cause the output RML file to be "./data/height_rml.ttl", and the expected YARRRML template being named 
# "./config/height_yarrrml_template.yaml"
#

  def initialize(params = {}) # get a name from the "new" call, or set a default
    
    @yarrrmlfilename = params.fetch(:yarrrmlfilename, nil)
    @yarrrmltemplate = params.fetch(:yarrrmltemplate, nil)

    @datafile = params.fetch(:datafile, nil)
    @outputrmlfile = params.fetch(:outputrmlfile, nil)
    @outputrdffolder = params.fetch(:outputrdffolder, nil)
    @datatype_tag = params.fetch( :datatype_tag, nil)
    @formulation = params.fetch(:formulation, "csv")

    abort "must have a datatype_tag parameter" unless @datatype_tag
    abort "must have a datafile parameter" unless @datafile

    unless @datafile =~ /data\/(.*)/
      abort "datafile must exist in the mounted data folder (usually ./data/datafile.csv)"
    else 
      $stderr.puts "taking datafile name #{$1}"
      @datafile = $1
    end

    @outputrmlfile = "/data/#{self.datatype_tag}_rml.ttl" unless @outputrmlfile
    @outputrdffolder = "/data/triples/" unless @outputrdffolder
    @yarrrmlfilename = "/data/#{self.datatype_tag}_yarrrml.yaml" unless @yarrrmlfilename
    @yarrrmltemplate = "./config/#{self.datatype_tag}_yarrrml_template.yaml" unless @yarrrmltemplate
    @inifile = "./data/#{self.datatype_tag}.ini"
    @inifilename = "#{self.datatype_tag}.ini"

    write_ini(self.inifile, self.outputrdffolder, self.outputrmlfile, self.datatype_tag)
    
    # transform appropriate template with this data
    File.open(self.yarrrmltemplate, "r") {|f| @template = f.read}
    @template.gsub!("|||DATA|||", self.datafile)
    @template.gsub!("|||FORMULATION|||", self.formulation)
    File.open("./"+self.yarrrmlfilename, "w") {|f| f.puts @template}
    $stderr.puts "Ready to yarrrml transform #{self.datatype_tag}"
    return self

  end
  

  def write_ini(inifile = self.inifile, rdffolder = self.outputrdffolder, rmlfile = self.outputrmlfile, datatype = self.datatype_tag)
    configfilecontent = <<CONFIG
[default]
main_directory: /data

[datasets]
number_of_datasets: 1
output_folder: #{rdffolder}
all_in_one_file: yes
remove_duplicate: yes
enrichment: yes
name: #{datatype}

[dataset1]
name: #{datatype}
mapping: #{rmlfile}

CONFIG

    File.open(inifile, "w"){|f| f.puts configfilecontent}
  end
  
# Executes the yarrrml to rml transformation 
#
# no parameters
#
#
  def yarrrml_transform
    $stderr.puts "running docker yarrrml-parser:ejp-latest"
    parser_start_string = "docker run -e PARSERIN=#{self.yarrrmlfilename} -e PARSEROUT=#{self.outputrmlfile} --rm --name yarrrml-parser -v $PWD/data:/data markw/yarrrml-parser-ejp:latest"
    $stderr.puts "parser start with: " + parser_start_string
    system(parser_start_string)
    $stderr.puts "rml file has been created in #{self.outputrmlfile} - ready to make FAIR data"
  end
  
# Executes the CSV to RDF based on the RML
#
# no parameters
#
#executes the sdmrdfizer transformation using the .ini file created by the 'initialize' routine
  
  def make_fair_data
    $stderr.puts "making FAIR data with http://localhost:4000/graph_creation/data/#{self.inifilename}"  # this is sdmrdfizer
    response = RestClient.get("http://localhost:4000/graph_creation/data/#{self.inifilename}")
    $stderr.puts response.body
    $stderr.puts "FAIR data is avaialable in .#{self.outputrdffolder}" + self.datatype_tag + ".nt"
    return File.read("." + self.outputrdffolder + self.datatype_tag + ".nt")
  end
  
  
end
