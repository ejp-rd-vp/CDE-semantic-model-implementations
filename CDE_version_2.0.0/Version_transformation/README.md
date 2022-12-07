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

You can use this [pipeline](/CDE_version_2.0.0/Version_transformation/test_hefesto.py) to define the path of [version 1.0.0 CDE-based CSV input data files](/CDE_version_1.0.0/exemplar_csv/), and perform the transformation:

```py
from Hefesto.main import Hefesto
import yaml
from perseo.main import get_files
import pandas as pd


path_config_file = "CDEconfig.yaml" ## USE THIS YAML FROM THIS GITHUB REPO
path_files= "../../CDE_version_1.0.0/exemplar_csv/"

with open(path_config_file) as file:
    configuration = yaml.load(file, Loader=yaml.FullLoader)



all_files = get_files(path_files, format="csv")
print(all_files)


model_relation = dict(
    personal_information = ["Birthdate", "Sex"],
    patient_status = ["Status","Date_of_death"],
    care_pathway = ["Care_pathway"],
    diagnosis = ["Diagnosis"],
    disease_history = ["Date_of_diagnosis", "Date_of_symptoms"],
    genetic_diagnosis = ["Genotype_OMIM", "Genotype_HGNC"],
    phenotyping = ["Phenotype"],
    patient_consent = ["Consent"],
    disability = ["Disability"]
)

resulting_table = pd.DataFrame(index=[1])

for model in model_relation.items():
    file = model[0] + ".csv"
    if file in all_files:
        for element in model[1]:
            for config in configuration.items():
                if config[1]["cde"] == element:
                    path = path_files + file
                    test = Hefesto(datainput = path)
                    transform = test.transform_shape(configuration={element: config[1]}, clean_blanks=False)
                    resulting_table = pd.concat([transform, resulting_table])
resulting_table.to_csv ("unifiedCDE_fromV1.csv", index = False, header=True)

```
**Execution**

```bash
python3 test_hefesto.py
```
