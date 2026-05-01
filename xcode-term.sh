#!/bin/sh
# I bind this to ⌃⌘T

dir=$(printf '%s' "$PWD" | sed 's|/.swiftpm/xcode||')
esc_dir=$(printf '%s' "$dir" | sed 's/\\/\\\\/g; s/"/\\"/g')

osascript \
    -e "tell application \"Ghostty\"" \
    -e "    set cfg to new surface configuration" \
    -e "    set initial working directory of cfg to \"$esc_dir\"" \
    -e "    new window with configuration cfg" \
    -e "end tell"
