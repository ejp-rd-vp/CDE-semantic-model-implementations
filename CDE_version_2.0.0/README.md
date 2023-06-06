# Common Data Element semantic model implementation 

[Common Data Element Semantic Model](https://github.com/ejp-rd-vp/CDE-semantic-model) defines a set of clinical data elements used in the healthcare domain of knowledge. However, it doesn't specify a way for implementing it. There's several ways to implement this CDE semantic model, from the European Joint Project for Rare Diseases (EJPRD) we propose an implementation workflow.

This implementation consumes a CSV-based data table that contains patient data under a certain glossary that defines the data template. Also, consumes a YARRRML template that references each one of the data requirements and defines the RDF shape based on the CDE semantic model. Both artifacts are the requirement to perform an RDF transformation tool to obtain functional RDF-based data.

[YARRRML](https://rml.io/yarrrml/spec/) is not an easy language for creating and maintaining complex triplets patterns, that's why we have created a YARRRML builder that consumes a Python script with all information required to generate a fully functional [YARRRML file](/CDE_version_2.0.0/YARRRML/CDE_yarrrml_template.yaml). Also all information related to our **YARRRML template builder** is located [here](/CDE_version_2.0.0/YARRRML/README.md).

Due to having some YARRRML limitations to define certain references in template and the need of a quality control step at data level before perfoming the data transformation. We have created a Python3-based module (Hefesto) to cover some data curation and adaptation for this workflow. Documentation for all **CSV data requirements** needed to generate each data element, please go [here](/CDE_version_2.0.0/CSV_docs/).

We have created a Dockerized Ruby-based web service that contains YARRRML2RML parser and a RDF transformation tool named RDFizer that performs the transformation to RDF.

All these elements, properly Dockerized to work as a workflow, have been mounted into our [FAIR-in-a-box](https://github.com/ejp-rd-vp/FiaB) interface that controls all this patient data transformation using the version 2 of the Common Data Element Semantic model.

### [YARRRML template](/CDE_version_2.0.0/YARRRML/)

Have a look at `YARRRML` folder to know more about the YARRRML builder and the resulting YARRRML templates.

### [CSV documentation](/CDE_version_2.0.0/CSV_docs/)

Check the folder named `CSV_docs` to obtain some exemplar data (before and after our curation step) and also, a glossary to populate your CSV properly to generate CDE-based patient data.

## Implementation without using FAIR-in-a-box

Despite the whole implementation is ready using [FAIR-in-a-box](https://github.com/ejp-rd-vp/FiaB) interface, you can run the whole workflow locally by executing each one of the step individually using our Dockerized images and/or each one of the module used.