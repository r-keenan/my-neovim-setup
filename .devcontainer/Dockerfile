# Use Fedora as base image
FROM fedora:42

# Install system dependencies
RUN dnf update -y && dnf install -y \
    # Basic utilities
    curl \
    wget \
    git \
    unzip \
    # Build tools
    gcc \
    gcc-c++ \
    make \
    cmake \
    pkgconfig \
    # Python and Node.js (for Neovim plugins)
    python3 \
    python3-pip \
    nodejs \
    npm \
    # Additional tools
    ripgrep \
    fd-find \
    fzf \
    tree \
    htop \
    zsh \
    # Neovim dependencies
    libtool \
    autoconf \
    automake \
    gettext \
    && dnf clean all

# Install .NET 8 and .NET 9 SDKs
RUN dnf install -y dotnet-sdk-8.0 dotnet-sdk-9.0 \
    && dnf clean all

# Install Ghostty terminal
RUN dnf copr enable scottames/ghostty -y \
    && dnf install ghostty -y \
    && dnf clean all

# Install lazygit
RUN dnf install lazygit -y \
    && dnf clean all

# Install Homebrew for Linux
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    && echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /etc/profile \
    && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install Neovim, Pulumi, Go, 1Password CLI, and uv via Homebrew
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && brew install neovim pulumi go 1password-cli uv

# Install vectorcode using uv
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    && uv tool install vectorcode

# Install language servers and tools commonly used with Neovim
RUN npm install -g \
    typescript \
    typescript-language-server \
    vscode-langservers-extracted \
    @tailwindcss/language-server \
    pyright

# Install Python packages for Neovim
RUN pip3 install \
    pynvim \
    black \
    flake8 \
    mypy

# Create a non-root user and set up Homebrew permissions
RUN useradd -m -s /bin/zsh r-keenan \
    && usermod -aG sudo r-keenan \
    && echo 'r-keenan ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && chown -R r-keenan:r-keenan /home/linuxbrew/.linuxbrew 2>/dev/null || true

# Install Oh My Zsh for better terminal experience
USER r-keenan
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

# Create necessary directories
RUN mkdir -p /home/r-keenan/.config/nvim

# Copy and set up entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set working directory
WORKDIR /workspace

# Switch back to r-keenan user
USER r-keenan 

# Set environment variables
ENV SHELL=/bin/zsh
ENV EDITOR=nvim

# Use entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]