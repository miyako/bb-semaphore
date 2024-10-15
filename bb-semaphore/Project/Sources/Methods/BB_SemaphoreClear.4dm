//%attributes = {}
//BB_SemaphoreClear(Name)
//By: Tony Ringsmuth 10/08/24, 10:26:02

//FUNCTION: 
// Used to clear a semaphore.  
// Can only clear a semaphore created by the local process.
//--------------------------------------------------------------------------------
//PARAMETERS
//$1: text: semaphore name

//--------------------------------------------------------------------------------
//REVISION HISTORY
//10/08/24: New

//--------------------------------------------------------------------------------

#DECLARE($Name_t : Text)->$Result_b : Boolean

var $semCat_t : Text

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
	
	$Sems_ob:=BB_OB_VerifyOb(Storage:C1525; $semCat_t)
	
	If (Value type:C1509($Sems_ob[$Name_t])=Is object:K8:27)
		$Sem_ob:=$Sems_ob[$Name_t]
		If (Bool:C1537($Sem_ob.isSet))
			//If the semaphore is in the current process: then return False.
			If ($Sem_ob.process_number=Current process:C322) && ($Sem_ob.process_id=BB_Process_GetUniqueID($Sem_ob.process_number))
				Use ($Sems_ob)  //Using this higher-level object also gives us USE access to deeper shared objects.
					$Sem_ob.isSet:=False:C215
					OB REMOVE:C1226($Sems_ob; $Name_t)
				End use 
			End if 
		End if 
		
	End if 
	
Else 
	BB_SemOnServer("<global>"+$Name_t; 0; {clearSemaphore: True:C214})
End if 