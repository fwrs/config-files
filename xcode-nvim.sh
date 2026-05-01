#!/bin/sh
# I bind this to ⌃⌘,

path=$(osascript -e "
tell application \"Xcode\"
    set x to path of last item of source documents
end tell
return x")

dir=$(printf '%s' "$PWD" | sed 's|/.swiftpm/xcode||')
path="${path#"$dir/"}"
esc_dir=$(printf '%s' "$dir" | sed 's/\\/\\\\/g; s/"/\\"/g')
esc_path=$(printf '%s' "$path" | sed 's/\\/\\\\/g; s/"/\\"/g')

osascript \
    -e "tell application \"Ghostty\"" \
    -e "    set cfg to new surface configuration" \
    -e "    set initial working directory of cfg to \"$esc_dir\"" \
    -e "    set win to new window with configuration cfg" \
    -e "    set term to focused terminal of selected tab of win" \
    -e "    input text \"nvim \\\"$esc_path\\\"\" to term" \
    -e "    send key \"enter\" to term" \
    -e "end tell"
