#!/usr/bin/env fish

set BREWFILE_ID '9cb61c9482daae6ac7673047a9df3bf2'
set BREWFILE_NAME 'Brewfile'

if not command -v gh &>/dev/null
    echo 'Installing gh...'
    brew install gh
end

if not gh auth status
    gh auth login
end

set tempfile (mktemp)
brew bundle dump --file=- >>$tempfile
gh gist view $BREWFILE_ID -r -f $BREWFILE_NAME >>$tempfile
sort -u $tempfile | pbcopy
rm $tempfile

set saved_editor $EDITOR
set -gx EDITOR nvim
gh gist edit $BREWFILE_ID -f $BREWFILE_NAME
set -gx EDITOR $saved_editor