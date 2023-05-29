from embuilder.builder import EMB

prefixes = dict(
  rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#" ,
  rdfs = "http://www.w3.org/2000/01/rdf-schema#" ,
  obo = "http://purl.obolibrary.org/obo/" ,
  sio = "https://sio.semanticscience.org/resource/" ,
  xsd = "http://www.w3.org/2001/XMLSchema#",
  this = "http://my_example.com/")


triplets = [

# Nodes
["this:$(pid)_ID","sio:SIO_000020","this:$(pid)_$(uniqid)_Role","iri", "this:$(uniqid)_Context"],
["this:$(pid)_Entity","sio:SIO_000228","this:$(pid)_$(uniqid)_Role","iri", "this:$(uniqid)_Context"],
["this:$(pid)_Entity","sio:SIO_000008","this:$(pid)_$(uniqid)_Attribute","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Role","sio:SIO_000356","this:$(pid)_$(uniqid)_Process","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Process","sio:SIO_000291","this:$(pid)_$(uniqid)_Target","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Process","sio:SIO_000139","$(agent_id)","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Process","sio:SIO_000552","this:$(pid)_$(uniqid)_Route","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Process","sio:SIO_000230","this:$(pid)_$(uniqid)_Input","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Process","sio:SIO_000229","this:$(pid)_$(uniqid)_Output","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Output","sio:SIO_000628","this:$(pid)_$(uniqid)_Attribute","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Output","sio:SIO_000221","this:$(pid)_$(uniqid)_Unit","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Output","sio:SIO_000900","this:$(pid)_$(uniqid)_Frequency","iri", "this:$(uniqid)_Context"],

# Types
["this:$(pid)_ID","rdf:type","sio:SIO_000115","iri", "this:$(uniqid)_Context"],
["this:$(pid)_Entity","rdf:type","sio:SIO_000498","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Role","rdf:type","sio:SIO_000016","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Role","rdf:type","obo:OBI_0000093","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Process","rdf:type","sio:SIO_000006","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Process","rdf:type","$(process_type)","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Output","rdf:type","sio:SIO_000015","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Output","rdf:type","$(output_type)","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Input","rdf:type","sio:SIO_000015","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Input","rdf:type","$(input_type)","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Target","rdf:type","sio:SIO_000015","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Target","rdf:type","$(target_type)","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Route","rdf:type","sio:SIO_000015","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Route","rdf:type","$(route_type)","iri", "this:$(uniqid)_Context"],
["$(agent_id)","rdf:type","sio:SIO_000015","iri", "this:$(uniqid)_Context"],
["$(agent_id)","rdf:type","$(agent_type)","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Attribute","rdf:type","sio:SIO_000614","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Attribute","sio:SIO_000332","$(attribute_type)","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Attribute","rdf:type","$(attribute_id)","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Unit","rdf:type","sio:SIO_000074","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Unit","rdf:type","$(unit_type)","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Frequency","rdf:type","sio:SIO_001367","iri", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Frequency","rdf:type","$(frequency_type)","iri", "this:$(uniqid)_Context"],

# Labels
["this:$(pid)_ID","rdfs:label","Identifier","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_Entity","rdfs:label","Person","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Role","rdfs:label","Patient role","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Process","rdfs:label","$(model) measurement process","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Output","rdfs:label","$(model) measurement output","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Input","rdfs:label","$(model) input","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Target","rdfs:label","$(model) target","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Agent","rdfs:label","$(model) agent","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Route","rdfs:label","$(model) route","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Attribute","rdfs:label","$(model) attribute","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Unit","rdfs:label","$(model) unit of measurement","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Frequency","rdfs:label","$(model) frequency","xsd:string", "this:$(uniqid)_Context"],

# Values
["this:$(pid)_ID","sio:SIO_000300","$(pid)","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Output","sio:SIO_000300","$(value_string)","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Output","sio:SIO_000300","$(value_date)","xsd:date", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Output","sio:SIO_000300","$(value_float)","xsd:float", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Output","sio:SIO_000300","$(value_integer)","xsd:integer", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Process","rdfs:comments","$(comments)","xsd:string", "this:$(uniqid)_Context"],
["this:$(pid)_$(uniqid)_Frequency","sio:SIO_000300","$(frequency_value)","xsd:integer", "this:$(uniqid)_Context"],

# Context:
["this:$(uniqid)_Context","sio:SIO_000680","this:$(uniqid)_Startdate","iri"],
["this:$(uniqid)_Context","sio:SIO_000681","this:$(uniqid)_Enddate", "iri"],
["this:$(uniqid)_Context","sio:SIO_000068","this:$(pid)_Timeline","iri"],
["this:$(pid)_Timeline","sio:SIO_000332","this:$(pid)_Person","iri"],
["this:$(pid)_Person","sio:SIO_000671","this:$(pid)_Identifier","iri"],

["this:$(uniqid)_Context","rdf:type","obo:NCIT_C25616","iri"],
["this:$(uniqid)_Startdate","rdf:type","sio:SIO_000031","iri"],
["this:$(uniqid)_Enddate","rdf:type","sio:SIO_000032","iri"],
["this:$(pid)_Timeline","rdf:type","sio:SIO_000417","iri"],
["this:$(pid)_Timeline","rdf:type","obo:NCIT_C54576","iri"],
["this:$(pid)_Person","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_Identifier","rdf:type","sio:SIO_000115","iri"],

["this:$(uniqid)_Startdate","rdfs:label","$(model) startdate: $(startdate)","xsd:string"],
["this:$(uniqid)_Enddate","rdfs:label","$(model) enddate: $(enddate)","xsd:string"],

["this:$(uniqid)_Startdate","sio:SIO_000300","$(startdate)","xsd:date"],
["this:$(uniqid)_Enddate","sio:SIO_000300","$(enddate)","xsd:date"],
["this:$(pid)_Identifier","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(uniqid)_Context","sio:SIO_000300","$(uniqid)","xsd:string"],

# Mayor Context:
["this:$(uniqid)_Context","sio:SIO_000068","this:$(pid)_$(context_id)_Mayor_context","iri"],
["this:$(pid)_$(context_id)_Mayor_context","sio:SIO_000680","this:$(pid)_$(context_id)_Startdate","iri"],
["this:$(pid)_$(context_id)_Mayor_context","sio:SIO_000681","this:$(pid)_$(context_id)_Enddate","iri"],
["this:$(pid)_$(context_id)_Mayor_context","sio:SIO_000793","this:$(pid)_$(context_id)_Age","iri"],

["this:$(pid)_$(context_id)_Mayor_context","rdf:type","obo:NCIT_C25616","iri"],
["this:$(pid)_$(context_id)_Startdate","rdf:type","sio:SIO_000031","iri"],
["this:$(pid)_$(context_id)_Enddate","rdf:type","sio:SIO_000032","iri"],
["this:$(pid)_$(context_id)_Age","rdf:type","sio:SIO_001013","iri"],

["this:$(pid)_$(context_id)_Startdate","sio:SIO_000300","$(context_startdate)","xsd:date"],
["this:$(pid)_$(context_id)_Enddate","sio:SIO_000300","$(context_enddate)","xsd:date"],
["this:$(pid)_$(context_id)_Mayor_context","sio:SIO_000300","$(context_id)","xsd:string"],
["this:$(pid)_$(context_id)_Age","sio:SIO_000300","$(age)","xsd:float"]
]

config = dict(
  source_name = "source_cde_test",
  configuration = "ejp",   
  csv_name = "source_1",
  basicURI = "this"
)

builder = EMB(config, prefixes, triplets)
test = builder.transform_YARRRML()
# test = builder.transform_OBDA()
# test = builder.transform_ShEx()
# test = builder.transform_SPARQL()
print(test)
