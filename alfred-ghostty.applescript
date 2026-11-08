on alfred_script(query)
    tell application "Ghostty"
        activate
        
        if (count of windows) = 0 then
            set cfg to new surface configuration
            new window with configuration cfg
        end if
        
        set term to focused terminal of selected tab of window 1
        input text query to term
        send key "enter" to term
    end tell
end alfred_script
