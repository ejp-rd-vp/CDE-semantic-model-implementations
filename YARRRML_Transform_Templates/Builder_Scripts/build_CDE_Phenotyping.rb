require "yarrrml-template-builder"

#"pid, uniqid, HP_IRI, HP_Label, date


b = YARRRML_Template_Builder.new({
  source_tag: "cde_patient_phenotyping",
  sio_verbose: 1,
  }
  )

#b.add_prefixes(
#               prefixesHash: {
#  "HP" => "http://purl.obolibrary.org/obo/HP_"
#})


b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_phenotyping",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Phenotyping Patient"
                                    })

# ===============================================

b.role_in_process({
    person_role_tag: "patientRole_phenotyping",
    process_tag:  "patientRole_phenotyping_process",
    process_label: "comparative phenotypic assessment",
    process_start_column: "date",
    process_type: "http://purl.obolibrary.org/obo/OBI_0001546", # comparative phenotypic assessment
    })
b.process_has_annotations({
    process_tag:  "patientRole_phenotyping_process",
    process_annotations: [
                           ["rdf:type", "http://purl.obolibrary.org/obo/NCIT_C16205", "iri"],# healthcare activity
                           ["rdf:type", "http://purl.obolibrary.org/obo/NCIT_C18020", "iri"],# diagnostic procedure
                           ]  
    })


# ===================================================================================
# ===================================================================================
# ===================================================================================

b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process_diseaseX",
  part_process_tag: "patientRole_phenotyping_process",
  output_start_column: "date",
  parent_unique_process: false,
})

# ===================================================================================
# ===================================================================================
# ========================================Phenotyping===========================================
#"pid,uniqid, HP_IRI, HP_Label
b.process_hasoutput_output({
    process_with_output_tag: "patientRole_phenotyping_process",  # connect to the correct process
    output_type: "http://purl.obolibrary.org/obo/NCIT_C102741", # classification of a clinical observation
    output_type_label_column: "HP_Label",
    })

b.input_output_refers_to({
  refers_to_tag: "phenotyping_attribute",
  inout_process_tag:   "patientRole_phenotyping_process",  # connect to the correct process
  inout_refers_to_column: "HP_IRI",
  inout_refers_to_label_column: "HP_Label",
  base_types: ["http://semanticscience.org/resource/SIO_010056"]
})

puts b.generate