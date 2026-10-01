ARG BASE_IMAGE=debian:trixie
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Kolkata \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    CLEAN_DOT_INSTALL=no

RUN apt-get update

RUN LANG=C LC_ALL=C LANGUAGE=C apt-get install -y locales && \
    sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

RUN apt-get install -y sudo

RUN apt-get install -y wget curl trurl ca-certificates

RUN apt-get install -y tzdata tzdata-legacy tzwatch && \
    ln -snf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime && \
    echo "Asia/Kolkata" > /etc/timezone

RUN apt-get install -y neovim vim zsh zsh-doc bash bash-completion zsh-syntax-highlighting zsh-autosuggestions

RUN apt-get install -y git gnupg jq dos2unix tar zip unzip xz-utils 7zip putty

RUN apt-get install -y python3-venv python3-dev python3-httpx python3-docker python3-requests

RUN apt-get install -y ffmpeg

RUN apt-get install -y sshfs

RUN apt-get install -y ninja-build gettext cmake build-essential gcc

RUN (getent group sudo || groupadd --system sudo) && \
    (getent group wheel || groupadd --system wheel) && \
    mkdir -p /etc/sudoers.d && \
    echo "root ALL=(ALL:ALL) ALL" > /etc/sudoers.d/1000-root && \
    echo "%sudo ALL=(ALL:ALL) ALL" > /etc/sudoers.d/1100-sudo && \
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/1200-wheel
RUN (id -u vscode >/dev/null 2>&1 && userdel -r vscode || true) && \
    (getent group vscode >/dev/null 2>&1 && groupdel vscode || true) && \
    useradd -m -s /bin/zsh -G wheel iac-ctl
ADD --chown=iac-ctl:iac-ctl --chmod=755 \
    https://raw.githubusercontent.com/arpanrec/dotfiles/refs/heads/main/install-dotfiles.sh \
    /tmp/install-dotfiles.sh
ADD --chown=iac-ctl:iac-ctl --chmod=755 \
    https://raw.githubusercontent.com/arpanrec/dotfiles/refs/heads/main/setup-workspace.sh \
    /tmp/setup-workspace.sh
USER iac-ctl
WORKDIR /tmp
RUN ./install-dotfiles.sh && rm -f ./install-dotfiles.sh
RUN ./setup-workspace.sh --tags all && rm -f ./setup-workspace.sh
USER root
WORKDIR /

RUN apt-get update && apt-get full-upgrade -y && \
    apt-get autopurge -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*
