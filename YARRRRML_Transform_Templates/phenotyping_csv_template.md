# Phenotyping CDE

A record of the phenotypic observations for a patient

## CSV Columns

# pid,uniqid, HP_IRI, HP_Label, date


## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * HP_IRI: the full Human Phenotype Ontology URI
  * HP_Label:  the associated HPO label
  * date:  ISO 8601 formatted date of the observation
  
Note that it is optional to have all HP observations attached to the same uniqid (i.e. multiple rows with the same uniqid) or to
have them as separate paths through the linked data.  When querying, you should always assume that they are independent, and organize them
by date if there were multiple phenotyping sessions over time.
