macroScript FastCap
buttonText: "FastCap"
category:"DmitryG Tools"
tooltip:"Fast Cap"
silentErrors: true
(
    local currMod = modPanel.getCurrentObject()
    
    if ((ClassOf currMod == Editable_Poly or  ClassOf currMod == Edit_Poly) and subobjectLevel != 0) do
    (
        currMod.ConvertSelection #CurrentLevel #Border
		if classOF currMod == Editable_Poly then 
		(
			currMod.capHoles #Edge
		)
		else
			(
				currMod.ButtonOp #Cap
			)
    )

) -- end script
