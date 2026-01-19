# Job Scheduling: Der Mac arbeitet, während du schläfst

## Fragen zum Nachdenken

Bevor du Tasks automatisierst, nimm dir einen Moment:

**Automatisierung im Alltag**
- Jeden Montag um 9 Uhr ein Backup machen. Willst du das wirklich jedes Mal von Hand starten?
- Logs älter als 7 Tage löschen - täglich prüfen oder... automatisch?

**cron vs. launchd**
- Linux nutzt `cron` seit Jahrzehnten. macOS hat zusätzlich `launchd`. Warum?
- Was passiert, wenn ein geplanter Task laufen soll, aber der Mac schläft?

**Die Macht der Zeitsteuerung**
- "Jeden Werktag um 8:30" - wie drückt man das aus?
- Was ist gefährlicher: Ein Job der zu oft läuft oder einer der nie läuft?

---

## Aha-Momente

### cron ist ein Klassiker

```bash
# crontab bearbeiten
crontab -e

# Format: Minute Stunde Tag Monat Wochentag Befehl
#         *      *     *   *     *         befehl
#         │      │     │   │     │
#         │      │     │   │     └── Wochentag (0-7, So=0 oder 7)
#         │      │     │   └──────── Monat (1-12)
#         │      │     └──────────── Tag (1-31)
#         │      └────────────────── Stunde (0-23)
#         └───────────────────────── Minute (0-59)

# Beispiel: Jeden Tag um 2:30 Uhr
30 2 * * * /pfad/zu/backup.sh
```

### launchd ist Apple's Weg

```xml
<!-- ~/Library/LaunchAgents/com.user.backup.plist -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.backup</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/klaus/scripts/backup.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>2</integer>
        <key>Minute</key>
        <integer>30</integer>
    </dict>
</dict>
</plist>
```

Mehr XML, aber auch mehr Kontrolle!

### Der Unterschied ist wichtig

| Feature | cron | launchd |
|---------|------|---------|
| Syntax | Einfach | Verbose (XML) |
| Sleep-Verhalten | Verpasst Jobs | Holt Jobs nach |
| Ressourcen-Limits | Nein | Ja |
| macOS-native | Ja | **Ja (bevorzugt)** |

---

## Gedankenexperimente

### Experiment 1: cron verstehen

```bash
# Was bedeuten diese Zeilen?
0 * * * *     # ?
0 0 * * *     # ?
0 0 * * 0     # ?
*/15 * * * *  # ?
0 9-17 * * 1-5 # ?
```

Antworten:
- Jede volle Stunde
- Jeden Tag um Mitternacht
- Jeden Sonntag um Mitternacht
- Alle 15 Minuten
- Jede Stunde von 9-17 Uhr, Mo-Fr

### Experiment 2: crontab ausprobieren

```bash
# Eigene crontab anzeigen
crontab -l

# Test-Job hinzufügen (jede Minute)
crontab -e
# Füge hinzu:
# * * * * * echo "$(date)" >> /tmp/crontest.log

# Warte 2 Minuten, dann prüfe
cat /tmp/crontest.log

# Job wieder entfernen!
crontab -e
```

### Experiment 3: launchctl verstehen

```bash
# Alle laufenden Agents anzeigen
launchctl list

# Nur User-Agents
launchctl list | grep -v "com.apple"

# Einen Agent manuell starten
launchctl start com.user.mein-job
```

---

## Selbst ausprobieren

**Challenge 1:** Einfacher cron-Job
```bash
# Bearbeite crontab
crontab -e

# Füge hinzu: Täglich um 8:00 eine Erinnerung
0 8 * * * osascript -e 'display notification "Guten Morgen!" with title "Tägliche Erinnerung"'
```

**Challenge 2:** Erster launchd Agent
```bash
# Skript erstellen
mkdir -p ~/scripts
cat > ~/scripts/hello-launchd.sh << 'EOF'
#!/bin/zsh
echo "$(date): Hello from launchd" >> ~/launchd-test.log
EOF
chmod +x ~/scripts/hello-launchd.sh

# Plist erstellen
cat > ~/Library/LaunchAgents/com.user.hello.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.hello</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/DEIN_USERNAME/scripts/hello-launchd.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>300</integer>
</dict>
</plist>
EOF

# Agent laden
launchctl load ~/Library/LaunchAgents/com.user.hello.plist

# Nach 5 Minuten prüfen
cat ~/launchd-test.log

# Agent wieder entfernen
launchctl unload ~/Library/LaunchAgents/com.user.hello.plist
rm ~/Library/LaunchAgents/com.user.hello.plist
```

**Challenge 3:** Backup-Automatisierung
```bash
# Backup-Skript
cat > ~/scripts/backup-documents.sh << 'EOF'
#!/bin/zsh
set -euo pipefail

QUELLE="$HOME/Documents"
ZIEL="$HOME/Backups/Documents-$(date +%Y%m%d)"

mkdir -p "$ZIEL"
rsync -av --delete "$QUELLE/" "$ZIEL/"
echo "$(date): Backup fertig" >> ~/backup.log
EOF
chmod +x ~/scripts/backup-documents.sh

# Als wöchentlichen cron-Job (Sonntag 3:00)
crontab -e
# 0 3 * * 0 ~/scripts/backup-documents.sh
```

**Challenge 4:** Cleanup-Job
```bash
# Alte Dateien in Downloads löschen (älter als 30 Tage)
cat > ~/scripts/cleanup-downloads.sh << 'EOF'
#!/bin/zsh
find ~/Downloads -type f -mtime +30 -delete
find ~/Downloads -type d -empty -delete
echo "$(date): Downloads aufgeräumt" >> ~/cleanup.log
EOF
chmod +x ~/scripts/cleanup-downloads.sh
```

---

## Weiter geht's

Wenn du die Grundlagen verstanden hast:
- [CHEATSHEET.md](CHEATSHEET.md) - cron und launchd Referenz
- [scripts/](scripts/) - Fertige Job-Skripte
