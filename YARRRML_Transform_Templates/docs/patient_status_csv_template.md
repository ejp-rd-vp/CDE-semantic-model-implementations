# Patient Status CDE

The CDE for patient status

## CSV file 

### Example CSV file
Please find example CSV file [here](../csv/patient_status.csv)

### Columns

pid, uniqid, date, status_uri, status_label, death_date


## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * date:  ISO 8601 formatted date representing the date of the current observation
  * status_uri:  one of
    * http://semanticscience.org/resource/SIO_010059 (dead)
    * http://semanticscience.org/resource/SIO_010058 (alive)
    * http://purl.obolibrary.org/obo/NCIT_C70740 (lost to follow-up)
    * http://purl.obolibrary.org/obo/NCIT_C124784 (refused to participate)
  * status label:  a human readable label to match the value of the status URI for that row
  * death_date:  if the patient is dead, the recorded date of death (may be different from the 'date' column of this record).  If patient is not dead, leave this field as empty
  

## YARRRML

Please find the YARRRML template for this module [here](../templates/patient_status_yarrrml_template.yaml)

  
##  TODO

  