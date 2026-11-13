# prompt

function fish_prompt
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status
    set -l color_cwd
    set -l suffix

    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        else
            set color_cwd $fish_color_cwd
        end
        set suffix "#"
    else
        set color_cwd $fish_color_cwd
        set suffix "$"
    end

    set_color $color_cwd
    echo -n (prompt_pwd)
    set_color --reset

    printf "%s " (fish_vcs_prompt)

    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color --bold $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
    echo -n $prompt_status
    set_color --reset

    echo -n "$suffix "
end

# title

function fish_title
    set -l ssh
    set -q SSH_TTY
    and set ssh "[" (prompt_hostname | string sub -l 10 | string collect | string trim) "]"

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

# theme

set -g fish_color_autosuggestion 808080
set -g fish_color_cancel --reverse
set -g fish_color_command blue
set -g fish_color_comment red
set -g fish_color_cwd green
set -g fish_color_cwd_root red
set -g fish_color_end green
set -g fish_color_error brred
set -g fish_color_escape brcyan
set -g fish_color_history_current --bold
set -g fish_color_host normal
set -g fish_color_host_remote
set -g fish_color_keyword
set -g fish_color_match --background=brblue
set -g fish_color_normal normal
set -g fish_color_operator brcyan
set -g fish_color_option
set -g fish_color_param cyan
set -g fish_color_quote yellow
set -g fish_color_redirection cyan --bold
set -g fish_color_search_match white --background=brblack
set -g fish_color_selection white --bold --background=brblack
set -g fish_color_status red
set -g fish_color_user brgreen
set -g fish_color_valid_path --underline
set -g fish_pager_color_background
set -g fish_pager_color_completion normal
set -g fish_pager_color_description yellow --italics
set -g fish_pager_color_prefix normal --bold --underline
set -g fish_pager_color_progress brwhite --background=cyan
set -g fish_pager_color_secondary_background
set -g fish_pager_color_secondary_completion
set -g fish_pager_color_secondary_description
set -g fish_pager_color_secondary_prefix
set -g fish_pager_color_selected_background --reverse
set -g fish_pager_color_selected_completion
set -g fish_pager_color_selected_description
set -g fish_pager_color_selected_prefix

# initial title to be rendered as quickly as possible

set -l title "~"

if set -q fish_startup_cwd
    cd -- "$fish_startup_cwd"
    set title (prompt_pwd -d 1 -D 1)
    set -e fish_startup_cwd
end

if set -q fish_startup_command
    set -l command_title (string sub -l 40 -- "$fish_startup_command" | string trim)
    set title "$command_title — $title"
end

printf "\e]0;%s\a" "$title"

# bare essentials needed for the startup command

eval (/opt/homebrew/bin/brew shellenv)
fish_add_path ~/.local/bin
set -gx JAVA_HOME "/Library/Java/JavaVirtualMachines/zulu-27.jdk/Contents/Home"

if set -q fish_startup_command
    eval $fish_startup_command
    set -e fish_startup_command
end

# env var config

set -gx MANPAGER "nvim +Man!"
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx GPG_TTY (tty)
set -gx EDITOR /opt/homebrew/bin/nvim

# other ui settings

set -g fish_greeting

fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block
function fish_mode_prompt; end

set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_hide_untrackedfiles 1
set -g __fish_git_prompt_color_branch magenta --bold
set -g __fish_git_prompt_showupstream informative
set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green --bold
set __fish_git_prompt_char_stagedstate "○"
set __fish_git_prompt_char_dirtystate "+"
set __fish_git_prompt_char_untrackedfiles "…"
set __fish_git_prompt_char_conflictedstate "×"
set __fish_git_prompt_char_cleanstate "✓"

# helpers

abbr -a gl "git log --graph --all --oneline --decorate --pretty=format:\"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\""
abbr -a gfixup "git commit -a --amend --no-edit"
abbr -a gsw "git switch"
abbr -a nv "nvim ."
abbr -a ng "nvim . -c \":G ++curwin\""
abbr -a gcleanstale "git branch -vv | grep \": gone]\" | awk \"{print \\\$1}\" | xargs -p git branch -D"
abbr -a xc "open \"\$(fd -I -d 1 -e xcworkspace | head -n 1)\""
abbr -a idea "env -i HOME=\"\$HOME\" zsh -l -c \"open -a \\\"IntelliJ IDEA CE\\\" .\""
abbr -a studio "env -i HOME=\"\$HOME\" zsh -l -c \"open -a \\\"Android Studio\\\" .\""
abbr -a nsh "env -i HOME=\"\$HOME\" zsh"
abbr -a cdr "cd (git rev-parse --show-toplevel)"

function gss -a branch
    git stash && git switch $branch && git stash pop
end

function gff -a branch
    git fetch origin $branch:$branch
end
