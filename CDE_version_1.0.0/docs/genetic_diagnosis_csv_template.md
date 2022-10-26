# Genetic Diagnosis CDE

The CDE for genetic diagnosis

## CSV file 

### Example CSV file
Please find example CSV file [here](../exemplar_csv/genetic_diagnosis.csv)

### Columns

pid, uniqid, clinvar_uri, hgnc_uri, omim_uri, hgvs_string,


## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * clinvar_uri:  the URI of the clinical variant (e.g. https://identifiers.org/clinvar:4886)
  * hgnc_code:  this is constructed by appending the HGNC code to http://identifiers.org/  e.g. http://identifiers.org/HGNC:2928
  * omim_uri:  this is constructed by appending the OMIM number to ",https://www.omim.org/entry/" e.g. https://www.omim.org/entry/310200
  * hgvs_string: the hgvs string

## YARRRML

Please find the YARRRML template for this module [here](../templates/genetic_diagnosis_yarrrml_template.yaml)
  
##  TODO

