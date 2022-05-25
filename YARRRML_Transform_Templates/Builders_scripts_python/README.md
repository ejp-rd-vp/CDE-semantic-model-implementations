# EMbuilder workflow:

## Instalation:
Please install builder module for Python:

```python
pip install EMbuilder
```

## Use case:

#### You can use ```emb.py``` to execute any of the Python3-based builder scripts from this repository. You only need to execute embuilder.py file using as arguments:
+ name of the builder you want to execute
+ the representation you want to obtain: YARRRML, ShEx or OBDA

### Examples:
For executing yarrrml for Pseudonym builder:

```python3
python3 emb.py builder_pseudonym yarrrml
```

For executing ShEx for Diagnosis builder:

```python3
python3 emb.py builder_diagnosis shex
```

You can also iterate this process using ```exploit.sh``` to execute multiple scripts at once, providing all tagnames of the builder (builder_TAGNAME.py) and the path to store them:

```sh
# CHOOSE ALL TAGNAMES TO NEED:
declare -a Models=("personal_information" "patient_status" "care_pathway" "diagnosis" "disease_history" "genetic_diagnosis" "phenotyping" "undiagnosed" "patient_consent" "disability")

for val in ${Models[@]}; 
do
    # CHANGE YOUR PATH
    python3 embuilder.py builder_${val} yarrrml > CHOOSE/YOUR/PATH/${val}_yarrrml_template.yaml # Change file format to .obda or .shex if you change your implementation
done
```