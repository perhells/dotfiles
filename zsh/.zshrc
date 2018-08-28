PATH="$HOME/.local/bin/:${PATH}"
export PATH
export VISUAL=nvim
export EDITOR=nvim

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/per/.zshrc'

whatthecommit(){
    curl -s http://whatthecommit.com/ | tr -s '\n' ' ' \
        | grep -so 'p>\(.*\)</p' | sed -n 's/..\(.*\)..../\1/p' | sed -e 's/<[^>]*>//g' | sed -e 's/\[[^>]*\]//g';
}
gm(){
    git commit -a -m "`whatthecommit`" && git push;
}

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# colors for ls
if [[ -f ~/.dir_colors ]] ; then
    eval $(dircolors -b ~/.dir_colors)
elif [[ -f /etc/DIR_COLORS ]] ; then
    eval $(dircolors -b /etc/DIR_COLORS)
fi

autoload -U colors && colors

# brackets:
#PROMPT="%{$fg[blue]%}[%{$fg[cyan]%}%n@%M %{$fg[red]%}%1~%{$fg[blue]%}]%{$fg[cyan]%}❯%{$fg[blue]%}❯%{$fg[magenta]%}❯ %{$reset_color%}"
# tri arrow: 
#PROMPT="%{$fg[cyan]%}%n@%M %{$fg[red]%}%1~ %{$fg[cyan]%}❯%{$fg[blue]%}❯%{$fg[magenta]%}❯ %{$reset_color%}"
# one arrow:
PROMPT="%{$fg[blue]%}(zsh) %{$fg[cyan]%}%n%{$fg[blue]%}@%{$fg[cyan]%}%M %{$fg[red]%}%1~ %{$fg[blue]%}❯ %{$reset_color%}"

# job count: RPROMPT="%{$fg[blue]%}[%{$fg[cyan]%}%j%{$fg[blue]%}]%{$reset_color%}"
RPROMPT="%{$fg[blue]%}[%{$fg[cyan]%}%j%{$fg[blue]%}]%{$reset_color%}"

autoload -Uz compinit
compinit
stty -ixon
# End of lines added by compinstall

bindkey '^W' vi-backward-kill-word

if [[ "$TERM" == *rxvt* || "$TERM" == *xterm* ]]; then
    exec fish
fi
