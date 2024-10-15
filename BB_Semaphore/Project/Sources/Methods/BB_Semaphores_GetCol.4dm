//%attributes = {}
//BB_Semaphores_GetCol -> Semaphores_c
//By: Tony Ringsmuth 10/08/24, 10:50:58

//FUNCTION: 
//Return a collection of all active semaphores
//--------------------------------------------------------------------------------
//PARAMETERS
//$0: Collection of objects

//--------------------------------------------------------------------------------

//EXAMPLE:
/*
[
  {
    "process_number": 10,
    "process_id": 402,
    "process_name": "P_27",
    "ts": "2024-10-08T21:06:11.824Z",
    "tick": 37306179,
    "machine_name": "MYPC",
    "user_name": "Designer",
    "system_user": "tonyr",
    "isServer": true,
    "isGlobal": true
  },
  {
    "process_number": 13,
    "process_id": 404,
    "process_name": "P_28",
    "ts": "2024-10-08T21:06:17.318Z",
    "tick": 37306509,
    "isRemote": true,
    "machine_name": "MYPC",
    "user_name": "Designer",
    "system_user": "tonyr",
    "remote_process_number": 6,
    "remote_process_id": 155,
    "isGlobal": true
  }
]
*/

//--------------------------------------------------------------------------------
//REVISION HISTORY
//10/08/24: New

//

//--------------------------------------------------------------------------------

#DECLARE()->$sems_c : Collection

var $ob; $Sems_ob : Object
$sems_c:=[]

var $pn : Text

BB_SemaphoreCleanup

If (Value type:C1509(Storage:C1525.SemLocal)=Is object:K8:27)
	For each ($pn; Storage:C1525.SemLocal)
		$ob:=OB Copy:C1225(Storage:C1525.SemLocal[$pn])
		$ob.isGlobal:=False:C215
		OB REMOVE:C1226($ob; "isSet")  //for internal use only
		$sems_c.push($ob)
	End for each 
End if 

$Sems_ob:=BB_SemOnServer("_Semapohres_GetGlobal"; 0; {})
For each ($pn; $Sems_ob)
	$ob:=OB Copy:C1225($Sems_ob[$pn])
	$ob.isGlobal:=True:C214
	OB REMOVE:C1226($ob; "isSet")  //for internal use only
	$sems_c.push($ob)
End for each 

