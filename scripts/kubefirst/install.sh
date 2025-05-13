#!/bin/bash

# Nix - Install Homebrew on Linux or macOS
echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Locate the brew executable after installation
echo "Configuring Homebrew environment..."
if [ -x "/usr/local/bin/brew" ]; then
    # macOS typically installs here
    BREW_EXEC="/usr/local/bin/brew"
elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    # Linux standard location with sudo access
    BREW_EXEC="/home/linuxbrew/.linuxbrew/bin/brew"
elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
    # Linux user-specific location without sudo
    BREW_EXEC="$HOME/.linuxbrew/bin/brew"
else
    echo "Error: Could not find brew executable after installation."
    exit 1
fi

# Set up the environment for the current session
eval "$($BREW_EXEC shellenv)"

# Verify Homebrew is working
if ! command -v brew >/dev/null 2>&1; then
    echo "Error: brew command not available after setup."
    exit 1
else
    echo "Homebrew installed and configured successfully."
fi

# Install mkcert using Homebrew
brew install mkcert
mkcert -install

# Download and install kubefirst (Linux-specific in original script)
curl -L -o /tmp/kubefirst_2.8.4_linux_amd64.tar.gz https://github.com/konstructio/kubefirst/releases/download/v2.8.4/kubefirst_2.8.4_linux_amd64.tar.gz
sudo tar --overwrite -xvf /tmp/kubefirst_2.8.4_linux_amd64.tar.gz -C /usr/local/bin
sudo chmod +x /usr/local/bin/kubefirst
kubefirst version

# Install K3D
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Install Kubectl
sudo apt install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubectl


# Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
bash get_helm.sh
helm version

# Clean up temporary files
rm -f /tmp/kubefirst_2.8.4_linux_amd64.tar.gz

# Set up SSH
mkdir -p ~/.ssh
ssh-keyscan gitlab.com > ~/.ssh/known_hosts

# Run the create-cluster script
sh scripts/create-cluster.sh

echo "Setup complete. If Homebrew commands are not available in new terminal sessions,"
echo "please restart your terminal or source your shell configuration file (e.g., ~/.bashrc or ~/.zshrc)."
