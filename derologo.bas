Function ShowLogo()
    10 PRINTF "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
    20 PRINTF "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
    30 PRINTF "&&&&&&&&&&&&&&&&&&&&    &&&    &&&&&&&&&&&&&&&&&&&&&"
    40 PRINTF "&&&&&&&&&&&&&&&.        &&&        .&&&&&&&&&&&&&&&&"
    50 PRINTF "&&&&&&&&&&&&&      (&&&&&&&&&&       &&&&&&&&&&&&&&&"
    60 PRINTF "&&&&&&&&&&&     &&&&&&&&&&&&&&&&&&     &&&&&&&&&&&&&"
    70 PRINTF "&&&&&&&&&&     &&&&&&&&&-/^\-&&&&&&&     &&&&&&&&&&&"
    80 PRINTF "&&&&&&&&&&    &&&&&&&&        &&&&&&&&    &&&&&&&&&&"
    90 PRINTF "&&&&&&&&&*    &&&&&&              &&&&&&&   &&&&&&&&&&"
    100 PRINTF "&&&&&&&&&    &&&&&&              &&&&&&&   &&&&&&&&&&"
    110 PRINTF "&&&&&&&&&    &&&&&&             &&&&&&&&   &&&&&&&&&&"
    120 PRINTF "&&&&&&&&&,   ,&&&&&&           &&&&&&&   .&&&&&&&&&&"
    130 PRINTF "&&&&&&&&&&    ,&&&&&&&        &&&&&&&&   &&&&&&&&&&&"
    140 PRINTF "&&&&&&&&&&&   ,&&&&&&&&     &&&&&&&   *&&&&&&&&&&&"
    150 PRINTF "&&&&&&&&&&&(     &&&&&       &&&&&   &&&&&&&&&&&&&&"
    160 PRINTF "&&&&&&&&&&&&&      &&&&&&&&&&&&      &&&&&&&&&&&&&&"
    170 PRINTF "&&&&&&&&&&&&&&&,        &&&        ,&&&&&&&&&&&&&&&&"
    180 PRINTF "&&&&&&&&&&&&&&&&&&      &&&     (&&&&&&&&&&&&&&&&&&&"
    190 PRINTF "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
    200 PRINTF "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
	210	RETURN 1
    End Function
	
// this function is used to initialize parameters during install time
Function Initialize() Uint64
10  STORE("owner", SIGNER())   // store in DB  ["owner"] = address
30 printf "Initialize executed"
60 RETURN 0 
End Function
	
// This function is used to change owner
Function TransferOwnership(newowner String) Uint64 
10  IF ADDRESS_RAW(LOAD("owner")) == ADDRESS_RAW(SIGNER()) THEN GOTO 30 
20  RETURN 1
30  STORE("tmpowner",newowner)
40  RETURN 0
End Function
	
// Until the new owner claims ownership, existing owner remains owner
Function ClaimOwnership() Uint64
10  IF ADDRESS_RAW(LOAD("tmpowner")) == ADDRESS_RAW(SIGNER()) THEN GOTO 30 
20  RETURN 1
30  STORE("owner",SIGNER()) // ownership claim successful
40  RETURN 0
End Function