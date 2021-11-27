require "yarrrml-template-builder"

# pid, uniqid


b = YARRRML_Template_Builder.new({
  source_tag: "patient_in_clinical_trial",
  sio_verbose: 1,
  }
  )


b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "person_clinical_trial_role",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Patient in clinical trial"
})

#pid,uniqid,drugID,drugURI,drugName,compoundURI,diseaseURI,diseaseLabel

b.entity_identifier_role_mappings({
  entityid_column: "drugID",
  entity_type_column: "drugURI",
  entity_label_column: "drugName",
  uniqueid_column: "uniqid",
  entity_role_tag: "compound_clinical_trial_role",
  role_type: 'http://semanticscience.org/resource/SIO_010430',  # test role
  role_label: "Compound tested in clinical trial"
})


# ===============================================
b.role_in_process({
    person_role_tag: "person_clinical_trial_role",
    process_tag:  "clinical_trial_process",
    process_label: "A clinical trial",
    process_type: "http://purl.obolibrary.org/obo/NCIT_C71104", # clinical trial
    make_unique_process: false,
})
b.role_in_process({
    person_role_tag: "compound_clinical_trial_role",
    process_tag:  "clinical_trial_process",
    process_label: "A clinical trial",
    process_type: "http://purl.obolibrary.org/obo/NCIT_C71104", # clinical trial
    make_unique_process: false,
    })



# @param params [Hash]  a hash of options
# @option params :process_with_target_tag  [String] (required) the same process tag that is used in the "role in process" for which this is the target
# @option params :target_type_tag  [String] a tag to differentiate this target from other targets
# @option params :target_type  [String] the ontological type for the target  (e.g. process is targetted at creatinine - http://purl.obolibrary.org/obo/CHEBI_16737)
# @option params :target_type_column  [String] the column header specifying the ontological type for the target node (overrides target_type).  
# @option params :target_type_label  [String] the label for all targets
# @option params :target_type_label_column  [String] the label column for each target
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  th
b.process_has_target({
    process_tag:  "clinical_trial_process",
    target_type_tag: "thisdisease",
    target_type_column: "diseaseURI",
    target_type_label_column: "diseaseLabel",

})

# @param params [Hash]  a hash of options
# @option params :process_tag  [String] (required) the same process tag that is used in the "role in process" 
# @option params :entityid_column [String] (required) default "pid"
# @option params :entity_tag [String] (required) default "thisEntity".   The entity-tag that you used for the entity in the entity/identifier/role clauses
b.process_has_agent({
    process_tag:  "clinical_trial_process",
    entityid_column: "drugURI",
    entity_tag: "somedrug",

})

# @param params [Hash]  a hash of options
# @option params :parent_entityid_column  [String] (required) the column that contains the parent entity id
# @option params :part_entity_tag  [String] (required) the tag of the part
# @option params :part_type_column  [String] (required) the column that contains the parent entity id
b.entity_has_component({
    parent_entityid_column:  "drugID",
    part_entity_tag: "somedrugcomponent1",
    part_type_column: "compoundURI"

})

puts b.generate