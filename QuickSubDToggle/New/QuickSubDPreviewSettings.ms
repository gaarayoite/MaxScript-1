
---QuckSubD Settings v1.0---
-- 11.14.2017
--  coded by Dmitry Gubkin 

---Destroying Dialog
try DestroyDialog (QuickSubDSettings) catch()

----Vars
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------	

---Main UI 
--------------------------------------------------------------------------------------------------------------------------------------------	
	rollout QuickSubDSettings "QuickSubD Settings v1.0" width:400 height:250
	(
		subrollout qs_MainManu    width: 190 height:190 pos: [5,5] align:#cener
		
		button      btn_Cancel "Cancel"   width: 60  height: 25  align:#right
		button      btn_Apply "Apply"   width: 60  height: 25  align:#left
		button      btn_OK "OK"   width: 60  height: 25  align:#right
		
--Events
		
		on btn_OK pressed do
		(
			
		)
		
		on btn_Apply pressed do
		(
			
		)
		
		on btn_Cancel pressed do
		(
			try DestroyDialog (QuickSubDSettings) catch()
		)
		
		on QuickSubDSettings open do
		(
		)

	)
--------------------------------------------------------------------------------------------------------------------------------------------	
	
---Funcs
--------------------------------------------------------------------------------------------------------------------------------------------
function fn_MakeSettingsDlg =
(
--Sub UI Items
	rollout qs_SubMainMenu01 "Main Settings" 
	(
		dropDownList ddl_SubDType "Subdivision Method " pos:[0,0] width:180 height:40 align:#center 
		dropDownList ddl_PositionInStack "Position in Stack " pos:[0,45] width:180 height:40 align:#center 
		label lb_Itrs "Iterations:" pos:[0,90] width:100 height:16 align:#left
		spinner spn_ItrsCount  pos:[126,90] width:50 height:16 range:[0,8,2] type:#integer align:#left
		checkbox chk_RenderIters "Render Iterations" pos:[0,111] width:104 height:16 align:#left cheked:false
		spinner spn_RenderItrsCount  pos:[126,111] width:50 height:16 range:[0,10,3] type:#integer align:#left  enabled:false
		checkbox chk_IsolateDisplay "Isolate Display" pos:[0,127] width:104 height:16 align:#left cheked:false
		checkbox chk_UndoOff "Undo Off" pos:[0,143] width:104 height:16 align:#left cheked:false
		
--Events		
	)
		
	createdialog QuickSubDSettings
	AddSubrollout QuickSubDSettings.qs_MainManu qs_SubMainMenu01 
	qs_SubMainMenu01.open = true
	
	QuickSubDSettings.btn_Cancel.pos = [5, QuickSubDSettings.height]-[0,30] 
	QuickSubDSettings.btn_Apply.pos = QuickSubDSettings.btn_Cancel.pos+[65,0]
	QuickSubDSettings.btn_OK.pos = QuickSubDSettings.btn_Apply.pos+[65,0]
	
	)
--end func
	
	function fn_ReadSettings =
	(
		
	)
--------------------------------------------------------------------------------------------------------------------------------------------	
	
--------------------------------------------------------------------------------------------------------------------------------------------
--Create UI
fn_MakeSettingsDlg()	







