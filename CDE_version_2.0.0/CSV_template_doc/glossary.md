# Glossary: Data source requirements for CDE semantic model.

This is a glossary that describes what are the data requirements for our Common data element semantic model. Its mandatory that column names used maintained so [YARRRML file](../YARRRML/CDE_yarrrml_template.yaml) can recognize the data references. FAIR-in-a-box is prepared to cover this implementation and obtain RDF based on this data glossary. 

## Birthdate:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **value**: ISO 8601 formatted date (not date time)
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:date by default
- **model**: Birthdate
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`.  
- **comments**: Human readable comments of any kind related to this procedure

## Deathdate:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **value**: ISO 8601 formatted date of death (not date time)
- **attribute_id**: one of the following: 
    * http://semanticscience.org/resource/SIO_010059 (dead)
    * http://semanticscience.org/resource/SIO_010058 (alive)
    * http://purl.obolibrary.org/obo/NCIT_C70740 (lost to follow-up)
    * http://purl.obolibrary.org/obo/NCIT_C124784 (refused to participate)
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:date by default
- **model**: Deathdate
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 
- **comments**: Human readable comments of any kind related to this procedure

## First Confirmed Visit:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **value**: ISO 8601 formatted date of first confirmed visit (not date time)
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:date by default
- **model**: First_visit
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 
- **comments**: Human readable comments of any kind related to this procedure

## Onset of symptoms:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **attribute_id**: one of the following:
    * http://purl.obolibrary.org/obo/HP_0030674 (Antenatal onset)
    * http://purl.obolibrary.org/obo/HP_0003577 (Congenital onset)
    * http://purl.obolibrary.org/obo/NCIT_C124294 (Undetermined) 
    * http://purl.obolibrary.org/obo/NCIT_C93613 (Onset Date) - use this when you are going to provide a date
- **value**: ISO 8601 formatted date of symptom's onset (not date time) in case of date of diagnosis is defined as a date
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:date by default
- **model**: Onset_symptoms
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 
- **comments**: Human readable comments of any kind related to this procedure

## Sex:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **attribute_id**: one of the following: 
    * http://purl.obolibrary.org/obo/NCIT_C16576 (Female) ; 
    * http://purl.obolibrary.org/obo/NCIT_C20197 (Male); 
    * http://purl.obolibrary.org/obo/NCIT_C124294 (Undetermined) ; 
    * http://purl.obolibrary.org/obo/NCIT_C17998 (Unknown, use this for foetal undetermined) 
- **model**: Sex
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 
- **comments**: Human readable comments of any kind related to this procedure

## Status:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **attribute_id**: one of the following: 
    * http://semanticscience.org/resource/SIO_010059 (dead)
    * http://semanticscience.org/resource/SIO_010058 (alive)
    * http://purl.obolibrary.org/obo/NCIT_C70740 (lost to follow-up)
    * http://purl.obolibrary.org/obo/NCIT_C124784 (refused to participate)
- **model**: Status
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 
- **comments**: Human readable comments of any kind related to this procedure

## Diagnosis:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **attribute_id**: IRI that defines clinical condition: Human Phenotype ontology (HPO) term or Orphanet disease ontology (ORDO) (full URL such as http://www.orpha.net/ORDO/Orphanet_100031)
- **model**: Diagnosis
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 
- **comments**: Human readable comments of any kind related to this procedure

## Genetic information:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **attribute_id**: OMIM gene code constructed by appending the OMIM number to, https://www.omim.org/entry/{OMIM code} e.g. https://www.omim.org/entry/310200
- **model**: Genetic
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 
- **comments**: Human readable comments of any kind related to this procedure

## Consent for being contacted:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **value**: Some label describing consent outcome
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:string by default
- **model**: Consent_contacted
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 
- **comments**: Human readable comments of any kind related to this procedure

## Consent for Data (Re)Use Permission:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **value**: Some label describing consent outcome
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:string by default
- **model**: Consent_used
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 
- **comments**: Human readable comments of any kind related to this procedure

## Biobank:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **value**: Biobank Identifier as https://directory.bbmri-eric.eu/{biobank id}
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:string by default
- **model**: Biobank
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 
- **comments**: Human readable comments of any kind related to this procedure


## Disability:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **process_type**: Some child of http://purl.obolibrary.org/obo/NCIT_C20993 (research or clinical assessment tool)
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:float by default, but depending on your score's datatype, it could be different
- **value**: the numeric score of the output from the test
- **model**: Disability
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`.
- **comments**: Human readable comments of any kind related to this procedure


## Body measurement:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **attribute_id**: Child of Personal Attribute: http://purl.obolibrary.org/obo/NCIT_C19332
- **value**: Resulting value from this observation
- **value_datatype**: xsd:float by default (but could be another different datatype)
- **unit_type**: Child of UO:unit http://purl.obolibrary.org/obo/UO_0000000
- **model**: Body_measurement
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`.
- **comments**: Human readable comments of any kind related to this procedure

## Laboratory measurement:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **input_type**: Material input represented as Child of Anatomic, Structure, System, or Substance http://purl.obolibrary.org/obo/NCIT_C12219 (ex: obo:Urine)
- **value**: Resulting value from this analysis
- **value_datatype**: xsd:float by default (but could be another different datatype)
- **target_type**: Compound being measured in the sample. Child of Drug, Food, Chemical or Biomedical Material http://purl.obolibrary.org/obo/NCIT_C1908 (ex: obo:Creatinine http://purl.obolibrary.org/obo/NCIT_C399)
- **unit_type**: Child of UO:unit http://purl.obolibrary.org/obo/UO_0000000
- **model**: Lab_measurement
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`.
- **comments**: Human readable comments of any kind related to this procedure


## Imaging:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **process_type**: child of Imaging technique http://purl.obolibrary.org/obo/NCIT_C17369  (example: obo:Digital X-Ray http://purl.obolibrary.org/obo/NCIT_C18001)
- **target_type**: Child of Anatomic Structure, System, or Substance http://purl.obolibrary.org/obo/NCIT_C12219 (ex: obo:Palmar Region http://purl.obolibrary.org/obo/NCIT_C33252)
- **valueIRI**: Preferably a URI-based GUID of the file (must be a GUID system compatible with RDF Resource identifiers)
- **model**: Imaging
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`.
- **comments**: Human readable comments of any kind related to this procedure

## Medications and Therapies:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **route_type**: Child of Route of Administration http://purl.obolibrary.org/obo/NCIT_C38114 (example: obo:Sublingual Route of Administration http://purl.obolibrary.org/obo/NCIT_C38300 )
- **value**: Dose value prescribe to the patient
- **value_datatype**: xsd:float by default (others like xsd:integer are also an option)
- **unit_type**: Child of UO:unit http://purl.obolibrary.org/obo/UO_0000000
- **frequency_type**: Child of obo:Temporal Qualifier http://purl.obolibrary.org/obo/NCIT_C21514 (ex: obo:Per Day)
- **frequency_value**: Frequency value prescribe to the patient
- **agent_id**: ATC URI-code for drugs components. (example: https://www.whocc.no/atc_ddd_index/?code=A07EA01)
- **model**: Medications
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`.
- **comments**: Human readable comments of any kind related to this procedure


## Intervention (Surgery):

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **process_type**: Child of Intervention or Procedure http://purl.obolibrary.org/obo/NCIT_C25218 (ex: obo:Tumor Resection http://purl.obolibrary.org/obo/NCIT_C164212)
- **target_type**:  Child of Anatomic Structure, System, or Substance
or obo:Material (example: obo: Tumor Tissue http://purl.obolibrary.org/obo/NCIT_C18009)
- **model**: Surgery
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`.
- **comments**: Human readable comments of any kind related to this procedure


## Clinical trials:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/phenotype relationship or some elements under same visit occurrence)
- **agent_id**: GUID for this medical center where this clinical trial is taking place.
- **attribute_id**: IRI that defines clinical condition: Human Phenotype ontology (HPO) term or Orphanet disease ontology (ORDO) (full URL such as http://www.orpha.net/ORDO/Orphanet_100031)
- **model**: Clinical_trial
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`.
- **comments**: Human readable comments of any kind related to this procedure
