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
global xLocation = 608 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global Ylocation = 502 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global contractScrollX = 615, ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global contractScrollY = 440 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global scrollX = 781 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global scrollY = 445 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global useContractX = 590 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global useCotractY = 488 ; THESE LOCATIONS CHANGE DEPENING ON WHERE YOUR BOUNTY CONTRACTS ARE LOCATED
global counter = 0

^t::
{

    while(numberOfContracts > counter){
      MouseMove, xLocation, Ylocation,
      Sleep, 200


      MouseClick,
      sleep, 300
      Loop, 25 {
        MouseClick, WheelDown, scrollX, scrollY
        Sleep, 10
      }
      Sleep, 200
      MouseMove, useContractX, useCotractY
      sleep, 300
      MouseClick
      sleep, 500
      MouseMove, xLocation, Ylocation,
      Sleep, 350
      sleep, 6500
      counter++

    }

}

`::
{
	Pause, , 1
	return
}
