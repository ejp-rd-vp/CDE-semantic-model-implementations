require "yarrrml-template-builder"

# pid,uniqid,tool,score,date


b = YARRRML_Template_Builder.new({
  baseURI: "https://w3id.org/duchenne-fdp/data/",
  source_tag: "cde_disability",
  sio_verbose: 1,
  }
  )


b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_disability_assessment",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Genetic Diagnosis Patient"
                                    })

# ===============================================
b.role_in_process({
    person_role_tag: "patientRole_disability_assessment",
    process_tag:  "patientRole_disability_assessment_process",
    process_label: "disability assessment",
    process_type_column: "tool",  # research or clinical assessment tool
    })
# @option params :process_annotations [Array] ([[pred, val,datatype]...]) (required) the same process tag that is used in the "role in process"

b.process_has_annotations({
  
  ["rdf:type", "http://purl.obolibrary.org/obo/NCIT_C20993", "iri"],  # research or clinical assessment tool
})
# ===================================================================================
# ===================================================================================
# ===================================================================================

b.process_has_part({
  parent_process_tag: "longitudinal_information_gathering_process_diseaseX",
  part_process_tag: "patientRole_disability_assessment_process",
  parent_unique_process: false,
})


# ========================================GENETIC DIAGNOSIS===========================================
#"pid,uniqid, hgvs_variant
b.process_hasoutput_output({
    process_with_output_tag: "patientRole_disability_assessment_process",  # connect to the correct process
    output_type: "http://semanticscience.org/resource/SIO_001381",  # genomic sequence variant
    output_type_label: "genome sequence variant",
    output_value_column: "hgvs_variant",
    })



puts b.generate