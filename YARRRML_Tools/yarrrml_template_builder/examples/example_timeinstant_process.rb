require "yarrrml-template-builder"

#"pid,uniqid,start,data


b = YARRRML_Template_Builder.new({
  source_tag: "cde_timed_process",
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
# @param params [Hash]  a hash of options
# @option params :person_role_tag  [String] the tag of the role that is fulfilled in this process (default 'thisRole') - see person_role_tag above, synchronize these tags!
# @option params :process_type  [String] the URL for the ontological type of the process (defaults to http://semanticscience.org/resource/process)
# @option params :process_type_column  [String] the column header that contains the URL for the ontological type of the process - overrides process_type
# @option params :process_tag  [String] some single-word tag for that process; defaults to "thisprocess"
# @option params :process_label  [String] the label associated with the process type in that row (defaults to "thisprocess")
# @option params :process_label_column  [String] the column header for the label associated with the process type in that row
# @option params :process_start_column  [ISO 8601 date (only date)] (optional) the column header for the datestamp when that process started. NOTE:  For instantaneous processes, create ONLY the start date column, and an identical end date will be automatically generated
# @option params :process_end_column  [ISO 8601 date (only date)]  (optional) the column header for the datestamp when that process ended
# @option params :make_unique_process [boolean] (true)  (optional) if you want the core URI to be globally unique, or based only on the patient ID.  this can be used to merge nodes over multiple runs of different yarrrml transforms.

b.role_in_process({
    person_role_tag: "patientRole_status",
    process_tag:  "patient_status",
    process_label: "status recording process", 
    process_type: "http://semanticscience.org/resource/SIO_001052", # data collection
    process_start_column: "start",
#    process_end_column: "end"  # without an end, it shiould become an identical start/end
    })



# ===================================================================================
# ========================================Status===========================================
# pid,uniqid,date,status_uri,status_label,death_date


b.process_hasoutput_output({
    process_with_output_tag: "patient_status",  # connect to the correct process
    output_type_label_column: "data",
    output_value_column: "data",
    })



puts b.generate