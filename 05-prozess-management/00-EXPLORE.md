# Prozess-Management: Was passiert eigentlich auf deinem Mac?

## Fragen zum Nachdenken

**Was ist ein Prozess überhaupt?**
- Du startest Safari. Was passiert im Hintergrund? Ist Safari EIN Prozess oder mehrere?

**PID - die Identität eines Prozesses**
- Jeder Prozess hat eine eindeutige Nummer (PID). Warum braucht man das? Und was ist PID 1?

**Parent und Child**
- Prozesse haben Eltern und Kinder. Dein Terminal startet `ls` - wer ist Eltern, wer ist Kind?

**Zombies und Waisen**
- Es gibt "Zombie-Prozesse" und "Orphan-Prozesse". Was könnte das bedeuten?

**Signale - die Sprache der Prozesse**
- `Ctrl+C` beendet ein Programm. Aber wie? Und warum funktioniert es manchmal nicht?

---

## Aha-Momente

### Ein Prozess ist ein laufendes Programm

```
Programm (auf Festplatte)     →    Prozess (im RAM)
─────────────────────────          ───────────────────
/usr/bin/ls                        PID: 12345
(statische Datei)                  (läuft gerade)
                                   (hat CPU-Zeit)
                                   (hat Speicher)
```

Ein Programm ist wie ein Rezept. Ein Prozess ist das Kochen.

### Die Prozess-Hierarchie

```
launchd (PID 1)
├── kernel_task
├── WindowServer
├── Finder
├── Dock
├── Terminal
│   └── zsh (deine Shell)
│       └── ls (wenn du ls tippst)
│       └── vim (wenn du vim startest)
└── Safari
    ├── Safari Web Content
    ├── Safari Web Content
    └── Safari Networking
```

**launchd** ist der Ur-Prozess - er startet ALLES andere.

### Prozess-Zustände

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   RUNNING   │────▶│   SLEEPING  │────▶│   STOPPED   │
│ (läuft)     │◀────│ (wartet)    │◀────│ (pausiert)  │
└─────────────┘     └─────────────┘     └─────────────┘
       │                                       │
       │            ┌─────────────┐            │
       └───────────▶│   ZOMBIE    │◀───────────┘
                    │ (beendet,   │
                    │  nicht      │
                    │  aufgeräumt)│
                    └─────────────┘
```

- **Running**: Hat CPU-Zeit
- **Sleeping**: Wartet auf etwas (I/O, Timer, etc.)
- **Stopped**: Pausiert (z.B. durch Ctrl+Z)
- **Zombie**: Beendet, aber Eltern-Prozess hat Status noch nicht abgeholt

### Signale - Prozess-Kommunikation

```
Signal       Nummer   Tastatur    Bedeutung
─────────────────────────────────────────────────────
SIGHUP       1        -           Hang up (Terminal geschlossen)
SIGINT       2        Ctrl+C      Interrupt (höfliche Bitte zu beenden)
SIGQUIT      3        Ctrl+\      Quit (mit Core Dump)
SIGKILL      9        -           Kill (SOFORT beenden, nicht abfangbar!)
SIGTERM      15       -           Terminate (Standard bei kill)
SIGSTOP      17       -           Stop (pausieren, nicht abfangbar)
SIGTSTP      18       Ctrl+Z      Terminal Stop (pausieren)
SIGCONT      19       -           Continue (weitermachen)
```

**Wichtig:**
- `SIGTERM` (15) = "Bitte beenden" - Prozess kann aufräumen
- `SIGKILL` (9) = "SOFORT sterben" - Keine Gnade, keine Aufräumarbeiten

### Vordergrund vs. Hintergrund

```bash
# Vordergrund - blockiert Terminal
./long_script.sh

# Hintergrund - Terminal bleibt frei
./long_script.sh &

# Vordergrund → Hintergrund
Ctrl+Z          # Pausiert
bg              # Weiter im Hintergrund

# Hintergrund → Vordergrund
fg              # Holt Job nach vorne
```

---

## Gedankenexperimente

### Experiment 1: Wer bin ich?

```bash
echo $$           # PID der aktuellen Shell
echo $PPID        # PID des Eltern-Prozesses
ps -p $$          # Details zu meiner Shell
ps -p $PPID       # Details zum Eltern-Prozess
```

### Experiment 2: Prozess-Baum

```bash
# Zeige den Prozess-Baum
pstree            # Falls installiert
# Oder:
ps -axo pid,ppid,comm | head -20
```

### Experiment 3: Was frisst CPU?

```bash
# Top CPU-Verbraucher
ps aux --sort=-%cpu | head -10
# Oder interaktiv:
top
```

### Experiment 4: Signale in Aktion

```bash
# In Terminal 1:
sleep 1000

# In Terminal 2:
ps aux | grep sleep        # Finde die PID
kill -SIGSTOP <pid>        # Pausiere
kill -SIGCONT <pid>        # Weiter
kill -SIGTERM <pid>        # Beende höflich
# Oder wenn das nicht hilft:
kill -9 <pid>              # Zwangsbeenden
```

### Experiment 5: Zombie erzeugen

```bash
# Ein Zombie entsteht, wenn ein Kind-Prozess endet,
# aber der Eltern-Prozess den Exit-Status nicht abholt.

# Dieses Skript erzeugt kurz einen Zombie:
( sleep 1 & exec sleep 10 ) &
sleep 2
ps aux | grep Z            # Z = Zombie
```

---

## Selbst ausprobieren

**Challenge 1:** Finde alle deine Prozesse
```bash
ps -u $(whoami)
```

**Challenge 2:** Wie viel RAM verbraucht Chrome/Safari?
```bash
ps aux | grep -i safari | awk '{sum += $6} END {print sum/1024 " MB"}'
```

**Challenge 3:** Starte einen Hintergrund-Job und hole ihn zurück
```bash
sleep 100 &
jobs
fg %1
Ctrl+C
```

**Challenge 4:** Finde den Eltern-Prozess deines Terminals
```bash
ps -p $PPID -o comm=
```

**Challenge 5:** Welcher Prozess hört auf Port 8080?
```bash
lsof -i :8080
# oder
netstat -an | grep 8080
```

---

## Die Prozess-Lebenszyklus

```
1. fork()     - Eltern-Prozess klont sich selbst
2. exec()     - Kind ersetzt sich mit neuem Programm
3. [läuft]    - Prozess arbeitet
4. exit()     - Prozess beendet sich
5. wait()     - Eltern holt Exit-Status ab → Prozess verschwindet

Wenn Schritt 5 fehlt → Zombie!
Wenn Eltern stirbt bevor Kind → Kind wird von launchd adoptiert
```

---

## Weiter geht's

- [CHEATSHEET.md](CHEATSHEET.md) - Alle Befehle im Überblick
- [scripts/](scripts/) - Praktische Beispiele zum Ausprobieren
