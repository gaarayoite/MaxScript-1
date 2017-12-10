macroScript MinZPivot
buttonText:"Min Z Pivot"
category:"DmitryG Tools"
tooltip:"Set Pivot To Min Z"
icon:#("DmitryGTools_icons",5)
silentErrors: true
(
    for obj in selection do(

        obj.Pivot = [obj.center.x, obj.center.y,obj.min.z]
    )
)
