# Phenotyping CDE

A record of the phenotypic observations for a patient

## CSV file 

### Example CSV file
Please find example CSV file [here](../csv/phenotyping.csv)

### Columns

pid,uniqid, HP_IRI, HP_Label, date


## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * HP_IRI: the full Human Phenotype Ontology URI
  * HP_Label:  the associated HPO label
  * date:  ISO 8601 formatted date of the observation
  
Note: When querying, you should always assume that every phenotypic observation is independent - that is, 
they will all come from **independent Process nodes** in the graph! This is because phenotypes can change over time, and there may be
multiple phenotype entries at different times.  Heads-up!

## YARRRML

Please find the YARRRML template for this module [here](../templates/phenotyping_yarrrml_template.yaml)
