
macroScript QuickSubDToggle
buttonText:"Quick SubD"
category:"DmitryGScripts"
tooltip:"Quick SubD Toggle"
(
-- Don't rename/set modifier name "Quick_SubD_Preview" 
-- Script adds TurboSmooth modifier whith name - "Quick_SubD_Preview"  to entire object and on top
--"Quick_SubD_Preview" modifier not affect to object by changing its parameters manually in ModPanel, 
-- You also can change it(script) parameters in mod Panel, use "Quick_SubD_Preview" modifier as global settings of the script, reToggle script for adding modifier with changed parameters
-------------Vars-----------------
	global theFastTurboSmt -- turbosmooth modifier 
	global theSubDTogsCount -- SubD toggs counter
	global theSubDType -- type of subdivision modifier
-------------Vars-----------------

---------Garbage Collector Force---------
if theSubDTogsCount == undefined do 
 (theSubDTogsCount =0)
	if(theSubDTogsCount>999) do 
	(
		theSubDTogsCount=0 
		gc light:true delayed:false
	)
---------Garbage Collector Force---------

	if ($!=undefined)  do
	(	SetCommandPanelTaskMode #create
		for obj in $ do
		(
			if SuperClassOf obj == GeometryClass do
			(
				with redraw off
				(
					if obj.modifiers[#Quick_SubD_Preview]!=undefined then 
					(
						 undo off
						(deleteModifier obj obj.modifiers[#Quick_SubD_Preview])	
					)
					else
						(
							if theFastTurboSmt == undefined do
								(
									undo off
									(
										case  theSubDType of (
											0:(body) -- Turbo smooth
											1:(    ) -- Open Subdivision
											2:(    ) -- Mesh Smooth
											default:(body)
										)
									theFastTurboSmt = TurboSmooth()
									theFastTurboSmt. name = "Quick_SubD_Preview"
									theFastTurboSmt. iterations = 2 -- change iterations count if you want (optimal value in range 1-4)
									theFastTurboSmt. isolineDisplay = false -- change "isolate display" if you want (type false to disable this option or true to enable it)
									theFastTurboSmt. smoothResult = true
									theFastTurboSmt. update =1
									)
								)
								 undo off(addmodifier obj theFastTurboSmt)
						)	
					)
			 theSubDTogsCount+=1
			)
		)
		SetCommandPanelTaskMode #modify
		RedrawViews()
		
	)
)

