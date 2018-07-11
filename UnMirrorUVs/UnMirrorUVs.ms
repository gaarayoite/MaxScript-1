macroScript UnMirrorUVs
buttonText:"UnMirror UVs"
category:"DmitryG Tools"
tooltip:"UnMirror UV Shells"
silentErrors: true
(

local currMod = undefined
local ResStore = #{}
local StoreFlag = true 
local itr = true
local StopTime = timeStamp() + 1000

   function fn_checkMirror =
    (
        if StopTime < timeStamp() then 
            (   
                return (messagebox "TimeOUT impossible to splve" title:"UnMirror UV Shells Tool")
			)
			else 
				(
					currMod.selectInvertedFaces() 
					facearr = currMod.getSelectedFaces()
					
					if StoreFlag == true do 
					(
						ResStore = currMod.getSelectedFaces()
						StoreFlag = false 
					)
					
					if facearr.isempty == true then 
					(
						print "UnMirror: Solved!!!"
					)
					else 
					(
						
						if itr == true then 
						(
							actionMan.executeAction 2077580866 "40010"  -- Unwrap UVW: Mirror Horizontal
							itr = false
						)
						else 
							(
								actionMan.executeAction 2077580866 "40032"  -- Unwrap UVW: Mirror Vertical
								itr = true
							)
						print "UnMirror: Solving..."
						fn_checkMirror()
					)
				)
            	
    )
	
if $ != undefined do 
    (
     currMod= modPanel.getCurrentObject()
        if ClassOf currMod ==  Unwrap_UVW then
            (
			   fn_checkMirror ()  
			   currMod.unwrap6.selectFacesByNode ResStore $
            )
            else (messagebox "Please use >Unwrap_UVW< modifier\n and open >UV Editor<\n before using this tool" title:"UnMirror UV Shells Tool")
    )
)