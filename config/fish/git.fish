# Format
set -x _git_log_medium_format (echo (set_color -o)"Commit:"(set_color normal)" "(set_color green)"%H"(set_color red)"%d%n"(set_color -o)"Author:"(set_color normal)" "(set_color cyan)"%an <%ae>%n"(set_color -o)"Date:"(set_color normal)"   "(set_color blue)"%ai "%ar(set_color normal)"%n%+B")
set -x _git_log_oneline_format (echo (set_color green)"%h"(set_color normal)" %s"(set_color red)"%d"(set_color normal)"%n")
set -x _git_log_brief_format (echo (set_color green)"%h"(set_color normal)" %s%n"(set_color blue)%ar by %an""(set_color red)"%d"(set_color normal)"%n")

# Autosave
# if command -v autosaved
#     autosaved start
# end

# Add (a)
abbr -g ga 'git add'
abbr -g gaa 'git add --all'
abbr -g gaA 'git add .'
abbr -g gau 'git add --update'

# Branch (b)
abbr -g gb 'git branch'
abbr -g gba 'git branch --all --verbose'
abbr -g gbc 'git checkout -b'
abbr -g gbf 'git branch -f'
abbr -g gbd 'git branch --delete'
abbr -g gbD 'git branch --delete --force'
abbr -g gbl 'git branch --verbose'
abbr -g gbL 'git branch --all --verbose'
abbr -g gbm 'git branch --move'
abbr -g gbM 'git branch --move --force'
abbr -g gbr 'git branch --move'
abbr -g gbR 'git branch --move --force'
abbr -g gbs 'git show-branch'
abbr -g gbS 'git show-branch --all'
abbr -g gbv 'git branch --verbose'
abbr -g gbV 'git branch --verbose --verbose'
abbr -g gbx 'git branch --delete'
abbr -g gbX 'git branch --delete --force'

# Commit (c)
abbr -g gc 'git commit --verbose'
abbr -g gca 'git commit --verbose --all'
abbr -g gcm 'git commit --message'
abbr -g gcam 'git commit --all --message'
abbr -g gcAm 'git add . && git commit --all --message'
abbr -g gco 'git checkout'
abbr -g gcO 'git checkout --force'
abbr -g gcD 'git checkout --detach'
abbr -g gcf 'git commit --amend --reuse-message HEAD'
abbr -g gcaf 'git commit --all --amend --reuse-message HEAD'
abbr -g gcF 'git commit --verbose --amend'
abbr -g gcp 'git cherry-pick'
abbr -g gcP 'git cherry-pick --no-commit'
abbr -g gcpa 'git cherry-pick --abort'
abbr -g gcpc 'git cherry-pick --continue'
abbr -g gcpf 'git cherry-pick --ff'
abbr -g gcpn 'git cherry-pick --no-stat'
abbr -g gcr 'git revert'
abbr -g gcR 'git reset "HEAD^"'
abbr -g gcs 'git show'
abbr -g gcsS 'git show --pretty=short --show-signature'
abbr -g gcl git-commit-lost

# Conflict (C)
abbr -g gCl 'git conflicts'
abbr -g gCa 'git add (git conflicts)'
abbr -g gCe 'git mergetool (git conflicts)'

# Diff (d)
abbr -g gd 'git diff'
abbr -g gdc 'git diff --cached'
abbr -g gdw 'git diff --cached --word-diff'

# Fetch (f)
abbr -g gf 'git fetch'
abbr -g gfa 'git fetch --all'
abbr -g gft 'git fetch --tags'
abbr -g gfat 'git fetch --all --tags'
abbr -g gfr 'git fetch --recurse-submodules -j8'
abbr -g gfc 'git clone'
abbr -g gfcr 'git clone --recurse-submodules -j8'

# Log (l)
alias git_log 'git log --topo-order --pretty=format:$_git_log_medium_format'
abbr -g gl 'git_log'
abbr -g gl1 'git_log -1'
abbr -g gl2 'git_log -2'
abbr -g gl3 'git_log -3'
abbr -g glf 'git_log --first-parent'
abbr -g glb 'git log --topo-order --pretty=format:$_git_log_brief_format'
abbr -g gls 'git log --topo-order --stat --pretty=format:$_git_log_medium_format'
abbr -g gld 'git log --topo-order --stat --patch --full-diff --pretty=format:$_git_log_medium_format'
abbr -g glo 'git log --topo-order --pretty=format:$_git_log_oneline_format'
abbr -g glg 'git log --topo-order --graph --pretty=format:$_git_log_oneline_format'
abbr -g glc 'git shortlog --summary --numbered'

# Merge (m)
abbr -g gm 'git merge --no-edit'
abbr -g gmn 'git merge --no-stat'
abbr -g gme 'git merge --edit'
abbr -g gmF 'git merge --no-edit --no-ff'
abbr -g gma 'git merge --abort'
abbr -g gmc 'git merge --continue'
abbr -g gmC 'git merge --no-commit'
abbr -g gmt 'git mergetool'

# Push & Pull (p)
abbr -g gp 'git push'
abbr -g gpu 'git push -u'
abbr -g gpf 'git push --force-with-lease'
abbr -g gpF 'git push --force'
abbr -g gpa 'git push --all'
abbr -g gpA 'git push --all && git push --tags'
abbr -g gpt 'git push --tags'
abbr -g gP 'branch=(git-branch-current 2>/dev/null) git pull'
abbr -g gPr 'branch=(git-branch-current 2>/dev/null) git pull --rebase'
abbr -g gPm 'branch=(git-branch-current 2>/dev/null) git pull --recurse-submodules -j8'
abbr -g gPp 'branch=(git-branch-current 2>/dev/null) git pull origin $branch && git push origin $branch'
abbr -g gpp 'branch=(git-branch-current 2>/dev/null) git pull origin $branch && git push origin $branch'

# Rebase (r)
abbr -g gr 'git rebase'
abbr -g gra 'git rebase --abort'
abbr -g grc 'git rebase --continue'
abbr -g gri 'git rebase --interactive'
abbr -g grs 'git rebase --skip'

# Stash (s)
abbr -g gs 'git stash'
abbr -g gss 'git stash --staged'
abbr -g gsa 'git stash apply'
abbr -g gsx 'git stash drop'
abbr -g gsl 'git stash list'
abbr -g gsd 'git stash show --patch --stat'
abbr -g gsp 'git stash pop'
abbr -g gsA 'git stash save --all'
abbr -g gsu 'git stash save --include-untracked'
abbr -g gsi 'git stash save --include-untracked --keep-index'

# Status (S)
abbr -g gS 'git status'
abbr -g gSs 'git status --short'
abbr -g gSm 'git submodule status'

# Tag (t)
abbr -g gt 'git tag'
abbr -g gtl 'git tag --list'
abbr -g gts 'git tag --sign'
abbr -g gtv 'git verify-tag'

# Working Copy (w)
abbr -g gwr 'git reset --soft'
abbr -g gwr1 'git reset --soft HEAD~1'
abbr -g gwR 'git-stash-if-dirty; git reset --hard'
abbr -g gwR1 'git-stash-if-dirty; git reset --hard HEAD~1'
abbr -g gwc 'git clean --dry-run'
abbr -g gwC 'git clean --force'
abbr -g gwx 'git rm -r'
abbr -g gwX 'git rm -r --force'

# Functions
function git-inside -a dir
    [ -z $dir ] && set -l dir .
    command git -C $dir rev-parse --is-inside-work-tree >/dev/null 2>&1
end

function git-dirty -a dir
    # The first checks for staged changes, the second for unstaged ones.
    # We put them in this order because checking staged changes is *fast*.
    not command git -C $dir diff-index --ignore-submodules --cached --quiet HEAD -- >/dev/null 2>&1
    or not command git -C $dir diff --ignore-submodules --no-ext-diff --quiet --exit-code >/dev/null 2>&1
    and echo
end

function git-stash-if-dirty
    git-dirty $PWD
end

function git-commit-lost
    if not git-inside
        echo (status current-command) ": not a repository work tree: $PWD" >&2
        return 1
    end
    command git fsck 2>/dev/null \
        | grep "^dangling commit" \
        | awk '{print $3}' \
        | command git log --date-order --no-walk --stdin --pretty=format:$_git_log_oneline_format
end

function git-branch-current
    if not git-inside
        echo (status current-command) ": not a repository: $PWD" >&2
        return 1
    end

    set -l ref (command git symbolic-ref HEAD 2>/dev/null)
    if [ -n $ref ]
        echo (string sub -s (string length 'refs/heads/+') $ref)
        return 0
    else
        return 1
    end
end

abbr -g gea "git-exec-all"
abbr -g goa "git-exec-all --dirty --exec='$GIT_OPENER {}'"
abbr -g gfa "git-exec-all --exec='git -C {} fetch'"
abbr -g gpa "git-exec-all --exec='git -C {} push'"
abbr -g gPa "git-exec-all --exec='git -C {} pull'"
abbr -g gPpa "git-exec-all --exec='git -C {} pull && git -C {} push'"
abbr -g gppa "git-exec-all --exec='git -C {} pull && git -C {} push'"
function git-exec-all
    argparse -i 'd/dirty' 'l/max_level=?' 'exec=?' 'v/verbose' -- $argv

    [ -z $_flag_max_level ] && set -l _flag_max_level 3
    [ -z $_flag_exec ] && set -l _flag_exec 'git status -C'

    set -l dirs .
    [ (count $argv) -gt 0 ] && set dirs $argv
    set -l git_dirs (find $dirs -maxdepth $_flag_max_level -path '*/.git')

    if [ (count $git_dirs) -eq 0 ]
        echo 'No git repositories found.'
        return 1
    else if set -q _flag_verbose
        echo "Running $_flag_exec in:"
        printf '%s\n' (string sub -e -5 $git_dirs)
    end

    function git-exec -V _flag_dirty -V _flag_exec -a dir
        if not set -q _flag_dirty || git-dirty $dir
            set -l cmd (string replace -a '{}' (realpath $dir) $_flag_exec)
            echo (set_color -o black)'Command: '(set_color brred)$cmd(set_color normal)
            eval $cmd
        end
    end

    if [ (count $git_dirs) -eq 1 ]
        git-exec (dirname $git_dirs)
    else
        env_parallel --env git-exec -k "git-exec (dirname '{}')" ::: $git_dirs
    end
end
