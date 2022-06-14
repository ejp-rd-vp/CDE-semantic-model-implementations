# from embuilder.builder import EMB

prefixes = dict(
  rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#" ,
  rdfs = "http://www.w3.org/2000/01/rdf-schema#" ,
  obo = "http://purl.obolibrary.org/obo/" ,
  sio = "http://semanticscience.org/resource/" ,
  xsd = "http://www.w3.org/2001/XMLSchema#",
  this = "http://my_example.com/")


triplets = [

# Nodes
["this:$(pid)_$(uniqid)_ID","sio:SIO_000020","this:$(pid)_$(uniqid)_Treatment_role","iri"],
["this:$(pid)_$(uniqid)_Entity","sio:SIO_000228","this:$(pid)_$(uniqid)_Treatment_role","iri"],
["this:$(pid)_$(uniqid)_Treatment_role","sio:SIO_000356","this:$(pid)_$(uniqid)_Drug_intake_process","iri"],
["this:$(pid)_$(uniqid)_Treatment_role","sio:SIO_000356","this:$(pid)_$(uniqid)_Drug_prescription_process","iri"],
["this:$(pid)_$(uniqid)_Drug_intake_process","sio:CHEMINF_000047","this:$(pid)_$(uniqid)_Prescription_output","iri"],
["this:$(pid)_$(uniqid)_Drug_prescription_process","sio:SIO_000229","this:$(pid)_$(uniqid)_Prescription_output","iri"],
["this:$(pid)_$(uniqid)_Drug_intake_process","sio:SIO_000680","this:$(pid)_$(uniqid)_Treatment_startdate","iri"],
["this:$(pid)_$(uniqid)_Drug_intake_process","sio:SIO_000681","this:$(pid)_$(uniqid)_Treatment_enddate","iri"],
["this:$(pid)_$(uniqid)_Drug_intake_process","sio:SIO_000230","this:$(pid)_$(uniqid)_Administration_input","iri"],
["this:$(pid)_$(uniqid)_Drug_intake_process","sio:SIO_000139","this:$(pid)_$(uniqid)_Drug","iri"],
["this:$(pid)_$(uniqid)_Prescription_output","sio:SIO_000628","this:$(pid)_$(uniqid)_Drug","iri"],
["this:$(pid)_$(uniqid)_Prescription_output","sio:SIO_000628","this:$(pid)_$(uniqid)_Dose","iri"],
["this:$(pid)_$(uniqid)_Dose","sio:SIO_000221","this:$(pid)_$(uniqid)_Unit","iri"],
["this:$(pid)_$(uniqid)_Dose","sio:SIO_000900","this:$(pid)_$(uniqid)_Frequency","iri"],
["$(med_atc_uri)","sio:SIO_000313","this:$(pid)_$(uniqid)_Drug","iri"],

# Types
["this:$(pid)_$(uniqid)_ID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_$(uniqid)_Entity","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_$(uniqid)_Treatment_role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)_Treatment_role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)_Drug_intake_process","rdf:type","obo:NCIT_C25538","iri"],
["this:$(pid)_$(uniqid)_Drug_prescription_process","rdf:type","obo:NCIT_C111077","iri"],
["this:$(pid)_$(uniqid)_Treatment_startdate","rdf:type","sio:SIO_000031","iri"],
["this:$(pid)_$(uniqid)_Treatment_enddate","rdf:type","sio:SIO_000032","iri"],
["this:$(pid)_$(uniqid)_Prescription_output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Prescription_output","rdf:type","obo:NCIT_C28180","iri"],
["this:$(pid)_$(uniqid)_Administration_input","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Administration_input","rdf:type","$(routeURI)","iri"],
["this:$(pid)_$(uniqid)_Unit","rdf:type","$(unitURI)","iri"],
["$(med_atc_uri)","rdf:type","obo:NCIT_C177929","iri"],
["$(med_atc_uri)","rdf:type","$(med_atc_type)","iri"],
["this:$(pid)_$(uniqid)_Dose","rdf:type","obo:NCIT_C25488","iri"],
["this:$(pid)_$(uniqid)_Drug","rdf:type","sio:SIO_010038","iri"],
["this:$(pid)_$(uniqid)_Frequency","rdf:type","$(freqURI)","iri"],

# Labels
["this:$(pid)_$(uniqid)_Treatment_role","rdfs:label","Role: Patient","xsd:string"],
["this:$(pid)_$(uniqid)_Drug_intake_process","rdfs:label","Process: Drug intake","xsd:string"],
["this:$(pid)_$(uniqid)_Drug_prescription_process","rdfs:label","Process: Drug prescription","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_startdate","rdfs:label","Startdate: $(startdate)","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_enddate","rdfs:label","Enddate: $(enddate)","xsd:string"],
["this:$(pid)_$(uniqid)_Prescription_output","rdfs:label","Prescription","xsd:string"],
["this:$(pid)_$(uniqid)_Prescription_output","rdfs:comment","$(comments)","xsd:string"],
["this:$(pid)_$(uniqid)_Administration_input","rdfs:label","Route of administration: $(routeLabel)","xsd:string"],
["this:$(pid)_$(uniqid)_Unit","rdfs:label","Unit: $(unitLabel)","xsd:string"],
["this:$(pid)_$(uniqid)_Dose","rdfs:label","Dose","xsd:string"],
["this:$(pid)_$(uniqid)_Drug","rdfs:label","Drug","xsd:string"],
["this:$(pid)_$(uniqid)_Frequency","rdfs:label","Frequency: $(freqLabel)","xsd:string"],
["$(med_atc_uri)","rdfs:label","Drug component: $(med_atc_label)","xsd:string"],

# Values
["this:$(pid)_$(uniqid)_ID","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_startdate","sio:SIO_000300","$(startdate)","xsd:date"],
["this:$(pid)_$(uniqid)_Treatment_enddate","sio:SIO_000300","$(enddate)","xsd:date"],
["this:$(pid)_$(uniqid)_Drug","sio:SIO_000300","$(dose)","xsd:float"],
["this:$(pid)_$(uniqid)_Frequency","sio:SIO_000300","$(freq)","xsd:integer"]]



config = dict(
  source_name = "source_cde_test",
  configuration = "ejp",    # Two options for this parameter:
                            # ejp: it defines CDE-in-a-Box references, being compatible with this workflow  
                            # csv: No workflow defined, set the source configuration for been used by CSV as data source
                            
  csv_name = "source_1" # parameter only needed in case you pick "csv" as configuration
)

# builder = EMB(config, prefixes, triplets)
# test = builder.transform_YARRRML()
# print(test)