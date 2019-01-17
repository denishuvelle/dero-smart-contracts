/* HODL Worthily Smart Contract in DVM-BASIC  
   
	Not a classical "HODL Smart Contract"... The purpose Is to HODL for a given amount of blocks (so * 12 seconds to simulate the time to HODL) And to protect your DERO from a panic sale after a big FUD on Twitter.

	But... if you really need to access to your coins before the end of the HODL period (DERO goes to the moon, you want to sell after this * 100...), you can still withdraw the locked DERO: but you will only receive a part Of your coins (calculated according To % Of blocks before End Of the HODL period). I limit To 50% Of the coins (so, If you withdraw just after starting the contract And you don't want to wait for the 999999 blocks you won't receive 0.000001% but 50%).

	Where the remaining amount Is going?!
	That won't disappear and that will be very useful for a chosen foundation (this foundation has to create its Dero wallet!) like UNICEF.

	In all scenario, the DERO address of the chosen foundation receive 1% of the HODL amount, even if HODL period Is finished, only 99% of the amount can be withdraw.

	So it's not the classical HODL smart contract where your coins are blocked until the end: you still have the option to get them back early but you must share them with UNICEF.
	Even if you respect the locking time, you will send at least 1% to UNICEF: we know Dero will go to the moon... if you lock your Dero bag in this contract, you will automatically share a small part of your future wealth :)
*/

	Function Hodl(value Uint64, numberOfBlocks Uint64) Uint64
	10  IF value == 0 THEN GOTO 110  // if deposit amount Is 0, simply return
	20  IF numberOfBlocks <= 0 THEN GOTO 110  // if number of blocks Not > 0, simply return
	30  STORE("depositor_" + SIGNER(), value) // store address And amount: we don't support multiple HODL period, need 2 DERO wallets for that...
	40  STORE("depositor_beginning_period_block_" + SIGNER(), BLOCK_HEIGHT()) // store current block number for beginning of HODL period
    50  STORE("depositor_number_of_blocks_" + SIGNER(), numberOfBlocks) // store number of blocks for HODL period
	110  RETURN 0
	End Function
	
	// this function is used to initialize parameters during install time
	Function Initialize() Uint64
	10  STORE("owner", SIGNER())   // store in DB  ["owner"] = address
	20  STORE("foundationaddress", "dETofNoog8yaoLjH7SHy7NVAr91jZmDyC5UdrGi8xyeteinEaGEtw3APyjLbwGcunjYSJM3GsHXiKUKAJbKYmsC765GTfJ5dcV")   // HODL contract will always give 1% of the amount Or more if withdraw before the end of the HODL period
	30  STORE("maxpercentageforfoundation", 5000)   // Contract will give at least 50% even if withdraw to soon
	35 printf "Initialize executed"
	40 RETURN 0 
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
	
	// if everything is okay, coins will be showing in signers wallet
	Function Withdraw(amount Uint64) Uint64
	5	printf "Entering Withdraw"
    10  DIM amount,amountforfoundation,startblockheight,numberfofblockstowait,endblockheight,differenceOfBlocks,currentBlockHeight,percentagedone,percentageforfoundation as Uint64
    15  IF EXISTS("depositor_" + SIGNER()) == 0) THEN GOTO 30 
	20  RETURN 1
	30  LET amount = LOAD("depositor_" + SIGNER())
	35  LET startblockheight = LOAD("depositor_beginning_period_block_" + SIGNER())
	40  LET numberfofblockstowait = LOAD("depositor_number_of_blocks_" + SIGNER())
    45  LET endblockheight = startblockheight + numberfofblockstowait
    50  LET currentBlockHeight = BLOCK_HEIGHT()
    55  LET differenceOfBlocks = currentBlockHeight - endblockheight
    120 IF blockheighttoendperiod <= BLOCK_HEIGHT() THEN GOTO 200 // The end block Is "in the past", we can return the coins (except 1% for the foundation)
    // If we are here, the signer withdraws before the end of the HODL period.
    130 LET percentagedone = (differenceOfBlocks/numberfofblockstowait) * 100
    140 IF percentagedone > 50 THEN GOTO 170
    150 LET percentagedone = 50 // Even if withdraw very early, we don't go under 50%
    160 LET percentageforfoundation = 50
    165 GOTO 210
	170 LET percentageforfoundation = 100 - percentagedone
    175 GOTO 210
    200 percentageforfoundation = 1
    210 PRINT "Percentage for foundation: " + percentageforfoundation
    215 LET amountforfoundation = (amount / 100) * percentageforfoundation
    217 PRINT "Amount for foundation: " + amountforfoundation
    220 SEND_DERO_TO_ADDRESS(SIGNER(), amount - amountforfoundation)
    225 SEND_DERO_TO_ADDRESS(LOAD("foundationaddress"), amountforfoundation)
    300 RETURN 0
	End Function