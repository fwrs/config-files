# Prompt: Informative VCS
# Theme: Fish Default

# Manually set the title so that it renders as fast as possible
if set -q fish_startup_cwd
    cd $fish_startup_cwd

    if set -q fish_startup_command
        echo -n -e "\e]0;" (string sub -l 40 -- $fish_startup_command | string trim) — (prompt_pwd -d 1 -D 1) "\a"
    else
        echo -n -e "\e]0;" (prompt_pwd -d 1 -D 1) "\a"
    end
    
    set -e fish_startup_cwd
else if set -q fish_startup_command
    echo -n -e "\e]0;" (string sub -l 40 -- $fish_startup_command | string trim) — "~\a"
else
    echo -n -e "\e]0;~\a"
end

fish_add_path /opt/homebrew/bin /opt/homebrew/sbin ~/Library/Python/3.9/bin ~/.cargo/bin

set -gx HOMEBREW_PREFIX "/opt/homebrew"
set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar"
set -gx HOMEBREW_REPOSITORY "/opt/homebrew"
set -gx JAVA_HOME "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"
set -gx DOCKER_HOST "unix://$HOME/.colima/docker.sock"

if test -n "$MANPATH[1]"
    set -gx MANPATH "" $MANPATH
end

if not contains "/opt/homebrew/share/info" $INFOPATH
    set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH
end

set fish_greeting
set -gx MANPAGER "nvim +Man!"
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx GPG_TTY (tty)

if set -q fish_startup_command
    eval $fish_startup_command
    set -e fish_startup_command
end

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
    set -l ssh
    set -q SSH_TTY
    and set ssh "["(prompt_hostname | string sub -l 10 | string collect | string trim)"]"

    if set -q argv[1]
        set -f command $argv[1]
    else
        set -f command (status current-command)
    end

    if test "$command" = fish
        echo -- $ssh (prompt_pwd -d 1 -D 1)
    else
        echo -- $ssh (string sub -l 40 -- $command | string trim) — (prompt_pwd -d 1 -D 1)
    end
end
