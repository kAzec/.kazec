# SSH
if not ssh-add -l >/dev/null 2>&1
    ssh-add --apple-use-keychain (string sub -e -4 $HOME/.ssh/*.pub)
end

# Exa
alias l 'exa -l --icons --group-directories-first'
abbr -g ll 'l -h'
abbr -g la 'l -ha'
abbr -g lD 'l -hD'
abbr -g lt 'l -ha -TL=1'
abbr -g ltt 'l -ha -TL=2'
abbr -g lt3 'l -ha -TL=3'
abbr -g lt4 'l -ha -TL=4'
abbr -g lg 'l -ha | grep'
abbr -g ltg 'l -ha -TL=1 | grep'
abbr -g lg 'l -ha | fzf'
abbr -g ltg 'l -ha -TL=1 | fzf'

# Misc
abbr -g spm 'swift package'
abbr -g rgf 'rg -F'
abbr -g ydl youtube-dl
abbr -g kxcd 'killall Xcode'
abbr -g brewU 'brew update && brew upgrade'
abbr -g sha256 'shasum -a 256'
abbr -g reload 'exec $SHELL'

function opend -d "Open directory in Finder."
    if count $argv >/dev/null
        open $argv
    else
        open .
    end
end

function b64e
    echo $argv | base64
end

function b64d
    echo $argv | base64 -D
end

function myip
    dig +short myip.opendns.com @resolver1.opendns.com
end

function mkdcd -a dir
    [ -z $dir ] && return 1
    mkdir -p -p $dir && builtin cd $dir
end

function symcrash
    set -gx DEVELOPER_DIR (xcode-select --print-path)
    /Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/symbolicatecrash $argv
end

function update_brewfile
    brew bundle dump --file=$HOME/.kazec/sync/brew/Brewfile --force
end
