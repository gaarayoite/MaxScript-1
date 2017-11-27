struct QuickSubDPreview 
(
	-------------Members-----------------
private	SubDMod,-- Torbo Smooth modifier , OpenSubdivision, Mesh Smooth
private	TogsCount = 0 ,-- SubD toggs counter
private	ModSettings = #(), -- subdivision settings
private	ModPos =0,  -- position of last selected modifier
private ModNmae = "Quick_SubD_Preview", -- modifier name
private IniName = "QuickSubDConfig.ini", --name of *.ini configuration file
private ScriptPath = (symbolicPaths.getPathValue "$userScripts")+"\\DmitryG Tools\\QuickSubDPreview\\", -- Default Script Directory
private IniKeys = #("Iterations", "Enable Render Iterations","Render Iterations","Isolate Display","Stack Position","SubD Mod","Undo Off"), --keywords for *.ini "SubD Config"
private SubDVars =#(#("Top Stack","After Selection","Before Selection"),#("Turbo Smooth","OpenSubdiv","Mesh Smooth")), --SubD variants, 1- Mod StackPosition, 2 - SubD Mod
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
           undo off ( ModSettings = #(2, false, 3, false, SubDVars[1][1], SubDVars[2][1], true) )
			--1 - iteration count; 
			--2 - render iterations bool; 
			--3 - render iterations count;			
			--4 - isolate display;
			--5 stack position : Top Stack; After Selection; Before Selection
			--6 - SubD Type : Turbo Smooth; OpenSubdiv; Mesh Smooth
			--7 - Undo Off 
),
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Appling modifier paramiters
private function fn_ApplySubDParams =
(
undo off
( 
	if ModSettings[6] ==SubDVars[2][1] then
	(
		SubDMod = TurboSmooth()
		SubDMod. smoothResult = true
	)
	else
		(
			if ModSettings[6] == SubDVars[2][2] then
			(
				SubDMod = OpenSubdiv()
				SubDMod. smoothtriangles = true
			)
				else
						if ModSettings[6] = SubDVars[2][3] then
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
			(	if the_pos!=SubDVars[1][1] then 
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
					if the_pos!=SubDVars[1][1] then 
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
	if ModSettings[5] ==SubDVars[1][1] or selection.count>1  then
		(
			fn_AddMod obj ModSettings[5]	
		)
		else
			(
				if ModSettings[5] ==SubDVars[1][2]  then
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
				fn_AddMod obj SubDVars[2][3] 
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
	ModSettings[1] = SubDMod.Iterations
	ModSettings[2] = SubDMod.useRenderIterations
	ModSettings[3] = SubDMod.renderIterations
	ModSettings[4] = SubDMod.isolineDisplay

	return ModSettings
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Get directory of current file
public function fn_GetMSDir =
(
	local fullPath = getThisScriptFilename()
	local str = "\\"
	local inx = 1
	for i in (fullPath.count) to 1 by -1 do 
	(
		
		if fullPath[i] == str do 
		(
			ScriptPath = substring fullPath 1 i
			print (ScriptPath)
			exit
			
		)
	) 
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

public function fn_SetSubDSettings arr =
(
	ModSettings[1] = arr[1] as integer
	ModSettings[2] = arr[2] as BooleanClass
	ModSettings[3] = arr[3] as integer
	ModSettings[4] = arr[4] as BooleanClass
	ModSettings[5] = arr[5] as string
	ModSettings[6] = arr[6] as string
	ModSettings[7] = arr[7] as BooleanClass

	fn_ApplySubDParams()
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Writing config file
public function fn_WriteConfig =
(
	local IniPath =ScriptPath+ IniName

		for i=1 to IniKeys.count do
		(
			setINISetting IniPath "SubD Config" IniKeys[i] (ModSettings[i] as string)
		)

),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Loading ini file
private function fn_ReadConfig =
(
    local msg = "=>Config file: "--message base for user
    local IniPath =ScriptPath+ IniName

    if doesFileExist (IniPath) ==true then 
(
	local str ="0" -- current string value of ini setting
    local flag = false -- invalid ini setting
    
	for i = 1 to Inikeys.count do 
		(
            if (hasINISetting IniPath "SubD Config" IniKeys[i]) == true and flag==false  then
			(
                str = getINISetting IniPath "SubD Config" IniKeys[i]
            )
          else 
 --exit cycle, invalid *.ini config
            (exit)
      
			if i==1 do
			(
				str = str as integer
				if str>-1 and str<9 then 
					(ModSettings[i] = str) else (flag = true)
            )

            if i==2 do
                (
                    if str=="true" or str=="false" then 
                        ( ModSettings[i] = str as BooleanClass) else (flag = true)
                )

                if i==3 do
                    (
                        str = str as integer
                        if str>-1 and str<11 then 
                            (ModSettings[i] = str) else (flag = true)
                    )

                    if i==4 do
                        (
                            if str=="true" or str=="false" then 
                                ( ModSettings[i] = str as BooleanClass) else (flag = true)
                        )

                        if i==5 do
                            (
                                str = str as string
                                if str == SubDVars[1][1] or str == SubDVars[1][2] or str ==SubDVars[1][3] then 
                                    (ModSettings[i] = str) else (flag = true)
                            )

                            if i==6 do
                                (
                                    str = str as string

                                    if str == SubDVars[2][1] or str == SubDVars[2][2] or str == SubDVars[2][3] then 
                                        (
                                            local ver = (maxVersion())[1]/1000

                                            if ver<18 and str == SubDVars[2][2] then (flag =true)
                                            else (ModSettings[i] = str)
                                        ) 
                                        else (flag = true)
                                )

                                if i==7 do
                                    (
                                        if str=="true" or str=="false" then 
                                            ( ModSettings[i] = str as BooleanClass) else (flag = true)
                                    )

        )
 --loop end
        
        if flag == true then 
            (
 --removing config  file and  writing it whith default settings
                deleteFile IniPath
                fn_WriteConfig()
                msg+="has been reset, invalid *.ini settings"
            )
            else (msg+="has been loaded and applied successfully")
)
else(msg+="not detected, applied default settings")

--info for user
print (msg)
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Main working function
public function fn_ToggSubD =
(
---------Garbage Collector Force---------
	if(TogsCount>512) do 
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

-- Set params by default
fn_SetDefaultSetting()

--Check and read *.ini file 
fn_ReadConfig()

--Appling SubD Params
fn_ApplySubDParams()
print("QuickSubDPreview is Ready!")
)
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------Funcs-----------------
)
--end Struct
