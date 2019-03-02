; works with silver and gold chests
Gui, Add, text, , Enter number of chests to open #:
Gui, Add, Edit, vchestsToOpen
Gui, Add, Button, default, OK
Gui, Show
Return

GuiClose:
ButtonOK:
Gui, Submit

global counter = 0
^Space::		;this is the space every 10 miliseconds
while true	;this is loops until the counter isn't bigger than the chests to open
{
send {space}
sleep 10 ; RAPID FIRE OPENING, change sleep to see what you are getting
counter++ ; increment counter to use compare operator
}
return		;ends the hotkey

`::
{
	Pause, , 1
	return
}
