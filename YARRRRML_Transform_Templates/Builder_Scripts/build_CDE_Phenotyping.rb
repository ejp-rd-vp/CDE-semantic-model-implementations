require "yarrrml-template-builder"

#"pid,uniqid,status,statusLabel,date_of_death,"


b = YARRRML_Template_Builder.new({
  baseURI: "https://w3id.org/duchenne-fdp/data/",
  source_tag: "cde_patient_disease_progression",
  sio_verbose: 1,
  }
  )

b.add_prefixes(
               prefixesHash: {
  "HP" => "http://purl.obolibrary.org/obo/HP_"
})

b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "long_information_gathering_role",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Patient for longitudinal information gathering"
                                    })



b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_symptom_onset",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Symptom Onset Patient"
                                    })


b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_first_contact",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "First Contact Patient"
                                    })


b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_diagnosis",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Diagnosis Patient"
                                    })



b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_genetic_diagnosis",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Genetic Diagnosis Patient"
                                    })

b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_phenotyping",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Phenotyping Patient"
                                    })


b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_status",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Patient for status recording"
                                    })
# ===============================================
b.role_in_process({
    person_role_tag: "long_information_gathering_role",
    process_tag:  "longitudinal_information_gathering_process",
    process_label: "patient longitudinal data collection",
    process_type: "http://semanticscience.org/resource/SIO_001052", # data collection
    make_unique_process: false,
    })

b.role_in_process({
    person_role_tag: "patientRole_symptom_onset",
    process_tag:  "patientRole_symptom_onset_process",
    process_label: "data collection - symptom onset date recording process",
    process_type: "http://semanticscience.org/resource/SIO_001052", # data collection
    })


b.role_in_process({
    person_role_tag: "patientRole_first_contact",
    process_tag:  "patientRole_first_contact_process",
    process_label: "first confirmed visit",
    process_type: "http://purl.obolibrary.org/obo/NCIT_C159705", # first confirmed visit
    })
b.process_has_annotations({
    process_tag:  "patientRole_first_contact_process",
    process_annotations: [["rdf:type", "http://purl.obolibrary.org/obo/NCIT_C16205", "iri"]], # healthcare activity
})
b.process_has_annotations({
    process_tag:  "patientRole_first_contact_process",
    process_annotations_columns: [["http://semanticscience.org/resource/SIO_000669", "first_contact_date", "xsd:date"]], # healthcare activity
})


b.role_in_process({
    person_role_tag: "patientRole_genetic_diagnosis",
    process_tag:  "patientRole_genetic_diagnosis_process",
    process_label: "genetic testing",
    process_type: "http://purl.obolibrary.org/obo/NCIT_C15709",  # genetic testing
    })

b.role_in_process({
    person_role_tag: "patientRole_phenotyping",
    process_tag:  "patientRole_phenotyping_process",
    process_label: "comparative phenotypic assessment",
    process_type: "http://purl.obolibrary.org/obo/OBI_0001546", # comparative phenotypic assessment
    })

b.role_in_process({
    person_role_tag: "patientRole_diagnosis",
    process_tag:  "medical_diagnosis",
    process_label: "medical diagnosis", 
    process_type: "http://semanticscience.org/resource/SIO_001001",  # medical diagnosis
    })

b.role_in_process({
    person_role_tag: "patientRole_status",
    process_tag:  "patient_status",
    process_label: "patient status", 
    process_type: "http://semanticscience.org/resource/SIO_001052", # data collection
    })

# ===================================================================================
# ===================================================================================
# ===================================================================================
b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process",
  part_process_tag: "patientRole_symptom_onset_process",
  parent_unique_process: false,
})

b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process",
  part_process_tag: "patientRole_first_contact_process",
  parent_unique_process: false,
})

b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process",
  part_process_tag: "patientRole_genetic_diagnosis_process",
  parent_unique_process: false,
})

b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process",
  part_process_tag: "patientRole_phenotyping_process",
  parent_unique_process: false,
})

b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process",
  part_process_tag: "medical_diagnosis",
  parent_unique_process: false,
})

b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process",
  part_process_tag: "patient_status",
  parent_unique_process: false,
})

# ===================================================================================
# ===================================================================================


# =====================================ONSET==============================================
#"pid,uniqid, first_contact_date, symptom_onset_age,

b.process_hasoutput_output({
    process_with_output_tag: "patientRole_symptom_onset_process",  # connect to the correct process
    output_type: "http://purl.obolibrary.org/obo/NCIT_C124353",  # symptom onset
    output_type_label: "age at onset",
    output_value_column: "symptom_onset_age",
    output_value_datatype: "xsd:dateTime"
    })


# ========================================GENETIC DIAGNOSIS===========================================
#"pid,uniqid, first_contact_date, symptom_onset_age, hgvs_variant
b.process_hasoutput_output({
    process_with_output_tag: "patientRole_genetic_diagnosis_process",  # connect to the correct process
    output_type: "http://semanticscience.org/resource/SIO_001381",  # symptom onset
    output_type_label: "genome sequence variant",
    output_value_column: "hgvs_variant",
    })


# ========================================Phenotyping===========================================
#"pid,uniqid, first_contact_date, symptom_onset_age, hgvs_variant, HP1, HP2, HP3, HP4, HP5 
b.process_hasoutput_output({
    process_with_output_tag: "patientRole_phenotyping_process",  # connect to the correct process
    output_type: "http://semanticscience.org/resource/SIO_010056",  # phenotype
    output_type_label: "phenotypic observations",
    })

b.input_output_refers_to({
  inout_process_tag:   "patientRole_phenotyping_process",  # connect to the correct process
  inout_refers_to_columns: ["HP1", "HP2", "HP3", "HP4", "HP5", "HP6", "HP7", "HP8", "HP9", "HP10"],
  inout_refers_to_label_columns: ["HP1L", "HP2L", "HP3L", "HP4L", "HP5L", "HP6L", "HP7L", "HP8L", "HP9L", "HP10L"]
})
b.person_has_attribute({
  inout_process_tag:   "patientRole_phenotyping_process",  # connect to the correct process
  inout_refers_to_columns: ["HP1", "HP2", "HP3", "HP4", "HP5", "HP6", "HP7", "HP8", "HP9", "HP10"]  
})

#b.input_output_refers_to({
#  inout_process_tag:   "patientRole_phenotyping_process",  # connect to the correct process
#  inout_refers_to_columns: ["HP1",],
#  inout_refers_to_label_columns: ["HP1L", ]
#})
#b.person_has_attribute({
#  inout_process_tag:   "patientRole_phenotyping_process",  # connect to the correct process
#  inout_refers_to_columns: ["HP1",]  
#})



# ========================================Diagnosis===========================================
#"pid,uniqid, first_contact_date, symptom_onset_age, hgvs_variant, HP1, HP2, HP3, HP4, HP5,... ordo_uri, diagnostic_opinion, date
b.process_hasoutput_output({
    process_with_output_tag: "medical_diagnosis",  # connect to the correct process
    output_type: "http://semanticscience.org/resource/SIO_001003",  # diagnostic_opinion
    output_type_label: "diagnostic_opinion",
    output_start_column: "date"
    })

b.input_output_refers_to({
  inout_process_tag:   "medical_diagnosis",  # connect to the correct process
  inout_refers_to_columns: ["ordo_uri"]
})
b.person_has_attribute({
  inout_process_tag:   "medical_diagnosis",  # connect to the correct process
  inout_refers_to_columns: ["ordo_uri"]
})





# ========================================Status===========================================
#"pid,uniqid, first_contact_date, symptom_onset_age, hgvs_variant, HP1, HP2, HP3, HP4, HP5, ordo_uri, diagnostic_opinion, date status_label, status_uri, death_date


b.process_hasoutput_output({
    process_with_output_tag: "patient_status",  # connect to the correct process
    output_type_label_column: "status_label",
    output_value_column: "status_label",
    output_end_column: "death_date"
    })
b.input_output_refers_to({
  inout_process_tag:   "patient_status",  # connect to the correct process
  inout_refers_to_columns: ["status_uri"]
})
b.person_has_attribute({
  inout_process_tag:   "patient_status",  # connect to the correct process
  inout_refers_to_columns: ["status_uri"]
})



puts b.generate