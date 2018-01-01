try (DestroyDialog DmitryGTools) catch()
rollout DmitryGTools "DmitryG Tools v1.0" width:195 height:265
(
    local usermacros = (symbolicPaths.getPathValue "$userMacros")+"\\"
    local usericons = (symbolicPaths.getPathValue "$usericons")+"\\"
    local tmpdir = getFilenamePath (getSourceFileName())
    local maxver = (maxversion())[1] 
    local ScriptArr = #(
        "EdgeDivide.ms",
        "FastGreyMat.ms",
        "MinZPivot.ms",
        "MoveToOrigin.ms",
        "MultyBevelDialog.ms",
        "QuadSphere.ms",
        "SoftPolys.ms",
        "ToggleHardEdgesDisplay.ms",
        "TrackBarToggle.ms",
        "ZeroExtrude.ms"
    )

    checkbox chb_EdgeDivide "Edge Divide" pos:[5,10] height:16 checked:true tooltip:"Divide selected edge(s) by 1 vertex or by custom verteces count(Editable Poly only).\nScript works with Edit\Editable poly and with all subObject levels.\nUse option box in quad menu to open settings dialog"
	checkbox chb_FastGreyMat "Fast Grey Material" pos:[5,31] height:16 checked:true tooltip:"Applies grey material to selected object(s) and changing wire color to black.\nNice to check subdivided surface."
	checkbox chb_MinZPivot "Min Z pivot position" pos:[5,52] height:16 checked:true tooltip:"Move pivot position to the minimal Z"
	checkbox chb_MoveToOrigin "Move to Origin" pos:[5,73] height:16 checked:true tooltip:"Move object to [0,0,0] position by it pivot,\nif selected multiple objects the pivot of them will be centered by average value"
	checkbox chb_MultyBevelDialog "Multy Bevel Dialog" pos:[5,94] height:16 checked:true tooltip:"If subObject level is Face opens Bevel dialog else Extrude dialog\nEdit\Editable poly compatible\nIdea - use it via hotkey"
	checkbox chb_QuadSphere "Quad Sphere" pos:[5,115] height:16 checked:true tooltip:"Create quad sphere"
	checkbox chb_SoftPolys "Soft Polys" pos:[5,136] height:16 checked:true tooltip:"AutoSmooth selected face(s) by angle 180 \nsimilar as max build in feature in the Ribbont but it saves current autosmooth angle value"
	checkbox chb_ToggleHardEdgesDisplay "Toggle Hard Edge Display" pos:[5,157] height:16 checked:true tooltip:"Toggle Hard Edge Display via hotkey,\nEditable poly only"
	checkbox chb_TrackBarToggle "Hide\Unhide Track Bar" pos:[5,178] height:16 checked:true tooltip:"Hide\Unhide Track Bar and Time Slider"
    checkbox chb_ZeroExtrude "Zero Extrude" pos:[5,199] height:16 checked:true tooltip:"Extrude face(s) by 0 value\nEdit\Editable poly compatible"

    button btn_inst "Install" pos:[5,220] width:90 height:30
    button btn_uninst "Uninstall All" pos:[100,220] width:90 height:30
	hyperlink   hl_WebSite "By Dmitry Gubkin"  pos:[55,251]  color:(color 79  180  176) hoverColor:(color 277 130 69)  visitedColor:(color 79  180  176)  address:"https://www.artstation.com/dmitry_g"
    
	
    on DmitryGTools open do 
    (
        if maxver<18000 do 
        (
            chb_ToggleHardEdgesDisplay.checked = false
            chb_ToggleHardEdgesDisplay.enabled = false   
        )
    )

    function fn_CopyDir fsource fdir =
    (
       command = "XCOPY \""+fsource+"*\" \""+fdir+"\" /Q /I /S /Y"	
		HiddenDOSCommand command startpath:".\\"
    )

     function fn_install arr =
     (
         local dir = tmpdir +"Scripts\\"
         for i=1 to  arr.count do 
        (
            try (filein (dir + arr[i])) catch() --install macro
        )
        sleep 1
        fn_CopyDir (tmpdir+"Icons\\") usericons -- install icons
        sleep 1
        colorman.reInitIcons() 
     )
     
     function fn_uninstallall = 
     (
        for i in (getFiles (usermacros + "*DmitryG Tools-*")) do 
        (
            try (deleteFile i) catch()
        )

        for i in (getFiles (usericons + "*DmitryGTools_icons*")) do 
        (
            try (deleteFile i) catch()
        )
        sleep 1
        colorman.reInitIcons()
     )

     on btn_inst pressed do 
    (
        local scrArr = #()

        if chb_EdgeDivide.checked == true do (append scrArr ScriptArr[1])
        if chb_FastGreyMat.checked == true do (append scrArr ScriptArr[2])
        if chb_MinZPivot.checked == true do (append scrArr ScriptArr[3])
        if chb_MoveToOrigin.checked == true do (append scrArr ScriptArr[4])
        if chb_MultyBevelDialog.checked == true do (append scrArr ScriptArr[5])
        if chb_QuadSphere.checked == true do (append scrArr ScriptArr[6])
        if chb_SoftPolys.checked == true do (append scrArr ScriptArr[7])
        if chb_ToggleHardEdgesDisplay.checked == true do (append scrArr ScriptArr[8])
        if chb_TrackBarToggle.checked == true do (append scrArr ScriptArr[9])
        if chb_ZeroExtrude.checked == true do (append scrArr ScriptArr[10])

		fn_install scrArr
		
        if (queryBox ("Instalation Compleate,\n Go to Customize -> Customize User Interface, choose \"DmitryG Tools\" in the Category list and use it!\nOpen  Customize User Interface ?") title:"DmitryG Tools") do
            (
                actionMan.executeAction 0 "59226" 
            )
    )

    on btn_uninst pressed do 
    (
        fn_uninstallall()
        messageBox "DmitryG Tools Uninstalled Successfully!" title:"DmitryG Tools"
    )

    on DmitryGTools close do 
    (
        gc()
    )
)

CreateDialog DmitryGTools style:#(#style_toolwindow, #style_border, #style_sysmenu)