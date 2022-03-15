# Drug Treatment DCDE

The DCDE to capture any kind of drug treatment

## CSV file 

### Example CSV file
Please find example CSV file [here](../exemplar_csv/drug_treatment.csv)

### Columns

pid,uniqid,med_atc_uri,med_atc_label,med_atc_type,startdate,enddate,dose,unitLabel,unitURI,freq,freqLabel,freqURI,routeURI,routeLabel,processURI,processLabel,comments


## Notes:

  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * processURI - Child of Intervention or Procedure http://purl.obolibrary.org/obo/NCIT_C25218. Example: Therapeutic Procedure http://purl.obolibrary.org/obo/NCIT_C49236
  * processLabel: human readable label for the process
  * med_atc_uri: ATC code of the druf component
  * med_atc_label: human readable label for the ATC component
  * med_atc_type: Ontological term that defines this ATC drug code. Example: Prednisone - http://purl.obolibrary.org/obo/NCIT_C770 
  * startdate: date of the begining of the therapeutical process
  * enddate: date of the end of the therapeutical process (if its ends)
  * dose: numerical value of a single drug dose 
  * unitURI: unit of meassurement of drug dose. Example: miligram - http://purl.obolibrary.org/obo/UO_0000022
  * unitLabel: human readable label for the unit
  * freqURI: ontological term to define frequency of drug intaken. Example: per day - http://purl.obolibrary.org/obo/NCIT_C66968
  * freqLabel: human readable label for the frequency
  * freq: numerical (integer) value of frequency
  * routeURI: Child of Route of Administration - http://purl.obolibrary.org/obo/NCIT_C38114 . Example: Intramuscular Route of Administration - http://purl.obolibrary.org/obo/NCIT_C28161
  * routeLabel: human readable label for route of administration
  * comments:  textual comments about the measurement, if any

## YARRRML

Please find the YARRRML template for this module [here](../templates/drug_treatment_yarrrml_template.yaml)
  
##  TODO