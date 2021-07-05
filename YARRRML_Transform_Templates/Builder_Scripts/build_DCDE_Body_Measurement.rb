require "yarrrml-template-builder"

# pid,uniqid,qualityURI,qualityLabel,processURI,processLabel,value,valueDatatype,unitURI,unitLabel,date,comments

b = YARRRML_Template_Builder.new({
  source_tag: "body_measurement",
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


# @param params [Hash]  a hash of options
# @option params :process_with_protocol_tag  [String] (required) the same process tag that is used in the "role in process" for which this is the input
# @option params :protocol_type_tag  [String] a tag to differentiate this input from other inputs
# @option params :protocol_type  [String] ("http://purl.obolibrary.org/obo/NCIT_C42651" - protocol)
# @option params :protocol_type_label  [String] ("protocol")
# @option params :protocol_uri  [String] uri of the process protocol for all inputs
# @option params :protocol_uri_column  [String] column header for the protocol uri column
b.process_conforms_to({
    process_with_target_tag:  "some_body_quality_measuring_process",
    protocol_type_tag: "process_protocol",
    protocol_uri_column: "protocolURI",  # informed consent form (input)
})


b.process_hasoutput_output({
    process_with_output_tag: "some_body_quality_measuring_process",
    output_value_column: "value",
    output_value_datatype_column: "valueDatatype",
    output_comments_column: "comments",
    })

b.output_has_unit({
    inout_process_tag: "some_body_quality_measuring_process",
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