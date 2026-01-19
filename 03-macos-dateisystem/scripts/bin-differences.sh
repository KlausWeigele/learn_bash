#!/bin/zsh
# ==============================================================================
# bin-differences.sh - Was liegt in welchem bin-Ordner?
# ==============================================================================

echo "=== DIE BIN-ORDNER HIERARCHIE ==="
echo ""
echo "macOS hat mehrere Ordner für ausführbare Programme."
echo "Jeder hat seinen spezifischen Zweck!"
echo ""

# ==============================================================================
echo "=== ÜBERSICHT ==="
# ==============================================================================

echo "
┌─────────────────┬─────────────────────────────────────────────┐
│ Ordner          │ Zweck                                       │
├─────────────────┼─────────────────────────────────────────────┤
│ /bin            │ Boot-essentiell (Shell, Basis-Befehle)      │
│ /sbin           │ System-Admin Boot-essentiell                │
│ /usr/bin        │ Allgemeine Befehle (nach Boot verfügbar)    │
│ /usr/sbin       │ System-Admin Befehle                        │
│ /usr/local/bin  │ Lokal installiert (Homebrew, eigene)        │
│ ~/bin           │ Persönliche Skripte                         │
└─────────────────┴─────────────────────────────────────────────┘
"

# ==============================================================================
echo "=== STATISTIK ==="
# ==============================================================================

echo "Anzahl Programme pro Ordner:"
echo ""

for dir in /bin /sbin /usr/bin /usr/sbin /usr/local/bin ~/bin; do
    if [[ -d $dir ]]; then
        count=$(ls "$dir" 2>/dev/null | wc -l | tr -d ' ')
        printf "  %-20s %5s Programme\n" "$dir:" "$count"
    else
        printf "  %-20s (existiert nicht)\n" "$dir:"
    fi
done
echo ""

# ==============================================================================
echo "=== /bin - BOOT-ESSENTIELL ==="
# ==============================================================================

echo "Diese Programme sind absolut grundlegend."
echo "Sie werden gebraucht, BEVOR /usr gemountet ist."
echo ""
echo "Inhalt von /bin:"
ls /bin | column
echo ""

echo "Wichtigste Befehle:"
echo "  bash, zsh, sh     → Shells"
echo "  ls, cp, mv, rm    → Datei-Operationen"
echo "  cat, echo, pwd    → Basis-Utilities"
echo "  chmod, chown      → Berechtigungen"
echo ""

# ==============================================================================
echo "=== /sbin - SYSTEM-ADMIN (BOOT) ==="
# ==============================================================================

echo "System-Administration während des Boots."
echo ""
echo "Inhalt von /sbin:"
ls /sbin | column
echo ""

echo "Wichtigste Befehle:"
echo "  mount, umount     → Dateisysteme mounten"
echo "  fsck              → Dateisystem prüfen"
echo "  launchd           → Init-System (PID 1!)"
echo "  reboot, shutdown  → System-Kontrolle"
echo ""

# ==============================================================================
echo "=== /usr/bin - ALLGEMEINE BEFEHLE ==="
# ==============================================================================

echo "Die meisten System-Befehle landen hier."
echo "Verfügbar nachdem /usr gemountet wurde."
echo ""
echo "Beispiele aus /usr/bin (Auswahl):"
ls /usr/bin | head -30 | column
echo "... ($(ls /usr/bin | wc -l | tr -d ' ') insgesamt)"
echo ""

echo "Wichtige Befehle:"
echo "  git, python3, perl  → Entwickler-Tools"
echo "  ssh, scp, curl      → Netzwerk"
echo "  man, less, more     → Dokumentation"
echo "  grep, sed, awk      → Text-Verarbeitung"
echo ""

# ==============================================================================
echo "=== /usr/sbin - SYSTEM-ADMIN ==="
# ==============================================================================

echo "System-Administration nach dem Boot."
echo ""
echo "Beispiele aus /usr/sbin (Auswahl):"
ls /usr/sbin | head -20 | column
echo ""

echo "Wichtige Befehle:"
echo "  diskutil           → Festplatten verwalten"
echo "  systemsetup        → System-Einstellungen"
echo "  networksetup       → Netzwerk konfigurieren"
echo ""

# ==============================================================================
echo "=== /usr/local/bin - LOKAL INSTALLIERT ==="
# ==============================================================================

echo "Hier installiert Homebrew und du selbst."
echo "NICHT von Apple verwaltet!"
echo ""

if [[ -d /usr/local/bin ]] && [[ $(ls /usr/local/bin 2>/dev/null | wc -l) -gt 0 ]]; then
    echo "Inhalt von /usr/local/bin:"
    ls /usr/local/bin | head -20 | column
    echo ""

    # Prüfe auf Homebrew
    if command -v brew &> /dev/null; then
        echo "Homebrew ist installiert!"
        echo "Homebrew-Programme: $(brew list | wc -l | tr -d ' ')"
    fi
else
    echo "(Ordner leer oder nicht vorhanden)"
    echo "Tipp: Installiere Homebrew um hier Programme hinzuzufügen!"
fi
echo ""

# ==============================================================================
echo "=== ~/bin - DEINE PERSÖNLICHEN SKRIPTE ==="
# ==============================================================================

echo "Ein optionaler Ordner für deine eigenen Skripte."
echo ""

if [[ -d ~/bin ]]; then
    count=$(ls ~/bin 2>/dev/null | wc -l | tr -d ' ')
    if [[ $count -gt 0 ]]; then
        echo "Deine Skripte in ~/bin:"
        ls ~/bin
    else
        echo "(Ordner existiert, aber ist leer)"
    fi
else
    echo "(~/bin existiert nicht)"
    echo ""
    echo "Tipp: Erstelle ihn mit:"
    echo "  mkdir ~/bin"
    echo ""
    echo "Und füge ihn zum PATH hinzu (in ~/.zshrc):"
    echo "  export PATH=\"\$HOME/bin:\$PATH\""
fi
echo ""

# ==============================================================================
echo "=== DEIN PATH ==="
# ==============================================================================

echo "Der PATH bestimmt, in welcher Reihenfolge gesucht wird:"
echo ""
echo "$PATH" | tr ':' '\n' | nl
echo ""

# ==============================================================================
echo "=== WO LIEGT EIN BEFEHL? ==="
# ==============================================================================

echo "Beispiele mit 'which' und 'where':"
echo ""

for cmd in ls bash zsh git python3 brew node; do
    location=$(which $cmd 2>/dev/null)
    if [[ -n $location ]]; then
        printf "  %-10s → %s\n" "$cmd" "$location"
    else
        printf "  %-10s → (nicht gefunden)\n" "$cmd"
    fi
done
echo ""

# ==============================================================================
echo "=== GLEICHNAMIGE PROGRAMME ==="
# ==============================================================================

echo "Manchmal gibt es den gleichen Befehl mehrfach:"
echo ""

# Prüfe auf mehrfache python-Versionen
echo "Python-Versionen:"
where python3 2>/dev/null || echo "  python3 nicht gefunden"
echo ""

# Prüfe ob git mehrfach existiert
echo "Git-Versionen:"
where git 2>/dev/null || echo "  git nicht gefunden"
echo ""

echo "
FAZIT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Apple liefert: /bin, /sbin, /usr/bin, /usr/sbin
- Du installierst: /usr/local/bin (Homebrew)
- Du schreibst: ~/bin (persönliche Skripte)

Der erste Fund im PATH gewinnt!
Homebrew-Versionen überschreiben oft System-Versionen.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
