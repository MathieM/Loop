#!/bin/sh
if ! [ -x "$(command -v brew)" ]; then
    # Install Homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if brew ls carthage > /dev/null; then
    brew upgrade carthage || echo "Continuing…"
else
    brew install carthage
fi

