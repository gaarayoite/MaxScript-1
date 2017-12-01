macroScript Display_Hard_Edges
buttonText: "Display HE"
category:"DmitryG Tools"
tooltip:"Toggle Hard Edge Display"
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
	
	
	