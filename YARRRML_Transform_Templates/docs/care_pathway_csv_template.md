# Care Pathway History CDE

The care pathway (currently limited to first-contact information)

## CSV file 

### Example CSV file
Please find example CSV file [here](../csv/care_pathway.csv)

### Columns

pid, uniqid, first_contact_date


## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * first_contact_date:  date of first contact (ISO 8601 compliant)
  
## YARRRML

Please find the YARRRML template for this module [here](../templates/care_pathway_yarrrml_template.yaml)


##  TODO

