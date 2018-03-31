try 
(
    if doesFileExist ((symbolicPaths.getPathValue "$userScripts")+"\\Quick SubD Toggle\\QuickSubDPreview.ms") then 
    (
        filein ((symbolicPaths.getPathValue "$userScripts")+"\\Quick SubD Toggle\\QuickSubDPreview.ms")
    )
    else (messageBox "Can't locate settings script file\n=>Try Reinstall tool to fix it!" title:"Quick SubD Toggle")

)
catch()