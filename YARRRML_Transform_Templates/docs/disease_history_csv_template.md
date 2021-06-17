# Disease History CDE

The CDE for disease history ("age" at onset, "age" at diagnosis)

## CSV file 

### Example CSV file
Please find example CSV file [here](../csv/disease_history.csv)

### Columns

pid, uniqid, onset_uri, onset_date, diagnosis_uri, diagnosis_date


## Notes:
  * pid - patient unique identifier
  * iniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * onset_uri:
    * http://purl.obolibrary.org/obo/HP_0030674 (Antenatal onset)
    * http://purl.obolibrary.org/obo/HP_0003577 (Congenital onset)
    * http://purl.obolibrary.org/obo/NCIT_C124294 (Undetermined) 
    * http://purl.obolibrary.org/obo/HP_0003674 (onset) - use this when you are going to provide a date
  * onset_date:  ISO 8601 date  (note that the CDE calls this "age", but it is annotated as being a date field...??)
  * diagnosis_uri:
    * http://purl.obolibrary.org/obo/HP_0030674 (Antenatal onset)
    * http://purl.obolibrary.org/obo/HP_0003577 (Congenital onset)
    * http://purl.obolibrary.org/obo/NCIT_C124294 (Undetermined) 
    * http://purl.obolibrary.org/obo/HP_0003674 (onset) - use this when you are going to provide a date
  * diagnosis_date: ISO 8601 date  (note that the CDE calls this "age", but it is annotated as being a date field...??)


SPARQL NOTES:  When querying, the patient attribute will be one of: 
  * http://purl.obolibrary.org/obo/NCIT_C156420 (Age at Diagnosis) 
  * http://purl.obolibrary.org/obo/NCIT_C124353  (symptom onset)

## YARRRML

Please find the YARRRML template for this module [here](../templates/disease_history_yarrrml_template.yaml)
  
##  TODO


