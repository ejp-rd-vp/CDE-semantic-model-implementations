# Common Data Element semantic model implemention for latest version:

## Motivation for a new version

While considerable time was spent on the first generation of CDE models, the final published set remained inconsistent in a number of ways:

1) Nodes had different numbers of ontological annotaions, with no justification
2) The CDE models adopted the high-level CDEs defined by the RD Platform, which were often aggregations of individual data elements.  As a consequence:

    a) Registries did not always have all of the individual subcomponents to fulfil the model
    
    b) It was unclear what to do when a model couldn't be filled
    
    c) This led to data loss, when those data elements were not FAIR-transformed

3) Date/time were sometimes included in the model, and sometimes not
4) The CSV files all had a distinct structure, meaning each one needed fairly specialized code to generate
5) There was no easy way to aggregate various observations together that might be related (e.g. the observations/interventions made during the course of a COVID infection)

## Features of the new version:

1) The overall model is identical to the original Core CDE model
2) Only one data element is modelled at a time; if you do not have that element, you do not use that model
3) Every element of the model has an "upper ontology" type (e.g. "process") and a domain-specific type (e.g. "blood presssure measurement process").  Exactly two types per node.
4) Date/Time is now considered metadata of the data model.  Even in the case where date/time are the core observation of the model (e.g. date of symptom onset) that information is duplicated as the start date of the observation in its metadata.  Thus, all models are identical in structure and metadata
5) This metadata takes the form of a "context" node (i.e. an RDF Quad, rather than an RDF Triple), which is annotated with various things.  In addition, the context node becomes "part of" a patient's overall timeline, which itself is modelled in RDF and creates a larger grouping of all observations about a patient.
6) In addition to being "part of" a patient's timeline, context nodes _can be_ grouped into other arbitrary collections reflecting other kinds of groupings (like the COVID-19 infection scenario described above).  

     a) WE DO NOT IMPLEMENT THIS IN THE NEW MODEL - it is merely made possible by this new model, which was not the case with the Version 1 models.
  


## YARRRML template creation:

Our current functional **YARRRML** CDE template is located [here](/CDE_version_2.0.0/YARRRML/unifiedCDE_yarrrml_template.yaml). 
Also all information related to our **YARRRML template builder** is located [here](/CDE_version_2.0.0/YARRRML/README.md).

## CSV template documentation:

Documentation for all **CSV data requirements** needed to generate each common data element, please go [here](/CDE_version_2.0.0/CSV_template_doc/).
Also, **exemplar CSV** for our CDE model is located [here](/CDE_version_2.0.0/CSV_template_doc/exemplar_unifiedCDE.csv).

## Transformation pipeline from previous version:

If you already have generated CSV compatible with our previous versions of CDE semantic models, You can adapt your CSV templates to our new structure with a pipeline prepared to obtain new CSV templates prepared for our latest release. All documentation is located [here](/CDE_version_2.0.0/Version_transformation/).
