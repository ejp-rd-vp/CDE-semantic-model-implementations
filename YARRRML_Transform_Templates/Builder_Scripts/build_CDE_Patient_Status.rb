require "yarrrml-template-builder"

#"pid,uniqid,url
#http://purl.obolibrary.org/obo/ICO_0000196


b = YARRRML_Template_Builder.new({
#  baseURI: "https://w3id.org/duchenne-fdp/data/",
  source_tag: "cde_patient_status",
  sio_verbose: 1,
  }
  )


b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_status",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Patient for status recording"
                                    })
# ===============================================

b.role_in_process({
    person_role_tag: "patientRole_status",
    process_tag:  "patient_status",
    process_label: "status process", 
    })



#======================================

b.process_hasoutput_output({
    process_with_output_tag: "patient_status",  # connect to the correct process
    output_type_label_column: "status_label",
    output_value_column: "status_label",
    })
b.input_output_refers_to({
  refers_to_tag: "status_attribute",
  inout_process_tag:   "patient_status",  # connect to the correct process
  inout_refers_to_columns: ["status_uri"]
})


#sio:SIO_010059 (dead)
#sio:SIO_010058 (alive)
#obo:NCIT_C70740 (lost to follow-up)
#obo:NCIT_C124784 (refused to participate)

b.process_hasoutput_output({
    process_with_output_tag: "patient_death_information",  # connect to the correct process
    output_type_label: "patient death information",
    output_value_column: "death_date",
    output_end_column: "death_date"
    })
b.input_output_refers_to({
  refers_to_tag: "death_information",
  inout_process_tag:   "patient_death_information",  # connect to the correct process
  inout_refers_to: "obo:NCIT_C70810"
})


puts b.generate