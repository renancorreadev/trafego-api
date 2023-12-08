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

# Clone git-flow
RUN git clone https://github.com/nvie/gitflow.git ${ZSH_CUSTOM:-/home/node/.oh-my-zsh/custom}/plugins/git-flow

# Clone F-Sy-H zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/home/node/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Clone zsh-completions
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-/home/node/.oh-my-zsh/custom}/plugins/zsh-completions

# Check if .zshrc exists, configure Oh My Zsh, zsh-syntax-highlighting plugin, and create zsh history directory
RUN if [ -f /home/node/.zshrc ]; then \
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' /home/node/.zshrc && \
    echo 'export LS_COLORS="di=1;34:ln=35"' >> /home/node/.zshrc && \
    sed -i 's/plugins=(git zsh-syntax-highlighting)/plugins=(git zsh-syntax-highlighting git-flow zsh-autosuggestions zsh-completions)/' /home/node/.zshrc && \
    echo 'source ${ZSH_CUSTOM:-/home/node/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' >> /home/node/.zshrc && \
    mkdir -p /home/node/zsh && \
    echo 'HISTFILE=/home/node/zsh/.zsh_history' >> /home/node/.zshrc; \
    fi

# Download and set the Powerlevel10k config file
RUN wget -O /home/node/.p10k.zsh https://raw.githubusercontent.com/romkatv/powerlevel10k/master/config/p10k-rainbow.zsh

# Ensure the .p10k.zsh file is sourced in .zshrc
RUN echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> /home/node/.zshrc


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
