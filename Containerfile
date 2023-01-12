FROM ghcr.io/cgwalters/fedora-silverblue:37
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY ublue-firstboot /usr/bin

# RUN rpm-ostree override replace https://kojipkgs.fedoraproject.org//packages/rpm-ostree/2022.19/2.fc37/x86_64/rpm-ostree-{libs-,}2022.19-2.fc37.x86_64.rpm

# Download VSCode in format rpm
RUN curl -L https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64 -o vscode.rpm && rpm-ostree install ./vscode.rpm

RUN wget https://copr.fedorainfracloud.org/coprs/lyessaadi/blackbox/repo/fedora-37/lyessaadi-blackbox-fedora-37.repo -O /etc/yum.repos.d/lyessaadi-blackbox.repo

RUN rpm-ostree override remove firefox firefox-langpacks && \
    rpm-ostree install zsh neofetch distrobox gnome-tweaks gnome-shell-extension-gsconnect nautilus-gsconnect blackbox-terminal  && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    rm -f /etc/yum.repos.d/lyessaadi-blackbox.repo && \
    rpm-ostree cleanup -m && \
    ostree container commit


# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh && \
    chmod +x rustup.sh && \
    ./rustup.sh -y && \
    rm -f rustup.sh