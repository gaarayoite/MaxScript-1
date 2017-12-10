macroScript MultyBevelDialog
buttonText: "MultyBevel"
category:"DmitryG Tools"
tooltip:"MultyBevel Dialog"
icon:#("DmitryGTools_icons",7)
silentErrors: true
(
    if GetCommandPanelTaskMode() == #modify do 
    (
        currMod = modPanel.getCurrentObject()

        if ClassOf currMod  == Editable_Poly or ClassOf currMod == Edit_Poly do 
        (
        if subObjectLevel != 0 do 
            (
                if subObjectLevel == 1 or subObjectLevel == 2  or subObjectLevel == 3 then 
                (
                    if ClassOf currMod  == Editable_Poly then (currMod.PopupDialog #Extrude)
                    else 
                        (
                            case subObjectLevel of
                            (
                                1:(currMod.PopupDialog  #ExtrudeVertex)
                                2:(currMod.PopupDialog  #ExtrudeEdge)
                                3:(currMod.PopupDialog  #ExtrudeEdge)
                            )
                        )
                )
                else 
                    (
                        currMod.PopupDialog #Bevel
                    )
            )
        ) 
    )
)

    