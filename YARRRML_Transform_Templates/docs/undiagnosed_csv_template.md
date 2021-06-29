# Undiagnosed

A combination of a variant and a phenotype that cannot be definitively diagnosed

## CSV file 

### Example CSV file
Please find example CSV file [here](../csv/undiagnosed.csv)

### Columns

pid,uniqid,hp_uri,hp_label,clinvar_uri,hgvs_string,date


## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * hp_uri:  the URI from the human phenotype ontology that describes the patient's primary phenotypic manifestation
  * hp_label:  the name for that Human Phenotype Ontology term
  * clinvar_uri:  the URL for the variant, either directly to NCBI ClinVar database, or via the identifiers.org proxy (e.g. https://identifiers.org/clinvar:4886)
  * hgvs_string:  the string expression of that clinical variant, in HGVS format (e.g. "NM_003977.4(AIP):c.40C>T (p.Gln14Ter)") - be sure you enclose this in quotes!!
  * date:  date of the diagnosis (leave blank if not available)

## YARRRML

Please find the YARRRML template for this module [here](../templates/undiagnosed_yarrrml_template.yaml)


##  TODO

