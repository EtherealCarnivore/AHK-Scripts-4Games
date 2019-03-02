;The X/Y values will only work for 1920x1080p
global skill4X = 1608 ;4th skill
global skill4Y = 1054
global thunderX = 1435 ;lightning golem
global thunderY = 714
global flameX = 1507 ;flame golem
global flameY = 631
global portX = 16 ;blue icon for party member
global portY = 255
global clickPX = 1129 ;click port to party member
global clickPY = 559
global newX = 476 ;location of the "New" instance
global newY = 341
global bridgeX = 1071 ;location of the bridge
global bridgeY = 446


; use flask 1-5 -- this is for my MF Windripper as spamming flasks is SUPER annoying
SPACE::
{
Send {1}{2}{3}{4}{5}
Sleep 1000
return
}

; swap golems and cast them -- this needs a rework, no longer using Arc Witch
F2::
{
  MouseMove, skill4X, skill4Y,
  Sleep 30
  MouseClick,
  Sleep 30
  MouseMove, thunderX, thunderY,
  Sleep 30
  MouseClick,
  Sleep 30
  Send R,
  Sleep 30
  MouseMove, skill4X, skill4Y,
  Sleep 30
  MouseClick,
  Sleep 30
  MouseMove, flameX, flameY,
  Sleep 30
  MouseClick,
Sleep 30
MouseMove, skill4X, skill4Y,
Sleep 30
  Send R
  Sleep 30

  return
}

;port to party member current location 
;this will teleport you to the location of the 1st party member instantly
F3::
{
  MouseMove, portX, portY,
  Sleep 50,
  MouseClick,
  Sleep 50,
  MouseMove, clickPX, clickPY,
  Sleep 50,
  MouseClick,
  Sleep 50

  return
}

;ctrl+6 to re-instanciate zone
;VERY usefull when farming harbour bridge for syndicates as it re-instanciates the zone way faster
^6::
{
  Send ^{Click, bridgeX, bridgeY},
  Sleep 600
  MouseMove, newX, newY,
  MouseClick,
  return

}
;suspend the script so you can type like a normal person
^`::Suspend
