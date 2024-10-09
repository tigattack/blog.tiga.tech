#!/usr/bin/env bash -e

dlpath="/tmp/hugo.rb"

if [ -z $1 ]; then
  echo "Empty hash, will not proceed."
  exit 1
fi

curl -s -o "$dlpath" https://raw.githubusercontent.com/Homebrew/homebrew-core/${1}/Formula/h/hugo.rb
HOMEBREW_NO_AUTO_UPDATE=1 brew uninstall hugo
HOMEBREW_NO_AUTO_UPDATE=1 brew install --formula "$dlpath"
rm "$dlpath"
