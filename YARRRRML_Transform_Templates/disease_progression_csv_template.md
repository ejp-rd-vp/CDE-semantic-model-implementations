# Disease Progression

The longitudinal record of a patient's observations through the course of their disease

## CSV Columns

pid, uniqid


## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)

This creates a 'container' process node that will have-part all of the other events.  It is given a URI that can be predictably reused
by other YARRRML templates.  by default, this is #longitudinal_information_gathering_process_diseaseX.  If you need to follow multiple diseases
in your triplestore, then you need to create a Disease Progression node for each of these... do this by
replacing "diseaseX" with some unique id for your disease.  If you are not tracking multiple diseases, then do nothing :-)

##  TODO

