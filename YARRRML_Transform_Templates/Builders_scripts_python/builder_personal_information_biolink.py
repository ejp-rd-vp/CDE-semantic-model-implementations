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
["this:$(pid)_$(uniqid)#ID","sio:SIO_000020","this:$(pid)_$(uniqid)#Age_Role","iri"],
["this:$(pid)_$(uniqid)#Entity","sio:SIO_000228","this:$(pid)_$(uniqid)#Age_Role","iri"],
["this:$(pid)_$(uniqid)#Entity","sio:SIO_000008","this:$(pid)_$(uniqid)#Age_Attribute","iri"],
["this:$(pid)_$(uniqid)#Age_Role","sio:SIO_000356","this:$(pid)_$(uniqid)#Age_Process","iri"],
["this:$(pid)_$(uniqid)#Age_Process","sio:SIO_000229","this:$(pid)_$(uniqid)#Age_Output","iri"],
["this:$(pid)_$(uniqid)#Age_Output","sio:SIO_000628","this:$(pid)_$(uniqid)#Age_Attribute","iri"],

["this:$(pid)_$(uniqid)#ID","sio:SIO_000020","this:$(pid)_$(uniqid)#Sex_Role","iri"],
["this:$(pid)_$(uniqid)#Entity","sio:SIO_000228","this:$(pid)_$(uniqid)#Sex_Role","iri"],
["this:$(pid)_$(uniqid)#Entity","sio:SIO_000008","this:$(pid)_$(uniqid)#Sex_Attribute","iri"],
["this:$(pid)_$(uniqid)#Sex_Role","sio:SIO_000356","this:$(pid)_$(uniqid)#Sex_Process","iri"],
["this:$(pid)_$(uniqid)#Sex_Process","sio:SIO_000229","this:$(pid)_$(uniqid)#Sex_Output","iri"],
["this:$(pid)_$(uniqid)#Sex_Output","sio:SIO_000628","this:$(pid)_$(uniqid)#Sex_Attribute","iri"],

# Types
["this:$(pid)_$(uniqid)#ID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_$(uniqid)#Entity","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_$(uniqid)#Age_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)#Age_Role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)#Age_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)#Age_Output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)#Age_Attribute","rdf:type","sio:SIO_000614","iri"],
["this:$(pid)_$(uniqid)#Age_Attribute","rdf:type","obo:NCIT_C25150","iri"],

["this:$(pid)_$(uniqid)#Sex_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)#Sex_Role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)#Sex_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)#Sex_Output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)#Sex_Attribute","rdf:type","sio:SIO_000614","iri"],
["this:$(pid)_$(uniqid)#Sex_Attribute","rdf:type","$(sexURI)","iri"],
["this:$(pid)_$(uniqid)#Sex_Attribute","rdf:type","obo:NCIT_C28421","iri"],

# Biolink types
["this:$(pid)_$(uniqid)#Entity","rdf:type","biolink:Case","iri"],
["this:$(pid)_$(uniqid)#Age_Process","rdf:type","biolink:Procedure","iri"],
["this:$(pid)_$(uniqid)#Age_Output","rdf:type","biolink:InformationContentEntity","iri"],
["this:$(pid)_$(uniqid)#Age_Attribute","rdf:type","biolink:Attribute","iri"],

["this:$(pid)_$(uniqid)#Sex_Process","rdf:type","biolink:Procedure","iri"],
["this:$(pid)_$(uniqid)#Sex_Output","rdf:type","biolink:InformationContentEntity","iri"],
["this:$(pid)_$(uniqid)#Sex_Attribute","rdf:type","biolink:Attribute","iri"],
["this:$(pid)_$(uniqid)#Sex_Attribute","rdf:type","biolink:BiologicalSex","iri"],

# Labels
["this:$(pid)_$(uniqid)#Age_Role","rdfs:label","Role: Patient for age assessment","xsd:string"],
["this:$(pid)_$(uniqid)#Age_Process","rdfs:label","Process: age measuring process","xsd:string"],
["this:$(pid)_$(uniqid)#Age_Output","rdfs:label","Output type: Age","xsd:string"],
["this:$(pid)_$(uniqid)#Age_Attribute","rdfs:label","Attribute type: Age","xsd:string"],
["this:$(pid)_$(uniqid)#Sex_Role","rdfs:label","Role: Patient for gender assessment","xsd:string"],
["this:$(pid)_$(uniqid)#Sex_Process","rdfs:label","Process: sex measuring process","xsd:string"],
["this:$(pid)_$(uniqid)#Sex_Output","rdfs:label","Output type: $(sexLabel)","xsd:string"],
["this:$(pid)_$(uniqid)#Sex_Attribute","rdfs:label","Attribute type: $(sexLabel)","xsd:string"],

# Values
["this:$(pid)_$(uniqid)#ID","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(pid)_$(uniqid)#Age_Output","sio:SIO_000300","$(age)","xsd:float"],
["this:$(pid)_$(uniqid)#Sex_Output","sio:SIO_000300","$(sexLabel)","xsd:string"]]


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