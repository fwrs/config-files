#!/bin/sh
# I bind this to ⌃⌘,
osascript -e "
tell application \"Xcode\"
    set x to path of last item of source documents
end tell

tell application \"iTerm\"
    activate
    tell current window
        create tab with default profile
        delay 0.3
        tell current session
            write text \"nvim \\\"\" & x & \"\\\"\"
        end tell
    end tell
end tell"
