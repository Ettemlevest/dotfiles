#!/usr/bin/env bash

#
# Bootstraps a new macOS system
#

# List of packages to install
packages=(
    # Essentials (cli)
    tree
    htop
    fzf
    # Essentials (gui)
    alt-tab
    keepassxc
    rectangle
    # Development
    php
    node
    mysql
)

# some
BLUE='\033[0;34m'
NC='\033[0m'

function log() {
    echo -e "${BLUE}$1"
    echo -e "${BLUE}-----------------${NC}"
}

# Start the installation process
log "Preparing before installations"
brew update
brew upgrade

for package in "${packages[@]}"
do
    log "Installing ${package}"
    brew install ${package}  
done

log "Cleaning up"
brew cleanup