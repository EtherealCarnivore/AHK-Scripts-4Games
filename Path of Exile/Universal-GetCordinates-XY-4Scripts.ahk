;this allow you to get the X/Y cordinates of anything in any game or program
;this is the fastest way to write scripts as fetching cordinates manually with Window Spy will take a ton of time
;use control+t to access the script
^t::                                                ;CTRL+T to copy XY coordinates & color (0xBBGGRR) to clipboard
{
    MouseGetPos, X, Y
    PixelGetColor, colour, X, Y
    Clipboard = %X%, %Y%, %colour%
    Return
}