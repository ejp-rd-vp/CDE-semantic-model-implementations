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
["this:$(pid)_ID","sio:SIO_000020","this:$(pid)_$(uniqid)_Undiagnosed_Role","iri"],
["this:$(pid)_Entity","sio:SIO_000228","this:$(pid)_$(uniqid)_Undiagnosed_Role","iri"],
["this:$(pid)_Entity","sio:SIO_000008","this:$(pid)_$(uniqid)_Undiagnosed_Attribute","iri"],
["this:$(pid)_Entity","sio:SIO_000008","this:$(pid)_$(uniqid)_Phenotype_Attribute","iri"],
["this:$(pid)_Entity","sio:SIO_000008","$(clinvar_uri)","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Role","sio:SIO_000356","this:$(pid)_$(uniqid)_Undiagnosed_Process","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Process","sio:SIO_000680","this:$(pid)_$(uniqid)_Undiagnosed_Startdate","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Process","sio:SIO_000681","this:$(pid)_$(uniqid)_Undiagnosed_Enddate","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Process","sio:SIO_000229","this:$(pid)_$(uniqid)_Undiagnosed_Output","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Process","sio:SIO_000230","this:$(pid)_$(uniqid)_Phenotype_Input","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Process","sio:SIO_000230","this:$(pid)_$(uniqid)_Genotype_Input","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Output","sio:SIO_000628","this:$(pid)_$(uniqid)_Undiagnosed_Attribute","iri"],
["this:$(pid)_$(uniqid)_Phenotype_Input","sio:SIO_000628","this:$(pid)_$(uniqid)_Phenotype_Attribute","iri"],
["this:$(pid)_$(uniqid)_Genotype_Input","sio:SIO_000628","$(clinvar_uri)","iri"],

# Types
["this:$(pid)_ID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_Entity","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Process","rdf:type","sio:SIO_001001","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Startdate","rdf:type","sio:SIO_000031","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Enddate","rdf:type","sio:SIO_000032","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Attribute","rdf:type","sio:SIO_000614","iri"],
["this:$(pid)_$(uniqid)_Undiagnosed_Attribute","rdf:type","obo:NCIT_C113725","iri"],

["this:$(pid)_$(uniqid)_Phenotype_Input","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Phenotype_Input","rdf:type","obo:NCIT_C102741","iri"],
["this:$(pid)_$(uniqid)_Phenotype_Attribute","rdf:type","sio:SIO_000614","iri"],
["this:$(pid)_$(uniqid)_Phenotype_Attribute","rdf:type","$(hp_uri)","iri"],

["this:$(pid)_$(uniqid)_Genotype_Input","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Genotype_Input","rdf:type","sio:SIO_001388","iri"],
["$(clinvar_uri)","rdf:type","sio:SIO_000614","iri"],
["$(clinvar_uri)","rdf:type","obo:NCIT_C171178","iri"],

# Labels
["this:$(pid)_$(uniqid)_Undiagnosed_Role","rdfs:label","Role: Undiagnosed patient","xsd:string"],
["this:$(pid)_$(uniqid)_Undiagnosed_Process","rdfs:label","Process: Medical diagnosis","xsd:string"],
["this:$(pid)_$(uniqid)_Undiagnosed_Startdate","rdfs:label","Startdate: $(date)","xsd:string"],
["this:$(pid)_$(uniqid)_Undiagnosed_Enddate","rdfs:label","Enddate: $(date)","xsd:string"],
["this:$(pid)_$(uniqid)_Undiagnosed_Output","rdfs:label","Output type: Undiagnosed label","xsd:string"],
["this:$(pid)_$(uniqid)_Undiagnosed_Attribute","rdfs:label","Attribute type: Undiagnosed","xsd:string"],
["this:$(pid)_$(uniqid)_Phenotype_Input","rdfs:label","Input type: HP_Phenotype","xsd:string"],
["this:$(pid)_$(uniqid)_Phenotype_Attribute","rdfs:label","Attribute type: $(hp_label)","xsd:string"],
["this:$(pid)_$(uniqid)_Genotype_Input","rdfs:label","Input type: HGVS_Genotype","xsd:string"],
["$(clinvar_uri)","rdfs:label","Attribute type: $(hgvs_string)","xsd:string"],

# Values
["this:$(pid)_ID","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(pid)_$(uniqid)_Undiagnosed_Startdate","sio:SIO_000300","$(date)","xsd:date"],
["this:$(pid)_$(uniqid)_Undiagnosed_Enddate","sio:SIO_000300","$(date)","xsd:date"],
["this:$(pid)_$(uniqid)_Undiagnosed_Output","sio:SIO_000300","Undiagnosed","xsd:string"],
["this:$(pid)_$(uniqid)_Phenotype_Input","sio:SIO_000300","$(hp_label)","xsd:string"],
["this:$(pid)_$(uniqid)_Genotype_Input","sio:SIO_000300","$(hgvs_string)","xsd:string"]]

config = dict(
  source_name = "source_cde_test",
  configuration = "ejp",   
  csv_name = "source_1",
  basicURI = "this"
)

# builder = EMB(config, prefixes, triplets)
# test = builder.transform_YARRRML()
# print(test)