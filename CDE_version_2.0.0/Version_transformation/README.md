# CSV transformation from Common Data Elements Semantic model V1.0.0 to V2.0.0

This CSV template transformation is based on Python library called `Hefesto`. This library will allow you to take one or multiple CSV that contain your Common Data Elements compatible with CDE semantic model  `v1.0.0` release and turn them into a CSV template complatible with our latest version of our CDE semantic model.

Documentation for this library is located here: https://github.com/pabloalarconm/Hefesto


## Usage:
```bash
pip install Hefesto
```
**Requirements**


This library consumes a CSV with your CDE data YAML configuration file to define which CDE do you want to execute and which columns contains the information. Its located here: [`CDEconfig.yaml`](/CDE_version_2.0.0/Version_transformation/CDEconfig.yaml)

**Preparation**

You can use this pipeline to define the location of each component (`CDEconfig.yaml`, CSV input data file and your resulting CSV)

```py
from Hefesto.main import Hefesto
import yaml

location_config_file = "CDEconfig.yaml" ## USE THIS YAML FROM THIS GITHUB REPO
location_data_input = "exemplarCDEdata.csv" ## ADD HERE THE LOCARTION OF YOUR CSV DATA
cde_tagname = ["Birth_date","Sex"] # DEFINED ALL COMMON DATA ELEMENTS TO OBATIN FROM THIS DATA

## possible tagnames for your CDEs:  
# "Birth_date"
# "Sex"
# "Status"
# "Date_of_death"
# "Care pathway"
# "Diagnosis"
# "Date_of_diagnosis"
# "Onset_of_symptoms"
# "Genotype_OMIM"
# "Genotype_HGNC"
# "Phenotype"
# "Consent"
# "Disability"

with open(location_config_file) as file:
    configuration = yaml.load(file, Loader=yaml.FullLoader)

for tag in cde_tagname:
    for config in configuration.items():
        if config[0] == tag:
            configuration_entry = {tag: config[1]}
            test = Hefesto.transform_shape(path_datainput = location_data_input, configuration = {tag: config[1]})
            test.to_csv ("../CSV_template_doc/exemplar_unifiedCDE_{}.csv".format(tag), index = False, header=True)
```
**Execution**

```bash
python3 test_hefesto.py
```
