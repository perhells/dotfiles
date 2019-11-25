alias ..='cd ..'
alias ls='ls -lh --color'

for i in $(seq 9); do
    alias s$i="pwd > ~/.saved_folder$i"
    alias p$i="if [ -f ~/.saved_folder$i ]; then cat <(echo -n \"Saved folder $i: \") ~/.saved_folder$i 2>/dev/null; fi"
    alias l$i="cd \$(cat ~/.saved_folder$i 2> /dev/null)"
    alias r$i="rm ~/.saved_folder$i"
done

# Calls all individual functions for listing and removing saved directories
alias p='p1; p2; p3; p4; p5; p6; p7; p8; p9'
alias rA='r1; r2; r3; r4; r5; r6; r7; r8; r9'
