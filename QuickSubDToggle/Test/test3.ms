struct QuickSubDPreview 
(
	-------------Members-----------------
private	SubDMod,-- Torbo Smooth modifier , OpenSubdivision, Mesh Smooth
private	TogsCount = 0 ,-- SubD toggs counter
private	ModSettings = #(), -- subdivision settings
private	ModPos =0,  -- position of the last selected modifier
private ModNmae = "Quick_SubD_Preview", -- modifier name
private IniName = "QuickSubDConfig.ini", --name of *.ini configuration file
private ScriptPath = (symbolicPaths.getPathValue "$userScripts")+"\\DmitryG Tools\\QuickSubDPreview\\", -- Script Directory
private IniKeys = #("Iterations", "Enable Render Iterations","Render Iterations","Isolate Display","Stack Position","SubD Mod","Undo Off"),
    -------------Members-----------------
	
-------------Funcs-----------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Get last position in stack of selected modifier
private function fn_GetModLastPos  = 
(
undo off 
(
	ModPos =0
	if selection.count ==1  do
	(
	local obj =$
	SetCommandPanelTaskMode #modify
	local currMod =  modPanel.getCurrentObject()
			
		if superclassof currMod == modifier and superclassof obj == GeometryClass  do
		(ModPos = modPanel.getModifierIndex  obj currMod)		
	)
	print(ModPos)
)
),
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Default modifier paramiters 
private function fn_SetDefaultSetting =
(
           undo off ( ModSettings = #(2, false, 2, false, 0, 0, true) )
			--1 - iteration count; 
			--2 - render iterations bool; 
			--3 - render iterations count;			
			--4 - isolate display;
			--5 stack position : stack position 0 - on top; 1 - After selected modifier; 2  - before selected modifier
			--6 - SubD Type : 0 - Turbo smooth ; 1: OpenSubD; 2:Mesh Smooth
			--7 - Undo Off 
),
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Appling modifier paramiters
private function fn_ApplySubDParams =
(
undo off
( 
	if ModSettings[6] ==0 then
	(
		SubDMod = TurboSmooth()
		SubDMod. smoothResult = true
	)
	else
		(
			if ModSettings[6] == 1 then
			(
				SubDMod = OpenSubdiv()
				SubDMod. smoothtriangles = true
			)
				else
						if ModSettings[6] = 2 then
						(
							SubDMod = MeshSmooth()
							SubDMod. smoothResult = true
						)
						else
						(
							fn_SetDefaultSetting()
							fn_ApplySubDParams()
						)
		)
		
		--- applying paramiters
		SubDMod. name = ModNmae
	    SubDMod. iterations = ModSettings[1]  
		SubDMod. useRenderIterations = ModSettings[2] 
		SubDMod. renderIterations = ModSettings[3] 
		SubDMod. isolineDisplay = ModSettings[4]  
        SubDMod. update =1
        SubDMod.enabled = true
)
),
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Add modifier to object
private function fn_AddMod obj the_pos= 
(
	if ModSettings[7] = true then
		( 
			undo off 
			(	if the_pos!=0 then 
				(
					addmodifier obj SubDMod before:ModPos	
				)
				else(addmodifier obj SubDMod)	
			)
		)
		else
			(
				undo on 
				(
					if the_pos!=0 then 
						(
							addmodifier obj SubDMod before:ModPos	
						)
						else(addmodifier obj SubDMod)
				)
			)
),
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Position modifier in stack
private function fn_PositionModInStack obj  = 
(
	if ModSettings[5] ==0 or selection.count>1  then
		(
			fn_AddMod obj ModSettings[5]	
		)
		else
			(
				if ModSettings[5] ==1  then
					(
						ModPos-=1
						-- if ModPos= -1 means selected  not modifier in the stack
						if ModPos ==-1 do (ModPos = obj.modifiers.count+1)
						fn_AddMod obj ModSettings[5]
					)	
					else (fn_AddMod obj ModSettings[5])						
			)
		
),
--end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Restore paramiters to default
public function fn_RestoreSettings =
(
    fn_SetDefaultSetting() 
    fn_ApplySubDParams()
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete modifier 
private function fn_DeleteSubD obj =
(
	if ModSettings[7] = true then
		( 
			undo off (deleteModifier obj obj.modifiers[#Quick_SubD_Preview])	
		)
			else
				(
					undo on (deleteModifier obj obj.modifiers[#Quick_SubD_Preview])	
				)
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Update or remove SubD modifiers
public function fn_UpdateSubD the_upd the_sel =
(   --bool the_upd: true - update modifiers false - remove modifiers
	--bool the_sel: true - selected objects, false- all
    local sel= the_sel  as BooleanClass
	local upd = the_upd as BooleanClass
	local objs =#()
	
SetCommandPanelTaskMode #create

    if sel == true then 
    (
        if $ != undefined do    
        (
			objs = for obj in $ where(superClassOf obj == GeometryClass) collect obj
        )
    )
    else 
        (
			objs = for obj in $* where(superClassOf obj == GeometryClass) collect obj
		)


	for obj in objs do 
	(
		if obj.modifiers[#Quick_SubD_Preview]!=undefined do 
		(
			ModPos = modPanel.getModifierIndex obj obj.modifiers[#Quick_SubD_Preview] 
			ModPos-=1

--remove old modifier
			fn_DeleteSubD obj

--add new updated modifier
			if upd ==true do 
			(
-- 2- add modifier before ModPos index 
				fn_AddMod obj 2 
           		SetCommandPanelTaskMode #modify 
			)
		)
	)	
   
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Get array of values  to fill UI items
public function fn_GetUIData =
(
undo off 
(
	--cheking max version if it more then 17, OpenSubDiv modifier is available, 18 version is 3ds max 2016
	local ver = (maxVersion())[1]/1000 
	
	local arr= #(#("Top Stack","After Selection","Before Selection"),#("Turbo Smooth","Mesh Smooth"))

	if ver[1]>17 do 
	(
		arr = #(#("Top Stack","After Selection","Before Selection"),#("Turbo Smooth","OpenSubdiv","Mesh Smooth"))
	)

--return valid array			
return arr
)
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Get modifier settings as array
public function fn_GetSubDSettings =
(
	ModSettings[1] = SubDMod.iterations 
	ModSettings[2] = SubDMod.useRenderIterations 
	ModSettings[3] = SubDMod.renderIterations 
	ModSettings[4] = SubDMod.isolineDisplay 
	return ModSettings
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

public function fn_SetSubDSettings arr =
(
	ModSettings[1] = arr[1] as integer
	ModSettings[2] = arr[2] as BooleanClass
	ModSettings[3] = arr[3] as integer
	ModSettings[4] = arr[1] as BooleanClass

--Stack position by default 0
	ModSettings[5] = 0

if arr[5]=="After Selection" then (ModSettings[5]==1)
else (if arr[5]=="Before Selection" do (ModSettings[5]==2))

--Set SubDType by default 0
	ModSettings[6] = 0

if arr[6]=="OpenSubdiv" then (ModSettings[6]==1)
else (if arr[6]=="Mesh Smooth" do (ModSettings[6]==2))

	ModSettings[7] = arr[7] as integer

	fn_ApplySubDParams()
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Cheking Scriptdirectory/config
private function fn_CheckDir path= 
(
	return doesFileExist path
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Writing config file
public function fn_WriteConfig =
(
	local Inipath =ScriptPath+ IniName

		for i=1 to IniKeys.count do
		(
			setINISetting Inipath "SubD Config" IniKeys[i] (ModSettings[i] as string)
		)

),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Main working function
public function fn_ToggSubD =
(
---------Garbage Collector Force---------
	if(TogsCount>999) do 
	(
		TogsCount=0 
		gc light:true delayed:false
	)
---------Garbage Collector Force---------

--------SetUp QuickSubDModifier-------
	if ($!=undefined)  do
	(
		fn_GetModLastPos()
		SetCommandPanelTaskMode #create	
								
		for obj in $ do
		(
			if SuperClassOf obj == GeometryClass do
			(
				with redraw off
				(
					if obj.modifiers[#Quick_SubD_Preview]!=undefined then 
					(
						fn_DeleteSubD obj
					)
					else
						(
							fn_PositionModInStack obj
						)	
				)
                TogsCount+=1
			)
		)
		
		SetCommandPanelTaskMode #modify
		RedrawViews()
	)
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

---Init
on create do 
(
--Check ini file exsisting

fn_SetDefaultSetting()
fn_ApplySubDParams()
print("Hello")
)
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------Funcs-----------------
)
--end Struct
