;NOTES / Potential Issues
;these values are based on the gaming running at 1366x768 (windowed)
;Having Title Bar turned off will create a shift in the Y values and Script wont be able find several Locations (Jadisero)
;values may not match if running game full screen

;design window sizes
global gWindowWidth_Default 	:= 1372
global gWindowHeight_Default	:= 797

;campaign buttons/locations
global worldmap_favor_x := 1335			; pixel in favor box (top right of world map screen)
global worldmap_favor_y := 120
global worldmap_favor_c1 := 0x242423
global worldmap_favor_c2 := 0x262625	;second color added due to correct for error when last campaign was an Event
							;212121 (IzHaN)
							;252524	(IzHaN)

global swordcoast_x	:= 50				; horizontal location of the tomb button
global swordcoast_y	:= 125				; vertical location of the tomb button
global toa_x 		:= 50				; horizontal location of the sword coast button
global toa_y		:= 200				; vertical location of the sword coast button

;----------------------------
;these are the different position of the town for the MadWizard adventures
;the position used is based on gSwordCoastProgress in MadWizard.ahk
;Sword Coast Town with Mad Wizard Adventure
;----------------------------
;gSwordCoastProgress := 1 -- waterdeep not unlocked / longsaddle not unlocked
global town_x1		:= 790
global town_y1		:= 275

;gSwordCoastProgress := 2 -- waterdeep unlocked / longsaddle not unlocked (thx H3llscr3am)
global town_x2		:= 800
global town_y2		:= 275

;gSwordCoastProgress := 3 -- waterdeep and longsaddle unlocked
global town_x3		:= 795
global town_y3		:= 500

global select_win_x 	:= 1085				; red pixel for the Close Button on the Adventure Select window
global select_win_y 	:= 120
global select_win_c1	:= 0x8E0303

global list_top_x		:= 590				; pixel to check if list is scrolled to the top (if valid then list needs to scroll up)
global list_top_y		:= 137
global list_top_c1		:= 0x0A0A0A

;----------------------------
;these values are used in conjunction with gAdventurePosition in MadWizard.ahk
;gAdventurePosition may change pending if still progressing through Sword Coast Campaign
;
;NOTE: 	current code expects the Mad Wizard FP to be in view when List is Scrolled to the Top
;		may need to click Hide Locked/Completed to accomplish this (thx Echo)
;
;		newer players (or players who skip variants) may need to change the gAdventurePosition value
;		as position the MadWizard Free Play Selection position will change as Variants are completed/unlocked
;		for players who've completed Mad Wizard and Cursed Farmer + variants -- Hide Completed and gAdventurePosition := 4 should be correct
;----------------------------
global mw_adventure1_x		:= 405		; position of the Mad Wizard Cursed Farmer Adventure in the list selection
global mw_adventure1_y		:= 150
global mw_adventure_spacing := 85		; approximate spacing of the Selections	;83 (IzHaN)

global mw_start_x	:= 770				; position of the Start Adventure button for Mad Wizard (note this changes based on selected adventure)
global mw_start_y	:= 610				; but currently is always MadWizard so no extra code
global mw_start_c1	:= 0x467EC1

;adventure window pixel (redish pixel in the Redish Flag behind the gold coin in the DPS/Gold InfoBox)
global adventure_dps_x	:= 75
global adventure_dps_y	:= 35
global adventure_dps_c1	:= 0x90181C

;search box for 1st mob
global mob_name_color 	:= 0xFEFEFE
global mob_name_top		:= 175
global mob_name_bottom	:= 600
global mob_name_left	:= 1300
global mob_name_right	:= 1325

; variables for checking if a transition is occuring (center of screen and towards top)
;global transition_x 	:= 400				;uses screen_width/2 (for me it falls between notification banners)
global transition_y 	:= 35 				;toward top of screen
global transition_c1	:= 0x000000 		;black

; variables pertaining to manipulating the champion roster (and click damage upgrade)
global roster_x			:= 133			; horizontal location of the a point in the upper left corner of the click damage button
global roster_y			:= 763			; vertical location of the a point in the upper left corner of the click damage button
global roster_c1		:= 0x58B831		; Green this used to check if Level Ups are ready
global roster_c2		:= 0x5CCB2F		; Green Hover color
global roster_b1		:= 0x589CDE		; Blue Bench Color (benched or not unlocked)
global roster_b2		:= 0x5CABF7		; Blue Bench Hover Color (benched or not unlocked)
global roster_g1		:= 0x8F8F8F		; Grey this used to check if Level Ups are ready (via a not check)
global roster_g2		:= 0x6B6B6B		; Grey this used to check if Level Ups are ready (if special window is open)
global roster_bg1		:= 0x8C8C8C		; Grey this used to check if Level Ups are ready (via a not check - bench champ)
global roster_bg2		:= 0x696969		; Grey this used to check if Level Ups are ready (if special window is open - bench champ)
global roster_spacing	:= 121			; distance between the roster buttons

;whitish pixel on Left Border of Champ1 - used to ensure Roster is Left Justified
global roster_lcheck_x	:= 126
global roster_lcheck_y	:= 645
global roster_lcheck_c1	:= 0xEFEFEF
global roster_lcheck_c2	:= 0xB3B3B3

;pixel checks for upgrade being purplish
global roster_upoff_x 	:= 82
global roster_upoff_y	:= 18
global roster_up_c1		:= 0xC94292		;purple without open window
global roster_up_c2		:= 0x97316D		;purple with open window
global roster_up_g1		:= 0x5B5B5B		;grey without open window

;find left most Specialization Pixel
global special_window_left 		:= 0
global special_window_top 		:= 585
global special_window_bottom 	:= 645
global special_window_c1		:= 0x54B42D 	;color of green button
global special_window_spacing 	:= 250

;red pixel for the close button of the Speicalization Window
global special_window_close_l	:= 0			;this will be screen left
global special_window_close_r	:= 0			;this will be screen width
global special_window_close_t	:= 110
global special_window_close_b	:= 175
global special_window_close_c1	:= 0xCF0000


;autoprogress check
global autoprogress_x		:= 1328		; horizontal location of a white pixel in the autoprogress arrow
global autoprogress_y		:= 139		; vertical location of a white pixel in the autoprogress arrow
global autoprogress_c1		:= 0xFFFFFF	; white color

;Reset Buttons
;global reset_complete_x		:= 555
;global reset_complete_y		:= 575
global reset_complete_top		:= 525
global reset_complete_bottom	:= 575
global reset_complete_left		:= 555
global reset_complete_right		:= 755
global reset_complete_c1		:= 0x54B42D

global reset_continue_x		:= 600
global reset_continue_y		:= 650
global reset_continue_c1	:= 0x4A9E2A

;familiar positions
global fam_roster_top		:= 540
global fam_roster_bottom	:= 630
global fam_roster_c1		:= 0x5486C6

global fam_1_x 	:= 1005
global fam_1_y 	:= 300
global fam_2_x 	:= 940
global fam_2_y 	:= 370
global fam_3_x 	:= 1080
global fam_3_y 	:= 370
global fam_4_x 	:= 940
global fam_4_y 	:= 440
global fam_5_x 	:= 1080
global fam_5_y 	:= 440
global fam_6_x 	:= 1005
global fam_6_y 	:= 515
global fam_7_x  := 160
global fam_7_y  := 765
global fam_CD_x := 160
global fam_CD_y := 765
global fam_U_x 	:= 420
global fam_U_y 	:= 600

	;----------------------------
	;Champ Specialization selections will need to be set based on ur formation
	;----------------------------
	global Champ1_SpecialOptionQ := 2	;deekin
	global Champ2_SpecialOptionQ := 1	;cele
	global Champ3_SpecialOptionQ := 1	;nay
	global Champ4_SpecialOptionQ := 2	;2 ishi // 2 stoki
	global Champ5_SpecialOptionQ := 1	;cali
	global Champ6_SpecialOptionQ := 1	;2 eve // 1 ash
	global Champ7_SpecialOptionQ := 2	;minsc
	global Champ8_SpecialOptionQ := 2	;hitch
	global Champ9_SpecialOptionQ := 1	;tyril

	;----------------------------
	;Champ Specialization selections will need to be set based on ur formation
	;----------------------------
	global Champ1_SpecialOptionW := 2	;deekin
	global Champ2_SpecialOptionW := 1	;cele
	global Champ3_SpecialOptionW := 1	;nay
	global Champ4_SpecialOptionW := 2	;2 ishi // 2 stoki
	global Champ5_SpecialOptionW := 1	;cali
	global Champ6_SpecialOptionW := 1	;2 eve // 1 ash
	global Champ7_SpecialOptionW := 2	;minsc
	global Champ8_SpecialOptionW := 2	;hitch
	global Champ9_SpecialOptionW := 1	;tyril

	;----------------------------
	;Champ Specialization selections will need to be set based on ur formation
	;----------------------------
	global Champ1_SpecialOptionE := 2	;deekin
	global Champ2_SpecialOptionE := 1	;celeste
	global Champ3_SpecialOptionE := 2	;binwin
	global Champ4_SpecialOptionE := 2	;stoki
	global Champ5_SpecialOptionE := 1	;dhadius
	global Champ6_SpecialOptionE := 2	;asharra (tiefling)
	global Champ7_SpecialOptionE := 2	;farideh
	global Champ8_SpecialOptionE := 1	;hitch
	global Champ9_SpecialOptionE := 2	;birdsong
