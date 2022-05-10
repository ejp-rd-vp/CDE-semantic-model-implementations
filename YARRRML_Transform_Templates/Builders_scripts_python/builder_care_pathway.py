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
["this:$(pid)_$(uniqid)_ID","sio:SIO_000020","this:$(pid)_$(uniqid)_Care_pathway_Role","iri"],
["this:$(pid)_$(uniqid)_Entity","sio:SIO_000228","this:$(pid)_$(uniqid)_Care_pathway_Role","iri"],
["this:$(pid)_$(uniqid)_Care_pathway_Role","sio:SIO_000356","this:$(pid)_$(uniqid)_Care_pathway_Process","iri"],
["this:$(pid)_$(uniqid)_Care_pathway_Process","sio:SIO_000680","this:$(pid)_$(uniqid)_Care_pathway_Startdate","iri"],
["this:$(pid)_$(uniqid)_Care_pathway_Process","sio:SIO_000681","this:$(pid)_$(uniqid)_Care_pathway_Enddate","iri"],

# Types
["this:$(pid)_$(uniqid)_ID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_$(uniqid)_Entity","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_$(uniqid)_Care_pathway_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)_Care_pathway_Role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)_Care_pathway_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)_Care_pathway_Process","rdf:type","obo:NCIT_C16205","iri"],
["this:$(pid)_$(uniqid)_Care_pathway_Process","rdf:type","obo:NCIT_C159705","iri"],
["this:$(pid)_$(uniqid)_Care_pathway_Startdate","rdf:type","sio:SIO_000031","iri"],
["this:$(pid)_$(uniqid)_Care_pathway_Enddate","rdf:type","sio:SIO_000032","iri"],

# Labels
["this:$(pid)_$(uniqid)_Care_pathway_Role","rdfs:label","Role: First contact patient","xsd:string"],
["this:$(pid)_$(uniqid)_Care_pathway_Process","rdfs:label","Process: First contact with specialized center","xsd:string"],
["this:$(pid)_$(uniqid)_Care_pathway_Startdate","rdfs:label","Startdate: $(first_contact_date)","xsd:string"],
["this:$(pid)_$(uniqid)_Care_pathway_Enddate","rdfs:label","Enddate: $(first_contact_date)","xsd:string"],

# Values
["this:$(pid)_$(uniqid)_ID","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(pid)_$(uniqid)_Care_pathway_Startdate","sio:SIO_000300","$(first_contact_date)","xsd:date"],
["this:$(pid)_$(uniqid)_Care_pathway_Enddate","sio:SIO_000300","$(first_contact_date)","xsd:date"]]


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