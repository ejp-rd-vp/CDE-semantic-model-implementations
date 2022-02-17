from embuilder.builder import EMB

prefixes = dict(
  rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#" ,
  rdfs = "http://www.w3.org/2000/01/rdf-schema#" ,
  obo = "http://purl.obolibrary.org/obo/" ,
  sio = "http://semanticscience.org/resource/" ,
  xsd = "http://www.w3.org/2001/XMLSchema#",
  biolink = "https://w3id.org/biolink/vocab/",
  this = "http://my_example.com/")


triplets = [

# Nodes
["this:$(pid)_$(uniqid)#ID","sio:SIO_000020","this:$(pid)_$(uniqid)#Lab_measurement_Role","iri"],
["this:$(pid)_$(uniqid)#Entity","sio:SIO_000228","this:$(pid)_$(uniqid)#Lab_measurement_Role","iri"],
["this:$(pid)_$(uniqid)#Entity","sio:SIO_000008","this:$(pid)_$(uniqid)#Lab_measurement_Attribute","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Role","sio:SIO_000356","this:$(pid)_$(uniqid)#Lab_measurement_Process","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Process","sio:SIO_000680","this:$(pid)_$(uniqid)#Lab_measurement_Startdate","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Process","sio:SIO_000681","this:$(pid)_$(uniqid)#Lab_measurement_Enddate","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Process","sio:SIO_000229","this:$(pid)_$(uniqid)#Lab_measurement_Output","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Process","sio:SIO_000230","this:$(pid)_$(uniqid)#Lab_measurement_Input","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Process","sio:SIO_000291","this:$(pid)_$(uniqid)#Lab_measurement_Target","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Process","sio:SIO_000339","$(protocolURI)","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Output","sio:SIO_000628","this:$(pid)_$(uniqid)#Lab_measurement_Attribute","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Output","sio:SIO_000221","this:$(pid)_$(uniqid)#Lab_measurement_Unit","iri"],

# Types
["this:$(pid)_$(uniqid)#ID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_$(uniqid)#Entity","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Process","rdf:type","$(processURI)","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Startdate","rdf:type","sio:SIO_000031","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Enddate","rdf:type","sio:SIO_000032","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Input","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Input","rdf:type","$(material_tested)","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Target","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Target","rdf:type","$(target)","iri"],
["$(protocolURI)","rdf:type","sio:SIO_000015","iri"],
["$(protocolURI)","rdf:type","obo:NCIT_C42651","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Unit","rdf:type","$(unitURI)","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Attribute","rdf:type","sio:SIO_000614","iri"],

# Biolink types
["this:$(pid)_$(uniqid)#Entity","rdf:type","biolink:Case","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Process","rdf:type","biolink:Procedure","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Input","rdf:type","biolink:InformationContentEntity","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Output","rdf:type","biolink:InformationContentEntity","iri"],
["this:$(pid)_$(uniqid)#Lab_measurement_Attribute","rdf:type","biolink:Attribute","iri"],

# Labels
["this:$(pid)_$(uniqid)#Lab_measurement_Role","rdfs:label","Role: Patient","xsd:string"],
["this:$(pid)_$(uniqid)#Lab_measurement_Process","rdfs:label","Process: $(processLabel)","xsd:string"],
["this:$(pid)_$(uniqid)#Lab_measurement_Startdate","rdfs:label","Startdate: $(date)","xsd:string"],
["this:$(pid)_$(uniqid)#Lab_measurement_Enddate","rdfs:label","Enddate: $(date)","xsd:string"],
["this:$(pid)_$(uniqid)#Lab_measurement_Output","rdfs:label","Output type: Measurement value","xsd:string"],
["this:$(pid)_$(uniqid)#Lab_measurement_Output","rdfs:comment","$(comments)","xsd:string"],
["this:$(pid)_$(uniqid)#Lab_measurement_Input","rdfs:label","Input type: $(material_tested_label)","xsd:string"],
["this:$(pid)_$(uniqid)#Lab_measurement_Target","rdfs:label","Target type: $(target_label)","xsd:string"],
["$(protocolURI)","rdfs:label","Protocol: $(protocolLabel)","xsd:string"],
["this:$(pid)_$(uniqid)#Lab_measurement_Unit","rdfs:label","Target type: $(unitLabel)","xsd:string"],
["this:$(pid)_$(uniqid)#Lab_measurement_Attribute","rdfs:label","Lab measurement attribute","xsd:string"],

# Values
["this:$(pid)_$(uniqid)#ID","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(pid)_$(uniqid)#Lab_measurement_Startdate","sio:SIO_000300","$(date)","xsd:date"],
["this:$(pid)_$(uniqid)#Lab_measurement_Enddate","sio:SIO_000300","$(date)","xsd:date"],
["this:$(pid)_$(uniqid)#Lab_measurement_Output","sio:SIO_000300","$(value)","xsd:float"]]


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