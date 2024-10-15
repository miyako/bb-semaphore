//%attributes = {"preemptive":"capable"}
//BB_SemaphoreCleanup
//By: Tony Ringsmuth 10/08/24, 11:05:18

//FUNCTION: 
//Cleanup un-closed semapohres for expired processes
//<NotASharedMethod>
//--------------------------------------------------------------------------------
//PARAMETERS
//none.

//--------------------------------------------------------------------------------
//REVISION HISTORY
//10/08/24: New

//--------------------------------------------------------------------------------

var $Sem_ob; $Sems_ob : Object
var $pn; $sems_t : Text

For ($ii; 0; 1)
	$sems_t:=Choose:C955($ii; "SemGlobal"; "SemLocal")
	
	$Sems_ob:=Storage:C1525[$sems_t]
	
	If ($Sems_ob#Null:C1517)
		Use ($Sems_ob)
			For each ($pn; $Sems_ob)
				$Sem_ob:=$Sems_ob[$pn]
				If (Not:C34(BB_Process_VerifyUniqueID($Sem_ob.process_number; $Sem_ob.process_id)))  //Validate that the semaphore process still exists. If it does not: then the 
					OB REMOVE:C1226($Sems_ob; $pn)
				End if 
			End for each 
		End use 
	End if 
	
End for 