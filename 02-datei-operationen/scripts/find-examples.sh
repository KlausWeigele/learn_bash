#!/bin/zsh
# ==============================================================================
# find-examples.sh - Der mächtigste Suchbefehl
# ==============================================================================

echo "=== FIND: DATEIEN SUCHEN ==="
echo "find durchsucht Verzeichnisse rekursiv nach Kriterien"
echo ""

# Testverzeichnis erstellen
TESTDIR=$(mktemp -d)
echo "Erstelle Testumgebung in: $TESTDIR"
echo ""

# Testdateien erstellen
mkdir -p "$TESTDIR"/{docs,images,scripts,backup}
touch "$TESTDIR"/docs/{readme.txt,notes.txt,report.pdf}
touch "$TESTDIR"/images/{foto.jpg,bild.png,icon.gif}
touch "$TESTDIR"/scripts/{start.sh,stop.sh,helper.py}
touch "$TESTDIR"/backup/{old.bak,older.bak}
touch "$TESTDIR"/.hidden_file

# Größere Datei simulieren
dd if=/dev/zero of="$TESTDIR/docs/large.bin" bs=1024 count=100 2>/dev/null

# ==============================================================================
echo "=== NACH NAME SUCHEN ==="
# ==============================================================================

echo "Alle .txt-Dateien:"
find "$TESTDIR" -name "*.txt"
echo ""

echo "Case-insensitive (würde auch .TXT finden):"
find "$TESTDIR" -iname "*.txt"
echo ""

echo "Dateien die mit 's' beginnen:"
find "$TESTDIR" -name "s*"
echo ""

# ==============================================================================
echo "=== NACH TYP SUCHEN ==="
# ==============================================================================

echo "Nur Verzeichnisse (-type d):"
find "$TESTDIR" -type d
echo ""

echo "Nur reguläre Dateien (-type f):"
find "$TESTDIR" -type f | head -5
echo "  ... (gekürzt)"
echo ""

# ==============================================================================
echo "=== NACH GRÖSSE SUCHEN ==="
# ==============================================================================

echo "Dateien größer als 50KB:"
find "$TESTDIR" -type f -size +50k
echo ""

echo "Dateien kleiner als 1KB:"
find "$TESTDIR" -type f -size -1k | head -3
echo "  ... (gekürzt)"
echo ""

# Größeneinheiten:
# c = Bytes
# k = Kilobytes
# M = Megabytes
# G = Gigabytes

# ==============================================================================
echo "=== KOMBINIERTE SUCHE ==="
# ==============================================================================

echo "Alle .sh-Dateien (Skripte):"
find "$TESTDIR" -type f -name "*.sh"
echo ""

echo "Alle Bild-Dateien (.jpg, .png, .gif):"
find "$TESTDIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.gif" \)
echo ""

echo "NICHT .bak-Dateien:"
find "$TESTDIR" -type f ! -name "*.bak" | head -5
echo "  ... (gekürzt)"
echo ""

# ==============================================================================
echo "=== VERSTECKTE DATEIEN ==="
# ==============================================================================

echo "Versteckte Dateien finden (beginnen mit .):"
find "$TESTDIR" -name ".*" -type f
echo ""

# ==============================================================================
echo "=== AKTIONEN AUSFÜHREN ==="
# ==============================================================================

echo "Mit -exec: Dateigröße jeder .txt-Datei anzeigen:"
find "$TESTDIR" -name "*.txt" -exec ls -lh {} \;
echo ""

echo "Mit -exec und Bestätigung (simuliert):"
echo "  find . -name '*.tmp' -exec rm {} \;"
echo "  (Löscht jede gefundene Datei)"
echo ""

echo "Mit -delete: Direkt löschen (VORSICHT!):"
echo "  find . -name '*.bak' -delete"
echo ""

# ==============================================================================
echo "=== SUCHTIEFE BEGRENZEN ==="
# ==============================================================================

echo "Nur im aktuellen Verzeichnis (maxdepth 1):"
find "$TESTDIR" -maxdepth 1 -type f
echo ""

echo "Maximal 2 Ebenen tief:"
find "$TESTDIR" -maxdepth 2 -type f | head -5
echo "  ... (gekürzt)"
echo ""

# ==============================================================================
echo "=== PRAKTISCHE BEISPIELE ==="
# ==============================================================================

echo "Alle leeren Dateien finden:"
touch "$TESTDIR/empty.txt"
find "$TESTDIR" -type f -empty
echo ""

echo "Dateien nach Extension zählen:"
find "$TESTDIR" -type f -name "*.*" | sed 's/.*\.//' | sort | uniq -c
echo ""

# ==============================================================================
echo "=== PERFORMANCE-TIPP ==="
# ==============================================================================

echo "
Reihenfolge der Filter ist wichtig!
Schneller: find . -type f -name '*.txt'  (erst Typ, dann Name)
Langsamer: find . -name '*.txt' -type f  (Name-Check auf allem)

Bei -exec: Sammeln mit + statt einzeln mit \;
Schneller: find . -name '*.txt' -exec ls {} +
Langsamer: find . -name '*.txt' -exec ls {} \;
"

# Aufräumen
rm -rf "$TESTDIR"
echo "Testumgebung aufgeräumt."

echo ""
echo "=== ENDE ==="
echo "Tipp: Nutze 'find . -name \"muster\" 2>/dev/null' um Fehlermeldungen zu unterdrücken"
