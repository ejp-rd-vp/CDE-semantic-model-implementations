require "yarrrml-template-builder"

# pid,uniqid,processURI,processLabel,material_tested,material_tested_label,target,target_label,value,valueDatatype,unitURI,unitLabel,date,comments

b = YARRRML_Template_Builder.new({
  source_tag: "laboratory_measurement",
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
    process_tag:  "some_laboratory_measuring_process",
    process_label_column: "processLabel", 
    process_start_column: "date", 
    })

# ===================================================================================
# ========================================Input===========================================
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

# pid,uniqid,processURI,processLabel,material_tested,material_tested_label,target,target_label,value,valueDatatype,unitURI,unitLabel,date,comments

b.process_has_input({
    process_with_input_tag:  "some_laboratory_measuring_process",
    input_type_tag: "material_tested",
    input_type_column: "material_tested",  # informed consent form (input)
    input_type_label_column: "material_tested_label",
})

# @param params [Hash]  a hash of options
# @option params :process_with_target_tag  [String] (required) the same process tag that is used in the "role in process" for which this is the input
# @option params :target_type_tag  [String] a tag to differentiate this input from other inputs
# @option params :target_type  [String] the ontological type for the target  (e.g. process is targetted at creatinine - http://purl.obolibrary.org/obo/CHEBI_16737)
# @option params :target_type_column  [String] the column header specifying the ontological type for the input node (overrides input_type).  Ignored if using output from another process (specify it there!)
# @option params :target_type_label  [String] the label for all inputs
# @option params :target_type_label_column  [String] the label column for each input
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.

b.process_has_target({
    process_with_target_tag:  "some_laboratory_measuring_process",
    target_type_tag: "target_entity",
    target_type_column: "target",  # informed consent form (input)
    target_type_label_column: "target_label",
})


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

#b.input_output_refers_to({
# inout_process_tag: "some_body_quality_measuring_process",
# refers_to_tag: "measured_attribute",
# inout_refers_to_column: "qualityURI",
# inout_refers_to_label_column: "qualityLabel",
# is_attribute: true,
# base_types: ["http://semanticscience.org/resource/SIO_000614"]  # attribute  
#})

puts b.generate