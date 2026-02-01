# Shizuku-Termux

> A professional tool to bridge Shizuku with Termux.

## Features
- **Auto-Injection**: Automatically moves binaries to `$PREFIX/bin`.
- **Zero-Config Patching**: Automatically removes `BASEDIR` and maps `DEX` to absolute system paths.
- **Dual Mode**: Install from local exported files or fetch directly from GitHub.
- **Persistent Backups**: Keeps a copy of binaries in `Documents/aerixy/`.

## Quick Start
```bash
curl -sL [https://raw.githubusercontent.com/aliyoariel/shizuku-termux/main/install.sh](https://raw.githubusercontent.com/aliyoariel/shizuku-termux/main/init.sh) | bash
