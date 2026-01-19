# Prozess-Management Cheatsheet

## ps - Prozesse anzeigen

```bash
# Einfache Aufrufe
ps                    # Eigene Prozesse (aktuelles Terminal)
ps aux                # ALLE Prozesse, ausführlich
ps -ef                # ALLE Prozesse (POSIX-Format)

# Wichtige Optionen
ps -u username        # Prozesse eines Benutzers
ps -p 1234            # Bestimmte PID
ps -C command         # Nach Befehlsname
ps --forest           # Baum-Ansicht (Linux)
ps -axo pid,ppid,comm # Benutzerdefinierte Spalten

# Nützliche Kombinationen
ps aux | grep chrome           # Prozesse filtern
ps aux --sort=-%mem | head     # Top RAM-Verbraucher
ps aux --sort=-%cpu | head     # Top CPU-Verbraucher
ps -eo pid,ppid,cmd --forest   # Hierarchie anzeigen
```

### ps aux Spalten erklärt
```
USER   PID  %CPU %MEM    VSZ   RSS TTY  STAT START   TIME COMMAND
│      │    │    │       │     │   │    │    │       │    │
│      │    │    │       │     │   │    │    │       │    └─ Befehl
│      │    │    │       │     │   │    │    │       └─ CPU-Zeit
│      │    │    │       │     │   │    │    └─ Startzeit
│      │    │    │       │     │   │    └─ Status (R/S/D/Z/T)
│      │    │    │       │     │   └─ Terminal
│      │    │    │       │     └─ Resident Set Size (RAM in KB)
│      │    │    │       └─ Virtual Memory Size
│      │    │    └─ Speicher %
│      │    └─ CPU %
│      └─ Prozess-ID
└─ Benutzer
```

### Prozess-Status (STAT)
```
R    Running (läuft)
S    Sleeping (wartet auf Event)
D    Disk sleep (wartet auf I/O, nicht unterbrechbar)
Z    Zombie (beendet, wartet auf Eltern)
T    Stopped (pausiert)
I    Idle (Kernel-Thread, idle)

Zusatzzeichen:
<    High priority
N    Low priority
s    Session leader
+    Foreground process
l    Multi-threaded
```

## top / htop - Live-Monitoring

```bash
# Starten
top                   # Standard
htop                  # Bessere Version (falls installiert)

# top Tastenbefehle
q         Beenden
h         Hilfe
P         Nach CPU sortieren
M         Nach RAM sortieren
k         Prozess killen (PID eingeben)
r         Renice (Priorität ändern)
u         Nach User filtern
c         Befehlszeile anzeigen/verstecken
1         Einzelne CPUs anzeigen
```

### top Header verstehen
```
Processes: 385 total, 2 running, 383 sleeping
Load Avg: 1.52, 1.88, 2.01    ← 1, 5, 15 Minuten Durchschnitt
CPU usage: 12.5% user, 8.3% sys, 79.2% idle
PhysMem: 8192M used, 8192M free
```

**Load Average:**
- < Anzahl CPUs: System entspannt
- = Anzahl CPUs: System ausgelastet
- > Anzahl CPUs: System überlastet

## kill - Prozesse beenden

```bash
# Standard (SIGTERM = 15)
kill 1234             # Höflich beenden
kill -15 1234         # Explizit SIGTERM

# Zwangs-Beenden (SIGKILL = 9)
kill -9 1234          # SOFORT beenden (Notfall!)
kill -KILL 1234       # Alternativ

# Andere Signale
kill -STOP 1234       # Pausieren
kill -CONT 1234       # Fortsetzen
kill -HUP 1234        # Hang-up (oft: Config neu laden)

# Mehrere Prozesse
kill 1234 5678 9012   # Mehrere PIDs
killall prozessname   # Nach Name
pkill -f "pattern"    # Nach Muster
```

### Wichtige Signale
```
Signal    Nr    Tastatur    Bedeutung
──────────────────────────────────────────────────────
SIGHUP    1     -           Config neu laden / Verbindung verloren
SIGINT    2     Ctrl+C      Interrupt (höflich beenden)
SIGQUIT   3     Ctrl+\      Quit mit Core Dump
SIGKILL   9     -           Zwangs-Kill (nicht abfangbar!)
SIGTERM   15    -           Terminate (Standard, kann aufräumen)
SIGSTOP   17    -           Stop (nicht abfangbar)
SIGTSTP   18    Ctrl+Z      Terminal Stop (abfangbar)
SIGCONT   19    -           Continue
```

### Kill-Strategie
```bash
# 1. Erst höflich
kill 1234

# 2. Warten
sleep 2

# 3. Prüfen ob noch da
ps -p 1234

# 4. Wenn nötig, Gewalt
kill -9 1234
```

## jobs / bg / fg - Job-Kontrolle

```bash
# Job im Hintergrund starten
command &

# Laufende Jobs anzeigen
jobs                  # Alle Jobs
jobs -l               # Mit PIDs

# Job-Kontrolle
Ctrl+Z                # Aktuellen Job pausieren
bg                    # Pausierten Job im Hintergrund fortsetzen
bg %1                 # Job 1 im Hintergrund
fg                    # Letzten Job in Vordergrund
fg %2                 # Job 2 in Vordergrund

# Job beenden
kill %1               # Job 1 beenden
```

### Job-Bezeichner
```
%1        Job Nummer 1
%+        Aktueller Job
%-        Vorheriger Job
%name     Job der mit "name" beginnt
%?text    Job der "text" enthält
```

## nohup / disown - Prozesse "freigeben"

```bash
# Prozess überlebt Terminal-Schließung
nohup command &
nohup ./script.sh > output.log 2>&1 &

# Laufenden Prozess "freigeben"
command &
disown %1             # Von Shell trennen

# Alternative: screen oder tmux
screen -S session     # Neue Session
screen -r session     # Session wiederherstellen
```

## pgrep / pkill - Nach Name suchen/killen

```bash
# Suchen
pgrep chrome          # PIDs von chrome
pgrep -l chrome       # Mit Namen
pgrep -u klaus        # Prozesse von klaus
pgrep -f "python.*server"  # In ganzer Kommandozeile

# Killen
pkill chrome          # Alle chrome beenden
pkill -9 chrome       # Zwangs-Kill
pkill -u klaus        # Alle Prozesse von klaus
pkill -f "node server"  # Nach Muster
```

## lsof - Offene Dateien/Ports

```bash
# Wer nutzt einen Port?
lsof -i :8080         # Port 8080
lsof -i :80,443       # Port 80 und 443

# Wer nutzt eine Datei?
lsof /path/to/file

# Was nutzt ein Prozess?
lsof -p 1234          # Alles was PID 1234 offen hat
lsof -c chrome        # Alles was chrome offen hat

# Netzwerk-Verbindungen
lsof -i               # Alle Netzwerk-Verbindungen
lsof -i tcp           # Nur TCP
lsof -i udp           # Nur UDP
```

## Priorität (nice / renice)

```bash
# Prozess mit niedriger Priorität starten
nice -n 10 command    # Niedrigere Priorität (1-19)
nice -n -10 command   # Höhere Priorität (-20 bis -1, braucht root)

# Priorität ändern
renice 10 -p 1234     # Priorität von PID 1234 auf 10 setzen
renice -5 -u klaus    # Alle Prozesse von klaus

# Nice-Werte
-20       Höchste Priorität
  0       Normal
 19       Niedrigste Priorität
```

## Nützliche Kombinationen

```bash
# Prozess finden und killen
ps aux | grep firefox | awk '{print $2}' | xargs kill

# Oder einfacher:
pkill firefox

# Alle hängenden Prozesse eines Users killen
pkill -9 -u problematic_user

# Memory-Hogs finden
ps aux --sort=-%mem | head -5

# CPU-Fresser finden
ps aux --sort=-%cpu | head -5

# Prozesse nach Startzeit
ps aux --sort=start_time

# Wer blockiert ein Verzeichnis?
lsof +D /path/to/dir

# Zombie-Prozesse finden
ps aux | awk '$8 ~ /Z/'
```

## System-Info

```bash
# Uptime und Load
uptime

# Speicher-Übersicht
free -h               # Linux
vm_stat               # macOS

# CPU-Info
sysctl -n hw.ncpu     # macOS: Anzahl CPUs
nproc                 # Linux: Anzahl CPUs

# Prozess-Limits
ulimit -a             # Alle Limits anzeigen
```
