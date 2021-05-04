# Patient Consent CDE

The CDE for patient status

## CSV Columns

pid, uniqid, url, result_uri, result_label, date



## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * url:  the URL to the raw (not patient-filled) consent document
  * result_uri:  some child of http://purl.obolibrary.org/obo/DUO_0000001 (ICO/DUI Data Use Permission)
  * result_label:  some label describing the meaning of the result_uri
  * date:  the date this consent was captured
  
## YARRRML

Please find the YARRRML template for this module [here](../templates/patient_consent_yarrrml_template.yaml)

  
##  TODO

  