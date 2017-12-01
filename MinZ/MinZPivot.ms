macroScript MinZPivot
buttonText:"Min Z Pivot"
category:"DmitryG Tools"
tooltip:"Set Pivot To Min Z"
(
    for obj in selection do(

        obj.Pivot = [obj.center.x, obj.center.y,obj.min.z]
    )
)
