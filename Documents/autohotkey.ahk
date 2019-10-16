;Open cmd prompt
#^d::
    Run, cmd, %userprofile%
    return

;Open admin cmd prompt
#^+d::
    Run *RunAs cmd.exe
    return


