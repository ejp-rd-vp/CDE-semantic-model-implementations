require "yarrrml-template-builder"

# pid,uniqid,qualityURI,qualityLabel,processURI,processLabel,value,valueDatatype,unitURI,unitLabel,date,comments

b = YARRRML_Template_Builder.new({
  baseURI: "http://marks.test/this/",
  source_tag: "patient_height_experimental",
  sio_verbose: 1,
  }
  )

b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role: "patientRole",
                                    role_type: 'obo:OBI_0000093',
                                    role_label: "Patient"
                                    })
b.role_in_process({
    process_type_column: "processURI",  
    process_tag:  "some_body_quality_measuring_process",
    process_label_column: "processLabel", 
    process_start_column: "date", 
    })

#b.person_has_quality({
#    quality_type_column: "qualityURI",  
#    quality_tag:  "height_quality",
#    quality_label_column: "qualityLabel", 
#    })

b.process_hasoutput_output({
    output_value_column: "value",
    output_value_datatype_column: "valueDatatype",
    output_comments_column: "comments",
    })

b.output_has_unit({
    output_unit_column: "unitURI",
    output_unit_label_column: "unitLabel"  
})


    #:inout_process_tag (String) — default: "unidentifiedProcess"
    #:refers_to_tag (String) — default: nil —
    #
    #required unique one-word tag of an attribute
    #:inout_refers_to (String) — default: [] —
    #
    #an ontology URI
    #:inout_refers_to_column (String) — default: [] —
    #
    #column headers for column of ontologyURIs
    #:inout_refers_to_label (String) — default: [] —
    #
    #an ontology term label
    #:inout_refers_to_label_column (String) — default: [] —
    #
    #column header for column of ontology term labels
    #:is_attribute (Boolean) — default: true —
    #
    #is this output an attribute of the patient?
    #:base_types (Array) — default: [] —
    #
    #an array of ontology terms that will be applied as the rdf:type for all the referred-to quality/attribute

# pid,uniqid,qualityURI,qualityLabel,processURI,processLabel,value,valueDatatype,unitURI, unitLabel,date,comments

b.input_output_refers_to({
 inout_process_tag: "some_body_quality_measuring_process",
 refers_to_tag: "measured_attribute",
 inout_refers_to_column: "qualityURI",
 inout_refers_to_label_column: "qualityLabel",
 is_attribute: true,
 base_types: ["http://semanticscience.org/resource/SIO_000614"]  # attribute  
})

puts b.generate