# Das macOS Dateisystem: Warum ist das so aufgebaut?

## Fragen zum Nachdenken

**Warum gibt es so viele Ordner direkt unter `/`?**
- Öffne den Finder und aktiviere "Alle Dateien anzeigen" (Cmd+Shift+.). Zähle die Ordner unter `/`. Wozu braucht man so viele?

**Die große bin-Verwirrung**
- Es gibt `/bin`, `/sbin`, `/usr/bin`, `/usr/sbin`, `/usr/local/bin`... Warum nicht einfach EINEN Ordner für alle Programme?

**Was bedeutet `/usr`?**
- Die meisten denken "User" - aber das stimmt nicht! Die echten User-Daten liegen in `/Users`. Was ist dann `/usr`?

**Warum `/private`?**
- Tippe `ls -la /var` - es ist ein Symlink zu `/private/var`. Warum dieser Umweg?

**Das Unsichtbare**
- Im Finder siehst du `/Applications`, `/Users`, `/System`. Aber wo sind `/bin`, `/etc`, `/var`? Sind die versteckt? Warum?

---

## Aha-Momente

### Unix-Erbe trifft Apple-Design

macOS ist ein **zertifiziertes Unix** (seit 2007). Das bedeutet:
- Es folgt dem Unix-Standard für Verzeichnisstruktur
- Apple hat aber eigene Ordner hinzugefügt
- Im Finder versteckt Apple die "hässlichen" Unix-Ordner

```
/                          # Root - die Wurzel von allem
├── [Unix-Ordner]          # Das Erbe von BSD/Unix
│   ├── bin/               # Grundlegende Befehle
│   ├── sbin/              # System-Befehle
│   ├── usr/               # Sekundäre Programme
│   ├── var/               # Variable Daten
│   ├── etc/               # Konfigurationen
│   └── tmp/               # Temporäre Dateien
│
└── [Apple-Ordner]         # macOS-spezifisch
    ├── Applications/      # GUI-Programme
    ├── Library/           # Systemweite Daten
    ├── System/            # macOS selbst
    └── Users/             # Home-Verzeichnisse
```

### Die Geschichte von `/usr`

**USR = Unix System Resources** (NICHT "User"!)

In den 1970ern war Speicherplatz teuer. Die erste Festplatte war voll, also:
- `/bin` - auf der Boot-Platte (essentiell)
- `/usr/bin` - auf der zweiten Platte (Rest)

Heute ist das historisch, aber die Struktur blieb:
```
/bin          → Boot-essentiell (wird VOR /usr gemountet)
/usr/bin      → Kann später gemountet werden
/usr/local/bin → Lokal installiert (Homebrew!)
```

### Warum so viele bin-Ordner?

```
Stell dir vor, dein Mac startet:

1. Kernel lädt         → braucht /bin und /sbin
2. System initialisiert → braucht /usr/bin und /usr/sbin
3. Du installierst Apps → landen in /usr/local/bin
4. Du schreibst Skripte → legst sie in ~/bin

Jede Ebene hat ihren Zweck!
```

| Ordner | Wer installiert dort? | Beispiele |
|--------|----------------------|-----------|
| `/bin` | Apple (System) | bash, ls, cp, mv |
| `/sbin` | Apple (System) | mount, fsck, launchd |
| `/usr/bin` | Apple (System) | git, python3, perl |
| `/usr/sbin` | Apple (System) | diskutil, systemsetup |
| `/usr/local/bin` | Du (Homebrew) | node, brew, ffmpeg |
| `~/bin` | Du (persönlich) | deine Skripte |

### System Integrity Protection (SIP)

Seit macOS 10.11 El Capitan schützt Apple kritische Ordner:

```bash
# Diese Ordner sind geschützt - selbst root kann nichts ändern:
/System
/bin
/sbin
/usr (außer /usr/local)

# Das kannst du prüfen mit:
csrutil status
```

**Warum?** Malware kann sich nicht mehr ins System einnisten, selbst wenn sie root-Rechte erlangt.

### Firmlinks: Die APFS-Magie

Seit macOS Catalina (10.15) gibt es **zwei Volumes**:
- **System Volume** - Read-only, signiert, geschützt
- **Data Volume** - Deine Daten, beschreibbar

```bash
# Schau selbst:
df -h

# Du siehst wahrscheinlich:
# /dev/disk1s1   System
# /dev/disk1s2   Data
```

**Firmlinks** verbinden beide nahtlos:
```
/System/Volumes/Data/Users  ←→  /Users
/System/Volumes/Data/Applications  ←→  /Applications
```

Du merkst davon nichts - aber es macht das System viel sicherer!

---

## Gedankenexperimente

### Experiment 1: Was liegt wo?

```bash
# Wo ist der "echte" ls?
which ls
file $(which ls)

# Wo ist brew (falls installiert)?
which brew

# Wo liegt deine Shell?
echo $SHELL
file $SHELL
```

### Experiment 2: Die Symlink-Wahrheit

```bash
# Ist /var wirklich ein Ordner?
ls -la / | grep var

# Folge dem Link:
readlink /var
readlink /tmp
readlink /etc
```
Alle zeigen nach `/private/...` - warum wohl?

### Experiment 3: Was schützt SIP?

```bash
# Versuche, eine Datei in /bin zu erstellen (wird fehlschlagen!):
sudo touch /bin/test.txt

# Aber in /usr/local geht es:
touch /usr/local/test.txt
rm /usr/local/test.txt
```

### Experiment 4: Die zwei Volumes

```bash
# Zeige alle APFS Volumes:
diskutil list

# Wo bin ich wirklich?
pwd
ls -la /System/Volumes/Data$(pwd)
```

---

## Selbst ausprobieren

**Challenge 1:** Finde heraus, welche Ordner unter `/` Symlinks sind
```bash
ls -la / | grep "^l"
```

**Challenge 2:** Zähle die Programme in jedem bin-Ordner
```bash
echo "/bin: $(ls /bin | wc -l)"
echo "/sbin: $(ls /sbin | wc -l)"
echo "/usr/bin: $(ls /usr/bin | wc -l)"
echo "/usr/local/bin: $(ls /usr/local/bin 2>/dev/null | wc -l)"
```

**Challenge 3:** Finde alle `.DS_Store`-Dateien in deinem Home
```bash
find ~ -name ".DS_Store" 2>/dev/null | wc -l
```
(Spoiler: Es sind wahrscheinlich hunderte!)

**Challenge 4:** Prüfe den Boot-Prozess
```bash
# Wer hat deinen Mac gestartet?
ps -p 1 -o comm=

# Was war der erste Prozess?
# (Hinweis: Es ist launchd, PID 1)
```

---

## Weiter geht's

- [CHEATSHEET.md](CHEATSHEET.md) - Alle Verzeichnisse auf einen Blick
- [scripts/](scripts/) - Erkunde das Dateisystem interaktiv
