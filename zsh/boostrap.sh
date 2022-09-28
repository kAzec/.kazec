#! /usr/bin/env zsh

DOTFILES="$HOME/.kazec"
DOTFILES_REPO='git@github.com:kAzec/.kazec.git'
BREW='/opt/homebrew/bin/brew'
BREWFILE='https://gist.githubusercontent.com/kAzec/9cb61c9482daae6ac7673047a9df3bf2/raw/Brewfile'
XCODE='/Applications/Xcode.app'

alias ring='afplay /System/Library/Sounds/Ping.aiff -v 2'

if [ ! -d $DOTFILES ]; then
  echo 'Generating one-time SSH key for cloning dot files...'
  tempkey=$(mktemp)
  ssh-keygen -t ed25519 -C "kazecx@gmail.com" -N '' -f $tempkey
  echo 'Please add the following pubkey to GitHub SSH keys (Copied).'
  cat "$tempkey.pub" | tee /dev/tty | pbcopy
  read -s -k '?Press any key to continue.'
  echo 'Cloning dot files...'
  git clone --recurse-submodules -j8 $DOTFILES_REPO $DOTFILES
  echo '...dot files OK.'
  echo "It's now safe to remove previously added SSH key from GitHub."
  
  echo 'Linking dot files...'
  find $DOTFILES ! -name ".*" -maxdepth 1 -execdir ln -vs "$DOTFILES/{}" "$HOME/.{}" ';'
fi

function setup_homebrew()
{
  if [ ! $(command -v brew) ]; then
    echo 'Install Homebrew...'
    ring
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$($BREW shellenv)"
  fi

  echo 'Removing potentially incomplete downloads...'
  brew cleanup -s

  if [ ! $(command -v parallel) ]; then
    echo 'Installing gnu-parallel...'
    brew install parallel
    echo 'will cite' | parallel --citation > /dev/null 2>&1 
  fi
}

function setup_fish()
{
  if [ ! $(command -v fish) ]; then
    echo 'Installing fish shell...'
    brew install fish
    echo $(which fish) | sudo tee -a /etc/shells
    
    ring
    chsh -s $(which fish)
  fi
}

setup_zsh && echo '...zsh shell OK'
setup_homebrew && echo '...Homebrew OK'
setup_fish && echo '...fish shell OK'

source `which env_parallel.zsh`

env_parallel --record-env

function setup_xcode()
{
  [ -d $XCODE ] && return 0

  echo 'Install Latest Xcode...'

  $BREW install aria2
  $BREW install robotsandpencils/made/xcodes
  xcodes install --latest --experimental-unxip

  ring
  echo 'Accepting Xcode License...'
  sudo xcodebuild -license accept

  echo 'Running Xcode First Launch...'
  xcodebuild -runFirstLaunch
}

function setup_brew_apps()
{
  echo 'Restoring Homebrew Apps...'

  $BREW tap Homebrew/bundle
  curl -fsSL $BREWFILE | /opt/homebrew/bin/brew bundle --file=-
}

function setup_misc()
{
  echo 'Copying SF-Mono fonts...'
  cp /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/* $HOME/Library/Fonts > /dev/null 2>&1

  if [ ! -f /etc/pam.d/sudo.bak ]; then
    echo 'Enabling Touch-ID for terminal sudo...'
    ring
    awk 'NR==2 {print "auth       sufficient     pam_tid.so"} 1' /etc/pam.d/sudo | sudo tee /etc/pam.d/sudo.new > /dev/null
    sudo cp /etc/pam.d/sudo /etc/pam.d/sudo.bak
    sudo mv /etc/pam.d/sudo.new /etc/pam.d/sudo
  fi
}

echo 'Running multiple commands in parallel...'

printf "
setup_xcode && echo '...Xcode OK'
setup_brew_apps && echo '...Homebrew Apps OK'
" | env_parallel

misc && echo '...Misc OK'
