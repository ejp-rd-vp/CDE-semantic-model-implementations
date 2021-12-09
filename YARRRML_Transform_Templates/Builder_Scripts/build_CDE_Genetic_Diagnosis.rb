require "yarrrml-template-builder"

# #"pid,uniqid,clinvar_uri,hgvs_string,hgnc_code,omim_number


b = YARRRML_Template_Builder.new({
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
    process_tag:  "patientRole_genetic_diagnosis_process_omim",
    process_label: "genetic testing OMIM",
    process_type: "http://purl.obolibrary.org/obo/NCIT_C15709",  # genetic testing
    })
b.role_in_process({
    person_role_tag: "patientRole_genetic_diagnosis",
    process_tag:  "patientRole_genetic_diagnosis_process_hgnc",
    process_label: "genetic testing HGNC",
    process_type: "http://purl.obolibrary.org/obo/NCIT_C15709",  # genetic testing
    })
b.role_in_process({
    person_role_tag: "patientRole_genetic_diagnosis",
    process_tag:  "patientRole_genetic_diagnosis_process_hgvs",
    process_label: "genetic testing HGVS",
    process_type: "http://purl.obolibrary.org/obo/NCIT_C15709",  # genetic testing
    })

# ===================================================================================
# ===================================================================================
# ===================================================================================

b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process_diseaseX",
  part_process_tag: "patientRole_genetic_diagnosis_process_omim",
  parent_unique_process: false,
})

b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process_diseaseX",
  part_process_tag: "patientRole_genetic_diagnosis_process_hgnc",
  parent_unique_process: false,
})

b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process_diseaseX",
  part_process_tag: "patientRole_genetic_diagnosis_process_hgvs",
  parent_unique_process: false,
})


# ========================================GENETIC DIAGNOSIS===========================================
# #"pid,uniqid, clinvar_uri, hgnc_uri, omim_uri, hgvs_string

b.process_hasoutput_output({
    process_with_output_tag: "patientRole_genetic_diagnosis_process_hgvs",  # connect to the correct process
    output_type: "http://semanticscience.org/resource/SIO_001388",  # genomic sequence variant
    output_value_column: "hgvs_string",
    output_value_datatype: "xsd:string"
    })

b.process_hasoutput_output({
    process_with_output_tag: "patientRole_genetic_diagnosis_process_omim",  # connect to the correct process
    output_type: "http://semanticscience.org/resource/SIO_001381",  # genomic sequence variant
    output_type_label: "OMIM genome sequence variant",
    output_value_column: "omim_uri",
    output_value_datatype: "xsd:string"
    })
b.process_hasoutput_output({
    process_with_output_tag: "patientRole_genetic_diagnosis_process_hgnc",  # connect to the correct process
    output_type: "http://semanticscience.org/resource/SIO_001381",  # genomic sequence variant
    output_type_label: "HGNC genome sequence variant",
    output_value_column: "hgnc_uri",
    output_value_datatype: "xsd:string"
    })

#@param params [Hash]  a hash of options
#@option params  :inout_process_tag [String]  ("unidentifiedProcess")
#@option params  :refers_to_tag [String]  (nil) required unique one-word tag of an attribute
#@option params  :inout_refers_to [String]  ([])  an ontology URI
#@option params  :inout_refers_to_column [String] ([]) column headers for column of ontologyURIs
#@option params  :inout_refers_to_label  [String]  ([]) an ontology term label
#@option params  :inout_refers_to_label_column  [String]  ([])  column header for column of ontology term labels
#@option params  :inout_refers_to_uri_column  [String]  ([])  column header for column containing the URIs of the in/out node (e.g. a specific clinical variant identifier)
#@option params  :is_attribute  [Boolean]  (true)  is this output an attribute of the patient?
#@option params  :base_types [Array] ([])  an array of ontology terms that will be applied as the rdf:type for all the referred-to quality/attribute

  b.input_output_refers_to({
    refers_to_tag: "hgnc_reference",
    inout_process_tag: "patientRole_genetic_diagnosis_process_hgnc",
    inout_refers_to: "http://edamontology.org/data_2298",  # HGNC ID
    inout_refers_to_uri_column: "hgnc_uri",
    inout_refers_to_label_column: "hgnc_uri",
    base_types: ["http://semanticscience.org/resource/SIO_000015"]  # info content entity
    
  })


  b.input_output_refers_to({
    refers_to_tag: "hgvs_reference",
    inout_process_tag: "patientRole_genetic_diagnosis_process_hgvs",
    inout_refers_to: "http://purl.obolibrary.org/obo/NCIT_C171178",  # sequence variant report
    inout_refers_to_uri_column: "clinvar_uri",
    inout_refers_to_label_column: "hgvs_string",
    base_types: ["http://semanticscience.org/resource/SIO_000015"]  # info content entity
    
  })

  b.input_output_refers_to({
    refers_to_tag: "omim_reference",
    inout_process_tag: "patientRole_genetic_diagnosis_process_omim",
    inout_refers_to: "http://edamontology.org/data_1153",  # OMIM Accession
    inout_refers_to_uri_column: "omim_uri",
    inout_refers_to_label_column: "omim_uri",
    base_types: ["http://semanticscience.org/resource/SIO_000015"]  # info content entity
  })


puts b.generate
