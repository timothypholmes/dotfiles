#!/usr/bin/env bash

# NPM functions and aliases

# NPM aliases
alias ni="npm install"
alias nis="npm install --save"
alias nid="npm install --save-dev"
alias nig="npm install --global"
alias nr="npm run"
alias ns="npm start"
alias nt="npm test"
alias nb="npm run build"
alias nls="npm list"
alias nlsg="npm list --global --depth=0"
alias nou="npm outdated"
alias nup="npm update"
alias nri="rm -rf node_modules && npm install"
alias ncc="npm cache clean --force"

# Yarn aliases (if preferred)
alias yi="yarn install"
alias ya="yarn add"
alias yad="yarn add --dev"
alias yag="yarn global add"
alias yr="yarn run"
alias ys="yarn start"
alias yt="yarn test"
alias yb="yarn build"
alias yls="yarn list"
alias you="yarn outdated"
alias yup="yarn upgrade"
alias yri="rm -rf node_modules && yarn install"

# Package.json helpers
function npm-init-quick() {
    npm init -y
    echo "package.json created with defaults"
}

function npm-list-scripts() {
    if [ -f "package.json" ]; then
        cat package.json | jq '.scripts'
    else
        echo "No package.json found"
    fi
}