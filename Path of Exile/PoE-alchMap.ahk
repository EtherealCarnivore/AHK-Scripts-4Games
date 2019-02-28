; FOR RESOLUTION 1920X1080!!!!!!
;PoE Simplicity v0.0.1
;This will take the map and alch it for you
global mapInInvetoryX = 1291
global mapInInvetoryY = 616
global alchemyX = 487
global alchemyY = 338
global mapInTabX = 343
global mapInTabY = 520
global fixLocationX = 336
global fixLocationY = 571
global mapDeviceX = 1036
global mapDeviceY = 403
global activateX = 604
global activateY = 829
global skillX = 1603
global skillY = 970
global wrathX = 1505
global wrathY = 705
global totemX = 1573
global totemY = 768



;auto-alch map and return it to invetory
;you need to have your currency tab opened and map in top left inventory slot
F2::
{
MouseMove, mapInInvetoryX, mapInInvetoryY
Sleep 10,
Send ^{Click, mapInInvetoryX, mapInInvetoryY},
Sleep 50,
MouseMove, alchemyX, alchemyY,
Sleep 10,
Send ^{Click, mapInTabX, mapInTabY, right},
Sleep 10,
MouseMove, mapInTabX, mapInTabY,
Sleep 10,
MouseClick,
Sleep 10,
MouseMove, fixLocationX, fixLocationY,
Sleep 50,
Send ^{Click, mapInTabX, mapInTabY},
Sleep 10,
return
}

;places map and opens the portal
F3::
{
MouseMove, mapInInvetoryX, mapInInvetoryY
Sleep 10,
Send ^{Click, mapInInvetoryX, mapInInvetoryY},
Sleep 50,
MouseMove, activateX, activateY,
Sleep 10,
MouseClick
return
}

;casts wrath and replaces skill with totem -- custom made for my Arc Witch
F4::
{
MouseMove, skillX, skillY
Sleep 10,
MouseClick,
Sleep 50,
MouseMove, wrathX, wrathY,
MouseClick,
Sleep 50,
Send {F},
Sleep 50,
MouseMove, skillX, skillY,
Sleep 50,
MouseClick,
Sleep 50,
MouseMove totemX, totemY,
Sleep 50,
MouseClick
return
}
