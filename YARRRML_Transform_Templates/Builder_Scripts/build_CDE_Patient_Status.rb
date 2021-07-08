require "yarrrml-template-builder"

#"pid,uniqid,url
#http://purl.obolibrary.org/obo/ICO_0000196


b = YARRRML_Template_Builder.new({
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
    process_label: "status recording process", 
    })


b.role_in_process({
    person_role_tag: "patientRole_status",
    process_tag:  "patient_death_information",
    process_label: "death information recording process",
    process_start_column: "date"
    })


#======================================

b.process_hasoutput_output({
    process_with_output_tag: "patient_status",  # connect to the correct process
    output_type_label_column: "status_label",
    output_value_column: "status_label",
    })

#sio:SIO_010059 (dead)
#sio:SIO_010058 (alive)
#obo:NCIT_C70740 (lost to follow-up)
#obo:NCIT_C124784 (refused to participate)
b.input_output_refers_to({
  refers_to_tag: "status_attribute",
  inout_process_tag:   "patient_status",  # connect to the correct process
  inout_refers_to_column: "status_uri",
  inout_refers_to_label: "Patient status",
  is_attribute: true
})
#=====================================

b.process_hasoutput_output({
    process_with_output_tag: "patient_death_information",  # connect to the correct process
    output_type_label: "patient death information",
    output_value_column: "death_date",
    output_value_datatype: "xsd:date",
    output_timeinstant_column: "death_date"
    })

b.input_output_refers_to({
  refers_to_tag: "death_information",
  inout_process_tag:   "patient_death_information",  # connect to the correct process
  inout_refers_to: "obo:NCIT_C70810",
  inout_refers_to_label: "Date of death",
  is_attribute: true
})


puts b.generate