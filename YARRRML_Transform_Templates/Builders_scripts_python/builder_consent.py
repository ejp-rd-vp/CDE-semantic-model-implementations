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
["this:$(pid)_$(uniqid)_ID","sio:SIO_000020","this:$(pid)_$(uniqid)_Consent_Role","iri"],
["this:$(pid)_$(uniqid)_Entity","sio:SIO_000228","this:$(pid)_$(uniqid)_Consent_Role","iri"],
["this:$(pid)_$(uniqid)_Entity","sio:SIO_000008","this:$(pid)_$(uniqid)_Consent_Attribute","iri"],
["this:$(pid)_$(uniqid)_Consent_Role","sio:SIO_000356","this:$(pid)_$(uniqid)_Consent_Process","iri"],
["this:$(pid)_$(uniqid)_Consent_Process","sio:SIO_000680","this:$(pid)_$(uniqid)_Consent_Startdate","iri"],
["this:$(pid)_$(uniqid)_Consent_Process","sio:SIO_000681","this:$(pid)_$(uniqid)_Consent_Enddate","iri"],
["this:$(pid)_$(uniqid)_Consent_Process","sio:SIO_000229","this:$(pid)_$(uniqid)_Consent_Output","iri"],
["this:$(pid)_$(uniqid)_Consent_Process","sio:SIO_000230","this:$(pid)_$(uniqid)_Consent_Input","iri"],
["this:$(pid)_$(uniqid)_Consent_Output","sio:SIO_000628","this:$(pid)_$(uniqid)_Consent_Attribute","iri"],

# Types
["this:$(pid)_$(uniqid)_ID","rdf:type","sio:SIO_000115","iri"],
["this:$(pid)_$(uniqid)_Entity","rdf:type","sio:SIO_000498","iri"],
["this:$(pid)_$(uniqid)_Consent_Role","rdf:type","sio:SIO_000016","iri"],
["this:$(pid)_$(uniqid)_Consent_Role","rdf:type","obo:OBI_0000093","iri"],
["this:$(pid)_$(uniqid)_Consent_Process","rdf:type","sio:SIO_000006","iri"],
["this:$(pid)_$(uniqid)_Consent_Process","rdf:type","obo:OBI_0000810","iri"],
["this:$(pid)_$(uniqid)_Consent_Startdate","rdf:type","sio:SIO_000031","iri"],
["this:$(pid)_$(uniqid)_Consent_Enddate","rdf:type","sio:SIO_000032","iri"],
["this:$(pid)_$(uniqid)_Consent_Output","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Consent_Input","rdf:type","sio:SIO_000015","iri"],
["this:$(pid)_$(uniqid)_Consent_Input","rdf:type","obo:ICO_0000001","iri"],
["this:$(pid)_$(uniqid)_Consent_Attribute","rdf:type","sio:SIO_000614","iri"],
["this:$(pid)_$(uniqid)_Consent_Attribute","rdf:type","$(result_uri)","iri"],

# Labels
["this:$(pid)_$(uniqid)_Consent_Role","rdfs:label","Role: Patient for status recording","xsd:string"],
["this:$(pid)_$(uniqid)_Consent_Process","rdfs:label","Process: Consenting","xsd:string"],
["this:$(pid)_$(uniqid)_Consent_Startdate","rdfs:label","Startdate: $(date)","xsd:string"],
["this:$(pid)_$(uniqid)_Consent_Enddate","rdfs:label","Enddate: $(date)","xsd:string"],
["this:$(pid)_$(uniqid)_Consent_Output","rdfs:label","Output type: Patient consent record","xsd:string"],
["this:$(pid)_$(uniqid)_Consent_Input","rdfs:label","Input type: Consent document","xsd:string"],
["this:$(pid)_$(uniqid)_Consent_Attribute","rdfs:label","Attribute type: $(result_label)","xsd:string"],


# Values
["this:$(pid)_$(uniqid)_ID","sio:SIO_000300","$(pid)","xsd:string"],
["this:$(pid)_$(uniqid)_Consent_Startdate","sio:SIO_000300","$(date)","xsd:date"],
["this:$(pid)_$(uniqid)_Consent_Enddate","sio:SIO_000300","$(date)","xsd:date"],
["this:$(pid)_$(uniqid)_Consent_Output","sio:SIO_000300","$(result_label)","xsd:string"],
["this:$(pid)_$(uniqid)_Consent_Input","sio:SIO_000300","$(consent_template)","xsd:string"]]

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