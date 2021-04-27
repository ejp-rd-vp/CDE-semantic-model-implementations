require "yarrrml-template-builder"

#pid, uniqid, onset_uri, onset_date, diagnosis_uri, diagnosis_date
  #
  #  * obo:HP_0030674 (Antenatal onset)
  #  * obo:HP_0003577 (Congenital onset)
  #  * obo:NCIT_C124294 (Undetermined) 
  #  * obo:HP_0003674 (onset) - use this when you are going to provide a date
  #* diagnosis_date: ISO 8601 date  (note that the CDE calls this "age", but it is annotated as being a date field...??)
  #
##  TODO



b = YARRRML_Template_Builder.new({
  baseURI: "https://w3id.org/duchenne-fdp/data/",
  source_tag: "cde_patient_disease_history",
  sio_verbose: 1,
  }
  )

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
                                    person_role_tag: "patientRole_diagnosis_date",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Diagnosis Date Patient"
                                    })
# ===============================================

b.role_in_process({
    person_role_tag: "patientRole_symptom_onset",
    process_tag:  "patientRole_symptom_onset_process",
    process_label: "data collection - symptom onset date recording process",
    process_type: "http://semanticscience.org/resource/SIO_001052", # data collection
    })


b.role_in_process({
    person_role_tag: "patientRole_diagnosis_date",
    process_tag:  "patientRole_diagnosis_date_process",
    process_label: "data collection - diagnosis date recording process",
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
  part_process_tag: "patientRole_diagnosis_date_process",
  parent_unique_process: false,
})

# ===================================================================================
# ===================================================================================
# =====================================ONSET==============================================
#pid, uniqid, onset_uri, onset_date, diagnosis_uri, diagnosis_date

b.process_hasoutput_output({
    process_with_output_tag: "patientRole_symptom_onset_process",  # connect to the correct process
    output_type_column: "onset_uri",  # symptom onset
    output_type_label: "'age' at onset",
    output_value_column: "onset_date",
    output_value_datatype: "xsd:dateTime"
    })

# =====================================DIAG DATE==============================================
#pid, uniqid, onset_uri, onset_date, diagnosis_uri, diagnosis_date

b.process_hasoutput_output({
    process_with_output_tag: "patientRole_diagnosis_date_process",  # connect to the correct process
    output_type_column: "diagnosis_uri",  # symptom onset
    output_type_label: "'age' at diagnosis",
    output_value_column: "diagnosis_date",
    output_value_datatype: "xsd:dateTime",
    
    })


#obo:NCIT_C156420 (Age at Diagnosis) 
#obo:NCIT_C124353  (symptom onset)

b.input_output_refers_to({
  refers_to_tag: "age_at_onset",
  inout_process_tag:   "patientRole_symptom_onset_process",  # connect to the correct process
  inout_refers_to: "obo:NCIT_C124353",
  inout_refers_to_label: "Age at onset"
})
b.input_output_refers_to({
  refers_to_tag: "disagnosis_date",
  inout_process_tag:   "patientRole_diagnosis_date_process",  # connect to the correct process
  inout_refers_to: ["obo:NCIT_C156420"],
  inout_refers_to_label: ["Age at diagnosis"]
})




puts b.generate