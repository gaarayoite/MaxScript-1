------------------------------------ Settings Global Vars------------------------------------------------
global Set_SelStyleSwitch = #(1,5,1)
global SmartCycleSel --CurrentMode
global SmartSelTemp -- Last Selected Object
global Set_IgnoreBackFace = #(true, false,true,false)
global Set_ActivateSelectionTool = # (true, true)
------------------------------------------------------------------------------------------------------------

fn_AvativaSelectionTool Set_ActivateSelectionTool[1] 

 SmartCycleSel = (if SmartCycleSel == Set_SelStyleSwitch[1] then Set_SelStyleSwitch[2] else Set_SelStyleSwitch[1])

 fn_SelStyleSwitch SmartCycleSel 
 
	if(selection.count ==1) then
		(	StoreObjTemp()
			SmartIgnoreBF()
			callbacks.addScript #modPanelSelChanged "SmartIgnoreBF()" id:#IDSmartIgnoreBF -- activate callback		
		)
			else
			(
				callbacks.removeScripts id:#IDSmartIgnoreBF -- deactivate callback	
			)

		
	-------------------------------------------------------------------------------------------------------------------------------------------------
	 function SmartIgnoreBF=
		(
			print "redraw"
			if SmartSelTemp != $ and $!=undefined   do
				(
					actionMan.executeAction 0 "50027"--activate selection tool, remove this line if you want to keep transform tool
					actionMan.executeAction 0 "59232" --- enable rec selection in the scene, remove this line if you watn to keep selection style
					callbacks.removeScripts id:#IDSmartIgnoreBF
					return undefined
				)
				
		local	currMod = modPanel.getCurrentObject()
				
			if ClassOf currMod == Edit_Poly or ClassOf currMod == Editable_Poly do 
			( 
				

				if SmartCycleSel!=Set_SelStyleSwitch[2] then
					(
						currMod.ignorebackfacing = Set_IgnoreBackFace[2] 
						
					)
					else 
						(
						currMod.ignorebackfacing = Set_IgnoreBackFace[1]  
						)	

			)
			
									
		)--end function SmartIgnoreBF
		
-------------------------------------------------------------------------------------------------------------------------------------------------
function StoreObjTemp = 
	(
			 if (SmartSelTemp != $ and $!=undefined)  do -- SmartSelTemp - last selected object
			(
				SmartSelTemp = $ 
			)
			
	)
-------------------------------------------------------------------------------------------------------------------------------------------------	
function fn_SelStyleSwitch SelMode = 
(
	case SelMode of 
	(
		  1:(actionMan.executeAction 0 "59232") 		-- Rectangle selection
		  2:(actionMan.executeAction 0 "59233") 		-- Circle selection
		  3:(actionMan.executeAction 0 "59234") 		-- Fence selection
		  4:(actionMan.executeAction 0 "59235") 		-- Lasso selection
		  5:(actionMan.executeAction 0 "59236") 		-- Paint selection
		  6:(								  ) 		-- Dont Change selection style
        default:(actionMan.executeAction 0 "59232")	-- Default is Rectangle selection style
	)
)
-------------------------------------------------------------------------------------------------------------------------------------------------
function fn_AvativaSelectionTool ActivateSel= 
(
	if ActivateSel == true do 
		(actionMan.executeAction 0 "50027")	--activate selection tool)
)







 