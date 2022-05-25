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
["this:$(pid)_$(uniqid)_ID","sio:SIO_000020","this:$(pid)_$(uniqid)_Disability_Role","iri"],
["this:$(pid)_$(uniqid)_Entity","sio:SIO_000228","this:$(pid)_$(uniqid)_Disability_Role","iri"],
["this:$(pid)_$(uniqid)_Disability_Role","sio:SIO_000356","this:$(pid)_$(uniqid)_Disability_Process","iri"],
["this:$(pid)_$(uniqid)_Disability_Process","sio:SIO_000680","this:$(pid)_$(uniqid)_Disability_Startdate","iri"],
["this:$(pid)_$(uniqid)_Disability_Process","sio:SIO_000681","this:$(pid)_$(uniqid)_Disability_Enddate","iri"],
["this:$(pid)_$(uniqid)_Disability_Process","sio:SIO_000229","this:$(pid)_$(uniqid)_Disability_Output","iri"],
["this:$(pid)_$(uniqid)_Disability_Process","sio:SIO_000230","this:$(pid)_$(uniqid)_Disability_Input","iri"],

# Types
["this:$(pid)_$(uniqid)_ID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_$(uniqid)_Entity","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_$(uniqid)_Disability_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)_Disability_Role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)_Disability_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)_Disability_Process","rdf:type","obo:NCIT_C20993","iri"],
["this:$(pid)_$(uniqid)_Disability_Process","rdf:type","$(test_uri)","iri"],
["this:$(pid)_$(uniqid)_Disability_Startdate","rdf:type","sio:SIO_000031","iri"],
["this:$(pid)_$(uniqid)_Disability_Enddate","rdf:type","sio:SIO_000032","iri"],
["this:$(pid)_$(uniqid)_Disability_Output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Disability_Input","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Disability_Input","rdf:type","obo:NCIT_C17048","iri"],

# Labels
["this:$(pid)_$(uniqid)_Disability_Role","rdfs:label","Role: Patient","xsd:string"],
["this:$(pid)_$(uniqid)_Disability_Process","rdfs:label","Process: $(test_name)","xsd:string"],
["this:$(pid)_$(uniqid)_Disability_Startdate","rdfs:label","Startdate: $(test_date)","xsd:string"],
["this:$(pid)_$(uniqid)_Disability_Enddate","rdfs:label","Enddate: $(test_date)","xsd:string"],
["this:$(pid)_$(uniqid)_Disability_Output","rdfs:label","Output type: Disability score","xsd:string"],
["this:$(pid)_$(uniqid)_Disability_Input","rdfs:label","Input type: Questionnaire","xsd:string"],

# Values
["this:$(pid)_$(uniqid)_ID","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(pid)_$(uniqid)_Disability_Startdate","sio:SIO_000300","$(test_date)","xsd:date"],
["this:$(pid)_$(uniqid)_Disability_Enddate","sio:SIO_000300","$(test_date)","xsd:date"],
["this:$(pid)_$(uniqid)_Disability_Output","sio:SIO_000300","$(score)","xsd:string"]]


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