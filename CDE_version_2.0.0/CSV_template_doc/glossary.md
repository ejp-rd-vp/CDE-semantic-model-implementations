# Glossary: Data source requirements for CDE semantic model.

The name of each parameter that defines this common data elements are not the column names, but the same you have to referenced using a [YAML file](../Version_transformation/CDEconfig.yaml) to preprocess your data source (CSV) using [Hefesto](https://github.com/pabloalarconm/Hefesto) module before making the RDF transformation.

## CDE - Birthdate:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **value**: ISO 8601 formatted date (not date time)
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:date by default
- **model**: Birthdate
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`.  


## CDE - Sex:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **value**: Human readable label that defines sex (ex: Female)
- **valueIRI**: one of the following: 
    * http://purl.obolibrary.org/obo/NCIT_C16576 (Female) ; 
    * http://purl.obolibrary.org/obo/NCIT_C20197 (Male); 
    * http://purl.obolibrary.org/obo/NCIT_C124294 (Undetermined) ; 
    * http://purl.obolibrary.org/obo/NCIT_C17998 (Unknown, use this for foetal undetermined) 
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:string by default
- **model**: Sex
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 



## CDE - Status:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **value**: Human readable label that defines status (ex: Alive)
- **valueIRI**: one of the following: 
    * http://semanticscience.org/resource/SIO_010059 (dead)
    * http://semanticscience.org/resource/SIO_010058 (alive)
    * http://purl.obolibrary.org/obo/NCIT_C70740 (lost to follow-up)
    * http://purl.obolibrary.org/obo/NCIT_C124784 (refused to participate)
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:string by default
- **model**: Status
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 


## CDE - Deathdate:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **value**: ISO 8601 formatted date of death (not date time)
- **valueIRI**: one of the following: 
    * http://semanticscience.org/resource/SIO_010059 (dead)
    * http://semanticscience.org/resource/SIO_010058 (alive)
    * http://purl.obolibrary.org/obo/NCIT_C70740 (lost to follow-up)
    * http://purl.obolibrary.org/obo/NCIT_C124784 (refused to participate)
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:date by default
- **model**: Deathdate
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 


## CDE - Care Pathway:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **value**: ISO 8601 formatted date of first confirmed visit (not date time)
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:date by default
- **model**: Care_pathway
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 


## CDE - Diagnosis:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **value**: Label that describes diagnosis information
- **valueIRI**: Orphanet disease ontology (full URL such as http://www.orpha.net/ORDO/Orphanet_100031)
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:string by default
- **model**: Diagnosis
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 


## CDE - Onset of diagnosis:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **valueIRI**: one of the following:
    * http://purl.obolibrary.org/obo/HP_0030674 (Antenatal onset)
    * http://purl.obolibrary.org/obo/HP_0003577 (Congenital onset)
    * http://purl.obolibrary.org/obo/NCIT_C124294 (Undetermined) 
    * http://purl.obolibrary.org/obo/NCIT_C93613 (Onset Date) - use this when you are going to provide a date
- **value**: ISO 8601 formatted date of diagnosis (not date time) in case of date of diagnosis is defined as a date
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:date by default
- **model**: Onset_diagnosis
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 


## CDE - Onset of symptoms:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **valueIRI**: one of the following:
    * http://purl.obolibrary.org/obo/HP_0030674 (Antenatal onset)
    * http://purl.obolibrary.org/obo/HP_0003577 (Congenital onset)
    * http://purl.obolibrary.org/obo/NCIT_C124294 (Undetermined) 
    * http://purl.obolibrary.org/obo/NCIT_C93613 (Onset Date) - use this when you are going to provide a date
- **value**: ISO 8601 formatted date of symptom's onset (not date time) in case of date of diagnosis is defined as a date
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:date by default
- **model**: Onset_symptoms
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 


## CDE - Phenotype:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **value**: Label that describes phenotype information
- **valueIRI**: Full Human Phenotype Ontology (HPO) URI 
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:string by default
- **model**: Phenotype
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 


## CDE - Genotype_OMIM:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **value**: OMIM variant/gene notation code
- **valueIRI**: OMIM gene code constructed by appending the OMIM number to, https://www.omim.org/entry/{OMIM code} e.g. https://www.omim.org/entry/310200
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:string by default
- **model**: Genotype_OMIM
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 


## CDE - Genotype_HGNC:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **value**: HGNC gene notation code
- **valueIRI**: HGNC gene code this constructed by appending the HGNC code to https://bioregistry.io/{HGNC code} e.g. https://bioregistry.io/HGNC:2928
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:string by default
- **model**: Genotype_HGNC
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 


## CDE - Genotype_HGVS:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **value**: HGVS variant notation code
- **valueIRI**: URI of the clinical variant (e.g. https://identifiers.org/clinvar:4886)
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:string by default
- **model**: Genotype_HGVS
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 

## CDE - Consent for being contacted:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **value**: Some label describing consent outcome
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:string by default
- **model**: Consent_contacted
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 

## CDE - Consent for Data (Re)Use Permission:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **value**: Some label describing consent outcome
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:string by default
- **model**: Consent_used
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 


## CDE - Biobank:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **value**: Biobank Identifier as https://directory.bbmri-eric.eu/{biobank id}
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:string by default
- **model**: Biobank
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`. 


## CDE - Disability:

- **pid**: Patient unique identifier
- **context_id**: *(OPTIONAL)* Contextual identifier in case you want to relate several data elements under a common context (ex: certain diagnosis/pehnotype relationship or some elements under same visit occurrence)
- **valueIRI**: Some child of http://purl.obolibrary.org/obo/NCIT_C20993 (research or clinical assessment tool)
- **value_datatype**: XSD datatype that defines `value` column type, for this case is xsd:float by default, but depending on your score's datatype, it could be different
- **value**: the numeric score of the output from the test
- **model**: Disability
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: (OPTIONAL) ISO 8601 formatted enddate of observation in case it is different from `startdate`.


## Example CSV file:
Please find example CSV file [here](/CDE_version_2.0.0/CSV_template_doc/CDE.csv)


## YARRRML template:
Please find the YARRRML template for this module [here](/CDE_version_2.0.0/YARRRML/CDE_yarrrml_template.yaml)
  
