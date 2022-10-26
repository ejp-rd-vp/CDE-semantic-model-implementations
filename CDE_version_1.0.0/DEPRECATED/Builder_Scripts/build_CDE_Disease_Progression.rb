require "yarrrml-template-builder"

# pid, uniqid


b = YARRRML_Template_Builder.new({
  source_tag: "cde_patient_disease_progression",
  sio_verbose: 1,
  }
  )


b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "longitudinal_information_gathering_role",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Patient for longitudinal information gathering"
                                    })

# ===============================================
b.role_in_process({
    person_role_tag: "longitudinal_information_gathering_role",
    process_tag:  "longitudinal_information_gathering_process_diseaseX",
    process_label: "patient longitudinal data collection",
    process_type: "http://semanticscience.org/resource/SIO_001052", # data collection
    make_unique_process: false,
    })

b.process_has_annotations({
    process_tag:  "longitudinal_information_gathering_process_diseaseX",
    process_annotations: [
                           ["sio:refers-to", "http://purl.obolibrary.org/obo/NCIT_C17747", "iri"],
                           ["rdfs:label", "Longitudinal record of patient disease progression and events"],
                           ], # Disease Progression
})




puts b.generate