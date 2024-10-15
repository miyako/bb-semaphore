//%attributes = {"executedOnServer":true,"preemptive":"capable"}
//BB_SemOnServer(name;WaitTicks;Context_ob)
//By: Tony Ringsmuth 10/08/24, 09:56:12

//FUNCTION: 
// an "execute on server" method
// Not exposed to host:  internal only
//<NotASharedMethod>
//--------------------------------------------------------------------------------
//PARAMETERS


//--------------------------------------------------------------------------------
//REVISION HISTORY
//10/08/24: New

//--------------------------------------------------------------------------------

#DECLARE($Name_t : Text; $WaitTicks_i : Integer; $context_ob : Object)->$Result_v : Variant

//TRACE
Case of 
	: (Bool:C1537($context_ob.isTest))
		$Result_v:=BB_SemaphoreTest($Name_t)
		
		
	: (Bool:C1537($context_ob.clearSemaphore))
		BB_SemaphoreClear($Name_t)
		
		
	: ($Name_t="_Semapohres_GetGlobal")
		
		BB_SemaphoreCleanup  //Clean up any semaphores from terminated processes
		
		If (Value type:C1509(Storage:C1525.SemGlobal)=Is object:K8:27)
			$Result_v:=Storage:C1525.SemGlobal
		Else 
			$Result_v:={}
		End if 
		
	Else 
		$Result_v:=BB_Semaphore($Name_t; $WaitTicks_i; $context_ob)
End case 
