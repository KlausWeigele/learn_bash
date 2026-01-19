#!/bin/zsh
# ==============================================================================
# xargs-magic.sh - Argumente aus stdin verarbeiten
# ==============================================================================

echo "=== XARGS: DIE BRÜCKE ZWISCHEN BEFEHLEN ==="
echo "xargs wandelt Eingaben (stdin) in Kommandozeilen-Argumente um"
echo ""

# ==============================================================================
echo "=== DAS GRUNDPRINZIP ==="
# ==============================================================================

echo "Ohne xargs - echo gibt nur Text aus:"
echo "datei1 datei2 datei3"
echo ""

echo "Mit xargs - Text wird zu Argumenten für einen Befehl:"
echo "datei1 datei2 datei3" | xargs echo "Dateien:"
echo ""

# ==============================================================================
echo "=== WARUM XARGS? ==="
# ==============================================================================

echo "Problem: Manche Befehle akzeptieren keine stdin-Eingabe"
echo ""
echo "Das funktioniert NICHT wie erwartet:"
echo "  find . -name '*.txt' | rm"
echo "  (rm liest nicht von stdin!)"
echo ""
echo "Lösung mit xargs:"
echo "  find . -name '*.txt' | xargs rm"
echo "  (xargs wandelt Zeilen in Argumente um)"
echo ""

# ==============================================================================
echo "=== EINFACHE BEISPIELE ==="
# ==============================================================================

# Testverzeichnis erstellen
TESTDIR=$(mktemp -d)
touch "$TESTDIR"/{a,b,c}.txt
touch "$TESTDIR"/{x,y,z}.log

echo "Testdateien erstellt in: $TESTDIR"
ls "$TESTDIR"
echo ""

echo "Alle Dateien mit xargs auflisten:"
ls "$TESTDIR" | xargs -I {} echo "  Gefunden: {}"
echo ""

# ==============================================================================
echo "=== -n: ANZAHL DER ARGUMENTE ==="
# ==============================================================================

echo "Alle auf einmal (Standard):"
echo "1 2 3 4 5 6" | xargs echo "Args:"
echo ""

echo "Je 2 Argumente pro Aufruf (-n 2):"
echo "1 2 3 4 5 6" | xargs -n 2 echo "Args:"
echo ""

echo "Je 1 Argument pro Aufruf (-n 1):"
echo "1 2 3 4 5 6" | xargs -n 1 echo "Arg:"
echo ""

# ==============================================================================
echo "=== -I: PLATZHALTER VERWENDEN ==="
# ==============================================================================

echo "Mit Platzhalter {} (wie bei find -exec):"
echo -e "apfel\nbirne\nkirsche" | xargs -I {} echo "Frucht: {} ist lecker"
echo ""

echo "Platzhalter kann beliebig sein:"
echo -e "rot\nblau\ngrün" | xargs -I COLOR echo "Die Farbe COLOR ist schön"
echo ""

# ==============================================================================
echo "=== -0: NULL-TERMINIERUNG (WICHTIG!) ==="
# ==============================================================================

echo "Problem: Dateinamen mit Leerzeichen"
# Erstelle Datei mit Leerzeichen im Namen
touch "$TESTDIR/meine datei.txt"
touch "$TESTDIR/noch eine.txt"
echo ""

echo "FALSCH - bricht bei Leerzeichen:"
echo "  find . -name '*.txt' | xargs ls"
echo "  (Interpretiert 'meine' und 'datei.txt' als separate Dateien!)"
echo ""

echo "RICHTIG - mit null-Terminierung:"
echo "  find . -name '*.txt' -print0 | xargs -0 ls"
echo "  (-print0 trennt mit \\0 statt \\n, -0 liest \\0)"
echo ""

echo "Demonstration:"
find "$TESTDIR" -name "*.txt" -print0 | xargs -0 -I {} basename "{}"
echo ""

# ==============================================================================
echo "=== -p: BESTÄTIGUNG VOR AUSFÜHRUNG ==="
# ==============================================================================

echo "Mit -p fragt xargs vor jeder Ausführung nach:"
echo "  find . -name '*.tmp' | xargs -p rm"
echo "  (Zeigt Befehl an und wartet auf y/n)"
echo ""

# ==============================================================================
echo "=== -P: PARALLELE AUSFÜHRUNG ==="
# ==============================================================================

echo "Mit -P können Befehle parallel laufen:"
echo "  find . -name '*.jpg' | xargs -P 4 -I {} convert {} {}.png"
echo "  (4 parallele Prozesse)"
echo ""

echo "Demonstration (simuliert mit sleep):"
echo "Sequentiell würde dauern: 4 x 1 Sekunde = 4 Sekunden"
echo "Parallel mit -P 4:"
time (echo -e "1\n2\n3\n4" | xargs -P 4 -I {} sh -c 'sleep 1; echo "Job {} fertig"')
echo ""

# ==============================================================================
echo "=== PRAKTISCHE KOMBINATIONEN ==="
# ==============================================================================

echo "=== find + xargs (Classic Combo) ==="
echo ""

echo "Alle .log-Dateien löschen:"
echo "  find . -name '*.log' -print0 | xargs -0 rm -f"
echo ""

echo "Alle Skripte ausführbar machen:"
echo "  find . -name '*.sh' -print0 | xargs -0 chmod +x"
echo ""

echo "In allen .txt-Dateien suchen:"
echo "  find . -name '*.txt' -print0 | xargs -0 grep 'suchbegriff'"
echo ""

echo "Dateien mit bestimmtem Inhalt finden:"
echo "  find . -name '*.py' | xargs grep -l 'import os'"
echo ""

# ==============================================================================
echo "=== XARGS VS FIND -EXEC ==="
# ==============================================================================

echo "
┌────────────────────────┬────────────────────────┐
│ find -exec             │ xargs                  │
├────────────────────────┼────────────────────────┤
│ Ein Prozess pro Datei  │ Sammelt Argumente      │
│ Langsamer bei vielen   │ Schneller bei vielen   │
│ Eingebaut in find      │ Flexibler              │
│ {} \\;                  │ Braucht -print0/-0     │
└────────────────────────┴────────────────────────┘

Faustregel:
- Wenige Dateien: find -exec ist einfacher
- Viele Dateien: xargs ist schneller
- Komplexe Verarbeitung: xargs mit -I {}
"

# Aufräumen
rm -rf "$TESTDIR"
echo "Testumgebung aufgeräumt."

echo ""
echo "=== ENDE ==="
echo "Tipp: Immer -print0 und -0 verwenden für Sicherheit bei Sonderzeichen!"
