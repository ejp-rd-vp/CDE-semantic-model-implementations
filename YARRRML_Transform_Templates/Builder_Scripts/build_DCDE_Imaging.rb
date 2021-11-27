require "yarrrml-template-builder"

# pid,uniqid,processURI,processLabel,protocolURI,target,target_label,imageURI,date,comments

b = YARRRML_Template_Builder.new({
  source_tag: "imaging",
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
    process_tag:  "some_imaging_process",
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
b.process_is_specified_by({
    process_with_target_tag:  "some_imaging_process",
    protocol_type_tag: "process_protocol",
    process_type_column: "processURI",
    process_type_label_column: "processLabel",
    protocol_uri_column: "protocolURI", 
    protocol_label_column: "protocolLabel",  
})

b.process_has_target({
    process_with_target_tag:  "some_imaging_process",
    target_type_tag: "target_entity",
    target_type_column: "target",  
    target_type_label_column: "target_label",
})


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
# @option params :output_start_column  [xsd:date] the column header for start date
# @option params :output_end_column  [xsd:date]   the column header for end date
# @option params :output_timeinstant_column  [xsd:date]   the column header for a time-instant date
# @option params :output_annotations  [Array] Array of Arrays of [[predicate, value, datatype]...] that wiill be applied as annotations to the output of the tagged process (datatype is options, default xsd:string)
# @option params :output_annotations_columns  [Array]   Array of Arrays of [[predicate, value, datatype]...] column headers that will be applied as annotations to the output of the tagged process (datatype is optional, default xsd:string)
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.

# pid,uniqid,processURI,processLabel,protocolURI,target,target_label,imageURI,date,comments

b.process_hasoutput_output({
    process_with_output_tag: "some_imaging_process",
    output_comments_column: "comments",
    output_annotations: [["http://semanticscience.org/resource/SIO_000205", "imageID", "xsd:anyURI"]]
    })


puts b.generate