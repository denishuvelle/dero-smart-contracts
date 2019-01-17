/* Safe Smart Contract in DVM-BASIC  
   
   Keep secret your seed is already a good protection to keep your coins... But if you deposit your coins to a SC with a password, you have a protection if somebody found your seed!
*/

    Function Deposit(value Uint64, password String) Uint64
    10  IF EXISTS(SIGNER()) == 1 THEN GOTO 100
    20  STORE(SIGNER(), value)
    30  STORE(SIGNER() + "password", password)
    40  PRINTF "Your coins have been saved, don't lose your password!"
    50  RETURN 0
    100 IF LOAD(SIGNER() + "password") != password THEN GOTO 200
    110 STORE(SIGNER(), LOAD(SIGNER()) + value)
	115  PRINTF "Your coins have been added to existing coins!"
    120 RETURN 0
    200 PRINTF "You already have coins in this SC: you have to use the same password again to deposit more coins!"
    210  RETURN 1
    End Function

Function Withdraw(password String) Uint64
    10  IF EXISTS(SIGNER()) == 0 THEN GOTO 300
    15	IF LOAD(SIGNER() + "password") != password THEN GOTO 200
    20  SEND_DERO_TO_ADDRESS(SIGNER(), LOAD(SIGNER()))
    30  PRINTF "Your coins are going back to your wallet... :-)"
    40  RETURN 0
    200 PRINTF "Password incorrect, try again..."
    210 RETURN 1
    300 PRINTF "You don't have coins in this SC..."
    310 RETURN 1
	End Function
	
	// this function is used to initialize parameters during install time
	Function Initialize() Uint64
	10  STORE("owner", SIGNER())   // store in DB  ["owner"] = address
	60 printf "Initialize executed"
	70 RETURN 0 
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