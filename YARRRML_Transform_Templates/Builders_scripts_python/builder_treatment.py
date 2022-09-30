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
["this:$(pid)_ID","sio:SIO_000020","this:$(pid)_$(uniqid)_Treatment_role","iri"],
["this:$(pid)_Entity","sio:SIO_000228","this:$(pid)_$(uniqid)_Treatment_role","iri"],
["this:$(pid)_$(uniqid)_Treatment_role","sio:SIO_000356","this:$(pid)_$(uniqid)_Treatment_process","iri"],
["this:$(pid)_$(uniqid)_Treatment_process","sio:SIO_000229","this:$(pid)_$(uniqid)_Treatment_ICO","iri"],
["this:$(pid)_$(uniqid)_Treatment_process","sio:SIO_000680","this:$(pid)_$(uniqid)_Treatment_Interval","iri"],
["this:$(pid)_$(uniqid)_Treatment_ICO","sio:SIO_000221","this:$(pid)_$(uniqid)_Unit","iri"],

# Types
["this:$(pid)_ID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_Entity","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_$(uniqid)_Treatment_role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)_Treatment_role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)_Treatment_process","rdf:type","$()","iri"],
["this:$(pid)_$(uniqid)_Treatment_process","rdf:type","$()","iri"],
["this:$(pid)_$(uniqid)_Treatment_process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)_Treatment_Interval","rdf:type","sio:SIO_000417","iri"],
["this:$(pid)_$(uniqid)_Treatment_ICO","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Treatment_ICO","rdf:type","$()","iri"],
["this:$(pid)_$(uniqid)_Treatment_ICO","rdf:type","$()","iri"],
["this:$(pid)_$(uniqid)_Unit","rdf:type","$(unitURI)","iri"],
["this:$(pid)_$(uniqid)_Unit","rdf:type","obo:NCIT_C68553","iri"],

# Labels
["this:$(pid)_$(uniqid)_Treatment_role","rdfs:label","Role: Patient","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_process","rdfs:label","Process: $()","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_Interval","rdfs:label","$()","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_ICO","rdfs:label","$()","xsd:string"],
["this:$(pid)_$(uniqid)_Unit","rdfs:label","Unit: $(unitLabel)","xsd:string"],

# Values
["this:$(pid)_ID","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(pid)_$(uniqid)_Treatment_Interval","sio:SIO_000300","$(startdate)","xsd:date"],
["this:$(pid)_$(uniqid)_Treatment_ICO","sio:SIO_000300","$()","xsd:string"]]



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