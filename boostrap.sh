#! /usr/bin/env zsh

# /bin/zsh -c "$(curl -fsSL 'https://raw.githubusercontent.com/kAzec/.kazec/main/boostrap.sh?token=TOKEN_NEEDED')"

export DOTFILES="$HOME/.kazec"
export DOTFILES_REPO='git@github.com:kAzec/.kazec.git'
if [[ $(/usr/bin/uname -m) == "arm64" ]]; then
  export BREW="/opt/homebrew/bin/brew"
else
  export BREW="/usr/local/bin/brew"
fi
export BREWFILE='https://gist.githubusercontent.com/kAzec/9cb61c9482daae6ac7673047a9df3bf2/raw/Brewfile'
export XCODE='/Applications/Xcode.app'

alias ring='afplay /System/Library/Sounds/Ping.aiff -v 2'
alias echo='echo; echo'

if [[ ! -d $DOTFILES ]]; then
  echo 'Generating one-time SSH key for cloning dot files...'
  tempkey=$(mktemp)
  ssh-keygen -t ed25519 -C "kazecx@gmail.com" -N '' -f $tempkey
  echo 'Please add the following pubkey to GitHub SSH keys (Copied).'
  cat "$tempkey.pub" | tee /dev/tty | pbcopy

  read -s -k '?Press any key to open GitHub...'$'\n'
  open 'https://github.com/settings/ssh/new'

  read -s -k '?Press any key to continue cloning...'$'\n'
  git -c core.sshCommand="ssh -i $tempkey" clone $DOTFILES_REPO $DOTFILES

  echo 'Linking dot files...'
  for src in $(find $DOTFILES ! -name ".*" ! -name $(basename $0) -maxdepth 1); do
    dest="$HOME/.$(basename $src)"
    [[ -e $dest ]] && echo "Backing up $dest" && mv $dest $dest.bak
    ln -vs $src $dest
  done

  $DOTFILES/zsh/boostrap.sh
  echo "All done, it's now safe to remove previously added SSH key from GitHub."
  exit
fi

function setup_homebrew()
{
  if [[ ! -f $BREW ]]; then
    echo 'Installing Homebrew...'
    ring
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$($BREW shellenv)"
  fi

  echo 'Removing potentially incomplete downloads...'
  brew cleanup -s

  if ! command -v parallel >/dev/null 2>&1; then
    echo 'Installing gnu-parallel...'
    brew install parallel
    echo 'will cite' | parallel --citation > /dev/null 2>&1
  fi
}

function setup_fish()
{
  if ! command -v fish >/dev/null 2>&1; then
    echo 'Installing fish shell...'
    brew install fish
  fi

  if ! grep -q fish /etc/shells; then
    echo $(which fish) | sudo tee -a /etc/shells > /dev/null

    ring
    chsh -s $(which fish)
  fi
}

setup_homebrew && echo '...Homebrew OK'
setup_fish && echo '...fish shell OK'

source `which env_parallel.zsh`

env_parallel --record-env

function setup_rust()
{
  echo 'Installing Rust via rustup...'

  if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi
}

function setup_xcode()
{
  [[ -d $XCODE ]] && return 0

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
  curl -fsSL $BREWFILE | $BREW bundle --file=-
}

echo 'Running multiple commands in parallel...'

printf "
setup_rust && echo '...Rust OK'
setup_xcode && echo '...Xcode OK'
setup_brew_apps && echo '...Homebrew Apps OK'
" | env_parallel

function setup_misc()
{
  echo 'Copying SF-Mono fonts...'
  cp /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/* $HOME/Library/Fonts >/dev/null 2>&1

  if ! grep -q pam_tid /etc/pam.d/sudo; then
    echo 'Enabling Touch-ID for terminal sudo...'
    ring
    awk 'NR==2 {print "auth       sufficient     pam_tid.so"} 1' /etc/pam.d/sudo | sudo tee /etc/pam.d/sudo.new >/dev/null
    sudo cp /etc/pam.d/sudo /etc/pam.d/sudo.bak
    sudo mv /etc/pam.d/sudo.new /etc/pam.d/sudo
  fi

  $DOTFILES/sync/sync.fish
}

setup_misc && echo '...Misc OK'
