# Genetic Diagnosis CDE

The CDE for genetic diagnosis

## CSV file 

### Example CSV file
Please find example CSV file [here](../csv/genetic_diagnosis.csv)

### Columns

pid, uniqid, hgvs_variant, hgnc_code, omim_number


## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * hgvs_variant: the hgvs string (only one allowed at this time... complain to us if you need more than one!)
  * hgnc_code:  for example  HGNC:2928
  * omim_number:  just the numerical portion of the gene/locus MIM number, e.g. 310200

## YARRRML

Please find the YARRRML template for this module [here](../templates/genetic_diagnosis_yarrrml_template.yaml)
  
##  TODO

