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
    genetic_diagnosis = ["Genotype_OMIM", "Genotype_HGNC", "Genotype_HGVS"],
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
                    transform = test.transform_shape(configuration={element: config[1]})
                    resulting_table = pd.concat([transform, resulting_table])
resulting_table.to_csv ("resulting_V1_CDE.csv", index = False, header=True)
