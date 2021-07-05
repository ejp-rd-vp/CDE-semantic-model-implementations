# Body Measurement DCDE

The DCDE to capture any imaging data

## CSV file 

### Example CSV file
Please find example CSV file [here](../csv/imaging.csv)

### Columns

 pid,uniqid,processURI,processLabel,protocolURI,target,target_label,imageID,date,comments


## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * processURI:  child of http://purl.obolibrary.org/obo/NCIT_C17369 (Imaging technique)
  * processLabel:  the human readable label for the process
  * protocolURI: a DOI URL reference to a https://protocols.io deposit.
  * target:  the body part being imaged - child of http://purl.obolibrary.org/obo/NCIT_C12219 (Anatomic Structure, System, or Substance) such as http://purl.obolibrary.org/obo/NCIT_C33252 ("palmar region")
  * target_label:  label of that body part (e.g. "palmar region")
  * imageID:  GUID (preferably a URI) of the file (must be a GUID system compatible with RDF Resource identifiers!)
  * date:  ISO 8601 formatted date  (not date time!)
  * comments:  textual comments about the measurement, if any

## YARRRML

Please find the YARRRML template for this module [here](../templates/imaging_yarrrml_template.yaml)
  
##  TODO

