# Body Measurement DCDE

The DCDE to capture any physical measurement of the body

## CSV file 

### Example CSV file
Please find example CSV file [here](../csv/lab_measurement.csv)

### Columns

 pid,uniqid,processURI,processLabel,material_tested,material_tested_label,target,target_label,value,valueDatatype,unitURI,unitLabel,date,comments

## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * processURI:  child of http://purl.obolibrary.org/obo/NCIT_C25404, or a DOI URL reference to a https://protocols.io deposit.
    * Suggestions:
      * Quantitation (please use this by default) http://purl.obolibrary.org/obo/NCIT_C48937
      * Estimation (http://purl.obolibrary.org/obo/NCIT_C25498)
  * processLabel:  the human readable label for the process
  * material_tested:  material inut to the test - child of http://purl.obolibrary.org/obo/NCIT_C12219 (Anatomic Structure, System, or Substance) such as http://purl.obolibrary.org/obo/NCIT_C13283 ("urine")
  * material_tested_label: label for the material tested (e.g. "urine")
  * target:  the compound being measured in the sample. Child of  http://purl.obolibrary.org/obo/NCIT_C1908 (Drug, Food, Chemical or Biomedical Material) such as "http://purl.obolibrary.org/obo/NCIT_C399" (creatinine)
  * target_label:  label of that compound (e.g. "creatinine")
  * value:  the value of the measurement
  * valueDatatype: select one of:  xsd:string, xsd:int, xsd:float  or if you know a more specific type, use that (be aware that xsd:integer may not be cross-platform compatible)
  * unitURI: select a Unit of Measure Ontology URI e.g. http://purl.obolibrary.org/obo/UO_0000015 (centimeter)
  * unitLabel:  the label for that unit URI (e.g. "centimeter")
  * date:  ISO 8601 formatted date  (not date time!)
  * comments:  textual comments about the measurement, if any

## YARRRML

Please find the YARRRML template for this module [here](../templates/body_measurement_yarrrml_template.yaml)
  
##  TODO

