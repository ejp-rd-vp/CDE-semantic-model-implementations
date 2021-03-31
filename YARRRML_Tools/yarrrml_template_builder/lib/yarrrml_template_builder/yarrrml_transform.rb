require 'tempfile'
require 'rest-client'

# note that SDMrdfizer needs to be running on port 4000 with the ./data folder mounted as /data
# docker run --name rdfizer --rm -d -p 4000:4000 -v $PWD/data:/data fairdatasystems/sdmrdfizer:0.1.0

class YARRRML_Transform
  
  attr_accessor :datafile
  attr_accessor :datafile_path
  attr_accessor :datatype_tag
  attr_accessor :yarrrmltemplate
  attr_accessor :yarrrmlfilename
  attr_accessor :configfilename
  attr_accessor :outputrmlfile
  attr_accessor :outputrdffolder
  attr_accessor :formulation
  attr_accessor :inifile
  attr_accessor :inifile_name
  attr_accessor :inifile_path
  attr_accessor :rdfizer_base_url
  attr_accessor :failure
 
  

# Creates the YARRRML Transformer object
#
#
#  the datatype_tag is used to construct other input/output filenames.  e.g. a tag of "height" will
# cause the output RML file to be "./data/height_rml.ttl", and the expected YARRRML template being named 
# "./config/height_yarrrml_template.yaml"
#
# Note that this assumes a specific configuration, with a csv folder mounted as /data/, containing a subdirectory /data/triples
# and a folder containing the yarrrml templates mounted as /config inside the docker container
#
# all params are passed as a hash, and retrieved by params.fetch(paramName).  the ini file used by yarrrml transform is auto-generated
#
# @param params [Hash]  params   a Hash of options
# @option params  :datatype_tag [String]   (required) a one-word indicator of the data type.  This is considered the "base" for all other filenames (see below)
# @option params  :rdfizer_base_url [String] (http://localhost:4000/graph_creation/) the base URL of the yarrrml_parser docker instance server 
# @option params  :datafile [String]  (/data/[datatype_tag].csv) the path and filename to the csv file FROM THE PERSPECTIVE OF THE DOCKER INSTANCE 
# @option params  :datafile_path [String]  (/data) the path to the csv file FROM THE PERSPECTIVE OF THE DOCKER INSTANCE 
# @option params  :outputrmlfile [String]  (/data/[datatype_tag]_rml.ttl) - is auto-constructed from the datatype-tag (see below))
# @option params  :outputrdffolder [String]  (/data/triples/) - defaults to /data/triples - this folder must exist, even if left to default.  NOTE - this path is not relative to the host, it is relative to the docker rdfizer, so it begins with /data not ./data)
# @option params  :formulation [String]  for the yarrrml transformer, what is the input file format (default 'csv')
# @option params  :inifile_path [String]  (/data/[datatype_tag].ini)  FROM THE PERSPECTIVE OF THE DOCKER INSTANCE
# @option params  :inifile_name [String]  ([datatype_tag].ini)
#
# @return [YARRRML_Transform]
  def initialize(params = {}) # get a name from the "new" call, or set a default
    

    @datatype_tag = params.fetch( :datatype_tag, nil)
    unless @datatype_tag
          $stderr.puts "must have a datatype_tag parameter.  Aborting"
          self.failure = true
          return nil
    end
    @datafile = params.fetch(:datafile, "/data/" + @datatype_tag + ".csv")
    unless File.exists?(@datafile)
        $stderr.puts "the CSV file #{@datafile} doesn't exist!  Aborting"
        self.failure = true
        return nil
        #abort "the CSV file #{@datafile} doesn't exist!  Aborting"
    end


    @rdfizer_base_url = params.fetch(:rdfizer_base_url, "http://rdfizer:4000/graph_creation")
    @outputrdffolder = params.fetch(:outputrdffolder, "/data/triples")
    @formulation = params.fetch(:formulation, "csv")
    @datafile = params.fetch(:datafile, "/data/" + @datatype_tag + ".csv")
    @datafile_path = params.fetch(:datafile_path, "/data")
    @outputrmlfile = params.fetch(:outputrmlfile, "/data/#{self.datatype_tag}_rml.ttl")
    @yarrrmlfilename = params.fetch(:yarrrmlfilename, "/data/#{self.datatype_tag}_yarrrml.yaml")
    @yarrrmltemplate = params.fetch(:yarrrmltemplate, "/config/#{self.datatype_tag}_yarrrml_template.yaml")
    @inifile_path = params.fetch(:inifile_path, "/data/#{self.datatype_tag}.ini")
    @inifile_name = params.fetch(:inifile_name, "#{self.datatype_tag}.ini")

    
$stderr.puts "writing", self.datafile_path + "/" + self.inifile_name, self.datafile_path, self.outputrdffolder, self.outputrmlfile, self.datatype_tag
    write_ini(self.datafile_path + "/" + self.inifile_name, self.datafile_path, self.outputrdffolder, self.outputrmlfile, self.datatype_tag)
    
    # transform appropriate template with this data
    File.open(self.yarrrmltemplate, "r") {|f| @template = f.read}
    @template.gsub!("|||DATA|||", self.datafile)
    @template.gsub!("|||FORMULATION|||", self.formulation)
    File.open(self.yarrrmlfilename, "w") {|f| f.puts @template}
    $stderr.puts "Ready to yarrrml transform #{self.datatype_tag} from #{self.yarrrmlfilename} "
    return self

  end
  

  def write_ini(inifile = self.inifile, path = self.datafile_path, rdffolder = self.outputrdffolder, rmlfile = self.outputrmlfile, datatype = self.datatype_tag)
    configfilecontent = <<CONFIG
[default]
main_directory: #{path}

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
    #$stderr.puts "inifile #{inifile} \nconfig #{configfilecontent}\n"
    File.open(inifile, "w"){|f| f.puts configfilecontent}
  end
  
# Executes the yarrrml to rml transformation 
#
# no parameters
#
#
  def yarrrml_transform
    $stderr.puts "running docker yarrrml-parser:ejp-latest"
    #parser_start_string = "docker run -e PARSERIN=#{self.yarrrmlfilename} -e PARSEROUT=#{self.outputrmlfile} --rm --name yarrrml-parser -v $PWD/data:/data markw/yarrrml-parser-ejp:latest"
    $stderr.puts "parser start with: PARSERIN=#{self.yarrrmlfilename} -e PARSEROUT=#{self.outputrmlfile}"
    resp = RestClient.get("http://yarrrml_transform:3000/?parserin=#{self.yarrrmlfilename}&parserout=#{self.outputrmlfile}")
    #system(parser_start_string)
    $stderr.puts "#{resp}: rml file has been created in #{self.outputrmlfile} - ready to make FAIR data"
  end
  
# Executes the CSV to RDF based on the RML
#
# no parameters
#
#executes the sdmrdfizer transformation using the .ini file created by the 'initialize' routine
  
  def make_fair_data
    $stderr.puts "making FAIR data with #{self.rdfizer_base_url + self.inifile_path}"  # this is sdmrdfizer
    response = RestClient.get(self.rdfizer_base_url + self.inifile_path)
    $stderr.puts response.code
    $stderr.puts "FAIR data is avaialable in .#{self.outputrdffolder}" + "/" + self.datatype_tag + ".nt"
    #return File.read(self.outputrdffolder + self.datatype_tag + ".nt")
  end
  
  
end
