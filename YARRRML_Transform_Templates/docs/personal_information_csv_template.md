# Personal Information CDE

The CDE for personal information (birth date and sex)

## CSV file 

### Example CSV file
Please find example CSV file [here](../csv/personal_information.csv)

### Columns

pid, uniqid, sexURI, sexLabel, birthdate


## Notes:
  * pid - patient unique identifier
  * iniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * sexURI: one of 
    * Female sex  obo:NCIT_C16576(female) ; 
    * Male sex obo:NCIT_C20197(male); 
    * Undetermined  obo:NCIT_C124294 (undetermined) ; 
    * Unknown  obo:NCIT_C17998(unknown) (use this for foetal undetermined) 
  * sexLabel:  some human readable label that matches the sexURI column
  * birthdate:  ISO 8601 compliant date string

## YARRRML

Please find the YARRRML template for this module [here](../templates/personal_information_yarrrml_template.yaml)
  
##  TODO

