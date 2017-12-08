
---QuckSubD Toggle global version v1.0.2---
--  coded by Dmitry Gubkin 

---Destroying Dialog
try DestroyDialog (QuickSubDSettings) catch()

----Vars
--------------------------------------------------------------------------------------------------------------------------------------------
The_SetArr  -- Array of settings
global The_QSubDTogg
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------

--function cheking main script class instance
function fn_CheckMS = 
(

	if The_QSubDTogg == undefined do 
	(
		local MsPath = (symbolicPaths.getPathValue "$userScripts")+"\\Quick SubD Toggle\\QuickSubDPreview.ms"
		
		if doesFileExist MsPath == true then 
		(
			print ("Please Wait,Main Script Initializing...")
			filein MsPath
			sleep 5 
		)
			else 
					(
						try DestroyDialog (QuickSubDSettings) catch()
						return (messageBox "Can't locate main script file\n=>Try Reinstall tool to fix it!" title:"Quick SubD Toggle")
					)
	)

)
--end func 

--------------------------------------------------------------------------------------------------------------------------------------
--Load Drop Down Lists Items
function fn_LoadDDLItems =
(
	local ddlArr =The_QSubDTogg.fn_GetUIData()
--main UI--
	qs_SubMainMenu01.ddl_PositionInStack.items = ddlArr[1]
	qs_SubMainMenu01.ddl_SubDType.items = ddlArr[2]

--Exstra Tools	
	qs_Tools01.ddl_SubDType.items = ddlArr[3]
	qs_Tools01.ddl_SubDMethod.items = ddlArr[4]
)
--end func 

--Set Checkbox state
function fn_SetCheck val = 
(
	if val == false then return 0 else return 1
)
--end func 

--------------------------------------------------------------------------------------------------------------------------------------
--Read Settings
function fn_ReadSettings = 
(
	local flag = false
	The_SetArr = The_QSubDTogg.fn_GetSubDSettings() -- local settings array

-- select drop down list items by current settings	
	for j=1 to (qs_SubMainMenu01.ddl_PositionInStack.items.count) do 
	(
		if (qs_SubMainMenu01.ddl_PositionInStack.items[j] == The_SetArr[5]) and flag == false  do 
		(
			qs_SubMainMenu01.ddl_PositionInStack.selection = j
			flag =true
		)
		
	)
flag = false
	for j=1 to (qs_SubMainMenu01.ddl_SubDType.items.count) do 
	(
		if (qs_SubMainMenu01.ddl_SubDType.items[j] == The_SetArr[6]) and flag == false do 
		(
			qs_SubMainMenu01.ddl_SubDType.selection = j
			flag = true
		)
		
	)
--Fill Main Settings
qs_SubMainMenu01.spn_ItrsCount.value = The_SetArr[1]
qs_SubMainMenu01.chk_RenderIters.triState  = (fn_SetCheck The_SetArr[2])
qs_SubMainMenu01.spn_RenderItrsCount.value = The_SetArr[3]
qs_SubMainMenu01.chk_IsolateDisplay.triState  = (fn_SetCheck The_SetArr[4])
qs_SubMainMenu01.chk_UndoOff.triState  = (fn_SetCheck The_SetArr[7])
qs_SubMainMenu01.chk_SkipByPoly.triState = (fn_SetCheck The_SetArr[8])
qs_SubMainMenu01.spn_PolyCount.value = The_SetArr[9]


-- Fill SubD Switch 
qs_SubDSwitch01.chk_FixedIter.triState 	= (fn_SetCheck The_SetArr[11])
qs_SubDSwitch01.chk_MakeFixedFirs.triState	= (fn_SetCheck The_SetArr[10])
qs_SubDSwitch01.spn_FixedItrsTS.value 	= The_SetArr[12][1]
qs_SubDSwitch01.spn_FixedItrsMS.value 	= The_SetArr[12][2]
qs_SubDSwitch01.spn_FixedItrsOS.value	= The_SetArr[12][3]
qs_SubDSwitch01.chk_MSSkip.triState   	= (fn_SetCheck The_SetArr[13])

--enable elements of SubD Switch roll
qs_SubDSwitch01.chk_MakeFixedFirs.enabled	=
qs_SubDSwitch01.spn_FixedItrsTS.enabled 	=
qs_SubDSwitch01.spn_FixedItrsMS.enabled 	=
qs_SubDSwitch01.spn_FixedItrsOS.enabled		= The_SetArr[11]	
qs_SubMainMenu01.spn_RenderItrsCount.enabled = The_SetArr[2] --enable/disable rener iters spiner
qs_SubMainMenu01.spn_PolyCount.enabled = The_SetArr[8] -- enable/disable skip by poly count	
)
--end func

--------------------------------------------------------------------------------------------------------------------------------------
--Apply config
function fn_SetConfig = 
(
	The_QSubDTogg.fn_SetSubDSettings The_SetArr
)
--end func

--------------------------------------------------------------------------------------------------------------------------------------------
---Main UI 
--------------------------------------------------------------------------------------------------------------------------------------------	
rollout QuickSubDSettings "QuickSubD Settings v1.0.1" width:395 height:290
(
	subrollout qs_MainMenu    	width: 190 height:240 pos: [5,5] 		align:#left
	subrollout qs_SubDSwitch    width: 190 height:110 pos: [200,5] 		align:#left
	subrollout qs_Tools    		width: 190 height:153 pos: [200,115] 	align:#left
	
	button      btn_Toggle 			"Toggle" width: 60  height: 20  align:#right
	button      btn_Switch 			"Switch" width: 60  height: 20  align:#left
	checkbutton btn_DisplaySubD 	"Show"   width: 60  height: 20  align:#right highlightColor:(color 79  170  176) cheked:false border:true
	
	button      btn_Cancel "Cancel"   	width: 60  height: 20  align:#right
	button      btn_Apply "Apply"  		width: 60  height: 20  align:#left
	button      btn_OK "OK"  		 	width: 60  height: 20  align:#right
	
	hyperlink   hl_WebSite ">By Dmitry Gubkin<"  pos:[245,270]  color:(color 79  180  176) hoverColor:(color 277 130 69)  visitedColor:(color 79  180  176)  address:"https://www.artstation.com/dmitry_g"
	

	
--Events	
	on btn_OK pressed do
	(
		fn_SetConfig()
		try DestroyDialog (QuickSubDSettings) catch()
	)
-----------------------------------------	
	on btn_Apply pressed do
	(
		fn_SetConfig()
	)
-----------------------------------------	
	on btn_Cancel pressed do
	(
		try DestroyDialog (QuickSubDSettings) catch()
	)
-----------------------------------------	
	on QuickSubDSettings open do
	(
		--fn_CheckMS()	
	)
-----------------------------------------
	on QuickSubDSettings close do 
	(
		The_QSubDTogg.fn_DisplaySubDOnObjs false
	)
-----------------------------------------
	on btn_Toggle pressed do 
	(
		The_QSubDTogg.fn_ToggSubD()
	)
-----------------------------------------
	on btn_Switch pressed do 
	(
		The_QSubDTogg.fn_SwitchSubD()
	)
-----------------------------------------
	on btn_DisplaySubD changed  state do 
	(
		The_QSubDTogg.fn_DisplaySubDOnObjs state
	)
--end Event
)
--------------------------------------------------------------------------------------------------------------------------------------------	


--Sub UI Items
rollout qs_SubMainMenu01 "Main Settings" 
(
	dropDownList ddl_SubDType "Subdivision Method:" pos:[0,0] width:180 height:40 align:#left 
	dropDownList ddl_PositionInStack "Position in Stack:" pos:[0,45] width:180 height:40 align:#left 
	label lb_Itrs "Iterations:" pos:[0,90] width:100 height:16 align:#left
	spinner spn_ItrsCount  pos:[126,90] width:50 height:16 range:[0,8,2] type:#integer align:#left
	checkbox chk_RenderIters "Render Iterations" pos:[0,111] width:104 height:16 align:#left cheked:false
	spinner spn_RenderItrsCount  pos:[126,111] width:50 height:16 range:[0,10,3] type:#integer align:#left  enabled:false
	checkbox chk_IsolateDisplay "Isolate Display" pos:[0,127] width:104 height:16 align:#left cheked:false
	checkbox chk_UndoOff "Undo Off" pos:[0,143] width:190 height:16 align:#left cheked:false
	checkbox chk_SkipByPoly "Skip By Poly" pos:[0,160] width:90 height:16 align:#left cheked:false
	spinner spn_PolyCount  pos:[100,160] width:60 height:16 range:[1,100000,1000] type:#integer align:#left enabled:false
	label lb_PolyK "K." pos:[163,160] width:100 height:16 align:#left
	
	button      btn_Store 		"Store Config"  		pos: [0,190] 	width: 80  height: 20  align:#left
	button      btn_Default 	"Reset Config"  		pos: [97,190] 	width: 80  height: 20  align:#left

--Events
	on ddl_SubDType selected i do 
	(
		The_SetArr[6] = ddl_SubDType.items[i]
	)
-----------------------------------------
	on ddl_PositionInStack selected i do 
	(
		The_SetArr[5] = ddl_PositionInStack.items[i]
	)
-----------------------------------------
	on spn_ItrsCount changed val do 
	(
		The_SetArr[1] = val
	)
-----------------------------------------
	on spn_RenderItrsCount changed val do 
	(
		The_SetArr[3] = val
	)
-----------------------------------------
	on chk_IsolateDisplay changed state do 
	(
		The_SetArr[4] = state
	)
-----------------------------------------
	on chk_UndoOff changed state do 
	(
		The_SetArr[7] = state
	)
-----------------------------------------
	on spn_PolyCount changed val do 
	(
		The_SetArr[9] = val
	)
-----------------------------------------
	on chk_RenderIters changed state do 
	(
		The_SetArr[2] = state
		if state == true then 
		(
			spn_RenderItrsCount.enabled =  true 
		)
		else (spn_RenderItrsCount.enabled = false )
	)
-----------------------------------------
	on chk_SkipByPoly changed state do 
	(
		The_SetArr[8] = state
		if state == true then 
		(
			spn_PolyCount.enabled = true
		)
		else (spn_PolyCount.enabled = false)
	)
-----------------------------------------
	on btn_Store pressed do 
	(
		fn_SetConfig()
		The_QSubDTogg.fn_WriteConfig()
		Print ("=>Config file has been successfully saved!")
	)
-----------------------------------------
	on btn_Default pressed do 
	(
		The_QSubDTogg.fn_RestoreSettings()
		fn_ReadSettings()
		The_QSubDTogg.fn_RemoveConfig()
	)
-----------------------------------------
--end Events			
)
--end main dialog

rollout qs_SubDSwitch01 "SubD Switch" 
(
	checkbox chk_FixedIter "Fixed Iterations" pos:[0,0] width:170 height:16 align:#left 					cheked:false
	checkbox chk_MakeFixedFirs "Make Fixed Firs" pos:[0,21] width:170 height:16 align:#left cheked:false 	enabled:false
	spinner spn_FixedItrsTS  "TS:" pos:[0,42] width:30 height:16 range:[0,8,3] type:#integer align:#left 	enabled:false
	spinner spn_FixedItrsMS  "MS:" pos:[60,42] width:30 height:16 range:[0,8,3] type:#integer align:#left 	enabled:false
	spinner spn_FixedItrsOS  "OS:" pos:[120,42] width:30 height:16 range:[0,8,4] type:#integer align:#left 	enabled:false
	checkbox chk_MSSkip "Ignore Mesh Smooth Switching" pos:[0,63] width:170 height:16 align:#left 			cheked:false
	
--Events	
	on chk_FixedIter changed state do 
	(
		The_SetArr[11] = state
		if state == true then 
		(
			spn_FixedItrsTS.enabled = chk_MakeFixedFirs.enabled = spn_FixedItrsTS.enabled = spn_FixedItrsMS.enabled = spn_FixedItrsOS.enabled  = true
		)
		else (spn_FixedItrsTS.enabled = chk_MakeFixedFirs.enabled = spn_FixedItrsTS.enabled = spn_FixedItrsMS.enabled = spn_FixedItrsOS.enabled = false)
	)
-----------------------------------------
	on chk_MakeFixedFirs changed state do 
	(
		The_SetArr[10] = state
	)
-----------------------------------------
	on spn_FixedItrsTS changed val do 
	(
		The_SetArr[12][1] = val
	)
-----------------------------------------
	on spn_FixedItrsMS changed val do 
	(
		The_SetArr[12][2] = val
	)
-----------------------------------------
on spn_FixedItrsOS changed val do 
	(
		The_SetArr[12][3] = val
	)		
-----------------------------------------
on chk_MSSkip changed state do 
	(
		The_SetArr[13] = state
	)
--end Events	
)
--end sub roll

rollout qs_Tools01 "Exstra Tools" 
(
	radiobuttons rb_seltype labels:#("All", "Selection") pos:[0,5] width:30 height:40 default:2 columns:1

	button      btn_Remove 	"Remove"   				pos: [70,0] 	width: 52  height: 18  align:#left
	button      btn_Update 	"Update"   				pos: [125,0] 	width: 52  height: 18  align:#left
	button      btn_Add 	"Add"  						pos: [70,20] 	width: 30  height: 18  align:#left
	button      btn_AddUpd 	"Add & Update"  		pos: [102,20] 	width: 75  height: 18  align:#left
	

	
	label lb_TextSepar "-------------------------------------------" pos:[0,50] width:185 height:16 align:#left
	
	dropDownList ddl_SubDType "Type Filter:" 				pos:[0,65] 		width:80 	height:40 	align:#left
	dropDownList ddl_SubDMethod "Mehtod Filter:"  		pos:[82,65] 	width:100 	height:40 	align:#left
	button      btn_SelectByFilter 	"Select By Filters"  	pos: [0,105] 	width: 178  height: 20  align:#left

--Events	
	on btn_Remove pressed do 
	(
		local sel = true 
		if rb_seltype.state == 1 do (sel = false)
		The_QSubDTogg.fn_UpdateSubD 0 sel false
	)
-----------------------------------------
	on 	btn_Update pressed do 
	(
		local sel = true 
		if rb_seltype.state == 1 do (sel = false)
		The_QSubDTogg.fn_SetSubDSettings The_SetArr
		The_QSubDTogg.fn_UpdateSubD 1 sel false
	)
-----------------------------------------
	on 	btn_Add pressed do 
	(
		local sel = true 
		if rb_seltype.state == 1 do (sel = false)
		The_QSubDTogg.fn_SetSubDSettings The_SetArr
		The_QSubDTogg.fn_UpdateSubD 2 sel false
	)
-----------------------------------------
	on 	btn_AddUpd pressed do 
	(
		local sel = true 
		if rb_seltype.state == 1 do (sel = false)
		The_QSubDTogg.fn_SetSubDSettings The_SetArr
		The_QSubDTogg.fn_UpdateSubD 3 sel false
	)
-----------------------------------------
	on 	btn_SelectByFilter pressed do 
	(
		The_QSubDTogg.fn_SelectSubDObjects (ddl_SubDType.selected) (ddl_SubDMethod.selected) 
	)
--end Events	
)
-- end sub roll 

	
createdialog QuickSubDSettings style:#(#style_toolwindow, #style_border, #style_sysmenu)
AddSubrollout QuickSubDSettings.qs_MainMenu qs_SubMainMenu01 
AddSubrollout QuickSubDSettings.qs_SubDSwitch qs_SubDSwitch01 
AddSubrollout QuickSubDSettings.qs_Tools qs_Tools01 

qs_SubMainMenu01.open = true
qs_SubDSwitch01.open = true
qs_Tools01.open = true
--buttons position
QuickSubDSettings.btn_Cancel.pos = [5, QuickSubDSettings.height]-[0,25] 
QuickSubDSettings.btn_Apply.pos = QuickSubDSettings.btn_Cancel.pos+[65,0]
QuickSubDSettings.btn_OK.pos = QuickSubDSettings.btn_Apply.pos+[65,0]

QuickSubDSettings.btn_Toggle.pos = [5, QuickSubDSettings.height]-[0,47] 
QuickSubDSettings.btn_Switch.pos = QuickSubDSettings.btn_Toggle.pos+[65,0]
QuickSubDSettings.btn_DisplaySubD.pos = QuickSubDSettings.btn_Switch.pos+[65,0]


fn_LoadDDLItems()
fn_ReadSettings()
-- end buttons position	

--------------------------------------------------------------------------------------------------------------------------------------------
--End Main UI
--------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------	
		







