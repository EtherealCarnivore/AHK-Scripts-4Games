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


global xLocation = 763 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global Ylocation = 414 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global contractScrollX = 736 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global contractScrollY = 434 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global scrollX = 791 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global scrollY = 440 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global useContractX = 605 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global useCotractY = 487 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global counter = 0

^t::                                                ;CTRL+T to copy XY coordinates & color (0xBBGGRR) to clipboard
{

    while(numberOfContracts > counter){
      MouseMove, xLocation, Ylocation,
      Sleep, 300
      MouseMove, contractScrollX, contractScrollY,
      Sleep, 300
      MouseClick,
      sleep, 300
      Loop, 2 {
        MouseClick, WheelDown, %scrollX%, %scrollY%
        Sleep, 50
      }
      Sleep, 350
      MouseMove, useContractX, useCotractY
      sleep, 350
      MouseClick
      sleep, 350
      counter++

    }

}

`::
{
	Pause, , 1
	return
}
