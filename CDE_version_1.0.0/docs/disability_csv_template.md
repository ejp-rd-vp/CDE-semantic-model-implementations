# Disability CDE

Measurement of disability using some standardized assessment test

## CSV file 

### Example CSV file
Please find example CSV file [here](../exemplar_csv/phenotyping.csv)

### Columns

pid,uniqid,test_uri,test_name,test_date,score


## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * test_uri: some child of http://purl.obolibrary.org/obo/NCIT_C20993 (research or clinical assessment tool)
  * test_name:  The name of the test from the URI in the previous column (e.g. "Behavior Assessment system for Children")
  * test_date:  ISO 8601 formatted date of the test
  * score:  the numeric or string score of the output from the test
  
## YARRRML

Please find the YARRRML template for this module [here](../templates/disability_yarrrml_template.yaml)
