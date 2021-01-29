require 'tempfile'
require 'rest-client'
require 'yaml'


class YARRRML_Template_BuilderII
  
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

  attr_accessor :quality_type
  attr_accessor :quality_type_column
  attr_accessor :quality_tag
  attr_accessor :quality_label
  attr_accessor :quality_label_column

  attr_accessor :output_nature  # qualitative or quantitative
  attr_accessor :output_type
  attr_accessor :output_type_column
  attr_accessor :output_type_label
  attr_accessor :output_type_label_column
  attr_accessor :output_value_column
  attr_accessor :output_comments_column
  attr_accessor :output_value_datatype
  attr_accessor :output_value_datatype_column
  
  attr_accessor :output_unit
  attr_accessor :output_unit_column
  attr_accessor :output_unit_label_column
  attr_accessor :output_unit_label
  
  
  
  attr_accessor :mappings  

  SIO = {"has-attribute" => ["sio:has-attribute", "sio:SIO_000008"], 
"has-quality" => ["sio:SIO_000217", "sio:has-quality"],
"has-unit" => ["sio:SIO_000221", "sio:has-unit"],
"has-value" => ["sio:SIO_000300", "sio:has-value"],
"has-role" => ["sio:SIO_000228", "sio:has-role"],
"is-participant-in" => ["sio:SIO_000062", "sio:is-participant-in"],
"is-about" => ["sio:SIO_000332", "sio:is-about"],
"has-output" => ["sio:SIO_000229", "sio:has-output"],
"denotes" => ["sio:SIO_000020", "sio:denotes"],
"is-realized-in" => ["sio:SIO_000356", "sio:is-realized-in"],
"start-time" => ["sio:SIO_000669", "sio:start-time"],
"end-time" => ["sio:SIO_000670", "sio:end-time"],
"is-component-part-of" => ["sio:SIO_000313", "sio:is-component-part-of"],
"drug" => ["sio:SIO_010038", "sio:drug"],
"is-base-for" => ["sio:SIO_000642", "sio:is-base-for"],
"has-concretization" => ["sio:SIO_000213", "sio:has-concretization"],
"realizable-entity" =>  ["sio:SIO:000340", "sio:realizable-entity"],
"measurement-value" => ["sio:SIO_000070", "sio:measurement-value"],
}

# Creates the Template Builder object
#
# all params are passed as a hash, and retrieved by params.fetch(paramName)
#
# @param baseURI [string] a URL that will become the base for "urls owned by the data provider" e.g. "http://my.dataset.org/thisdataset/records/"
# @param source_name [string]  a "short name" (i.e. a single word, no spaces) for the kind of data being transformed.  e.g. height_data
# @param sio_verbose [0/1]  "1" means to use sio:has-value instead of sio:SIO_000300 for all sio.  Default is 0
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
      "sio" => "https://semanticscience.org/resource/",
      "vocab" => "https://ejp-rd.eu/vocab/", 
      "pico" => "http://data.cochrane.org/ontologies/pico/",
      "ndfrt" => "http://purl.bioontology.org/ontology/NDFRT/",
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
    
    self.mappings.each {|m| clauses.merge!(m); $stderr.puts m; $stderr.puts "CLAUSES: #{clauses}\n\n"}
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
    
    @identifier_type = params.fetch(:identifier_type, 'https://ejp-rd.eu/vocab/identifier')
    @identifier_type_column = params.fetch(:identifier_type_column, nil)
    @person_type = params.fetch(:person_type, 'https://ejp-rd.eu/vocab/Person')
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
                                   [SIO["denotes"][self.sio_verbose], "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.person_role_tag}", "iri"],
                                  ]
                                 )
    @mappings << mapping_clause(
                                "person_has_role",
                                ["#{self.source_tag}-source"],
                                "this:individual_$(#{self.personid_column})#Person",
                                [
                                 ["a", "#{person_type}", "iri"],
                                 [SIO["has-role"][self.sio_verbose], "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.person_role_tag}", "iri"],
                                ]
                               )

    @mappings << mapping_clause(
                                "#{self.person_role_tag}_annotation",
                                ["#{self.source_tag}-source"],
                                "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.person_role_tag}",
                                [["a", "#{role_type}", "iri"],
                                 ["rdfs:label", "#{role_label}", "xsd:string"],
                                ]
                               )    
  
  end
  
  

# creates the role_in_process portion of the CDE
#
# Parameters passed as a hash
#
# @param [:process_type] (URI) the URL for the ontological type of the process (defaults to sio:process)
# @param [:process_type_column] (string) the column header that contains the URL for the ontological type of the process - overrides process_type
# @param [:process_tag] (string) some single-word tag for that process; defaults to "thisprocess"
# @param [:process_label] (string) the label associated with the process type in that row (defaults to "thisprocess")
# @param [:process_label_column] (string) the column header for the label associated with the process type in that row
# @param [:process_start_column] (string) (optional) the column header for the timestamp when that process started
# @param [:process_end_column] (string)  (optional) the column header for the timestamp when that process ended
#  
  def role_in_process(params)
    @process_type = params.fetch(:process_type, "sio:process")  
    @process_type_column = params.fetch(:process_type_column, nil)  
    @process_tag  = params.fetch(:process_tag, 'thisprocess')  # some one-word name
    @process_label = params.fetch(:process_label, 'thisprocess') 
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
           [["rdf:type","#{process_type}", "iri"],
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
  
  
  

# creates the person_has_quality portion of the CDE
#
# Parameters passed as a hash
#
# @param [:quality_type] (URL) the URL for the ontological type of the quality (defaults to sio:quality)
# @param [:quality_type_column] (string) the column header that contains the URL for the ontological type of the quality (overrides quality_type)
# @param [:quality_tag] (string) some single-word tag for that process; defaults to "someQuality"
# @param [:quality_label] (string) the the label associated with the quality type in that row (defaults to 'quality')
# @param [:quality_label_column] (string) the column header for the label associated with the quality type in that row (overrides quality_label)
#  
  def person_has_quality(params)
    @quality_type = params.fetch(:quality_type, "sio:quality")  
    @quality_type_column = params.fetch(:quality_type_column, nil)  
    @quality_tag  = params.fetch(:quality_tag, "someQuality")  # some one-word name
    @quality_label = params.fetch(:quality_label, "quality") 
    @quality_label_column = params.fetch(:quality_label_column, nil)
    
    quality_type = self.quality_type_column ? "$(#{self.quality_type_column})":self.quality_type
    quality_label = self.quality_label_column ? "$(#{self.quality_label_column})":self.quality_label

        
    
      @mappings << mapping_clause(
          "person_has_#{self.quality_tag}_quality",
          ["#{self.source_tag}-source"],
          "this:individual_$(#{self.personid_column})#Person",
          [[SIO["has-quality"][self.sio_verbose],"this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.quality_tag}","iri"]]
          )

      @mappings << mapping_clause(
        "#{self.quality_tag}_quality_annotation",
          ["#{self.source_tag}-source"],
          "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.quality_tag}",
          [["rdf:type", "#{quality_type}", "iri"],
           ["rdfs:label","#{quality_label}", "xsd:string"]
          ]
          )
    
  end
  


# creates the quality_basisfor_measurement portion of the CDE
#
# Parameters passed as a hash
#
# NOTE!! You must have already used the person_has_quality(params) and role_in_process(params) methods for this call to succeed!
#
# no parameters
#  

  def quality_basisfor_measurement(params)
    abort "must have already defined a (optional) quality before calling this routine" unless self.quality_tag
    
    @mappings << mapping_clause(
        "#{self.quality_tag}_quality_basis_for_meas",
        ["#{self.source_tag}-source"],
        "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.quality_tag}",
        [[SIO["is-base-for"][self.sio_verbose], "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output", "iri"]]
        )
  end
  



# creates the process_hasoutput_output portion of the CDE
#
# Parameters passed as a hash
#
# @param [:output_value] (string)  (optional) the default value of that output (defaults to nil, and the output node is not created in the RDF)
# @param [:output_value_column] (string)  (optional) the column header for the value of that output (e.g. the column that contains "80"  for "80 mmHg")
# @param [:output_nature] (string) either 'qualitative' (e.g. "healthy") or 'quantitative' (e.g. 82mmHg)# @param [:process_tag] (string) some single-word tag for that process; defaults to "thisprocess"
# @param [:output_type] (URL) the URL associated with the output ontological type (defaults to sio:realizable-entity)
# @param [:output_type_column] (string) the column header for the URL associated with the output ontological type (overrides output_type)
# @param [:output_type_label] (string) (optional) the the label of that ontological type (defaults to "measurement-value")
# @param [:output_type_label_column] (string) (optional) the column header for the label of that ontological type (overrides output_type_label)
# @param [:output_value_datatype] (xsd:type)  (optional) the xsd:type for that kind of measurement (defaults to xsd:string)
# @param [:output_value_datatype_column] (string)  (optional) the column header for the xsd:type for that kind of measurement (overrides output_value_datatype)
# @param [:output_comments_column] (string)  (optional) the column header for amy textual comments.  text must not contain a comma!!  defaults to nil
#  

  def process_hasoutput_output(params)
    @output_nature = params.fetch(:output_nature, nil)
    abort "must have an output nature of 'qualitative' or 'quantitative'" unless self.output_nature
    
    @output_value = params.fetch(:output_value, nil)
    @output_value_column = params.fetch(:output_value_column, nil)
    @output_type = params.fetch(:output_type, SIO["realizable-entity"][self.sio_verbose])
    @output_type_column = params.fetch(:output_type_column, nil)
    @output_type_label = params.fetch(:output_type_label, "measurement-value")
    @output_type_label_column = params.fetch(:output_type_label_column, nil)
    @output_value_datatype = params.fetch(:output_value_datatype, "xsd:string")
    @output_value_datatype_column = params.fetch(:output_value_datatype_column, nil)
    @output_comments_column = params.fetch(:output_comments_column, nil)


    output_value = self.output_value_column ? "$(#{self.output_value_column})":self.output_value
    output_type = self.output_type_column ? "$(#{self.output_type_column})":self.output_type
    output_type_label = self.output_type_label_column ? "$(#{self.output_type_label_column})":self.output_type_label
    output_value_datatype = self.output_value_datatype_column ? "$(#{self.output_value_datatype_column})":self.output_value_datatype

   return unless output_value
   
    @mappings << mapping_clause(
        "#{self.process_tag}_process_has_output",
        ["#{self.source_tag}-source"],
        "this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}",
        [[SIO["has-output"][self.sio_verbose], "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output", "iri"]]
        )
    if self.output_nature == "quantitative"
          @mappings << mapping_clause(
              "#{self.process_tag}_Output_annotation",
              ["#{self.source_tag}-source"],
              "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output",
              [["rdf:type",SIO["measurement-value"][self.sio_verbose], "iri"]]
              )      
    end
    
    if self.output_type_column
          @mappings << mapping_clause(
              "#{self.process_tag}_Output_type_annotation",
              ["#{self.source_tag}-source"],
              "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output",
              [["rdf:type","#{output_type}", "iri"]]
              )
    end
    
    if self.output_type_label_column
          @mappings << mapping_clause(
              "#{self.process_tag}_Output_type_label_annotation",
              ["#{self.source_tag}-source"],
              "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output",
              [["rdfs:label","#{output_type_label}", "xsd:string"]]
              )
    end
    
    if self.output_value_column
          @mappings << mapping_clause(
              "#{self.process_tag}_Output_value_annotation",
              ["#{self.source_tag}-source"],
              "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output",
              [[SIO["has-value"][self.sio_verbose],"$(#{self.output_value_column})", "#{output_value_datatype}"]]
              )
    end
    
    if self.output_comments_column
          @mappings << mapping_clause(
              "#{self.process_tag}_Output_value_comments",
              ["#{self.source_tag}-source"],
              "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output",
              [["rdfs:comment","$(#{self.output_comments_column})", "xsd:string"]]
              )
    end
        
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
    @output_unit_label_column = params.fetch(:output_unit_label, nil)
    
    output_unit = self.output_unit_column ? "$(#{self.output_unit_column})":self.output_unit
    output_unit_label = self.output_unit_label_column ? "$(#{self.output_unit_label_column})":self.output_unit_label

    if output_unit
      @mappings << mapping_clause(
              "#{self.process_tag}_Output_hasunit_unit",
                ["#{self.source_tag}-source"],
                "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output",
                [[SIO["has-unit"][self.sio_verbose], "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output_unit", "iri"]]
                )

      @mappings << mapping_clause(
              "#{self.process_tag}_Output_hasunit_unit",
                ["#{self.source_tag}-source"],
                "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output",
                [[SIO["has-unit"][self.sio_verbose], "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output_unit", "iri"]]
                )
      @mappings << mapping_clause(
              "#{self.process_tag}_Output_unit_annotation",
              ["#{self.source_tag}-source"],
              "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output_unit",
              [["rdf:type","$(#{output_unit_column})", "iri"]]
              )

    end

    if output_unit_label
    
      @mappings << mapping_clause(
              "#{self.process_tag}_Output_unit_annotation",
              ["#{self.source_tag}-source"],
              "this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output_unit",
              [["rdfs:label","#{output_unit_label}","xsd:string"]
              ]
              )
    end
    

  end
  
end
