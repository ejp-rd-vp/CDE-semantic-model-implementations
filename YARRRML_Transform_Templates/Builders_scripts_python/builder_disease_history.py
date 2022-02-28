from embuilder.builder import EMB

prefixes = dict(
  rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#" ,
  rdfs = "http://www.w3.org/2000/01/rdf-schema#" ,
  obo = "http://purl.obolibrary.org/obo/" ,
  sio = "http://semanticscience.org/resource/" ,
  xsd = "http://www.w3.org/2001/XMLSchema#",
  this = "http://my_example.com/")


triplets = [

# Nodes
["this:$(pid)_$(uniqid)#ID","sio:SIO_000020","this:$(pid)_$(uniqid)#Symptom_onset_Role","iri"],
["this:$(pid)_$(uniqid)#Entity","sio:SIO_000228","this:$(pid)_$(uniqid)#Symptom_onset_Role","iri"],
["this:$(pid)_$(uniqid)#Entity","sio:SIO_000008","this:$(pid)_$(uniqid)#Symptom_onset_Attribute","iri"],
["this:$(pid)_$(uniqid)#Symptom_onset_Role","sio:SIO_000356","this:$(pid)_$(uniqid)#Symptom_onset_Process","iri"],
["this:$(pid)_$(uniqid)#Symptom_onset_Process","sio:SIO_000229","this:$(pid)_$(uniqid)#Symptom_onset_Output","iri"],
["this:$(pid)_$(uniqid)#Symptom_onset_Output","sio:SIO_000628","this:$(pid)_$(uniqid)#Symptom_onset_Attribute","iri"],

["this:$(pid)_$(uniqid)#ID","sio:SIO_000020","this:$(pid)_$(uniqid)#Diagnosis_date_Role","iri"],
["this:$(pid)_$(uniqid)#Entity","sio:SIO_000228","this:$(pid)_$(uniqid)#Diagnosis_date_Role","iri"],
["this:$(pid)_$(uniqid)#Entity","sio:SIO_000008","this:$(pid)_$(uniqid)#Diagnosis_date_Attribute","iri"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Role","sio:SIO_000356","this:$(pid)_$(uniqid)#Diagnosis_date_Process","iri"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Process","sio:SIO_000229","this:$(pid)_$(uniqid)#Diagnosis_date_Output","iri"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Output","sio:SIO_000628","this:$(pid)_$(uniqid)#Diagnosis_date_Attribute","iri"],

# Types
["this:$(pid)_$(uniqid)#ID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_$(uniqid)#Entity","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_$(uniqid)#Symptom_onset_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)#Symptom_onset_Role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)#Symptom_onset_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)#Symptom_onset_Process","rdf:type","sio:SIO_001052","iri"],
["this:$(pid)_$(uniqid)#Symptom_onset_Output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)#Symptom_onset_Output","rdf:type","$(onset_uri)","iri"],
["this:$(pid)_$(uniqid)#Symptom_onset_Attribute","rdf:type","sio:SIO_000614","iri"],
["this:$(pid)_$(uniqid)#Symptom_onset_Attribute","rdf:type","obo:NCIT_C25279","iri"],

["this:$(pid)_$(uniqid)#Diagnosis_date_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Process","rdf:type","sio:SIO_001052","iri"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Output","rdf:type","$(diagnosis_uri)","iri"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Attribute","rdf:type","sio:SIO_000614","iri"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Attribute","rdf:type","obo:NCIT_C156420","iri"],

# Labels
["this:$(pid)_$(uniqid)#Symptom_onset_Role","rdfs:label","Role: Symptom onset patient","xsd:string"],
["this:$(pid)_$(uniqid)#Symptom_onset_Process","rdfs:label","Process: Symptom onset date recording process","xsd:string"],
["this:$(pid)_$(uniqid)#Symptom_onset_Output","rdfs:label","Output type: Date of onset","xsd:string"],
["this:$(pid)_$(uniqid)#Symptom_onset_Attribute","rdfs:label","Attribute type: Stage or date of onset","xsd:string"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Role","rdfs:label","Role: Diagnosis date patient","xsd:string"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Process","rdfs:label","Process: Diagnosis date recording process","xsd:string"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Output","rdfs:label","Output type: Age at diagnosis","xsd:string"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Attribute","rdfs:label","Attribute type: Stage or date of diagnosis","xsd:string"],

# Values
["this:$(pid)_$(uniqid)#ID","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(pid)_$(uniqid)#Symptom_onset_Output","sio:SIO_000300","$(onset_date)","xsd:date"],
["this:$(pid)_$(uniqid)#Diagnosis_date_Output","sio:SIO_000300","$(diagnosis_date)","xsd:date"]]


config = dict(
  source_name = "source_cde_test",
  configuration = "ejp",    # Two options for this parameter:
                            # ejp: it defines CDE-in-a-Box references, being compatible with this workflow  
                            # csv: No workflow defined, set the source configuration for been used by CSV as data source
                            
  csv_name = "source_1" # parameter only needed in case you pick "csv" as configuration
)

yarrrml = EMB(config)
test = yarrrml.transform(prefixes, triplets)
print(test)