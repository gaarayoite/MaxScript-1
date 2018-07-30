macroScript IntersectionShape
buttonText: "Intrs. Shape"
category:"DmitryG Tools"
tooltip:"Create Intersection Shape"
silentErrors: true
(
	global objs = #() -- Array of Working objects (geometry)
	global ShapeArr = #() -- Array of Shapes
	global BoolMesh = undefined -- Boolean Object
	global OptsArr = #(true, false) -- array of options, 1 - Merge Shapes, 2 - Keep Boolean Mesh
		
--- Collect SubShapes
	function fn_CollectShapes obj =   
	(
		ProBoolean.CreateBooleanObject BoolMesh obj 0 1 0
		local tempBool = copy BoolMesh
		
		ConvertTo tempBool Editable_Poly
		
		local edges = polyop.getEdgeSelection tempBool
		local ShpName = "IntersectionShape_" + (timeStamp() as String)
		
		polyop.createShape tempBool edges name:ShpName smooth:false
		
		local IntrShape = getNodebyName ShpName
		
		if (numKnots IntrShape) > 0 then
		(
			append ShapeArr IntrShape
		)
		else (delete IntrShape)
		
		delete tempBool
		free tempBool
	)
-- End Function 

-- Reset XForm Shape 
	fn fn_ResetXFShape Arr = 
	(  setCommandPanelTaskMode #create
		with undo off
		(
			with redraw off 
			(
				for obj in Arr do 
				(
					addModifier obj (XForm())
					convertToSplineShape obj
				)
			)
		)
	)

-- Center Pivot 
	fn fn_CPivot Arr = 
	( setCommandPanelTaskMode #create 
		with undo off 
		(
			with redraw off 
			(
				for obj in Arr do 
				(
					CenterPivot obj
				)
			)
		)
	)
-- End Function 

-- Enable in viewport togg  , Rend -- True - Render, False - Viewport
	fn fn_VEnable Arr Rend =
	(	
		setCommandPanelTaskMode #create 
		Arr = for obj in Arr where(superClassOf obj == Shape) collect obj
		with undo off 
		( 
			with redraw off 
			(
				if keyboard.altPressed then 
				(
					for obj in Arr do 
					(
						if Rend == true then 
						(
							obj.render_renderable = false 
						)
						else 
							(
								obj.render_displayRenderMesh = false 
							)
					)
					
				)
				else 
					(
						for obj in Arr do 
							(
								if Rend == true then 
								(
									obj.render_renderable = true 
								)
								else 
									(
										obj.render_displayRenderMesh = true 
									)
							)
					)
			)
		)
		
		setCommandPanelTaskMode #modify
	) 
-- End Function

-- Merge Shapes 
	function fn_MergeShapes = 
	(
		if ShapeArr.count > 1 do 
		(
			if OptsArr[1] == true do  
			(
				local FirstShape = ShapeArr [1]
				FirstShape.name = "Merged_" + FirstShape.name 
				deleteItem  ShapeArr 1
				
				for obj in ShapeArr do 
				(
					AddAndWeld FirstShape obj 0
				)
				
				ShapeArr = #()
				append ShapeArr FirstShape
			) 	
		) 
		select ShapeArr
	)
	
-- End Function 

-- Keep Boolen Mesh
	fn fn_KeepBoolMesh = 
	(
		if BoolMesh != undefined do 
		(
			if OptsArr[2] == true then
			(
				local LName = "Lyr_Boolean_Meshes"
				
				local NLayer = (LayerManager.getLayerFromName LName)
				
				if NLayer == undefined do
				(
					NLayer = LayerManager.newLayerFromName LName
				)
				
				NLayer.addnode  BoolMesh
				NLayer.on = false
			) 
			else (delete BoolMesh)
		)
	)
-- End Function 
	
-- Make Shape
	function fn_CreateShape = 
	(
		setCommandPanelTaskMode #create 
		
		with undo off 
		(
			disableSceneRedraw()
			objs = for obj in objs collect (copy obj )
			
			for obj in objs do
			(
				addModifier obj (XForm())
			)
			ConvertTo objs Editable_Poly
			
			BoolMesh = objs[1] -- copy first item 
			BoolMesh.name = "Boolean_Mesh_" + (timeStamp() as String)
			deleteItem objs 1 -- remove first item 
			
			for obj in objs do 
			(
				fn_CollectShapes obj
				
			)
			
			fn_KeepBoolMesh()	
			
			if ShapeArr.count != 0 do 
			(
				fn_MergeShapes()
				fn_ResetXFShape ShapeArr
				fn_CPivot ShapeArr
			)
			
			enableSceneRedraw() 
			redrawViews()
		)
	)
-- End Function 

--Check Mesh Density
	fn fn_CheckMesh = 
	(
		if selection.count > 1 do 
		(
			objs = for obj in selection where(superClassOf obj == GeometryClass) collect obj
			
			if objs.count > 1 do 
			(

				local maxTris = 20000-- max tris count 
				
				for obj in objs do 
				(
					maxTris -= obj.mesh.numFaces
				)
				
				if maxTris < 0 then 
				(
					if (queryBox  "Warning. Heavy Mesh Density.\nDo You Want Continue ?" title:"Intersection Spline ?") == false then 
					(return false)
					
					else	(fn_CreateShape())
				)
					else (fn_CreateShape())
				
			)
		)
	)
-- End Function 
try (destroyDialog ::IntersectionShapeDlg) catch() -- Destroy dialog
--UI
	rollout IntersectionShapeDlg "Intersection Shape" width:150 height:100 
	(
		checkbox cbx_Merge  "Merge Shapes" pos:[5, 5] width:140 height:16 checked:(OptsArr[1]) tooltip:"Merge Multy Intersections in One Shape"
		checkbox cbx_KeepBoolMesh  "Keep Bool Mesh (Hidden)" pos:[5, 26] width:140 height:16 checked:(OptsArr[2]) tooltip:"Don't Delete Boolean Mesh(Hiden)\nLayer - Lyr_Boolean_Meshes"
		button btn_Create "Create" pos:[5, 50 ] width: 65  height: 20  align:#left tooltip:"Create Intersaction Shape"
		button btn_Delete "Delete Last" pos:[80,50 ] width: 65  height: 20  align:#left tooltip: "Delete Last Intersection Shape(s)\nand Boolean Mesh"
		button btn_XForm "XF" pos:[5,75 ] width: 25  height: 20  align:#left tooltip: "Reset XForm(Shapes Only)"
		button btn_CP "CP" pos:[34,76 ] width: 25  height: 20  align:#left tooltip: "Center Pivot"
		button btn_ERender "R" pos:[62,75 ] width: 25  height: 20  align:#left tooltip: "Enable in Reder Selected Shape(s)\nALT - Disable"
		button btn_EViewport "V" pos:[90,75 ] width: 25  height: 20  align:#left tooltip: "Enable in Viewport Selected Shape(s)\nALT - Disable"
		button btn_MergeSel "M" pos:[118,75 ] width: 25  height: 20  align:#left  tooltip: "Merge Selection Shapes"
		
--Events 
		on btn_Create pressed do
		(
--Reset values
			objs = #() 
			ShapeArr = #() 
			BoolMesh = undefined 
			
			fn_CheckMesh()
		)
		
		on btn_Delete pressed do 
		(
			with undo on 
			(
				try 
				(
					if  BoolMesh.isDeleted == false   do 
					( 
						delete BoolMesh
						free BoolMesh
					)

					if ShapeArr.count > 0 do 
					(
						for obj in ShapeArr do 
						(
							if obj. isDeleted == false do
							(
								delete obj
								free obj 
							)
						)
					)
				) catch()
				
				
			)
		)

		on btn_XForm pressed do
		(
			local Arr = for obj in selection where(superClassOf obj == Shape) collect obj
			fn_ResetXFShape Arr
			setCommandPanelTaskMode #modify 
		)

		on btn_CP pressed do
		(
			fn_CPivot selection
		)

		on btn_ERender pressed do
		(
			fn_VEnable selection true 
		)

		on btn_EViewport pressed do
		(
			fn_VEnable selection false 
		)

		on cbx_Merge changed state do 
		(
			OptsArr[1] = state 
		)

		on cbx_KeepBoolMesh changed state do 
		(
			OptsArr[2] = state 
		)
		
--End Events
	)
--End UI
		
	enableSceneRedraw() 
	redrawViews()
	CreateDialog IntersectionShapeDlg style:#(#style_toolwindow, #style_border, #style_sysmenu)-- create dialog 
)