# Unified CDE model


## General Glossary for any CDE:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: Domain-specific term to define the process among sio:process 
- **outputURI**: Domain-specific term to define the output among sio:information-content-entity
- **attributeURI**: Domain-specific term to define the input among sio:attribute
- **valueOutput**: Datetime value from ouput node
- **datatype** : Output value datatype defined XSD scheme 
- **valueAttributeIRI**: IRI datatype from attribute node
- **model**: defines which CDE are we generating
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation 




## CDE - Birthdate:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C142470 
- **outputURI**: http://www.ebi.ac.uk/efo/EFO_0006921
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C68615
- **valueOutput**: ISO 8601 formatted date (not date time)
- **datatype** : xsd:date
- **valueAttributeIRI**: None
- **model**: Birthdate
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation 


## CDE - Sex:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C142470 
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C103159
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C28421
- **valueOutput**: Human readable label that defines sex (ex: Female)
- **datatype** : xsd:string 
- **valueAttributeIRI**: one of the following: 
    * http://purl.obolibrary.org/obo/NCIT_C16576 (Female) ; 
    * http://purl.obolibrary.org/obo/NCIT_C20197 (Male); 
    * http://purl.obolibrary.org/obo/NCIT_C124294 (Undetermined) ; 
    * http://purl.obolibrary.org/obo/NCIT_C17998 (Unknown, use this for foetal undetermined) 
- **model**: Sex
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation 



## CDE - Status:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C142470 
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C103159
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C166244
- **valueOutput**: Human readable label that defines status (ex: Alive)
- **datatype** : xsd:string
- **valueAttributeIRI**: one of the following: 
    * http://semanticscience.org/resource/SIO_010059 (dead)
    * http://semanticscience.org/resource/SIO_010058 (alive)
    * http://purl.obolibrary.org/obo/NCIT_C70740 (lost to follow-up)
    * http://purl.obolibrary.org/obo/NCIT_C124784 (refused to participate)
- **model**: Status
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation 


## CDE - Date of Death:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C142470 
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C103159
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C70810
- **valueOutput**: ISO 8601 formatted date of death (not date time)
- **datatype** : xsd:date 
- **valueAttributeIRI**: one of the following: 
    * http://semanticscience.org/resource/SIO_010059 (dead)
    * http://semanticscience.org/resource/SIO_010058 (alive)
    * http://purl.obolibrary.org/obo/NCIT_C70740 (lost to follow-up)
    * http://purl.obolibrary.org/obo/NCIT_C124784 (refused to participate)
- **model**: Date_of_death
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation 


## CDE - Care Pathway:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C159705 
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C25716
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C164021
- **valueOutput**: ISO 8601 formatted date of first confirmed visit (not date time)
- **datatype** : xsd:date 
- **valueAttributeIRI**: None
- **model**: Care_pathway
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation 


## CDE - Diagnosis:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C15220 
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C103159
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C2991
- **valueOutput**: Label that describes diagnosis information
- **datatype** : xsd:string
- **valueAttributeIRI**: Orphanet disease ontology (full URL such as http://www.orpha.net/ORDO/Orphanet_100031)
- **model**: Diagnosis
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation 


## CDE - Date of diagnosis:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C142470 
- **outputURI**: one of the following:
    * http://purl.obolibrary.org/obo/NCIT_C81318 (Prenatal)
    * http://purl.obolibrary.org/obo/NCIT_C81317 (Postnatal)
    * http://purl.obolibrary.org/obo/NCIT_C124294 (Undetermined) 
    * http://purl.obolibrary.org/obo/NCIT_C25164 (Date) - use this when you are going to provide a date
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C156420
- **valueOutput**: ISO 8601 formatted date of diagnosis (not date time) in case of date of diagnosis is defined as a date
- **datatype**: xsd:date (in case of date of diagnosis is defined as a date)
- **valueAttributeIRI**: None
- **model**: Date_of_diagnosis
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation 


## CDE - Date of symptoms:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C142470 
- **outputURI**: one of the following:
    * http://purl.obolibrary.org/obo/HP_0410280 (Pediatric onset)
    * http://purl.obolibrary.org/obo/HP_0003581 (Adult onset)
    * http://purl.obolibrary.org/obo/HP_0030674 (Antenatal onset)
    * http://purl.obolibrary.org/obo/HP_0003623 (Neonatal onset)
    * http://purl.obolibrary.org/obo/HP_0003577 (Congenital onset)
    * http://purl.obolibrary.org/obo/NCIT_C124294 (Undetermined) 
    * http://purl.obolibrary.org/obo/NCIT_C25164  (Date) - use this when you are going to provide a date
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C25279
- **valueOutput**: ISO 8601 formatted date of symptom's onset (not date time) in case of date of diagnosis is defined as a date
- **datatype**: xsd:date (in case of date of diagnosis is defined as a date)
- **valueAttributeIRI**: None
- **model**: Date_of_symptoms
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation 


## CDE - Phenotype:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C25305
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C125204
- **attributeURI**: http://semanticscience.org/resource/SIO_010056
- **valueOutput**: Label that describes phenotype information
- **datatype** : xsd:string
- **valueAttributeIRI**: Full Human Phenotype Ontology (HPO) URI 
- **model**: Phenotype
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation 


## CDE - Genotype:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C15709
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C17248
- **attributeURI**: Gene ID type, one of the following:
    * http://edamontology.org/data_1153 for OMIM ID
    * http://edamontology.org/data_2295 for HGNC ID
- **valueOutput**: HGVS variant notation code
- **datatype**: xsd:string
- **valueAttributeIRI**: One of the following:
    * OMIM gene code constructed by appending the OMIM number to ", https://www.omim.org/entry/{OMIM code}" e.g. https://www.omim.org/entry/310200
    * HGNC gene code this constructed by appending the HGNC code to https://bioregistry.io/{HGNC code}  e.g. https://bioregistry.io/HGNC:2928
- **model**: Genotype
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation 


## CDE - Consent:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/OBI_0000810
- **outputURI**: Some child of http://purl.obolibrary.org/obo/DUO_0000001 (ICO/DUI Data Use Permission) or http://purl.obolibrary.org/obo/OBIB_0000488 (willingness to be contacted)
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C25460
- **valueOutput**: Some label describing consent outcome
- **datatype**: xsd:string
- **valueAttributeIRI**: None
- **model**: Consent
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation 


## CDE - Biobank:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/OMIABIS_0000061
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C115570
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C25429
- **valueOutput**: Biobank Identifier as https://directory.bbmri-eric.eu/
- **datatype**: xsd:string
- **valueAttributeIRI**: None
- **model**: Biobank
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation 


## CDE - Disability:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: Some child of http://purl.obolibrary.org/obo/NCIT_C20993 (research or clinical assessment tool)
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C25338
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C21007
- **valueOutput**: the numeric score of the output from the test
- **datatype**: xsd:integer
- **valueAttributeIRI**: None
- **model**: Disability
- **startdate**: ISO 8601 formatted start date of observation
- **enddate**: ISO 8601 formatted end date of observation



## Example CSV file:
Please find example CSV file [here](/CDE_version_2.0.0/CSV_template_doc/exemplar_unifiedCDE.csv)


## YARRRML template:
Please find the YARRRML template for this module [here](/CDE_version_2.0.0/YARRRML/unifiedCDE_yarrrml_template.yaml)
  
