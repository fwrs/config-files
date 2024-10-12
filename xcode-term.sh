#!/bin/sh
# I bind this to ⌃⌘T
dir="$PWD"
# Remove a potential suffix in case Xcode shows a Swift Package
suffix="/.swiftpm/xcode"
dir=${dir//$suffix/}

echo "
#!/bin/sh
export fish_startup_cwd=\"$dir\"
/opt/homebrew/bin/fish -i" > ~/.xcode/launch_term.command

chmod +x ~/.xcode/launch_term.command
open ~/.xcode/launch_term.command
