macroScript QuadSphere
buttonText: "QuadSphere"
category:"DmitryG Tools"
tooltip:"QuadSphere"
icon:#("DmitryGTools_icons",8)
silentErrors: true
(
global QBox
---------------------------------------------------------------
--Create new QSphere func
function fn_NewQSphere dim seg = 
(
    SetCommandPanelTaskMode #create 
    with redraw off 
    (
        QBox = Box() 
---making correct name
        local NameDigits = ""
        if ($*QSphere*.count +1)<10 then 
        (
            NameDigits = "00"+(($*QSphere*.count +1) as string)
        )
        else 
            (
                if ($*QSphere*.count +1)<100 then 
                (
                    NameDigits = "0"+(($*QSphere*.count +1) as string)
                )
                else 
                    (
                        NameDigits =($*QSphere*.count +1) as string 
                    )                   
            )
--- end making correct name 

        QBox.Name = "QSphere" +  NameDigits  --final name
        QBox. length = QBox. width = QBox. height = dim 
        QBox. widthsegs = QBox. lengthsegs = QBox.heightsegs = seg 
        QBox.Pivot = (QBox.center) as point3
        QBox.Pos= [0,0,0]
        select QBox
        addModifier QBox (Spherify PERCENT:100)
        addModifier QBox (Smooth smoothingBits:1)
        SetCommandPanelTaskMode #modify
    )
    redrawViews()
) 
-- end func 


--UI
try (DestroyDialog QSphereSettings) catch()
rollout QSphereSettings "QSphere" width:120 height:126 
(
    label lb_QDim "Diametr:" pos:[5,8] width:40 height:16 align:#left
    spinner spn_Dim  pos:[55,5] width:60 height:16 range:[0,99999.0,10.0] type:#float align:#left
	label lb_QSeg "Segments:" pos:[5,24] width:50 height:16 align:#left
    spinner spn_Seg  pos:[55,24] width:60 height:16 range:[1,200,4] type:#integer align:#left
    checkbox cbx_Collapse  "Collapse Stack" pos:[5, 48] width:110 height:16 checked:true
	button btn_Cancel "Cancel" pos:[5, 72] width: 54  height: 25  align:#left
	button btn_NewQSphere "New" pos:[61, 72] width: 54  height: 25  align:#left
	button btn_OK "OK" pos:[5, 98] width: 110  height: 25  align:#left
    
    on spn_Dim changed val do 
    (
        if isValidNode QBox do 
        (
            QBox. length = QBox. width = QBox. height = val
            QBox.Pivot = (QBox.center) as point3
        )
		
    )

    on spn_Seg changed val do 
    (
        if isValidNode QBox do 
        (
			QBox. widthsegs = QBox. lengthsegs = QBox.heightsegs = val
			QBox.Pivot = (QBox.center) as point3
		)
    )
	
	on btn_OK pressed do
	(
        if cbx_Collapse.checked == true do 
        (
            macros.run "Modifier Stack" "Convert_to_Poly"
            
        ) 
        
        try (DestroyDialog QSphereSettings) catch()
	)

    on btn_Cancel pressed do 
    (
		if isValidNode QBox == true do 
		(
			delete QBox
		)
        try (DestroyDialog QSphereSettings) catch() 
    )
    
    on btn_NewQSphere pressed do 
    (
        if cbx_Collapse.checked == true do 
            (
                macros.run "Modifier Stack" "Convert_to_Poly"  
            )

            with undo on (fn_NewQSphere (QSphereSettings.spn_Dim.value) (QSphereSettings.spn_Seg.value))
    )
	
)
--End UI

CreateDialog QSphereSettings style:#(#style_toolwindow, #style_border, #style_sysmenu)-- create dialog 
with undo on (fn_NewQSphere (QSphereSettings.spn_Dim.value) (QSphereSettings.spn_Seg.value)) -- create default sphere
) -- end script 