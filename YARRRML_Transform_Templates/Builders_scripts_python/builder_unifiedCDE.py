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
["this:$(pid)_ID","sio:SIO_000020","this:$(pid)_$(uniqid)_Role","iri"],
["this:$(pid)_Entity","sio:SIO_000228","this:$(pid)_$(uniqid)_Role","iri"],
["this:$(pid)_Entity","sio:SIO_000008","this:$(pid)_$(uniqid)_Attribute","iri"],
["this:$(pid)_$(uniqid)_Role","sio:SIO_000356","this:$(pid)_$(uniqid)_Process","iri"],
["this:$(pid)_$(uniqid)_Process","sio:SIO_000229","this:$(pid)_$(uniqid)_Output","iri"],
#["this:$(pid)_$(uniqid)_Process","sio:SIO_000230","this:$(pid)_$(uniqid)_Input","iri"],
["this:$(pid)_$(uniqid)_Output","sio:SIO_000628","this:$(pid)_$(uniqid)_Attribute","iri"],
# ["this:$(pid)_$(uniqid)_Input","sio:SIO_000628","this:$(pid)_$(uniqid)_Attribute","iri"],

# Types
["this:$(pid)_ID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_Entity","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_$(uniqid)_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)_Role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)_Process","rdf:type","$(processURI)","iri"],
["this:$(pid)_$(uniqid)_Output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Output","rdf:type","$(outputURI)","iri"],
# ["this:$(pid)_$(uniqid)_Input","rdf:type","sio:SIO_000015","iri"],
# ["this:$(pid)_$(uniqid)_Input","rdf:type","$(inputURI)","iri"],
["this:$(pid)_$(uniqid)_Attribute","rdf:type","sio:SIO_000614","iri"],
["this:$(pid)_$(uniqid)_Attribute","rdf:type","$(attributeURI)","iri"],
["this:$(pid)_$(uniqid)_Attribute","rdf:type","$(valueAttributeIRI)","iri"],


# Labels
["this:$(pid)_ID","rdfs:label","Identifier","xsd:string"],
["this:$(pid)_Person","rdfs:label","Person","xsd:string"],
["this:$(pid)_$(uniqid)_Role","rdfs:label","Patient role","xsd:string"],
["this:$(pid)_$(uniqid)_Process","rdfs:label","$(model) measurement process","xsd:string"],
["this:$(pid)_$(uniqid)_Output","rdfs:label","$(model) measurement output","xsd:string"],
# ["this:$(pid)_$(uniqid)_Input","rdfs:label","$(model) measurement input","xsd:string"],
["this:$(pid)_$(uniqid)_Attribute","rdfs:label","$(model) attribute","xsd:string"],


# Values
["this:$(pid)_ID","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(pid)_$(uniqid)_Output","sio:SIO_000300","$(valueOutput)","$(datatype)"]



# Metadata:

["this:$(chonoid)_Chronoid","sio:SIO_000680","this:$(pid)_$(uniqid)_Startdate"],
["this:$(chonoid)_Chronoid","sio:SIO_000681","this:$(pid)_$(uniqid)_Enddate"],

["this:$(pid)_$(uniqid)_Startdate","rdfs:label","$(model) startdate: $(startdate)","xsd:string"],
["this:$(pid)_$(uniqid)_Enddate","rdfs:label","$(model) enddate: $(enddate)","xsd:string"],

["this:$(pid)_$(uniqid)_Startdate","rdf:type","sio:SIO_000031","iri"],
["this:$(pid)_$(uniqid)_Enddate","rdf:type","sio:SIO_000032","iri"],

["this:$(pid)_$(uniqid)_Startdate","sio:SIO_000300","$(startdate)","xsd:date"]
["this:$(pid)_$(uniqid)_Enddate","sio:SIO_000300","$(enddate)","xsd:date"]

["this:$(chonoid)_Chronoid","sio:SIO_000068","this:$(pid)_Timeline"],
["this:$(pid)_Timeline","sio:SIO_000332","$(pid)"]
]

config = dict(
  source_name = "source_cde_test",
  configuration = "ejp",   
  csv_name = "source_1",
  basicURI = "this"
)

# builder = EMB(config, prefixes, triplets)
# test = builder.transform_YARRRML()
# print(test)