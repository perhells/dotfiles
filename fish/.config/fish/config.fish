# Load locale
if status -l; and test -r /etc/locale.conf
    while read -l kv
        set -gx (string split "=" -- $kv)
    end </etc/locale.conf
end

# Add NPM bin dir
set NPM_BIN "$HOME/.npm-packages/bin"
test -d "$NPM_BIN"; and set PATH $PATH $NPM_BIN

# Add Yarn bin dir
set YARN_BIN "$HOME/.yarn/bin"
test -d "$YARN_BIN"; and set PATH $PATH $YARN_BIN

# Add bin dirs in program folders
if test -d "$HOME/Programs";
    for folder in (ls "$HOME/Programs")
        set bindir "$HOME/Programs/$folder/bin"
        if test -d "$bindir"
            set PATH $PATH $bindir
        end
    end
end

# Add ~/.local/bin to PATH
if test -d "$HOME/.local/bin";
    set PATH "$HOME/.local/bin" $PATH
end

# Fix delete in st
if test "$TERM" = "st-256color";
    tput smkx
end

# Add opam to path
if type -q opam
    eval (opam env)
end

# Auto completion for aws-cli
if type -q aws_completer
    and complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
end

# Load aliases
if test -f ~/.config/fish/aliases.fish
    . ~/.config/fish/aliases.fish
end

# Check if local alias file exists (Ignored by git)
if test -f ~/.config/fish/local_aliases.fish
    . ~/.config/fish/local_aliases.fish
end

# Load local functions
if test -d ~/.config/fish/local
    for function_file in ~/.config/fish/local/*
        . $function_file
    end
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
    set -l git_branches (git branch --color=never 2> /dev/null | sed -n '/\* /s///p')
    set -l git_status (git status --porcelain  2> /dev/null)
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
    echo -n $hostname
    set_color $pathcolor
    echo -n " "(prompt_dir)" "
    set_color $delimcolor
    echo -n "> "
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
