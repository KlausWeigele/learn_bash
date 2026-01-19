#!/bin/zsh
# ==============================================================================
# filesystem-tour.sh - Eine Tour durch das macOS Dateisystem
# ==============================================================================

echo "=== WILLKOMMEN ZUR MACOS DATEISYSTEM-TOUR ==="
echo ""
echo "Wir starten bei / (Root) und arbeiten uns durch die wichtigsten Ordner."
echo ""

# ==============================================================================
echo "=== STATION 1: DAS ROOT-VERZEICHNIS (/) ==="
# ==============================================================================

echo "Alle Einträge unter /:"
echo ""
ls -la / | head -25
echo ""

echo "Anzahl der Einträge unter /:"
ls -la / | tail -n +2 | wc -l
echo ""

# ==============================================================================
echo "=== STATION 2: SYMLINKS ERKENNEN ==="
# ==============================================================================

echo "Diese Ordner sind Symlinks (zeigen woanders hin):"
echo ""
for item in /var /tmp /etc; do
    if [[ -L $item ]]; then
        target=$(readlink $item)
        echo "  $item → $target"
    fi
done
echo ""

# ==============================================================================
echo "=== STATION 3: DIE UNIX-ORDNER ==="
# ==============================================================================

echo "--- /bin (Boot-essenzielle Befehle) ---"
echo "Inhalt (erste 10):"
ls /bin | head -10
echo "... und $(ls /bin | wc -l | tr -d ' ') Programme insgesamt"
echo ""

echo "--- /sbin (System-Admin Befehle) ---"
echo "Inhalt (erste 10):"
ls /sbin | head -10
echo "... und $(ls /sbin | wc -l | tr -d ' ') Programme insgesamt"
echo ""

echo "--- /usr (Unix System Resources) ---"
echo "Unterordner:"
ls /usr
echo ""

echo "--- /usr/bin (Allgemeine Befehle) ---"
echo "Anzahl Programme: $(ls /usr/bin | wc -l | tr -d ' ')"
echo "Beispiele: $(ls /usr/bin | head -5 | tr '\n' ' ')"
echo ""

echo "--- /usr/local (Lokal installiert - z.B. Homebrew) ---"
if [[ -d /usr/local/bin ]]; then
    echo "Anzahl Programme: $(ls /usr/local/bin 2>/dev/null | wc -l | tr -d ' ')"
    echo "Beispiele: $(ls /usr/local/bin 2>/dev/null | head -5 | tr '\n' ' ')"
else
    echo "(Ordner existiert nicht oder ist leer)"
fi
echo ""

# ==============================================================================
echo "=== STATION 4: DIE MACOS-ORDNER ==="
# ==============================================================================

echo "--- /Applications (GUI-Programme) ---"
echo "Anzahl Apps: $(ls /Applications/*.app 2>/dev/null | wc -l | tr -d ' ')"
echo "Beispiele:"
ls /Applications/*.app 2>/dev/null | head -5 | xargs -I {} basename "{}"
echo ""

echo "--- /Users (Home-Verzeichnisse) ---"
echo "Benutzer auf diesem Mac:"
ls /Users | grep -v "Shared" | grep -v "^\."
echo ""

echo "--- /System (macOS selbst - geschützt!) ---"
echo "Unterordner:"
ls /System
echo "(Dieser Ordner ist durch SIP geschützt)"
echo ""

echo "--- /Library (Systemweite Einstellungen) ---"
echo "Wichtige Unterordner:"
ls /Library | head -10
echo ""

echo "--- ~/Library (Deine persönlichen Einstellungen) ---"
echo "Größe deiner Library: $(du -sh ~/Library 2>/dev/null | cut -f1)"
echo "Wichtige Unterordner:"
ls ~/Library | head -8
echo ""

# ==============================================================================
echo "=== STATION 5: VERSTECKTE SCHÄTZE ==="
# ==============================================================================

echo "--- /private (Das echte Zuhause von var, tmp, etc) ---"
echo "Inhalt:"
ls /private
echo ""

echo "--- /Volumes (Gemountete Laufwerke) ---"
echo "Aktuell gemountet:"
ls /Volumes
echo ""

echo "--- /cores (Crash Dumps) ---"
if [[ -d /cores ]]; then
    count=$(ls /cores 2>/dev/null | wc -l | tr -d ' ')
    if [[ $count -gt 0 ]]; then
        echo "Core Dumps vorhanden: $count"
    else
        echo "(Leer - keine Crashes aufgezeichnet)"
    fi
else
    echo "(Ordner existiert nicht)"
fi
echo ""

# ==============================================================================
echo "=== STATION 6: DEIN HOME-VERZEICHNIS ==="
# ==============================================================================

echo "Dein Home: $HOME"
echo ""
echo "Standard-Ordner:"
for dir in Desktop Documents Downloads Movies Music Pictures Public; do
    if [[ -d ~/$dir ]]; then
        size=$(du -sh ~/$dir 2>/dev/null | cut -f1)
        echo "  ~/$dir: $size"
    fi
done
echo ""

echo "Versteckte Dateien in deinem Home (Auswahl):"
ls -la ~ | grep "^\." | head -10
echo ""

# ==============================================================================
echo "=== TOUR ABGESCHLOSSEN ==="
# ==============================================================================

echo "
Zusammenfassung:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Unix-Ordner:     /bin, /sbin, /usr, /var, /tmp, /etc
macOS-Ordner:    /Applications, /Library, /System, /Users
Dein Bereich:    $HOME
Versteckt:       /private, /Volumes, /cores
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Tipp: Nutze 'cd' um die Ordner selbst zu erkunden!
"
