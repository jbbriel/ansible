#!/bin/bash

# Prompt the user for API key
echo "Please enter your API key:"
read -s API_KEY
echo "-------------------------------------------------------------"

# Check if the API key is empty
if [ -z "$API_KEY" ]; then
    echo "Error: API key cannot be empty."
else
    # Authenticate using the API key
    TOKEN=$(curl -s --header "Accept-Encoding: base64" \
                --data "$API_KEY" \
                https://conjur-nonprod-follower.cisco.com/authn/cisco/host%2Fit%2Fcode-checkmarx-automation%2Fcheckmarx-vault%2Fcheckmarx-webapp/authenticate)

    # Check if authentication was successful
    if [ -n "$TOKEN" ]; then
        echo "Authentication successful!! :D"

        # Pull the vault password using the token
        VAULT_PASSWORD=$(curl -s --header "Authorization: Token token=\"$TOKEN\"" \
                         https://conjur-nonprod-follower.cisco.com/secrets/cisco/variable/it%2Fcode-checkmarx-automation%2Fcheckmarx-vault%2Fvault-password)

        # Check if the vault password was retrieved successfully
        echo "-------------------------------------------------------------"
        if [ -n "$VAULT_PASSWORD" ]; then
            echo "Vault password retrieved successfully. (ノ◕ヮ◕)ノ*:・゚✧"
            echo "-------------------------------------------------------------"
            # Store the vault password in .vault_pass one directory behind
            echo "$VAULT_PASSWORD" > "$(dirname "$0")/../.vault_pass"

            echo "Vault password stored in .vault_pass file. (⌐■_■)"
            echo "-------------------------------------------------------------"
            echo -e "Creating BJC_DISABLE_INITIALIZE_FORK_SAFETY variable if not set. This will unrestrict in multithreading in macOS High Sierra and later versions of macOS.\n"
            if [ -z "$OBJC_DISABLE_INITIALIZE_FORK_SAFETY" ]; then
                # Set OBJC_DISABLE_INITIALIZE_FORK_SAFETY variable
                export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
                echo "OBJC_DISABLE_INITIALIZE_FORK_SAFETY set to: $OBJC_DISABLE_INITIALIZE_FORK_SAFETY"
            else
                echo "OBJC_DISABLE_INITIALIZE_FORK_SAFETY is already set."
            fi
            echo "-------------------------------------------------------------"
            # Set up ANSIBLE_VAULT_PASSWORD_FILE variable with the location of .vault_pass file
            export ANSIBLE_VAULT_PASSWORD_FILE=$(realpath "$(dirname "$0")/../.vault_pass")
            echo "ANSIBLE_VAULT_PASSWORD_FILE set to: $ANSIBLE_VAULT_PASSWORD_FILE"
        else
            echo "Error: Failed to retrieve vault password. :'("
        fi
    else
        echo "Authentication failed. Please check your API key and try again."
    fi
fi