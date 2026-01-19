#!/bin/zsh
# ==============================================================================
# top-understanding.sh - System-Monitoring verstehen
# ==============================================================================

echo "=== SYSTEM-MONITORING: TOP UND MEHR ==="
echo "Verstehe, was auf deinem Mac gerade passiert!"
echo ""

# ==============================================================================
echo "=== SYSTEM-ÜBERSICHT ==="
# ==============================================================================

echo "--- Uptime und Load ---"
uptime
echo ""

echo "Load Average erklärt:"
load=$(sysctl -n vm.loadavg 2>/dev/null | awk '{print $2, $3, $4}')
cpus=$(sysctl -n hw.ncpu)
echo "  Load: $load"
echo "  CPUs: $cpus"
echo ""

echo "Interpretation:"
load_1=$(echo $load | awk '{print $1}')
if (( $(echo "$load_1 < $cpus" | bc -l) )); then
    echo "  ✓ System entspannt (Load < CPU-Kerne)"
elif (( $(echo "$load_1 < $cpus * 2" | bc -l) )); then
    echo "  ⚠ System beschäftigt (Load ~ CPU-Kerne)"
else
    echo "  ✗ System überlastet (Load > CPU-Kerne)"
fi
echo ""

# ==============================================================================
echo "=== CPU-INFORMATIONEN ==="
# ==============================================================================

echo "--- Hardware ---"
echo "  CPU-Kerne: $(sysctl -n hw.ncpu)"
echo "  Physische CPUs: $(sysctl -n hw.physicalcpu)"
echo "  Logische CPUs: $(sysctl -n hw.logicalcpu)"

cpu_brand=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Apple Silicon")
echo "  Prozessor: $cpu_brand"
echo ""

echo "--- CPU-Nutzung (Snapshot) ---"
# Auf macOS verwenden wir top im Logging-Modus
top_output=$(top -l 1 -n 0 2>/dev/null | head -12)
echo "$top_output" | grep -E "CPU usage|Load Avg"
echo ""

# ==============================================================================
echo "=== SPEICHER-INFORMATIONEN ==="
# ==============================================================================

echo "--- RAM-Übersicht ---"

# Gesamter RAM
total_mem=$(sysctl -n hw.memsize)
total_mem_gb=$(echo "scale=2; $total_mem / 1024 / 1024 / 1024" | bc)
echo "  Gesamt: ${total_mem_gb} GB"

# vm_stat für Details
echo ""
echo "--- Speicher-Statistik (vm_stat) ---"
vm_stat | head -10
echo ""

echo "Erklärung:"
echo "  Pages free:     Sofort verfügbar"
echo "  Pages active:   Aktuell genutzt"
echo "  Pages inactive: Kürzlich genutzt, kann freigegeben werden"
echo "  Pages wired:    Vom System fixiert, nicht auslagerbar"
echo ""

# ==============================================================================
echo "=== TOP RESSOURCEN-VERBRAUCHER (JETZT) ==="
# ==============================================================================

echo "--- Top 10 nach CPU ---"
ps aux | sort -k3 -rn | head -11 | awk 'NR==1 {print "USER       %CPU %MEM  COMMAND"} NR>1 {printf "%-10s %5s %5s  %s\n", $1, $3, $4, $11}'
echo ""

echo "--- Top 10 nach RAM ---"
ps aux | sort -k6 -rn | head -11 | awk 'NR==1 {print "USER        RSS(KB)  COMMAND"} NR>1 {printf "%-10s %8s  %s\n", $1, $6, $11}'
echo ""

# ==============================================================================
echo "=== FESTPLATTEN-NUTZUNG ==="
# ==============================================================================

echo "--- Belegter Speicherplatz ---"
df -h | grep -E "^/dev|Filesystem"
echo ""

# ==============================================================================
echo "=== NETZWERK-AKTIVITÄT ==="
# ==============================================================================

echo "--- Aktive Verbindungen ---"
echo "Anzahl etablierter Verbindungen: $(netstat -an 2>/dev/null | grep ESTABLISHED | wc -l | tr -d ' ')"
echo "Anzahl lauschender Ports: $(netstat -an 2>/dev/null | grep LISTEN | wc -l | tr -d ' ')"
echo ""

echo "--- Top lauschende Ports ---"
netstat -an 2>/dev/null | grep LISTEN | head -5
echo ""

# ==============================================================================
echo "=== TOP INTERAKTIV NUTZEN ==="
# ==============================================================================

echo "
top ist ein interaktives Tool. Starte es mit: top

┌──────────────────────────────────────────────────────────────┐
│ Wichtige Tastenbefehle in top:                               │
├──────────────────────────────────────────────────────────────┤
│ q         Beenden                                            │
│ h         Hilfe anzeigen                                     │
│ P         Nach CPU sortieren                                 │
│ M         Nach Speicher sortieren                            │
│ k         Prozess killen (PID eingeben)                      │
│ r         Priorität ändern (renice)                          │
│ u         Nach User filtern                                  │
│ c         Volle Befehlszeile ein/aus                        │
│ 1         Einzelne CPU-Kerne anzeigen                        │
│ s         Aktualisierungsrate ändern                         │
└──────────────────────────────────────────────────────────────┘
"

# ==============================================================================
echo "=== HTOP - DIE BESSERE ALTERNATIVE ==="
# ==============================================================================

if command -v htop &> /dev/null; then
    echo "htop ist installiert!"
    echo "Starte mit: htop"
    echo ""
    echo "Vorteile von htop:"
    echo "  - Farbige Ausgabe"
    echo "  - Maus-Unterstützung"
    echo "  - Einfacheres Killen/Renicen"
    echo "  - CPU-Balkenanzeige"
else
    echo "htop ist NICHT installiert."
    echo "Installation: brew install htop"
fi
echo ""

# ==============================================================================
echo "=== ACTIVITY MONITOR (GUI) ==="
# ==============================================================================

echo "macOS hat auch einen grafischen Activity Monitor:"
echo "  - Öffnen: Cmd+Space, 'Activity Monitor'"
echo "  - Oder: /Applications/Utilities/Activity Monitor.app"
echo ""
echo "Dort siehst du:"
echo "  - CPU, Speicher, Energie, Festplatte, Netzwerk"
echo "  - Prozesse mit Details"
echo "  - System-Auslastung über Zeit"
echo ""

# ==============================================================================
echo "=== QUICK MONITORING COMMANDS ==="
# ==============================================================================

echo "
Schnelle Checks für die Kommandozeile:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# System-Load
uptime

# CPU-Fresser finden
ps aux --sort=-%cpu | head -5

# RAM-Fresser finden
ps aux --sort=-%mem | head -5

# Festplatte fast voll?
df -h /

# Wer nutzt Port 8080?
lsof -i :8080

# Prozesse zählen
ps aux | wc -l

# Offene Dateien pro Prozess
lsof -c processname | wc -l

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"

echo "=== ENDE ==="
echo "Tipp: Für Live-Monitoring starte 'top' oder 'htop'!"
