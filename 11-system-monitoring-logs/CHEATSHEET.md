# System-Monitoring & Logs Cheatsheet

## Prozesse überwachen

### ps - Prozess-Snapshot

```bash
# Alle Prozesse (BSD-Stil, macOS)
ps aux

# Alle Prozesse mit voller Kommandozeile
ps auxww

# Nur eigene Prozesse
ps ux

# Nach CPU sortiert
ps aux --sort=-%cpu | head -20

# Nach Memory sortiert
ps aux --sort=-%mem | head -20

# Bestimmten Prozess suchen
ps aux | grep -i firefox
pgrep -l firefox

# Prozessbaum
pstree  # brew install pstree
```

### ps-Spalten erklärt

| Spalte | Bedeutung |
|--------|-----------|
| USER | Prozess-Besitzer |
| PID | Prozess-ID |
| %CPU | CPU-Auslastung |
| %MEM | Speicher-Anteil |
| VSZ | Virtueller Speicher (KB) |
| RSS | Physischer Speicher (KB) |
| STAT | Status (R=running, S=sleeping, Z=zombie) |
| START | Startzeit |
| TIME | CPU-Zeit gesamt |
| COMMAND | Befehl |

### top - Live-Überwachung

```bash
# Interaktiv starten
top

# Einmalige Ausgabe (Skript-geeignet)
top -l 1

# Top 10 nach CPU
top -l 1 -n 10 -o cpu

# Nach Memory
top -l 1 -n 10 -o mem

# Bestimmter User
top -U klaus
```

### top-Tastaturbefehle

| Taste | Aktion |
|-------|--------|
| `q` | Beenden |
| `o` | Sortierung ändern |
| `s` | Update-Intervall |
| `?` | Hilfe |

### htop - Besseres top

```bash
# Installieren
brew install htop

# Starten
htop

# Als root (für alle Prozesse)
sudo htop
```

## Speicher (Memory)

### vm_stat - Detaillierte Memory-Statistik

```bash
vm_stat

# Wichtige Werte:
# Pages free: Freier RAM
# Pages active: Aktiv genutzter RAM
# Pages inactive: Inaktiv (gecached)
# Pages wired: Vom System fixiert
```

### Memory-Übersicht

```bash
# Einfache Übersicht (macOS)
memory_pressure

# Top Memory-Verbraucher
ps aux --sort=-%mem | head -10

# Swap-Nutzung
sysctl vm.swapusage
```

## Festplatte

### df - Filesystem-Übersicht

```bash
# Alle Filesystems
df -h

# Nur lokale
df -hl

# Bestimmtes Filesystem
df -h /
df -h /Volumes/ExternePlatte
```

### du - Verzeichnis-Größen

```bash
# Ordner-Größe
du -sh ~/Downloads

# Alle Unterordner
du -sh ~/Downloads/*

# Sortiert (größte zuerst)
du -sh ~/Downloads/* | sort -hr

# Top 10 größte Ordner
du -sh ~/* 2>/dev/null | sort -hr | head -10

# Mit Tiefenlimit
du -h -d 1 ~/Library
```

### Große Dateien finden

```bash
# Dateien > 100MB
find ~ -size +100M -type f 2>/dev/null

# Mit Größe anzeigen
find ~ -size +100M -type f -exec ls -lh {} \; 2>/dev/null

# Sortiert
find ~ -size +100M -type f -print0 2>/dev/null | xargs -0 ls -lhS
```

## Netzwerk

### netstat - Netzwerk-Statistiken

```bash
# Alle Verbindungen
netstat -an

# Nur TCP
netstat -an -p tcp

# Nur lauschende Ports
netstat -an | grep LISTEN

# Aktive Verbindungen
netstat -an | grep ESTABLISHED

# Statistiken
netstat -s
```

### lsof - Offene Dateien/Verbindungen

```bash
# Netzwerk-Verbindungen
lsof -i

# Nur bestimmter Port
lsof -i :8080
lsof -i :443

# Bestimmter Prozess
lsof -i -P | grep Chrome

# Wer nutzt eine Datei?
lsof /path/to/file
```

### Netzwerk-Tools

```bash
# Verbindung testen
ping -c 5 google.com

# Route verfolgen
traceroute google.com

# DNS-Auflösung
nslookup example.com
dig example.com

# Öffentliche IP
curl -s ifconfig.me
curl -s ipinfo.io/ip

# Lokale IPs
ifconfig | grep "inet "
```

## Logs (macOS Unified Logging)

### log show - Vergangene Logs

```bash
# Letzte 5 Minuten
log show --last 5m

# Letzte Stunde
log show --last 1h

# Zeitraum
log show --start "2024-01-15 10:00:00" --end "2024-01-15 11:00:00"

# Nur Fehler
log show --last 1h --predicate 'messageType == error'

# Bestimmter Prozess
log show --last 1h --predicate 'process == "Safari"'

# Suchbegriff
log show --last 1h --predicate 'eventMessage contains "failed"'

# Kombiniert
log show --last 1h --predicate 'process == "kernel" AND messageType == error'

# Kompaktes Format
log show --last 5m --style compact

# JSON-Format
log show --last 5m --style json
```

### log stream - Live-Logs

```bash
# Alle Logs live
log stream

# Nur Fehler
log stream --level error

# Bestimmter Prozess
log stream --process Safari
log stream --process kernel

# Mit Prädikat
log stream --predicate 'eventMessage contains "error"'

# Kompakt
log stream --style compact
```

### Log-Level

| Level | Bedeutung |
|-------|-----------|
| default | Standard-Meldungen |
| info | Informationen |
| debug | Debug-Details |
| error | Fehler |
| fault | Schwere Fehler |

### Klassische Log-Dateien

```bash
# System-Log (veraltet, aber manchmal noch vorhanden)
/var/log/system.log

# Crash-Reports
~/Library/Logs/DiagnosticReports/

# App-Logs
~/Library/Logs/

# Mit tail live verfolgen
tail -f /var/log/system.log
```

## System-Informationen

```bash
# macOS Version
sw_vers

# Hardware-Übersicht
system_profiler SPHardwareDataType

# Uptime
uptime

# Hostname
hostname

# Kernel-Version
uname -a

# CPU-Info
sysctl -n machdep.cpu.brand_string
sysctl hw.ncpu

# RAM-Größe
sysctl hw.memsize | awk '{print $2/1024/1024/1024 " GB"}'
```

## Nützliche Monitoring-Skripte

### Quick Health Check

```bash
#!/bin/zsh
echo "=== System Status ==="
echo "Uptime: $(uptime | awk -F'up ' '{print $2}' | awk -F',' '{print $1}')"
echo "Load: $(uptime | awk -F'load averages: ' '{print $2}')"
echo ""
echo "=== Disk ==="
df -h / | tail -1 | awk '{print "Used: " $3 " / " $2 " (" $5 ")"}'
echo ""
echo "=== Memory ==="
memory_pressure 2>/dev/null || vm_stat | head -5
echo ""
echo "=== Top CPU ==="
ps aux --sort=-%cpu | head -4 | tail -3
```

### Disk Space Alert

```bash
#!/bin/zsh
THRESHOLD=90
USAGE=$(df -h / | tail -1 | awk '{print $5}' | tr -d '%')

if [[ $USAGE -gt $THRESHOLD ]]; then
    echo "WARNING: Disk usage at ${USAGE}%"
    # Optional: Notification
    osascript -e "display notification \"Disk usage: ${USAGE}%\" with title \"Disk Space Warning\""
fi
```

### Log-Fehler zählen

```bash
#!/bin/zsh
ERRORS=$(log show --last 1h --predicate 'messageType == error' 2>/dev/null | wc -l)
echo "Errors in last hour: $ERRORS"
```

## Keyboard Shortcuts für Activity Monitor

| Shortcut | Aktion |
|----------|--------|
| `Cmd+1` | CPU-Ansicht |
| `Cmd+2` | Memory-Ansicht |
| `Cmd+3` | Energie-Ansicht |
| `Cmd+4` | Disk-Ansicht |
| `Cmd+5` | Netzwerk-Ansicht |
| `Cmd+F` | Prozess suchen |
| `Cmd+Q` | Beenden |
