# win11

A terminal tool to download the Windows 11 ISO at maximum speed — with background resumable downloads, live progress, and official SHA256 verification.

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   ██╗    ██╗██╗███╗   ██╗ ██╗ ██╗                               ║
║   ██║    ██║██║████╗  ██║███║███║                               ║
║   ██║ █╗ ██║██║██╔██╗ ██║╚██║╚██║                               ║
║   ██║███╗██║██║██║╚██╗██║  ██║ ██║                               ║
║   ╚███╔███╔╝██║██║ ╚████║  ██║ ██║                               ║
║    ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝  ╚═╝ ╚═╝                               ║
║                                                                  ║
║          ISO Downloader  ·  24H2  ·  English x64                ║
╚══════════════════════════════════════════════════════════════════╝
```

## Features

- **Maximum speed** — aria2c with 16 parallel connections
- **Background download** — runs in a tmux session, survives closing your terminal
- **Auto-resume** — picks up exactly where it left off after interruption or reboot
- **SHA256 verification** — checks against Microsoft's official hash on completion
- **Any user** — saves to `$HOME/iso` by default, fully configurable
- **Multi-distro** — detects your package manager and shows the right install command

## Compatibility

| Distro | Supported | Package Manager |
|---|---|---|
| Arch Linux / Manjaro | ✅ | pacman |
| Ubuntu / Debian / Mint | ✅ | apt |
| Fedora / RHEL / CentOS | ✅ | dnf |
| openSUSE | ✅ | zypper |
| macOS (with Homebrew) | ✅ | brew |

**Requirements:** `aria2c`, `tmux`, `sha256sum` (coreutils)

## Install

One line:

```bash
curl -fsSL https://raw.githubusercontent.com/franc417/win11/main/install.sh | bash
```

Or manually:

```bash
sudo curl -fsSL https://raw.githubusercontent.com/franc417/win11/main/win11 -o /usr/local/bin/win11
sudo chmod +x /usr/local/bin/win11
```

Install dependencies first if needed:

```bash
# Arch / Manjaro
sudo pacman -S aria2 tmux coreutils

# Ubuntu / Debian
sudo apt-get install -y aria2 tmux coreutils

# Fedora
sudo dnf install -y aria2 tmux coreutils

# macOS
brew install aria2 tmux
```

## Usage

```
win11             Start or resume download
win11 status      Show progress bar
win11 attach      Open live download session (Ctrl+B D to detach)
win11 stop        Pause download
win11 verify      Re-check SHA256 of existing ISO
win11 clean       Wipe partial files and reset
win11 help        Show help
```

## Quickstart

```bash
# 1. Run it
win11

# 2. Go to microsoft.com/en-us/software-download/windows11
#    Select: Windows 11 multi-edition ISO → English → 64-bit Download
#    Right-click the button → Copy link address

# 3. Paste the link when prompted — download starts in background

# 4. Check progress any time
win11 status

# 5. Watch live aria2c output
win11 attach
```

## Custom save location

Override the default `$HOME/iso` directory:

```bash
WIN11_DIR=/mnt/usb/isos win11
```

Or set it permanently in your shell config:

```bash
export WIN11_DIR=/mnt/usb/isos
```

## How it works

1. You paste a direct Microsoft download link (valid 24h from their site)
2. The link is saved to disk — so if you resume later, it reuses it automatically
3. `aria2c` downloads with 16 parallel connections for maximum speed (~5.4 GiB)
4. The download runs inside a `tmux` session named `win11-download`
5. After completion, SHA256 is verified against Microsoft's official hash

## SHA256 Reference

| Version | Language | SHA256 |
|---|---|---|
| 24H2 | English x64 | `B56B911BF18A2CEAEB3904D87E7C770BDF92D3099599D61AC2497B91BF190B11` |

> Note: SHA256 only matches the English x64 ISO. Other languages have different hashes — the script will warn you but won't block you.

## Update

Pull the latest version with the same one-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/franc417/win11/main/install.sh | bash
```

## License

MIT
