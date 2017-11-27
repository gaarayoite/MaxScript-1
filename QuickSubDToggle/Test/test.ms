-------------Vars-----------------
	global theFastSubDMod-- turbosmooth modifier , open SubD, Mesh smooth
	global theSubDTogsCount -- SubD toggs counter
	global theFastSubDModSettings -- subdivision settings
	global theModPos  -- position of the last selected modifier
-------------Vars-----------------

-------------Funcs-----------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------
function fn_GetModLastPos  = 
(
	if selection.count !=1 then
	(
		local theModPos =0
	)
	else
		(
			 local obj =$
			 SetCommandPanelTaskMode #modify
			 local currMod =  modPanel.getCurrentObject()
			
			if superclassof currMod == modifier and superclassof obj == GeometryClass and currMod.name != "Quick_SubD_Preview" then
				(theModPos = modPanel.getModifierIndex  obj currMod)
				
			else
				(theModPos=0)
			)
)
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

function fn_SetDefaultSetting =
(
			theFastSubDModSettings = #("Quick_SubD_Preview", 2, false, 2, false, 0, 0, true) 
			-- 1 - modifier name; !!! dont change the name
			--2- iteration count; 
			--3 - render iterations bool; 
			--4 - render iterations count;			
			--5 - isolate display;
			--6 stack position : stack position 0 - on top; 1 - After selected modifier; 2  - before selected modifier
			-- 7 - SubD Type : 0 - Turbo smooth ; 1: OpenSubD; 2:Mesh Smooth
			-- 8 - Undo Off 
)
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

function fn_ApplySubDParams =
(
	if theFastSubDModSettings[7] ==0 then
	(
		theFastSubDMod = TurboSmooth()
		theFastSubDMod. smoothResult = true
	)
	else
		(
			if theFastSubDModSettings[7] == 1 then
			(
				theFastSubDMod = OpenSubdiv()
				theFastSubDMod. smoothtriangles = true
			)
				else
						if theFastSubDModSettings[7] = 2 then
						(
							theFastSubDMod = MeshSmooth()
							theFastSubDMod. smoothResult = true
						)
						else
						(
							fn_SetDefaultSetting()
							fn_ApplySubDParams()
						)
		)
		
		--- applying paramiters
		theFastSubDMod. name = theFastSubDModSettings[1] as string
	    theFastSubDMod. iterations = theFastSubDModSettings[2]  as integer
		theFastSubDMod. useRenderIterations = theFastSubDModSettings[3] as booleanClass
		theFastSubDMod. renderIterations = theFastSubDModSettings[4] as integer
		theFastSubDMod. isolineDisplay = theFastSubDModSettings[5]  as booleanClass
		theFastSubDMod. update =1

)
-- end func
--------------------------------------------------------------------------------------------------------------------------------------------------------------

function fn_PositionModOnStack obj  = 
(
	if theFastSubDModSettings[6] ==0 or selection.count>1  then
		(
			addmodifier obj theFastSubDMod
		)
		else
			(
				if theFastSubDModSettings[6] ==1  then
					(
						theModPos+=1
						addmodifier obj theFastSubDMod before:theModPos
					)
					
						else
							(
								if theFastSubDModSettings[6] == 2 then
								(
									addmodifier obj theFastSubDMod before:theModPos		
								)
								else
									(
										addmodifier obj theFastSubDMod
									)
							)
			)
)
--end func


function fn_ToggSubD =
(
---------Garbage Collector Force---------
if theSubDTogsCount == undefined do 
 (theSubDTogsCount =0)
	if(theSubDTogsCount>999) do 
	(
		theSubDTogsCount=0 
		gc light:true delayed:false
	)
---------Garbage Collector Force---------

--------SetUp QuickSubDModifier-------
	if ($!=undefined)  do
	(
		fn_GetModLastPos()
		SetCommandPanelTaskMode #create
		
			if theFastSubDMod == undefined do
			(
				undo off
							(
								if theFastSubDModSettings == undefined  do fn_SetDefaultSetting()
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
						
						if theFastSubDModSettings[8] = true then
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
							if theFastSubDModSettings[8] = true then
							( 
								undo off (fn_PositionModOnStack (obj))
							)
								else
									(
										undo on (fn_PositionModOnStack (obj))
									)
						)	
				)
			 theSubDTogsCount+=1
			)
		)
		
		SetCommandPanelTaskMode #modify
		RedrawViews()
	)
)
--end func	
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------Funcs-----------------
fn_ToggSubD()