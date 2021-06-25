require "yarrrml-template-builder"

#"pid,uniqid,url,result_uri,result_label
#http://purl.obolibrary.org/obo/ICO_0000196


b = YARRRML_Template_Builder.new({
  source_tag: "cde_patient_consent",
  sio_verbose: 1,
  }
  )


b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_consent",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Patient for status recording"
                                    })
# ===============================================

b.role_in_process({
    person_role_tag: "patientRole_consent",
    process_tag:  "patient_consenting",
    process_label: "consenting process", 
    process_type: "http://purl.obolibrary.org/obo/OBI_0000810", # informed consent process
    process_start_column: "date"
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

b.process_has_input({
    process_with_input_tag:  "patient_consenting",
    input_type: "http://purl.obolibrary.org/obo/ICO_0000001",  # informed consent form (input)
    input_type_tag: "consent_document",
    input_has_value_column: "url" 
})


#======================================

b.process_hasoutput_output({
    process_with_output_tag: "patient_consenting",  # connect to the correct process
    output_type_label: "Patient Consent Record",
    output_value_column: "result_label",
    output_start_column: "date"
    })
b.input_output_refers_to({
  refers_to_tag: "consent_attribute",
  inout_process_tag:   "patient_consenting",  # connect to the correct process
  inout_refers_to_column: "result_uri"  # the URI of the type of consent obtained (e.g, http://purl.obolibrary.org/obo/OBIB_0000488 (willingness to be contacted))
})



puts b.generate