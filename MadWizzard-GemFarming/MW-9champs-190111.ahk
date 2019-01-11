#SingleInstance force
;Mad Wizard Gem Farming Script
;by Bootch
;version: 190111(01/11/19)
;original script by Hikibla
;Modified by Carnivorous(https://git.io/fhZ7s) and Caern - 11th January, 2019

;LEVEL DETECTOR GEM FARM
;Resolution Setting 1366x768
;This script is designed to farm gems and automatically progress through low level areas,
;then resetting and starting over the same mission

;----------------
;!!!! ATTENTION: You need at least 3 familiars to run this script for the gold auto-pickup !!!!
;-------------

;HOTKEYS
;	`		: Pauses the Script
;	F1		: (Help) -- Shows ToolTip with HotKey Info
;	F2		: starts the script to farm MadWizard to L30
;	F3		: enables High Roller functionality -- (by default) iterates through Levels 50-90 (10 at time) then resets back to L30
;	F8		: shows stats for the current script run
;	F9		: Reloads the script
;	Up		: used to increase the Target Level by 10
;	DOWN	: used to decrease the Target Level by 10
;	Q/W/E	: will Temporarily Save the Formation Selected (w/ keyboard) till next Script Reset/Reload


#include MW_Settings_1366x768.ahk

;custom settings/defaults
global gFamiliarCount 	:= 7		;number of familiars to use
global gFamiliarDrag  	:= 50		;value in milliseconds to slow down the dragging functions for the familiars
global nMax_Level 		:= 30		;target level to farming gems

;used to determine/find the Town on the World Map
;1 -- waterdeep not unlocked / longsaddle not unlocked
;2 -- waterdeep unlocked / longsaddle not unlocked
;3 -- waterdeep and longsaddle unlocked
global gSwordCoastProgress := 3

;position of the MadWizard Adventure is in Selection List
;with All Adventures Completed and Hide Completed Checked MadWizard will be 4th from the top when scrolled up
;this number may change for some players who have "Locked" or Uncompleted Variants
global gAdventurePosition := 4

;assumes deekein already in 1st slot
;can set to whichever formation you have set up for this script
;if dont want to change it here the script will also Temporarily Save a Formation on Q/W/E KeyPress
;NOTE: will revert back to default Formation on Scipt Reset/Reload
global gFormation := "E"			;Q/W/E (if changing use capital letters)

;High Roller Settings -- will increment target level by 10 till completes the max then defaults back to [nMax_Level]
global nHR_Min 			:= 50		; start HR runs at z50
global nHR_Max 			:= 90		; end HR runs after completing z90
global bAutoHR_Enable	:= 0		; 1 to auto run HR Levels 0 to disable this feature
global nAutoHR_Time 	:= 2		; High Roller Levels will be enabled when game Loops within 15 minutes after this Hour
									; for 2 it will begin HR Levels between 2:01 AM Local Time and 2:15 AM Local Time
									; if Local CST this will be 12:01 AM PST and 12:15 AM PST

;internal globals
global gFound_Error := 0
global gRosterButton := ""			;pixel object to find the click damage button also used often to find champ level up buttons
global gLeftRosterPixel := ""		;pixel object to help in scrolling champ roster left
global gSpecialWindowClose := ""	;pixel object to help determine if Specialization Window is showing
global gSpecialWindowSearch := ""	;pixel object to find green select buttons in the Specialization Windows

global gHR_Enabled := 0
global nHR_CurrentLimit := 50

global dtPrevRunTime := "00:00:00"
global gLevel_Number := 0
global gTotal_RunCount := 0
global gTotal_Bosses := 0
global gTotal_RunTime := "00:00:00"

;get and store the settings for the GameWindow
GetWindowSettings()
Adjust_YValues()
Init()
ShowHelpTip()

return

#IfWinActive Idle Champions
F1::
{
	ShowHelpTip()
	return
}

global gShowHelpTip := ""
ShowHelpTip()
{
	gShowHelpTip := !gShowHelpTip

	if (gShowHelpTip)
	{
		ToolTip, % "F1: Show Help`nF2: Start Gem Farm`nF3: Toggle HR Leveling`nF8: Show Stats`nF9: Reload Script`nUP: +10 to Target Levels`nDOWN: -10 to Target Levels`n``: Pause Script", 25, 350, 3
		SetTimer, ClearToolTip, -5000
	}
	else
	{
		ToolTip, , , ,3
	}
}

#IfWinActive Idle Champions
F2::
{
	Loop_GemRuns()
	return
}

#IfWinActive Idle Champions
F3::
{
	gHR_Enabled := !gHR_Enabled
	nHR_CurrentLimit := nHR_Min
	UpdateToolTip()

	return
}

;holder for running to wall
#IfWinActive Idle Champions
F4::
{
	;RunAdventure()
	return
}

;testing hotkey
;#IfWinActive Idle Champions
F5::
{
	;MoveToPixel(gRosterButton)
	;TestWindowSettings()
	;TestFavorBox()
	;TestTownLocations()
	;TestAdventureSelect()
	TestFindMob()
	;TestAutoProgress()
	;DoFamiliars(6)
	;DoLevel(0)
	;TestRosterButtons()
	;TestUpgradeButtons()
	;AutoLevelChamps(2)
	;LevelUp(0)
	;LevelUp(4)
	;LevelUp(3,5)
	;DoSpecial(3)
	;TestTransition()
	;TestSpecializationWinClose()
	;TestSpecializationSelectButtons()
	;IsNewDay()
	;TestSend()
	return
}

global gLastX := ""
global gLastY := ""
#IfWinActive Idle Champions
F6::
{
	;get current pixel info
	MouseGetPos, outx, outy
    PixelGetColor, oColor, outx, outy, RGB
	sText :=  "Current Pixel`nColor: " oColor "`n" "X,Y: " outx ", " outy
	ToolTip, %sText%, 25, 200, 15

	gLastX := outx
	gLastY := outy

	return
}

#IfWinActive Idle Champions
F7::
{
	;get last pixel info
	nX:= gLastX
	nY:= gLastY

	;nX := reset_complete_x
	;nY := reset_complete_y

	PixelGetColor, oColor, nX, nY, RGB
	Sleep, 500
	MouseMove, nX, nY, 5

	sText :=  "Prev Pixel`nColor: " oColor "`n" "X,Y: " nX ", " nY
	ToolTip, %sText%, 25, 260, 16

	return
}

#IfWinActive Idle Champions
F8::
{
	ShowStatsTip()
	return
}

global gShowStatTip := ""
ShowStatsTip()
{
	gShowStatTip := !gShowStatTip

	if (gShowStatTip)
	{
		nAvgRuntime := 0
		nEstGems := Format("{:i}" , (gTotal_Bosses * 7.5)) ;convert to int
		nAvgRuntime := TimeSpanAverage(gTotal_RunTime, gTotal_RunCount)

		ToolTip, % "Total Time: " gTotal_RunTime "`nAvg Run: " nAvgRuntime "`nRun Count: " gTotal_RunCount "`nBoss Count: " gTotal_Bosses "`nEst. Gems: " nEstGems "*`n* 7.5 per boss", 25, 350, 3
		SetTimer, ClearToolTip, -10000
	}
	else
	{
		ToolTip, , , ,3
	}
}

#IfWinActive Idle Champions
F9::
{
	Reload
	return
}

#IfWinActive Idle Champions
Q::
{
	gFormation := "Q"
	sleep, 100
	send, q
	return
}
#IfWinActive Idle Champions
W::
{
	gFormation := "W"
	sleep, 100
	send, w
	return
}
#IfWinActive Idle Champions
E::
{
	gFormation := "E"
	sleep, 100
	send, e
	return
}

#IfWinActive Idle Champions
Up::
{
	nMax_Level := nMax_Level + 10
	ToolTip, % "Max Level: " nMax_Level, 25, 475, 2
	SetTimer, ClearToolTip, -1000

	UpdateToolTip()

	return
}

#IfWinActive Idle Champions
Down::
{
	nMax_Level := nMax_Level - 10
	ToolTip, % "Max Level: " nMax_Level, 25, 475, 2
	SetTimer, ClearToolTip, -1000

	UpdateToolTip()

	return
}

ClearToolTip:
{
	ToolTip, , , ,2
	ToolTip, , , ,3
	gShowHelpTip := 0
	gShowStatTip := 0
	return
}

;toggle Pause on/off
#IfWinActive Idle Champions
`::
{
	Pause, , 1
	return
}

Adjust_YValues()
{
	;MsgBox, % gWindowSettings.HeightAdjust

	worldmap_favor_y 		:= worldmap_favor_y + gWindowSettings.HeightAdjust
	swordcoast_y 			:= swordcoast_y + gWindowSettings.HeightAdjust
	toa_y 					:= toa_y + gWindowSettings.HeightAdjust
	town_y1 				:= town_y1 + gWindowSettings.HeightAdjust
	town_y2 				:= town_y2 + gWindowSettings.HeightAdjust
	town_y3 				:= town_y3 + gWindowSettings.HeightAdjust
	select_win_y 			:= select_win_y + gWindowSettings.HeightAdjust
	list_top_y 				:= list_top_y + gWindowSettings.HeightAdjust
	mw_adventure1_y 		:= mw_adventure1_y + gWindowSettings.HeightAdjust
	mw_start_y 				:= mw_start_y + gWindowSettings.HeightAdjust
	adventure_dps_y 		:= adventure_dps_y + gWindowSettings.HeightAdjust
	transition_y 			:= transition_y + gWindowSettings.HeightAdjust
	roster_y 				:= roster_y + gWindowSettings.HeightAdjust
	roster_lcheck_y 		:= roster_lcheck_y + gWindowSettings.HeightAdjust
	;special_window_top 		:= special_window_top + gWindowSettings.HeightAdjust
	special_window_bottom 	:= special_window_bottom + gWindowSettings.HeightAdjust
	;special_window_close_t 	:= special_window_close_t + gWindowSettings.HeightAdjust
	special_window_close_b 	:= special_window_close_b + gWindowSettings.HeightAdjust
	autoprogress_y 			:= autoprogress_y + gWindowSettings.HeightAdjust
	;reset_complete_top 		:= reset_complete_top + gWindowSettings.HeightAdjust.
	reset_complete_bottom 	:= reset_complete_bottom + gWindowSettings.HeightAdjust
	reset_continue_y 		:= reset_continue_y + gWindowSettings.HeightAdjust

	fam_1_y := fam_1_y + gWindowSettings.HeightAdjust
	fam_2_y := fam_2_y + gWindowSettings.HeightAdjust
	fam_3_y := fam_3_y + gWindowSettings.HeightAdjust
	fam_4_y := fam_4_y + gWindowSettings.HeightAdjust
	fam_5_y := fam_5_y + gWindowSettings.HeightAdjust
	fam_6_y := fam_6_y + gWindowSettings.HeightAdjust
}

Init()
{
	gFound_Error := 0

	;init click damage button -- rest of the buttons will be based of this positioning
	gRosterButton := {}
	gRosterButton.X := roster_x
	gRosterButton.Y := roster_y
	gRosterButton.Color_1 := roster_c1
	gRosterButton.Color_2 := roster_c2
	gRosterButton.Color_B1 := roster_b1
	gRosterButton.Color_B2 := roster_b2
	gRosterButton.Color_G1 := roster_g1
	gRosterButton.Color_G2 := roster_g2
	gRosterButton.Color_BG1 := roster_bg1
	gRosterButton.Color_BG2 := roster_bg2

	gRosterButton.Spacing := roster_spacing

	gLeftRosterPixel := {}
	gLeftRosterPixel.X := roster_lcheck_x
	gLeftRosterPixel.Y := roster_lcheck_y
	gLeftRosterPixel.Color_1 := roster_lcheck_c1
	gLeftRosterPixel.Color_2 := roster_lcheck_c2

	gSpecialWindowClose := {}
	gSpecialWindowClose.StartX := special_window_close_l
	gSpecialWindowClose.StartY := special_window_close_t
	gSpecialWindowClose.EndX := gWindowSettings.Width
	gSpecialWindowClose.EndY := special_window_close_b
	gSpecialWindowClose.Color_1 := special_window_close_c1

	gSpecialWindowSearch := {}
	gSpecialWindowSearch.StartX := special_window_left
	gSpecialWindowSearch.StartY := special_window_top
	gSpecialWindowSearch.EndX := gWindowSettings.Width
	gSpecialWindowSearch.EndY := special_window_bottom
	gSpecialWindowSearch.Color_1 := special_window_c1
	gSpecialWindowSearch.Spacing := special_window_spacing
}

UpdateToolTip()
{
	sToolTip := "Prev Run: " dtPrevRunTime

	if(gHR_Enabled)
	{
		sToolTip := sToolTip "`nTarget Level: " nHR_CurrentLimit
	}
	else
	{
		sToolTip := sToolTip "`nTarget Level: " nMax_Level
	}

	sToolTip := sToolTip "`nCurrent Level: " gLevel_Number
	sToolTip := sToolTip "`nHigh Rollers: " (gHR_Enabled ? "On (" nHR_Min "-" nHR_Max ")" : "Off")

	ToolTip, % sToolTip, 25, 500, 1
}

Loop_GemRuns()
{
	;fast check for Adventure Running --> will force a reset
	bAdventureWindowFound := AdventureWindow_Check(1)
	if (bAdventureWindowFound)
	{
		ResetAdventure()
	}

	while (!gFound_Error)
	{
		dtStart := A_Now

		dtPrevRunTime := DateTimeDiff(dtPrev, dtStart)

		UpdateToolTip()

		dtPrev := dtStart

		gTotal_RunTime := TimeSpanAdd(gTotal_RunTime, dtPrevRunTime)

		;Set Campaign and Select Adventure if on World Map
		bAdventureSelected := SelectAdventure()

		if (bAdventureSelected)
		{
			;Loop Levels till Target Level Reached
			RunAdventure()
		}

		if(gHR_Enabled)
		{
			if ((nHR_CurrentLimit + 10) <= nHR_Max)
			{
				nHR_CurrentLimit := nHR_CurrentLimit + 10
			}
			else
			{
				gHR_Enabled := 0
			}
		}

		;Start High Roller Levels if just past Specified Time and Auto HR Enabled
		if (bAutoHR_Enable and IsNewDay() and !gHR_Enabled)
		{
			gHR_Enabled := 1
			nHR_CurrentLimit := nHR_Min
			UpdateToolTip()
		}

		bAdventureWindowFound := AdventureWindow_Check(1)
		if (bAdventureWindowFound)
		{
			;Complete the Adventure
			ResetAdventure()
		}

		gTotal_RunCount := gTotal_RunCount + 1

		;the game has an issue with memory leaking, after you do a few resets your gem runs will become slower
		;reset app every few runs to avoid excessive memory leaks
		;mod the number after gTotal_RunCount(currently 20) to change after how many runs the reset will be
		cycle_RunCount := Mod(gTotal_RunCount,20)
		if !cycle_RunCount
		{
			Process, Close, IdleDragons.exe
			run "C:\Program Files (x86)\Steam\SteamApps\common\IdleChampions\IdleDragons.exe"
			WinWait, Idle Champions,
			IfWinNotActive, Idle Champions, , WinActivate, Idle Champions,
			WinWaitActive, Idle Champions,
			Loop, 6
			{
				Click 981, 127
				Sleep, 1000
			}
		}
	}

	ShowToolTip("No Longer Looping Runs")
}

SelectAdventure()
{
	;fast check for Adventure Running --> will force a reset
	bAdventureWindowFound := AdventureWindow_Check(1)
	if (bAdventureWindowFound)
	{
		return 0
	}

	;ensure on the World Map before trying find/click buttons(pixels)
	if (!WorldMapWindow_Check())
	{
		return 0
	}

	; Zooms out campaign map
	town_x := town_x%gSwordCoastProgress%
	town_y := town_y%gSwordCoastProgress%
	Loop 15
    {
        MouseClick, WheelDown, %town_x%, %town_y%
        Sleep 5
    }
	Sleep 100

	;campaign switching to force world map resets/positions

	; Select Tomb of Annihilation
	Click %toa_x%, %toa_y%
	Sleep 100

	; Select A Grand Tour
	Click %swordcoast_x%, %swordcoast_y%
	Sleep 500

	;ensure adventure select window is open
	oSelect_WinChecker := {}
	oSelect_WinChecker.X := select_win_x
	oSelect_WinChecker.Y := select_win_y
	oSelect_WinChecker.Color_1 := select_win_c1

	ctr := 0
	;check 10 times in 5sec intervals for the Adventure Select Window show;
	;server lag can cause issues between clicking the town and selector window displaying
	while (!bFound and ctr < 10)
	{
		;open adventure select window
		Click %town_x%, %town_y%				; Click the town button for mad wizard adventure
		Sleep 100

		;wait for 10 seconds for Selector window to show
		if (WaitForPixel(oSelect_WinChecker, 5000))
		{
			bFound := 1
		}

		ctr := ctr + 1
	}

	if (!bFound)
	{
		;failed to open the selector window in a timely manner
		return
	}

	;ensure adventure select window is scrolled to top
	oListScroll_Checker := {}
	oListScroll_Checker.X := list_top_x
	oListScroll_Checker.Y := list_top_y
	oListScroll_Checker.Color_1 := list_top_c1

	spacing := mw_adventure_spacing
	mw_select_x := mw_adventure1_x
	mw_select_y := mw_adventure1_y 	+ (spacing * (gAdventurePosition - 1))

	MouseMove, %mw_select_x%, %mw_select_y%

	bIsNotAtTop := CheckPixel(oListScroll_Checker)
	while (bIsNotAtTop)
	{
		MouseClick, WheelUp

		bIsNotAtTop := CheckPixel(oListScroll_Checker)

		if (bIsNotAtTop)
		{
			sleep, 50
		}
	}

	;note i had hide completed and locked checked
	;Mad Wizard should be in window at this position
	sleep, 100
	MouseClick, Left, %mw_select_x%, %mw_select_y%

	;click the adventure start button (this position will change per adventure)
	oStart_Adventure_Button := {}
	oStart_Adventure_Button.X := mw_start_x
	oStart_Adventure_Button.Y := mw_start_y
	oStart_Adventure_Button.Color_1 := mw_start_c1

	if(WaitForPixel(oStart_Adventure_Button))
	{
		ClickPixel(oStart_Adventure_Button)
	}

	Return 1
}

RunAdventure()
{
	;allowing for up to 30 seconds (vs the 5 sec default) to find the Adventure Window as server/game lag can cause varying time delays
	bAdventureWindowFound := AdventureWindow_Check(30000)
	if (!bAdventureWindowFound)
	{
		return 0
	}

	;wait for 1st mob to enter screen - wait upto 1min before Fails
	if (FindFirstMob())
	{
		;continue script
	}
	else
	{
		return 0
	}

	;Ensure AutoProgress off to minimize issues with Specialization Windows getting stuck open
	;NOTE: spamming Send, {Right} to manage level progression
	EnableAutoProgress()

	;Place the Set Number Familiars
	;Disabled, do familiars later within level 1
	;DoFamiliars(gFamiliarCount)

	bContinueRun := 1
	gLevel_Number := 1
	UpdateToolTip()

	while (bContinueRun)
	{
		;ShowToolTip("Current Level: " gLevel_Number)

		bRunComplete := DoLevel(gLevel_Number)
		if (bRunComplete)
		{
			gLevel_Number := gLevel_Number + 1

			UpdateToolTip()

			if (gHR_Enabled and gLevel_Number > nHR_CurrentLimit)
			{
				bContinueRun := 0
			}
			else if (!gHR_Enabled and gLevel_Number > nMax_Level)
			{
				bContinueRun := 0
			}
		}
		else
		{
			bContinueRun := 0
		}
	}
}

FindFirstMob()
{
	pixWhite := {}
	pixWhite.StartX := mob_name_left
	pixWhite.EndX 	:= mob_name_right
	pixWhite.StartY := mob_name_top
	pixWhite.EndY 	:= mob_name_bottom

	pixWhite.Color_1 := mob_name_color

	bFound := 0

	;NOTE: WaitForPixel() -- default performs search 4 times a second for 1 minute (240 times over 1 minute)
	bFound := WaitForFindPixel(pixWhite, outX, outY)

	return bFound
}

EnableAutoProgress()
{
	pixAutoProgress := {}
	pixAutoProgress.X := autoprogress_x
	pixAutoProgress.Y := autoprogress_y
	pixAutoProgress.Color_1 := autoprogress_c1

	;checks against White Color
	if (CheckPixel(pixAutoProgress))
	{
		;Auto Progress is off .. transitions handled by Right Arrow Spamming
	}
	else
	{
		;disable AutoProgress if on
		Send, g
	}
}

DoLevel(nLevel_Number)
{
	;new run Level 1
	if (nLevel_Number = 1)
	{
		;place three familiars
		PlaceFamiliar(1) ;familiar in familiar roster for pickups etc
		PlaceFamiliar(2) ;familiar in familiar roster for pickups etc
		PlaceFamiliar(3) ;familiar in familiar roster for pickups etc

		;Wait for 10 seconds for the 1st Gold Gains then Level Deek to L90 for ability
		if (!WaitForPixel(gRosterButton, 10000))
		{
			;took too long to find the Green ClickDamageButton - reset and try again
			;ToolTip, % "Failed to find the Click Damage Button", 50, 300, 10
			return 0
		}
		;Level Deekin up to confidence in the boss, avoid ultimate
		LevelUp(1, 9)

		;Max Click Damage on 1st Level and then add remaining familiars
		LevelUp(0)
		if (gFamiliarCount < 8)
		{
			PlaceFamiliar(7) ;click damage button familiar placement
			PlaceFamiliar(4) ;familiar in familiar roster for pickups etc
			PlaceFamiliar(5) ;familiar in familiar roster for pickups etc

		}

		if (gFamiliarCount = 7){
			PlaceFamiliar(6)
		}


	}

  ; !!!!! All of the above values for LevelUp can be adjusted depending on your Torm TestFavorBox
	; The first integer is the champion slot and the second one is how many times it will be leveled while using the UPG leveling method
	; for example look at Celeste's leveling up below - LevelUp(2,7) || 2 is the slot number for Celeste and 7 is how many times she will get upgraded
	; You can adjust these values for each champion or even create new blocks of code for other leveling up Functionality


	;Level Celeste up to her ultimate
	if (nLevel_Number = 2)
	{
		LevelUp(2, 7)
	}

	;Level Stoki to ultimate
	if (nLevel_Number = 4)
	{
		LevelUp(4, 5)
	}

	;Level Asharra up to specialization
	if (nLevel_Number = 7)
	{
		LevelUp(6, 2)
	}

	;Add Farideh, avoid ultimate or upgrades (too expensive to extra attack)
	;Level Binwin up to crash and smash, avoid ultimate
	;Level Dhadius halfway to specialization
	if (nLevel_Number = 8)
	{
		LevelUp(7, 1)
		Sleep, 1000
		LevelUp(3, 12)
		Sleep, 3000
		LevelUp(5, 9)
	}

	;Remove click damage familiar temporarily to gain more gold
	;Level Birdsong to extra attack
	if (nLevel_Number = 9)
	{
		PlaceFamiliar(7)
		champ_number := 9
		nX := gRosterButton.X + (gRosterButton.Spacing * champ_number)
		nY := gRosterButton.Y
		champ_button := gRosterButton.Clone()
		champ_button.X := nX
		Loop, 4
		{
			ClickPixel(champ_button)
			Sleep, 10
		}
	}

	;Level Hitch halfway to extra attacks
	if (nLevel_Number = 10)
	{
		LevelUp(8, 10)
	}

	;Level Dhadius to specialization
	if (nLevel_Number = 11)
	{
		LevelUp(5, 9)
	}

	;Level Asharra up to extra attack
	if (nLevel_Number = 12)
	{
		LevelUp(6, 8)
	}

	;Level Dhadius to ultimate
	;Level Hitch as much as possible towards extra attacks
	;Restore click damage familiar
	if (nLevel_Number = 13)
	{
		LevelUp(5, 7)
		Sleep, 2000
		LevelUp(8, 12)
		PlaceFamiliar(7)
	}

	;Adjust formation
	Send, %gFormation%

	;get wave number 1-5
	nWaveNumber := Mod(nLevel_Number, 5)

	;Spam ultimates in level 14
	DoLevel_MW(nLevel_Number)

	bContinueWave := 1
	while (bContinueWave)
	{
		IfWinActive, Idle Champions
		{
			Send, {Right}
		}
		else
		{
			return
		}

		bFoundTransition := CheckTransition()
		if (bFoundTransition)
		{
			;wait for black pixel to pass this point
			while(CheckTransition())
			{
				sleep, 100
			}
			bContinueWave := 0
		}
		sleep, 100
	}

	if (bFoundTransition)
	{
		;completed a boss level
		if (nWaveNumber = 0)
		{
			gTotal_Bosses := gTotal_Bosses + 1
		}

		return 1
	}
	else
	{
		return 0
	}
}

DoLevel_MW(nLevel_Number)
{
	;spam ults for Levels 14/64/...
	nSpecial_Level := Mod(nLevel_Number, 50)
	if (nSpecial_Level = 14)
	{
		sleep, 500
		Loop, 9
		{
			Send, 1235
			Sleep, 100
		}
	}
}

ResetAdventure()
{
	pixReset_Complete := {}
	pixReset_Complete.StartX 	:= reset_complete_left
	pixReset_Complete.EndX 		:= reset_complete_right
	pixReset_Complete.StartY 	:= reset_complete_top
	pixReset_Complete.EndY 		:= reset_complete_bottom

	pixReset_Complete.Color_1 := reset_complete_c1

	pixReset_Continue := {}
	pixReset_Continue.X := reset_continue_x
	pixReset_Continue.Y := reset_continue_y
	pixReset_Continue.Color_1 := reset_continue_c1

	IfWinActive, Idle Champions
	{
		Send, R
	}
	else
	{
		return
	}

	bFound := 0

	;NOTE: WaitForPixel() -- default performs search 4 times a second for 1 minute (240 times over 1 minute)
	if (WaitForFindPixel(pixReset_Complete, outX, outY))
	{
		;NOTE: this will be tend to be up right corner (just move down and right a bit)
		oClickPixel := {}
		oClickPixel.X := outX + 5
		oClickPixel.Y := outY + 5

		bFound := 1
		ClickPixel(oClickPixel)
	}

	if (bFound and WaitForPixel(pixReset_Continue))
	{
		bFound := 2
		ClickPixel(pixReset_Continue)
	}
	return bFound
}

WorldMapWindow_Check()
{
	oCornerPixel := {}
	oCornerPixel.X := worldmap_favor_x
	oCornerPixel.Y := worldmap_favor_y

	oCornerPixel.Color_1 := worldmap_favor_c1
	;for legacy settings file
	if (worldmap_favor_c)
	{
		oCornerPixel.Color_1 := worldmap_favor_c
	}
	oCornerPixel.Color_2 := worldmap_favor_c2

	;wait for up to 5 second with 4 checks per second for the Target Pixel to show
	if (!WaitForPixel(oCornerPixel, 5000))
	{
		;CheckPixelInfo(oCornerPixel)
		;ShowToolTip("ERROR: Failed to find World Map in a Timely Manner.")
		return 0
	}
	return 1
}

;allowing for up to 5 seconds (as default) to find the Adventure Window
AdventureWindow_Check(wait_time := 5000)
{
	;redish pixel in the Gold/Dps InfoBox while an adventure is running
	adventure_window_pixel := {}
	adventure_window_pixel.X := adventure_dps_x
	adventure_window_pixel.Y := adventure_dps_y
	adventure_window_pixel.Color_1 := adventure_dps_c1

	;wait for up to 5 second with 4 checks per second for the Target Pixel to show
	if (!WaitForPixel(adventure_window_pixel, wait_time))
	{
		;ShowToolTip("ERROR: Failed to find Adventure Window in a Timely Manner.")
		return 0
	}
	return 1
}

;Level Transition Check
gTransitionPixel_Left := ""
gTransitionPixel_Right := ""
CheckTransition()
{
	if (!gTransitionPixel_Left)
	{
		gTransitionPixel_Left := {}
		gTransitionPixel_Left.X := 10
		gTransitionPixel_Left.Y := transition_y
		gTransitionPixel_Left.Color_1 := transition_c1
	}

	if (!gTransitionPixel_Right)
	{
		gTransitionPixel_Right := {}
		gTransitionPixel_Right.X := gWindowSettings.Width - 10
		gTransitionPixel_Right.Y := transition_y
		gTransitionPixel_Right.Color_1 := transition_c1
	}

	return (CheckPixel(gTransitionPixel_Left) or CheckPixel(gTransitionPixel_Right))
}

;Roster/Champ Functions
AutoLevelChamps(level_number := 0)
{
	;Level up the 1st 9 champs (5 levels at a time)
	MaxChampNumber := 9

	;Champ to level
	nChamp_level := Mod(nLevel_Number,MaxChampNumber)

	;Level champ
	LevelUp(nChamp_level,15)

	if (level_number)
	{
		ctr := 1
		is_even_level := (Mod(level_number, 2) = 0)
		if (is_even_level)
		{
			ctr := ctr + 1
		}

		while ctr < MaxChampNumber
		{
			LevelUp(ctr, 5)
			ctr := ctr + 2
		}
	}
	else
	{
		loop, MaxChampNumber
		{
			LevelUp(A_Index, 5)
		}
	}

	CenterMouse()

	return
}

;Levels/unlocks a champion or click damage
LevelUp(champ_number, num_clicks := 1)
{
	;max level up - click damage
	if (champ_number = 0)
	{
		ScrollRosterLeft()

		ClickPixel(gRosterButton, "MAX")
		return
	}

	;Specialization option is 0 or -1 (ie dont use this champ)
	nSpecialOption := Champ%champ_number%_SpecialOption%gFormation%
	if (nSpecialOption < 1)
	{
		return
	}

	;TODO: Add Scroll Right Functionality so get Champs on the Right
	if (champ_number < 9)
	{
		ScrollRosterLeft()
	}
	else
	{
		return
	}

	nX := gRosterButton.X + (gRosterButton.Spacing * champ_number)
	nY := gRosterButton.Y

	;get a fresh copy of ClickDamageButton (so dont alter values of the Original Object)
	;all properties of the champ buttons are same except for its X value (so only update this property)
	champ_button := gRosterButton.Clone()
	champ_button.X := nX

	;current champ button not green go to next champ
	if (!CheckPixel(champ_button))
	{
		;ToolTip, % "champ not ready -- " champ_number , 50, (200 + (25 * champ_number)) , (10 + champ_number)
		Return
	}

	bGreyCheck := 0
	ctr := 0

	;spam clicks till Click Count reached or Button Greys out
	while (!bGreyCheck and ctr < num_clicks)
	{
		ClickPixel(champ_button)
		sleep, 100

		bGreyCheck := CheckGreyPixel(champ_button)
		ctr := ctr + 1
	}

	;ensure the Game UI has completed the clicks
	;Game has a slight delay between Click and UI updating
	while (!bFound1)
	{
		if (CheckGreyPixel(champ_button) or CheckPixel(champ_button))
		{
			bFound1 := 1
		}
		else
		{
			sleep, 100
		}
	}

	;upgrade button is relative to the champ_button
	up_button := {}
	up_button.X := nX + roster_upoff_x
	up_button.Y := nY + roster_upoff_y
	up_button.Color_1 := roster_up_c1
	up_button.Color_2 := roster_up_c2
	up_button.Color_G1 := roster_up_g1
	up_button.Color_G2 := roster_up_g2

	;check if Special Window is showing before continuing
	while (!bFound2 and bFound1)
	{
		;upgrade button is Grey
		if (CheckGreyPixel(up_button))
		{
			bFound2 := 1
		}
		;upgrade button is purple
		if (CheckPixel(up_button))
		{
			DoSpecial(champ_number)
		}
		sleep, 100
	}
	Return
}

ScrollRosterLeft()
{
	;scroll roster left as required
	nX := gWindowSettings.Width / 2
	nY := roster_y - 20

	bScrollRequired := !CheckPixel(gLeftRosterPixel)
	if (bScrollRequired)
	{
		MouseMove, nX, nY
		sleep, 100
	}

	while (bScrollRequired)
	{
		MouseClick, WheelUp, nX, nY
		bScrollRequired := !CheckPixel(gLeftRosterPixel)
		sleep, 5
	}
}

DoSpecial(champ_number)
{
	nSpecialOption := Champ%champ_number%_SpecialOption%gFormation%

	ctr := 0
	timer := 10000 ;10 seconds
	interval := 100 ;10 times a second
	bFound := 0
	prevX := 0
	prevY := 0

	;look for Red Pixel in the Close Button of the Specialization Window and Ensure it has stopped moving
	while (ctr < timer and !bFound)
	{
		ctr :=  ctr + interval

		if (FindPixel(gSpecialWindowClose, foundX, foundY))
		{
			if (prevX = foundX and prevY = foundY)
			{
				bFound := 1
			}
			else
			{
				;found pixel but still moving
				prevX := foundX
				prevY := foundY
				sleep, %interval%
			}
		}
		else
		{
			sleep, %interval%
		}
	}

	if (bFound)
	{
		;find a Green Pixel for the First Select Button
		if (FindPixel(gSpecialWindowSearch, foundX, foundY))
		{
			bFound := 1
		}
		else
		{
			bFound := 0
		}

	}
	else
	{
		ToolTip, failed to find red, 50,200, 5
	}

	if (bFound)
	{
		nX := foundX + ((nSpecialOption - 1) * gSpecialWindowSearch.Spacing) + 5
		nY := foundY + 5

		;clicked special
		MouseClick, Left, nX, nY

		;wait for Specialization Window to Slide off Screen
		while(FindPixel(gSpecialWindowSearch, foundX, foundY))
		{
			sleep, %interval%
		}

		return 1
	}
	else
	{
		ToolTip, failed to find green, 50,225, 6
		;MsgBox,%  "Error failed to find Pixel for Special Window --" gSpecialWindowSearch.Color_1 " -- " gSpecialWindowSearch.StartX ", " gSpecialWindowSearch.StartY " -- " gSpecialWindowSearch.EndX ", " gSpecialWindowSearch.EndY
	}

	return 0
}
;END Roster Functions

;Familiar functions
DoFamiliars(fam_count)
{
 ;this function is currently not being used
	loop, %fam_count%
	{
		PlaceFamiliar(A_Index)
	}
	return
}

; this is the function which places familiars, it is called directly with a location
PlaceFamiliar(fam_slot)
{
	nX := fam_%fam_slot%_x
	nY := fam_%fam_slot%_y

	MouseMove, nX, nY
	sleep, 50
	Send, {F down}
	Click
	sleep, 50
		;Send, {F up }
		;sleep, 50
	Send, F
}

PlaceFamiliar_OLD(fam_slot)
{
	;recheck the position of the Familiar if invalid -> reset button
	if (!CheckPixel(gFamRoster))
	{
		FindFamiliarRoster()
	}

	nX := fam_%fam_slot%_x
	nY := fam_%fam_slot%_y

	;move mouse to the Familiar Roster Button and pause for game to register new mouse poistion
	MoveToPixel(gFamRoster)
	sleep, gFamiliarDrag 	;default 50

	;click and hold Left Mouse Down (start dragging) and pause for game to register left mouse is down
	Click, Down
	sleep, gFamiliarDrag	;default 50

	;move mouse to the current Familiar Location and pause for game to register new mouse poistion
	MouseMove, nX, nY
	sleep, gFamiliarDrag	;default 50

	;release mouse ie drop familiar on spot and pause for game to register left mouse is up
	Click, Up
	sleep, gFamiliarDrag	;default 50
}

global gFamRoster := ""
FindFamiliarRoster()
{
	gFamRoster := ""

	froster_button := {}
	froster_button.StartX 	:= 0
	froster_button.StartY 	:= fam_roster_top
	froster_button.EndX 	:= gWindowSettings.Width
	froster_button.EndY		:= fam_roster_bottom
	froster_button.Color_1	:= fam_roster_c1

	bFound := FindPixel(froster_button, foundX, foundY)
	if (bFound)
	{
		froster_button.X := foundX
		froster_button.Y := foundY

		gFamRoster := froster_button
	}
}
;END Familiar Funcitons

CenterMouse()
{
	nX := gWindowSettings.Width / 2
	nY := gWindowSettings.Height / 2
	MouseMove, nX, nY

	Return
}

;Helper Functions
ClickPixel(oPixel, num_clicks := 1)
{
	MoveToPixel(oPixel)
	sleep, 10

	if (num_clicks = "MAX")
	{
		Send, {Control down}
		sleep, 5
		Click
		sleep, 5
		Send, {Control up}
	}
	else
	{
		loop, %num_clicks%
		{
			Click
			sleep, 5
		}
	}
}

MoveToPixel(oPixel)
{
	nX := oPixel.X
	nY := oPixel.Y

	IfWinActive, Idle Champions
	{
		MouseMove, nX, nY
	}
}

CheckPixel(oPixel)
{
	nX := oPixel.X
	nY := oPixel.Y
	sColor_1 := oPixel.Color_1
	sColor_2 := oPixel.Color_2
	sColor_B1 := oPixel.Color_B1
	sColor_B2 := oPixel.Color_B2

	PixelGetColor, oColor, nX, nY, RGB

	;NOTE: that pure black compares are tricky as same as null and can lead to false positives
	bFound := 0

	bFound := ((oColor = sColor_1) or bFound)

	if (sColor_2)
	{
		bFound :=((oColor = sColor_2) or bFound)
	}
	if (sColor_B1)
	{
		bFound := ((oColor = sColor_B1) or bFound)
	}
	if (sColor_B2)
	{
		bFound := ((oColor = sColor_B2) or bFound)
	}

	if(bFound)
	{
		return 1
	}
	else
	{
		;MsgBox, % sColor_1 " -- " sColor_2 " -- " sColor_B1 " -- " sColor_B2 " EOL"
		return 0
	}
}

CheckGreyPixel(oPixel)
{
	nX := oPixel.X
	nY := oPixel.Y
	sColor_1 := oPixel.Color_G1
	sColor_2 := oPixel.Color_G2
	sColor_B1 := oPixel.Color_BG1
	sColor_B2 := oPixel.Color_BG2

	PixelGetColor, oColor, nX, nY, RGB

	bFound := 0

	bFound := ((oColor = sColor_1) or bFound)

	if (sColor_2)
	{
		bFound :=((oColor = sColor_2) or bFound)
	}
	if (sColor_B1)
	{
		bFound := ((oColor = sColor_B1) or bFound)
	}
	if (sColor_B2)
	{
		bFound := ((oColor = sColor_B2) or bFound)
	}

	if(bFound)
	{
		return 1
	}
	else
	{
		;MsgBox, % sColor_1 " -- " sColor_2 " -- " sColor_B1 " -- " sColor_B2 " EOL"
		return 0
	}
}

;searchs for a Pixel within a Defined Rectangle
FindPixel(oPixel, ByRef foundX, ByRef foundY)
{
	nStartX := oPixel.StartX
	nStartY := oPixel.StartY
	nEndX := oPixel.EndX
	nEndY := oPixel.EndY

	if (!nStartX)
		nStartX := 0
	if (!nStartY)
		nStartY := 0
	if (!nEndX)
		nEndX := gWindowSettings.Width
	if (!nEndY)
		nEndY := gWindowSettings.Height

	bFound := 0
	PixelSearch, foundX, foundY,  nStartX, nStartY, nEndX, nEndY, oPixel.Color_1, ,Fast|RGB
	if ErrorLevel = 1
	{
		;MsgBox, Error 1
	}
	else if ErrorLevel = 2
	{
		;MsgBox, Error 2
	}
	else
	{
		;MsgBox, % "Found: " foundX ", " foundY "`nTop: " nStartX ", " nStartY "`nBottom: " nEndX ", " nEndY
		bFound := 1
	}
	return bFound
}

;default 4 times a second for 1 minute (240 times over 1 minute)
WaitForPixel(oPixel, timer := 60000, interval := 250)
{
	ctr := 0
	while (ctr < timer)
	{
		ctr :=  ctr + interval
		if (CheckPixel(oPixel))
		{
			return 1
		}

		sleep, %interval%
	}
	return 0
}

;default 4 times a second for 1 minute (240 times over 1 minute)
WaitForFindPixel(oPixel, ByRef foundX, ByRef foundY, timer := 60000, interval := 250)
{
	ctr := 0
	while (ctr < timer)
	{
		ctr :=  ctr + interval
		if (FindPixel(oPixel, foundX, foundY))
		{
			return 1
		}

		sleep, %interval%
	}
	return 0
}

CheckPixelInfo(oPixel)
{
	if WinExist("Idle Champions")
	{
		WinActivate
	}

	PixelGetColor, oColor, oPixel.X, oPixel.Y, RGB
	oPixel.FoundColor := oColor + 0 ;force convert to int

	ToolTip, % "Color Found: " oPixel.FoundColor "`nSearch: " oPixel.X ", " oPixel.Y "`nC1: " oPixel.Color_1 "`nC2: " oPixel.Color_2 "`nG1: " oPixel.Color_G1 "`nG2: " oPixel.Color_G2, 50, 200, 18

	sleep, 250
	MoveToPixel(oPixel)
}

global gWindowSettings := ""
GetWindowSettings()
{
	if (!gWindowSettings)
	{
		if WinExist("Idle Champions")
		{
			WinActivate
			WinGetPos, outWinX, outWinY, outWidth, outHeight, Idle Champions

			gWindowSettings := []
			gWindowSettings.X := outWinX
			gWindowSettings.Y := outWinY
			gWindowSettings.Width := (outWidth - 1)
			gWindowSettings.Height := (outHeight - 1)
			gWindowSettings.HeightAdjust := (outHeight - gWindowHeight_Default)

			;MsgBox, % "error init window (this) -- " this.Width ", " this.Height " -- " this.X ", " this.Y
		}
		else
		{
			MsgBox Idle Champions not running
			return
		}
	}

	return gWindowSettings
}


global sToolTip := ""
ShowToolTip(sText := "")
{
	if (!sText)
	{
		sToolTip := ""
	}

	dataitems := StrSplit(sToolTip, "`n")
	nCount := dataitems.Count()
	sToolTip := ""

	nMaxLineCount := 5
	if (nCount > nMaxLineCount)
	{
		nCtr := nCount - nMaxLineCount
	}
	else
	{
		nCtr := 1
	}

	while (nCtr <= nCount)
	{
		if (nCtr = 1)
		{
			sToolTip := dataitems[nCtr]
		}
		else if (nCtr > 1)
		{
			sToolTip := sToolTip "`n" dataitems[nCtr]
		}
		nCtr := nCtr + 1
	}

	if (sToolTip)
	{
		sToolTip := sToolTip  "`n"  sText
	}
	else
	{
		sToolTip := sText
	}

	ToolTip, % sToolTip, 50, 150, 19
	return
}

IsNewDay()
{
	nHour_Now := 	A_Hour ;midnight is 00
	nMin_Now := 	A_Min
	nSec_Now := 	A_Sec
	;ToolTip, % "H:" nHour_Now " M:" nMin_Now " S:" nSec_Now " IsTrue: " (nHour_Now = (10 + nTimeZoneOffset) and nMin_Now > 0 and nMin_Now < 30) , 50, 100, 5

	;by default a New Day is flagged in 2:01AM to 2:15 range (CST)
	return (nHour_Now = nAutoHR_Time and nMin_Now > 0 and nMin_Now < 16)
}

;return String HH:mm:ss of the timespan
DateTimeDiff(dtStart, dtEnd)
{
	dtResult := dtEnd

	EnvSub, dtResult, dtStart, Seconds

	nSeconds := Mod(dtResult, 60)
	nMinutes := Floor(dtResult / 60)
	nHours := Floor(nMinutes / 60)
	nMinutes := Mod(nMinutes, 60)

	sResult := (StrLen(nHours) = 1 ? "0" : "") nHours ":" (StrLen(nMinutes) = 1 ? "0" : "") nMinutes ":" (StrLen(nSeconds) = 1 ? "0" : "") nSeconds

	return sResult
}

TimeSpanAdd(ts1, ts2)
{
	time_parts1 := StrSplit(ts1, ":")
	time_parts2 := StrSplit(ts2, ":")

	t1_seconds := (((time_parts1[1] * 60) + time_parts1[2]) * 60) + time_parts1[3]
	t2_seconds := (((time_parts2[1] * 60) + time_parts2[2]) * 60) + time_parts2[3]

	dtResult := t1_seconds + t2_seconds

	nSeconds := Mod(dtResult, 60)
	nMinutes := Floor(dtResult / 60)
	nHours := Floor(nMinutes / 60)
	nMinutes := Mod(nMinutes, 60)

	sResult := (StrLen(nHours) = 1 ? "0" : "") nHours ":" (StrLen(nMinutes) = 1 ? "0" : "") nMinutes ":" (StrLen(nSeconds) = 1 ? "0" : "") nSeconds

	return sResult
}

TimeSpanAverage(ts1, nCount)
{
	time_parts1 := StrSplit(ts1, ":")

	t1_seconds := (((time_parts1[1] * 60) + time_parts1[2]) * 60) + time_parts1[3]

	if (!nCount)
	{
		return "00:00:00"
	}

	dtResult := t1_seconds / nCount

	nSeconds := Floor(Mod(dtResult, 60))
	nMinutes := Floor(dtResult / 60)
	nHours := Floor(nMinutes / 60)
	nMinutes := Mod(nMinutes, 60)

	sResult := (StrLen(nHours) = 1 ? "0" : "") nHours ":" (StrLen(nMinutes) = 1 ? "0" : "") nMinutes ":" (StrLen(nSeconds) = 1 ? "0" : "") nSeconds

	return sResult
}

TestWindowSettings()
{
	nX := gWindowSettings.X
	nY := gWindowSettings.Y
	nW := gWindowSettings.Width
	nH := gWindowSettings.Height

	ToolTip, % "Window Size" "`nX, Y: " nX ", " nY "`nW,H: " nW ", " nH, 50, 100, 5
	return
}

TestFavorBox()
{
	nX := worldmap_favor_x
	nY := worldmap_favor_y

	PixelGetColor, oColor1, nX, nY, RGB

	MouseMove, nX, nY
	sleep, 1000

	ToolTip, % "Favor Info -- Color: " oColor1 , 50, 100, 5
}

TestAutoProgress()
{
	nX := autoprogress_x
	nY := autoprogress_y
	spacing := roster_spacing

	MouseMove, nX, nY
	sleep, 1000

	PixelGetColor, oColor, nX, nY, RGB
	ToolTip, % "Auto Progress -- Color: " oColor , 50, 100, 5

}

TestFindMob()
{
	pixWhite := {}
	pixWhite.StartX := mob_name_left
	pixWhite.EndX 	:= mob_name_right
	pixWhite.StartY := mob_name_top
	pixWhite.EndY 	:= mob_name_bottom
	pixWhite.Color_1 := mob_name_color

	MouseMove, pixWhite.StartX, pixWhite.StartY, 25
	MouseMove, pixWhite.EndX, pixWhite.StartY, 25
	MouseMove, pixWhite.EndX, pixWhite.EndY, 25
	MouseMove, pixWhite.StartX, pixWhite.EndY, 25
	MouseMove, pixWhite.StartX, pixWhite.StartY, 25

	;NOTE: WaitForPixel() -- default performs search 4 times a second for 1 minute (240 times over 1 minute)
	if (WaitForFindPixel(pixWhite, outX, outY))
	{
		bFound := 1
	}

	if (bFound)
	{
		ToolTip, Found, 50, 100, 5
	}
	else
	{
		ToolTip, Error, 50, 100, 5
	}


}

TestRosterButtons()
{
	nX := roster_x
	nY := roster_y
	spacing := roster_spacing

	PixelGetColor, oColor1, nX, nY, RGB

	MouseMove, nX, nY
	sleep, 1000

	PixelGetColor, oColor, nX, nY, RGB
	ToolTip, % "Champ Num: Click DMG -- Color Before: " oColor1 " Color After: " oColor , 50, 100, 5

	loop, 9
	{
		nX := roster_x + (A_Index * spacing)

		PixelGetColor, oColor1, nX, nY, RGB

		MouseMove, nX, nY
		sleep, 1000

		PixelGetColor, oColor, nX, nY, RGB
		ToolTip, % "Champ Num: " A_Index " -- Color Before: " oColor1 " Color After: " oColor , 50, 100 + (A_Index * 25), (5 + A_Index)
	}
	return
}

TestUpgradeButtons()
{
	spacing := roster_spacing

	loop, 9
	{
		nX := roster_x + (A_Index * spacing) + roster_upoff_x
		nY := roster_y + roster_upoff_y

		PixelGetColor, oColor1, nX, nY, RGB

		MouseMove, nX, nY
		sleep, 1000

		PixelGetColor, oColor, nX, nY, RGB
		ToolTip, % "Champ Num: " A_Index " -- Color Before: " oColor1 " Color After: " oColor , 50, 100 + (A_Index * 25), (5 + A_Index)
	}
	return
}

TestTownLocations()
{
	loop, 3
	{
		nX := town_x%A_Index%
		nY := town_y%A_Index%

		MouseMove, nX, nY
		sleep, 1000
	}
	return
}

TestAdventureSelect()
{
	nX := mw_adventure1_x		;:= 405		; position of the Mad Wizard button in the list selection
	nY := mw_adventure1_y		;:= 280		;380
	spacing := mw_adventure_spacing

	loop, %gAdventurePosition%
	{
		MouseMove, nX, (nY + ((A_Index - 1) * spacing))
		sleep, 1000
	}

	return
}

TestTransition()
{
	bResult := CheckTransition()
	if (bResult)
	{
		ToolTip, % "Success found black Transition", 50, 100, 5
	}
	else
	{
		nX := gTransitionPixel.X
		nY := gTransitionPixel.Y

		ToolTip, % "ERROR: failed to find black Transition ---" nX ", " nY, 50, 100, 5
		MouseMove, nX, nY
	}
	return
}

TestSpecializationWinClose()
{
	if (FindPixel(gSpecialWindowClose, foundX, foundY))
	{
		ToolTip, % "Success found Close Button", 50, 100, 5
		return
	}

	nLeft :=	gSpecialWindowClose.StartX
	nRight :=	gSpecialWindowClose.EndX
	nTop := 	gSpecialWindowClose.StartY
	nBottom :=	gSpecialWindowClose.EndY

	MouseMove, nLeft, nTop, 15
	sleep, 500
	MouseMove, nRight, nTop, 15
	sleep, 500
	MouseMove, nRight, nBottom, 15
	sleep, 500
	MouseMove, nLeft, nBottom,15
	sleep, 500
	MouseMove, nLeft, nTop, 15
	sleep, 500

	return
}

TestSpecializationSelectButtons()
{
	if (FindPixel(gSpecialWindowSearch, foundX, foundY))
	{
		ToolTip, % "Success found 1st Green Button", 50, 100, 5
		;return
	}

	nLeft :=	gSpecialWindowSearch.StartX
	nRight :=	gSpecialWindowSearch.EndX
	nTop := 	gSpecialWindowSearch.StartY
	nBottom :=	gSpecialWindowSearch.EndY

	MouseMove, nLeft, nTop, 15
	sleep, 500
	MouseMove, nRight, nTop, 15
	sleep, 500
	MouseMove, nRight, nBottom, 15
	sleep, 500
	MouseMove, nLeft, nBottom,15
	sleep, 500
	MouseMove, nLeft, nTop, 15
	sleep, 500

	return
}

TestSend()
{
	wintitle = Idle Champions
	SetTitleMatchMode, 2

	;ahk_class UnityWndClass
	;ahk_exe IdleDragons.exe

	Loop
	{
		ControlSend, , T, ahk_exe IdleDragons.exe
		sleep, 1000
	}

	;IfWinExist %wintitle%
	;{
	;	ToolTip, here, 50, 50, 17
        ;Controlsend,,T, ahk_id IdleDragons.exe  ; <-- this is the proper format
		;Controlsend,,T, ahk_class UnityWndClass  ; <-- this is the proper format
	;	Send T
    ;    sleep 500
	;}
	Return
}
