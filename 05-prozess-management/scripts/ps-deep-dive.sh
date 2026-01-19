#!/bin/zsh
# ==============================================================================
# ps-deep-dive.sh - Prozesse verstehen mit ps
# ==============================================================================

echo "=== PS: PROZESSE ANZEIGEN ==="
echo "ps zeigt eine Momentaufnahme aller laufenden Prozesse."
echo ""

# ==============================================================================
echo "=== GRUNDLEGENDE BEFEHLE ==="
# ==============================================================================

echo "--- ps (ohne Optionen) ---"
echo "Zeigt nur Prozesse des aktuellen Terminals:"
ps
echo ""

echo "--- ps aux (alle Prozesse, ausführlich) ---"
echo "Erste 10 Zeilen:"
ps aux | head -10
echo "..."
echo ""

# ==============================================================================
echo "=== DIE SPALTEN VERSTEHEN ==="
# ==============================================================================

echo "
┌──────────────────────────────────────────────────────────────┐
│ ps aux Spalten erklärt:                                      │
├──────────────────────────────────────────────────────────────┤
│ USER     Benutzer, dem der Prozess gehört                    │
│ PID      Prozess-ID (eindeutige Nummer)                      │
│ %CPU     CPU-Auslastung in Prozent                           │
│ %MEM     RAM-Auslastung in Prozent                           │
│ VSZ      Virtual Memory Size (KB)                            │
│ RSS      Resident Set Size - tatsächlich genutzter RAM (KB)  │
│ TTY      Terminal (? = kein Terminal)                        │
│ STAT     Status (R=Running, S=Sleeping, Z=Zombie, etc.)      │
│ START    Startzeit                                           │
│ TIME     Verbrauchte CPU-Zeit                                │
│ COMMAND  Der Befehl/Programmname                             │
└──────────────────────────────────────────────────────────────┘
"

# ==============================================================================
echo "=== PROZESS-STATUS (STAT) ==="
# ==============================================================================

echo "Aktuell laufende Prozesse (Status R):"
ps aux | awk 'NR==1 || $8 ~ /R/' | head -10
echo ""

echo "Schlafende Prozesse (Status S) - die meisten:"
ps aux | awk '$8 ~ /S/' | wc -l | xargs echo "Anzahl:"
echo ""

echo "Zombie-Prozesse (Status Z):"
zombies=$(ps aux | awk '$8 ~ /Z/' | wc -l)
echo "Anzahl: $zombies"
if [[ $zombies -gt 0 ]]; then
    ps aux | awk 'NR==1 || $8 ~ /Z/'
fi
echo ""

# ==============================================================================
echo "=== DEIN PROZESS-KONTEXT ==="
# ==============================================================================

echo "Deine aktuelle Shell:"
echo "  PID: $$"
echo "  PPID (Eltern): $PPID"
echo ""

echo "Details zu deiner Shell (PID $$):"
ps -p $$ -o pid,ppid,user,stat,comm
echo ""

echo "Details zum Eltern-Prozess (PID $PPID):"
ps -p $PPID -o pid,ppid,user,stat,comm
echo ""

echo "Prozess-Kette bis zur Shell:"
current_pid=$$
echo "PID → PPID → Command"
while [[ $current_pid -gt 1 ]]; do
    info=$(ps -p $current_pid -o pid=,ppid=,comm= 2>/dev/null)
    if [[ -n $info ]]; then
        echo "  $info"
        current_pid=$(echo $info | awk '{print $2}')
    else
        break
    fi
done
echo ""

# ==============================================================================
echo "=== PROZESSE FILTERN ==="
# ==============================================================================

echo "--- Nach Benutzer ---"
echo "Deine Prozesse ($(whoami)):"
ps -u $(whoami) | wc -l | xargs echo "Anzahl:"
echo ""

echo "--- Nach Name ---"
echo "Alle Shell-Prozesse:"
ps aux | grep -E "bash|zsh|sh" | grep -v grep | head -5
echo ""

# ==============================================================================
echo "=== TOP RESSOURCEN-VERBRAUCHER ==="
# ==============================================================================

echo "--- Top 5 CPU-Verbraucher ---"
ps aux | sort -k3 -rn | head -6 | awk '{printf "%-10s %5s%% CPU  %s\n", $1, $3, $11}'
echo ""

echo "--- Top 5 RAM-Verbraucher ---"
ps aux | sort -k4 -rn | head -6 | awk '{printf "%-10s %5s%% MEM  %s\n", $1, $4, $11}'
echo ""

echo "--- Top 5 nach RSS (tatsächlicher RAM) ---"
ps aux | sort -k6 -rn | head -6 | awk '{printf "%-10s %8d KB  %s\n", $1, $6, $11}'
echo ""

# ==============================================================================
echo "=== BENUTZERDEFINIERTE AUSGABE ==="
# ==============================================================================

echo "ps -eo ... erlaubt benutzerdefinierte Spalten"
echo ""

echo "PID, Parent-PID, User, Memory%, Command:"
ps -eo pid,ppid,user,%mem,comm | head -10
echo "..."
echo ""

echo "Nur bestimmte Spalten, sortiert nach Speicher:"
ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head -10
echo ""

# ==============================================================================
echo "=== PRAKTISCHE BEISPIELE ==="
# ==============================================================================

echo "--- Alle Chrome/Safari Prozesse ---"
browser_count=$(ps aux | grep -iE "chrome|safari" | grep -v grep | wc -l)
echo "Browser-Prozesse gefunden: $browser_count"
ps aux | grep -iE "chrome|safari" | grep -v grep | head -5
echo ""

echo "--- Prozesse ohne Terminal (Daemons) ---"
echo "Anzahl: $(ps aux | awk '$7 == "?" || $7 == "??" {count++} END {print count}')"
echo ""

echo "--- Älteste Prozesse (längste Laufzeit) ---"
ps -eo pid,etime,comm --sort=-etime | head -6
echo "(etime = elapsed time seit Start)"
echo ""

# ==============================================================================
echo "=== PROZESS-STATISTIK ==="
# ==============================================================================

total=$(ps aux | wc -l)
running=$(ps aux | awk '$8 ~ /R/' | wc -l)
sleeping=$(ps aux | awk '$8 ~ /S/' | wc -l)
zombie=$(ps aux | awk '$8 ~ /Z/' | wc -l)

echo "
Prozess-Übersicht:
━━━━━━━━━━━━━━━━━━━━━━━━━━
  Total:     $total
  Running:   $running
  Sleeping:  $sleeping
  Zombie:    $zombie
━━━━━━━━━━━━━━━━━━━━━━━━━━
"

# ==============================================================================
echo "=== PS OPTIONEN ÜBERSICHT ==="
# ==============================================================================

echo "
┌─────────────────┬─────────────────────────────────────┐
│ Option          │ Bedeutung                           │
├─────────────────┼─────────────────────────────────────┤
│ ps aux          │ Alle Prozesse (BSD-Style)           │
│ ps -ef          │ Alle Prozesse (POSIX-Style)         │
│ ps -u user      │ Prozesse eines Users                │
│ ps -p PID       │ Bestimmte PID                       │
│ ps -C name      │ Nach Befehlsname                    │
│ ps -eo ...      │ Benutzerdefinierte Spalten          │
│ ps --sort=key   │ Sortieren (z.B. -%cpu, -%mem)       │
│ ps --forest     │ Baum-Ansicht (Linux)                │
└─────────────────┴─────────────────────────────────────┘
"

echo "=== ENDE ==="
echo "Tipp: Kombiniere ps mit grep, awk und sort für mächtige Abfragen!"
