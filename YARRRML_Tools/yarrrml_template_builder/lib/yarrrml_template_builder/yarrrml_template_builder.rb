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
    "has-attribute" => ["http://semanticscience.org/resource/SIO_000008", "http://semanticscience.org/resource/has-attribute"], 
    "has-quality" => ["http://semanticscience.org/resource/SIO_000217", "http://semanticscience.org/resource/has-quality"],
    "has-unit" => ["http://semanticscience.org/resource/SIO_000221", "http://semanticscience.org/resource/has-unit"],
    "has-value" => ["http://semanticscience.org/resource/SIO_000300", "http://semanticscience.org/resource/has-value"],
    "has-part" => ["http://semanticscience.org/resource/SIO_000028", "http://semanticscience.org/resource/has-part"],
    "has-role" => ["http://semanticscience.org/resource/SIO_000228", "http://semanticscience.org/resource/has-role"],
    "has-target" => ["http://semanticscience.org/resource/SIO_000291", "http://semanticscience.org/resource/has-target"],
    "has-agent" => ["http://semanticscience.org/resource/SIO_000139", "http://semanticscience.org/resource/has-agent"],
    "has-component-part" => ["http://semanticscience.org/resource/SIO_000369", "http://semanticscience.org/resource/has-component-part"],
    "is-participant-in" => ["http://semanticscience.org/resource/SIO_000062", "http://semanticscience.org/resource/is-participant-in"],
    "is-about" => ["http://semanticscience.org/resource/SIO_000332", "http://semanticscience.org/resource/is-about"],
    "has-output" => ["http://semanticscience.org/resource/SIO_000229", "http://semanticscience.org/resource/has-output"],
    "denotes" => ["http://semanticscience.org/resource/SIO_000020", "http://semanticscience.org/resource/denotes"],
    "is-realized-in" => ["http://semanticscience.org/resource/SIO_000356", "http://semanticscience.org/resource/is-realized-in"],
    # predicates
    # for processs
    "has-start-time" => ["http://semanticscience.org/resource/SIO_000680", "http://semanticscience.org/resource/has-start-time"],
    "has-end-time" => ["http://semanticscience.org/resource/SIO_000681", "http://semanticscience.org/resource/has-end-time"],
    "has-time-boundary" => ["http://semanticscience.org/resource/SIO_000679", "http://semanticscience.org/resource/has-time-boundary"],
    "exists-at" => ["http://semanticscience.org/resource/SIO_000687", "http://semanticscience.org/resource/exists-at"],
    "is-specified-by" => ["http://semanticscience.org/resource/SIO_000339", "http://semanticscience.org/resource/is_specified_by"],

    # for information artifact
    "measured-at" => [" http://semanticscience.org/resource/SIO_000793", " http://semanticscience.org/resource/measured-at"],
    # objects
    "start-time" => ["http://semanticscience.org/resource/SIO_000669", "http://semanticscience.org/resource/start-time"],
    "end-time" => ["http://semanticscience.org/resource/SIO_000670", "http://semanticscience.org/resource/end-time"],
    "start-date" => ["http://semanticscience.org/resource/SIO_000031", "http://semanticscience.org/resource/start-date"],
    "end-date" => ["http://semanticscience.org/resource/SIO_000032", "http://semanticscience.org/resource/end-date"],
    "time-instant" => ["http://semanticscience.org/resource/SIO_000418", "http://semanticscience.org/resource/time-instant"],
    #



    "is-component-part-of" => ["http://semanticscience.org/resource/SIO_000313", "http://semanticscience.org/resource/is-component-part-of"],
    "drug" => ["http://semanticscience.org/resource/SIO_010038", "http://semanticscience.org/resource/drug"],
    "sequence-variation-notation" => ["http://semanticscience.org/resource/SIO_001388", "http://semanticscience.org/resource/sequence_variation_notation"],
    "is-base-for" => ["http://semanticscience.org/resource/SIO_000642", "http://semanticscience.org/resource/is-base-for"],
    "has-concretization" => ["http://semanticscience.org/resource/SIO_000213", "http://semanticscience.org/resource/has-concretization"],
    "realizable-entity" =>  ["http://semanticscience.org/resource/SIO_000340", "http://semanticscience.org/resource/realizable-entity"],
    "information-content-entity" =>  ["http://semanticscience.org/resource/SIO_000015", "http://semanticscience.org/resource/information-content-entity"],
    "measurement-value" => ["http://semanticscience.org/resource/SIO_000070", "http://semanticscience.org/resource/measurement-value"],
    "refers-to" => ["http://semanticscience.org/resource/SIO_000628", "http://semanticscience.org/resource/refers-to"],
    "has-input" => ["http://semanticscience.org/resource/SIO_000230", "http://semanticscience.org/resource/has-input"],
    "person" => ["http://semanticscience.org/resource/SIO_000498", "http://semanticscience.org/resource/person"],
    "object" => ["http://semanticscience.org/resource/SIO_000776", "http://semanticscience.org/resource/object"],
    "identifier" => ["http://semanticscience.org/resource/SIO_000115", "http://semanticscience.org/resource/identifier"],
    "role" => ["http://semanticscience.org/resource/SIO_000016", "http://semanticscience.org/resource/role"],
    "process" => ["http://semanticscience.org/resource/SIO_000006", "http://semanticscience.org/resource/process"],
    "day" => ["http://semanticscience.org/resource/SIO_000430", "http://semanticscience.org/resource/day"],
    "attribute" => ["http://semanticscience.org/resource/SIO_000614", "http://semanticscience.org/resource/attribute"],
    "conforms-to" => ["http://semanticscience.org/resource/CHEMINF_000047", "http://semanticscience.org/resource/conforms-to"],

    "specialized-object" => ['http://semanticscience.org/resource/SIO_001353', "http://semanticscience.org/resource/specialized-object"],

  }




# all params are passed as a hash, and retrieved by params.fetch(paramName)
#
# @param params [Hash]  params   a Hash of options
# @option params [String] :baseURI a URL that will become the base for "urls owned by the data provider" e.g. "https://my.dataset.org/thisdataset/records/"
# @option params [String] :source_name   a "short name" (i.e. a single word, no spaces) for the kind of data being transformed.  e.g. height_data
# @option params [Integer] :sio_verbose (0)  "1" means to use http://semanticscience.org/resource/has-value instead of http://semanticscience.org/resource/SIO_000300 for all sio.  Default is 0
#
# @return [YARRRML_Template_BuilderII]
  def initialize(params = {}) # get a name from the "new" call, or set a default
    
    @baseURI = params.fetch(:baseURI, "|||BASE|||")
    @sio_verbose = params.fetch(:sio_verbose, 0)
    abort "must have a baseURI parameter" unless self.baseURI
    @mappings = []

    @source_tag = params.fetch(:source_tag, nil)
    abort "must have a source_name parameter" unless self.source_tag

    @prefix_map = {
      "rdf" => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "rdfs" => "http://www.w3.org/2000/01/rdf-schema#",
      "ex" => "https://ejp-rd.eu/ids/",
      "obo" => "http://purl.obolibrary.org/obo/",
      "sio" => "http://semanticscience.org/resource/",
      "vocab" => "https://ejp-rd.eu/vocab/", 
      "pico" => "https://data.cochrane.org/ontologies/pico/",
      "ndfrt" => "http://purl.bioontology.org/ontology/NDFRT/",
      "edam" => "http://purl.bioontology.org/ontology/EDAM/",
      "ordo" => "http://www.orpha.net/ORDO/",
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
#   e.g. {"mydata" => "https://my.dataset.org/thisdataset/records/"}
#
#   you can send it an empty hash to simply return the existing hash
#
# @return [Hash]  the current hash of prefixes
#  
  def add_prefixes(params = {})
    
    prefixesHash = params.fetch(:prefixesHash, {})
    $stderr.puts prefixesHash
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
    
    #$stderr.puts output.inspect
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
      #$stderr.puts pot.class
      (pred, obj, type) = pot
      #$stderr.puts "#{pred} #{obj}  #{type}"
      typetag = "type"
      typetag = "datatype" unless type == 'iri'
      type = "xsd:string" unless type
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


  def get_root_url(uniq)
    if uniq
      "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})_process"
    else
      "this:individual_$(#{@personid_column})_process"
    end
  end

# creates an entity/identifier/role set of clauses
#
# Parameters passed as a hash
#
# @param params [Hash]  a hash of options
# @option params :entityid_column [String] (required) the column header that contains the identifier of the entity
# @option params :uniqueid_column [String] (required) the column header that contains unique ID for that row (over ALL datasets! e.g. a hash of a timestamp); defaults to "uniqid"
# @option params :identifier_type [String]  the URL of the ontological type of that identifier; defaults to  'sio:identifier'
# @option params :identifier_type_column [String] the column header for the ontological type of that identifier.  Overrides identifier_type.
# @option params :entity_type [String]  the URL of the ontological type defining a "entity"; defaults to 'sio:specialized-object'
# @option params :entity_type_column [String] the column header for the ontological type of the "entity".  Overrides entity_type
# @option params :entity_label [String]  the label for an "entity"; defaults to 'some entity'
# @option params :entity_label_column [String] column for the label
# @option params :entity_tag [String] a single-word unique tag for the entity within this model (defaults to "thisEntity").  Does not appear in the output RDF
# @option params :entity_role_tag [String] a single-word tag for therole (e.g. "patient", "clinician", "drug") the entity plays in this dataset; defaults to "thisRole".  This does not appear in the output RDF
# @option params :role_type [String] the URL for the ontological type of that role; defaults to "obo:OBI_0000093" ("patient")
# @option params :role_type_column [String] the column header that contains the ontological type of that role.  Overrides role_type
# @option params :role_label [String] the label for that kind of role; defaults to "Some Role"
# @option params :role_label_column [String] the column header that has the label for that kind of role (overrides role_label)

def entity_identifier_role_mappings(params = {})
  @entityid_column = params.fetch(:entityid_column, 'pid')
  @uniqueid_column = params.fetch(:uniqueid_column, 'uniqid')
  
  identifier_type = params.fetch(:identifier_type,  SIO["identifier"][self.sio_verbose])
  identifier_type_column = params.fetch(:identifier_type_column, nil)
  entity_tag = params.fetch(:entity_tag, 'thisEntity')
  entity_type = params.fetch(:entity_type, SIO["specialized-object"][self.sio_verbose])
  entity_type_column = params.fetch(:entity_type_column, nil)
  entity_label = params.fetch(:entity_label, nil)
  entity_label_column = params.fetch(:entity_label_column, nil)
  entity_role_tag = params.fetch(:entity_role_tag, 'thisRole')
  role_type = params.fetch(:role_type, 'obo:OBI_0000093')  # patient
  role_type_column = params.fetch(:role_type_column, nil)  # 
  role_label = params.fetch(:role_label, 'Some Role')  # patient
  role_label_column = params.fetch(:role_label_column, nil)  # 

  identifier_type = identifier_type_column ? "$(#{identifier_type_column})":identifier_type
  entity_type = entity_type_column ? "$(#{entity_type_column})":entity_type
  role_type = role_type_column ? "$(#{role_type_column})":role_type
  role_label = role_label_column ? "$(#{role_label_column})":role_label
  entity_label = entity_label_column ? "$(#{entity_label_column})":entity_label

  abort "You MUST have a @entityid_column and a @uniqueid_column to use this library.  Sorry!" unless @entityid_column and @uniqueid_column
  @mappings << mapping_clause(
                           "identifier_has_value_for_#{entity_role_tag}",
                           ["#{source_tag}-source"],
                           "this:individual_$(#{@entityid_column})#ID",
                           [[SIO["has-value"][self.sio_verbose], "$(#{@entityid_column})", "xsd:string"]]
                           )

  @mappings << mapping_clause(
                                "identifier_denotes_role_#{entity_role_tag}",
                                ["#{source_tag}-source"],
                                "this:individual_$(#{@entityid_column})#ID",
                                [
                                 ["a", "#{identifier_type}", "iri"],
                                 ["a", SIO["identifier"][self.sio_verbose], "iri"],
                                 [SIO["denotes"][self.sio_verbose], "this:individual_$(#{@entityid_column})_$(#{@uniqueid_column})##{entity_role_tag}", "iri"],
                                ]
                               )
  @mappings << mapping_clause(
                              "entity_has_role_#{entity_role_tag}",
                              ["#{source_tag}-source"],
                              "this:individual_$(#{@entityid_column})#Entity",
                              [
                               ["a", "#{entity_type}", "iri"],
                               ["a", SIO["object"][self.sio_verbose], "iri"],
                               [SIO["has-role"][self.sio_verbose], "this:individual_$(#{@entityid_column})_$(#{@uniqueid_column})##{entity_role_tag}", "iri"],
                              ]
                             )

  @mappings << mapping_clause(
                              "#{entity_role_tag}_annotation",
                              ["#{source_tag}-source"],
                              "this:individual_$(#{@entityid_column})_$(#{@uniqueid_column})##{entity_role_tag}",
                              [
                                ["a", "#{role_type}", "iri"],
                                ["a", SIO["role"][self.sio_verbose], "iri"],
                                ["rdfs:label", " Role: #{role_label}", "xsd:string"],
                              ]
                             ) 
  if entity_label
    @mappings << mapping_clause(
                                "#{entity_role_tag}_entity_label_annotation",
                                ["#{source_tag}-source"],
                                "this:individual_$(#{@entityid_column})#Entity",
                                [
                                  ["rdfs:label", " Role: #{entity_label}", "xsd:string"],
                                ]
                              ) 
  end



end

# creates the person/identifier/role portion of the CDE
#
# Parameters passed as a hash.  this is a specification of the entity-identifier-role method, with Patient defaults
#
# @param params [Hash]  a hash of options
# @option params :personid_column [String] (required) the column header that contains the anonymous identifier of the person; defaults to "pid"
# @option params :uniqueid_column [String] (required) the column header that contains unique ID for that row (over ALL datasets! e.g. a hash of a timestamp); defaults to "uniqid"
# @option params :identifier_type [String]  the URL of the ontological type of that identifier; defaults to  'sio:identifier'
# @option params :identifier_type_column [String] the column header for the ontological type of that identifier.  Overrides identifier_type.
# @option params :person_type [String]  the URL of the ontological type defining a "person"; defaults to 'sio:person'
# @option params :person_type_column [String] the column header for the ontological type of the "individual".  Overrides person_type
# @option params :person_role_tag [String] a single-word label for the kind of role (e.g. "patient", "clinician") the person plays in this dataset; defaults to "thisRole"
# @option params :role_type [String] the URL for the ontological type of that role; defaults to "obo:OBI_0000093" ("patient")
# @option params :person_tag [String] a single-word unique tag for the person within this model (defaults to "thisPerson").  Does not appear in the output RDF
# @option params :role_type_column [String] the column header that contains the ontological type of that role.  Overrides role_type
# @option params :role_label [String] the label for that kind of role; defaults to "Patient"
# @option params :role_label_column [String] the column header that has the label for that kind of role (overrides role_label)
# @option params :person_label [String] the label for that person (no default)
# @option params :person_label_column [String] the column header that has the label for that person (no default)
#
  def person_identifier_role_mappings(params = {})
    @personid_column = params.fetch(:personid_column, 'pid')
    uniqueid_column = params.fetch(:uniqueid_column, 'uniqid')
    
    identifier_type = params.fetch(:identifier_type,  SIO["identifier"][self.sio_verbose])
    identifier_type_column = params.fetch(:identifier_type_column, nil)
    person_type = params.fetch(:person_type, SIO["person"][self.sio_verbose])
    person_tag = params.fetch(:person_tag, 'thisPerson')
    person_type_column = params.fetch(:person_type_column, nil)
    person_role_tag = params.fetch(:person_role_tag, 'thisRole')
    role_type = params.fetch(:role_type, 'obo:OBI_0000093')  # patient
    role_type_column = params.fetch(:role_type_column, nil)  # 
    role_label = params.fetch(:role_label, 'Patient Role')  # patient
    role_label_column = params.fetch(:role_label_column, nil)  # 
    person_label = params.fetch(:person_label, nil)  # patient
    person_label_column = params.fetch(:person_label_column, nil)  # 

    self.entity_identifier_role_mappings({
      entityid_column: @personid_column,
      uniqueid_column: uniqueid_column,
      identifier_type: identifier_type,
      identifier_type_column: identifier_type_column,
      entity_tag: person_tag,
      entity_type: person_type,
      entity_type_column: person_type_column,
      entity_role_tag: person_role_tag,
      role_type: role_type,
      role_type_column: role_type_column,
      role_label: role_label,
      role_label_column: role_label_column,
      entity_label: person_label,
      entity_label_column: person_label_column,
    })

  end
  

  




# creates the role_in_process portion of the CDE
#
# Parameters passed as a hash
#
# @param params [Hash]  a hash of options
# @option params :person_role_tag  [String] the tag of the role that is fulfilled in this process (default 'thisRole') - see person_role_tag above, synchronize these tags!
# @option params :entity_role_tag  [String] the tag of the role that is fulfilled in this process (default 'thisRole') - see entity_role_tag above, synchronize these tags!
# @option params :process_type  [String] the URL for the ontological type of the process (defaults to http://semanticscience.org/resource/process)
# @option params :process_type_column  [String] the column header that contains the URL for the ontological type of the process - overrides process_type
# @option params :process_tag  [String] some single-word tag for that process; defaults to "thisprocess"
# @option params :process_label  [String] the label associated with the process type in that row (defaults to "thisprocess")
# @option params :process_label_column  [String] the column header for the label associated with the process type in that row
# @option params :process_start_column  [ISO 8601 date (only date)] (optional) the column header for the datestamp when that process started. NOTE:  For instantaneous processes, create ONLY the start date column, and an identical end date will be automatically generated
# @option params :process_end_column  [ISO 8601 date (only date)]  (optional) the column header for the datestamp when that process ended
# @option params :process_duration_column  [xsd:int]  (optional) the column header for the duration of the event measured in integer numbers of days
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.
  def role_in_process(params)
    person_role_tag = params.fetch(:person_role_tag, 'thisRole')
    entity_role_tag = params.fetch(:person_role_tag, nil)
    process_type = params.fetch(:process_type, SIO["process"][self.sio_verbose])  
    process_type_column = params.fetch(:process_type_column, nil)  
    process_tag  = params.fetch(:process_tag, 'thisprocess')  # some one-word name
    process_label = params.fetch(:process_label, 'Process') 
    process_label_column = params.fetch(:process_label_column, nil) 
    process_start_column = params.fetch(:process_start_column, nil) 
    process_end_column = params.fetch(:process_end_column, nil)
    process_duration_column = params.fetch(:process_end_column, nil)
    make_unique_process = params.fetch(:make_unique_process, true)

    process_type = process_type_column ? "$(#{process_type_column})":process_type
    process_label = process_label_column ? "$(#{process_label_column})":process_label

    person_role_tag = entity_role_tag if entity_role_tag

    root_url = get_root_url(make_unique_process)

    @mappings << mapping_clause(
      "#{person_role_tag}_realized_#{process_tag}",
      ["#{source_tag}-source"],
      "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{person_role_tag}",
      [
            [SIO["is-realized-in"][self.sio_verbose], root_url + "##{process_tag}","iri"]
      ]
      )
    
    @mappings << mapping_clause(
          "#{process_tag}_process_annotation",
          ["#{source_tag}-source"],
           root_url + "##{process_tag}",
           [
             ["rdf:type",SIO["process"][self.sio_verbose], "iri"],
             ["rdf:type","#{process_type}", "iri"],
             ["rdfs:label","Process: #{process_label}", "xsd:string"],
           ]
           )      
      
      
    if process_start_column
      @mappings << mapping_clause(
        "#{process_tag}_process_annotation_start",
          ["#{source_tag}-source"],
           root_url + "##{process_tag}",
           [
             [SIO["has-start-time"][self.sio_verbose], root_url + "##{process_tag}_startdate_#{process_start_column}", "iri"]
            ]
           )
      @mappings << mapping_clause(
        "#{process_tag}_process_annotation_start_value",
          ["#{source_tag}-source"],
           root_url + "##{process_tag}_startdate_#{process_start_column}",
           [
             [SIO["has-value"][self.sio_verbose], "$(#{process_start_column})", "xsd:date"],
             ["rdf:type", SIO["start-date"][self.sio_verbose], "iri"],             
             ["rdfs:label", "Start Date: $(#{process_start_column})"],             
             ]
           )
      # now create the MIRROR  (!!!!) end time, if one is not provided
      unless process_end_column
        @mappings << mapping_clause(
          "#{process_tag}_process_annotation_end",
            ["#{source_tag}-source"],
             root_url + "##{process_tag}",
             [[SIO["has-end-time"][self.sio_verbose], root_url + "##{process_tag}_enddate_#{process_start_column}", "iri"]]
        )
        @mappings << mapping_clause(
          "#{process_tag}_process_annotation_end_value",
            ["#{source_tag}-source"],
             root_url + "##{process_tag}_enddate_#{process_start_column}",
             [
               [SIO["has-value"][self.sio_verbose], "$(#{process_start_column})", "xsd:date"],
               ["rdf:type", SIO["end-date"][self.sio_verbose], "iri"],             
               ["rdfs:label", "End Date: $(#{process_start_column})"],             
               ]
        )
      end

    end
    
    if process_end_column
      @mappings << mapping_clause(
        "#{process_tag}_process_annotation_end",
          ["#{source_tag}-source"],
           root_url + "##{process_tag}",
           [[SIO["has-end-time"][self.sio_verbose], root_url + "##{process_tag}_enddate_#{process_end_column}", "iri"]]
           )
      @mappings << mapping_clause(
        "#{process_tag}_process_annotation_end_value",
          ["#{source_tag}-source"],
           root_url + "##{process_tag}_enddate_#{process_end_column}",
           [
             [SIO["has-value"][self.sio_verbose], "$(#{process_end_column})", "xsd:date"],
             ["rdf:type", SIO["end-date"][self.sio_verbose], "iri"],             
             ["rdfs:label", "End Date: $(#{process_end_column})"],             
             ]
           )
    end

    if process_duration_column
      @mappings << mapping_clause(
        "#{process_tag}_process_annotation_duration",
          ["#{source_tag}-source"],
           root_url + "##{process_tag}",
           [[SIO["exists-at"][self.sio_verbose], root_url + "##{process_tag}_exists_at_#{process_duration_column}", "iri"]]
           )
      @mappings << mapping_clause(
        "#{process_tag}_process_annotation_duration_value",
          ["#{source_tag}-source"],
          root_url + "##{process_tag}_exists_at_#{process_duration_column}",
           [
             [SIO["has-value"][self.sio_verbose], "$(#{process_duration_column})", "xsd:int"],
             ["rdf:type", SIO["day"][self.sio_verbose], "iri"],             
             ["rdfs:label", "Duration: $(#{process_end_column}) days"],             
             ]
           )
    end

  end
  
  
  
# creates the process has annotations portion of the CDE
#
# Parameters passed as a hash
#
# @param params [Hash]  a hash of options
# @option params :process_tag  [String] (required) the same process tag that is used in the "role in process" 
# @option params :process_annotations_columns [Array] ([[predcol, valcol,datatypecol], ...])   (if predol looks like a URI, it will be used as a URI)
# @option params :process_annotations [Array] ([[pred, valuecolumn,datatype]...]) 
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.
  def process_has_annotations(params)
    process_tag = params.fetch(:process_tag, "thisprocess")  
    process_annotations_columns = params.fetch(:process_annotations_columns, [])  
    process_annotations = params.fetch(:process_annotations, [])  
    make_unique_process = params.fetch(:make_unique_process, true)

    root_url = get_root_url(make_unique_process)


    if !process_annotations_columns.empty?
      process_annotations_columns.each do |predicate, value, datatype|
        case 
        when datatype =~ /iri/
          datatype = "iri"
        when datatype =~ /^xsd\:/
          datatype = datatype
        when datatype
          datatype = "$(#{datatype})"   # its a column header
        else
          datatype = "xsd:string"
        end
        
        
        if predicate =~ /https?\:\/\//
          predicate = predicate
        else
          predicate = "$(#{predicate})"  # if the predicate looks like a URI, assume that it is, rather than a colulmn header
        end
        
        next unless predicate and value
        uniqid = get_uniq_id
        
        @mappings << mapping_clause(
            "#{uniqid}_process_custom_annotation",
            ["#{source_tag}-source"],
            root_url + "##{process_tag}",
            [[predicate, "$(#{value})", datatype]]
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
           root_url + "##{process_tag}",
            [[predicate, value, datatype]]
            )
        
      end
      
    end

    
  end
  

  # creates the process has agent portion of the CDE
#
# Parameters passed as a hash
#
# @param params [Hash]  a hash of options
# @option params :process_tag  [String] (required) the same process tag that is used in the "role in process" 
# @option params :entityid_column [String] (required) default "pid"
# @option params :entity_tag [String] (required) default "thisEntity".   The entity-tag that you used for the entity in the entity/identifier/role clauses
  def process_has_agent(params)
    process_tag = params.fetch(:process_tag, "thisprocess")  
    entityid_column = params.fetch(:entityid_column, "pid")
    entity_tag = params.fetch(:entityid_column, "thisEntity")
    make_unique_process = params.fetch(:make_unique_process, true)

    root_url = get_root_url(make_unique_process)


    @mappings << mapping_clause(
        "process_has_agent_#{entity_tag}",
        ["#{source_tag}-source"],
        root_url + "##{process_tag}",
        [[SIO['has-agent'][self.sio_verbose], "this:individual_$(#{@entityid_column})#Entity" , 'iri']]
        )
      
      
  end




# creates the process_has_part portion of the CDE
#
# Parameters passed as a hash
#
# @param params [Hash]  a hash of options
# @option params :parent_process_tag  [String] (required) the same process tag that is used in the "role in process"  for the parent process
# @option params :part_process_tag  [String] (required) the same process tag that is used in the "role in process" for the process that is a part of the parent
# @option params :parent_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.
# @option params :part_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.
  def process_has_part(params)
    parent_process_tag = params.fetch(:parent_process_tag, nil)  
    part_process_tag = params.fetch(:part_process_tag, nil)  
    parent_unique_process = params.fetch(:parent_unique_process, true)
    part_unique_process = params.fetch(:part_unique_process, true)

    parent_root_url = get_root_url(parent_unique_process)
    part_root_url = get_root_url(part_unique_process)

    abort "cannot create part relationship unless both parent and child processes have a tag" unless (parent_process_tag && part_process_tag)
      
    #uniqid = get_uniq_id
    
    @mappings << mapping_clause(
        "#{parent_process_tag}_has_part_#{part_process_tag}",
        ["#{source_tag}-source"],
        parent_root_url + "##{parent_process_tag}",
        [[SIO["has-part"][self.sio_verbose], part_root_url + "##{part_process_tag}" , "iri"]]
        )
    
  end





# creates the process has target portion of the CDE
#
# Parameters passed as a hash
#
# @param params [Hash]  a hash of options
# @option params :process_with_target_tag  [String] (required) the same process tag that is used in the "role in process" for which this is the target
# @option params :target_type_tag  [String] a tag to differentiate this target from other targets
# @option params :target_type  [String] the ontological type for the target  (e.g. process is targetted at creatinine - http://purl.obolibrary.org/obo/CHEBI_16737)
# @option params :target_type_column  [String] the column header specifying the ontological type for the target node (overrides target_type).  
# @option params :target_type_label  [String] the label for all targets
# @option params :target_type_label_column  [String] the label column for each target
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.
  def process_has_target(params)
    process_with_target_tag  = params.fetch(:process_with_target_tag, "thisprocess")  # some one-word name
    target_type_tag  = params.fetch(:target_type_tag, "thisTarget")  # some one-word name
    target_type  = params.fetch(:target_type, SIO["information-content-entity"][self.sio_verbose])  # some one-word name
    target_type_column  = params.fetch(:target_type_column, nil)  # some one-word name
    target_type_label  = params.fetch(:target_type_label, "information content entity")  # some one-word name
    target_type_label_column  = params.fetch(:target_type_label_column, nil)  # some one-word name
    make_unique_process = params.fetch(:make_unique_process, true)

    root_url = get_root_url(make_unique_process)
    
    
    abort "must specify the process_with_target_tag
    (the identifier of the process that has the input)
    before you can use the process_has_target function" unless process_with_target_tag

    target_type = target_type_column ? "$(#{target_type_column})":target_type
    target_label = target_type_label_column ? "$(#{target_type_label_column})":target_type_label

    @mappings << mapping_clause(
        "#{process_with_target_tag}_has_target_#{target_type_tag}",
        ["#{source_tag}-source"],
        root_url + "##{process_with_target_tag}",
        [[SIO["has-target"][self.sio_verbose],"this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_target_tag}_Target", "iri"]]
        )
    
    @mappings << mapping_clause(
        "#{process_with_target_tag}_has_target_#{target_type_tag}_annotation",
        ["#{source_tag}-source"],
        "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_target_tag}_Target",
        [
          ["rdf:type",SIO["information-content-entity"][self.sio_verbose], "iri"],
          ["rdf:type","#{target_type}", "iri"],
          ["rdfs:label","Process Target: #{target_label}", "xsd:string"],
          ]
        )
    
  end
  





# creates the process is specified by portion of the CDE
#
# Parameters passed as a hash
#
# @param params [Hash]  a hash of options
# @option params :process_with_protocol_tag  [String] (required) the same process tag that is used in the "role in process" for which this is the input
# @option params :protocol_type_tag  [String] a tag to differentiate this input from other inputs
# @option params :process_type  [String] ("sio:process" - process) usually you want to be more specific, like "measuring" or "estimating"
# @option params :process_type_column  [String] ("sio:process" - process)
# @option params :process_type_label  [String] ("protocol")
# @option params :process_type_label_column [String] ("protocol")
# @option params :protocol_uri  [String] uri of the process protocol for all inputs
# @option params :protocol_uri_column  [String] column header for the protocol uri column
# @option params :protocol_label  [String] label of the process protocol for all inputs
# @option params :protocol_label_column  [String] column header for the label for the protocol uri
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.
  def process_is_specified_by(params)
    process_with_protocol_tag  = params.fetch(:process_with_protocol_tag, "thisprocess")  # some one-word name
    protocol_type_tag  = params.fetch(:protocol_type_tag, "thisProtocoltype")  # some one-word name
    process_type  = params.fetch(:processs_type, SIO["process"][self.sio_verbose])  # 
    process_type_column  = params.fetch(:protocol_type_column, nil) # 
    process_type_label  = params.fetch(:protocol_type_label, "Process") 
    process_type_label_column  = params.fetch(:protocol_type_label_column, nil) 
    protocol_uri  = params.fetch(:protocol_uri, nil)  # Protocol
    protocol_uri_column  = params.fetch(:protocol_uri_column, nil)  
    protocol_label  = params.fetch(:protocol_uri, nil)  # Protocol
    protocol_label_column  = params.fetch(:protocol_uri_column, nil)  
    protocol_type  = params.fetch(:protocol_type, "http://purl.obolibrary.org/obo/NCIT_C42651")   # Protocol
    protocol_type_column  = params.fetch(:protocol_type_column, nil)   
    make_unique_process = params.fetch(:make_unique_process, true)

    root_url = get_root_url(make_unique_process)
    
    
    abort "must specify the process_with_target_tag and the protocol type tag
    (the identifier of the process that has the input)
    before you can use the process_has_target function" unless (process_with_protocol_tag and protocol_type_tag)

    process_type = process_type_column ? "$(#{process_type_column})":process_type
    process_type_label = process_type_label_column ? "$(#{process_type_label_column})":process_type_label
    protocol_uri = protocol_uri_column ? "$(#{protocol_uri_column})":protocol_uri
    protocol_label = protocol_label_column ? "$(#{protocol_label_column})":protocol_label
    protocol_type = protocol_type_column ? "$(#{protocol_type_column})":protocol_type

    abort "must specify either a default protocol URI, or a column of protocol URIs" unless protocol_uri

    @mappings << mapping_clause(
      "#{process_with_protocol_tag}_specified_by_#{protocol_type_tag}_specifictype_annotation",
      ["#{source_tag}-source"],
      root_url + "##{process_with_protocol_tag}",
      [
        ["rdf:type","#{process_type}", "iri"],
        ["rdfs:label","Protocol: #{process_type_label}", "xsd:string"],
      ]
      )

    @mappings << mapping_clause(
        "#{process_with_protocol_tag}_specified_by_#{protocol_type_tag}",
        ["#{source_tag}-source"],
        root_url + "##{process_with_protocol_tag}",
        [[SIO["is-specified-by"][self.sio_verbose], protocol_uri, "iri"]]
        )
    
    @mappings << mapping_clause(
        "#{process_with_protocol_tag}_specified_by_#{protocol_type_tag}_annotation",
        ["#{source_tag}-source"],
        protocol_uri,
        [
          ["rdf:type",SIO["information-content-entity"][self.sio_verbose], "iri"],
          ["rdf:type","http://purl.obolibrary.org/obo/NCIT_C42651", "iri"],  # Protocol
          ["rdf:type","#{protocol_type}", "iri"],
          ["rdfs:label","Protocol: #{protocol_label}", "xsd:string"],
          ]
        )
    
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
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.


#  NEED AN INPUT REFERS TO HERE>>>>>>

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
    make_unique_process = params.fetch(:make_unique_process, true)

    root_url = get_root_url(make_unique_process)
    
    
    abort "must specify the process_with_input_tag (the identifier of the process that receives the input) before you can use the process_has_input function" unless process_with_input_tag

    input_type = input_type_column ? "$(#{input_type_column})":input_type
    input_label = input_type_label_column ? "$(#{input_type_label_column})":input_type_label
    input_value = input_has_value_column ? "$(#{input_has_value_column})":input_has_value
    input_value_datatype = input_has_value_datatype_column ? "$(#{input_has_value_datatype_column})":input_has_value_datatype

    @mappings << mapping_clause(
        "#{process_with_input_tag}_has_input_#{input_type_tag}",
        ["#{source_tag}-source"],
        root_url + "##{process_with_input_tag}",
        [[SIO["has-input"][self.sio_verbose],"this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{input_is_output_of_process_tag}_Output", "iri"]]
        )
    
    @mappings << mapping_clause(
        "#{process_with_input_tag}_has_input_#{input_type_tag}_annotation",
        ["#{source_tag}-source"],
        "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{input_is_output_of_process_tag}_Output",
        [
          ["rdf:type",SIO["information-content-entity"][self.sio_verbose], "iri"],
          ["rdf:type","#{input_type}", "iri"],
          ["rdfs:label","Process Input: #{input_label} - Type: #{input_type_tag}", "xsd:string"],
          ]
        )
    

    if input_value

      @mappings << mapping_clause(
      "input_#{input_type_tag}_has_value",
      ["#{source_tag}-source"],
      "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{input_is_output_of_process_tag}_Output",
      [[SIO["has-value"][self.sio_verbose],"#{input_value}", "#{input_value_datatype}"]]
      )
    end

      # TODO:   need to allow units here too!  ...one day...
  end
  






# creates the process_hasoutput_output portion of the CDE
#
# TODO  allow multiple outputs
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
# @option params :output_start_column  [xsd:date] the column header for start date, if the observation is time-constrained (e.g. symptoms from 2020-01-01 to 2020-01-05)
# @option params :output_end_column  [xsd:date]   the column header for end date, if the observation is time-constrained (e.g. symptoms from symptoms from 2020-01-01 to 2020-01-05)
# @option params :output_measured_at_column  [xsd:date]   the column header for a time-instant date of the observation
# @option params :output_annotations  [Array] Array of Arrays of [[predicate, valuecolumn, datatype]...] that will be applied as annotations to the output of the tagged process.  predicate may be a full URI or a column reference; value MUST be a column-reference; datatype is options, default xsd:string
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.
  def process_hasoutput_output(params)
    process_with_output_tag = params.fetch(:process_with_output_tag, "thisprocess")  # some one-word name
    output_value = params.fetch(:output_value, nil)
    output_value_column = params.fetch(:output_value_column, nil)
    output_type = params.fetch(:output_type, SIO["information-content-entity"][self.sio_verbose])
    output_type_column = params.fetch(:output_type_column, nil)
    output_type_label = params.fetch(:output_type_label, "measurement-value")
    output_type_label_column = params.fetch(:output_type_label_column, nil)
    output_value_datatype = params.fetch(:output_value_datatype, "xsd:string")
    output_value_datatype_column = params.fetch(:output_value_datatype_column, nil)
    output_comments_column = params.fetch(:output_comments_column, nil)
    output_start_column = params.fetch(:output_start_column, nil)
    output_end_column = params.fetch(:output_end_column, nil)
    output_timeinstant_column = params.fetch(:output_timeinstant_column, nil)
    output_measured_at_column = params.fetch(:output_measured_at_column, nil)
    output_annotations = params.fetch(:output_annotations, [])
    #output_annotations_columns = params.fetch(:output_annotations_columns, [])
    make_unique_process = params.fetch(:make_unique_process, true)

    output_value = output_value_column ? "$(#{output_value_column})":output_value
    output_type = output_type_column ? "$(#{output_type_column})":output_type
    output_type_label = output_type_label_column ? "$(#{output_type_label_column})":output_type_label
    output_value_datatype = output_value_datatype_column ? "$(#{output_value_datatype_column})":output_value_datatype
    

    root_url = get_root_url(make_unique_process)

   #return unless output_value
   
    @mappings << mapping_clause(
        "#{process_with_output_tag}_process_has_output",
        ["#{source_tag}-source"],
        root_url + "##{process_with_output_tag}",
        [[SIO["has-output"][self.sio_verbose], "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output", "iri"]]
        )
    @mappings << mapping_clause(
        "#{process_with_output_tag}_Output_annotation",
        ["#{source_tag}-source"],
        "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output",
        [["rdf:type",SIO["information-content-entity"][self.sio_verbose], "iri"]]
        )      
    
    if output_type
          @mappings << mapping_clause(
              "#{process_with_output_tag}_Output_type_annotation",
              ["#{source_tag}-source"],
              "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output",
              [["rdf:type",output_type, "iri"]]
              )
    end
    
    if output_type_label
          @mappings << mapping_clause(
              "#{process_with_output_tag}_Output_type_label_annotation",
              ["#{source_tag}-source"],
              "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output",
              [["rdfs:label","Output Type: #{output_type_label}", "xsd:string"]]
              )
    end
    
    if output_value
          @mappings << mapping_clause(
              "#{process_with_output_tag}_Output_value_annotation",
              ["#{source_tag}-source"],
              "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output",
              [[SIO["has-value"][self.sio_verbose],output_value, output_value_datatype]]
              )
    end
    
    if output_comments_column
          @mappings << mapping_clause(
              "#{process_with_output_tag}_Output_value_comments",
              ["#{source_tag}-source"],
              "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output",
              [["rdfs:comment","$(#{output_comments_column})", "xsd:string"]]
              )
    end
    
  
    if output_measured_at_column
      
      @mappings << mapping_clause(
        "#{process_with_output_tag}_output_measured_at_timeinstant",
          ["#{source_tag}-source"],
          "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output",
           [
             [SIO["measured-at"][self.sio_verbose], "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output_measured_at", "iri"],           
             ]
           )
      @mappings << mapping_clause(
        "#{process_with_output_tag}_output_measured_at_timeinstant_value",
          ["#{source_tag}-source"],
          "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output_measured_at",
           [
             [SIO["has-value"][self.sio_verbose], "$(#{output_timeinstant_column})", "xsd:date"],
             ["rdf:type", SIO["time-instant"][self.sio_verbose], "iri"],         
             ]
           )
    end


    if output_start_column  # start and end will be attributes of the information object
      
      @mappings << mapping_clause(
        "#{process_with_output_tag}_output_has_start_atribute",
          ["#{source_tag}-source"],
          "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output",
           [
              # need to add the start column into this URI so that, if it is empty, the attribute will not be created at all by SDMRDFizer
             [SIO["has-attribute"][self.sio_verbose], "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output_start_attribute_$(#{output_start_column})", "iri"],           
             ]
           )
      @mappings << mapping_clause(
        "#{process_with_output_tag}_output_has_start_attribute_value",
          ["#{source_tag}-source"],
          "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output_start_attribute_$(#{output_start_column})",
           [
             [SIO["has-value"][self.sio_verbose], "$(#{output_start_column})", "xsd:date"],
             ["rdf:type", SIO["start-date"][self.sio_verbose], "iri"],         
             ]
           )
    end


    if output_end_column  # start and end will be attributes of the information object
      
      @mappings << mapping_clause(
        "#{process_with_output_tag}_output_has_end_atribute",
          ["#{source_tag}-source"],
          "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output",
           [
              # need to add the start column into this URI so that, if it is empty, the attribute will not be created at all by SDMRDFizer
             [SIO["has-attribute"][self.sio_verbose], "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output_end_attribute_$(#{output_end_column})", "iri"],           
             ]
           )
      @mappings << mapping_clause(
        "#{process_with_output_tag}_output_has_end_attribute_value",
          ["#{source_tag}-source"],
          "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output_end_attribute_$(#{output_end_column})",
           [
             [SIO["has-value"][self.sio_verbose], "$(#{output_end_column})", "xsd:date"],
             ["rdf:type", SIO["end-date"][self.sio_verbose], "iri"],         
             ]
           )
    end

    output_annotations.each do |pred, value, dtype|
      datatype = "xsd:string"
      predicate = ""
      if dtype and dtype =~ /\S+\:\S+/  # URI or qname
        datatype = dtype
      elsif dtype
        datatype = "$(#{datatype})" # make it the column reference if it exists, but isn't a uri
      end
      
      if pred and pred =~ /\S+\:\S+/  # URI or qname
        predicate = pred
      else
        predicate = "$(#{pred})" # make it the column reference if it exists, but isn't a uri
      end
  
      next unless predicate and value
      uniqid = get_uniq_id
      
      @mappings << mapping_clause(
          "#{uniqid}_output_custom_annotation",
          ["#{source_tag}-source"],
           "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output",
          [["$(#{predicate})", "$(#{value})", datatype]]
          )
          
    end
      
  end


# creates the input output refers to portion of the CDE
#
# Parameters passed as a hash
#
#@param params [Hash]  a hash of options
#@option params  :inout_process_tag [String]  ("unidentifiedProcess")
#@option params  :refers_to_tag [String]  (nil) required unique one-word tag of an attribute
#@option params  :inout_refers_to [String]  ([])  an ontology URI
#@option params  :inout_refers_to_column [String] ([]) column headers for column of ontologyURIs
#@option params  :inout_refers_to_label  [String]  ([]) an ontology term label
#@option params  :inout_refers_to_label_column  [String]  ([])  column header for column of ontology term labels
#@option params  :inout_refers_to_uri_column  [String]  ([])  column header for column containing the URIs of the in/out node (e.g. a specific clinical variant identifier)
#@option params  :is_attribute  [Boolean]  (true)  is this output an attribute of the patient?
#@option params  :base_types [Array] ([])  an array of ontology terms that will be applied as the rdf:type for all the referred-to quality/attribute

  def input_output_refers_to(params)
    inout_process_tag = params.fetch(:inout_process_tag, 'unidentifiedProcess')
    refers_to_tag = params.fetch(:refers_to_tag, nil)
    inout_refers_to = params.fetch(:inout_refers_to, nil)  
    inout_refers_to_label = params.fetch(:inout_refers_to_label, nil) 
    inout_refers_to_column = params.fetch(:inout_refers_to_column, nil)  
    inout_refers_to_label_column = params.fetch(:inout_refers_to_label_column, nil ) 
    inout_refers_to_uri_column = params.fetch(:inout_refers_to_uri_column, nil ) 
    is_attribute = params.fetch(:is_attribute, true ) 
    base_types = params.fetch(:base_types, [] ) 
    
    refers_to = inout_refers_to_column ? "$(#{inout_refers_to_column})":inout_refers_to
    refers_to_label = inout_refers_to_label_column ? "$(#{inout_refers_to_label_column})":inout_refers_to_label

    abort "must specify in_out_process_tag" unless inout_process_tag
    abort "must specify refers_to_tag" unless refers_to_tag
    #$stderr.puts "is an attribute #{is_attribute}"

    attribute_node_uri = inout_refers_to_uri_column ? "$(#{inout_refers_to_uri_column})":"this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{refers_to_tag}_TypedAttributeNode"
    
    types = []
    types << ["rdf:type", SIO["attribute"][self.sio_verbose], "iri"] if is_attribute  # add base type if its an attribute
    types << ["rdf:type", refers_to, "iri"]
    base_types.each do |b|
      types << ["rdf:type", b, "iri"]
    end

    @mappings << mapping_clause(
        "inout_from_#{inout_process_tag}_refers_to_concepts",
        ["#{source_tag}-source"],
        "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{inout_process_tag}_Output",
        [
        [SIO["refers-to"][self.sio_verbose], attribute_node_uri, "iri"]
        ] 
    )

    if is_attribute
      @mappings << mapping_clause(
      "has_attribute_of_inout_from_#{inout_process_tag}",
      ["#{source_tag}-source"],
      "this:individual_$(#{@personid_column})#Person",            
      [
       [SIO["has-attribute"][self.sio_verbose], attribute_node_uri, "iri"]
      ]
      )
    end

    @mappings << mapping_clause(
      "inout_from_#{inout_process_tag}_refers_to_concept_#{refers_to_tag}_type",
      ["#{source_tag}-source"],
      attribute_node_uri,
      
        types
      
    )


    if refers_to_label    
      @mappings << mapping_clause(
          "inout_from_#{inout_process_tag}_refers_to_concept_#{refers_to_tag}_label",
          ["#{source_tag}-source"],
          attribute_node_uri,
          [
          ["rdfs:label", "Attribute Type: #{refers_to_label}" ] 
          ]
      )
    end
            
    
  end
  




  

# creates the output_has_unit portion of the CDE
#
# Parameters passed as a hash
# @option params  :inout_process_tag [String]  ("unidentifiedProcess")
# @option params  :output_unit [URL] the ontological type of that unit (default nil)
# @option params  :output_unit_column [String]column containing the ontological type of that unit (overrides output_unit)
# @option params  :output_unit_label [string] the string label for that unit (e.g. "centimeters" for the ontological type "cm" ) (default nil)
# @option params  :output_unit_label_column [string] column header containing the string label for that unit (e.g. "centimeters" for the ontological type "cm" )
  
  def output_has_unit(params)
    process_tag = params.fetch(:inout_process_tag, 'unidentifiedProcess')

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
                "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_tag}_Output",
                [[SIO["has-unit"][self.sio_verbose], "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_tag}_Output_unit", "iri"]]
                )

      @mappings << mapping_clause(
              "#{process_tag}_Output_unit_annotation",
              ["#{source_tag}-source"],
              "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_tag}_Output_unit",
              [["rdf:type",output_unit, "iri"]]
              )

    end

    if output_unit and output_unit_label
    
      @mappings << mapping_clause(
              "#{process_tag}_Output_unit_label_annotation",
              ["#{source_tag}-source"],
              "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_tag}_Output_unit",
              [["rdfs:label",output_unit_label,"xsd:string"]
              ]
              )
    end
    

  end

  

# creates the entity has component entity portion of the CDE
#
# Parameters passed as a hash
#
# @param params [Hash]  a hash of options
# @option params :parent_entityid_column  [String] (required) the column that contains the parent entity id
# @option params :part_entity_tag  [String] (required) the tag of the part
# @option params :part_type_column  [String] (required) the column that contains the parent entity id
  def entity_has_component(params)
    parent_entityid_column = params.fetch(:parent_entityid_column, 'pid')  
    part_entity_tag = params.fetch(:part_entity_tag, nil)  
    part_type = params.fetch(:part_type, nil)  
    part_type_column = params.fetch(:part_type_column, nil)  

    part_type = part_type_column ? "$(#{part_type_column})":part_type

    abort "cannot create entity has component without both a part type and part tag" unless (part_type && part_entity_tag)

    #uniqid = get_uniq_id
    
    @mappings << mapping_clause(
        "parent_entity_has_part_#{part_entity_tag}",
        ["#{source_tag}-source"],
        "this:individual_$(#{parent_entityid_column})#Entity",
        [[SIO["has-component-part"][self.sio_verbose], "this:individual_#{part_entity_tag}#comopnentEntity" , "iri"]]
        )

    @mappings << mapping_clause(
      "parent_entity_has_part_#{part_entity_tag}",
      ["#{source_tag}-source"],
      "this:individual_#{part_entity_tag}#comopnentEntity",
      [['rdf:type', part_type , "iri"]]
      )
    
  end



# creates a time-based locally-unique identifier

  def get_uniq_id
        return  Time.now.to_f.to_s.gsub("\.", "") 
      
  end
end



