FROM node:20-bullseye-slim

RUN apt-get update && apt-get install -y git zsh wget
RUN chsh -s /bin/zsh node

USER node

RUN wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/home/node/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

RUN if [ -f /home/node/.zshrc ]; then \
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' /home/node/.zshrc && \
    echo 'export LS_COLORS="di=1;34:ln=35"' >> /home/node/.zshrc && \
    echo 'plugins=(git zsh-syntax-highlighting)' >> /home/node/.zshrc && \
    mkdir -p /home/node/zsh && \
    echo 'HISTFILE=/home/node/zsh/.zsh_history' >> /home/node/.zshrc; \
    fi
SHELL ["/bin/zsh", "-c"]

USER node
WORKDIR /home/node/app
CMD ["tail", "-f", "/dev/null"]
