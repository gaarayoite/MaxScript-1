macroScript ToggleHardEdgesDisplay
buttonText: "Display HE"
category:"DmitryG Tools"
tooltip:"Toggle Hard Edge Display"
icon:#("DmitryGTools_icons",3)
silentErrors: true
(
	if ClassOf $ == Editable_Poly do 
	(
		if $.hardedgedisplay == 1 then 
		(
			$.hardedgedisplay = 0
		)
		else ($.hardedgedisplay = 1)
	)	
)
	
	
	