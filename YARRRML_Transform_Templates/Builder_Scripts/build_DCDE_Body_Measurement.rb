require "yarrrml-template-builder"

# pid,uniqid,qualityURI,qualityLabel,processURI,processLabel,protocolURI,protocolLabel,value,valueDatatype,unitURI,unitLabel,date,comments
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
# @option params :process_type  [String] ("sio:process" - process) usually you want to be more specific, like "measuring" or "estimating"
# @option params :process_type_column  [String] ("sio:process" - process)
# @option params :process_type_label  [String] ("protocol")
# @option params :process_type_label_column [String] ("protocol")
# @option params :protocol_uri  [String] uri of the process protocol for all inputs
# @option params :protocol_uri_column  [String] column header for the protocol uri column
# @option params :protocol_label  [String] label of the process protocol for all inputs
# @option params :protocol_label_column  [String] column header for the label for the protocol uri
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to b

# pid,uniqid,qualityURI,qualityLabel,processURI,processLabel,protocolURI,protocolLabel,value,valueDatatype,unitURI,unitLabel,date,comments

b.process_is_specified_by({
    process_with_target_tag:  "some_body_quality_measuring_process",
    protocol_type_tag: "body_measuring_process_protocol",
    process_type_column: "processURI",
    process_type_label_column: "processLabel",
    protocol_uri_column: "protocolURI", 
    protocol_label_column: "protocolLabel",  
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