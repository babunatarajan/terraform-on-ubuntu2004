#!/usr/bin/env bash

echo "Setting up Terraform CLI on Ubuntu 20.04 Server"
echo "Make sure the user has SUDO privilege to run script... hit CTRL+C to stop the setup..."
sleep 20

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install terraform

echo "You can install a specific version to match the existing version on another instances..."
echo "sudo apt install terraform=0.14.0"


echo "Setup Azure Cloud..."

sudo apt update && sudo apt -y upgrade azure-cli

echo "Remove the previously created subscription_id from the bashrc file."
sed -i "s:\$HOME/.azure/credentials | xargs):\$HOME/.azure/credentials | sed '/subscription_id/d' | xargs):" ~/.bashrc

echo "Add the following function in your startup to parse the previously created credentials file and include the pertinent login information as a servicePrincipal to Terraform, in a sub-shell:"
cat << 'EOF' >> ~/.bashrc
function terraform-az-sp() {
    (export $(grep -v '^\[' $HOME/.azure/credentials | sed 's/application_id/arm_client_id/; s/client_secret/arm_client_secret/; s/directory_id/arm_tenant_id/; s/subscription_id/arm_subscription_id/; s/^[^=]*/\U&\E/' | xargs) && terraform $*)
}
EOF

echo "Source the updated .bashrc file"
source ~/.bashrc

echo "Add the subscription_id..."
echo "You can grab the scubscription_id from Azure portal (Search for Subscriptions from top Subscriptions -> Click your subscription -> Overview) in to the Azure credentials file (replace <SUBSCRIPTION ID>):"

echo "still working on updating the script..."

