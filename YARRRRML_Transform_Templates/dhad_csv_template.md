## CSV Columns

pid,uniqid,first_contact_date,symptom_onset_age,hgvs_variant,HP1,HP1L,HP2,HP2L,HP3,HP3L,HP4,HP4L,HP5,HP5L,HP6,HP6L,HP7,HP7L,HP8,HP8L,HP9,HP9L,HP10,HP10L,ordo_uri,diagnostic_opinion,date,status_label,status_uri,death_date


## Notes:

  * symptom_onset_age is defined as one of several ontology terms, or a date.  Currently, only date is supported.
  * hgvs variant is a string
  * HP1-10 are Human Phenotype ontology terms
  
##  TODO

   * change the way we deal with HP terms... one column, multiple rows
