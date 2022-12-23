FROM ghcr.io/cgwalters/fedora-silverblue:37
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc

COPY ublue-firstboot /usr/bin

RUN rpm-ostree override replace https://kojipkgs.fedoraproject.org//packages/rpm-ostree/2022.19/2.fc37/x86_64/rpm-ostree-{libs-,}2022.19-2.fc37.x86_64.rpm

RUN rpm-ostree override remove firefox firefox-langpacks && \
    rpm-ostree install zsh neofetch distrobox gnome-tweaks && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    rpm-ostree cleanup -m && \
    ostree container commit
