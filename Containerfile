FROM ghcr.io/cgwalters/fedora-silverblue:37
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY ublue-firstboot /usr/bin

# Fix rpm-ostree, see: https://bodhi.fedoraproject.org/updates/FEDORA-2022-4ad713eb82
# RUN rpm-ostree override replace https://kojipkgs.fedoraproject.org//packages/rpm-ostree/2022.19/2.fc37/x86_64/rpm-ostree-{libs-,}2022.19-2.fc37.x86_64.rpm

RUN wget https://copr.fedorainfracloud.org/coprs/gqman69/plank/repo/fedora-37/gqman69-plank-fedora-37.repo -O /etc/yum.repos.d/gqman69-plank.repo

# Download VSCode in format rpm
RUN curl -L https://go.microsoft.com/fwlink/?LinkID=760867 -o vscode.rpm && rpm-ostree install ./vscode.rpm

RUN wget https://copr.fedorainfracloud.org/coprs/lyessaadi/blackbox/repo/fedora-37/lyessaadi-blackbox-fedora-37.repo -O /etc/yum.repos.d/lyessaadi-blackbox.repo

# gdb Is not installable
RUN rpm-ostree override remove firefox firefox-langpacks && \
    rpm-ostree install pip neovim blackbox-terminal git-credential-libsecret zsh docker moby-engine docker-compose neofetch distrobox gnome-tweaks gnome-shell-extension-gsconnect nautilus-gsconnect plank-0.11.4-99.fc31.x86_64 chromium-libs-media-freeworld openssh-clients autoconf automake binutils gcc gcc-c++ glibc-devel libtool make  && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    rm -f /etc/yum.repos.d/lyessaadi-blackbox.repo && \
    rpm-ostree cleanup -m && \
    ostree container commit

