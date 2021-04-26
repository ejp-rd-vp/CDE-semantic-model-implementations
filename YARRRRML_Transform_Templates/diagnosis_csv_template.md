# Diagnosis

The diagnostic opinion regarding the disease

## CSV Columns

pid, uniqid, ordo_uri, diagnostic_opinion, date


## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * ordo_uri:  the orphanet disease ontology (FULL URL!)
  * diagnostic_opinion: brief textual label of the diagnosic opinion.  Likely the label of the ORDO disease term, but may be richer.
  * date:  date of the diagnosis (leave blank if not available)


##  TODO

