# System-Monitoring & Logs: Der Mac erzählt dir alles

## Fragen zum Nachdenken

Bevor du in die Logs tauchst, nimm dir einen Moment:

**Das unsichtbare Geschehen**
- Dein Mac macht ständig etwas, auch wenn du nichts tust. Was?
- Woher weiß man, warum eine App abgestürzt ist?

**Die Sprache der Logs**
- Warnung, Fehler, Info - was ist der Unterschied?
- Wie findest du in 100.000 Log-Zeilen die eine wichtige?

**Ressourcen verstehen**
- "Mein Mac ist langsam" - wie findest du den Übeltäter?
- Wann ist 80% CPU-Auslastung ein Problem und wann nicht?

---

## Aha-Momente

### Der Mac loggt ALLES

```bash
# macOS Unified Logging
log show --last 5m

# Sehr viele Einträge! Besser filtern:
log show --last 5m --predicate 'eventMessage contains "error"'
```

### Logs in Echtzeit verfolgen

```bash
# Klassisch: tail -f
tail -f /var/log/system.log

# Modern (macOS): log stream
log stream --level error

# Nur bestimmter Prozess
log stream --process Safari
```

### System-Ressourcen auf einen Blick

```bash
# CPU, Memory, Prozesse
top

# Interaktiver und schöner
htop  # brew install htop

# Einmalige Snapshot
ps aux | head -20
```

---

## Gedankenexperimente

### Experiment 1: Was passiert gerade?

```bash
# Letzte 30 Sekunden System-Logs
log show --last 30s

# Nur Fehler
log show --last 1m --predicate 'messageType == error'

# Was macht Safari?
log show --last 1m --predicate 'process == "Safari"'
```

Wie viele Einträge siehst du? Was für Meldungen sind dabei?

### Experiment 2: top verstehen

```bash
top
```

Drücke verschiedene Tasten:
- `o` dann `cpu` - nach CPU sortieren
- `o` dann `mem` - nach Memory sortieren
- `q` - beenden

Was verbraucht am meisten CPU? Überrascht dich etwas?

### Experiment 3: Festplattenplatz

```bash
# Übersicht
df -h

# Große Dateien finden
du -sh ~/Downloads/*
du -sh ~/Library/Caches/*

# Top 10 größte Ordner im Home
du -sh ~/* 2>/dev/null | sort -hr | head -10
```

Wo versteckt sich der meiste Speicherplatz?

### Experiment 4: Wer nutzt das Netzwerk?

```bash
# Aktive Verbindungen
netstat -an | grep ESTABLISHED

# Welche Prozesse nutzen Netzwerk
lsof -i

# Nur Port 443 (HTTPS)
lsof -i :443
```

---

## Selbst ausprobieren

**Challenge 1:** CPU-Fresser finden
```bash
# Sortiert nach CPU
ps aux --sort=-%cpu | head -10

# Oder mit top (einmalig, nicht interaktiv)
top -l 1 -n 10 -o cpu
```

**Challenge 2:** Memory-Überblick
```bash
# Wie viel RAM ist frei?
vm_stat

# Menschenlesbar (ungefähr)
vm_stat | awk '/Pages free/ {print "Free: " $3 * 4096 / 1048576 " MB"}'

# Prozesse nach Memory
ps aux --sort=-%mem | head -10
```

**Challenge 3:** Log-Überwachung live
```bash
# Fehler in Echtzeit
log stream --level error

# Nur bestimmte App
log stream --predicate 'process == "Mail"'

# Mit Zeitstempel
log stream --style compact
```

**Challenge 4:** Crash-Logs finden
```bash
# Crash-Reports
ls -la ~/Library/Logs/DiagnosticReports/

# Letzten Crash anzeigen
cat ~/Library/Logs/DiagnosticReports/*.crash | head -50
```

**Challenge 5:** System-Health-Check Skript
```bash
#!/bin/zsh
echo "=== System Health Check ==="
echo ""
echo "--- Uptime ---"
uptime
echo ""
echo "--- Disk Usage ---"
df -h /
echo ""
echo "--- Memory ---"
vm_stat | head -5
echo ""
echo "--- Top 5 CPU Processes ---"
ps aux --sort=-%cpu | head -6
echo ""
echo "--- Recent Errors ---"
log show --last 5m --predicate 'messageType == error' 2>/dev/null | tail -10
```

---

## Weiter geht's

Wenn du die Grundlagen verstanden hast:
- [CHEATSHEET.md](CHEATSHEET.md) - Alle Monitoring-Befehle
- [scripts/](scripts/) - Monitoring-Skripte
