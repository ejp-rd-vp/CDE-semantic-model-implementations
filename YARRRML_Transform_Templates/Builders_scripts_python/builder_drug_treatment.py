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
["this:$(pid)_$(uniqid)_ID","sio:SIO_000020","this:$(pid)_$(uniqid)_Treatment_Role","iri"],
["this:$(pid)_$(uniqid)_Entity","sio:SIO_000228","this:$(pid)_$(uniqid)_Treatment_Role","iri"],
["this:$(pid)_$(uniqid)_Treatment_Role","sio:SIO_000356","this:$(pid)_$(uniqid)_Treatment_Process","iri"],
["this:$(pid)_$(uniqid)_Treatment_Process","sio:SIO_000680","this:$(pid)_$(uniqid)_Treatment_Startdate","iri"],
["this:$(pid)_$(uniqid)_Treatment_Process","sio:SIO_000681","this:$(pid)_$(uniqid)_Treatment_Enddate","iri"],
["this:$(pid)_$(uniqid)_Treatment_Process","sio:CHEMINF_000047","this:$(pid)_$(uniqid)_Treatment_Prescription_Output","iri"],
["this:$(pid)_$(uniqid)_Treatment_Process","sio:SIO_000230","this:$(pid)_$(uniqid)_Treatment_Input","iri"],
["this:$(pid)_$(uniqid)_Treatment_Process","sio:SIO_000139","this:$(pid)_$(uniqid)_Treatment_Drug_Attribute","iri"],
["this:$(pid)_$(uniqid)_Treatment_Prescription_Output","sio:SIO_000628","this:$(pid)_$(uniqid)_Treatment_Drug_Attribute","iri"],
["this:$(pid)_$(uniqid)_Treatment_Prescription_Output","sio:SIO_000628","this:$(pid)_$(uniqid)_Treatment_Dose_Attribute","iri"],
["this:$(pid)_$(uniqid)_Treatment_Dose_Attribute","sio:SIO_000221","this:$(pid)_$(uniqid)_Treatment_Unit","iri"],
["this:$(pid)_$(uniqid)_Treatment_Dose_Attribute","sio:SIO_000900","this:$(pid)_$(uniqid)_Treatment_Frequency","iri"],
["$(med_atc_uri)","sio:SIO_000313","this:$(pid)_$(uniqid)_Treatment_Drug_Attribute","iri"],

# Types
["this:$(pid)_$(uniqid)_ID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_$(uniqid)_Entity","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_$(uniqid)_Treatment_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)_Treatment_Role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)_Treatment_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)_Treatment_Process","rdf:type","$(processURI)","iri"],
["this:$(pid)_$(uniqid)_Treatment_Startdate","rdf:type","sio:SIO_000031","iri"],
["this:$(pid)_$(uniqid)_Treatment_Enddate","rdf:type","sio:SIO_000032","iri"],
["this:$(pid)_$(uniqid)_Treatment_Prescription_Output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Treatment_Prescription_Output","rdf:type","obo:NCIT_C28180","iri"],
["this:$(pid)_$(uniqid)_Treatment_Input","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Treatment_Input","rdf:type","$(routeURI)","iri"],
["this:$(pid)_$(uniqid)_Treatment_Unit","rdf:type","$(unitURI)","iri"],
["$(med_atc_uri)","rdf:type","obo:NCIT_C177929","iri"],
["$(med_atc_uri)","rdf:type","$(med_atc_type)","iri"],
["this:$(pid)_$(uniqid)_Treatment_Dose_Attribute","rdf:type","obo:NCIT_C25488","iri"],
["this:$(pid)_$(uniqid)_Treatment_Dose_Attribute","rdf:type","sio:SIO_000614","iri"],
["this:$(pid)_$(uniqid)_Treatment_Drug_Attribute","rdf:type","sio:SIO_010038","iri"],
["this:$(pid)_$(uniqid)_Treatment_Drug_Attribute","rdf:type","sio:SIO_000614","iri"],
["this:$(pid)_$(uniqid)_Treatment_Frequency","rdf:type","$(freqURI)","iri"],

# Labels
["this:$(pid)_$(uniqid)_Treatment_Role","rdfs:label","Role: Patient","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_Process","rdfs:label","Process: $(processLabel)","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_Startdate","rdfs:label","Startdate: $(startdate)","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_Enddate","rdfs:label","Enddate: $(enddate)","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_Prescription_Output","rdfs:label","Prescription","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_Prescription_Output","rdfs:comment","$(comments)","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_Input","rdfs:label","Route of administration: $(routeLabel)","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_Unit","rdfs:label","Unit: $(unitLabel)","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_Dose_Attribute","rdfs:label","Dose attribute","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_Drug_Attribute","rdfs:label","Drug attribute","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_Frequency","rdfs:label","Frequency: $(freqLabel)","xsd:string"],
["$(med_atc_uri)","rdfs:label","Drug component: $(med_atc_label)","xsd:string"],

# Values
["this:$(pid)_$(uniqid)_ID","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_Startdate","sio:SIO_000300","$(startdate)","xsd:date"],
["this:$(pid)_$(uniqid)_Treatment_Enddate","sio:SIO_000300","$(enddate)","xsd:date"],
["this:$(pid)_$(uniqid)_Treatment_Drug_Attribute","sio:SIO_000300","$(dose)","xsd:float"],
["this:$(pid)_$(uniqid)_Treatment_Frequency","sio:SIO_000300","$(freq)","xsd:integer"]]



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