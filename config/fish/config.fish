############################################################
# Variables
############################################################
set -x LANG en_US.UTF-8
set -x EDITOR vim
set -x GIT_OPENER fork
set -x GIT_EDITOR $EDITOR
set -x FISH_HOME $__fish_config_dir

set -x GOPATH $HOME/.go
set -x CURL_HOME $HOME/.config/curl
set -x PIP_CONFIG_FILE $HOME/.config/pip/config

set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_STATE_HOME $HOME/.local/state

set -x PATH $HOME/{.scripts,.cargo/bin} $PATH
set -x CDPATH $CDPATH . ~ $HOME/Projects

begin
    set -l brew '/opt/homebrew/bin/brew'
    if [ (/usr/bin/uname -m) != 'arm64' ]
        set brew '/usr/local/bin/brew'
    end
    [ -f $brew ] && eval ($brew shellenv)
end

set -x HOMEBREW_NO_ANALYTICS 1
set -x HOMEBREW_NO_AUTO_UPDATE 1
set -x HOMEBREW_NO_GITHUB_API 1
set -x HOMEBREW_NO_INSTALL_CLEANUP 1
set -x HOMEBREW_NO_INSTALL_UPGRADE 1
set -x HOMEBREW_NO_INSECURE_REDIRECT 1

############################################################
# Prompt
############################################################

if status is-interactive
    if [ $TERM_PROGRAM = WarpTerminal ]
        [ -z $FISH_ROOT_PID ] && set -x FISH_ROOT_PID $fish_pid
        if [ $fish_pid = $FISH_ROOT_PID ]
            # Disable custom prompt in root Warp shell
            functions -e fish_prompt
            function fish_prompt; end
            fish_prompt >/dev/null

            # Abbreviation not supported in Warp, replace with alias
            set -g WARP_ABBR_COMPAT_ALIAS 1
        end
    else
        set -g async_prompt_functions _pure_prompt_git
        function _pure_prompt_git_loading_indicator
            echo (set_color brblack)…(set_color normal)
        end
    end
end

############################################################
# Sources
############################################################

if set -q WARP_ABBR_COMPAT_ALIAS
    set -g WARP_ABBR_COMPAT_ALIAS (string split -n '\n' (abbr -l))
end

function source_if -a file
    [ -f $file ] && source $file
end

# Git
source $FISH_HOME/git.fish

# Misc
source $FISH_HOME/misc.fish

# Local
source_if $FISH_HOME/local.fish

# abbr -> alias
if set -q WARP_ABBR_COMPAT_ALIAS
    set -l old_abbrs $WARP_ABBR_COMPAT_ALIAS
    set -l new_abbrs (string split -n '\n' (abbr -s))
    set -e WARP_ABBR_COMPAT_ALIAS
    echo $old_abbrs
    echo $new_abbrs
    for a in $new_abbrs
        if string match -rq "\s--\s(?<name>\w+)\s'?(?<expansion>.+)'?" -- $a
            if not contains $name $old_abbrs
                set -l expansion (string unescape -- $expansion)
                set -l alias_desc "$name=\'$expansion\'"
                set -a WARP_ABBR_COMPAT_ALIAS $alias_desc

                set -l wraps --wraps (string escape -- $expansion)
                set -l desc --description (string escape -- "abbr: $alias_desc")
                set -l body "echo (set_color -o black)'Command: '(set_color brred)'$alias_desc'(set_color normal); $expansion \$argv"
                echo "function $name $wraps $desc; $body; end" | source
            end
        end
    end
end

# Source fzf
source_if $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.fish

# Source autojump
source_if $HOMEBREW_PREFIX/share/autojump/autojump.fish

# Source parallel
source_if (which env_parallel.fish)
