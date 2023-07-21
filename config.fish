# Prompt: Informative VCS
# Theme: Fish Default

source ~/.iterm2_shell_integration.fish
eval "$(/opt/homebrew/bin/brew shellenv)"
fish_add_path ~/Library/Python/3.9/bin
fish_add_path ~/.cargo/bin

set fish_greeting
set -gx MANPAGER "nvim +Man!"
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_AUTO_UPDATE 1

fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block
function fish_mode_prompt; end

abbr -a gl "git log --graph --all --oneline --decorate --pretty=format:\"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\""
abbr -a gfixup "git commit -a --amend --no-edit"
abbr -a gsw "git switch"
abbr -a lg "lazygit"
abbr -a lgs "lazygit status"
abbr -a pi "pod install"
abbr -a piup "pod install --repo-update"
abbr -a gcleanstale "git branch -vv | grep \": gone]\" | awk \"{print \\\$1}\" | xargs -p git branch -D"

function gss -a branch
    git stash && git switch $branch && git stash pop
end

function gff -a branch
    git fetch origin $branch:$branch
end
