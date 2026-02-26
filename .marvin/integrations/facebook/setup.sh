#!/bin/bash

# Facebook Integration Setup for MARVIN
# This script configures Facebook Graph API access with safety guardrails

set -e

echo "🔐 Facebook Social Media Manager Setup"
echo "======================================="
echo ""

# Check for required tools
check_requirements() {
    if ! command -v python3 &> /dev/null; then
        echo "❌ Python 3 is required but not installed."
        exit 1
    fi
    
    if ! python3 -c "import requests" &> /dev/null; then
        echo "Installing required Python packages..."
        pip3 install requests python-dotenv==1.0.0
    fi
}

# Get Meta App credentials
get_credentials() {
    echo "📱 Meta App Configuration"
    echo ""
    echo "1. Go to: https://developers.facebook.com/apps"
    echo "2. Create or select your app"
    echo "3. Add 'Facebook Graph API' product"
    echo "4. Go to Settings > Basic to find your App ID & App Secret"
    echo ""
    
    read -p "Enter your Meta App ID: " app_id
    read -sp "Enter your App Secret (won't be shown): " app_secret
    echo ""
