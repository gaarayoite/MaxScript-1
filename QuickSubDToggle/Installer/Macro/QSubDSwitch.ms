macroScript QSubDSwitch
buttonText: "SwitchSubD"
category:"Quick SubD Toggle"
tooltip:"Switch SubD, Clear Selection to Switch #Global SubD Method"
icon:#("QST_icons",2)
silentErrors: true 
(
 MsFolderPath = (symbolicPaths.getPathValue "$userScripts")+"\\Quick SubD Toggle\\" -- Default Script folder Path
global The_QSubDTogg
global The_ReloadSettings
--------------------------------------------------------------------------------------------------------------------------------------------------------------
--Toggle SubDPreview
on execute do 
(
    if The_QSubDTogg == undefined do 
    (
        local MsPath = MsFolderPath + "QuickSubDPreview.ms"
            if doesFileExist MsPath == false do 
            (
                return (messageBox "Can't locate main script file\n=>Try Reinstall tool to fix it!" title:"Quick SubD Toggle")
            )
 
        print ("Please Wait,Main Script Initializing...")
        filein MsPath 
        sleep 5
    )
The_QSubDTogg.fn_SwitchSubD()
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------

--option box for Quad Menu item
on altExecute type do 
(
local MsPath = MsFolderPath + "QuickSubDPreviewSettings.ms" 

    if doesFileExist MsPath == true then 
    (
        if The_ReloadSettings == undefined do (The_ReloadSettings=true)
        if The_ReloadSettings == true do 
        (
            The_ReloadSettings = false
            filein MsPath
        )
        filein MsPath
    )
    else 
        (
            return (messageBox "Can't locate settings script file\n=>Try Reinstall tool to fix it!"  title:"Quick SubD Toggle") 
        )
)

)
