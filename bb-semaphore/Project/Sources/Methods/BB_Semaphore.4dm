//%attributes = {"shared":true,"preemptive":"capable"}
//BB_Semaphore(Name;WaitTicks)->Object
//By: Tony Ringsmuth 10/08/24, 12:06:28

//FUNCTION: 
// Simlar to 4D's Semaphore function: but managed internally via Storage
//  to allow tracking of semaphores between users.
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
//$2: Longint: Tick count to wait before giving up
//$3: object: reserved for internal use
//--------------------------------------------------------------------------------

//EXAMPLE:
//$ob:=BB_Semaphore ("MySemaphore";60*60)  `Wait one minute before timeout.
//If ($ob.greenLight)
//     `...Do some work here.
//     BB_SemaphoreClear("MySemaphore")
//end if
//--------------------------------------------------------------------------------
//REVISION HISTORY
//10/08/24: New
//--------------------------------------------------------------------------------

#DECLARE($Name_t : Text; $WaitTicks_i : Integer; $context_ob : Object)->$Result_ob : Object

var $Locked_b : Boolean
var $beginTick_i : Integer
var $o2; $ob; $Sem_ob; $Sems_ob : Object
var $semCat_t : Text

If ($Name_t="$@") || (Application type:C494#4D Remote mode:K5:5)
	//Local Semaphore
	
	$beginTick_i:=Tickcount:C458
	
	Case of 
		: ($Name_t="<global>@")
			//an internal recursive call:  we are in the server-side now via BB_SemOnServer
			$Name_t:=Substring:C12($Name_t; 9)
			$semCat_t:="SemGlobal"
			
		: ($Name_t="$@")
			$semCat_t:="SemLocal"
			
		Else 
			$semCat_t:="SemGlobal"
			
			If (Application type:C494=4D Server:K5:6)
				$context_ob:={machine_name: Current machine:C483\
					; user_name: Current user:C182\
					; system_user: Current system user:C484\
					; isServer: True:C214\
					}
			End if 
			
	End case 
	
	$Sems_ob:=BB_OB_VerifyOb(Storage:C1525; $semCat_t)
	$Sem_ob:=BB_OB_VerifyOb($Sems_ob; $Name_t)
	
	$Result_ob:={}
	
	Repeat 
		Use ($Sem_ob)
			$OfCrntProc_b:=False:C215
			If (Bool:C1537($Sem_ob.isSet))
				$OfCrntProc_b:=(($Sem_ob.process_number=Current process:C322) && ($Sem_ob.process_id=BB_Process_GetUniqueID($Sem_ob.process_number)))  //Is it a semaphore owned by the current process?
				$Locked_b:=Not:C34($OfCrntProc_b)
				If ($Locked_b)
					$Locked_b:=BB_Process_VerifyUniqueID($Sem_ob.process_number; $Sem_ob.process_id)  //Validate that the semaphore process still exists. If it does not: then the 
				End if 
			Else 
				$Locked_b:=False:C215
			End if 
			
			If ($Locked_b=False:C215) & ($OfCrntProc_b=False:C215)
				$Sem_ob.isSet:=True:C214  //This will always be true: it's just an easy way to check the semaphore.
				$Sem_ob.process_number:=Current process:C322
				$Sem_ob.process_id:=BB_Process_GetUniqueID($Sem_ob.process_number)
				$Sem_ob.process_name:=Current process name:C1392
				$Sem_ob.ts:=Timestamp:C1445
				$Sem_ob.tick:=Tickcount:C458
				
				If ($context_ob#Null:C1517)
					//This is only called for global semaphores: when we're in recursion on the server side - being called from the client side.
					For each ($pn; $context_ob)
						$Sem_ob[$pn]:=$context_ob[$pn]
					End for each 
				End if 
				
			End if 
			
		End use 
		
		If ($Locked_b && ($WaitTicks_i>0))
			DELAY PROCESS:C323(Current process:C322; 1)
		End if 
		
	Until (($Locked_b=False:C215) || ($WaitTicks_i=0) || ((Tickcount:C458-$beginTick_i)>$WaitTicks_i))
	
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
	//Do a recursive call to this same method on the server via BB_SemOnServer
	$context_ob:={isRemote: True:C214\
		; machine_name: Current machine:C483\
		; user_name: Current user:C182\
		; system_user: Current system user:C484\
		; remote_process_number: Current process:C322\
		; remote_process_id: BB_Process_GetUniqueID(Current process:C322)}
	
	$Result_ob:=BB_SemOnServer("<global>"+$Name_t; $WaitTicks_i; $context_ob)
End if 

