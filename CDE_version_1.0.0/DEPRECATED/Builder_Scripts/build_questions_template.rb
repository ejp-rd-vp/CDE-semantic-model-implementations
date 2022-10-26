require "yarrrml-template-builder"


#pid,uniqid,processLabel,processURI,comments,measurementURI,measurementLabel,promURI,
#data,promQuestion,ontologyURI,eventDate,startDate,endDate

b = YARRRML_Template_Builder.new({
  source_tag: "questionsSIO",
  sio_verbose: 1,
  }
  )

b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Patient"
                                    })


# @param params [Hash]  a hash of options
# @option params :person_role_tag  [String] the tag of the role that is fulfilled in this process (default 'thisRole') - see person_role_tag above, synchronize these tags!
# @option params :process_type  [String] the URL for the ontological type of the process (defaults to http://semanticscience.org/resource/process)
# @option params :process_type_column  [String] the column header that contains the URL for the ontological type of the process - overrides process_type
# @option params :process_tag  [String] some single-word tag for that process; defaults to "thisprocess"
# @option params :process_label  [String] the label associated with the process type in that row (defaults to "thisprocess")
# @option params :process_label_column  [String] the column header for the label associated with the process type in that row
# @option params :process_start_column  [ISO 8601 date (only date)] (optional) the column header for the datestamp when that process started
# @option params :process_end_column  [ISO 8601 date (only date)]  (optional) the column header for the datestamp when that process ended
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.

b.role_in_process({
    person_role_tag: "patientRole",
    process_type_column: "processURI",  
    process_tag:  "questionnaire_test",
    process_label_column: "processLabel",
    process_start_column: "eventDate"
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


#pid,uniqid,processLabel,processURI,comments,measurementURI,measurementLabel,promURI,
#data,promQuestion,ontologyURI,eventDate,startDate,endDate
b.process_hasoutput_output({
    process_with_output_tag: "questionnaire_test",  # connect to the correct process
    output_type_label: "question response",
    output_value_column: "data",
    output_type_column: "measurementURI",
    output_type_label_column: "measurementLabel",
    output_comments_column: "comments",
    output_start_column: "startDate",
    output_end_column: "endDate"
    })



# @param [:process_with_input_tag] (string) (required) the same process tag that is used in the "role in process" for which this is the input
# @param [:input_is_output_of_process_tag] (string) defaults to 'unidentifiedProcess'; if the input is the output of another process, then specify the process tag here (matches the "role in process" which generates taht output
# @param [:input_type] (string) the ontological type for the input node (default http://semanticscience.org/resource/information-content-entity).  Ignored if using output from another process (specify it there!)
# @param [:input_type_tag] (string) some single-word tag for that input (default thisInput).  required if more than one input!
# @param [:input_type_column] (string) the column header specifying the ontological type for the input node (overrides input_type).  Ignored if using output from another process (specify it there!)
# @param [:input_type_label] (string) the label for all inputs
# @param [:input_type_label_column] (string) the label column for each input
# @param [:input_label_tag] (string) some single-word tag for that input (default thisInput).  required if more than one input!
# @param [:input_has_value] (string) the value of the input
# @param [:input_has_value_column] (string) the column containing the value of the input
# @param [:input_has_value_datatype] (string) datatype of the value (default xsd:string)
# @param [:input_has_value_datatype_column] (string) the column containing the datatype of the value of the input )(overrides input_has_value_datatype)

#pid,uniqid,processLabel,processURI,comments,measurementURI,measurementLabel,promURI,data,promQuestion,ontologyURI"

b.process_has_input({
  process_with_input_tag: "questionnaire_test",
  input_is_output_of_process_tag: "someQuestionAuthoringProcess",
  input_type: "http://semanticscience.org/resource/SIO_000085",
  input_type_tag: "thisQuestion",
  input_type_label_column: "promQuestion",
  input_has_value_column: "promQuestion",
}
)


b.input_output_refers_to(  {
                           refers_to_tag: "prom_question",
  inout_process_tag: "someQuestionAuthoringProcess",                     
  inout_refers_to_column: "promURI",
                           
})
b.input_output_refers_to(  {
                           refers_to_tag: "ontology_trait",
  inout_process_tag: "someQuestionAuthoringProcess",                     
  inout_refers_to_column: "ontologyURI",
                           
})

b.input_output_refers_to(  {
                           refers_to_tag: "prom_question",
  inout_process_tag: "questionnaire_test",                     
  inout_refers_to_column: "promURI",
                           
})




puts b.generate