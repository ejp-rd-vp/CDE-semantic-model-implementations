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
"has-attribute" => ["http://semanticscience.org/resource/SIO_000008", "http://semanticscience.org/resource/has-attribute"], 
"has-quality" => ["http://semanticscience.org/resource/SIO_000217", "http://semanticscience.org/resource/has-quality"],
"has-unit" => ["http://semanticscience.org/resource/SIO_000221", "http://semanticscience.org/resource/has-unit"],
"has-value" => ["http://semanticscience.org/resource/SIO_000300", "http://semanticscience.org/resource/has-value"],
"has-part" => ["http://semanticscience.org/resource/SIO_000028", "http://semanticscience.org/resource/has-part"],
"has-role" => ["http://semanticscience.org/resource/SIO_000228", "http://semanticscience.org/resource/has-role"],
"has-target" => ["http://semanticscience.org/resource/SIO_000291", "http://semanticscience.org/resource/has-target"],
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
"attribute" => ["http://semanticscience.org/resource/SIO_000614", "http://semanticscience.org/resource/attribute"],
"conforms-to" => ["https://semanticscience.org/resource/CHEMINF_000047", "http://semanticscience.org/resource/conforms-to"],
             
}




# all params are passed as a hash, and retrieved by params.fetch(paramName)
#
# @param params [Hash]  params   a Hash of options
# @option params [String] :baseURI a URL that will become the base for "urls owned by the data provider" e.g. "https://my.dataset.org/thisdataset/records/"
# @option params [String] :source_name   a "short name" (i.e. a single word, no spaces) for the kind of data being transformed.  e.g. height_data
# @option params [Integer] :sio_verbose (0)  "1" means to use http://semanticscience.org/resource/has-value instead of http://semanticscience.org/resource/SIO_000300 for all sio.  Default is 0
#
# @return [YARRRML_Template_BuilderII]
#
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
    @personid_column = params.fetch(:personid_column, 'pid')
    @uniqueid_column = params.fetch(:uniqueid_column, 'uniqid')
    
    identifier_type = params.fetch(:identifier_type,  SIO["identifier"][self.sio_verbose])
    identifier_type_column = params.fetch(:identifier_type_column, nil)
    person_type = params.fetch(:person_type, SIO["person"][self.sio_verbose])
    person_type_column = params.fetch(:person_type_column, nil)
    person_role_tag = params.fetch(:person_role_tag, 'thisRole')
    role_type = params.fetch(:role_type, 'obo:OBI_0000093')  # patient
    role_type_column = params.fetch(:role_type_column, nil)  # 
    role_label = params.fetch(:role_label, 'Patient Role')  # patient
    role_label_column = params.fetch(:role_label_column, nil)  # 

    identifier_type = identifier_type_column ? "$(#{identifier_type_column})":identifier_type
    person_type = person_type_column ? "$(#{person_type_column})":person_type
    role_type = role_type_column ? "$(#{role_type_column})":role_type
    role_label = role_label_column ? "$(#{role_label_column})":role_label

    abort "You MUST have a @personid_column and a @uniqueid_column to use this library.  Sorry!" unless @personid_column and @uniqueid_column
    @mappings << mapping_clause(
                             "identifier_has_value_for_#{person_role_tag}",
                             ["#{source_tag}-source"],
                             "this:individual_$(#{@personid_column})#ID",
#                             "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})#ID",
                             [[SIO["has-value"][self.sio_verbose], "$(#{@personid_column})", "xsd:string"]]
                             )

    @mappings << mapping_clause(
                                  "identifier_denotes_role_#{person_role_tag}",
                                  ["#{source_tag}-source"],
                                  "this:individual_$(#{@personid_column})#ID",
#                                  "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})#ID",
                                  [
                                   ["a", "#{identifier_type}", "iri"],
                                   ["a", SIO["identifier"][self.sio_verbose], "iri"],
                                   [SIO["denotes"][self.sio_verbose], "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{person_role_tag}", "iri"],
                                  ]
                                 )
    @mappings << mapping_clause(
                                "person_has_role_#{person_role_tag}",
                                ["#{source_tag}-source"],
                                "this:individual_$(#{@personid_column})#Person",
                                [
                                 ["a", "#{person_type}", "iri"],
                                 ["a", SIO["person"][self.sio_verbose], "iri"],
                                 [SIO["has-role"][self.sio_verbose], "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{person_role_tag}", "iri"],
                                ]
                               )

    @mappings << mapping_clause(
                                "#{person_role_tag}_annotation",
                                ["#{source_tag}-source"],
                                "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{person_role_tag}",
                                [
                                  ["a", "#{role_type}", "iri"],
                                  ["a", SIO["role"][self.sio_verbose], "iri"],
                                  ["rdfs:label", "#{role_label} Role", "xsd:string"],
                                ]
                               )    
  
  end
  
  

# creates the role_in_process portion of the CDE
#
# Parameters passed as a hash
#
# @param params [Hash]  a hash of options
# @option params :person_role_tag  [String] the tag of the role that is fulfilled in this process (default 'thisRole') - see person_role_tag above, synchronize these tags!
# @option params :process_type  [String] the URL for the ontological type of the process (defaults to http://semanticscience.org/resource/process)
# @option params :process_type_column  [String] the column header that contains the URL for the ontological type of the process - overrides process_type
# @option params :process_tag  [String] some single-word tag for that process; defaults to "thisprocess"
# @option params :process_label  [String] the label associated with the process type in that row (defaults to "thisprocess")
# @option params :process_label_column  [String] the column header for the label associated with the process type in that row
# @option params :process_start_column  [ISO 8601 date (only date)] (optional) the column header for the datestamp when that process started. NOTE:  For instantaneous processes, create ONLY the start date column, and an identical end date will be automatically generated
# @option params :process_end_column  [ISO 8601 date (only date)]  (optional) the column header for the datestamp when that process ended
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.
  def role_in_process(params)
    person_role_tag = params.fetch(:person_role_tag, 'thisRole')
    process_type = params.fetch(:process_type, SIO["process"][self.sio_verbose])  
    process_type_column = params.fetch(:process_type_column, nil)  
    process_tag  = params.fetch(:process_tag, 'thisprocess')  # some one-word name
    process_label = params.fetch(:process_label, 'Process') 
    process_label_column = params.fetch(:process_label_column, nil) 
    process_start_column = params.fetch(:process_start_column, nil) 
    process_end_column = params.fetch(:process_end_column, nil)
    make_unique_process = params.fetch(:make_unique_process, true)

    process_type = process_type_column ? "$(#{process_type_column})":process_type
    process_label = process_label_column ? "$(#{process_label_column})":process_label

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
             ["rdfs:label","#{process_label} Process", "xsd:string"],
           ]
           )      
      
      
    if process_start_column
      @mappings << mapping_clause(
        "#{process_tag}_process_annotation_start",
          ["#{source_tag}-source"],
           root_url + "##{process_tag}",
           [[SIO["has-start-time"][self.sio_verbose], root_url + "##{process_tag}_startdate_$(#{process_start_column})", "iri"]]
           )
      @mappings << mapping_clause(
        "#{process_tag}_process_annotation_start_value",
          ["#{source_tag}-source"],
           root_url + "##{process_tag}_startdate_$(#{process_start_column})",
           [
             [SIO["has-value"][self.sio_verbose], "$(#{process_start_column})", "xsd:date"],
             ["rdf:type", SIO["start-date"][self.sio_verbose], "iri"],             
             ]
           )
      # now create the mirror end time, if one is not provided
      unless process_end_column
        @mappings << mapping_clause(
          "#{process_tag}_process_annotation_end",
            ["#{source_tag}-source"],
             root_url + "##{process_tag}",
             [[SIO["has-end-time"][self.sio_verbose], root_url + "##{process_tag}_enddate_$(#{process_start_column})", "iri"]]
        )
        @mappings << mapping_clause(
          "#{process_tag}_process_annotation_end_value",
            ["#{source_tag}-source"],
             root_url + "##{process_tag}_enddate_$(#{process_start_column})",
             [
               [SIO["has-value"][self.sio_verbose], "$(#{process_start_column})", "xsd:date"],
               ["rdf:type", SIO["end-date"][self.sio_verbose], "iri"],             
               ]
        )
      end

    end
    
    if process_end_column
      @mappings << mapping_clause(
        "#{process_tag}_process_annotation_end",
          ["#{source_tag}-source"],
           root_url + "##{process_tag}",
           [[SIO["has-end-time"][self.sio_verbose], root_url + "##{process_tag}_enddate_$(#{process_end_column})", "iri"]]
           )
      @mappings << mapping_clause(
        "#{process_tag}_process_annotation_end_value",
          ["#{source_tag}-source"],
           root_url + "##{process_tag}_enddate_$(#{process_end_column})",
           [
             [SIO["has-value"][self.sio_verbose], "$(#{process_end_column})", "xsd:date"],
             ["rdf:type", SIO["end-date"][self.sio_verbose], "iri"],             
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
# @option params :process_with_target_tag  [String] (required) the same process tag that is used in the "role in process" for which this is the input
# @option params :target_type_tag  [String] a tag to differentiate this input from other inputs
# @option params :target_type  [String] the ontological type for the target  (e.g. process is targetted at creatinine - http://purl.obolibrary.org/obo/CHEBI_16737)
# @option params :target_type_column  [String] the column header specifying the ontological type for the input node (overrides input_type).  Ignored if using output from another process (specify it there!)
# @option params :target_type_label  [String] the label for all inputs
# @option params :target_type_label_column  [String] the label column for each input
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
          ["rdfs:label","#{target_label} Process Target", "xsd:string"],
          ]
        )
    
  end
  





# creates the process conforms to portion of the CDE
#
# Parameters passed as a hash
#
# @param params [Hash]  a hash of options
# @option params :process_with_protocol_tag  [String] (required) the same process tag that is used in the "role in process" for which this is the input
# @option params :protocol_type_tag  [String] a tag to differentiate this input from other inputs
# @option params :protocol_type  [String] ("http://purl.obolibrary.org/obo/NCIT_C42651" - protocol)
# @option params :protocol_type_label  [String] ("protocol")
# @option params :protocol_uri  [String] uri of the process protocol for all inputs
# @option params :protocol_uri_column  [String] column header for the protocol uri column
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.
  def process_conforms_to(params)
    process_with_target_tag  = params.fetch(:process_with_target_tag, "thisprocess")  # some one-word name
    protocol_type_tag  = params.fetch(:protocol_type_tag, "thisTarget")  # some one-word name
    protocol_type  = params.fetch(:protocol_type, "http://purl.obolibrary.org/obo/NCIT_C42651")  # Protocol
    protocol_type_label  = params.fetch(:protocol_type_label, "Protocol")  # some one-word name
    protocol_uri  = params.fetch(:protocol_uri, nil)  # Protocol
    protocol_uri_column  = params.fetch(:protocol_uri_column, nil)  # some one-word name
    make_unique_process = params.fetch(:make_unique_process, true)

    root_url = get_root_url(make_unique_process)
    
    
    abort "must specify the process_with_target_tag
    (the identifier of the process that has the input)
    before you can use the process_has_target function" unless process_with_target_tag

    protocol_uri = protocol_uri_column ? "$(#{protocol_uri_column})":protocol_uri

    abort "must specify either a default protocol URI, or a column of protocol URIs" unless process_with_target_tag

    @mappings << mapping_clause(
        "#{process_with_target_tag}_has_target_#{protocol_type_tag}",
        ["#{source_tag}-source"],
        root_url + "##{process_with_target_tag}",
        [[SIO["conforms-to"][self.sio_verbose], protocol_uri, "iri"]]
        )
    
    @mappings << mapping_clause(
        "#{process_with_target_tag}_has_target_#{protocol_type_tag}_annotation",
        ["#{source_tag}-source"],
        protocol_uri,
        [
          ["rdf:type",SIO["information-content-entity"][self.sio_verbose], "iri"],
          ["rdf:type","#{protocol_type}", "iri"],
          ["rdfs:label","#{protocol_type_label} Protocol", "xsd:string"],
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
          ["rdfs:label","#{input_label} Process Input", "xsd:string"],
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
              [["rdfs:label","#{output_type_label} Output Type", "xsd:string"]]
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
    
  
    #if output_timeinstant_column
    #  
    #  @mappings << mapping_clause(
    #    "#{process_with_output_tag}_output_annotation_timeinstant",
    #      ["#{source_tag}-source"],
    #      "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{process_with_output_tag}_Output",
    #       [
    #         [SIO["has-value"][self.sio_verbose], "$(#{output_timeinstant_column})", "xsd:date"],
    #         ["rdf:type", SIO["time-instant"][self.sio_verbose], "iri"],             
    #         ]
    #       )
    #end

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
#@option params  :is_attribute  [Boolean]  (true)  is this output an attribute of the patient?
#@option params  :base_types [Array] ([])  an array of ontology terms that will be applied as the rdf:type for all the referred-to quality/attribute

  def input_output_refers_to(params)
    inout_process_tag = params.fetch(:inout_process_tag, 'unidentifiedProcess')
    refers_to_tag = params.fetch(:refers_to_tag, nil)
    inout_refers_to = params.fetch(:inout_refers_to, nil)  
    inout_refers_to_label = params.fetch(:inout_refers_to_label, nil) 
    inout_refers_to_column = params.fetch(:inout_refers_to_column, nil)  
    inout_refers_to_label_column = params.fetch(:inout_refers_to_label_column, nil ) 
    is_attribute = params.fetch(:is_attribute, true ) 
    base_types = params.fetch(:base_types, [] ) 
    
    refers_to = inout_refers_to_column ? "$(#{inout_refers_to_column})":inout_refers_to
    refers_to_label = inout_refers_to_label_column ? "$(#{inout_refers_to_label_column})":inout_refers_to_label

    abort "must specify in_out_process_tag" unless inout_process_tag
    abort "must specify refers_to_tag" unless refers_to_tag
    #$stderr.puts "is an attribute #{is_attribute}"

          
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
        [SIO["refers-to"][self.sio_verbose], "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{refers_to_tag}_TypedAttributeNode", "iri"]
        ] 
    )

    if is_attribute
      @mappings << mapping_clause(
      "has_attribute_of_inout_from_#{inout_process_tag}",
      ["#{source_tag}-source"],
      "this:individual_$(#{@personid_column})#Person",            
      [
       [SIO["has-attribute"][self.sio_verbose], "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{refers_to_tag}_TypedAttributeNode", "iri"]
      ]
      )
    end

#$stderr.puts types.inspect
    @mappings << mapping_clause(
      "inout_from_#{inout_process_tag}_refers_to_concept_#{refers_to_tag}_type",
      ["#{source_tag}-source"],
      "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{refers_to_tag}_TypedAttributeNode",
      
        types
      
    )


    if refers_to_label    
      @mappings << mapping_clause(
          "inout_from_#{inout_process_tag}_refers_to_concept_#{refers_to_tag}_label",
          ["#{source_tag}-source"],
          "this:individual_$(#{@personid_column})_$(#{@uniqueid_column})##{refers_to_tag}_TypedAttributeNode",
          [
          ["rdfs:label", "#{refers_to_label} Attribute" ] 
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
  

# creates a time-based locally-unique identifier

  def get_uniq_id
        return  Time.now.to_f.to_s.gsub("\.", "") 
      
  end


end
