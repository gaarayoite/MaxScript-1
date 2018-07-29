macroScript ToggleHardEdgesDisplay
buttonText: "Display HE"
category:"DmitryG Tools"
tooltip:"Toggle Hard Edge Display"
icon:#("DmitryGTools_icons",3)
silentErrors: true
(
	local currMod = modPanel.getCurrentObject()

	if ClassOf currMod == Editable_Poly or ClassOf currMod == Edit_Poly then 
	(
		if currMod.hardedgedisplay == 1 then 
		(
			currMod.hardedgedisplay = 0
		)
		
		else (currMod.hardedgedisplay = 1)
	)	
)
	
	
	