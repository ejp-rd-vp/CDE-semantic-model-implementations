# frozen_string_literal: true

require_relative 'version'
require 'tempfile'
require 'rest-client'
require 'yaml'
require 'digest'

class YARRRML_Template_Builder
  
  attr_accessor :prefix_map
  attr_accessor :baseURI  
  attr_accessor :sio_verbose  
  attr_accessor :source_tag
  attr_accessor :sources_module
  

  attr_accessor :personid_column
  attr_accessor :uniqueid_column
  attr_accessor :identifier_type
  attr_accessor :identifier_type_column
  attr_accessor :person_type
  attr_accessor :person_type_column
  attr_accessor :person_role_tag 
  attr_accessor :role_type 
  attr_accessor :role_type_column
  attr_accessor :role_label
  attr_accessor :role_label_column
  
  attr_accessor :process_type
  attr_accessor :process_type_column
  attr_accessor :process_tag
  attr_accessor :process_label
  attr_accessor :process_label_column
  attr_accessor :process_start_column
  attr_accessor :process_end_column

  attr_accessor :process_with_input_tag  
  attr_accessor :input_type 
  attr_accessor :input_type_tag 
  attr_accessor :input_type_column
  attr_accessor :input_type_label 
  attr_accessor :input_type_label_column
  attr_accessor :input_has_value
  attr_accessor :input_has_value_column
  attr_accessor :input_has_value_datatype
  attr_accessor :input_has_value_datatype_column
  attr_accessor :input_is_output_of_process_tag
  attr_accessor :input_refers_to
  attr_accessor :input_refers_to_columns
    
  attr_accessor :inout_process_tag 
  attr_accessor :inout_refers_to 
  attr_accessor :inout_refers_to_label 
  attr_accessor :inout_refers_to_columns
  attr_accessor :inout_refers_to_label_columns 

  attr_accessor :attribute_type
  attr_accessor :attribute_type_column
  attr_accessor :attribute_tag
  attr_accessor :attribute_label
  attr_accessor :attribute_label_column

  attr_accessor :process_with_output_tag
  attr_accessor :output_type
  attr_accessor :output_type_column
  attr_accessor :output_type_label
  attr_accessor :output_type_label_column
  attr_accessor :output_value
  attr_accessor :output_value_column
  attr_accessor :output_comments_column
  attr_accessor :output_value_datatype
  attr_accessor :output_value_datatype_column
  attr_accessor :output_start_column
  attr_accessor :output_end_column

  
  attr_accessor :output_unit
  attr_accessor :output_unit_column
  attr_accessor :output_unit_label_column
  attr_accessor :output_unit_label
  
  attr_accessor :output_ontology_type 
  attr_accessor :output_ontology_type_column
  attr_accessor :output_ontology_label
  attr_accessor :output_ontology_label_column
   
  
  attr_accessor :mappings  

  SIO = {
"has-attribute" => ["http://semanticscience.org/resource/has-attribute", "http://semanticscience.org/resource/SIO_000008"], 
"has-quality" => ["http://semanticscience.org/resource/SIO_000217", "http://semanticscience.org/resource/has-quality"],
"has-unit" => ["http://semanticscience.org/resource/SIO_000221", "http://semanticscience.org/resource/has-unit"],
"has-value" => ["http://semanticscience.org/resource/SIO_000300", "http://semanticscience.org/resource/has-value"],
"has-role" => ["http://semanticscience.org/resource/SIO_000228", "http://semanticscience.org/resource/has-role"],
"is-participant-in" => ["http://semanticscience.org/resource/SIO_000062", "http://semanticscience.org/resource/is-participant-in"],
"is-about" => ["http://semanticscience.org/resource/SIO_000332", "http://semanticscience.org/resource/is-about"],
"has-output" => ["http://semanticscience.org/resource/SIO_000229", "http://semanticscience.org/resource/has-output"],
"denotes" => ["http://semanticscience.org/resource/SIO_000020", "http://semanticscience.org/resource/denotes"],
"is-realized-in" => ["http://semanticscience.org/resource/SIO_000356", "http://semanticscience.org/resource/is-realized-in"],
"start-time" => ["http://semanticscience.org/resource/SIO_000669", "http://semanticscience.org/resource/start-time"],
"end-time" => ["http://semanticscience.org/resource/SIO_000670", "http://semanticscience.org/resource/end-time"],
"is-component-part-of" => ["http://semanticscience.org/resource/SIO_000313", "http://semanticscience.org/resource/is-component-part-of"],
"drug" => ["http://semanticscience.org/resource/SIO_010038", "http://semanticscience.org/resource/drug"],
"is-base-for" => ["http://semanticscience.org/resource/SIO_000642", "http://semanticscience.org/resource/is-base-for"],
"has-concretization" => ["http://semanticscience.org/resource/SIO_000213", "http://semanticscience.org/resource/has-concretization"],
"realizable-entity" =>  ["http://semanticscience.org/resource/SIO_000340", "http://semanticscience.org/resource/realizable-entity"],
"information-content-entity" =>  ["http://semanticscience.org/resource/SIO_000015", "http://semanticscience.org/resource/information-content-entity"],
"measurement-value" => ["http://semanticscience.org/resource/SIO_000070", "http://semanticscience.org/resource/measurement-value"],
"refers-to" => ["http://semanticscience.org/resource/SIO_000628", "http://semanticscience.org/resource/refers-to"],
"has-input" => ["http://semanticscience.org/resource/SIO_000230", "http://semanticscience.org/resource/has-input"],
"person" => ["http://semanticscience.org/resource/SIO_000498", "http://semanticscience.org/resource/person"],
"identifier" => ["http://semanticscience.org/resource/SIO_000115", "http://semanticscience.org/resource/identifier"],
"role" => ["http://semanticscience.org/resource/SIO_000016", "http://semanticscience.org/resource/role"],
"process" => ["http://semanticscience.org/resource/SIO_000006", "http://semanticscience.org/resource/process"],
"attribute" => ["http://semanticscience.org/resource/SIO_000614]", "http://semanticscience.org/resource/attribute"]
             
}

# Creates the Template Builder object
#
# all params are passed as a hash, and retrieved by params.fetch(paramName)
#
# @param baseURI [string] a URL that will become the base for "urls owned by the data provider" e.g. "http://my.dataset.org/thisdataset/records/"
# @param source_name [string]  a "short name" (i.e. a single word, no spaces) for the kind of data being transformed.  e.g. height_data
# @param sio_verbose [0/1]  "1" means to use http://semanticscience.org/resource/has-value instead of http://semanticscience.org/resource/SIO_000300 for all sio.  Default is 0
#
# @return [YARRRML_Template_BuilderII]
#
  def initialize(params = {}) # get a name from the "new" call, or set a default
    
    @baseURI = params.fetch(:baseURI, nil)
    @sio_verbose = params.fetch(:sio_verbose, 0)
    abort "must have a baseURI parameter" unless self.baseURI
    @mappings = []

    @source_tag = params.fetch(:source_tag, nil)
    abort "must have a source_name parameter" unless self.source_tag

    @prefix_map = {"rdf" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs" => "http://www.w3.org/2000/01/rdf-schema#",
      "ex" => "http://ejp-rd.eu/ids/",
      "obo" => "http://purl.obolibrary.org/obo/",
      "sio" => "http://semanticscience.org/resource/",
      "vocab" => "http://ejp-rd.eu/vocab/", 
      "pico" => "http://data.cochrane.org/ontologies/pico/",
      "ndfrt" => "http://purl.bioontology.org/ontology/NDFRT/",
      "edam" => "http://purl.bioontology.org/ontology/EDAM/",
      }
    
    self.add_prefixes(prefixesHash: {"this" => self.baseURI})
    sources_module()
    
  end



# adds new Prefixes to the prefix map
#
# Parameters passed as the value to the key :prefixesHash
#
# @param [Hash] value of prefixesHash
#   a hash of prefix (string) =>  URL prefix
#   e.g. {"mydata" => "http://my.dataset.org/thisdataset/records/"}
#   you can send it an empty hash to simply return the existing hash
#
# @return [Hash]  the current hash of prefixes
#  
  def add_prefixes(params = {})
    
    prefixesHash = params.fetch(:prefixesHash, {})
    @prefix_map.merge!(prefixesHash)
    return self.prefix_map
    
  end


# Generate the YARRRML Template
#
# No input parameters
#
# @return [YAML] represents the YARRRML template
#  
  def generate
    output = Hash.new
    output["prefixes"] = @prefix_map
    output["sources"] = @sources_module
    
    clauses = Hash.new
    
    self.mappings.each {|m| clauses.merge!(m)}#; $stderr.puts m; $stderr.puts "CLAUSES: #{clauses}\n\n"}
    output["mappings"] = clauses
    
    return YAML::dump(output)
    
  end
  
  
  
  
  def sources_module
    
    @sources_module =  {
        "#{self.source_tag}-source" =>
        {
          "access" => "|||DATA|||",
          "referenceFormulation" => "|||FORMULATION|||",
          "iterator" => "$"
        }
    }
    
  end





# creates a single clause of the YARRRML (one subject, [p, o; p,o;....] mapping)
#
#  DO NOT use this externally!  I will eventually make it private...
#
# @param [name] (string) a unique name for that YARRRRML component (e.g. thisRole_realized_in_SomeProcess)
# @param [source] (string) the YARRRML source identifier
# @param [subject] (URI) URI of the subject
# @param [name] (string) a unique name for that YARRRRML component (e.g. thisRole_realized_in_SomeProcess)
# @param [pots] (Array) An array of arrays of [Predicate-object-datatype] (datatype is "iri" if it is a Node, rather than a literal)


#

  def mapping_clause(name, source, s, pots)
    pos = []
    pots.each do |pot|
      (pred, obj, type) = pot
      typetag = "type"
      typetag = "datatype" unless type == 'iri'
      pos << {
           "predicates" => pred, 
           "objects" => { 
                "value" => obj,
                typetag => type}
                }
    end
    
    mappingclause = {
      name => {
        "sources" => source,
        "s" => s,
        "po" => pos
      }
    }
      
    return mappingclause
  end



# creates the person/identifier/role portion of the CDE
#
# Parameters passed as a hash
#
# @param [:personid_column] (string) (required) the column header that contains the anonymous identifier of the person; defaults to "pid"
# @param [:uniqueid_column] (string) (required) the column header that contains unique ID for that row (over ALL datasets! e.g. a hash of a timestamp); defaults to "uniqid"
# @param [:identifier_type] (URL) the URL of the ontological type of that identifier; defaults to  'https://ejp-rd.eu/vocab/identifier'
# @param [:identifier_type_column] (string) the column header for the ontological type of that identifier.  Overrides identifier_type.
# @param [:person_type] (URL) the URL of the ontological type defining a "person"; defaults to 'https://ejp-rd.eu/vocab/Person'
# @param [:person_type_column] (strong) the column header for the ontological type of the "individual".  Overrides person_type
# @param [:person_role_tag] (string) a single-word label for the kind of role (e.g. "patient", "clinician") the person plays in this dataset; defaults to "thisRole"
# @param [:role_type] (QName) the QName for the ontological type of that role; defaults to "obo:OBI_0000093" ("patient")
# @param [:role_type_column] (strong) the column header that contains the ontological type of that role.  Overrides role_type
# @param [:role_label] (string) the label for that kind of role; defaults to "Patient"
# @param [:role_label_column] (string) the column header that has the label for that kind of role (overrides role_label)
#

  def person_identifier_role_mappings(params = {})
    @personid_column = params.fetch(:personid_column, 'pid')
    @uniqueid_column = params.fetch(:uniqueid_column, 'uniqid')
    
    @identifier_type = params.fetch(:identifier_type,  SIO["identifier"][self.sio_verbose])
    @identifier_type_column = params.fetch(:identifier_type_column, nil)
    @person_type = params.fetch(:person_type, SIO["person"][self.sio_verbose])
    @person_type_column = params.fetch(:person_type_column, nil)
    @person_role_tag = params.fetch(:person_role_tag, 'thisRole')
    @role_type = params.fetch(:role_type, 'obo:OBI_0000093')  # patient
    @role_type_column = params.fetch(:role_type_column, nil)  # 
    @role_label = params.fetch(:role_label, 'Patient')  # patient
    @role_label_column = params.fetch(:role_label_column, nil)  # 

    identifier_type = self.identifier_type_column ? "$(#{self.identifier_type_column})":self.identifier_type
    person_type = self.person_type_column ? "$(#{self.person_type_column})":self.person_type
    role_type = self.role_type_column ? "$(#{self.role_type_column})":self.role_type
    role_label = self.role_label_column ? "$(#{self.role_label_column})":self.role_label

    abort "You MUST have a personid_column and a uniqueid_column to use this library.  Sorry!" unless @personid_column and @uniqueid_column
    @mappings << mapping_clause(
                             "identifier_has_value",
                             ["#{self.source_tag}-source"],
                             "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})#ID",
                             [[SIO["has-value"][self.sio_verbose], "$(#{self.personid_column})", "xsd:string"]]
                             )

    @mappings << mapping_clause(
                                  "identifier_denotes",
                                  ["#{self.source_tag}-source"],
                                  "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})#ID",
                                  [
                                   ["a", "#{identifier_type}", "iri"],
                                   ["a", SIO["identifier"][self.sio_verbose], "iri"],
                                   [SIO["denotes"][self.sio_verbose], "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.person_role_tag}", "iri"],
                                  ]
                                 )
    @mappings << mapping_clause(
                                "person_has_role",
                                ["#{self.source_tag}-source"],
                                "this:individual_$(#{self.personid_column})#Person",
                                [
                                 ["a", "#{person_type}", "iri"],
                                 ["a", SIO["person"][self.sio_verbose], "iri"],
                                 [SIO["has-role"][self.sio_verbose], "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.person_role_tag}", "iri"],
                                ]
                               )

    @mappings << mapping_clause(
                                "#{self.person_role_tag}_annotation",
                                ["#{self.source_tag}-source"],
                                "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.person_role_tag}",
                                [
                                  ["a", "#{role_type}", "iri"],
                                  ["a", SIO["role"][self.sio_verbose], "iri"],
                                  ["rdfs:label", "#{role_label}", "xsd:string"],
                                ]
                               )    
  
  end
  
  

# creates the role_in_process portion of the CDE
#
# Parameters passed as a hash
#
# @param [:process_type] (URI) the URL for the ontological type of the process (defaults to http://semanticscience.org/resource/process)
# @param [:process_type_column] (string) the column header that contains the URL for the ontological type of the process - overrides process_type
# @param [:process_tag] (string) some single-word tag for that process; defaults to "thisprocess"
# @param [:process_label] (string) the label associated with the process type in that row (defaults to "thisprocess")
# @param [:process_label_column] (string) the column header for the label associated with the process type in that row
# @param [:process_start_column] (string) (optional) the column header for the timestamp when that process started
# @param [:process_end_column] (string)  (optional) the column header for the timestamp when that process ended
#  
  def role_in_process(params)
    @process_type = params.fetch(:process_type, SIO["process"][self.sio_verbose])  
    @process_type_column = params.fetch(:process_type_column, nil)  
    @process_tag  = params.fetch(:process_tag, 'thisprocess')  # some one-word name
    @process_label = params.fetch(:process_label, 'process') 
    @process_label_column = params.fetch(:process_label_column, nil) 
    @process_start_column = params.fetch(:process_start_column, nil) 
    @process_end_column = params.fetch(:process_end_column, nil) 

    process_type = self.process_type_column ? "$(#{self.process_type_column})":self.process_type
    process_label = self.process_label_column ? "$(#{self.process_label_column})":self.process_label


    @mappings << mapping_clause(
      "#{self.person_role_tag}_realized_#{self.process_tag}",
      ["#{self.source_tag}-source"],
      "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.person_role_tag}",
      [
            [SIO["is-realized-in"][self.sio_verbose], "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}","iri"]
      ]
      )
    
    @mappings << mapping_clause(
          "#{self.process_tag}_process_annotation",
          ["#{self.source_tag}-source"],
           "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}",
           [
             ["rdf:type",SIO["process"][self.sio_verbose], "iri"],
             ["rdf:type","#{process_type}", "iri"],
             ["rdfs:label","#{process_label}", "xsd:string"],
           ]
           )      
      
      
    if self.process_start_column
      @mappings << mapping_clause(
        "#{self.process_tag}_process_annotation_start",
          ["#{self.source_tag}-source"],
           "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}",
           [[SIO["start-time"][self.sio_verbose], "$(#{self.process_start_column})", "xsd:dateTime"]]
           )
    end
    
    if self.process_end_column
      @mappings << mapping_clause(
          "#{self.process_tag}_process_annotation_end",
          ["#{self.source_tag}-source"],
           "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}",
          [[SIO["end-time"][self.sio_verbose], "$(#{self.process_end_column})", "xsd:dateTime"]]
          )
    end
      
  end
  
  
# creates the process has input portion of the CDE
#
# Parameters passed as a hash
#
# @param [:process_with_input_tag] (string) (required) the same process tag that is used in the "role in process" for which this is the input
# @param [:input_is_output_of_process_tag] (string) defaults to 'unidentifiedProcess'; if the input is the output of another process, then specify the process tag here (matches the "role in process" which generates taht output
# @param [:input_type] (string) the ontological type for the input node (default http://semanticscience.org/resource/information-content-entity).  Ignored if using output from another process (specify it there!)
# @param [:input_type_tag] (string) a tag to differentiate this input from other inputs
# @param [:input_type_column] (string) the column header specifying the ontological type for the input node (overrides input_type).  Ignored if using output from another process (specify it there!)
# @param [:input_type_label] (string) the label for all inputs
# @param [:input_type_label_column] (string) the label column for each input
# @param [:input_has_value] (string) the value of the input
# @param [:input_has_value_column] (string) the column containing the value of the input
# @param [:input_has_value_datatype] (string) datatype of the value (default xsd:string)
# @param [:input_has_value_datatype_column] (string) the column containing the datatype of the value of the input )(overrides input_has_value_datatype)



  def process_has_input(params)
    @process_with_input_tag  = params.fetch(:process_with_input_tag, "thisprocess")  # some one-word name
    @input_is_output_of_process_tag  = params.fetch(:input_is_output_of_process_tag, 'unidentifiedProcess')  # some one-word name
    @input_type  = params.fetch(:input_type, SIO["information-content-entity"][self.sio_verbose])  # some one-word name
    @input_type_tag  = params.fetch(:input_type_tag, "thisInput")  # some one-word name
    @input_type_column  = params.fetch(:input_type_column, nil)  # some one-word name
    @input_type_label  = params.fetch(:input_type_label, "information content entity")  # some one-word name
    @input_type_label_column  = params.fetch(:input_type_label_column, nil)  # some one-word name
    @input_has_value  = params.fetch(:input_has_value, nil)  # some one-word name
    @input_has_value_column  = params.fetch(:input_has_value_column, nil)  # some one-word name
    @input_has_value_datatype  = params.fetch(:input_has_value_datatype, "xsd:string")  # some one-word name
    @input_has_value_datatype_column  = params.fetch(:input_has_value_datatype_column, nil)  # some one-word name
    
    
    abort "must specify the process_with_input_tag (the identifier of the process that receives the input) before you can use the process_has_input function" unless self.process_with_input_tag

    input_type = self.input_type_column ? "$(#{self.input_type_column})":self.input_type
    input_label = self.input_type_label_column ? "$(#{self.input_type_label_column})":self.input_type_label
    input_value = self.input_has_value_column ? "$(#{self.input_has_value_column})":self.input_has_value
    input_value_datatype = self.input_has_value_datatype_column ? "$(#{self.input_has_value_datatype_column})":self.input_has_value_datatype

    @mappings << mapping_clause(
        "#{self.process_with_input_tag}_has_input_#{self.input_type_tag}",
        ["#{self.source_tag}-source"],
        "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_with_input_tag}",
        [[SIO["has-input"][self.sio_verbose],"this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.input_is_output_of_process_tag}_Output", "iri"]]
        )
    
    @mappings << mapping_clause(
        "#{self.process_with_input_tag}_has_input_#{self.input_type_tag}_annotation",
        ["#{self.source_tag}-source"],
        "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.input_is_output_of_process_tag}_Output",
        [
          ["rdf:type",SIO["information-content-entity"][self.sio_verbose], "iri"],
          ["rdf:type","#{input_type}", "iri"],
          ["rdfs:label","#{input_label}", "xsd:string"],
          ]
        )
    

    if input_value

      @mappings << mapping_clause(
      "input_#{self.input_type_tag}_has_value",
      ["#{self.source_tag}-source"],
      "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.input_is_output_of_process_tag}_Output",
      [[SIO["has-value"][self.sio_verbose],"#{input_value}", "#{input_value_datatype}"]]
      )
    end

      # TODO:   need to allow units here too!  ...one day...
  end
  

# creates the process_hasoutput_output portion of the CDE
#
# Parameters passed as a hash

# @param [:process_with_output_tag] (string) (required) the same process tag that is used in the "role in process" for which this is the output
# @param [:output_value] (string)  (optional) the default value of that output (defaults to nil, and the output node is not created in the RDF)
# @param [:output_value_column] (string)  (optional) the column header for the value of that output (e.g. the column that contains "80"  for "80 mmHg")
# @param [:output_type] (URL) the URL associated with the output ontological type (defaults to http://semanticscience.org/resource/realizable-entity)
# @param [:output_type_column] (string) the column header for the URL associated with the output ontological type (overrides output_type)
# @param [:output_type_label] (string) (optional) the the label of that ontological type (defaults to "measurement-value")
# @param [:output_type_label_column] (string) (optional) the column header for the label of that ontological type (overrides output_type_label)
# @param [:output_value_datatype] (xsd:type)  (optional) the xsd:type for that kind of measurement (defaults to xsd:string)
# @param [:output_value_datatype_column] (string)  (optional) the column header for the xsd:type for that kind of measurement (overrides output_value_datatype)
# @param [:output_comments_column] (string)  (optional) the column header for amy textual comments.  text must not contain a comma!!  defaults to nil
# @param [:output_start_column] (xsd:datetime)  (optional) the column header for start date
# @param [:output_end_column] (xsd:datetime)  (optional) the column header for end date
## TODO # @param [:output_annotations] ([[URI, value, datatype],...])  (optional) annotations such as ["sio:start-date", "01-01-2021", "xsd:date"],["sio:end-date", "02-01-2021", "xsd:date"]
## TODO # @param [:output_annotations_columns] ([[URIcolumn, valuecolumn, datatype],...)  (optional) the column header for amy textual comments.  text must not contain a comma!!  defaults to nil
#  

  def process_hasoutput_output(params)
    @process_with_output_tag = params.fetch(:process_with_output_tag, "thisprocess")  # some one-word name
    @output_value = params.fetch(:output_value, nil)
    @output_value_column = params.fetch(:output_value_column, nil)
    @output_type = params.fetch(:output_type, SIO["realizable-entity"][self.sio_verbose])
    @output_type_column = params.fetch(:output_type_column, nil)
    @output_type_label = params.fetch(:output_type_label, "measurement-value")
    @output_type_label_column = params.fetch(:output_type_label_column, nil)
    @output_value_datatype = params.fetch(:output_value_datatype, "xsd:string")
    @output_value_datatype_column = params.fetch(:output_value_datatype_column, nil)
    @output_comments_column = params.fetch(:output_comments_column, nil)
    @output_start_column = params.fetch(:output_start_column, nil)
    @output_end_column = params.fetch(:output_end_column, nil)

    output_value = self.output_value_column ? "$(#{self.output_value_column})":self.output_value
    output_type = self.output_type_column ? "$(#{self.output_type_column})":self.output_type
    output_type_label = self.output_type_label_column ? "$(#{self.output_type_label_column})":self.output_type_label
    output_value_datatype = self.output_value_datatype_column ? "$(#{self.output_value_datatype_column})":self.output_value_datatype

   #return unless output_value
   
    @mappings << mapping_clause(
        "#{self.process_with_output_tag}_process_has_output",
        ["#{self.source_tag}-source"],
        "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}",
        [[SIO["has-output"][self.sio_verbose], "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_with_output_tag}_Output", "iri"]]
        )
    @mappings << mapping_clause(
        "#{self.process_tag}_Output_annotation",
        ["#{self.source_tag}-source"],
        "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_with_output_tag}_Output",
        [["rdf:type",SIO["information-content-entity"][self.sio_verbose], "iri"]]
        )      
    
    if output_type
          @mappings << mapping_clause(
              "#{self.process_with_output_tag}_Output_type_annotation",
              ["#{self.source_tag}-source"],
              "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_with_output_tag}_Output",
              [["rdf:type",output_type, "iri"]]
              )
    end
    
    if output_type_label
          @mappings << mapping_clause(
              "#{self.process_with_output_tag}_Output_type_label_annotation",
              ["#{self.source_tag}-source"],
              "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_with_output_tag}_Output",
              [["rdfs:label",output_type_label, "xsd:string"]]
              )
    end
    
    if output_value
          @mappings << mapping_clause(
              "#{self.process_with_output_tag}_Output_value_annotation",
              ["#{self.source_tag}-source"],
              "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_with_output_tag}_Output",
              [[SIO["has-value"][self.sio_verbose],output_value, output_value_datatype]]
              )
    end
    
    if self.output_comments_column
          @mappings << mapping_clause(
              "#{self.process_with_output_tag}_Output_value_comments",
              ["#{self.source_tag}-source"],
              "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_with_output_tag}_Output",
              [["rdfs:comment","$(#{self.output_comments_column})", "xsd:string"]]
              )
    end
    
    
    if self.output_start_column
      @mappings << mapping_clause(
        "#{self.process_with_output_tag}_output_annotation_start",
          ["#{self.source_tag}-source"],
           "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_with_output_tag}_Output",
           [[SIO["start-time"][self.sio_verbose], "$(#{self.output_start_column})", "xsd:dateTime"]]
           )
    end
    
    if self.output_end_column
      @mappings << mapping_clause(
          "#{self.process_with_output_tag}_process_annotation_end",
          ["#{self.source_tag}-source"],
           "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_with_output_tag}_Output",
          [[SIO["end-time"][self.sio_verbose], "$(#{self.output_end_column})", "xsd:dateTime"]]
          )
    end

  end

# creates the input output refers to portion of the CDE
#
# Parameters passed as a hash
#

   
    #@inout_process_tag = params.fetch(:in_out_process_tag, 'unidentifiedProcess')  # always output of some process
    #@inout_refers_to = params.fetch(:inout_refers_to, [])  #list of ontology terms
    #@inout_refers_to_columns = params.fetch(:inout_refers_to_columns, [])  # list of column headers
    #@inout_refers_to_label = params.fetch(:inout_refers_to_label, [] )  # some one-word name
    #@inout_refers_to_label_columns = params.fetch(:inout_refers_to_label_columns, [] )  # some one-word name

  def input_output_refers_to(params)
    @inout_process_tag = params.fetch(:inout_process_tag, 'unidentifiedProcess')
    @inout_refers_to = params.fetch(:inout_refers_to, [])  #list of ontology terms
    @inout_refers_to_label = params.fetch(:inout_refers_to_label, [] )  # some one-word name
    @inout_refers_to_columns = params.fetch(:inout_refers_to_columns, [])  # list of column headers
    @inout_refers_to_label_columns = params.fetch(:inout_refers_to_label_columns, [] )  # some one-word name
    
    #abort "must specify input_or_output as 'input' or 'output'" unless ["input", "output"].include? self.input_or_output.downcase
    #inout = self.input_or_output.capitalize
    abort "must specify in_out_process_tag" unless self.inout_process_tag
    
    if !(self.inout_refers_to_columns.empty?)
      $stderr.puts "checking inout columns"
          references = []
          types = []
          labels = Hash.new
          
          position = 0
          self.inout_refers_to_columns.each do |e|
            references << [SIO["refers-to"][self.sio_verbose], "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{e}_TypedAttributeNode", "iri"]
            types << ["rdf:type", "$(#{e})", "iri"]
            labels[e] << ["rdfs:label", self.inout_refers_to_label_columns[position] ] if !(self.inout_refers_to_label_columns.empty?)
            position += 1
          end   

          @mappings << mapping_clause(
              "inout_from_#{self.inout_process_tag}_refers_to_concepts",
              ["#{self.source_tag}-source"],
              "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.inout_process_tag}_Output",
              
              references
                
          )

          position = 0
          self.inout_refers_to_columns.each do |e|
            @mappings << mapping_clause(
                "inout_from_#{self.inout_process_tag}_refers_to_concept_#{e}_type",
                ["#{self.source_tag}-source"],
                "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{e}_TypedAttributeNode",
                [
                  types[position]
                ]
            )
            if labels[e]
              @mappings << mapping_clause(
                "inout_from_#{self.inout_process_tag}_refers_to_concept_#{e}_label",
                  ["#{self.source_tag}-source"],
                  "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{e}_TypedAttributeNode",
                  [
                    labels[e]
                  ]
                )
            end
            position += 1
            
          end

    elsif !(self.inout_refers_to.empty?)
          references = []
          types = []
          labels = Hash.new
          position = 0
          self.inout_refers_to.each do |e|
            uniqtype = Digest::SHA2.hexdigest e
            references << [SIO["refers-to"][self.sio_verbose], "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{uniqtype}_TypedAttributeNode", "iri"]
            types << ["rdf:type", "#{e}", "iri"]
            labels[e] << ["rdfs:label", self.inout_refers_to_label[position] ] if !(self.inout_refers_to_label.empty?)
            position += 1
          end   

          @mappings << mapping_clause(
            "inout_from_#{self.inout_process_tag}_refers_to_concepts",
            ["#{self.source_tag}-source"],
            "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{uniqtype}_TypedAttributeNode",
            
            references
            
          ) 
          
          position = 0
          self.input_refers_to.each do |e|
            uniqtype = Digest::SHA2.hexdigest e
            @mappings << mapping_clause(
              "inout_from_#{self.inout_process_tag}_refers_to_concept_#{uniqtype}_type",
              ["#{self.source_tag}-source"],
              "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{uniqtype}_TypedAttributeNode",
              [
                types[position]
              ]
              )
            if labels[e]
              @mappings << mapping_clause(
                "inout_from_#{self.inout_process_tag}_refers_to_concept_#{uniqtype}_label",
                ["#{self.source_tag}-source"],
                "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{uniqtype}_TypedAttributeNode",
                [
                 labels[e]
                ]
              )
            end
            position += 1
          end
 
    end
    
  end
  
## creates the process informed by process portion of the CDE
##
## Parameters passed as a hash
##
## @param [:input_process_tag] (string) (required) some single-word tag for that process that led to the output that will be the input to the primary process
## @param [:primary_process_tag] (string) (required) some single-word tag for that process that receives the output 
## @param [:input_type] (string) the ontological type fo the input (default "http://semanticscience.org/resource/input")
## @param [:input_type_column] (string) the column header for the ontological type column regarding the input
## @param [:input_type_label] (string) the label associated with the process type in that row (default 'input')
## @param [:input_type_label_column] (string) the column header for the label associated with the process type in that row
#
#  def input_refers_to(params)
#    @input_process_tag  = params.fetch(:input_process_tag, nil)  # some one-word name
#    @input_type  = params.fetch(:input_type, "http://semanticscience.org/resource/input")  # some one-word name
#    @input_type_column  = params.fetch(:input_type_column, nil)  # some one-word name
#    @input_type_label  = params.fetch(:input_type_label, "input")  # some one-word name
#    @input_type_label_column  = params.fetch(:input_type_label_column, nil)  # some one-word name
#    
#
#    abort "must have an input process tag before you can use the process_has_input function" unless self.input_process_tag
#
#    @mappings << mapping_clause(
#        "#{self.process_tag}_Output_type_annotation",
#        ["#{self.source_tag}-source"],
#        "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.primary_process_tag}",
#        [[SIO["has-input"][self.sio_verbose],"this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.input_process_tag}_Output", "iri"]]
#        )
#      
#  end
#  






# creates the person_has_attribute portion of the CDE
#
# Parameters passed as a hash.  Generally speaking, you will use the same column header(s) as you used for the
# "inout refers to" to join this attribute with the output node that measures it.
# i.e. attribute_type[_column] and their label equivalents will be the same as
# inout_refers_to[_column] and their label equivalents but can only be one!  (for now)
#
# @param [:attribute_from_process_tag] (string) all attributes are referred-to by the output of some measuring process process.  that process tag belongs here. default "unidentifiedProcess'
# @param [:attribute_type] (URL) the URL for the ontological type of the attribute (defaults to http://semanticscience.org/resource/attribute)
# @param [:attribute_type_column] (string) the column header that contains the URL for the ontological type of the quality (overrides attribute_type)
# @param [:attribute_tag] (string) some single-word tag for that process; defaults to "someQuality"
# @param [:attribute_label] (string) the the label associated with the quality type in that row (defaults to 'quality')
# @param [:attribute_label_column] (string) the column header for the label associated with the attribute type in that row (overrides attribute_label)
#

    #@input_or_output = params.fetch(:input_or_output, nil)
    #@inout_process_tag = params.fetch(:in_out_process_tag, nil)
    #@inout_refers_to = params.fetch(:inout_refers_to, [])  #list of ontology terms
    #@inout_refers_to_columns = params.fetch(:inout_refers_to_columns, [])  # list of column headers
    #@inout_refers_to_label = params.fetch(:inout_refers_to_label, [] )  # some one-word name
    #@inout_refers_to_label_columns = params.fetch(:inout_refers_to_label_columns, [] )  # some one-word name

  def person_has_attribute(params)
#    @attribute_from_process_tag = params.fetch(:attribute_from_process_tag, 'unidentifiedProcess')
    @attribute_type = params.fetch(:attribute_type, SIO["attribute"][self.sio_verbose])  
    @attribute_type_column = params.fetch(:attribute_type_column, nil)  
    @attribute_tag  = params.fetch(:attribute_tag, "someAttribute")  # some one-word name
    @attribute_label = params.fetch(:attribute_label, "attribute") 
    @attribute_label_column = params.fetch(:attribute_label_column, nil)
    
    attribute_type = self.attribute_type_column ? "$(#{self.attribute_type_column})":self.attribute_type
    attribute_label = self.attribute_label_column ? "$(#{self.attribute_label_column})":self.attribute_label

            # FROm INOUT-refers-to section above
            #uniqtype = Digest::SHA2.hexdigest e
            #"this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})#$(#{uniqtype})_TypedAttributeNode", "iri"]
            #
            #"this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})#$(#{e})_TypedAttributeNode", "iri"]
    uniqtype = ""  # here we are not dealing with lists, as we did last time, so we dont' generate this in a loop
    if self.attribute_type_column
      uniqtype = self.attribute_type_column
    else
      uniqtype = Digest::SHA2.hexdigest self.attribute_type
    end
    @mappings << mapping_clause(
        "person_has_#{self.attribute_tag}_attribute",
        ["#{self.source_tag}-source"],
        "this:individual_$(#{self.personid_column})#Person",
        [[SIO["has-attribute"][self.sio_verbose],"this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{uniqtype}_TypedAttributeNode","iri"]]
        )

    @mappings << mapping_clause(
      "#{self.attribute_tag}_attribute_annotation",
        ["#{self.source_tag}-source"],
        "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{uniqtype}_TypedAttributeNode",
        [
          ["rdf:type", SIO["attribute"][self.sio_verbose], "iri"],
          ["rdf:type", "#{attribute_type}", "iri"],
          ["rdfs:label","#{attribute_label}", "xsd:string"]
        ]
        )
    
  end
  



  


# creates the output_has_unit portion of the CDE
#
# Parameters passed as a hash
#
# @param [:output_unit] (URL) the ontological type of that unit (default nil)
# @param [:output_unit_column] (string) column containing the ontological type of that unit (overrides output_unit)
# @param [:output_unit_label] (string) the string label for that unit (e.g. "centimeters" for the ontological type "cm" ) (default nil)
# @param [:output_unit_label_column] (string) column header containing the string label for that unit (e.g. "centimeters" for the ontological type "cm" )
  
  def output_has_unit(params)

    @output_unit = params.fetch(:output_unit_column, nil)  # URI
    @output_unit_column = params.fetch(:output_unit_column, nil)  # URI
    @output_unit_label = params.fetch(:output_unit_label, nil)
    @output_unit_label_column = params.fetch(:output_unit_label_column, nil)
    
    output_unit = self.output_unit_column ? "$(#{self.output_unit_column})":self.output_unit
    output_unit_label = self.output_unit_label_column ? "$(#{self.output_unit_label_column})":self.output_unit_label

    if output_unit
      @mappings << mapping_clause(
              "#{self.process_tag}_Output_hasunit_unit",
                ["#{self.source_tag}-source"],
                "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output",
                [[SIO["has-unit"][self.sio_verbose], "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output_unit", "iri"]]
                )

      @mappings << mapping_clause(
              "#{self.process_tag}_Output_hasunit_unit",
                ["#{self.source_tag}-source"],
                "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output",
                [[SIO["has-unit"][self.sio_verbose], "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output_unit", "iri"]]
                )
      @mappings << mapping_clause(
              "#{self.process_tag}_Output_unit_annotation",
              ["#{self.source_tag}-source"],
              "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output_unit",
              [["rdf:type",output_unit, "iri"]]
              )

    end

    if output_unit_label
    
      @mappings << mapping_clause(
              "#{self.process_tag}_Output_unit_annotation",
              ["#{self.source_tag}-source"],
              "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output_unit",
              [["rdfs:label",output_unit_label,"xsd:string"]
              ]
              )
    end
    

  end
  


# creates the measurement_refers-to_attribute portion of the CDE
#
# Parameters passed as a hash
#
# NOTE!! You must have already used the person_has_attribute(params) and role_in_process(params) methods for this call to succeed!
#
# no parameters
#  
  #
  #def measurement_refers_to_attribute(params)
  #  abort "must have already defined a (optional) attribute before calling this routine" unless self.quality_tag
  #  
  #  @mappings << mapping_clause(
  #      "measurement_refers_to_attribute_#{self.attribute_tag}",
  #      ["#{self.source_tag}-source"],
  #      "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output",
  #      [[SIO["refers-to"][self.sio_verbose], "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.quality_tag}", "iri"]]
  #      )
  #end
  




# creates the output_refersto portion of the CDE
#
# Parameters passed as a hash
#
# @param [:output_ontology_type] (URL) the ontological type of that output (default nil)
# @param [:output_ontology_type_column (string) column containing the ontological type of that output (overrides output_ontology_type)
# @param [:output_ontology_label] (string) the string label for that unit (e.g. "duchenne muscular dystrophy")
# @param [:output_ontology_label_column] (string) column header containing the string label for that type

# TODO - need to specify the process tag, to align outputs with processes
  
  #def output_refers_to(params)
  #
  #  @output_ontology_type = params.fetch(:output_ontology_type, nil)  # URI
  #  @output_ontology_type_column = params.fetch(:output_ontology_type_column, nil)  # URI
  #  @output_ontology_label = params.fetch(:output_ontology_label, nil)
  #  @output_ontology_label_column = params.fetch(:output_ontology_label_column, nil)
  #  
  #  output_term = self.output_ontology_type_column ? "$(#{self.output_ontology_type_column})":self.output_ontology_type
  #  output_term_label = self.output_ontology_label_column ? "$(#{self.output_ontology_label_column})":self.output_ontology_label
  #
  #  if output_term 
  #    @mappings << mapping_clause(
  #            "#{self.process_tag}_Output_refersto_typed_thing",
  #              ["#{self.source_tag}-source"],
  #              "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output",
  #              [[SIO["refers-to"][self.sio_verbose], "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output_typednode", "iri"]]
  #              )
  #
  #    @mappings << mapping_clause(
  #            "#{self.process_tag}_Output_typedthing_type",
  #              ["#{self.source_tag}-source"],
  #              "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output_typednode",
  #              [["rdf:type", "#{output_term}", "iri"]]
  #              )
  #
  #  end
  #
  #  if output_term_label
  #  
  #    @mappings << mapping_clause(
  #            "#{self.process_tag}_Output_typenode_annotation",
  #            ["#{self.source_tag}-source"],
  #            "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output_typednode",
  #            [["rdfs:label","#{output_term_label}","xsd:string"]
  #            ]
  #            )
  #  end
  #  
  #
  #end



end
