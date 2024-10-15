//%attributes = {}
TRACE:C157

If (Count parameters:C259>0)
	$Name_t:=$1
Else 
	$Name_t:="Emails"
End if 

$Sems_c:=BB_Semaphores_GetCol
SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($Sems_c))

$b1:=BB_Semaphore($Name_t)

$t1:=BB_SemaphoreTest($Name_t)
$b2:=BB_Semaphore($Name_t; 60*20)


BB_SemaphoreClear($Name_t)



//


