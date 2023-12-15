#!/bin/bash

# Check if Node.js version is adequate
REQUIRED_NODE_VERSION=14
CURRENT_NODE_VERSION=$(node -v | grep -o '[0-9]\+' | head -1)

if [ "$CURRENT_NODE_VERSION" -lt "$REQUIRED_NODE_VERSION" ]; then
    echo "Node.js is outdated (current version: $CURRENT_NODE_VERSION). Updating Node.js..."
    sudo npm install -g n
    sudo n stable
fi

# Check and update npm
if command -v npm &> /dev/null; then
    echo "npm is already installed. Updating to the latest version."
    sudo npm install npm@latest -g
else
    echo "npm is not installed. Installing the latest version."
    curl -L https://www.npmjs.com/install.sh | sh
fi

# Check and update pm2
if npm list -g pm2 &> /dev/null; then
    echo "pm2 is already installed globally. Updating to the latest version."
    sudo npm install pm2@latest -g
else
    echo "pm2 is not installed globally. Installing the latest version."
    sudo npm install pm2@latest -g
fi

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# Deploy the app with pm2 using ecosystem.config.js
echo "Deploying the app with pm2..."
pm2 start ecosystem.config.js

echo "Deployment complete."
