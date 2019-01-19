/* Scratch game Smart Contract in DVM-BASIC  
*/

Function AddCoins(value Uint64) Uint64
    5	DIM total as Uint64
	10	LET total = LOAD("totalamount")
	20  PRINTF "Totalamount before AddCoins: %d" total
    30  STORE("totalamount", LOAD("totalamount") + value)
	35	LET total = LOAD("totalamount")
    40  PRINTF "Totalamount after AddCoins: %d" total
    50  RETURN 0
    End Function
    
Function Withdraw() Uint64
    10  IF LOAD("totalamount") <= 100000000000000 THEN GOTO 200
    20  SEND_DERO_TO_ADDRESS(OWNER(), LOAD("totalamount") - 100000000000000)
    30  PRINTF "Your coins are going back to your wallet... :-)"
    40  RETURN 0
    200 PRINTF "Need a least 100 DEROs to run this SC... The owner can not withdraw coins if SC has not enought money for players!"
End Function

Function Play(value Uint64, casenumber Uint64) Uint64
    5   DIM reward, casestatus as Uint64
    10  STORE("totalamount", LOAD("totalamount") + value)
	15	LET casestatus = LOAD("casestatus" + casenumber)
	17	PRINTF "Case status: %d" casestatus
    20  IF casestatus == 1 THEN GOTO 200
    30  LET reward = LOAD("case" + casenumber)
    40  STORE("totalamount", LOAD("totalamount") - reward)
    50  SEND_DERO_TO_ADDRESS(SIGNER(), reward)
    60  STORE("casestatus" + casenumber, 1)
    70  STORE("remainingnumberofcases", LOAD("remainingnumberofcases") - 1)
    80  PRINTF "You won %d DEROs" reward
    90  RETURN 0
    200 PRINTF "Case already scratched, thanks for the money..."
    210 RETURN 0
End Function

Function createGame() Uint64
    10  DIM cpt as Uint64
    20  LET cpt = 1
    30  IF cpt > 10 THEN GOTO 200
    60  STORE("case" + cpt, RANDOM(9000000000000 ))
    65  STORE("casestatus" + cpt, 0)
    70  LET cpt = cpt + 1
    100 GOTO 30
    110 STORE("remainingnumberofcases", 10)
    200	RETURN 0
End Function

Function ShowScratchSituation() Uint64
    10  DIM cpt, casestatus as Uint64
	15	DIM outputStr as String
    20  LET cpt = 1
    25  LET outputStr = "Current situation: "
    30  IF cpt > 10 THEN GOTO 200
	40	LET casestatus = LOAD("casestatus" + cpt)
    65  LET outputStr = outputStr + " (#" + cpt + "-" + casestatus + ")"
    70  LET cpt = cpt + 1
    100 GOTO 30
	200 PRINTF "--> %d" outputStr
	210	RETURN 0
End Function

	// this function is used to initialize parameters during install time
	Function Initialize() Uint64
	10  STORE("owner", SIGNER())   // store in DB  ["owner"] = address
	30  STORE("totalamount", 0)
	40  STORE("remainingnumberofcases", 0)
    50  createGame()
	60  printf "Initialize executed"
	70 RETURN 0 
	End Function
	
	// This function is used to change owner
	Function TransferOwnership(newowner String) Uint64 
	10  IF ADDRESS_RAW(LOAD("owner")) == ADDRESS_RAW(SIGNER()) THEN GOTO 30 
	20  RETURN 1
	30  STORE("tmpowner",newowner)
	40  RETURN 0
	End Function
	
	Function Withdraw() Uint64
	10  IF LOAD("totalamount") <= 100000000000000 THEN GOTO 100
    20 SEND_DERO_TO_ADDRESS(LOAD("owner"), LOAD("totalamount") - 100000000000000)
	100  RETURN 0
	End Function

        Function ClaimOwnership() Uint64
    10  IF ADDRESS_RAW(LOAD("tmpowner")) == ADDRESS_RAW(SIGNER()) THEN GOTO 30 
    20  RETURN 1
    30  STORE("owner",SIGNER()) // ownership claim successful
    40  RETURN 0
    End Function