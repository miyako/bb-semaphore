//%attributes = {"shared":true,"preemptive":"capable"}
//BB_OB_VerifyOb(ParentOb;SubName1;{SubNameN}) -> Object
//By: Tony Ringsmuth 02/22/20, 10:02:36
//Part of the BB_Base Component, by Business Brothers.
//--------------------------------------------------------------------------------
//FUNCTION: 
// Verify (and return) a sub-object (to any level)
// Works with Shared, or non-shared.

//<Category JsonObject>
//--------------------------------------------------------------------------------
//PARAMETERS
//$0: Final (deepest) object
//$1: Any Defined object, shared or not,including Storage
//$2-$n: Sub-object Name{s}
//--------------------------------------------------------------------------------
//EXAMPLE
//Example1:
//$Vars_ob:=BB_OB_VerifyOb (Storage;"vars")

//Example2:
//$Xyz_ob:=BB_OB_VerifyOb (Storage;"vars";"ProcFin";"Xyz")

//Example3:
//$Xyz_ob:=BB_OB_VerifyOb ($MyOb;"Xyz")

//--------------------------------------------------------------------------------
//REVISION HISTORY
//02/22/20 TRR : New

//--------------------------------------------------------------------------------

C_OBJECT:C1216($0)
C_OBJECT:C1216($1; $CrntOb)
C_TEXT:C284(${2})  //sub level object names
C_TEXT:C284($Name_t)


$CrntOb:=$1

C_BOOLEAN:C305($Shared_b)
$Shared_b:=(OB Get type:C1230($CrntOb; "__LockerID")=1)  //All shared objects, including Storage have a numeric "__LockerID" property.

$PrmStart_i:=2


C_LONGINT:C283($Prm_i)

ARRAY TEXT:C222($aPN; 0)
For ($Prm_i; $PrmStart_i; Count parameters:C259)
	$Name_t:=${$Prm_i}
	APPEND TO ARRAY:C911($aPN; $Name_t)
End for 


For ($Prm_i; 1; Size of array:C274($aPN))
	$Name_t:=$aPN{$Prm_i}
	If (Value type:C1509($CrntOb[$Name_t])#Is object:K8:27)
		
		If ($Shared_b)
			Use ($CrntOb)
				$CrntOb[$Name_t]:=New shared object:C1526
			End use 
		Else 
			$CrntOb[$Name_t]:=New object:C1471
		End if 
		
	End if 
	$CrntOb:=$CrntOb[$Name_t]
End for 
$0:=$CrntOb