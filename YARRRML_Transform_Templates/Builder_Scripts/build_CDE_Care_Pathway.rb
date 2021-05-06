require "yarrrml-template-builder"

#"pid,uniqid, first_contact_date

#longitudinal_information_gathering_process_diseaseX

b = YARRRML_Template_Builder.new({
#  baseURI: "https://w3id.org/duchenne-fdp/data/",
  source_tag: "cde_patient_care_pathway",
  sio_verbose: 1,
  }
  )

b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_care_pathway_first_contact",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "First Contact Patient"
                                    })

# ===============================================

b.role_in_process({
    person_role_tag: "patientRole_care_pathway_first_contact",
    process_tag:  "patientRole_care_pathway_first_contact_process",
    process_label: "first contact with specialized center",
    process_type: "http://purl.obolibrary.org/obo/NCIT_C159705", # first confirmed visit
    process_start_column: "first_contact_date"
    })
b.process_has_annotations({
    process_tag:  "patientRole_care_pathway_first_contact_process",
    process_annotations: [["rdf:type", "http://purl.obolibrary.org/obo/NCIT_C16205", "iri"]], # healthcare activity
})
b.process_has_annotations({
    process_tag:  "patientRole_care_pathway_first_contact_process",
    process_annotations_columns: [["http://semanticscience.org/resource/SIO_000669", "first_contact_date", "xsd:date"]], # healthcare activity
})


# ===================================================================================
# ===================================================================================
# ===================================================================================

b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process_diseaseX",
  part_process_tag: "patientRole_care_pathway_first_contact_process",
  parent_unique_process: false,
})

# ===================================================================================
# ===================================================================================


puts b.generate