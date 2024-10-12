# Prompt: Informative VCS
# Theme: Fish Default

# Render the title ASAP to prevent weird flashes
echo -n -e "\e]0;~\a"
eval "$(/opt/homebrew/bin/brew shellenv)"
set -gx JAVA_HOME "$(/usr/libexec/java_home)"
set -gx DOCKER_HOST "unix://$HOME/.colima/docker.sock"
fish_add_path ~/Library/Python/3.9/bin
fish_add_path ~/.cargo/bin

set fish_greeting
set -gx MANPAGER "nvim +Man!"
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx GPG_TTY (tty)

abbr -a gl "git log --graph --all --oneline --decorate --pretty=format:\"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\""
abbr -a gfixup "git commit -a --amend --no-edit"
abbr -a gsw "git switch"
abbr -a lg "lazygit"
abbr -a lgs "lazygit status"
abbr -a pi "pod install"
abbr -a piup "pod install --repo-update"
abbr -a gcleanstale "git branch -vv | grep \": gone]\" | awk \"{print \\\$1}\" | xargs -p git branch -D"
abbr -a xc "open \"\$(fd -I -d 1 -e xcworkspace | head -n 1)\""
abbr -a idea "env -i HOME=\"\$HOME\" zsh -l -c \"open -a \\\"IntelliJ IDEA CE\\\" .\""
abbr -a studio "env -i HOME=\"\$HOME\" zsh -l -c \"open -a \\\"Android Studio\\\" .\""
abbr -a nsh "env -i HOME=\"\$HOME\" bash"

function gss -a branch
    git stash && git switch $branch && git stash pop
end

function gff -a branch
    git fetch origin $branch:$branch
end

function fish_title
    if not set -q INSIDE_EMACS; or string match -vq "*,term:*" -- $INSIDE_EMACS
        set -l ssh
        set -q SSH_TTY
        and set ssh "["(prompt_hostname | string sub -l 10 | string collect | string trim)"]"

        if set -q argv[1]
            set -f command $argv[1]
        else
            set -f command (status current-command)
        end

        if set -q argv[2]
            set -f path $argv[2]
            if not set -q argv[1]; or test "$argv[1]" = ""
                set -f command "fish"
            end
        else
            set -f path (prompt_pwd -d 1 -D 1)
        end

        if test "$command" = fish
            echo -- $ssh $path
        else
            echo -- $ssh (string sub -l 40 -- $command | string trim) — $path
        end
    end
end

if set -q fish_startup_command; or set -q fish_startup_cwd
    function render_title
        echo -n -e "\e]0;" (fish_title $fish_startup_command $fish_startup_cwd) "\a"
    end
    
    # Really buggy behavior with ghostty so I call it twice
    render_title
    cd $fish_startup_cwd
    render_title

    eval $fish_startup_command
    set -e fish_startup_command
    set -e fish_startup_cwd
end
