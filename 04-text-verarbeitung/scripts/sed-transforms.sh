#!/bin/zsh
# ==============================================================================
# sed-transforms.sh - Text transformieren mit sed
# ==============================================================================

echo "=== SED: STREAM EDITOR ==="
echo "sed verarbeitet Text Zeile für Zeile und transformiert ihn."
echo ""

# Testdaten erstellen
TESTDIR=$(mktemp -d)
TESTFILE="$TESTDIR/config.txt"

cat > "$TESTFILE" << 'EOF'
# Konfigurationsdatei
server_host=localhost
server_port=8080
database_host=db.example.com
database_port=5432
database_user=admin
debug_mode=true
log_level=INFO
max_connections=100
timeout=30
EOF

echo "Testdatei erstellt:"
echo "─────────────────────────────────────────────────────────"
cat "$TESTFILE"
echo "─────────────────────────────────────────────────────────"
echo ""

# ==============================================================================
echo "=== ERSETZEN (SUBSTITUTE) ==="
# ==============================================================================

echo "sed 's/localhost/127.0.0.1/' - Ersetze localhost:"
sed 's/localhost/127.0.0.1/' "$TESTFILE" | grep "server_host"
echo ""

echo "--- Erstes vs. alle Vorkommen ---"
echo ""

echo "Teststring: 'Apfel Apfel Apfel'"
echo "sed 's/Apfel/Birne/' (nur erstes):"
echo "Apfel Apfel Apfel" | sed 's/Apfel/Birne/'

echo "sed 's/Apfel/Birne/g' (alle - global):"
echo "Apfel Apfel Apfel" | sed 's/Apfel/Birne/g'
echo ""

echo "sed 's/Apfel/Birne/2' (nur das 2.):"
echo "Apfel Apfel Apfel" | sed 's/Apfel/Birne/2'
echo ""

# ==============================================================================
echo "=== ANDERE DELIMITER ==="
# ==============================================================================

echo "Problem: Pfade enthalten / - das kollidiert mit sed 's/.../.../'"
echo ""

echo "Lösung: Andere Delimiter verwenden"
echo "sed 's|/old/path|/new/path|g'"
echo "sed 's#alt#neu#g'"
echo "sed 's@alt@neu@g'"
echo ""

echo "Beispiel mit Pfad:"
echo "/usr/local/bin" | sed 's|/usr/local|/opt|'
echo ""

# ==============================================================================
echo "=== CASE-INSENSITIVE ==="
# ==============================================================================

echo "sed 's/info/DEBUG/gi' - Case-insensitive ersetzen:"
echo "INFO info Info" | sed 's/info/DEBUG/gi'
echo ""

# ==============================================================================
echo "=== ZEILEN LÖSCHEN ==="
# ==============================================================================

echo "sed '1d' - Erste Zeile löschen:"
sed '1d' "$TESTFILE" | head -3
echo "..."
echo ""

echo "sed '3,5d' - Zeilen 3-5 löschen:"
sed '3,5d' "$TESTFILE" | head -5
echo "..."
echo ""

echo "sed '/^#/d' - Kommentare löschen (Zeilen mit #):"
sed '/^#/d' "$TESTFILE" | head -5
echo "..."
echo ""

echo "sed '/^$/d' - Leere Zeilen löschen:"
echo -e "Zeile1\n\nZeile2\n\nZeile3" | sed '/^$/d'
echo ""

# ==============================================================================
echo "=== ZEILEN AUSWÄHLEN ==="
# ==============================================================================

echo "sed -n '3p' - Nur Zeile 3 ausgeben:"
sed -n '3p' "$TESTFILE"
echo ""

echo "sed -n '2,4p' - Zeilen 2-4:"
sed -n '2,4p' "$TESTFILE"
echo ""

echo "sed -n '/database/p' - Zeilen mit 'database':"
sed -n '/database/p' "$TESTFILE"
echo ""

# ==============================================================================
echo "=== ZEILEN EINFÜGEN ==="
# ==============================================================================

echo "sed '1i\\HEADER' - VOR Zeile 1 einfügen:"
sed '1i\
# === HEADER ===' "$TESTFILE" | head -3
echo "..."
echo ""

echo "sed '\$a\\FOOTER' - NACH letzter Zeile einfügen:"
sed '$a\
# === FOOTER ===' "$TESTFILE" | tail -3
echo ""

# ==============================================================================
echo "=== BACKREFERENCES (GRUPPEN) ==="
# ==============================================================================

echo "Gruppen erfassen und wiederverwenden mit \\1, \\2, etc."
echo ""

echo "Werte in Klammern setzen:"
echo "sed 's/\\(.*\\)=\\(.*\\)/\\1=[\\2]/' (Basic Regex)"
sed 's/\(.*\)=\(.*\)/\1=[\2]/' "$TESTFILE" | head -5
echo "..."
echo ""

echo "Mit Extended Regex (-E) - keine Backslashes bei Gruppen:"
sed -E 's/(.*)=(.*)/\1=[\2]/' "$TESTFILE" | head -3
echo "..."
echo ""

echo "--- Praktisches Beispiel: Werte extrahieren ---"
echo ""

echo "Nur die Werte (rechts vom =):"
sed -E 's/.*=//' "$TESTFILE" | grep -v "^#" | head -5
echo ""

echo "Key-Value tauschen:"
sed -E 's/(.*)=(.*)/\2=\1/' "$TESTFILE" | grep -v "^#" | head -3
echo ""

# ==============================================================================
echo "=== MEHRERE BEFEHLE ==="
# ==============================================================================

echo "Mit -e mehrere Ersetzungen:"
echo "sed -e 's/true/false/' -e 's/INFO/DEBUG/'"
sed -e 's/true/false/' -e 's/INFO/DEBUG/' "$TESTFILE" | grep -E "debug_mode|log_level"
echo ""

echo "Alternativ mit Semikolon:"
echo "sed 's/true/false/; s/INFO/DEBUG/'"
sed 's/true/false/; s/INFO/DEBUG/' "$TESTFILE" | grep -E "debug_mode|log_level"
echo ""

# ==============================================================================
echo "=== IN-PLACE BEARBEITUNG ==="
# ==============================================================================

echo "ACHTUNG: sed -i ändert die Datei direkt!"
echo ""
echo "macOS:  sed -i '' 's/alt/neu/g' datei"
echo "Linux:  sed -i 's/alt/neu/g' datei"
echo ""

# Demo mit Kopie
cp "$TESTFILE" "$TESTDIR/config_backup.txt"
echo "Original debug_mode:"
grep "debug_mode" "$TESTDIR/config_backup.txt"

sed -i '' 's/true/false/' "$TESTDIR/config_backup.txt"
echo "Nach sed -i '':"
grep "debug_mode" "$TESTDIR/config_backup.txt"
echo ""

# ==============================================================================
echo "=== PRAKTISCHE BEISPIELE ==="
# ==============================================================================

echo "--- Windows-Zeilenenden (CRLF) entfernen ---"
echo "sed 's/\\r\$//' datei"
echo ""

echo "--- Führende Leerzeichen entfernen ---"
echo "   Text mit Leerzeichen" | sed 's/^[ \t]*//'
echo ""

echo "--- Trailing Whitespace entfernen ---"
echo "Text mit Leerzeichen   " | sed 's/[ \t]*$//' | cat -A
echo "(Das \$ markiert das Zeilenende)"
echo ""

echo "--- Mehrere Leerzeichen zu einem ---"
echo "zu    viele     Leerzeichen" | sed 's/  */ /g'
echo ""

echo "--- HTML-Tags entfernen ---"
echo "<p>Ein <b>fetter</b> Text</p>" | sed 's/<[^>]*>//g'
echo ""

echo "--- Zeilen nummerieren ---"
sed '=' "$TESTFILE" | sed 'N;s/\n/\t/' | head -5
echo "..."
echo ""

# ==============================================================================
echo "=== SED BEFEHL-ÜBERSICHT ==="
# ==============================================================================

echo "
┌────────────┬─────────────────────────────────────┐
│ Befehl     │ Bedeutung                           │
├────────────┼─────────────────────────────────────┤
│ s/a/b/     │ Ersetze erstes a durch b            │
│ s/a/b/g    │ Ersetze alle a durch b              │
│ s/a/b/gi   │ Global + case-insensitive           │
│ d          │ Lösche Zeile                        │
│ p          │ Drucke Zeile (mit -n)               │
│ i\\text     │ Füge vor Zeile ein                  │
│ a\\text     │ Füge nach Zeile ein                 │
│ =          │ Zeige Zeilennummer                  │
│ q          │ Beende nach dieser Zeile            │
└────────────┴─────────────────────────────────────┘

Adressierung:
  5         → Zeile 5
  5,10      → Zeilen 5-10
  /muster/  → Zeilen mit Muster
  \$         → Letzte Zeile
"

# Aufräumen
rm -rf "$TESTDIR"
echo "Testumgebung aufgeräumt."

echo ""
echo "=== ENDE ==="
echo "Tipp: Teste sed-Befehle IMMER erst ohne -i!"
