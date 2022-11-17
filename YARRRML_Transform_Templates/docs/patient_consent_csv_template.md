# Patient Consent CDE

The CDE for patient status

## CSV file 

### Example CSV file
Please find example CSV file [here](../exemplar_csv/patient_consent.csv)

### Columns

pid, uniqid, consent_template, result_uri, result_label, date



## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * consent_template:  the URI/URL to the raw (not patient-filled) consent document
  * result_uri:  some child of http://purl.obolibrary.org/obo/DUO_0000001 (ICO/DUI Data Use Permission) or http://purl.obolibrary.org/obo/OBIB_0000488 (willingness to be contacted)
  * result_label:  some label describing the meaning of the result_uri
  * date:  the date this consent was captured
  
If the patient has consented multiple times (e.g. consent for contact, and consent for data use, etc.) then
create a row for each consent, changing the result_uri for each appropriate ICO/DUI term
## YARRRML

Please find the YARRRML template for this module [here](../templates/patient_consent_yarrrml_template.yaml)

  
##  TODO

  