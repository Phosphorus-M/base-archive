FROM ghcr.io/cgwalters/fedora-silverblue:37
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY ublue-firstboot /usr/bin

RUN rpm-ostree override remove firefox firefox-langpacks && \
    rpm-ostree install zsh neofetch distrobox gnome-tweaks && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    rpm-ostree cleanup -m && \
    ostree container commit
    
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
RUN echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"\
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >>  ~/.zshrc
