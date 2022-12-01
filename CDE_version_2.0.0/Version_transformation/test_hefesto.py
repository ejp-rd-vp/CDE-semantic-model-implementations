from Hefesto.main import Hefesto
import yaml


location_config_file = "CDEconfig.yaml" ## USE THIS YAML FROM THIS GITHUB REPO
location_data_input = "exemplarCDEdata.csv" ## ADD HERE THE LOCARTION OF YOUR CSV DATA
cde_tagname = ["Birthdate","Sex"] # DEFINED ALL COMMON DATA ELEMENTS TO OBATIN FROM THIS DATA

# # possible tagnames for your CDEs:  
# "Birthdate"
# "Sex"
# "Status"
# "Date_of_death"
# "Care_pathway"
# "Diagnosis"
# "Date_of_diagnosis"
# "Date_of_symptoms"
# "Genotype_OMIM"
# "Genotype_HGNC"
# "Phenotype"
# "Consent"
# "Disability"

with open(location_config_file) as file:
    configuration = yaml.load(file, Loader=yaml.FullLoader)

for tag in cde_tagname:
    for config in configuration.items():
        if config[1]["cde"] == tag:
            test = Hefesto(datainput = location_data_input)
            transform = test.transform_shape(configuration={tag: config[1]})
            test.to_csv ("../CSV_template_doc/exemplar_unifiedCDE_{}.csv".format(tag), index = False, header=True)