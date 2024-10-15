//%attributes = {"preemptive":"capable"}
  //BB_Process_VerifyUniqueID(ProcID;UniqueID) -> bool
  //By: Tony Ringsmuth 09/30/19, 09:42:14

  //FUNCTION: 
  // Return True if the Process ID matches the Unique ID, and it's still valid.

  //--------------------------------------------------------------------------------
  //PARAMETERS
  //$0: Boolean: true if process number$1's ID=$2
  //$1: Longint: 4D process number
  //$2: Longint: 4D process ID.

  //--------------------------------------------------------------------------------
  //REVISION HISTORY
  //09/30/19: New

  //--------------------------------------------------------------------------------
C_BOOLEAN:C305($0)
C_LONGINT:C283($1;$2)
$0:=(BB_Process_GetUniqueID ($1)=$2)
