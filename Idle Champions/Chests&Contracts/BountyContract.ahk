;!!!!!! THIS IS FOR RESOLUTION 1366x768 (WINDOWED) !!!!!!!!
; CONTRACTS ARE OPENED BY 10X of chosen rarity - If you set X/Y to an epic contract it will open 10
; so if you have 10 contracts you enter 1 as the number of contractScrollX
; so numberOfContracts is - numberOfContracts * 10 !!!
Gui, Add, text, , Enter number of contracts to open 'contract*10' #:
Gui, Add, Edit, vnumberOfContracts
Gui, Add, Button, default, OK
Gui, Show
Return

GuiClose:
ButtonOK:
Gui, Submit

global xLocation = 595 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global Ylocation = 507 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global contractScrollX = 594 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global contractScrollY = 440 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global scrollX = 791 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global scrollY = 440 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global useContractX = 590 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global useCotractY = 488 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global counter = 0

^t::
{

    while(numberOfContracts > counter){
      MouseMove, xLocation, Ylocation,
      Sleep, 10


      MouseClick,
      sleep, 300
      Loop, 14 {
        MouseClick, WheelDown, scrollX, scrollY
        Sleep, 10
      }
      Sleep, 10
      MouseMove, useContractX, useCotractY
      sleep, 10
      MouseClick
      sleep, 10
      counter++

    }

}

`::
{
	Pause, , 1
	return
}
