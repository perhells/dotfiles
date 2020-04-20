# Alias related
function ra; . ~/.config/fish/aliases.fish; end
function ea; vim ~/.config/fish/aliases.fish; ra; end

# Use neovim instead of vim
function vim; command nvim $argv; end
function vi; command nvim $argv; end

# Git
function wow; git status; end
function owo; git status; end
function geet; git $argv; end
function such; git $argv; end
function very; git $argv; end
function many; git $argv; end
function much; git $argv; end
function so; git $argv; end

# SSH
function ssh-agent; eval (command ssh-agent -c); end

# Comfort
function ll; command ls -lh --group-directories-first --color $argv; end
function grep; command grep --color=auto $argv; end
function top; atop; end
function visudo; sudo EDITOR=vim visudo; end
function tree; command tree --dirsfirst -C $argv; end
function feh; command feh --auto-zoom $argv;end
function geet; command git $argv; end
function dots; command dot "$argv" -Tpng -o "$argv".png; feh "$argv".png; end

# Shows sizes of directories
function sizes
    set originalPath (pwd)
    if count $argv > /dev/null
        cd $argv
    end
    du -sch (ls -A) 2> /dev/null | sort -h
    cd $originalPath
end

function ssizes
    set originalPath (pwd)
    if count $argv > /dev/null
        cd $argv
    end
    sudo du -sch (ls -A) 2> /dev/null | sort -h
    cd $originalPath
end

# Opens PDF file on new workspace
function pdf; newworkspace zathura $argv &; end

# Open files
function open; command xdg-open $argv 2> /dev/null &; end

# Quick and easy way to open a lot of links in chrome
function open_all_chrome;
while read f
    google-chrome-unstable $f
end < $argv; end

# Handling of mirrorlist files for pacman
function pacman-edit; sudo vim /etc/pacman.d/mirrorlist; end
function pacnew-edit; sudo vim /etc/pacman.d/mirrorlist.pacnew; end
function paccopy; sudo cp /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist; end
function pacdiff;
    if test (count (diff /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.pacnew)) -gt 0
        vimdiff /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.pacnew
    else
        echo "No difference between new and old mirrorlist"
    end;
end

# Calls all individual functions for listing and removing saved directories
function p; p0; p1; p2; p3; p4; p5; p6; p7; p8; p9; end
function rA; r0; r1; r2; r3; r4; r5; r6; r7; r8; r9; end

# Indivivual functions for saving directories
function s1; pwd > ~/.saved_folder1; end
function p1; cat ~/.saved_folder1 2> /dev/null | xargs bash -c 'for filename; do echo "Saved folder 1: $filename"; done' bash; end
function l1; cd (cat ~/.saved_folder1); end
function r1; rm ~/.saved_folder1 2> /dev/null; end
function s2; pwd > ~/.saved_folder2; end
function p2; cat ~/.saved_folder2 2> /dev/null | xargs bash -c 'for filename; do echo "Saved folder 2: $filename"; done' bash; end
function l2; cd (cat ~/.saved_folder2); end
function r2; rm ~/.saved_folder2 2> /dev/null; end
function s3; pwd > ~/.saved_folder3; end
function p3; cat ~/.saved_folder3 2> /dev/null | xargs bash -c 'for filename; do echo "Saved folder 3: $filename"; done' bash; end
function l3; cd (cat ~/.saved_folder3); end
function r3; rm ~/.saved_folder3 2> /dev/null; end
function s4; pwd > ~/.saved_folder4; end
function p4; cat ~/.saved_folder4 2> /dev/null | xargs bash -c 'for filename; do echo "Saved folder 4: $filename"; done' bash; end
function l4; cd (cat ~/.saved_folder4); end
function r4; rm ~/.saved_folder4 2> /dev/null; end
function s5; pwd > ~/.saved_folder5; end
function p5; cat ~/.saved_folder5 2> /dev/null | xargs bash -c 'for filename; do echo "Saved folder 5: $filename"; done' bash; end
function l5; cd (cat ~/.saved_folder5); end
function r5; rm ~/.saved_folder5 2> /dev/null; end
function s6; pwd > ~/.saved_folder6; end
function p6; cat ~/.saved_folder6 2> /dev/null | xargs bash -c 'for filename; do echo "Saved folder 6: $filename"; done' bash; end
function l6; cd (cat ~/.saved_folder6); end
function r6; rm ~/.saved_folder6 2> /dev/null; end
function s7; pwd > ~/.saved_folder7; end
function p7; cat ~/.saved_folder7 2> /dev/null | xargs bash -c 'for filename; do echo "Saved folder 7: $filename"; done' bash; end
function l7; cd (cat ~/.saved_folder7); end
function r7; rm ~/.saved_folder7 2> /dev/null; end
function s8; pwd > ~/.saved_folder8; end
function p8; cat ~/.saved_folder8 2> /dev/null | xargs bash -c 'for filename; do echo "Saved folder 8: $filename"; done' bash; end
function l8; cd (cat ~/.saved_folder8); end
function r8; rm ~/.saved_folder8 2> /dev/null; end
function s9; pwd > ~/.saved_folder9; end
function p9; cat ~/.saved_folder9 2> /dev/null | xargs bash -c 'for filename; do echo "Saved folder 9: $filename"; done' bash; end
function l9; cd (cat ~/.saved_folder9); end
function r9; rm ~/.saved_folder9 2> /dev/null; end
function s0; pwd > ~/.saved_folder0; end
function p0; cat ~/.saved_folder0 2> /dev/null | xargs bash -c 'for filename; do echo "Saved folder 0: $filename"; done' bash; end
function l0; cd (cat ~/.saved_folder0); end
function r0; rm ~/.saved_folder0 2> /dev/null; end

# Copy/Paste
function pbcopy; xclip -selection clipboard; end
function pbpaste; xclip -selection clipboard -o; end

# Copy "HEMKÖP"
function hk
    set str ""
    for i in (seq 6)
        set str "$str:hk$i:"
    end
    echo -n "$str" | pbcopy
    figlet Hemkop
end

# Find branches removed at origin
function git-gone
    git fetch -p > /dev/null
    for branch in (git branch -vv --color=never | grep ': gone]' | awk '{print $1}')
        echo $branch
    end
end

# Remove branches that has been removed at origin
function git-gone-clean; git branch -D (git-gone); end

# Get groups of LDAP user
function ldapgroups
    ldapsearch -LLL -x -h ldap.dewire.com -b dc=dewire,dc=com member=uid=$argv[1],ou=people,dc=dewire,dc=com cn | grep "^cn:" | sed -e "s/^cn: //"
end

# Calculate percentage of test code
function counttests
    set codecount (cat (find src -not -name "*test*")  2> /dev/null | wc -l)
    set testcount (cat (find src -name "*test*")  2> /dev/null | wc -l)
    set totalcount (echo "$codecount + $testcount" | bc)
    set codepercentage (echo "scale=1; (10000 *  $codecount / $totalcount + 5) / 100" | bc)
    set testpercentage (echo "scale=1; (10000 *  $testcount / $totalcount + 5) / 100" | bc)
    echo -e "Code: \t$codecount ($codepercentage%)"
    echo -e "Test: \t$testcount ($testpercentage%)"
    echo -e "Total: \t$totalcount"
end

function nvidia-run
    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME="nvidia" __VK_LAYER_NV_optimus="NVIDIA_only" $argv
end
