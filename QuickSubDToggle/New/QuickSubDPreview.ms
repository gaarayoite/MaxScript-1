--By Dmitry Gubkin
--Module version - 1.0.1
--Main Script - Struct QuickSubDPreview
--for 3ds 2016 and higher
--------------------------------------------------------------------------------------------------------------------------------------------------------------
global The_QSubDTogg -- var for struct instance
--------------------------------------------------------------------------------------------------------------------------------------------------------------
struct QuickSubDPreview 
(
	-------------Members-----------------
private	SubDMod,-- Torbo Smooth modifier , OpenSubdivision, Mesh Smooth
private	TogsCount = 0 ,-- SubD toggs counter
private	ModSettings = #(), -- subdivision settings
private	ModPos =0,  -- position of last selected modifier
private GlobalModName = "Global_QSubD_Preview", -- global modifier name
private FixedModName = "Fixed_QSubD_Preview", -- fixed modifier name
private IniName = "QuickSubDConfig.ini", --name of *.ini configuration file
private ScriptPath = (symbolicPaths.getPathValue "$userScripts")+"\\DmitryG Tools\\QuickSubDPreview\\", -- Default Script Directory
private IniKeys = #("Iterations", "Enable Render Iterations","Render Iterations","Isolate Display","Stack Position","SubD Mod","Undo Off", "Skip By Poly Count","Poly Count","Make Fixet Firs","Enable Fixed Itr.","Fixed Itr."), --keywords for *.ini "SubD Config"
private SubDVars =#(#("Top Stack","After Selection","Before Selection"),#("Turbo Smooth","Mesh Smooth","OpenSubdiv")), --SubD variants, 1- Mod StackPosition, 2 - SubD Mod
private AvailableMods = #("Turbo Smooth","Mesh Smooth"), -- default availabale subD methods, needs to quick accsess via mod switch
private SubDModsArr = #(TurboSmooth(),Meshsmooth(),OpenSubdiv()), -- default modifier for with global control feature
    -------------Members-----------------
	
-------------Funcs-----------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Get last position in stack of selected modifier (only geometry objects!!!)
private function fn_GetModLastPos objs  = 
(
with undo off 
(
	ModPos =0

if objs.count !=0 do 
(	
	SetCommandPanelTaskMode #modify
	local currMod =  modPanel.getCurrentObject()

		if superclassof currMod == modifier and currMod != SubDMod  do
		(ModPos = modPanel.getModifierIndex  objs[1] currMod)		
	
	SetCommandPanelTaskMode #create
)		
	print(ModPos)
)
),
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Default modifier paramiters 
private function fn_SetDefaultSetting =
(
           with undo off ( ModSettings = #(2, false, 3, false, SubDVars[1][1], SubDVars[2][1], true, false,1000,true,true,#(5,2,3)) )
			--1 - iteration count; 
			--2 - render iterations bool; 
			--3 - render iterations count;			
			--4 - isolate display;
			--5 stack position : Top Stack; After Selection; Before Selection
			--6 - SubD Type : Turbo Smooth; Mesh Smooth; OpenSubdiv
			--7 - Undo Off 
			--8 - Skip by poly count bool
			--9 - Skip by poly count Integer, in thousands by default 1000K polygons
			--10 - Make fixed firs
			--11 - Enable fixed iterations per subd mod
			--12 - fixed iterations values
),
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Appling modifier paramiters
private function fn_ApplySubDParams subDFixed =
(
set undo off

	local subDLevel = ModSettings[1]

	if ModSettings[6] ==SubDVars[2][1] then
	(
		if subDFixed == true then 
			(
				SubDMod = TurboSmooth()
				subDLevel = ModSettings[12][1]
			)
			else (SubDMod = SubDModsArr[1])
		SubDMod. smoothResult = true
	)
	else
		(
			if ModSettings[6] == SubDVars[2][2] then
			(
				if subDFixed == true then 
					(
						SubDMod = TurboSmooth()
						subDLevel = ModSettings[12][2]
					)
					else (SubDMod = SubDModsArr[2])
				SubDMod. smoothResult = true
				
			)
				else
						if ModSettings[6] == SubDVars[2][3] then
						(
							if subDFixed == true then 
								(
									SubDMod = TurboSmooth()
									subDLevel = ModSettings[12][3]
								)
								else (SubDMod = SubDModsArr[3])
							SubDMod. smoothtriangles = true
						)
						else
						(
							fn_SetDefaultSetting()
							fn_ApplySubDParams false
						)
		)
		
		--- applying paramiters
		if subDFixed == true then 
		(SubDMod. name = FixedModName) 
			else (SubDMod. name = GlobalModName)

	    SubDMod. iterations = subDLevel 
		SubDMod. useRenderIterations = ModSettings[2] 
		SubDMod. renderIterations = ModSettings[3] 
		SubDMod. isolineDisplay = ModSettings[4]  

		if classof SubDMod == meshsmooth then (SubDMod. update =0)
			else (SubDMod. update =1)

		SubDMod.enabled = true
		
set undo on
),
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--helper, ads modifer with undo off check
private function fn_AddMod obj the_pos =
(
	set undo off
	if ModSettings[7] == false then
		(
			set undo on
		)
			if the_pos!=SubDVars[1][1] then 
			(
				addmodifier obj SubDMod before:ModPos	
			)
			else(addmodifier obj SubDMod)	
			
),
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Push modifier in object stack with poly check
private function fn_PushMod obj the_pos= 
(
if modSettings[8] == false then
(
	fn_AddMod obj the_pos
)
 else 
	(
		if obj.numFaces< ModSettings[9] do 
		(
			fn_AddMod obj the_pos
		)
	)
),
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Position modifier in stack
private function fn_PositionModInStack obj  = 
(
	if ModSettings[5] == SubDVars[1][1] then
		(
			fn_PushMod obj ModSettings[5]	
		)
		else
			(
				if ModSettings[5] == SubDVars[1][2]  then
					(
						ModPos-=1
						-- if ModPos = -1 means selected  not modifier in the stack
						if ModPos ==-1 do (ModPos = obj.modifiers.count+1)
						fn_PushMod obj ModSettings[5]
					)	
					else (fn_PushMod obj ModSettings[5])						
			)
		
),
--end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Restore paramiters to default
public function fn_RestoreSettings =
(
    fn_SetDefaultSetting() 
    fn_ApplySubDParams false
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete modifier 
private function fn_DeleteSubD obj =
(
	set undo off
	if ModSettings[7] = false do
		( 
			set undo on
		)

		if obj.modifiers[#Global_QSubD_Preview]!=undefined then 
		(deleteModifier obj obj.modifiers[#Global_QSubD_Preview])
			else (deleteModifier obj obj.modifiers[#Fixed_QSubD_Preview])
						
				
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Update or remove SubD modifiers
public function fn_UpdateSubD upd sel itrfix=
(   
--bool the_upd: 0 - remove modifiers; 1 - update modifiers; 2 - add modifers; 3 - update and add
--bool the_sel: true - selected objects; false- all

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
with redraw off
(
--Get last modifier position of Geometry objects
	fn_GetModLastPos objs
	local currMod = SubDMod
	for obj in objs do 
	(
		if obj.modifiers[#Global_QSubD_Preview]!=undefined then 
		(
			ModPos = modPanel.getModifierIndex obj obj.modifiers[#Global_QSubD_Preview] 
			ModPos-=1
--Make modifier iterations fixed
			if itrfix == true do 
			(
				for i=1 to SubDVars[2].count by 1 do 
				(
					if obj.modifiers[#Global_QSubD_Preview] == SubDModsArr[i] do 
					(
						ModSettings[6] = SubDVars[2][i]
						fn_ApplySubDParams true
					)
				)	
				
			)
--remove old modifier
			fn_DeleteSubD obj

--add new updated modifier
			if upd == 1 or upd ==3 do 
			(
-- [1][3] add modifier before ModPos index 
				fn_PushMod obj SubDVars[1][3] 	
			)

-- reset modifier position to default value
		ModPos = 0 

		)
		else 
			(
--add SubD modifier to object wich not used it before
				if upd == 2 or upd == 3  do 
				(
					fn_PositionModInStack obj
				)
			)
	)
)--redraw off end

if itrfix == true do 
(
	SubDMod = currMod
)
	SetCommandPanelTaskMode #modify 
	redrawViews()
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Switch between subD mods
public function fn_SwitchSubD =
(
	local inx = 1 -- index by default
	local flag = true 

local currMod = SubDMod
if $!= undefined do 
(
	objs = for obj in $ where (superClassOf obj == GeometryClass) collect obj
)

	SubDMod = currMod
/*
	for i=1 to AvailableMods.count by 1 do 
		(
			if AvailableMods[i] == ModSettings[6] and flag == true do 
				(
					if (i+1)<=AvailableMods.count then 
					(
						ModSettings[6] = AvailableMods[i+1] 
						inx = i+1
						flag = false
					)
					else(
							ModSettings[6] = AvailableMods[1]
							inx = 1
							flag = false
						)
				)
		)
		SubDMod = SubDModsArr[inx]
		fn_UpdateSubD 1 true
*/		
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--select objects which have subD mod
public function fn_SelectSubDObjects =
(
	clearSelection()
	local objs = #()
	objs = for obj in $* where(superClassOf obj == GeometryClass) collect obj

with redraw off
(
	for obj in objs do 
	(
		if obj.modifiers[#Global_QSubD_Preview] != undefined or obj.modifiers[#Fixed_QSubD_Preview] != undefined do 
		(selectMore obj)
	)
)
redrawViews()	
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--Get array of values  to fill UI items
public function fn_GetUIData =
(
--valid array for ui elements: 1 - stack position ops, 2 - subD methods
return SubDVars

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
	ModSettings[8] = arr[8] as BooleanClass
	ModSettings[9] = arr[9] as integer
	ModSettings[10] = arr[10] as BooleanClass
	ModSettings[11] = arr[11] as BooleanClass
	ModSettings[12] = arr[12] as Array
	fn_ApplySubDParams false
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
          else  (exit) --exit cycle, invalid *.ini config
 
			if i==1 do 
			(
				str = str as integer
				if str>-1 and str<9 then 
					(ModSettings[i] = str) else (flag = true)
            )

            if i==2 do 
                (
                    if str =="true" or str =="false" then 
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
                            if str =="true" or str =="false" then 
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
                                            ModSettings[i] = str
                                        ) 
                                        else (flag = true)
                                )

                                if i==7 do
                                    (
                                        if str =="true" or str =="false" then 
                                            ( ModSettings[i] = str as BooleanClass) else (flag = true)
									)

									if i==8 do
										(
											if str =="true" or str =="false" then 
												( ModSettings[i] = str as BooleanClass) else (flag = true)
										)

										if i==9 do
											(
												str = str as integer

												if str>-1 and str<100000 then 
													( ModSettings[i] = str) else (flag = true)
											)

											if i==10 do
												(
													if str =="true" or str =="false" then 
														( ModSettings[i] = str as BooleanClass) else (flag = true)
												)

												if i==11 do
													(
														if str =="true" or str =="false" then 
															( ModSettings[i] = str as BooleanClass) else (flag = true)
													)

													if i==12 do
														(
															str = execute(str)
															if str.count>-1 and str.count<4 then
															(
																for j=1 to str.count by 1 do 
																(
																	if ClassOf str[j] != integer or str[j]<0 or str[j]>8 do
																	(
																		 flag = true 
																		 exit
																	)	
																)

																ModSettings[i] = str as Array
															) else (flag = true)				 
														)
									
        ) --end Loop

        
        if flag == true then 
            (
 --removing config  file and  writing it with default settings
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
--Collect GeometryClass objects
local objs = for obj in $ where(superClassOf obj == GeometryClass) collect obj

with redraw off
(
--Get last modifier position of Geometry objects
	fn_GetModLastPos objs 
		
		for obj in objs do
		(
				
					if obj.modifiers[#Global_QSubD_Preview]!=undefined or obj.modifiers[#Fixed_QSubD_Preview]!=undefined then 
					(
						fn_DeleteSubD obj
					)
					else
						(	
							fn_PositionModInStack obj
						)	
				
                TogsCount+=1
		)
		
)--redraw off end

		SetCommandPanelTaskMode #modify
		RedrawViews()
	)
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

---Constructor
on create do 
(

-- Set params by default
fn_SetDefaultSetting()
--initialize global modifiers by default
for i=1 to SubDVars[2].count by 1 do 
(
	ModSettings[6] = SubDVars[2][i]
	fn_ApplySubDParams false
)

fn_SetDefaultSetting()
--Check and read *.ini file 
fn_ReadConfig()

--Appling SubD Params
fn_ApplySubDParams false
print("QuickSubDPreview is Ready!")
)
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------Funcs-----------------
)
--end Struct
--------------------------------------------------------------------------------------------------------------------------------------------------------------
The_QSubDTogg = QuickSubDPreview() -- make instance
