# win11

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

A single-file Bash tool for downloading the Windows 11 ISO using 16 parallel connections via `aria2c`, running silently in the background via `tmux`, with automatic resume on any interruption and SHA256 verification only when the download is fully complete.

---

## Features

- **16-connection parallel download** via aria2c — maximum speed on any connection
- **Background tmux session** — survives terminal close, SSH disconnect, screen lock
- **Smart auto-resume** — session file saved every 5 seconds, reused automatically on restart
- **Safe interruption handling** — network drops, manual stops, reboots all resume cleanly
- **SHA256 verification only on completion** — never triggers mid-download on disconnect
- **Rich status display** — speed, average speed, ETA, elapsed time, connections, downloaded/total, remaining
- **Auto-update** — checks GitHub on every run and hot-patches itself without interrupting active downloads
- **`win11 kill`** — kills all sessions and aria2c processes instantly
- **Configurable save location** via `WIN11_DIR` environment variable

---

## Requirements

```bash
# Ubuntu / Debian
apt install aria2 tmux curl coreutils

# Arch Linux
pacman -S aria2 tmux curl coreutils

# Termux (Android)
pkg install aria2 tmux curl coreutils
```

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/franc417/win11/main/win11 \
  -o /usr/local/bin/win11 && chmod +x /usr/local/bin/win11
```

---

## Get Your Download Link

The Microsoft direct download link expires after **24 hours** — get a fresh one each time:

1. Open [microsoft.com/en-us/software-download/windows11](https://www.microsoft.com/en-us/software-download/windows11)
2. Select **Windows 11 (multi-edition ISO for x64)** → Confirm
3. Choose language **English (United States)** → Confirm
4. Right-click **64-bit Download** → Copy link address
5. Paste into `win11` when prompted

> Make sure you select **English (United States)** — other language editions have a different SHA256 hash and will fail verification.

---

## Usage

### Start a download

```bash
win11
```

Prompts for your Microsoft link, then starts downloading in a background tmux session immediately.

### Resume after interruption

```bash
win11
```

If a previous download was interrupted, `win11` detects the saved URL and session file automatically. Press Enter to resume or type `new` to start fresh with a new link.

### Check progress

```bash
win11 status
```

Shows a rich dashboard:

```
┌─ Download Status ───────────────────────────────────────────┐
│
│  Status     :  ● Downloading
│  Progress   :   47%  —  2.54 GiB  /  5.40 GiB
│  Remaining  :  2.86 GiB
│
│  ██████████████████████████░░░░░░░░░░░░░░░░░░░░░░
│
│  Speed      :  8.3 MB/s  (avg: 6.1 MB/s)
│  ETA        :  6m 32s
│  Elapsed    :  7m 14s
│  Connections:  16 / 16
│
│  Live view  :  win11 attach
│
└─────────────────────────────────────────────────────────────┘
```

### Watch live output

```bash
win11 attach
```

Attaches to the tmux session showing real-time aria2c output.
Detach without stopping: `Ctrl+B` then `D`

### Pause gracefully

```bash
win11 stop
```

Saves the session file and kills the tmux session. Run `win11` to resume automatically.

### Force kill everything

```bash
win11 kill
```

Kills all win11 tmux sessions and any running aria2c processes immediately. Run `win11` to resume.

### Verify an existing ISO

```bash
win11 verify
```

Runs SHA256 on the existing ISO file and compares against the official Microsoft hash.
If the file is incomplete it warns you to resume first rather than reporting a false mismatch.

### Wipe and start fresh

```bash
win11 clean
```

Prompts for confirmation then deletes the partial ISO, aria2 session file, log, saved URL, and status file.

### Force update from GitHub

```bash
win11 update
```

Fetches the latest version from GitHub and replaces the current script.
Auto-update also runs silently on every `win11` invocation when no download is active.

### Help

```bash
win11 help
```

---

## Save Location

Default save path: `~/iso/Win11_24H2_English_x64.iso`

Override with environment variable:

```bash
WIN11_DIR=/mnt/phone/Download win11
WIN11_DIR=/home/user/downloads win11
```

---

## Resume Behaviour

| Situation | What happens |
|---|---|
| Network drops mid-download | aria2c retries automatically, session file preserved |
| Terminal closed | Download continues in tmux background |
| Manual `win11 stop` | Session saved, run `win11` to resume |
| Manual `win11 kill` | Session saved, run `win11` to resume |
| System reboot | Run `win11` — saved URL + session auto-detected |
| New Microsoft link needed | Type `new` at the resume prompt |

SHA256 is **only checked when the file size is within 1MB of the expected 5.40 GiB** — never on a partial download.

---

## SHA256 Hash

Official Microsoft hash for **Windows 11 24H2 English x64**:

```
B56B911BF18A2CEAEB3904D87E7C770BDF92D3099599D61AC2497B91BF190B11
```

---

## All Commands

| Command | Description |
|---|---|
| `win11` | Start or resume download |
| `win11 status` | Rich progress dashboard |
| `win11 attach` | Live aria2c output |
| `win11 stop` | Pause gracefully |
| `win11 kill` | Kill all sessions immediately |
| `win11 verify` | Check SHA256 of existing ISO |
| `win11 clean` | Wipe all files and reset |
| `win11 update` | Force update from GitHub |
| `win11 help` | Show help |

---

## Notes

- Runs on any Linux system with Bash — including Ubuntu proot on Android via Termux
- Does not require root
- The Microsoft download link expires in 24 hours — if a resume fails after that, run `win11` and type `new` to paste a fresh link
- If SHA256 fails on a completed download, the ISO edition or language may not match English (United States) 24H2 — use `win11 clean` and download again with the correct link
