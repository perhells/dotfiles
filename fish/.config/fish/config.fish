# Load locale
if status -l; and test -r /etc/locale.conf
    while read -l kv
        set -gx (string split "=" -- $kv)
    end </etc/locale.conf
end

# Change NPM path
set NPM_BIN "$HOME/.npm-packages/bin"
test -d "$NPM_BIN"; and set PATH $PATH $NPM_BIN

# Auto completion for aws-cli
test -x (which aws_completer); and complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

# start X at login
if status --is-login
    if test -z "$DISPLAY" -a $XDG_VTNR -eq 1
        exec startx -- -keeptty
    end
end

# Load aliases
if test -f ~/.config/fish/aliases.fish
    . ~/.config/fish/aliases.fish
end

# Check if local alias file exists (Ignored by git)
if test -f ~/.config/fish/local_aliases.fish
    . ~/.config/fish/local_aliases.fish
end

# Disable greeting on shell start
function fish_greeting
end

# Display home as "~"
function prompt_dir
    if test $PWD != $HOME
        printf "%s" (basename $PWD)
    else
        printf "~"
    end
end

# Displays repository information if in a git folder
function git_branch
    #set -l git_branches (git branch -l ^/dev/null | sed -e "s/^\* //")
    set -l git_branches (git rev-parse --abbrev-ref HEAD ^/dev/null)
    set -l git_status (git status --porcelain ^/dev/null)
    set -l infocolor 4ca4b5
    set -l delimcolor blue
    set -l pathcolor red
    if test "$git_branches"
        set_color $delimcolor
        echo -n "("
        if test "$git_status"
            set_color $pathcolor
            echo -n "*"
        end
        set_color $infocolor
        echo -n "$git_branches"
        set_color $delimcolor
        echo -n ")"
    end
end

# Clean left prompt with user, hostname and cwd
function fish_prompt
    set -l infocolor 4ca4b5
    set -l delimcolor blue
    set -l pathcolor red
    set_color $infocolor
    echo -n (basename $USER)
    set_color $delimcolor
    echo -n "@"
    set_color $infocolor
    echo -n (hostname)
    set_color $pathcolor
    echo -n " "(prompt_dir)" "
    set_color $delimcolor
    echo -n "❯ "
end

# Right prompt consisting of git info and bg jobs
function fish_right_prompt
    set -l delimcolor blue
    set -l infocolor 4ca4b5
    echo -n (git_branch)
    set_color $delimcolor
    echo -n "["
    set_color $infocolor
    echo -n (jobs | wc -l)
    set_color $delimcolor
    echo -n "]"
end
