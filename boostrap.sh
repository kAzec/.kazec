#! /usr/bin/env zsh

# /bin/zsh -ic "$(curl -fsSL 'https://raw.githubusercontent.com/kAzec/.kazec/master/boostrap.sh')"

export DOTFILES="$HOME/.kazec"
export DOTFILES_REPO='git@github.com:kAzec/.kazec.git'
if [[ $(/usr/bin/uname -m) == "arm64" ]]; then
  export BREW="/opt/homebrew/bin/brew"
else
  export BREW="/usr/local/bin/brew"
fi
export BREWFILE='https://gist.githubusercontent.com/kAzec/9cb61c9482daae6ac7673047a9df3bf2/raw/Brewfile'
export XCODE='/Applications/Xcode.app'
export SSH_KEY_MAIL='kazecx@gmail.com'
export SSH_KEY_NAME='kazecx_gmail'

alias ring='afplay /System/Library/Sounds/Ping.aiff -v 2'
alias echo='echo; echo'

if [[ ! -d $DOTFILES ]]; then
  function setup_ssh_file {
    if [ ! -f $1 ]; then
      echo "Generating GitHub $2 key for the first time..."
      ssh-keygen -t ed25519 -C $SSH_KEY_MAIL -N '' -f $1

      echo 'Please add the following pubkey to GitHub. (Copied)'
      echo "$2 key:"
      cat "$1.pub" | tee /dev/tty | pbcopy

      read -s -k '?Press any key to open GitHub...'$'\n'
      open 'https://github.com/settings/ssh/new'
    fi
  }

  local auth_file=$HOME/.ssh/$SSH_KEY_NAME.ed25519
  local sig_file=$HOME/.ssh/$SSH_KEY_NAME.signing.ed25519

  setup_ssh_file $auth_file 'Auth'
  setup_ssh_file $sig_file 'Signning'

  while read -s -k "?Press any key when you're ready to clone dot files..."$'\n'; do
    ssh -i $auth_file -o BatchMode=yes -o StrictHostKeyChecking=accept-new -T git@github.com
    if [[ $? != 255 ]]; then
      break
    fi
  done

  echo 'Cloning dot files...'
  git -c core.sshCommand="ssh -i $auth_file" clone $DOTFILES_REPO $DOTFILES

  echo 'Linking dot files...'
  local timestamp=$(date +%s)
  for src in $(find $DOTFILES ! -name ".*" ! -name "README.md" ! -name $(basename $0) -maxdepth 1); do
    dest="$HOME/.$(basename $src)"
    if [[ -e $dest ]]; then
      echo "Backing up $dest to $dest.$timestamp"
      mv -v $dest $dest.$timestamp
    fi
    ln -vs $src $dest
  done

  if [[ -d $HOME/.ssh.$timestamp ]]; then
    echo "Merging SSH config..."
    mv -v $HOME/.ssh.$timestamp/* $HOME/.ssh/ && rm -d $HOME/.ssh.$timestamp
  fi

  local config_local=$HOME/.config/git/config.local
  if ! grep -q 'signingKey' $config_local >/dev/null 2>&1; then
    echo "Appending signing key to $config_local..."
    echo "
[user]
  signingkey = $(cat $sig_file.pub)
" >>! $HOME/.config/git/config.local
  fi

  $DOTFILES/boostrap.sh

  exit
fi

function setup_homebrew {
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

function setup_fish {
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

function setup_rust {
  echo 'Installing Rust via rustup...'

  if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi
}

function setup_xcode {
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

function setup_brew_apps {
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

function setup_misc {
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
