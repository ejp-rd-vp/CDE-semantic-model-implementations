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
["this:$(pid)_$(uniqid)_ID","sio:SIO_000020","this:$(pid)_$(uniqid)_Status_Role","iri"],
["this:$(pid)_$(uniqid)_Entity","sio:SIO_000228","this:$(pid)_$(uniqid)_Status_Role","iri"],
["this:$(pid)_$(uniqid)_Entity","sio:SIO_000008","this:$(pid)_$(uniqid)_Status_Attribute","iri"],
["this:$(pid)_$(uniqid)_Status_Role","sio:SIO_000356","this:$(pid)_$(uniqid)_Status_Process","iri"],
["this:$(pid)_$(uniqid)_Status_Process","sio:SIO_000229","this:$(pid)_$(uniqid)_Status_Output","iri"],
["this:$(pid)_$(uniqid)_Status_Output","sio:SIO_000628","this:$(pid)_$(uniqid)_Status_Attribute","iri"],

["this:$(pid)_$(uniqid)_Entity","sio:SIO_000008","this:$(pid)_$(uniqid)_Death_information_Attribute","iri"],
["this:$(pid)_$(uniqid)_Status_Role","sio:SIO_000356","this:$(pid)_$(uniqid)_Death_information_Process","iri"],
["this:$(pid)_$(uniqid)_Death_information_Process","sio:SIO_000229","this:$(pid)_$(uniqid)_Death_information_Output","iri"],
["this:$(pid)_$(uniqid)_Death_information_Output","sio:SIO_000628","this:$(pid)_$(uniqid)_Death_information_Attribute","iri"],

# Types
["this:$(pid)_$(uniqid)_ID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_$(uniqid)_Entity","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_$(uniqid)_Status_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)_Status_Role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)_Status_Process","rdf:type","sio:SIO_001052","iri"],
["this:$(pid)_$(uniqid)_Status_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)_Status_Output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Status_Attribute","rdf:type","sio:SIO_000614","iri"],
["this:$(pid)_$(uniqid)_Status_Attribute","rdf:type","$(status_uri)","iri"],

["this:$(pid)_$(uniqid)_Death_information_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)_Death_information_Output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Death_information_Attribute","rdf:type","sio:SIO_000614","iri"],
["this:$(pid)_$(uniqid)_Death_information_Attribute","rdf:type","obo:NCIT_C70810","iri"],

# Labels
["this:$(pid)_$(uniqid)_Status_Role","rdfs:label","Role: Patient for status recording","xsd:string"],
["this:$(pid)_$(uniqid)_Status_Process","rdfs:label","Process: Status recording process","xsd:string"],
["this:$(pid)_$(uniqid)_Status_Output","rdfs:label","Output type: $(status_label)","xsd:string"],
["this:$(pid)_$(uniqid)_Status_Attribute","rdfs:label","Attribute type: $(status_label)","xsd:string"],
["this:$(pid)_$(uniqid)_Death_information_Process","rdfs:label","Process: Death information recording process","xsd:string"],
["this:$(pid)_$(uniqid)_Death_information_Output","rdfs:label","Output type: Patient death information)","xsd:string"],
["this:$(pid)_$(uniqid)_Death_information_Attribute","rdfs:label","Attribute type: Date of death","xsd:string"],

# Values
["this:$(pid)_$(uniqid)_ID","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(pid)_$(uniqid)_Status_Output","sio:SIO_000300","$(status_label)","xsd:string"],
["this:$(pid)_$(uniqid)_Death_information_Output","sio:SIO_000300","$(death_date)","xsd:date"]]


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