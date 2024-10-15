//%attributes = {"shared":true,"preemptive":"capable"}
//BB_SemaphoreTest(Name) ->Object
//By: Tony Ringsmuth 10/08/24, 09:33:22

//FUNCTION: 
// Read (but do NOT update) the state of a semaphore
//<Category Miscellaneous>
//--------------------------------------------------------------------------------
//PARAMETERS
//$0: Object: 
//  redLight:boolean  : opposite of greenLight
//  greenLight:boolean: opposite of redLight
//  ONLY SET IF greenLight:
//    isSetInLocalProcess: boolean:  true if the semaphore already existed in the current process. Only set if greenLight.
//  ONLY SET IF redLight:
//    process_number
//    process_id
//    process_name
//    ts: text: timestamp
//    tick
//  FOR GLOBAL SEMAPHORES ONLY:
//    machine_name
//    user_name
//    system_user
//    remote_process_number
//    remote_process_id

//$1: Text: Name of the semaphore:  if start with "$", then a local semaphore, else global.

//--------------------------------------------------------------------------------
//REVISION HISTORY
//10/08/24: New

//--------------------------------------------------------------------------------

#DECLARE($Name_t : Text)->$Result_ob : Object

var $Locked_b : Boolean
var $Sem_ob; $Sems_ob : Object
var $semCat_t : Text

$Locked_b:=False:C215
$Result_ob:={}

If ($Name_t="$@") || (Application type:C494#4D Remote mode:K5:5)
	
	Case of 
		: ($Name_t="<global>@")
			//an internal recursive call:  we are in the server-side now via BB_SemOnServer
			$Name_t:=Substring:C12($Name_t; 9)
			$semCat_t:="SemGlobal"
			
		: ($Name_t="$@")
			$semCat_t:="SemLocal"
		Else 
			$semCat_t:="SemGlobal"
	End case 
	
	$OfCrntProc_b:=False:C215
	
	//Local Semaphore
	$Sems_ob:=BB_OB_VerifyOb(Storage:C1525; $semCat_t)
	If (Value type:C1509($Sems_ob[$Name_t])=Is object:K8:27)
		Use ($Sems_ob)
			$Sem_ob:=$Sems_ob[$Name_t]
			
			If (BB_Process_VerifyUniqueID($Sem_ob.process_number; $Sem_ob.process_id))
				//Semaphore Process is still valid
				If (Bool:C1537($Sem_ob.isSet))
					//If the semaphore is in the current process: then return False.
					$OfCrntProc_b:=($Sem_ob.process_number=Current process:C322)
					$Locked_b:=Not:C34($OfCrntProc_b)
				End if 
				
			Else 
				//the semaphore process has terminated
				OB REMOVE:C1226($Sems_ob; $Name_t)
				$Locked_b:=False:C215
			End if 
		End use 
	End if 
	
	
	$Result_ob.greenLight:=Not:C34($Locked_b)
	$Result_ob.redLight:=$Locked_b
	If ($Locked_b)
		$o2:=OB Copy:C1225($Sem_ob)
		OB REMOVE:C1226($o2; "isSet")
		$Result_ob.lockingContext:=$o2
	Else 
		$Result_ob.isSetInLocalProcess:=$OfCrntProc_b
	End if 
	
	
Else 
	$Result_ob:=BB_SemOnServer("<global>"+$Name_t; 0; {isTest: True:C214})
End if 
