# YARRRML Builder:

The YARRRML is a crutial component in the execution of the Common Data Element (CDE) implementation workflow. However, creating and editing the required RDF templates can be a complex endeavor, primarily due to their intricate structure and vertical layout, essential for establishing a comprehensive model.

To address this challenge, a YARRRML builder tool called [EMbuilder](https://github.com/pabloalarconm/EMbuilder) has been developed. EMbuilder, implemented as a Python3-based script, simplifies the creation and modification of YARRRML templates by allowing precise definition of triplets' information and configuration-related parameters. This tool enables the generation of fully functional YARRRML templates, alleviating the burden associated with their manual creation.

EMbuilder goes beyond YARRRML generation and offers the flexibility to obtain multiple semantic representations, including OBDA (Ontology-Based Data Access), ShEx (Shape Expressions), and SPARQL (SPARQL Protocol and RDF Query Language). By leveraging this comprehensive tool, users can effortlessly generate various representations to suit their specific needs and requirements.

For detailed documentation and instructions on how to use the EMbuilder library, please refer to the official repository located at: https://github.com/pabloalarconm/EMbuilder

To tackle the challenge of handling different instances within these data representations and the inability to perform customized functions within the YARRRML templates using our RDF transformation tool, two distinct templates have been developed. Each template is tailored to handle the primary data shapes encountered in the CDE implementation process.

Both the Python-based YARRRML builder script and the resulting templates are available in this folder.