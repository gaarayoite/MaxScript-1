struct QuickSubDPreview 
(
	-------------Members-----------------
private	SubDMod,-- turbosmooth modifier , open SubD, Mesh smooth
private	TogsCount ,-- SubD toggs counter
public	ModSettings, -- subdivision settings
private	ModPos,  -- position of the last selected modifier
private ModNmae = "Quick_SubD_Preview",
    -------------Members-----------------
	
-------------Funcs-----------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------
private function fn_GetModLastPos  = 
(
	if selection.count !=1 then
	(
		 ModPos =0
	)
	else
		(
			 local obj =$
			 SetCommandPanelTaskMode #modify
			 local currMod =  modPanel.getCurrentObject()
			
			if superclassof currMod == modifier and superclassof obj == GeometryClass and currMod.name != "Quick_SubD_Preview" then
				(ModPos = modPanel.getModifierIndex  obj currMod)
				
			else
				(ModPos=0)
			)
),
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

private function fn_SetDefaultSetting =
(
            ModSettings = #("Quick_SubD_Preview", 2, false, 2, false, 0, 0, true) 
			-- 1 - modifier name; !!! dont change the name
			--2- iteration count; 
			--3 - render iterations bool; 
			--4 - render iterations count;			
			--5 - isolate display;
			--6 stack position : stack position 0 - on top; 1 - After selected modifier; 2  - before selected modifier
			--7 - SubD Type : 0 - Turbo smooth ; 1: OpenSubD; 2:Mesh Smooth
			-- 8 - Undo Off 
),
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------
public function fn_ApplySubDParams =
(
	if ModSettings[7] ==0 then
	(
		SubDMod = TurboSmooth()
		SubDMod. smoothResult = true
	)
	else
		(
			if ModSettings[7] == 1 then
			(
				SubDMod = OpenSubdiv()
				SubDMod. smoothtriangles = true
			)
				else
						if ModSettings[7] = 2 then
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
		SubDMod. name = ModSettings[1] as string
	    SubDMod. iterations = ModSettings[2]  as integer
		SubDMod. useRenderIterations = ModSettings[3] as booleanClass
		SubDMod. renderIterations = ModSettings[4] as integer
		SubDMod. isolineDisplay = ModSettings[5]  as booleanClass
		SubDMod. update =1

),
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

private function fn_PositionModOnStack obj  = 
(
	if ModSettings[6] ==0 or selection.count>1  then
		(
			addmodifier obj SubDMod
		)
		else
			(
				if ModSettings[6] ==1  then
					(
						ModPos+=1
						addmodifier obj SubDMod before:ModPos
					)
					
						else
							(
								if ModSettings[6] == 2 then
								(
									addmodifier obj SubDMod before:ModPos		
								)
								else
									(
										addmodifier obj SubDMod
									)
							)
			)
),
--end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

public function fn_RestoreSettings =
(
    fn_SetDefaultSetting() 
    fn_ApplySubDParams()
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

public function fn_Update the_upd the_sel =
(   --bool the_sel: true - selection, false- all
    --bool the_upd: true - update modifiers false - remove modifiers
    local  sel= the_sel as BooleanClass
	local upd = the_upd as BooleanClass
	local objs =#()
	
fn_ApplySubDParams()
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

SetCommandPanelTaskMode #modify 	

	for obj in objs do 
	(
		if obj.modifiers[#Quick_SubD_Preview]!=undefined do 
		(
			local mpos = modPanel.getModifierIndex obj obj.modifiers[#Quick_SubD_Preview]

			if ModSettings[8] = true then
				( 
					undo off (deleteModifier obj obj.modifiers[#Quick_SubD_Preview])	
				)
					else
						(
							undo on (deleteModifier obj obj.modifiers[#Quick_SubD_Preview])	
						)

			if upd ==true do 
			(
				if ModSettings[8] = true then
					( 
						undo off (addModifier obj SubDMod before:mpos)	
					)
						else
							(
								undo on (addModifier obj SubDMod before:mpos)	
							)
			)
		)
	)	
      
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

public function fn_GetUIData arr  =
(
	--cheking max version if more then 10 OpenSubDiv modifier is available, 18 version is 3ds max 2016
	local ver = getFileVersion "$max/3dsmax.exe" 
	ver = substring ver 1 2
	ver as integer

	if ver[1]>17 then 
	(
		arr = #(#("Top Stack","After Selection","Before Selection"),#("Turbo Smooth","OpenSubdiv","Mesh Smooth"))
	)
		else
			(
				arr= #(#("Top Stack","After Selection","Before Selection"),#("Turbo Smooth","Mesh Smooth"))
			)
),
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------

public function fn_ToggSubD =
(
---------Garbage Collector Force---------
if TogsCount == undefined do 
 (TogsCount =0)
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
		
			if SubDMod == undefined do
			(
				undo off
							(
								if ModSettings == undefined  do fn_SetDefaultSetting()
								fn_ApplySubDParams()
							)
			)
--------SetUp QuickSubDModifier-------
			
								
		for obj in $ do
		(
			if SuperClassOf obj == GeometryClass do
			(
				with redraw off
				(
					if obj.modifiers[#Quick_SubD_Preview]!=undefined then 
					(
						
						if ModSettings[8] = true then
							( 
								undo off (deleteModifier obj obj.modifiers[#Quick_SubD_Preview])	
							)
								else
									(
										undo on (deleteModifier obj obj.modifiers[#Quick_SubD_Preview])	
									)
					)
					else
						(
							if ModSettings[8] = true then
							( 
								undo off (fn_PositionModOnStack (obj))
							)
								else
									(
										undo on (fn_PositionModOnStack (obj))
									)
						)	
				)
                TogsCount+=1
			)
		)
		
		SetCommandPanelTaskMode #modify
		RedrawViews()
	)
)
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------Funcs-----------------
)
--end Struct