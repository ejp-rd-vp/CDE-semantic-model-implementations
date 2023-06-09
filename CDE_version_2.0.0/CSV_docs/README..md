# Common Data Element (CDE) Semantic model implementation: CSV data documentation.

This workflow is specifically designed to handle and process CSV-formatted files containing a multitude of data elements. Each data element must adhere to stringent formatting guidelines and be meticulously structured with precise column names and information disposition.

[CDE YARRRML templates](/CDE_version_2.0.0/YARRRML/README.md) utilize column name references to map and transform the data into a designated RDF (Resource Description Framework) structure. Therefore, it is crucial to correctly associate the data with the appropriate columns and datatypes to generate RDF-based CDE-oriented patient data.


## Data Glossary

Every data element defined by the European Joint Project - Rare Diseases is described at this [glossary](/CDE_version_2.0.0/CSV_docs/glossary.md) and defined by a set of sufficient columns to be represented.


## [Hefesto](https://github.com/pabloalarconm/Hefesto) - Curation Toolkit: A Critical Step in the Workflow

Hefesto serves as a module dedicated to performing a curation step prior to the conversion of data into RDF. The primary transformations carried out by Hefesto include:

* Adding every domain specific ontological term required to define every instances of the model, these terms are specific for every data element.

* Splitting the column labeled as `value` into distinct datatypes. This enables YARRRML to interpret each datatype differently, facilitating the subsequent processing.

* Conducting a sanity check on the `stardate` and `enddate` columns to ensure data consistency and validity.

* Eliminating any input rows that lack of the minimal required data to minimize the generation of incomplete RDF transformations.

* Creation of the column called `uniqid` that assigns a unique identifier to each observation. This prevents the RDF instances from overlapping with one another, ensuring their distinctiveness and integrity.

In conclusion, the implementation of the Common Data Element (CDE) Semantic Model for CSV data entails a meticulous and technically advanced workflow. By leveraging the power of the CDE YARRRML templates and incorporating the critical curation step executed by the Hefesto toolkit, this implementation achieves robustness, accuracy, and reliability in generating RDF-based CDE-oriented patient data.

For more information about the different ways to implement Hefesto, please check the [Github repository](https://github.com/pabloalarconm/Hefesto).

## Exemplar CDE data

You can also find an exemplar patient data table **before and after** Hefesto implementation at `exemplar_data` folder