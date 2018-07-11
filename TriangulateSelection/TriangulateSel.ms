macroScript TriangulateSelection
buttonText: "Triangulate"
category:"DmitryG Tools"
tooltip:"Triangulate selection base on face or vertex selection"
silentErrors: true
(
    function fn_TriangleMesh =  --Main function
    (
        if GetCommandPanelTaskMode() == #modify do 
        (
          
            local currMod = modPanel.getCurrentObject()
    
            if ClassOf currMod == Editable_Poly or  ClassOf currMod == Edit_Poly   do  
            (
                local The_CurrSelMod = subobjectLevel
    
                if The_CurrSelMod == 1 or The_CurrSelMod == 5 then 
                (
                    with redraw off 
                    (
                        currMod.ConvertSelection #CurrentLevel #Vertex
                        with undo on
                        ( 
                            
                                if ClassOf currMod == Editable_Poly then  
                                (
                                    currMod.ConnectVertices()
                                )
                    
                                else
                                    (
                                        currMod.ButtonOp #ConnectVertices
                                    )   
                         )   
                    )
                         
                ) 
                else 
                    (
                        if The_CurrSelMod == 4 do 
                        (

                                if ClassOf currMod == Edit_Poly then 
                                (
                                    local FaceArr  = currMod.GetSelection #Face
                                   
                                ) 
                                else
                                    (
                                        local FaceArr = polyOp. getFaceSelection currMod
                                    )

                                    FaceArr = FaceArr as Array
                               
                                if ClassOf currMod == Editable_Poly then 
                                (   
                                    for currFace in FaceArr do 
                                    (
                                        with redraw off
                                        (
                                               
                                            local currVertx = polyOp.getFaceVerts currMod currFace
                                            polyop.setVertSelection currMod currVertx

                                            with undo on 
                                            (  
                                                currMod.connectVertices()  
                                            )
                                            
                                           
                                        )
                                    )
                                
                                )

                                else 
                                    ( 
                                        for currFace in FaceArr do 
                                        (
                                            with redraw off
                                            (
                                                
                                                currMod. SetSelection #Face #{}
                                                currMod. Select #Face #{currFace}
                                                currMod. ConvertSelection #Face #Vertex

                                                with undo on 
                                                (
                                                    CurrMod.ButtonOp #ConnectVertices 
                                                )
                                                
                                            )
                                        )
                                        
                                    )

                        )
                        
                    )                    
            )
	    
	    subobjectLevel = The_CurrSelMod -- back sel level
        )          

    redrawViews()
    )
    
    fn_TriangleMesh()

) -- end script
