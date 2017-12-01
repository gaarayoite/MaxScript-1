macroScript Test01
buttonText: "ToggSubD"
category:"DmitryGScripts"
tooltip:"Toggle Subdivison"
(
global The_QSubDTogg -- var for Instance of QuickSubDPreview struct
MsFolderPath = (symbolicPaths.getPathValue "$userScripts")+"\\DmitryG Tools\\QuickSubDPreview\\" -- Default Script folder Path

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--Toggle SubDPreview
on execute do 
(
    if The_QSubDTogg == undefined do 
    (
        local MsPath = MsFolderPath + "QuickSubDPreview.ms"
            if doesFileExist MsPath == false do 
            (
                return (messageBox "Can't locate main script file\n=>Try Reinstall tool to fix it!" title:"Main Script Location Error")
            )
 
        print ("Please Wait,Main Script Initializing...")
        local maxTime = timeStamp() + 20000 

            while ClassOf The_QSubDTogg == UndefinedClass do 
                (
                   if timeStamp()>maxTime do -- time out if it needs more then 20 sec
                    (
                        return (messageBox "Time out,impossible to read main script file\nTry Reinstall tool to fix it!" title:"Time Out Error")
                    )
                    filein MsPath 
                )  
    )
The_QSubDTogg.fn_ToggSubD()
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
            return (messageBox "Can't locate settings script file\n=>Try Reinstall tool to fix it!"  title:"Settings Script Location Error") 
        )
)

)
