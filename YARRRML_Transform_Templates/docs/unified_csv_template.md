# Unified CDE model


## General Glossary for any CDE:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: Domain-specific term to define the process among sio:process 
- **outputURI**: Domain-specific term to define the output among sio:information-content-entity
- **inputURI**: Domain-specific term to define the input among sio:information-content-entity
- **attributeURI**: Domain-specific term to define the input among sio:attribute
- **valueOutputDate**: Datetime value from ouput node
- **valueOutputNumber**: Numeric (float) value from output node
- **valueOutputString**: String value from output node
- **valueInputString**: String value from input node
- **valueAttributeIRI**: IRI datatype from attribute node
- **model**: defines which CDE are we generating



## CDE - Birth date:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C142470 
- **outputURI**: http://www.ebi.ac.uk/efo/EFO_0006921
- **inputURI**: None
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C68615
- **valueOutputDate**: ISO 8601 formatted date (not date time)
- **valueOutputNumber**: None
- **valueOutputString**: None
- **valueInputString**: None
- **valueAttributeIRI**: None
- **model**: Birth_date


## CDE - Sex:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C142470 
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C103159
- **inputURI**: None
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C28421
- **valueOutputDate**: None
- **valueOutputNumber**: None
- **valueOutputString**: Human readable label that defines sex (ex: Female)
- **valueInputString**: None
- **valueAttributeIRI**: one of the following: 
    * http://purl.obolibrary.org/obo/NCIT_C16576 (Female) ; 
    * http://purl.obolibrary.org/obo/NCIT_C20197 (Male); 
    * http://purl.obolibrary.org/obo/NCIT_C124294 (Undetermined) ; 
    * http://purl.obolibrary.org/obo/NCIT_C17998 (Unknown, use this for foetal undetermined) 
- **model**: Sex



## CDE - Patient Status:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C142470 
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C103159
- **inputURI**: None
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C166244
- **valueOutputDate**: None
- **valueOutputNumber**: None
- **valueOutputString**: Human readable label that defines status (ex: Alive)
- **valueInputString**: None
- **valueAttributeIRI**: one of the following: 
    * http://semanticscience.org/resource/SIO_010059 (dead)
    * http://semanticscience.org/resource/SIO_010058 (alive)
    * http://purl.obolibrary.org/obo/NCIT_C70740 (lost to follow-up)
    * http://purl.obolibrary.org/obo/NCIT_C124784 (refused to participate)
- **model**: Patient_status


## CDE - Date of Death:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C142470 
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C103159
- **inputURI**: None
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C70810
- **valueOutputDate**: ISO 8601 formatted date of death (not date time)
- **valueOutputNumber**: None
- **valueOutputString**: None
- **valueInputString**: None
- **valueAttributeIRI**: one of the following: 
    * http://semanticscience.org/resource/SIO_010059 (dead)
    * http://semanticscience.org/resource/SIO_010058 (alive)
    * http://purl.obolibrary.org/obo/NCIT_C70740 (lost to follow-up)
    * http://purl.obolibrary.org/obo/NCIT_C124784 (refused to participate)
- **model**: Date_of_death


## CDE - Care Pathway:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C159705 
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C25716
- **inputURI**: None
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C164021
- **valueOutputDate**: ISO 8601 formatted date of first confirmed visit (not date time)
- **valueOutputNumber**: None
- **valueOutputString**: None
- **valueInputString**: None
- **valueAttributeIRI**: None
- **model**: Care_pathway


## CDE - Diagnosis:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C15220 
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C103159
- **inputURI**: None
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C25482
- **valueOutputDate**: None
- **valueOutputNumber**: None
- **valueOutputString**: None
- **valueInputString**: None
- **valueAttributeIRI**: Orphanet disease ontology (full URL such as http://www.orpha.net/ORDO/Orphanet_100031)
- **model**: Diagnosis


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
- **inputURI**: None
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C156420
- **valueOutputDate**: ISO 8601 formatted date of first confirmed visit (not date time)
- **valueOutputNumber**: None
- **valueOutputString**: None
- **valueInputString**: None
- **valueAttributeIRI**: None
- **model**: Date_of_diagnosis


## CDE - Onset_of_symptoms:

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
- **inputURI**: None
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C25279
- **valueOutputDate**: ISO 8601 formatted date of first confirmed visit (not date time)
- **valueOutputNumber**: None
- **valueOutputString**: None
- **valueInputString**: None
- **valueAttributeIRI**: None
- **model**: Onset_of_symptoms


## CDE - Phenotype:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C25305
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C125204
- **inputURI**: None
- **attributeURI**: http://semanticscience.org/resource/SIO_010056
- **valueOutputDate**: None
- **valueOutputNumber**: None
- **valueOutputString**: None
- **valueInputString**: None
- **valueAttributeIRI**: Full Human Phenotype Ontology (HPO) URI 
- **model**: Phenotype


## CDE - Genotype OMIM:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C15709
- **outputURI**: http://edamontology.org/data_1153
- **inputURI**: None
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C17938
- **valueOutputDate**: None
- **valueOutputNumber**: None
- **valueOutputString**: OMIM code constructed by appending the OMIM number to ",https://www.omim.org/entry/" e.g. https://www.omim.org/entry/310200
- **valueInputString**: None
- **valueAttributeIRI**: None
- **model**: Genotype_OMIM


## CDE - Genotype HGNC:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C15709
- **outputURI**: http://edamontology.org/data_2295
- **inputURI**: None
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C17938
- **valueOutputDate**: None
- **valueOutputNumber**: None
- **valueOutputString**: HGNC code this is constructed by appending the HGNC code to https://bioregistry.io/  e.g. https://bioregistry.io/HGNC:2928
- **valueInputString**: None
- **valueAttributeIRI**: None
- **model**: Genotype_HGNC


## CDE - Genotype HGVS:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/NCIT_C15709
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C17938
- **inputURI**: None
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C17938
- **valueOutputDate**: None
- **valueOutputNumber**: None
- **valueOutputString**: URI of the clinical variant (e.g. https://bioregistry.io/clinvar:4886)
- **valueInputString**: None
- **valueAttributeIRI**: None
- **model**: Genotype_HGVS


## CDE - Consent:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/OBI_0000810
- **outputURI**: Some child of http://purl.obolibrary.org/obo/DUO_0000001 (ICO/DUI Data Use Permission) or http://purl.obolibrary.org/obo/OBIB_0000488 (willingness to be contacted)
- **inputURI**: http://purl.obolibrary.org/obo/ICO_0000001
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C25460
- **valueOutputDate**: None
- **valueOutputNumber**: None
- **valueOutputString**: Some label describing the meaning of the result_uri
- **valueInputString**: the URI/URL to the raw (not patient-filled) consent document
- **valueAttributeIRI**: None
- **model**: Consent


## CDE - Biobanking:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: http://purl.obolibrary.org/obo/OMIABIS_0000061
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C19157
- **inputURI**: http://purl.obolibrary.org/obo/OMIABIS_0000000
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C25429
- **valueOutputDate**: None
- **valueOutputNumber**: None
- **valueOutputString**: None
- **valueInputString**: Biobank Identifier
- **valueAttributeIRI**: None
- **model**: Biobanking


## CDE - Disability:

- **pid**: Patient unique identifier
- **uniqid**: Row unique identifier (ex: millisecond timestamp)
- **chronoid**: Time-oriented identifier to relate models with same date of observation
- **processURI**: Some child of http://purl.obolibrary.org/obo/NCIT_C20993 (research or clinical assessment tool)
- **outputURI**: http://purl.obolibrary.org/obo/NCIT_C25338
- **inputURI**: http://purl.obolibrary.org/obo/NCIT_C17048
- **attributeURI**: http://purl.obolibrary.org/obo/NCIT_C21007
- **valueOutputDate**: None
- **valueOutputNumber**: the numeric score of the output from the test (In case there's one)
- **valueOutputString**: the string score of the output from the test (In case there's one)
- **valueInputString**: None
- **valueAttributeIRI**: None
- **model**: Consent



## Example CSV file:
Please find example CSV file [here](../exemplar_csv/unifiedCDE.csv)


## YARRRML template:
Please find the YARRRML template for this module [here](../templates/unifiedCDE_yarrrml_template.yaml)
  
