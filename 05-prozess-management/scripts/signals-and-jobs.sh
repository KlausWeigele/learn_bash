#!/bin/zsh
# ==============================================================================
# signals-and-jobs.sh - Signale und Job-Kontrolle verstehen
# ==============================================================================

echo "=== SIGNALE UND JOB-KONTROLLE ==="
echo "Lerne, wie du Prozesse steuerst und im Hintergrund arbeitest."
echo ""

# ==============================================================================
echo "=== WAS SIND SIGNALE? ==="
# ==============================================================================

echo "
Signale sind die Art, wie Unix mit Prozessen kommuniziert.
Sie sind wie Nachrichten: 'Bitte beenden', 'Sofort stoppen', 'Weitermachen'

Wenn du Ctrl+C drückst, sendest du ein Signal (SIGINT) an den Prozess!
"

# ==============================================================================
echo "=== WICHTIGE SIGNALE ==="
# ==============================================================================

echo "
┌─────────┬────────┬──────────┬─────────────────────────────────────────┐
│ Name    │ Nummer │ Taste    │ Bedeutung                               │
├─────────┼────────┼──────────┼─────────────────────────────────────────┤
│ SIGHUP  │   1    │ -        │ Hang up (Terminal geschlossen)          │
│ SIGINT  │   2    │ Ctrl+C   │ Interrupt - höfliche Beendigung         │
│ SIGQUIT │   3    │ Ctrl+\\   │ Quit mit Core Dump                      │
│ SIGKILL │   9    │ -        │ SOFORT beenden (nicht abfangbar!)       │
│ SIGTERM │  15    │ -        │ Terminate - Standard bei kill           │
│ SIGSTOP │  17    │ -        │ Stop (nicht abfangbar!)                 │
│ SIGTSTP │  18    │ Ctrl+Z   │ Terminal Stop (pausieren)               │
│ SIGCONT │  19    │ -        │ Continue (fortsetzen)                   │
└─────────┴────────┴──────────┴─────────────────────────────────────────┘
"

# ==============================================================================
echo "=== SIGNALE SENDEN MIT KILL ==="
# ==============================================================================

echo "Trotz des Namens ist 'kill' für ALLE Signale:"
echo ""

echo "# Standard (SIGTERM = 15) - höflich beenden"
echo "kill 1234"
echo "kill -15 1234"
echo "kill -TERM 1234"
echo ""

echo "# Zwangs-Kill (SIGKILL = 9) - Notfall!"
echo "kill -9 1234"
echo "kill -KILL 1234"
echo ""

echo "# Prozess pausieren"
echo "kill -STOP 1234"
echo ""

echo "# Prozess fortsetzen"
echo "kill -CONT 1234"
echo ""

# ==============================================================================
echo "=== DEMO: SIGNALE IN AKTION ==="
# ==============================================================================

echo "Starte einen Hintergrund-Prozess..."
sleep 300 &
demo_pid=$!
echo "  PID: $demo_pid"
echo ""

echo "Prozess läuft:"
ps -p $demo_pid -o pid,stat,comm
echo ""

echo "Sende SIGSTOP (pausieren)..."
kill -STOP $demo_pid
sleep 1
echo "Status nach STOP:"
ps -p $demo_pid -o pid,stat,comm
echo "  (T = Stopped)"
echo ""

echo "Sende SIGCONT (fortsetzen)..."
kill -CONT $demo_pid
sleep 1
echo "Status nach CONT:"
ps -p $demo_pid -o pid,stat,comm
echo "  (S = Sleeping, läuft wieder)"
echo ""

echo "Sende SIGTERM (beenden)..."
kill -TERM $demo_pid 2>/dev/null
sleep 1
if ps -p $demo_pid > /dev/null 2>&1; then
    echo "  Prozess läuft noch - benutze SIGKILL"
    kill -9 $demo_pid 2>/dev/null
else
    echo "  Prozess beendet"
fi
echo ""

# ==============================================================================
echo "=== KILL VS KILLALL VS PKILL ==="
# ==============================================================================

echo "
┌───────────┬─────────────────────────────────────────────────┐
│ Befehl    │ Verwendung                                      │
├───────────┼─────────────────────────────────────────────────┤
│ kill      │ Beendet per PID                                 │
│           │ kill 1234                                       │
│           │ kill -9 1234 5678                               │
├───────────┼─────────────────────────────────────────────────┤
│ killall   │ Beendet alle mit diesem Namen                   │
│           │ killall firefox                                 │
│           │ killall -9 chrome                               │
├───────────┼─────────────────────────────────────────────────┤
│ pkill     │ Beendet nach Muster (flexibler)                 │
│           │ pkill -f 'python.*server'                       │
│           │ pkill -u klaus                                  │
└───────────┴─────────────────────────────────────────────────┘
"

# ==============================================================================
echo "=== JOB-KONTROLLE ==="
# ==============================================================================

echo "
Jobs sind Prozesse, die von deiner Shell gestartet wurden.
Du kannst sie zwischen Vordergrund und Hintergrund verschieben.
"

echo "--- Hintergrund-Job starten ---"
echo "sleep 100 &"
sleep 100 &
job_pid=$!
echo "  PID: $job_pid"
echo ""

echo "--- Aktuelle Jobs anzeigen ---"
echo "jobs"
jobs
echo ""

echo "jobs -l (mit PIDs)"
jobs -l
echo ""

# ==============================================================================
echo "=== VORDERGRUND / HINTERGRUND ==="
# ==============================================================================

echo "
┌────────────────────────────────────────────────────────────────┐
│ Tastenkombinationen und Befehle:                               │
├────────────────────────────────────────────────────────────────┤
│ command &       Direkt im Hintergrund starten                  │
│ Ctrl+Z          Aktuellen Prozess pausieren (SIGTSTP)          │
│ bg              Pausierten Prozess im Hintergrund fortsetzen   │
│ bg %1           Job 1 im Hintergrund                           │
│ fg              Letzten Job in Vordergrund holen               │
│ fg %2           Job 2 in Vordergrund                           │
│ jobs            Alle Jobs anzeigen                             │
│ kill %1         Job 1 beenden                                  │
└────────────────────────────────────────────────────────────────┘
"

echo "--- Job-Bezeichner ---"
echo "
%1        Job Nummer 1
%+  %%    Aktueller Job (zuletzt gestartet/gestoppt)
%-        Vorheriger Job
%name     Job der mit 'name' beginnt
%?text    Job der 'text' enthält
"

# ==============================================================================
echo "=== PROZESS VOM TERMINAL TRENNEN ==="
# ==============================================================================

echo "
Normalerweise sterben Hintergrund-Jobs wenn du das Terminal schließt.
So überlebt ein Prozess:
"

echo "--- nohup (von Anfang an) ---"
echo "nohup ./long_script.sh > output.log 2>&1 &"
echo ""

echo "--- disown (nachträglich) ---"
echo "# Job starten"
echo "./long_script.sh &"
echo "# Von Shell trennen"
echo "disown %1"
echo ""

echo "--- screen/tmux (professionell) ---"
echo "# Neue Session starten"
echo "screen -S meinesession"
echo "# [Befehle ausführen]"
echo "# Ctrl+A, D  → Session trennen"
echo "# screen -r meinesession  → Wieder verbinden"
echo ""

# Aufräumen
kill $job_pid 2>/dev/null

# ==============================================================================
echo "=== SIGNALE IM SKRIPT ABFANGEN ==="
# ==============================================================================

echo "
Mit 'trap' kannst du auf Signale reagieren:
"

cat << 'TRAPEXAMPLE'
#!/bin/zsh
# Aufräumen bei Beendigung
cleanup() {
    echo "Aufräumen..."
    rm -f /tmp/mein_lockfile
    exit 0
}

# SIGINT und SIGTERM abfangen
trap cleanup SIGINT SIGTERM

echo "Skript läuft (PID $$)"
echo "Drücke Ctrl+C zum Beenden"

while true; do
    sleep 1
done
TRAPEXAMPLE

echo ""

# ==============================================================================
echo "=== PRAKTISCHE SZENARIEN ==="
# ==============================================================================

echo "
┌────────────────────────────────────────────────────────────────┐
│ Szenario                           │ Lösung                    │
├────────────────────────────────────┼───────────────────────────┤
│ Prozess reagiert nicht auf Ctrl+C  │ kill -9 PID               │
│ Prozess im Hintergrund laufen      │ command &                 │
│ Hintergrund-Job anhalten           │ kill -STOP %1             │
│ Terminal schließen, Job läuft      │ nohup oder disown         │
│ Alle Chrome-Tabs killen            │ pkill -f chrome           │
│ Aufräumen bei Script-Ende          │ trap cleanup EXIT         │
│ Wer blockiert Port 8080?           │ lsof -i :8080             │
└────────────────────────────────────┴───────────────────────────┘
"

# ==============================================================================
echo "=== SIGNAL-ÜBERSICHT ==="
# ==============================================================================

echo "Alle verfügbaren Signale anzeigen:"
echo "kill -l"
kill -l 2>/dev/null | head -3
echo "..."
echo ""

echo "
Merke dir die wichtigsten:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
2  SIGINT    Ctrl+C (höflich)
9  SIGKILL   Zwangs-Kill (brutal)
15 SIGTERM   Standard kill
18 SIGTSTP   Ctrl+Z (pausieren)
19 SIGCONT   Fortsetzen
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"

echo "=== ENDE ==="
echo "Tipp: Immer erst SIGTERM versuchen, nur im Notfall SIGKILL!"
