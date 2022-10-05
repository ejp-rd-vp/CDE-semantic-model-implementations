require 'tempfile'
require 'rest-client'

# note that SDMrdfizer needs to be running on port 4000 with the ./data folder mounted as /data
# docker run --name rdfizer --rm -d -p 4000:4000 -v $PWD/data:/data fairdatasystems/sdmrdfizer:0.1.0

class YARRRML_Transform
  
  attr_accessor :data_path_server
  attr_accessor :data_path_client
  attr_accessor :config_path_server
  attr_accessor :config_path_client
  attr_accessor :rdfizer_base_url
  attr_accessor :yarrrml_transform_base_url
  attr_accessor :datatype_tag
  attr_accessor :datafile
  attr_accessor :baseURI
  
  attr_accessor :yarrrmltemplate
  attr_accessor :yarrrmlfilename_client
  attr_accessor :yarrrmlfilename_server
  attr_accessor :outputrmlfile
  attr_accessor :formulation
  attr_accessor :outputrdffolder
  attr_accessor :inifile_client
  attr_accessor :inifile_server  
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
# @option params   :datatype_tag [String] (required)  a one-word indicator of the data type.  This is considered the "base" for all other filenames (see below)
# @option params   :data_path_server [String]  (/data) the path to data from the server perspective (default for Docker image)
# @option params   :data_path_client  [String]  (/data) the path to data from the client perspective (default for Docker image)
# @option params   :config_path_server [String]  (/config) the path to config from the server perspective (default for Docker image)
# @option params   :config_path_client [String]  (/config) the path to config from the server perspective (default for Docker image)
# @option params   :formulation [String]  (csv)
# @option params   :rdfizer_base_url [String] (http://rdfizer:4000) the base URL of the yarrrml_parser (default for a docker)
# @option params   :yarrrml_transform_base_url [String] ("http://yarrrml_transform:3000")  base URL of the yarrrml transform to rml script (default for a docker)

# @option params   :outputrdffolder [String]  (/data/triples/) - defaults to /data/triples - this folder must exist, even if left to default.  NOTE - this path is not relative to the host, it is relative to the docker rdfizer, so it begins with /data not ./data)
# @return [YARRRML_Transform]
  def initialize(params = {}) # get a name from the "new" call, or set a default
    
    @datatype_tag = params.fetch( :datatype_tag, nil)
    unless @datatype_tag
          warn "must have a datatype_tag parameter.  Aborting"
          self.failure = true
          return nil
    end
    
    @data_path_client = params.fetch(:data_path_client, "/data")   # from client perspective (default for docker)
    @data_path_server = params.fetch(:data_path_server, self.data_path_client)     # potentially from Docker image perspective (default for docker)
    @config_path_client = params.fetch(:config_path_client, "/config")  # from client perspective (default for docker)
    @config_path_server = params.fetch(:config_path_server, self.config_path_client)  # potentially from Docker image perspective (default for docker)

    @data_path_client.gsub!('/$', "")   # remove trailing slashes -I'll add them later if I need them
    @data_path_server.gsub!('/$', "")
    @config_path_client.gsub!('/$', "")
    @config_path_server.gsub!('/$', "")


    @rdfizer_base_url = params.fetch(:rdfizer_base_url, "http://rdfizer:4000")
    @yarrrml_transform_base_url = params.fetch(:yarrrml_transform_base_url, "http://yarrrml_transform:3000")
    @rdfizer_base_url.gsub!('/$', "")
    @yarrrml_transform_base_url.gsub!('/$', "")
    
    
    @formulation = params.fetch(:formulation, "csv")
    @datafile = params.fetch(:datafile, "#{self.data_path_server}/#{self.datatype_tag}.csv")
    @baseURI = params.fetch(:baseURI, ENV['baseURI'])
    @baseURI = "http://example.org/data/" unless @baseURI

    @outputrdffolder = params.fetch(:outputrdffolder, "#{self.data_path_server}/triples")
    @outputrmlfile = params.fetch(:outputrmlfile, "#{self.data_path_server}/#{self.datatype_tag}_rml.ttl")
    @yarrrmlfilename_client = params.fetch(:yarrrmlfilename, "#{self.data_path_client}/#{self.datatype_tag}_yarrrml.yaml")
    @yarrrmlfilename_server = params.fetch(:yarrrmlfilename, "#{self.data_path_server}/#{self.datatype_tag}_yarrrml.yaml")
    @yarrrmltemplate = params.fetch(:yarrrmltemplate, "#{self.config_path_client}/#{self.datatype_tag}_yarrrml_template.yaml")
    @inifile_client = params.fetch(:inifile_client, "#{self.data_path_client}/#{self.datatype_tag}.ini")
    @inifile_server = params.fetch(:inifile_server, "#{self.data_path_server}/#{self.datatype_tag}.ini")   # this will be a docker image in almost all cases
    
    
    write_ini()
    
    transform_template()
    
    return self

  end
  


  def transform_template()
# transform appropriate template with this data

    File.open(self.yarrrmltemplate, "r") {|f| @template = f.read}
    @template.gsub!("|||DATA|||", self.datafile)
    @template.gsub!("|||FORMULATION|||", self.formulation)
    @template.gsub!("|||BASE|||", self.baseURI)
    File.open(self.yarrrmlfilename_client, "w") {|f| f.puts @template}
    warn "Ready to yarrrml transform #{self.datatype_tag} from #{self.yarrrmlfilename_client} "

  end
  
  


  def write_ini(inifile = self.inifile_client,
                path = self.data_path_server,
                rdffolder = self.outputrdffolder,
                rmlfile = self.outputrmlfile,
                datatype = self.datatype_tag)

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

    File.open(inifile, "w"){|f| f.puts configfilecontent}

  end
  
  
  
# Executes the yarrrml to rml transformation 
#
# no parameters
#
#
  def yarrrml_transform
    warn "running docker yarrrml-parser:ejp-latest"
    #parser_start_string = "docker run -e PARSERIN=#{self.yarrrmlfilename} -e PARSEROUT=#{self.outputrmlfile} --rm --name yarrrml-parser -v $PWD/data:/data markw/yarrrml-parser-ejp:latest"
    warn "yarrrml to rml starting with: #{self.yarrrml_transform_base_url} PARSERIN=#{self.yarrrmlfilename_server} -e PARSEROUT=#{self.outputrmlfile}"
    #resp = RestClient.get("#{self.yarrrml_transform_base_url}/?parserin=#{self.yarrrmlfilename_server}&parserout=#{self.outputrmlfile}")
    resp = RestClient.execute(method: :get, url: "#{self.yarrrml_transform_base_url}/?parserin=#{self.yarrrmlfilename_server}&parserout=#{self.outputrmlfile}", timeout: 9000000)
    warn "#{resp}: rml file has been created in #{self.outputrmlfile} - ready to make FAIR data"
  end
  
  
  
# Executes the CSV to RDF based on the RML
#
# no parameters
#
#executes the sdmrdfizer transformation using the .ini file created by the 'initialize' routine
  def make_fair_data
    warn "making FAIR data with #{self.rdfizer_base_url}/graph_creation/#{self.inifile_server}"  # this is sdmrdfizer
    response = RestClient.execute(method: :get, url: self.rdfizer_base_url + "/graph_creation" + self.inifile_server, timeout: 900000000)
    warn response.code
    warn "FAIR data is avaialable in .#{self.outputrdffolder}/#{self.datatype_tag}.nt"
  end
  
  
end
