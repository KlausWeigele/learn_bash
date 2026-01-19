# macOS Dateisystem Cheatsheet

## Root-Verzeichnis Übersicht

```
/
├── Applications/      # macOS GUI-Programme (.app Bundles)
├── Library/           # Systemweite Bibliotheken & Einstellungen
├── System/            # macOS Systemdateien (SIP-geschützt)
├── Users/             # Home-Verzeichnisse aller Benutzer
├── Volumes/           # Gemountete Laufwerke & Disk Images
├── cores/             # Core Dumps (Crash-Speicherabbilder)
├── opt/               # Optionale Software (selten genutzt)
├── private/           # Echte Orte für var, tmp, etc
│
├── bin/    → Symlink oder echte essenzielle Befehle
├── sbin/   → Symlink oder System-Admin Befehle
├── usr/    → Symlink oder sekundäre Hierarchie
├── var/    → Symlink nach /private/var
├── tmp/    → Symlink nach /private/tmp
└── etc/    → Symlink nach /private/etc
```

## Unix-Standard-Verzeichnisse

### `/bin` - Essential User Binaries
```bash
# Boot-essenzielle Befehle (verfügbar vor /usr mount)
ls, cp, mv, rm, mkdir    # Datei-Operationen
cat, echo, pwd           # Basis-Utilities
bash, zsh, sh            # Shells
chmod, chown             # Berechtigungen
date, hostname           # System-Info
```

### `/sbin` - System Binaries
```bash
# Boot-essenzielle System-Admin Befehle
mount, umount            # Dateisystem mounten
fsck                     # Dateisystem prüfen
launchd                  # Init-System (PID 1)
reboot, shutdown         # System-Kontrolle
ifconfig                 # Netzwerk (veraltet)
```

### `/usr` - Unix System Resources
```
/usr/
├── bin/        # Allgemeine Befehle (git, python3, perl)
├── sbin/       # System-Admin Befehle (diskutil)
├── lib/        # Bibliotheken
├── libexec/    # Hilfsprogramme
├── share/      # Architektur-unabhängige Daten
└── local/      # LOKAL INSTALLIERT (Homebrew!)
    ├── bin/    # brew, node, ffmpeg...
    ├── lib/    # Bibliotheken
    └── share/  # Daten
```

### `/var` - Variable Data
```
/var/ (→ /private/var)
├── log/        # System-Logs
├── tmp/        # Temporäre Dateien (persistent)
├── run/        # Runtime-Daten (PIDs, Sockets)
├── db/         # Datenbanken
├── folders/    # Benutzer-Caches
└── root/       # Root-Home (selten genutzt)
```

### `/etc` - Configuration Files
```
/etc/ (→ /private/etc)
├── hosts       # Hostname-Zuordnungen
├── passwd      # Benutzer-Datenbank (veraltet)
├── shells      # Erlaubte Shells
├── paths       # System PATH-Erweiterungen
└── zshrc       # System-weite Zsh-Config
```

### `/tmp` - Temporary Files
```bash
/tmp/ (→ /private/tmp)
# Wird bei Neustart NICHT gelöscht (anders als Linux!)
# Für temporäre Dateien während einer Session
```

## macOS-spezifische Verzeichnisse

### `/Applications`
```
/Applications/
├── Safari.app/           # System-Apps
├── Xcode.app/            # Entwickler-Tools
└── [Deine Apps].app/     # Installierte Programme

# .app ist ein Bundle (Ordner mit spezieller Struktur):
Safari.app/
├── Contents/
│   ├── Info.plist        # App-Metadaten
│   ├── MacOS/            # Executable
│   └── Resources/        # Assets, Lokalisierung
```

### `/Library`
```
/Library/                 # Systemweit
├── Application Support/  # App-Daten
├── Caches/               # Cache-Dateien
├── LaunchAgents/         # User-Start-Skripte
├── LaunchDaemons/        # System-Start-Skripte
├── Preferences/          # Einstellungen (.plist)
└── Frameworks/           # Shared Libraries

~/Library/                # Pro Benutzer
├── Application Support/  # Deine App-Daten
├── Caches/               # Deine Caches
├── Preferences/          # Deine Einstellungen
└── Logs/                 # App-Logs
```

### `/System`
```
/System/                  # SIP-GESCHÜTZT!
├── Library/              # System-Frameworks
│   ├── Frameworks/       # Cocoa, Foundation, etc.
│   ├── CoreServices/     # Finder, Dock, etc.
│   └── Extensions/       # Kernel-Extensions (.kext)
├── Applications/         # System-Apps
└── Volumes/
    ├── Data/             # Dein Data-Volume
    └── Preboot/          # Boot-Konfiguration
```

### `/Users`
```
/Users/
├── Shared/               # Geteilte Dateien
└── [username]/           # Home-Verzeichnis
    ├── Desktop/
    ├── Documents/
    ├── Downloads/
    ├── Library/          # Benutzer-Library
    ├── Movies/
    ├── Music/
    ├── Pictures/
    └── Public/           # Für andere sichtbar
```

### `/Volumes`
```
/Volumes/
├── Macintosh HD/         # Boot-Volume
├── Macintosh HD - Data/  # Data-Volume
└── [Externe Laufwerke]/  # USB, Disk Images, etc.
```

## Die bin-Hierarchie

```
Priorität (PATH-Reihenfolge):
1. ~/bin              # Deine persönlichen Skripte
2. /usr/local/bin     # Homebrew, lokal installiert
3. /usr/bin           # System-Befehle
4. /bin               # Boot-essentiell
5. /usr/sbin          # System-Admin
6. /sbin              # Boot-essentiell Admin

# Deinen PATH anzeigen:
echo $PATH | tr ':' '\n'
```

## Wichtige Befehle

```bash
# Wo liegt ein Befehl?
which ls                  # Erster Fund im PATH
where ls                  # Alle Fundorte (zsh)
type ls                   # Details (builtin, alias, etc.)

# Dateisystem-Info
df -h                     # Freier Speicher
diskutil list             # Alle Volumes/Partitionen
mount                     # Gemountete Dateisysteme

# Symlinks auflösen
readlink /var             # Zeigt Ziel
realpath /var             # Voller aufgelöster Pfad

# SIP-Status
csrutil status            # Ist SIP aktiv?

# APFS Info
diskutil apfs list        # APFS-Container und Volumes
```

## Versteckte Dateien

```bash
# Im Finder anzeigen/verstecken:
Cmd + Shift + .

# Oder via Terminal:
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

# Häufige versteckte Dateien:
.DS_Store          # Finder-Metadaten (View-Einstellungen)
.localized         # Ordnername-Lokalisierung
.Spotlight-V100/   # Spotlight-Index
.fseventsd/        # File System Events
.Trashes/          # Papierkorb auf ext. Laufwerken
._*                # Resource Forks (auf FAT/NTFS)
```

## Symlinks unter `/`

```bash
# Diese Ordner sind Symlinks nach /private/:
/var  → /private/var
/tmp  → /private/tmp
/etc  → /private/etc

# Warum? Historische Kompatibilität + APFS Firmlinks
```

## APFS Firmlinks

```bash
# System und Data Volume sind getrennt, aber erscheinen als eins:

/              → System Volume (read-only)
/Users         → Firmlink → Data Volume
/Applications  → Firmlink → Data Volume

# Prüfen:
ls -la /System/Volumes/Data/
```
