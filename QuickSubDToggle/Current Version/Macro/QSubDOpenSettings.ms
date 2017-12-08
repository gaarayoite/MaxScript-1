macroScript QSubDOpenSettings
buttonText: "QSubDSettings"
category:"Quick SubD Toggle"
tooltip:"QSubD Settings"
icon:#("QST_icons",3)
silentErrors: true
(
MsFolderPath = (symbolicPaths.getPathValue "$userScripts")+"\\Quick SubD Toggle\\" -- Default Script folder Path
global The_QSubDTogg
global The_ReloadSettings
--------------------------------------------------------------------------------------------------------------------------------------------------------------
--Toggle SubDPreview
on execute do 
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
                return (messageBox "Can't locate settings script file\n=>Try Reinstall tool to fix it!" title:"Quick SubD Toggle") 
            )
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------
)
