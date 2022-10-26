require "yarrrml-template-builder"

#"pid,uniqid,ordo_uri, diagnostic_opinion, date


b = YARRRML_Template_Builder.new({
  source_tag: "cde_patient_diagnosis",
  sio_verbose: 1,
  }
  )

b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_diagnosis",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Diagnosis Patient"
                                    })

# ===============================================

b.role_in_process({
    person_role_tag: "patientRole_diagnosis",
    process_tag:  "medical_diagnosis",
    process_label: "medical diagnosis", 
    process_type: "http://semanticscience.org/resource/SIO_001001",  # medical diagnosis
    process_start_column: "date",

    })

# ===================================================================================
# ===================================================================================
# ===================================================================================


b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process_diseaseX",
  part_process_tag: "medical_diagnosis",
  parent_unique_process: false,
})

# ===================================================================================
# ===================================================================================

# ========================================Diagnosis===========================================
#"pid,uniqid,ordo_uri, diagnostic_opinion, date
b.process_hasoutput_output({
    process_with_output_tag: "medical_diagnosis",  # connect to the correct process
    output_type: "http://semanticscience.org/resource/SIO_001003",  # diagnostic_opinion
    output_type_label_column: "diagnostic_opinion",
    output_value_column: "diagnostic_opinion"
    })

b.input_output_refers_to({
  inout_process_tag:   "medical_diagnosis",  # connect to the correct process
  refers_to_tag: "medical_diagnosis_attribute",
  inout_refers_to_column: "ordo_uri",
  inout_refers_to_label_column: "diagnostic_opinion",
  is_attribute: true,
})

puts b.generate
