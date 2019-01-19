/* Lucky Test Smart Contract in DVM-BASIC  
   
   Test your chance!
*/

    Function AddCoins(value Uint64) Uint64
    10  STORE("totalamount", LOAD("totalamount") + value)
    20  RETURN 0
    End Function

    Function CheckStatus()
    10  PRINTF "Current jackpot = %d, number of tentatives = %d, started on block %d." LOAD("totalamount") LOAD("tentatives") LOAD("blocknumberfsincebeginning")
    20  RETURN 0
    End Function

Function TryToWin(value Uint64) Uint64
	10  IF value == 500000000000  THEN GOTO 100  // we can only play with 0.5 DERO
    20  printf "You can only play with 0.5 DERO"
    30  RETURN 0
    40  STORE("totalamount", LOAD("totalamount") + value)
    50  STORE("tentatives", LOAD("tentatives") + 1)
	100  IF LOAD("winnernumber") == RANDOM(999) THEN GOTO 140
    110  PRINTF "You lost... try again!"
    120  RETURN 0
    140 SEND_DERO_TO_ADDRESS(SIGNER(), (LOAD("totalamount") / 100) * 95)
    150 SEND_DERO_TO_ADDRESS(LOAD("owner"), (LOAD("totalamount") / 100) * 5)
    160 STORE("winnernumber", RANDOM(999))   // Number between 0 And 999
    170 STORE("totalamount", 0)
    180 STORE("blocknumberfsincebeginning", BLOCK_HEIGHT())
    190 STORE("tentatives", 0)
    200 PRINTF "You win!"
	210  RETURN 0
	End Function
	
	// this function is used to initialize parameters during install time
	Function Initialize() Uint64
	10  STORE("owner", SIGNER())   // store in DB  ["owner"] = address
	20  STORE("winnernumber", RANDOM(999))   // Number between 0 And 999
	30  STORE("totalamount", 0)
	40  STORE("blocknumberfsincebeginning", BLOCK_HEIGHT())
    50  STORE("tentatives", 0)
	60 printf "Initialize executed"
	80 RETURN 0 
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