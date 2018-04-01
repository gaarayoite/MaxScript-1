try (DestroyDialog QSTogg_Intaller) catch()
try DestroyDialog (QuickSubDSettings) catch()

rollout QSTogg_Intaller "Quick SubD Toggle v1.0.3" width:215 height:70 
(
    local invalidver = (MaxVersion())[1]<18000 -- check 3ds max version
    local usermacros = (symbolicPaths.getPathValue "$userMacros")+"\\"
    local userscripts = (symbolicPaths.getPathValue "$userScripts")+"\\"
    local usericons = (symbolicPaths.getPathValue "$usericons")+"\\"
    local startupdir =   userscripts + "startup\\"
    local tmpdir = getFilenamePath (getSourceFileName())
    button btn_inst "Install" pos:[5,25] width:100 height:30
    button btn_uninst "Uninstall" pos:[110,25] width:100 height:30
    label lb_msg "3ds Max version is supported" pos:[40,5]  height:16 align:#left
	hyperlink   hl_WebSite "By Dmitry Gubkin"  pos:[70,55]  color:(color 79  180  176) hoverColor:(color 277 130 69)  visitedColor:(color 79  180  176)  address:"https://www.artstation.com/dmitry_g"
	
    
    function fn_DelFolder fdir = 
    (
        if doesFileExist fdir do 
        (
           local  command =  "RD /S /Q \""+fdir+"\""
           HiddenDOSCommand command startpath:".\\"
        )
    )

    function fn_CopyDir fsource fdir =
    (
       command = "XCOPY \""+fsource+"*\" \""+fdir+"\" /Q /I /S /Y"	
		HiddenDOSCommand command startpath:".\\"
    )

    function fn_Uninstall = 
    (
        The_QSubDTogg = undefined
        local msdir =  userscripts + "Quick SubD Toggle"
        fn_DelFolder msdir -- delete foler

        for i in (getFiles (usermacros+"*QSubD*")) do ( try(deleteFile i) catch() ) -- delete macros

        if doesFileExist (startupdir + "QSTAutoLoad.ms") do 
        (
             try(deleteFile (startupdir + "QSTAutoLoad.ms")) catch() --delete autoload script
        )
        
        for i in (getFiles (usericons+"*QST_icons*")) do ( try(deleteFile i) catch() ) --delete icons
        sleep 1
    )

    function fn_Install  = 
    (
        fn_Uninstall()
        fn_CopyDir (tmpdir + "Scripts\\")   userscripts 
        fn_CopyDir (tmpdir + "Startup\\")   startupdir 
        fn_CopyDir (tmpdir + "Icons\\")     usericons 
        sleep 1
        for i in (getFiles (tmpdir+"\\Macro\\*.ms")) do (try (filein i ) catch(messageBox "Error on installation" title:"Error"))
        sleep 1
        filein (startupdir + "QSTAutoLoad.ms")
        sleep 1
    )

    on btn_inst pressed do 
    (
        fn_Install()
        colorman.reInitIcons()
        if (queryBox "Instalation Compleate\n Go to Customize -> Customize User Interface, choose \"Quick SubD Toggle\" in the Category list and use it!\nOpen  Customize User Interface ?" title:"Quick SubD Toggle") do
            (
                actionMan.executeAction 0 "59226" 
            ) 
    )

    on btn_uninst pressed do 
    (
        fn_Uninstall()
        colorman.reInitIcons()
        messageBox "Quick SubD Toggle Uninstalled Successfully!" title:"Quick SubD Toggle"
    )

    on QSTogg_Intaller close do 
    (
       -- local tmp =(symbolicPaths.getPathValue "$temp")+"\\QST" 
        --fn_DelFolder tmp
        gc()
    )

    on QSTogg_Intaller open do 
    (
        try DestroyDialog (QuickSubDSettings) catch()
        if invalidver == true do 
        (
            btn_inst.enabled = false 
            btn_uninst.enabled = false 
			lb_msg.text = "3ds Max version is unsupported"
        )
    )
)
createDialog QSTogg_Intaller style:#(#style_toolwindow, #style_border, #style_sysmenu)
