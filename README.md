# Debian Devcontainer

A Debian-based development container image for `linux/amd64` and `linux/arm64`.

## Contents

The image starts from `debian:trixie` and adds:

- Locale `en_US.UTF-8` and timezone `Asia/Kolkata`
- Shells and editors: zsh (with syntax highlighting and autosuggestions), bash, neovim, vim
- Tools: git, gnupg, curl, wget, trurl, jq, sshfs, ffmpeg, sudo, and common archive utilities (tar, zip, unzip, xz-utils, 7zip)
- Python 3 with venv, dev headers, httpx, docker, and requests
- Build tools: build-essential, gcc, cmake, ninja-build, gettext

## User

The default user is `iac-ctl`, with zsh as its login shell. It belongs to the `wheel` group, which has passwordless
sudo. The image removes the `vscode` user and group that some base images create.

The build runs `install-dotfiles.sh` and `setup-workspace.sh --tags all` from
[arpanrec/dotfiles](https://github.com/arpanrec/dotfiles) as `iac-ctl`, so the dotfiles and workspace setup come from
that repository's `main` branch at build time.

## Build

```bash
docker build -t debian-devcontainer .
```

Use another base image with the `BASE_IMAGE` build argument:

```bash
docker build --build-arg BASE_IMAGE=debian:bookworm -t debian-devcontainer .
```

## Use as a dev container

Reference the published image in `.devcontainer/devcontainer.json`:

```json
{
    "image": "docker.io/<user>/debian-devcontainer:<version>",
    "remoteUser": "iac-ctl"
}
```

## Releases

Publishing a GitHub release builds the image for both architectures and pushes it to Docker Hub, tagged with the release
tag.
