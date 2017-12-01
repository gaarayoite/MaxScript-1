macroScript TrackBarToggle
buttonText:"TrackBar"
category:"DmitryG Tools"
tooltip:"TrackBar Toggle"
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