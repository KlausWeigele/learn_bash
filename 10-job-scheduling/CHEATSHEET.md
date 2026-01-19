# Job Scheduling Cheatsheet

## cron

### crontab-Befehle

```bash
crontab -l          # Eigene crontab anzeigen
crontab -e          # Eigene crontab bearbeiten
crontab -r          # Eigene crontab löschen (Vorsicht!)
crontab datei.txt   # crontab aus Datei laden
```

### cron-Syntax

```
┌───────────── Minute (0-59)
│ ┌───────────── Stunde (0-23)
│ │ ┌───────────── Tag des Monats (1-31)
│ │ │ ┌───────────── Monat (1-12)
│ │ │ │ ┌───────────── Wochentag (0-7, 0 und 7 = Sonntag)
│ │ │ │ │
* * * * * befehl
```

### Spezielle Zeichen

| Zeichen | Bedeutung | Beispiel |
|---------|-----------|----------|
| `*` | Jeder Wert | `* * * * *` = jede Minute |
| `,` | Liste | `1,15 * * * *` = Minute 1 und 15 |
| `-` | Bereich | `0 9-17 * * *` = 9:00 bis 17:00 |
| `/` | Schritt | `*/15 * * * *` = alle 15 Minuten |

### Häufige Beispiele

```bash
# Jede Minute
* * * * * /pfad/script.sh

# Jede Stunde (zur vollen Stunde)
0 * * * * /pfad/script.sh

# Jeden Tag um 2:30 Uhr
30 2 * * * /pfad/script.sh

# Jeden Montag um 9:00
0 9 * * 1 /pfad/script.sh

# Jeden 1. des Monats um Mitternacht
0 0 1 * * /pfad/script.sh

# Alle 15 Minuten
*/15 * * * * /pfad/script.sh

# Mo-Fr um 8:30
30 8 * * 1-5 /pfad/script.sh

# Werktags alle 2 Stunden, 9-17 Uhr
0 9-17/2 * * 1-5 /pfad/script.sh

# Zweimal täglich (8:00 und 20:00)
0 8,20 * * * /pfad/script.sh
```

### Spezielle Strings (manche cron-Versionen)

```bash
@reboot     # Bei Systemstart
@yearly     # 0 0 1 1 *
@monthly    # 0 0 1 * *
@weekly     # 0 0 * * 0
@daily      # 0 0 * * *
@hourly     # 0 * * * *
```

### cron Best Practices

```bash
# Absolute Pfade verwenden
0 2 * * * /usr/local/bin/python3 /Users/klaus/scripts/backup.py

# Output loggen
0 2 * * * /pfad/script.sh >> /var/log/myscript.log 2>&1

# Nur Fehler loggen
0 2 * * * /pfad/script.sh > /dev/null 2>> /var/log/errors.log

# Umgebungsvariablen setzen
PATH=/usr/local/bin:/usr/bin:/bin
0 2 * * * script.sh

# Mit Locking (verhindert Überlappung)
0 * * * * flock -n /tmp/script.lock /pfad/script.sh
```

## launchd (macOS)

### Verzeichnisse

| Pfad | Beschreibung |
|------|--------------|
| `~/Library/LaunchAgents/` | User-Agents (nur für dich) |
| `/Library/LaunchAgents/` | Globale User-Agents |
| `/Library/LaunchDaemons/` | System-Daemons (als root) |
| `/System/Library/Launch*` | Apple-eigene (nicht anfassen!) |

### launchctl-Befehle

```bash
# Agent laden
launchctl load ~/Library/LaunchAgents/com.user.myjob.plist

# Agent entladen
launchctl unload ~/Library/LaunchAgents/com.user.myjob.plist

# Alle Agents anzeigen
launchctl list

# Bestimmten Agent anzeigen
launchctl list com.user.myjob

# Agent manuell starten
launchctl start com.user.myjob

# Agent stoppen
launchctl stop com.user.myjob

# Moderne Syntax (macOS 10.10+)
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.myjob.plist
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.user.myjob.plist
```

### Basis-Plist-Struktur

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.myjob</string>

    <key>ProgramArguments</key>
    <array>
        <string>/pfad/zu/script.sh</string>
        <string>argument1</string>
    </array>

    <!-- Wann ausführen (eine der Optionen) -->

</dict>
</plist>
```

### Timing-Optionen

#### StartInterval (alle X Sekunden)

```xml
<key>StartInterval</key>
<integer>3600</integer>  <!-- Jede Stunde -->
```

#### StartCalendarInterval (wie cron)

```xml
<!-- Täglich um 2:30 -->
<key>StartCalendarInterval</key>
<dict>
    <key>Hour</key>
    <integer>2</integer>
    <key>Minute</key>
    <integer>30</integer>
</dict>

<!-- Mehrere Zeiten -->
<key>StartCalendarInterval</key>
<array>
    <dict>
        <key>Hour</key>
        <integer>8</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <dict>
        <key>Hour</key>
        <integer>20</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
</array>

<!-- Jeden Montag um 9:00 -->
<key>StartCalendarInterval</key>
<dict>
    <key>Weekday</key>
    <integer>1</integer>  <!-- 0=So, 1=Mo, ... -->
    <key>Hour</key>
    <integer>9</integer>
    <key>Minute</key>
    <integer>0</integer>
</dict>
```

#### WatchPaths (bei Dateiänderung)

```xml
<key>WatchPaths</key>
<array>
    <string>/pfad/zu/datei.txt</string>
    <string>/pfad/zu/ordner</string>
</array>
```

#### StartOnMount (bei Volume-Mount)

```xml
<key>StartOnMount</key>
<true/>
```

### Nützliche Optionen

```xml
<!-- Beim Laden sofort starten -->
<key>RunAtLoad</key>
<true/>

<!-- Neustart bei Fehlschlag -->
<key>KeepAlive</key>
<true/>

<!-- Output umleiten -->
<key>StandardOutPath</key>
<string>/tmp/myjob.log</string>
<key>StandardErrorPath</key>
<string>/tmp/myjob.error.log</string>

<!-- Arbeitsverzeichnis -->
<key>WorkingDirectory</key>
<string>/Users/klaus/projects</string>

<!-- Umgebungsvariablen -->
<key>EnvironmentVariables</key>
<dict>
    <key>PATH</key>
    <string>/usr/local/bin:/usr/bin:/bin</string>
    <key>HOME</key>
    <string>/Users/klaus</string>
</dict>

<!-- Nur wenn Netzwerk verfügbar -->
<key>NetworkState</key>
<true/>

<!-- Ressourcen-Limits -->
<key>LowPriorityIO</key>
<true/>
<key>ProcessType</key>
<string>Background</string>
```

### Vollständiges Beispiel

```xml
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
        <integer>3</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>

    <key>StandardOutPath</key>
    <string>/Users/klaus/logs/backup.log</string>

    <key>StandardErrorPath</key>
    <string>/Users/klaus/logs/backup.error.log</string>

    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
    </dict>
</dict>
</plist>
```

### Plist validieren

```bash
# Syntax prüfen
plutil -lint ~/Library/LaunchAgents/com.user.myjob.plist

# In XML konvertieren (falls Binary)
plutil -convert xml1 datei.plist
```

## Troubleshooting

```bash
# launchd Logs
log show --predicate 'subsystem == "com.apple.xpc.launchd"' --last 1h

# Job-Status prüfen
launchctl list | grep myjob

# Fehler im Agent
launchctl error <error-code>

# cron Logs (macOS)
log show --predicate 'process == "cron"' --last 1h
```
