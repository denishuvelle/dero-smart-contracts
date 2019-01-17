/* Roulette Smart Contract in DVM-BASIC  
   
   Simple "roulette" game... odd/even instead of colors ;-)
*/

    Function AddCoins(value Uint64) Uint64
    10  STORE("totalamount", LOAD("totalamount") + value)
    20  RETURN 0
    End Function
    
Function TryToWinWithPreciseNumber(value Uint64, number Uint64) Uint64
    5 DIM randomNumber Uint64
	10  IF value == 2000000000000 THEN GOTO 40  // we can only play with 2 DERO or less
    20  printf "You can only play with 2 DEROs or less"
    30  RETURN 0
    40  IF number <= 36 THEN GOTO 80  // From 0 to 36
    50 PRINTF "Play a number between 0 an 36"
    60  RETURN 0
    80 IF LOAD("totalamount") >= 100000000000000 THEN GOTO 120
    90  PRINTF "SC does not contain enough dero to ensure your gain, you will be able to play when owner will add coins."
    100 RETURN 0
    120  LET randomNumber = RANDOM(37)
    130 IF randomNumber == number THEN GOTO 260
    140 SEND_DERO_TO_ADDRESS(SIGNER(), value * 36)
    150 STORE("totalamount", LOAD("totalamount") - (value * 36))
    150 PRINTF "You won %d DEROs! Congrats!" (value * 36)
    160 RETURN 0
    260 STORE("totalamount", LOAD("totalamount") + value)
    270 PRINTF "Sorry... you lost! Try again!"
    280 RETURN 0
	End Function
	
    Function TryToWinWithOddOrEven(value Uint64, kindofnumber string) Uint64
    5 DIM randomNumber Uint64
    10  IF value == 2000000000000 THEN GOTO 40  // we can only play with 2 DERO or less
    20  printf "You can only play with 2 DEROs or less"
    30  RETURN 0
    40  IF kindofnumber == "ODD" || kindofnumber == "EVEN" THEN GOTO 80
    50 PRINTF "Play with 'ODD' or 'EVEN' (without the ''!)"
    60  RETURN 0
    80 IF LOAD("totalamount") >= 100000000000000 THEN GOTO 120
    90  PRINTF "SC does not contain enough dero to ensure your gain, you will be able to play when owner will add coins."
    100 RETURN 0
    120 LET randomNumber = RANDOM(37)
    130 IF (randomNumber % 2 == 0 && kindofnumber == "ODD") || (randomNumber % 2 == 1 && kindofnumber == "EVEN") THEN GOTO 200
    140 PRINTF "Sorry... you lost! Try again!"
    160 RETURN 0
    200 SEND_DERO_TO_ADDRESS(SIGNER(), value * 2)
    210 STORE("totalamount", LOAD("totalamount") - (value * 2))
    250 PRINTF "You won %d DEROs! Congrats!" (value * 2)
    280 RETURN 0
    End Function

	// this function is used to initialize parameters during install time
	Function Initialize() Uint64
	10  STORE("owner", SIGNER())   // store in DB  ["owner"] = address
	30  STORE("totalamount", 0)
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
	
	Function Withdraw() Uint64
	10  IF LOAD("totalamount") <= 100000000000000 THEN GOTO 100
    20 SEND_DERO_TO_ADDRESS(LOAD("owner"), LOAD("totalamount") - 100000000000000)
	100  RETURN 0
	End Function