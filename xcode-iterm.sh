#!/bin/sh
# I bind this to ⌃⌘T
dir="$PWD"
# Remove a potential suffix in case Xcode shows a Swift Package
suffix="/.swiftpm/xcode"
dir=${dir//$suffix/}
open -a iTerm "$dir"
