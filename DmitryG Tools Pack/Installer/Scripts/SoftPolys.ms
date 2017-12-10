macroScript SoftPolys
buttonText: "Soft Polys"
category:"DmitryG Tools"
tooltip:"Make Selected Polys Soft"
icon:#("DmitryGTools_icons",9)
silentErrors: true
(
currMod = modPanel.getCurrentObject()
if ClassOf currMod == Editable_Poly or ClassOf currMod == Edit_Poly  do 
(
    if subObjectLevel == 4 or subObjectLevel == 5 do 
    (
        local currAngle = currMod.autoSmoothThreshold 
        currMod.autoSmoothThreshold = 180

        if  ClassOf currMod == Editable_Poly then 
        (
            currMod.autosmooth()
        )
        else 
            (
                currMod.ButtonOp #Autosmooth
            )

    currMod.autoSmoothThreshold = currAngle
    )
)
)