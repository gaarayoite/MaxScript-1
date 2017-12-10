macroScript TrackBarToggle
buttonText:"TrackBar"
category:"DmitryG Tools"
tooltip:"TrackBar Toggle"
icon:#("DmitryGTools_icons",4)
silentErrors: true
(
if timeslider.isvisible()!=trackbar.visible then
(
    undo off
    (
      timeslider.setvisible(true)
      trackbar.visible = true
    )
)
undo off 
(
  timeslider.setvisible(not timeslider.isvisible())
  trackbar.visible = not(trackbar.visible)
)

)