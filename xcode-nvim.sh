#!/bin/sh
# I bind this to ⌃⌘,
path=$(osascript -e "
tell application \"Xcode\"
    set x to path of last item of source documents
end tell

return x")

echo "
#!/bin/sh
export fish_startup_command=\"nvim \\\"$path\\\"\"
export fish_startup_cwd=\"~\"
/opt/homebrew/bin/fish -i" > ~/.xcode/launch_nvim.command

chmod +x ~/.xcode/launch_nvim.command
open ~/.xcode/launch_nvim.command
