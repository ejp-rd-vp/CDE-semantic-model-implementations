require "yarrrml-template-builder"
#require "../../YARRRML_Tools/yarrrml_template_builder/lib/yarrrml-template-builder.rb"

# pid,uniqid,sexURI,sexLabel,birthdate


b = YARRRML_Template_Builder.new({
#  baseURI: "https://w3id.org/duchenne-fdp/data/",
  source_tag: "cde_personal_information",
  sio_verbose: 1,
  }
  )

b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_age",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Patient for age assessment"
                                    })

b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole_sex",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Patient For Gender Assessment"
                                    })

b.role_in_process({
    person_role_tag: "patientRole_age",
    process_tag:  "age_measuring_procedure",
    process_label: "age measuring process", 
    })

b.role_in_process({
    person_role_tag: "patientRole_sex",
    process_tag:  "sex_measuring_procedure",
    process_label: "sex measuring process", 
    })

# @param [:process_with_output_tag] (string) (required) the same process tag that is used in the "role in process" for which this is the output
# @param [:output_value] (string)  (optional) the default value of that output (defaults to nil, and the output node is not created in the RDF)
# @param [:output_value_column] (string)  (optional) the column header for the value of that output (e.g. the column that contains "80"  for "80 mmHg")
# @param [:output_type] (URL) the URL associated with the output ontological type (defaults to http://semanticscience.org/resource/realizable-entity)
# @param [:output_type_column] (string) the column header for the URL associated with the output ontological type (overrides output_type)
# @param [:output_type_label] (string) (optional) the the label of that ontological type (defaults to "measurement-value")
# @param [:output_type_label_column] (string) (optional) the column header for the label of that ontological type (overrides output_type_label)
# @param [:output_value_datatype] (xsd:type)  (optional) the xsd:type for that kind of measurement (defaults to xsd:string)
# @param [:output_value_datatype_column] (string)  (optional) the column header for the xsd:type for that kind of measurement (overrides output_value_datatype)
# @param [:output_comments_column] (string)  (optional) the column header for amy textual comments.  text must not contain a comma!!  defaults to nil
# @param [:output_start_column] (xsd:datetime)  (optional) the column header for start date
# @param [:output_end_column] (xsd:datetime)  (optional) the column header for end date

#"pid,uniqid,sexURI,sexLabel,birthdate


b.process_hasoutput_output({
    process_with_output_tag: "age_measuring_procedure",  # connect to the correct process
    output_type_label: "Birth Date",
    output_value_column: "birthdate",
    output_value_datatype: "xsd:dateTime"
    })
b.process_hasoutput_output({
    process_with_output_tag: "sex_measuring_procedure",  # connect to the correct process
    output_type_label_column: "sexLabel",
    output_value_column: "sexLabel",
    })

#Options Hash (params):
#
#    :inout_process_tag (String) — default: "unidentifiedProcess"
#    :inout_refers_to (Array) — default: [] —
#
#    an array of ontology URIs
#    :inout_refers_to_columns (Array) — default: [] —
#
#    an array of column headers for columns of ontologyURIs
#    :inout_refers_to_label (Array) — default: [] —
#
#    am array of ontology term/labels
#    :inout_refers_to_label_columns (Array) — default: [] —
#
#    an array of column headers for columns of ontology term/labels

#"pid,uniqid,sexURI,sexLabel,birthdate

b.input_output_refers_to(  {
  inout_process_tag: "sex_measuring_procedure",
  refers_to_tag: "sexAttribute",
  inout_refers_to_column: "sexURI",
  inout_refers_to_label_column: "sexLabel",
  base_types: ["obo:NCIT_C28421"],
  is_attribute: true
})

b.input_output_refers_to(  {
  inout_process_tag: "age_measuring_procedure",                     
  refers_to_tag: "ageAttribute",
  inout_refers_to: "obo:NCIT_C68615",  
  inout_refers_to_label: "Birth Date",
  is_attribute: true
                           
})



puts b.generate