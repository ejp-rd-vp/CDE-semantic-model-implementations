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
["this:$(pid)_$(uniqid)_ID","sio:SIO_000020","this:$(pid)_$(uniqid)_Sample_Role","iri"],
["this:$(pid)_$(uniqid)_Entity","sio:SIO_000228","this:$(pid)_$(uniqid)_Sample_Role","iri"],
["this:$(pid)_$(uniqid)_Sample_Role","sio:SIO_000356","this:$(pid)_$(uniqid)_Sample_Process","iri"],
["this:$(pid)_$(uniqid)_Sample_Process","sio:SIO_000229","this:$(pid)_$(uniqid)_Specimen_Output","iri"],

["this:$(pid)_$(uniqid)_Biobank_ID","sio:SIO_000020","this:$(pid)_$(uniqid)_Biobank_Role","iri"],
["this:$(pid)_$(uniqid)_Biobank_Entity","sio:SIO_000228","this:$(pid)_$(uniqid)_Biobank_Role","iri"],
["this:$(pid)_$(uniqid)_Biobank_Role","sio:SIO_000356","this:$(pid)_$(uniqid)_Biobank_Process","iri"],
["this:$(pid)_$(uniqid)_Biobank_Process","sio:SIO_000229","this:$(pid)_$(uniqid)_Specimen_Output","iri"],

# Types
["this:$(pid)_$(uniqid)_ID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_$(uniqid)_Entity","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_$(uniqid)_Sample_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)_Sample_Role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)_Sample_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)_Sample_Process","rdf:type","obo:OBI_0000659","iri"],
["this:$(pid)_$(uniqid)_Specimen_Output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Specimen_Output","rdf:type","obo:OBI_0100051","iri"],

["this:$(pid)_$(uniqid)_BiobankID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_$(uniqid)_Entity","rdf:type","$(biobank_url)","iri"],
["this:$(pid)_$(uniqid)_Biobank_Role","rdf:type","obo:OBI_0000947","iri"],
["this:$(pid)_$(uniqid)_Biobank_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)_Biobank_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)_Biobank_Process","rdf:type","obo:OBI_0302893","iri"],

# Labels
["this:$(pid)_$(uniqid)_Sample_Role","rdfs:label","Role: Patient for biobank sample collection","xsd:string"],
["this:$(pid)_$(uniqid)_Sample_Process","rdfs:label","Process: Sample collection process","xsd:string"],
["this:$(pid)_$(uniqid)_Specimen_Output","rdfs:label","Output type: Specimen","xsd:string"],
["this:$(pid)_$(uniqid)_Biobank_Role","rdfs:label","Role: Biobank for sample storage","xsd:string"],
["this:$(pid)_$(uniqid)_Biobank_Process","rdfs:label","Process: Sample storage process","xsd:string"],

# Values
["this:$(pid)_$(uniqid)_ID","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(pid)_$(uniqid)_Biobank_ID","sio:SIO_000300","$(biobank_id)","xsd:string"]]

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