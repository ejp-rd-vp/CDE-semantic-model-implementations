require 'tempfile'
require 'rest-client'
#Dir[File.join(__dir__, 'config', '*.rb')].each { |file| require file }


@mappings = []

class YARRRML_Template_Builder
  
  attr_accessor :prefixes
  attr_accessor :baseURI  
  attr_accessor :source_name
  attr_accessor :source_module
  

  attr_accessor :personid_column
  attr_accessor :uniqueid_column
  attr_accessor :identifier_type
  attr_accessor :person_type
  attr_accessor :person_role 
  attr_accessor :role_type 
  attr_accessor :role_label
  
  attr_accessor :process_type_column
  attr_accessor :process_tag
  attr_accessor :process_label_column
  attr_accessor :process_start_column
  attr_accessor :process_end_column

  attr_accessor :quality_type_column
  attr_accessor :quality_tag
  attr_accessor :quality_label_column

  attr_accessor :output_nature  # qualitative or quantitative
  attr_accessor :output_type_column
  attr_accessor :output_type_label_column
  attr_accessor :output_value_column
  attr_accessor :output_comments_column
  attr_accessor :output_value_datatype
  
  attr_accessor :output_unit_column
  attr_accessor :output_unit_label
  
  
  
  attr_accessor :mappings  

  def initialize(params = {}) # get a name from the "new" call, or set a default
    
    @baseURI = params.fetch(:baseURI, nil)
    abort "must have a baseURI parameter" unless self.baseURI
    @mappings = []

    @source_name = params.fetch(:source_name, nil)
    abort "must have a source_name parameter" unless self.source_name

    @prefixes = {rdf: "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      rdfs: "http://www.w3.org/2000/01/rdf-schema#",
      ex: "http://ejp-rd.eu/ids/",
      obo: "http://purl.obolibrary.org/obo/",
      sio: "https://semanticscience.org/resource/",
      vocab: "https://ejp-rd.eu/vocab/", 
      pico: "http://data.cochrane.org/ontologies/pico/",
      ndfrt: "http://purl.bioontology.org/ontology/NDFRT/",
      }
    @prefixes[:this] = self.baseURI
    
  end
  
  def add_prefixes(params = {})
    
    prefixesHash = params.fetch(:prefixesHash, {})
    @prefixes.merge(prefixesHash)
    return self.prefixes
    
  end


  def generate
    output = ""
    output += "prefixes:\n"
    @prefixes.each do |tag, val|
      output += "  #{tag.to_s}: #{val}\n"
    end
    output += "\n\n"

    output += self.source_module
    output += "\n\n"

    output += "mappings:\n"
    
    self.mappings.each {|m| output += m}
    
    return output
    
  end
  
  
  
  
  def source_module
    
    @source_module = """  
sources:
  #{self.source_name}-source:
    access: |||DATA|||
    referenceFormulation: |||FORMULATION|||
    iterator: $  

"""
  end
  
  

  def person_identifier_role_mappings(params = {})
    @personid_column = params.fetch(:personid_column, 'pid')
    @uniqueid_column = params.fetch(:uniqueid_column, 'uniqid')
    @identifier_type = params.fetch(:identifier_type, 'https://ejp-rd.eu/vocab/identifier')
    @person_type = params.fetch(:person_type, 'https://ejp-rd.eu/vocab/Person')
    @person_role = params.fetch(:person_role, 'thisRole')
    @role_type = params.fetch(:role_type, 'obo:OBI_0000093')  # patient
    @role_label = params.fetch(:role_label, 'Patient')  # patient

    @mappings << """
  identifier_has_value: 
    sources: 
      - #{self.source_name}-source 
    s: this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})#ID 
    po: 
      - [sio:has-value, $(#{self.personid_column})]
      
  identifier_denotes: 
    sources: 
      - #{self.source_name}-source 
    s: this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})#ID 
    po: 
      - predicates: a 
        objects: 
            value: #{self.identifier_type} 
            type: iri 
      - predicates: sio:denotes 
        objects: 
            value: this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.person_role} 
            type: iri 

  person_has_role: 
    sources: 
      - #{self.source_name}-source
    s: this:individual_$(#{self.personid_column})#Person 
    po: 
      - predicates: a 
        objects: 
            value: #{self.person_type}
            type: iri 
      - predicates: sio:has-role 
        objects: 
            value: this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.person_role}
            type: iri 

  #{self.person_role}_annotation: 
    sources: 
      - #{self.source_name}-source 
    s: this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.person_role}
    po: 
      - [a, obo:OBI_0000093] 
      - [rdfs:label, #{self.role_label}] 

    
"""
    
  
  end
  
  
  def role_in_process(params)
    @process_type_column = params.fetch(:process_type_column, nil)  
    @process_tag  = params.fetch(:process_tag, 'thisprocess')  # some one-word name
    @process_label_column = params.fetch(:process_label_column, nil) 
    @process_start_column = params.fetch(:process_start_column, nil) 
    @process_end_column = params.fetch(:process_end_column, nil) 

    abort "must have a process_type_column" unless self.process_type_column
    abort "must have a process_label_column" unless self.process_label_column
    
    thismapping = """

# Role in Process
       
  #{self.person_role}_realized_#{self.process_tag}:
    sources:
      - #{self.source_name}-source
    s: this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.person_role}
    po:
      - predicates: sio:is-realized-in
        objects:
            value:  this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}
            type: iri

  #{self.process_tag}_process_annotation:
    sources:
      - #{self.source_name}-source
    s: this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}
    po:
      - predicates: rdf:type
        objects:
            value:  $(#{self.process_type_column})
            type: iri
      - predicates: rdfs:label
        objects:
            value:  $(#{self.process_label_column})
            datatype: xsd:string
"""
      
      
      
    if self.process_start_column
      thismapping += """
      - predicates: sio:start-time
        objects:
            value:  $(#{self.process_start_column})
            datatype: xsd:dateTime
"""
    end
    if self.process_end_column
      thismapping += """
      - predicates: sio:end-time
        objects:
            value:  $(#{self.process_end_column})
            datatype: xsd:dateTime
"""
    end
    
    thismapping += "\n\n"
  
    @mappings << thismapping
  
  end
  
  
  def person_has_quality(params)
    @quality_type_column = params.fetch(:quality_type_column, nil)  
    @quality_tag  = params.fetch(:quality_tag, nil)  # some one-word name
    @quality_label_column = params.fetch(:quality_label_column, nil) 
    
    abort "must provide a quality_type_column, quality_tag, and quality_label_column" unless @quality_tag and @quality_type_column and @quality_label_column
    
    
    thismapping = """
# Person has Quality

  person_has_#{self.quality_tag}_quality:
    sources:
      - #{self.source_name}-source
    s: this:individual_$(#{self.personid_column})#Person
    po:
      - predicates: sio:has-quality
        objects:
            value:  this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.quality_tag}
            type: iri

  #{self.quality_tag}_quality_annotation:
    sources:
      - #{self.source_name}-source
    s: this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.quality_tag}
    po:
      - predicates: rdf:type
        objects:
            value:  $(#{self.quality_type_column})
            type: iri
      - predicates: rdfs:label
        objects:
            value:  $(#{self.quality_label_column})
            datatype: xsd:string
            
"""

    mappings << thismapping
    
  end
  
  def quality_basisfor_measurement(params)
    abort "must have already defined a (optional) quality before calling this routine" unless self.quality_tag
    
    thismapping = """

# quality basisfor meas

  #{self.quality_tag}_quality_basis_for_meas:
    sources:
      - #{self.source_name}-source
    s: this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.quality_tag}
    po:
      - predicates: sio:is-basis-for
        objects:
            value:  this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output
            type: iri


"""
    
    mappings << thismapping
    
    
  end
  
  
  def process_hasoutput_output(params)
    @output_nature = params.fetch(:output_nature, nil)
    abort "must have an output nature" unless self.output_nature
    
    @output_type_column = params.fetch(:output_type_column, nil)
    @output_type_label_column = params.fetch(:output_type_label_column, "measurement-value")
    @output_value_column = params.fetch(:output_value_column, nil)
    @output_value_datatype = params.fetch(:output_value_datatype, "xsd:string")
    @output_comments_column = params.fetch(:output_comments_column, nil)
    
    
# Process has Output
    thismapping = """
  #{self.process_tag}_process_has_output:
    sources:
      - #{self.source_name}-source
    s: this:individual_$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}
    po:
      - predicates: sio:has-output
        objects:
            value:  this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output
            type: iri


"""
    if self.output_nature == "quantitative"
      thismapping += """
    
  #{self.process_tag}_Output_annotation:
    sources:
      - #{self.source_name}-source
    s: this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output
    po:
      - predicates: rdf:type
        objects:
            value:  sio:measurement-value
            type: iri"""
      
    end
    
    if self.output_type_column
      thismapping += """
      - predicates: rdf:type
        objects:
            value:  $(#{self.output_type_column})
            type: iri"""
    end
    
    if self.output_type_label_column
      thismapping += """
      - predicates: rdfs:label
        objects:
            value:  $(#{self.output_type_label_column})
            datatype: xsd:string"""
    end
    
    if self.output_value_column
      thismapping += """
      - predicates: sio:has-value
        objects:
            value:  $(#{self.output_value_column})
            datatype: #{self.output_value_datatype}"""              
    end
    
    if self.output_comments_column
      thismapping += """
      - predicates: rdfs:comment
        objects:
            value:  $(#{self.output_comments_column})
            datatype: xsd:string"""
    end
    
    thismapping += "\n\n"

    mappings << thismapping    
    
  end
  
  
  
  
  
  
  
  def output_has_unit(params)

    @output_unit_column = params.fetch(:output_unit_column, nil)  # URI
    @output_unit_label = params.fetch(:output_unit_label, nil)
    abort "need both output unit column and label" unless self.output_unit_column and self.output_unit_label
    

    thismapping = """
  #{self.process_tag}_Output_hasunit_unit:
    sources: 
      - #{self.source_name}-source 
    s: this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output
    po: 
      - predicates: sio:has-unit
        objects: 
            value: this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output_unit
            type: iri

  #{self.process_tag}_Output_unit_annotation:
    sources: 
      - height-source 
    s: this:individual__$(#{self.personid_column})_$(#{self.uniqueid_column})##{self.process_tag}_Output_unit
    po: 
      - predicates: rdf:type
        objects: 
            value: #{self.output_unit_column}
            type: iri
      - predicates: rdfs:label
        objects: 
            value: #{self.output_unit_label}
            datatype: xsd:string"""
              
    thismapping += "\n\n"

    mappings << thismapping
  end
  
end
