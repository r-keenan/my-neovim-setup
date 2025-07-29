#!/bin/zsh

# Neovim Development Container Entrypoint Script
# This script handles all the setup and keeps the container running

echo "🚀 Starting Neovim Development Container..."

# Initialize Homebrew environment
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/r-keenan/.zshrc

# Ensure proper permissions for mounted directories
sudo chown -R r-keenan:r-keenan /home/r-keenan/.config/nvim 2>/dev/null || true

# Set up git if gitconfig is mounted
if [ -f /home/r-keenan/.gitconfig ]; then
    echo "✅ Git configuration found"
else
    echo "⚠️  No git configuration found - you may want to mount ~/.gitconfig"
fi

# Set up SSH if keys are mounted
if [ -d /home/r-keenan/.ssh ]; then
    sudo chmod 700 /home/r-keenan/.ssh
    sudo chmod 600 /home/r-keenan/.ssh/* 2>/dev/null || true
    sudo chown -R r-keenan:r-keenan /home/r-keenan/.ssh
    echo "✅ SSH keys configured"
fi

# Handle Ghostty configuration override
echo "🔧 Setting up Ghostty configuration..."
if [ -d /home/r-keenan/.config/ghostty ]; then
    echo "📁 Existing Ghostty config found - backing up and overriding with repo config"
    mv /home/r-keenan/.config/ghostty /home/r-keenan/.config/ghostty.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
fi

# Clone the Ghostty config repository
echo "📥 Cloning Ghostty config from repository..."
git clone https://github.com/r-keenan/ghostty-config.git /home/r-keenan/.config/ghostty 2>/dev/null || {
    echo "⚠️  Failed to clone Ghostty config repository - using default config"
    mkdir -p /home/r-keenan/.config/ghostty
}

# Ensure proper ownership
sudo chown -R r-keenan:r-keenan /home/r-keenan/.config/ghostty 2>/dev/null || true
echo "✅ Ghostty configuration ready"

# Check if Neovim config is available
if [ -d /home/r-keenan/.config/nvim ]; then
    echo "✅ Neovim configuration mounted successfully"
else
    echo "⚠️  Neovim configuration not found - creating basic setup"
    mkdir -p /home/r-keenan/.config/nvim
fi

# Display useful information
echo ""
echo "🎉 Container is ready!"
echo "📁 Workspace: /workspace"
echo "⚙️  Neovim config: /home/r-keenan/.config/nvim"
echo "🔧 To start Neovim: nvim"
echo "🐚 Shell: zsh with Oh My Zsh"
echo ""
echo "💡 Useful commands:"
echo "   nvim          - Start Neovim"
echo "   nvim .        - Open current directory in Neovim"
echo "   lazygit       - Terminal UI for Git"
echo "   ghostty       - Launch Ghostty terminal"
echo "   pulumi        - Infrastructure as Code tool"
echo "   go            - Go programming language"
echo "   op            - 1Password CLI"
echo "   uv            - Fast Python package manager"
echo "   vectorcode    - AI code analysis tool"
echo "   brew          - Homebrew package manager"
echo "   exit          - Exit the container"
echo ""

# Keep the container running and start an interactive shell
exec /bin/zsh
