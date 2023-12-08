# Use the base Node.js image
FROM node:20-bullseye-slim

# Install Git, Zsh, and Wget
RUN apt-get update && apt-get install -y git zsh wget

# Set Zsh as the default shell for the node user
RUN chsh -s /bin/zsh node

# Change to the node user to install Oh My Zsh
USER node

# Install Oh My Zsh for the node user
RUN wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

# Clone zsh-syntax-highlighting plugin
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/home/node/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Clone powerlevel10k theme
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-/home/node/.oh-my-zsh/custom}/themes/powerlevel10k

# Check if .zshrc exists, configure Oh My Zsh, zsh-syntax-highlighting plugin, and create zsh history directory
RUN if [ -f /home/node/.zshrc ]; then \
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' /home/node/.zshrc && \
    echo 'export LS_COLORS="di=1;34:ln=35"' >> /home/node/.zshrc && \
    echo 'plugins=(git zsh-syntax-highlighting)' >> /home/node/.zshrc && \
    mkdir -p /home/node/zsh && \
    echo 'HISTFILE=/home/node/zsh/.zsh_history' >> /home/node/.zshrc; \
    fi

# Set Zsh as the default shell for subsequent commands
SHELL ["/bin/zsh", "-c"]

# Switch back to root user to clean up
USER root
RUN apt-get clean

# Configure user and working directory
USER node
WORKDIR /home/node/app

# Default command to keep the container running
CMD ["tail", "-f", "/dev/null"]
