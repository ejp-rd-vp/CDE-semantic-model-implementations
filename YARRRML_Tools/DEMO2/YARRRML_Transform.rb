require 'tempfile'
require 'rest-client'
#Dir[File.join(__dir__, 'config', '*.rb')].each { |file| require file }

# note that SDBrdfizer needs to be running on port 4000 with the ./data folder mounted as /data

class YARRRML_Transform
  
  attr_accessor :datafile
  attr_accessor :yarrrmltemplate
  attr_accessor :yarrrmlfilename
  attr_accessor :configfilename
  attr_accessor :outputrmlfile
  attr_accessor :outputrdffolder
  attr_accessor :datatype
  attr_accessor :formulation
  attr_accessor :inifile
  attr_accessor :inifilename
  

  def initialize(params = {}) # get a name from the "new" call, or set a default
    
    @yarrrmlfilename = params.fetch(:yarrrmlfilename, nil)
    @yarrrmltemplate = params.fetch(:yarrrmltemplate, nil)

    @datafile = params.fetch(:datafile, nil)
    @outputrmlfile = params.fetch(:outputrmlfile, nil)
    @outputrdffolder = params.fetch(:outputrdffolder, nil)
    @datatype = params.fetch( :datatype, nil)
    @formulation = params.fetch(:formulation, "csv")

    abort "must have a datatype parameter" unless @datatype
    abort "must have a datafile parameter" unless @datafile

    unless @datafile =~ /data\/(.*)/
      abort "datafile must exist in the mounted data folder (usually ./data/datafile.csv)"
    else 
      $stderr.puts "taking datafile name #{$1}"
      @datafile = $1
    end

    @outputrmlfile = "/data/"+ self.datatype+"_rml.ttl" unless @outputrmlfile
    @outputrdffolder = "/data/triples/" unless @outputrdffolder
    @yarrrmlfilename = "/data/#{self.datatype}_yarrrml.yaml" unless @yarrrmlfilename
    @yarrrmltemplate = "./config/#{self.datatype}_yarrrml_template.yaml" unless @yarrrmltemplate
    @inifile = "./data/#{self.datatype}.ini"
    @inifilename = "#{self.datatype}.ini"

    write_ini(self.inifile, self.outputrdffolder, self.outputrmlfile, self.datatype)
    
    # transform appropriate template with this data
    File.open(self.yarrrmltemplate, "r") {|f| @template = f.read}
    @template.gsub!("|||DATA|||", self.datafile)
    @template.gsub!("|||FORMULATION|||", self.formulation)
    File.open("./"+self.yarrrmlfilename, "w") {|f| f.puts @template}
    $stderr.puts "Ready to yarrrml transform #{datatype}"
    return self

  end
  

  def write_ini(inifile = self.inifile, rdffolder = self.outputrdffolder, rmlfile = self.outputrmlfile, datatype = self.datatype)
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
  
  def yarrrml_transform
    $stderr.puts "running docker yarrrml-parser:ejp-latest"
    parser_start_string = "docker run -e PARSERIN=#{self.yarrrmlfilename} -e PARSEROUT=#{self.outputrmlfile} --rm --name yarrrml-parser -v $PWD/data:/data markw/yarrrml-parser-ejp:latest"
    $stderr.puts "parser start with: " + parser_start_string
    system(parser_start_string)
    $stderr.puts "rml file has been created in #{self.outputrmlfile} - ready to make FAIR data"
  end
  
  
  def make_fair_data
    $stderr.puts "making FAIR data with http://localhost:4000/graph_creation/data/#{self.inifilename}"
    response = RestClient.get("http://localhost:4000/graph_creation/data/#{self.inifilename}")
    $stderr.puts response.body
    $stderr.puts "FAIR data is avaialable in .#{self.outputrdffolder}" + self.datatype + ".nt"
    return File.read("." + self.outputrdffolder + self.datatype + ".nt")
  end
  
  
end
