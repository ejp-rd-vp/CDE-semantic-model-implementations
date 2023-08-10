# Common Data Element semantic model implementation 

## CONTENTS

* [Quick Start](#QuickStart)
* [Full EJP Implementation](#Details)
* [Using the CDE Semantic Model "standalone"](#Standalone)


<a name="QuickStart"></a>
## Quick Start
To jump directly to the "just tell me what I have to do to make this work", please [follow this link](https://github.com/ejp-rd-vp/FiaB/blob/master/CDE%20version%202%20Models%20FiaB).

If you want to understand more deeply what you are doing, read on!

---

## CDE Model in Detail
<a name="Details"></a>


[Common Data Element Semantic Model](https://github.com/ejp-rd-vp/CDE-semantic-model) defines a set of clinical data elements used in the healthcare domain of knowledge. However, it doesn't specify a mechanism for bringing these to life. For the European Joint Project for Rare Diseases (EJPRD) we propose an implementation workflow that can be described as follows:


<p align="center"> 
	<img src="/CDE_version_2.0.0/misc/workflow.png"> 
	<p align="center">Figure 1: Common data element overall worflow </p> 
</p> 

The typical EJP implementation consumes a CSV data table that follows a common template spanning all types of patient data. Each row is an observation, and depending on the type of observation (e.g. diagosis or phenotyping) different columns of the template must be filled.  The required columns are defined by an [EJP-specific data element glossary](https://github.com/ejp-rd-vp/CDE-semantic-model-implementations/blob/master/CDE_version_2.0.0/CSV_docs/glossary.md). Alongside this standard CSV template is a YARRRML template that defines the final RDF shape based on the CDE semantic model. In the full EJP implementation, sitting between this common CSV and the YARRRML, is an additional step that modifies the template CSV to add additional fields and automatically make certain translations that reduce the complexity and burden on the data provider.  This translation is executed by a component called ["Hefesto"](https://github.com/pabloalarconm/Hefesto) (_note: it is not necessary to understand the functionality of this component to fully take advantage of the EJP pipeline!_)  It is this final, much richer CSV file that is used by the YARRRML to do the final RDF transformation.  

If you wish to create this final CSV directly, and skip the intermediate steps, please go to [Using the CDE Semantic Model "standalone"](#Standalone)

[YARRRML](https://rml.io/yarrrml/spec/) is not an easy language for creating and maintaining complex triplets patterns, that's why we have created a YARRRML builder that consumes a Python script with all information required to generate a fully functional [YARRRML file](/CDE_version_2.0.0/YARRRML/CDE_yarrrml.yaml). Also all information related to our **YARRRML template builder** is located [here](/CDE_version_2.0.0/YARRRML/README.md).

Due to having some YARRRML limitations to define certain references in template and the need of a quality control step at data level before perfoming the data transformation. We have created a Python3-based module (Hefesto) to cover some data curation and adaptation for this workflow. Documentation for all **CSV data requirements** needed to generate each data element, please go [here](/CDE_version_2.0.0/CSV_docs/).

We have created a Dockerized web service that contains YARRRML2RML parser and a RDF transformation tool named [RMLMapper](https://rml.io/) that performs the transformation to RDF.

All these elements, properly Dockerized to work as a workflow, have been mounted into our [FAIR-in-a-box](https://github.com/ejp-rd-vp/FiaB) interface that controls all this patient data transformation using the version 2 of the Common Data Element Semantic model.

### [YARRRML template](/CDE_version_2.0.0/YARRRML/)

Have a look at `YARRRML` folder to know more about the YARRRML builder and the resulting YARRRML templates.

### [CSV documentation](/CDE_version_2.0.0/CSV_docs/)

Check the folder named `CSV_docs` to obtain some exemplar data (before and after our curation step) and also, a glossary to populate your CSV properly to generate CDE-based patient data.

---

<a name="Standalone"></a>

## Implementation without using FAIR-in-a-box

Despite the whole implementation is ready using [FAIR-in-a-box](https://github.com/ejp-rd-vp/FiaB) interface, you have the option to perform RDF transformations locally, without relying on the FAIR-in-a-box toolkit. To support this process, we have developed Docker compose images that cover the entire transformation pipeline.

### YARRRML and CSV preparation:

First, create your YARRRML template using a YARRRML template builder or select the appropriate YARRRML template. Save the template as {TAGNAME}_yarrrml.yaml and place it in the ./data folder, for example, "height_yarrrml.yaml".

In the same ./data folder, create a CSV file with the required headings for your desired transformation, following the guidelines provided in the [accompanying documentation](/CDE_version_2.0.0/CSV_docs/glossary.md). Save the file as {TAGNAME}.csv, e.g., "height.csv". The {TAGNAME} serves as a coordinating identifier among various components during the automation steps and must precisely match the "tag" portion of the template name.

1) **Folder distribution:**
```bash
.
./data/
./data/{TAGNAME}.csv  # Input csv files,  TAGNAME explained above
./data/{TAGNAME}_yarrrml.yaml # YARRRML template
./data/triples/  # Output FAIR data ends up here, this folder will be automatically created.
./docker-compose.yaml # Docker image that will execute the transformation (see step 2 below)
```

2) **RDF transformation execution:**

You can use Docker Compose to run the services:

```yaml
version: "3"
services:
  yarrml-rdfizer:
    image: markw/yarrrml-rml-ejp:0.0.2
    container_name: yarrrml-rdfizer
    environment:
      # (nquads (default), trig, trix, jsonld, hdt, turtle)
      - SERIALIZATION=nquads
    ports:
      - "4567:4567"
    volumes:
      - ./data:/mnt/data
```

Once this services are running, call in your local browser this link: http://127.0.0.1:4567/{TAGNAME}   (where {TAGNAME} is the data/template tag name, as in the examples above, like "height"). RDF file should be created a `./data/triples` folder.