require "yarrrml-template-builder"

# pid,uniqid,icf_score


b = YARRRML_Template_Builder.new({
  baseURI: "https://w3id.org/duchenne-fdp/data/",
  source_tag: "cde_genetic_diagnosis",
  sio_verbose: 1,
  }
  )


b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_genetic_diagnosis",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Genetic Diagnosis Patient"
                                    })

# ===============================================
b.role_in_process({
    person_role_tag: "patientRole_genetic_diagnosis",
    process_tag:  "patientRole_genetic_diagnosis_process",
    process_label: "genetic testing",
    process_type: "http://purl.obolibrary.org/obo/NCIT_C15709",  # genetic testing
    })

# ===================================================================================
# ===================================================================================
# ===================================================================================

b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process_diseaseX",
  part_process_tag: "patientRole_genetic_diagnosis_process",
  parent_unique_process: false,
})


# ========================================GENETIC DIAGNOSIS===========================================
#"pid,uniqid, hgvs_variant
b.process_hasoutput_output({
    process_with_output_tag: "patientRole_genetic_diagnosis_process",  # connect to the correct process
    output_type: "http://semanticscience.org/resource/SIO_001381",  # genomic sequence variant
    output_type_label: "genome sequence variant",
    output_value_column: "hgvs_variant",
    })



puts b.generate