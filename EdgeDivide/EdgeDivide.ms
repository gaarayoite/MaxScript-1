macroScript EdgeDivide
buttonText: "EdgeDivide"
category:"DmitryG Tools"
tooltip:"Divide Edge. To open settings dialog use script as item of the quad menu"
silentErrors: true
(
global VertCount = 1 -- target verts count
global newVrxArr = #() -- new vereces array
---Make division Editable_Poly
function fn_DivEdgeEditable obj verts currEdge  = 
(
    if verts == 1 then 
    (
       local newVert = polyop.divideEdge obj currEdge 0.5 
        appendIfUnique newVrxArr newVert 

    )
    else 
        (
            local DivItr = verts as integer
            verts+=1.0
            
            for i=1 to DivItr do 
            (
                local DivFract = 1.0/verts
                local newVert = polyop.divideEdge obj currEdge DivFract 
                appendIfUnique newVrxArr newVert   
                local newEdges = (polyOp.getEdgesUsingVert obj newVert) as Array
                
                if newEdges[1] == currEdge then currEdge = newEdges[2] else currEdge = newEdges[1]
    
                verts -=1
            )
        )
    
) -- end func 

---Make division Editable_Poly, only one vertex div supported
function fn_DivEdgeEdit obj verts currEdge = 
(
    if verts == 1 then 
    (
        with undo on (local newVert = obj.DivideEdge  currEdge 0.5)
        obj.Commit()      
    )
)--end func

--Divide by target Edge
function fn_DivideEdge = 
(
    if GetCommandPanelTaskMode() == #modify do 
    (
        local The_EdgeArr = #()
        newVrxArr = #()

        local currMod = modPanel.getCurrentObject()

        if ClassOf currMod == Editable_Poly and subObjectLevel != 0 then  
        (
            case subObjectLevel of 
            (
                1:(The_EdgeArr = polyOp. getEdgesUsingVert currMod (polyOp. getVertSelection currMod ))
                2:(The_EdgeArr = polyOp. getEdgeSelection currMod)
                3:(The_EdgeArr = polyOp. getEdgeSelection currMod)
                4:(The_EdgeArr = polyOp. getEdgesUsingFace currMod (polyOp. getFaceSelection currMod ))
                5:(The_EdgeArr = polyOp. getEdgesUsingFace currMod (polyOp. getFaceSelection currMod ))
            )
        
            if The_EdgeArr. isEmpty == false and VertCount > 0 do 
            (
with undo on (
						for currEdge in The_EdgeArr do 
						( 
							fn_DivEdgeEditable currMod VertCount currEdge   -- divide edge by target edge count
						)
					)
            
                polyop. setVertSelection currMod newVrxArr
                subObjectLevel = 1 
            )
        )
        else
            (
                if ClassOf currMod == Edit_Poly and currMod.EditPolyMod.GetEPolySelLevel() != #Object and (currMod.GetSelection #CurrentLevel).count !=0 do 
                (
					VertCount = 1
                    currMod.ConvertSelection #CurrentLevel #Edge

                    if currMod.EditPolyMod.GetEPolySelLevel() != #Vertex do -- switch to vertex sublevel
                    (
                        currMod. SetEPolySelLevel #Vertex
                    ) 
                    currMod.SetSelection #Vertex #{} --clean selected vertices
                    currMod. SetEPolySelLevel #Edge
                    The_EdgeArr = currMod.GetSelection #Edge

with undo on( 
						for currEdge in The_EdgeArr do 
						(
							fn_DivEdgeEdit currMod 1 currEdge --divide edge by midle point
						)
					)
                    currMod. SetEPolySelLevel #Vertex 
                )
            )
    )	
) -- end function


--UI
function fn_OpenEdgDivUI = 
(
    try DestroyDialog (EdgeDivRol) catch()
    rollout EdgeDivRol "Edge Divide" width:135 height:65
    (
        label lb_VCount "Verteces Count:" pos:[5,8] width:80 height:16 align:#left
        spinner spn_VertsCount  pos:[90,5] width:40 height:16 range:[1,100,1] type:#integer align:#left
        
        button      btn_Apply "Apply"   	pos:[5,32 ]	 width: 60  height: 25  align:#left
        button      btn_OK "OK"   			pos:[70, 32] width: 60  height: 25  align:#left
        
        on btn_Apply pressed do
        (
			VertCount = (spn_VertsCount.value) as integer
            fn_DivideEdge()
        )
            
        on btn_OK pressed do
        (
			VertCount = (spn_VertsCount.value) as integer
            fn_DivideEdge()
            try DestroyDialog (EdgeDivRol) catch()   
        )

    )
    createdialog EdgeDivRol style:#(#style_toolwindow, #style_border, #style_sysmenu)
)
--endUI

on execute do 
(
    VertCount = 1 --set target verts count to one
    fn_DivideEdge()
)

on altExecute type do 
(
    if ClassOf (modPanel.getCurrentObject()) == Editable_Poly do 
    (
        fn_OpenEdgDivUI ()
    )
) 
) -- end script
