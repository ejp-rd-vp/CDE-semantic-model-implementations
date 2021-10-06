# Implementations and artefacts related to Common Data Elements models:

<hr>

This repository is fed by a variety of implementations based on semantic data model of common data elements registry [(see Github page).](https://github.com/ejp-rd-vp/CDE-semantic-model)

## Templates (YARRRML and CSV)
The transformation tools make use of YARRRML to capture triple transformation rules. Our YARRRML transformation files take `CSV` as input file format with certain headers for each CDE modules. If you would like to know more about the YARRRML and CSV templates, please click [here](YARRRML_Transform_Templates/README.md).


## YARRRML Tool

1) YARRRML Template Builder service that builds YARRRML templates based on Ruby's script. (Check ```YARRRML_Transform_Templates/Builder_Scripts``` folder).

<br>

2) YARRRML-into-RDF transformation tool. It generates resulting nTriples from YARRRML Templates using CSV files as data sources. Documentation [here](YARRRML_Tools/yarrrml_template_builder/README.md)

<br>

## CDE-in-a-box-Daemon