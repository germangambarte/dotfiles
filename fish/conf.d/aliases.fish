# ----------------------------
# File system (functions)
# ----------------------------
function ls
    eza -lh --group-directories-first --icons=auto --color=always $argv
end

function lsa
    ls -a $argv
end

function lt
    eza --tree --level=2 --long --icons --git --color=always $argv
end

function lta
    lt -a $argv
end

function ff
    fzf --preview 'bat --style=numbers --color=always {}' $argv
end

function cd
    zd $argv
end

function zd
    if test (count $argv) -eq 0
        builtin cd ~
    else if test -d $argv[1]
        builtin cd $argv[1]
    else
        z $argv; and printf " \U000F17A9 "; and pwd; or echo "Error: Directory not found"
    end
end

function open
    xdg-open $argv >/dev/null 2>&1 &
end
