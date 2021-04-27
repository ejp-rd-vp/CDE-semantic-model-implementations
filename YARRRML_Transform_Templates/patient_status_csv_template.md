# Patient Status CDE

The CDE for patient status

## CSV Columns

pid, uniqid, date, status_uri, status_label, death_date


## Notes:
  * pid - patient unique identifier
  * uniqid:  some row unique identifier, over all sessions (a millisecond timestamp, numerical only, is a good idea)
  * date:  ISO 8601 formatted date representing the date of the current observation
  * status_uri:  one of
    * sio:SIO_010059 (dead)
    * sio:SIO_010058 (alive)
    * obo:NCIT_C70740 (lost to follow-up)
    * obo:NCIT_C124784 (refused to participate)
  * status label:  a human readable label to match the value of the status URI for that row
  * death_date:  if the patient is dead, the recorded date of death (may be different from the 'date' column of this record).  If patient is not dead, leave this field as empty

  
##  TODO

  