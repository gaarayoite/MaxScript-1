macroScript MoveToOrigin
buttonText:"Move To Origin"
category:"DmitryG Tools"
tooltip:"Move Selection To Origin"
(
 if selection.count > 0 then 
  (
    if selection.count ==1 then
	(
	selection.pos=[0,0,0]
	)
		else
		(
		with redraw off 
		(
		group selection name:"tempgroup"
		$tempgroup.pos = [0,0,0]
		ungroup $tempgroup
		)
		redrawViews()
		)
  )	
)