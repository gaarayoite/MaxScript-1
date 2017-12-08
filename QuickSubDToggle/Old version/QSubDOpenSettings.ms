macroScript QSubDOpenSettings
buttonText: "SubDSettings"
category:"DmitryG Tools"
tooltip:"OpenSubD Settings"
(
MsFolderPath = (symbolicPaths.getPathValue "$userScripts")+"\\Quick SubD Toggle\\" -- Default Script folder Path

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--Toggle SubDPreview
on execute do 
(
    local MsPath = MsFolderPath + "QuickSubDPreviewSettings.ms" 
    
        if doesFileExist MsPath == true then 
        (
            filein MsPath
        )
        else 
            (
                return (messageBox "Can't locate settings script file\n=>Try Reinstall tool to fix it!"  title:"Settings Script Location Error") 
            )
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------
)
