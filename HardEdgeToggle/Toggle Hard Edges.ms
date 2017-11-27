macroScript Display_Hard_Edges
buttonText: "Display HE"
category:"DmitryGScripts"
tooltip:"Display Hard Edges"
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
	
	
	