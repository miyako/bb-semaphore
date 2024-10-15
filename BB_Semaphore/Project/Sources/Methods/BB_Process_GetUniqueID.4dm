//%attributes = {"preemptive":"capable"}
  //BB_Process_GetUniqueID(ProcessID) ->UniqueProcessID
  //By: Tony Ringsmuth
  //Part of the BB_Base Component, by Business Brothers.
  //--------------------------------------------------------------------------------
  //FUNCTION
  //Get the Unique Proess ID of a process number
  //<Category Process Management>
  //--------------------------------------------------------------------------------
  //PARAMETERS
  //$0: Longint: the "unique process id" as returned by $6 of PROCESS PROPERTIES
  //$1: Longint: a normal 4D process ID.  if no $1 passed, then return for the current process.
  //--------------------------------------------------------------------------------
  //EXAMPLE:
  //--------------------------------------------------------------------------------
  //REVISION HISTORY
  //09/08/10, 17:17:37: New
  //--------------------------------------------------------------------------------


C_LONGINT:C283($0;$UniqueID_i)
C_LONGINT:C283($1;$ProcID_i)
C_TEXT:C284($ProcName)
C_LONGINT:C283($ProcState_i;$ProcTime_i)
C_BOOLEAN:C305($Visible_b)

If (Count parameters:C259>0)
	$ProcID_i:=$1
Else 
	$ProcID_i:=Current process:C322
End if 

PROCESS PROPERTIES:C336($ProcID_i;$ProcName;$ProcState_i;$ProcTime_i;$Visible_b;$UniqueID_i)

$0:=$UniqueID_i
  //
