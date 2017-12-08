macroScript QSubDSwitch
buttonText: "SwitchSubD"
category:"DmitryG Tools"
tooltip:"Switch SubD"
silentErrors: true 
(
 MsFolderPath = (symbolicPaths.getPathValue "$userScripts")+"\\Quick SubD Toggle\\" -- Default Script folder Path
global The_QSubDTogg
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
        filein MsPath
    )
    else 
        (
            return (messageBox "Can't locate settings script file\n=>Try Reinstall tool to fix it!"  title:"Quick SubD Toggle") 
        )
)

)
