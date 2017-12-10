macroScript FastGreyMat
buttonText: "MAT Gray"
category:"DmitryG Tools"
tooltip:"Fast Grey Material"
icon:#("DmitryGTools_icons",2)
silentErrors: true
(
global theFastMat
------------------------------------------------------------------------------------------------------	
	
		if theFastMat == undefined  do
			(
				undo off 
				(
					theFastMat =StandardMaterial() 
					theFastMat. name = "FastGrayMat"
					theFastMat. ShaderType =1
					theFastMat. diffuse = (color 50 50 50)
					theFastMat. specular = (color 237 224 216)
					theFastMat. specularLevel =100.0 
					theFastMat. glossiness = 30.0 
				)
			)
		
			if $!=undefined do 
				(
					$.material = theFastMat
					$. wirecolor = (color 0 0 0) --change wire color
					
				)
	
)
	
	
	