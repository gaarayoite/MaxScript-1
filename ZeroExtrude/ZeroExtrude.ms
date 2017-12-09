macroScript ZeroExtrude
buttonText: "ZeroExt"
category:"DmitryG Tools"
tooltip:"Zero Extrude"
(
    GWTextSettings = #((color 34  208  201),"0", [0,0,0],500) -- 1 - color, 2 face count, 3- text position, 4- time msec

function GW_ExtFaceCount = 
(
    gw.setTransform (matrix3 1)
	gw.htext GWTextSettings[3] GWTextSettings[2] color:GWTextSettings[1] --text from left down origin, pos , text , color
	gw.enlargeUpdateRect #whole  

-- automatically unreg callback
	if timeStamp()>GWTextSettings[4] do 
	(
		unregisterRedrawViewsCallback GW_ExtFaceCount 
	)
)

if GetCommandPanelTaskMode() == #modify do 
(
    currmod = modPanel.getCurrentObject()
    unregisterRedrawViewsCallback GW_ExtFaceCount 
    GWTextSettings[3] = [ceil(gw.getWinSizeX()*0.5), ceil (gw.getWinSizeY() * 0.5) , 0] -- center screen
    GWTextSettings[4] = timeStamp() + 1100 -- 1.1 second

    if ClassOf currmod == Editable_Poly then 
    (
        if subObjectLevel == 4 or subObjectLevel ==5 do 
        (
            FaceArr = polyop.getFaceSelection currmod 
			
            if FaceArr.count !=0 do 
            (
				currExtType = currmod.extrusionType
				currmod.extrusionType = 0
                polyop.extrudeFaces currmod FaceArr 0.0 -- make extrudion
                currmod.extrusionType = currExtType
				subObjectLevel = 4
--visual callback
                GWTextSettings[2] = "#Face Extruded:" +(FaceArr.numberSet) as string
                registerRedrawViewsCallback GW_ExtFaceCount 
                gw.updateScreen() 
--end visual callback
            )
        )
    )
     else 
        (
            if ClassOf currmod == Edit_Poly do  
            (
                if subObjectLevel == 5 do 
                (
                    currmod.ConvertSelection #CurrentLevel #Face
                    subObjectLevel = 4
                )

                if subObjectLevel == 4 do 
                (

                    FaceArr = currmod.EditPolyMod.GetSelection  #CurrentLevel
                    
                    if FaceArr.count != 0 do 
                    (
                        currExtType = currmod.extrudeFaceType
                        currmod.extrudeFaceType = 0
                        currmod.SetOperation #ExtrudeFace
                        currmod.extrudeFaceHeight = 0.0
                        currmod.Commit ()
                        currmod.extrudeFaceType = currExtType 
                        
--visual callback
                       
                        GWTextSettings[2] = "#Face Extruded:" +(FaceArr.numberSet) as string
                        registerRedrawViewsCallback GW_ExtFaceCount 
                        gw.updateScreen() 
--end visual callback
                        
                    )
                )
            )
        )

)

) -- end script