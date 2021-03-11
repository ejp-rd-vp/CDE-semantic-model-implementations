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




# all params are passed as a hash, and retrieved by params.fetch(paramName)
#
# @param params [Hash]  params   a Hash of options
# @option params [String] :baseURI a URL that will become the base for "urls owned by the data provider" e.g. "http://my.dataset.org/thisdataset/records/"
# @option params [String] :source_name   a "short name" (i.e. a single word, no spaces) for the kind of data being transformed.  e.g. height_data
# @option params [Integer] :sio_verbose (0)  "1" means to use http://semanticscience.org/resource/has-value instead of http://semanticscience.org/resource/SIO_000300 for all sio.  Default is 0
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
# @param params [Hash] 
# @option params [Hash] :prefixesHash ({})  hash of shortname to URL prefix mappings
#
#   a hash of prefix [String] =>  URL prefix
#
#   e.g. {"mydata" => "http://my.dataset.org/thisdataset/records/"}
#
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
# @param name [String] a unique name for that YARRRRML component (e.g. thisRole_realized_in_SomeProcess)
# @param source [String] the YARRRML source identifier
# @param s [String] URI of the subject
# @param pots [Array] An array of arrays of [Predicate-object-datatype] (datatype is "iri" if it is a Node, rather than a literal)
#
# @return [String]  the mapping_clause in YAML format
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
# @param params [Hash]  a hash of options
# @option params :personid_column [String] (required) the column header that contains the anonymous identifier of the person; defaults to "pid"
# @option params :uniqueid_column [String] (required) the column header that contains unique ID for that row (over ALL datasets! e.g. a hash of a timestamp); defaults to "uniqid"
# @option params :identifier_type [String]  the URL of the ontological type of that identifier; defaults to  'https://ejp-rd.eu/vocab/identifier'
# @option params :identifier_type_column [String] the column header for the ontological type of that identifier.  Overrides identifier_type.
# @option params :person_type [String]  the URL of the ontological type defining a "person"; defaults to 'https://ejp-rd.eu/vocab/Person'
# @option params :person_type_column [String] the column header for the ontological type of the "individual".  Overrides person_type
# @option params :person_role_tag [String] a single-word label for the kind of role (e.g. "patient", "clinician") the person plays in this dataset; defaults to "thisRole"
# @option params :role_type [String] the URL for the ontological type of that role; defaults to "obo:OBI_0000093" ("patient")
# @option params :role_type_column [String] the column header that contains the ontological type of that role.  Overrides role_type
# @option params :role_label [String] the label for that kind of role; defaults to "Patient"
# @option params :role_label_column [String] the column header that has the label for that kind of role (overrides role_label)
#
  def person_identifier_role_mappings(params = {})
    personid_column = params.fetch(:personid_column, 'pid')
    uniqueid_column = params.fetch(:uniqueid_column, 'uniqid')
    
    identifier_type = params.fetch(:identifier_type,  SIO["identifier"][self.sio_verbose])
    identifier_type_column = params.fetch(:identifier_type_column, nil)
    person_type = params.fetch(:person_type, SIO["person"][self.sio_verbose])
    person_type_column = params.fetch(:person_type_column, nil)
    person_role_tag = params.fetch(:person_role_tag, 'thisRole')
    role_type = params.fetch(:role_type, 'obo:OBI_0000093')  # patient
    role_type_column = params.fetch(:role_type_column, nil)  # 
    role_label = params.fetch(:role_label, 'Patient')  # patient
    role_label_column = params.fetch(:role_label_column, nil)  # 

    identifier_type = identifier_type_column ? "$(#{identifier_type_column})":identifier_type
    person_type = person_type_column ? "$(#{person_type_column})":person_type
    role_type = role_type_column ? "$(#{role_type_column})":role_type
    role_label = role_label_column ? "$(#{role_label_column})":role_label

    abort "You MUST have a personid_column and a uniqueid_column to use this library.  Sorry!" unless personid_column and uniqueid_column
    @mappings << mapping_clause(
                             "identifier_has_value",
                             ["#{source_tag}-source"],
                             "this:individual_$(#{personid_column})_$(#{uniqueid_column})#ID",
                             [[SIO["has-value"][self.sio_verbose], "$(#{personid_column})", "xsd:string"]]
                             )

    @mappings << mapping_clause(
                                  "identifier_denotes",
                                  ["#{source_tag}-source"],
                                  "this:individual_$(#{personid_column})_$(#{uniqueid_column})#ID",
                                  [
                                   ["a", "#{identifier_type}", "iri"],
                                   ["a", SIO["identifier"][self.sio_verbose], "iri"],
                                   [SIO["denotes"][self.sio_verbose], "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{person_role_tag}", "iri"],
                                  ]
                                 )
    @mappings << mapping_clause(
                                "person_has_role",
                                ["#{source_tag}-source"],
                                "this:individual_$(#{personid_column})#Person",
                                [
                                 ["a", "#{person_type}", "iri"],
                                 ["a", SIO["person"][self.sio_verbose], "iri"],
                                 [SIO["has-role"][self.sio_verbose], "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{person_role_tag}", "iri"],
                                ]
                               )

    @mappings << mapping_clause(
                                "#{person_role_tag}_annotation",
                                ["#{source_tag}-source"],
                                "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{person_role_tag}",
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
# @param params [Hash]  a hash of options
# @option params :process_type  [String] the URL for the ontological type of the process (defaults to http://semanticscience.org/resource/process)
# @option params :process_type_column  [String] the column header that contains the URL for the ontological type of the process - overrides process_type
# @option params :process_tag  [String] some single-word tag for that process; defaults to "thisprocess"
# @option params :process_label  [String] the label associated with the process type in that row (defaults to "thisprocess")
# @option params :process_label_column  [String] the column header for the label associated with the process type in that row
# @option params :process_start_column  [String] (optional) the column header for the timestamp when that process started
# @option params :process_end_column  [String]  (optional) the column header for the timestamp when that process ended
  def role_in_process(params)
    process_type = params.fetch(:process_type, SIO["process"][self.sio_verbose])  
    process_type_column = params.fetch(:process_type_column, nil)  
    process_tag  = params.fetch(:process_tag, 'thisprocess')  # some one-word name
    process_label = params.fetch(:process_label, 'process') 
    process_label_column = params.fetch(:process_label_column, nil) 
    process_start_column = params.fetch(:process_start_column, nil) 
    process_end_column = params.fetch(:process_end_column, nil) 

    process_type = process_type_column ? "$(#{process_type_column})":process_type
    process_label = process_label_column ? "$(#{process_label_column})":process_label


    @mappings << mapping_clause(
      "#{person_role_tag}_realized_#{process_tag}",
      ["#{source_tag}-source"],
      "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{person_role_tag}",
      [
            [SIO["is-realized-in"][self.sio_verbose], "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_tag}","iri"]
      ]
      )
    
    @mappings << mapping_clause(
          "#{process_tag}_process_annotation",
          ["#{source_tag}-source"],
           "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_tag}",
           [
             ["rdf:type",SIO["process"][self.sio_verbose], "iri"],
             ["rdf:type","#{process_type}", "iri"],
             ["rdfs:label","#{process_label}", "xsd:string"],
           ]
           )      
      
      
    if process_start_column
      @mappings << mapping_clause(
        "#{process_tag}_process_annotation_start",
          ["#{source_tag}-source"],
           "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_tag}",
           [[SIO["start-time"][self.sio_verbose], "$(#{process_start_column})", "xsd:dateTime"]]
           )
    end
    
    if process_end_column
      @mappings << mapping_clause(
          "#{process_tag}_process_annotation_end",
          ["#{source_tag}-source"],
           "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_tag}",
          [[SIO["end-time"][self.sio_verbose], "$(#{process_end_column})", "xsd:dateTime"]]
          )
    end
      
  end
  
  
  
# creates the process has annotations portion of the CDE
#
# Parameters passed as a hash
#
# @param params [Hash]  a hash of options
# @option params :process_tag  [String] (required) the same process tag that is used in the "role in process" 
# @option params :process_annotations_columns [Array] ([[subcol,predcol,datatypecol], ...]) 
# @option params :process_annotations [Array] ([[sub,pred,datatype]...]) (required) the same process tag that is used in the "role in process" 
  def process_has_annotations(params)
    process_tag = params.fetch(:process_tag, "thisprocess")  
    process_annotations_columns = params.fetch(:process_annotations_columns, [])  
    process_annotations = params.fetch(:output_annotations, [])  


    if !process_annotations_columns.empty?
      process_annotations_columns.each do |predicate, value, datatype|
        datatype = "$(#{datatype})" if datatype # make it the column reference if it exists          
        datatype = "xsd:string" unless datatype  # otherwise make it default
        
        next unless predicate and value
        uniqid = get_uniq_id
        
        @mappings << mapping_clause(
            "#{uniqid}_process_custom_annotation",
            ["#{source_tag}-source"],
           "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_tag}",
            [["$(#{predicate})", "$(#{value})", datatype]]
            )
        
      end
    elsif !process_annotations.empty?
      process_annotations.each do |predicate, value, datatype|
        datatype = "xsd:string" unless datatype  # otherwise make it default
        
        next unless predicate and value
        uniqid = get_uniq_id
        
        @mappings << mapping_clause(
            "#{uniqid}_process_custom_annotation",
            ["#{source_tag}-source"],
           "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_tag}",
            [[predicate, value, datatype]]
            )
        
      end
      
    end

    
  end
  
# creates the process has input portion of the CDE
#
# Parameters passed as a hash
#
# @param params [Hash]  a hash of options
# @option params :process_with_input_tag  [String] (required) the same process tag that is used in the "role in process" for which this is the input
# @option params :input_is_output_of_process_tag  [String] defaults to 'unidentifiedProcess'; if the input is the output of another process, then specify the process tag here (matches the "role in process" which generates taht output
# @option params :input_type  [String] the ontological type for the input node (default http://semanticscience.org/resource/information-content-entity).  Ignored if using output from another process (specify it there!)
# @option params :input_type_tag  [String] a tag to differentiate this input from other inputs
# @option params :input_type_column  [String] the column header specifying the ontological type for the input node (overrides input_type).  Ignored if using output from another process (specify it there!)
# @option params :input_type_label  [String] the label for all inputs
# @option params :input_type_label_column  [String] the label column for each input
# @option params :input_has_value  [String] the value of the input
# @option params :input_has_value_column  [String] the column containing the value of the input
# @option params :input_has_value_datatype  [String] datatype of the value (default xsd:string)
# @option params :input_has_value_datatype_column  [String] the column containing the datatype of the value of the input )(overrides input_has_value_datatype)
  def process_has_input(params)
    process_with_input_tag  = params.fetch(:process_with_input_tag, "thisprocess")  # some one-word name
    input_is_output_of_process_tag  = params.fetch(:input_is_output_of_process_tag, 'unidentifiedProcess')  # some one-word name
    input_type  = params.fetch(:input_type, SIO["information-content-entity"][self.sio_verbose])  # some one-word name
    input_type_tag  = params.fetch(:input_type_tag, "thisInput")  # some one-word name
    input_type_column  = params.fetch(:input_type_column, nil)  # some one-word name
    input_type_label  = params.fetch(:input_type_label, "information content entity")  # some one-word name
    input_type_label_column  = params.fetch(:input_type_label_column, nil)  # some one-word name
    input_has_value  = params.fetch(:input_has_value, nil)  # some one-word name
    input_has_value_column  = params.fetch(:input_has_value_column, nil)  # some one-word name
    input_has_value_datatype  = params.fetch(:input_has_value_datatype, "xsd:string")  # some one-word name
    input_has_value_datatype_column  = params.fetch(:input_has_value_datatype_column, nil)  # some one-word name
    
    
    abort "must specify the process_with_input_tag (the identifier of the process that receives the input) before you can use the process_has_input function" unless process_with_input_tag

    input_type = input_type_column ? "$(#{input_type_column})":input_type
    input_label = input_type_label_column ? "$(#{input_type_label_column})":input_type_label
    input_value = input_has_value_column ? "$(#{input_has_value_column})":input_has_value
    input_value_datatype = input_has_value_datatype_column ? "$(#{input_has_value_datatype_column})":input_has_value_datatype

    @mappings << mapping_clause(
        "#{process_with_input_tag}_has_input_#{input_type_tag}",
        ["#{source_tag}-source"],
        "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_with_input_tag}",
        [[SIO["has-input"][self.sio_verbose],"this:individual_$(#{personid_column})_$(#{uniqueid_column})##{input_is_output_of_process_tag}_Output", "iri"]]
        )
    
    @mappings << mapping_clause(
        "#{process_with_input_tag}_has_input_#{input_type_tag}_annotation",
        ["#{source_tag}-source"],
        "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{input_is_output_of_process_tag}_Output",
        [
          ["rdf:type",SIO["information-content-entity"][self.sio_verbose], "iri"],
          ["rdf:type","#{input_type}", "iri"],
          ["rdfs:label","#{input_label}", "xsd:string"],
          ]
        )
    

    if input_value

      @mappings << mapping_clause(
      "input_#{input_type_tag}_has_value",
      ["#{source_tag}-source"],
      "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{input_is_output_of_process_tag}_Output",
      [[SIO["has-value"][self.sio_verbose],"#{input_value}", "#{input_value_datatype}"]]
      )
    end

      # TODO:   need to allow units here too!  ...one day...
  end
  

# creates the process_hasoutput_output portion of the CDE
#
# Parameters passed as a hash
#
# @param params [Hash]  a hash of options
# @option params :process_with_output_tag  [String] Required - the same process tag that is used in the "role in process" for which this is the output
# @option params :output_value  [String]  the default value of that output (defaults to nil, and the output node is not created in the RDF)
# @option params :output_value_column  [String]   the column header for the value of that output (e.g. the column that contains "80"  for "80 mmHg")
# @option params :output_type  [String]  the URL associated with the output ontological type (defaults to http://semanticscience.org/resource/realizable-entity)
# @option params :output_type_column  [String] the column header for the URL associated with the output ontological type (overrides output_type)
# @option params :output_type_label  [String] the the label of that ontological type (defaults to "measurement-value")
# @option params :output_type_label_column  [String] the column header for the label of that ontological type (overrides output_type_label)
# @option params :output_value_datatype  [xsd:type]  the xsd:type for that kind of measurement (defaults to xsd:string)
# @option params :output_value_datatype_column  [String]  the column header for the xsd:type for that kind of measurement (overrides output_value_datatype)
# @option params :output_comments_column  [String]  the column header for amy textual comments.  text must not contain a comma!!  defaults to nil
# @option params :output_start_column  [xsd:datetime] the column header for start date
# @option params :output_end_column  [xsd:datetime]   the column header for end date

  def process_hasoutput_output(params)
    process_with_output_tag = params.fetch(:process_with_output_tag, "thisprocess")  # some one-word name
    output_value = params.fetch(:output_value, nil)
    output_value_column = params.fetch(:output_value_column, nil)
    output_type = params.fetch(:output_type, SIO["realizable-entity"][self.sio_verbose])
    output_type_column = params.fetch(:output_type_column, nil)
    output_type_label = params.fetch(:output_type_label, "measurement-value")
    output_type_label_column = params.fetch(:output_type_label_column, nil)
    output_value_datatype = params.fetch(:output_value_datatype, "xsd:string")
    output_value_datatype_column = params.fetch(:output_value_datatype_column, nil)
    output_comments_column = params.fetch(:output_comments_column, nil)
    output_start_column = params.fetch(:output_start_column, nil)
    output_end_column = params.fetch(:output_end_column, nil)
    output_annotations = params.fetch(:output_annotations, [])
    output_annotations_columns = params.fetch(:output_annotations_columns, [])

    output_value = output_value_column ? "$(#{output_value_column})":output_value
    output_type = output_type_column ? "$(#{output_type_column})":output_type
    output_type_label = output_type_label_column ? "$(#{output_type_label_column})":output_type_label
    output_value_datatype = output_value_datatype_column ? "$(#{output_value_datatype_column})":output_value_datatype
   

   #return unless output_value
   
    @mappings << mapping_clause(
        "#{process_with_output_tag}_process_has_output",
        ["#{source_tag}-source"],
        "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_tag}",
        [[SIO["has-output"][self.sio_verbose], "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_with_output_tag}_Output", "iri"]]
        )
    @mappings << mapping_clause(
        "#{process_tag}_Output_annotation",
        ["#{source_tag}-source"],
        "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_with_output_tag}_Output",
        [["rdf:type",SIO["information-content-entity"][self.sio_verbose], "iri"]]
        )      
    
    if output_type
          @mappings << mapping_clause(
              "#{process_with_output_tag}_Output_type_annotation",
              ["#{source_tag}-source"],
              "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_with_output_tag}_Output",
              [["rdf:type",output_type, "iri"]]
              )
    end
    
    if output_type_label
          @mappings << mapping_clause(
              "#{process_with_output_tag}_Output_type_label_annotation",
              ["#{source_tag}-source"],
              "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_with_output_tag}_Output",
              [["rdfs:label",output_type_label, "xsd:string"]]
              )
    end
    
    if output_value
          @mappings << mapping_clause(
              "#{process_with_output_tag}_Output_value_annotation",
              ["#{source_tag}-source"],
              "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_with_output_tag}_Output",
              [[SIO["has-value"][self.sio_verbose],output_value, output_value_datatype]]
              )
    end
    
    if output_comments_column
          @mappings << mapping_clause(
              "#{process_with_output_tag}_Output_value_comments",
              ["#{source_tag}-source"],
              "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_with_output_tag}_Output",
              [["rdfs:comment","$(#{output_comments_column})", "xsd:string"]]
              )
    end
    
    
    if output_start_column
      @mappings << mapping_clause(
        "#{process_with_output_tag}_output_annotation_start",
          ["#{source_tag}-source"],
           "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_with_output_tag}_Output",
           [[SIO["start-time"][self.sio_verbose], "$(#{output_start_column})", "xsd:dateTime"]]
           )
    end
    
    if output_end_column
      @mappings << mapping_clause(
          "#{process_with_output_tag}_output_annotation_end",
          ["#{source_tag}-source"],
           "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_with_output_tag}_Output",
          [[SIO["end-time"][self.sio_verbose], "$(#{output_end_column})", "xsd:dateTime"]]
          )
    end
    
    if !output_annotations_columns.empty?
        output_annotations_columns.each do |predicate, value, datatype|
          datatype = "$(#{datatype})" if datatype # make it the column reference if it exists          
          datatype = "xsd:string" unless datatype  # otherwise make it default
          
          next unless predicate and value
          uniqid = get_uniq_id
          
          @mappings << mapping_clause(
              "#{uniqid}_output_custom_annotation",
              ["#{source_tag}-source"],
               "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_with_output_tag}_Output",
              [["$(#{predicate})", "$(#{value})", datatype]]
              )
          
        end
    elsif !output_annotations.empty?
        output_annotations.each do |predicate, value, datatype|
          datatype = "xsd:string" unless datatype  # otherwise make it default
          
          next unless predicate and value
          uniqid = get_uniq_id
          
          @mappings << mapping_clause(
              "#{uniqid}_output_custom_annotation",
              ["#{source_tag}-source"],
               "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_with_output_tag}_Output",
              [[predicate, value, datatype]]
              )
          
        end
      
    end

  end


# creates the input output refers to portion of the CDE
#
# Parameters passed as a hash
#
#@param params [Hash]  a hash of options
#@option params  :inout_process_tag [String]  ("unidentifiedProcess")
#@option params  :inout_refers_to [Array]  ([])
#@option params  :inout_refers_to_columns [Array] ([])
#@option params  :inout_refers_to_label  [Array]  ([])
#@option params  :inout_refers_to_label_columns  [Array]  ([])

  def input_output_refers_to(params)
    inout_process_tag = params.fetch(:inout_process_tag, 'unidentifiedProcess')
    inout_refers_to = params.fetch(:inout_refers_to, [])  
    inout_refers_to_label = params.fetch(:inout_refers_to_label, [] ) 
    inout_refers_to_columns = params.fetch(:inout_refers_to_columns, [])  
    inout_refers_to_label_columns = params.fetch(:inout_refers_to_label_columns, [] ) 
    
    abort "must specify in_out_process_tag" unless inout_process_tag
    
    if !(inout_refers_to_columns.empty?)
      $stderr.puts "checking inout columns"
          references = []
          types = []
          labels = Hash.new
          
          position = 0
          inout_refers_to_columns.each do |e|
            references << [SIO["refers-to"][self.sio_verbose], "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{e}_TypedAttributeNode", "iri"]
            types << ["rdf:type", "$(#{e})", "iri"]
            labels[e] << ["rdfs:label", inout_refers_to_label_columns[position] ] if !(inout_refers_to_label_columns.empty?)
            position += 1
          end   

          @mappings << mapping_clause(
              "inout_from_#{inout_process_tag}_refers_to_concepts",
              ["#{source_tag}-source"],
              "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{inout_process_tag}_Output",
              
              references
                
          )

          position = 0
          inout_refers_to_columns.each do |e|
            @mappings << mapping_clause(
                "inout_from_#{inout_process_tag}_refers_to_concept_#{e}_type",
                ["#{source_tag}-source"],
                "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{e}_TypedAttributeNode",
                [
                  types[position]
                ]
            )
            if labels[e]
              @mappings << mapping_clause(
                "inout_from_#{inout_process_tag}_refers_to_concept_#{e}_label",
                  ["#{source_tag}-source"],
                  "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{e}_TypedAttributeNode",
                  [
                    labels[e]
                  ]
                )
            end
            position += 1
            
          end

    elsif !(inout_refers_to.empty?)
          references = []
          types = []
          labels = Hash.new
          position = 0
          inout_refers_to.each do |e|
            uniqtype = Digest::SHA2.hexdigest e
            references << [SIO["refers-to"][self.sio_verbose], "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{uniqtype}_TypedAttributeNode", "iri"]
            types << ["rdf:type", "#{e}", "iri"]
            labels[e] << ["rdfs:label", inout_refers_to_label[position] ] if !(inout_refers_to_label.empty?)
            position += 1
          end   

          @mappings << mapping_clause(
            "inout_from_#{inout_process_tag}_refers_to_concepts",
            ["#{source_tag}-source"],
            "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{uniqtype}_TypedAttributeNode",
            
            references
            
          ) 
          
          position = 0
          input_refers_to.each do |e|
            uniqtype = Digest::SHA2.hexdigest e
            @mappings << mapping_clause(
              "inout_from_#{inout_process_tag}_refers_to_concept_#{uniqtype}_type",
              ["#{source_tag}-source"],
              "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{uniqtype}_TypedAttributeNode",
              [
                types[position]
              ]
              )
            if labels[e]
              @mappings << mapping_clause(
                "inout_from_#{inout_process_tag}_refers_to_concept_#{uniqtype}_label",
                ["#{source_tag}-source"],
                "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{uniqtype}_TypedAttributeNode",
                [
                 labels[e]
                ]
              )
            end
            position += 1
          end
 
    end
    
  end
  





# creates the person_has_attribute portion of the CDE
#
# Parameters passed as a hash.  Generally speaking, you will use the same column header(s) as you used for the
# "inout refers to" to join this attribute with the output node that measures it.
#
# i.e. attribute_type[_column] and their label equivalents will be the same as inout_refers_to[_column] and their label equivalents but can only be one!  (for now)
#
# @option params  params [Hash]  a hash of options
# @option params  :attribute_type [URL] the URL for the ontological type of the attribute (defaults to http://semanticscience.org/resource/attribute)
# @option params  :attribute_type_column [String] the column header that contains the URL for the ontological type of the quality (overrides attribute_type)
# @option params  :attribute_tag [String] some single-word tag for that process; defaults to "someQuality"
# @option params  :attribute_label [string] the the label associated with the quality type in that row (defaults to 'quality')
# @option params  :attribute_label_column [String] the column header for the label associated with the attribute type in that row (overrides attribute_label)
#

  def person_has_attribute(params)
    attribute_type = params.fetch(:attribute_type, SIO["attribute"][self.sio_verbose])  
    attribute_type_column = params.fetch(:attribute_type_column, nil)  
    attribute_tag  = params.fetch(:attribute_tag, "someAttribute")  # some one-word name
    attribute_label = params.fetch(:attribute_label, "attribute") 
    attribute_label_column = params.fetch(:attribute_label_column, nil)
    
    attribute_type = attribute_type_column ? "$(#{attribute_type_column})":attribute_type
    attribute_label = attribute_label_column ? "$(#{attribute_label_column})":attribute_label

    uniqtype = ""  # here we are not dealing with lists, as we did last time, so we dont' generate this in a loop
    if attribute_type_column
      uniqtype = attribute_type_column
    else
      uniqtype = Digest::SHA2.hexdigest attribute_type
    end
    @mappings << mapping_clause(
        "person_has_#{attribute_tag}_attribute",
        ["#{source_tag}-source"],
        "this:individual_$(#{personid_column})#Person",
        [[SIO["has-attribute"][self.sio_verbose],"this:individual_$(#{personid_column})_$(#{uniqueid_column})##{uniqtype}_TypedAttributeNode","iri"]]
        )

    @mappings << mapping_clause(
      "#{attribute_tag}_attribute_annotation",
        ["#{source_tag}-source"],
        "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{uniqtype}_TypedAttributeNode",
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
# @option params  :output_unit [URL] the ontological type of that unit (default nil)
# @option params  :output_unit_column [String]column containing the ontological type of that unit (overrides output_unit)
# @option params  :output_unit_label [string] the string label for that unit (e.g. "centimeters" for the ontological type "cm" ) (default nil)
# @option params  :output_unit_label_column [string] column header containing the string label for that unit (e.g. "centimeters" for the ontological type "cm" )
  
  def output_has_unit(params)

    output_unit = params.fetch(:output_unit_column, nil)  # URI
    output_unit_column = params.fetch(:output_unit_column, nil)  # URI
    output_unit_label = params.fetch(:output_unit_label, nil)
    output_unit_label_column = params.fetch(:output_unit_label_column, nil)
    
    output_unit = output_unit_column ? "$(#{output_unit_column})":output_unit
    output_unit_label = output_unit_label_column ? "$(#{output_unit_label_column})":output_unit_label

    if output_unit
      @mappings << mapping_clause(
              "#{process_tag}_Output_hasunit_unit",
                ["#{source_tag}-source"],
                "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_tag}_Output",
                [[SIO["has-unit"][self.sio_verbose], "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_tag}_Output_unit", "iri"]]
                )

      @mappings << mapping_clause(
              "#{process_tag}_Output_hasunit_unit",
                ["#{source_tag}-source"],
                "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_tag}_Output",
                [[SIO["has-unit"][self.sio_verbose], "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_tag}_Output_unit", "iri"]]
                )
      @mappings << mapping_clause(
              "#{process_tag}_Output_unit_annotation",
              ["#{source_tag}-source"],
              "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_tag}_Output_unit",
              [["rdf:type",output_unit, "iri"]]
              )

    end

    if output_unit_label
    
      @mappings << mapping_clause(
              "#{process_tag}_Output_unit_annotation",
              ["#{source_tag}-source"],
              "this:individual_$(#{personid_column})_$(#{uniqueid_column})##{process_tag}_Output_unit",
              [["rdfs:label",output_unit_label,"xsd:string"]
              ]
              )
    end
    

  end
  

# creates a time-based locally-unique identifier

  def get_uniq_id
        return  Time.now.to_f.to_s.gsub("\.", "") 
      
  end


end
