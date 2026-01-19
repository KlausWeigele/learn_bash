#!/bin/zsh
# ==============================================================================
# grep-patterns.sh - Suchen mit grep und Regulären Ausdrücken
# ==============================================================================

echo "=== GREP: GLOBAL REGULAR EXPRESSION PRINT ==="
echo "grep durchsucht Text nach Mustern und gibt passende Zeilen aus."
echo ""

# Testdaten erstellen
TESTDIR=$(mktemp -d)
TESTFILE="$TESTDIR/logfile.txt"

cat > "$TESTFILE" << 'EOF'
2024-01-15 08:30:22 INFO  Server started on port 8080
2024-01-15 08:30:25 DEBUG Connection pool initialized
2024-01-15 08:31:00 INFO  User admin logged in from 192.168.1.100
2024-01-15 08:31:15 WARNING High memory usage: 85%
2024-01-15 08:32:00 ERROR Database connection failed
2024-01-15 08:32:05 ERROR Retry attempt 1 of 3
2024-01-15 08:32:10 INFO  Database connection restored
2024-01-15 08:33:00 INFO  User guest logged in from 10.0.0.50
2024-01-15 08:34:00 DEBUG Cache cleared
2024-01-15 08:35:00 ERROR Critical: Out of memory!
EOF

echo "Testdatei erstellt. Inhalt:"
echo "─────────────────────────────────────────────────────────"
cat "$TESTFILE"
echo "─────────────────────────────────────────────────────────"
echo ""

# ==============================================================================
echo "=== EINFACHE SUCHE ==="
# ==============================================================================

echo "grep 'ERROR' - Zeilen mit 'ERROR':"
grep 'ERROR' "$TESTFILE"
echo ""

echo "grep 'error' - Case-sensitive (findet nichts):"
grep 'error' "$TESTFILE" || echo "(keine Treffer)"
echo ""

echo "grep -i 'error' - Case-insensitive:"
grep -i 'error' "$TESTFILE"
echo ""

# ==============================================================================
echo "=== MIT ZEILENNUMMERN UND ZÄHLEN ==="
# ==============================================================================

echo "grep -n 'INFO' - Mit Zeilennummern:"
grep -n 'INFO' "$TESTFILE"
echo ""

echo "grep -c 'INFO' - Anzahl der Treffer:"
grep -c 'INFO' "$TESTFILE"
echo ""

# ==============================================================================
echo "=== INVERTIEREN UND FILTERN ==="
# ==============================================================================

echo "grep -v 'DEBUG' - Alles OHNE 'DEBUG':"
grep -v 'DEBUG' "$TESTFILE"
echo ""

# ==============================================================================
echo "=== KONTEXT ANZEIGEN ==="
# ==============================================================================

echo "grep -A 1 'ERROR' - Zeile nach ERROR (After):"
grep -A 1 'ERROR' "$TESTFILE" | head -8
echo ""

echo "grep -B 1 'ERROR' - Zeile vor ERROR (Before):"
grep -B 1 'ERROR' "$TESTFILE" | head -8
echo ""

echo "grep -C 1 'WARNING' - Kontext (1 Zeile vor und nach):"
grep -C 1 'WARNING' "$TESTFILE"
echo ""

# ==============================================================================
echo "=== REGULÄRE AUSDRÜCKE ==="
# ==============================================================================

echo "--- Zeilenanfang und -ende ---"
echo ""

echo "grep '^2024' - Zeilen die mit '2024' beginnen (alle!):"
grep '^2024' "$TESTFILE" | wc -l
echo "(alle Zeilen - jede beginnt mit 2024)"
echo ""

echo "grep 'memory!$' - Zeilen die mit 'memory!' enden:"
grep 'memory!$' "$TESTFILE"
echo ""

echo "--- Zeichenklassen ---"
echo ""

echo "grep '[0-9]\\{3\\}\\.[0-9]' - IP-Adressen finden:"
grep '[0-9]\{3\}\.[0-9]' "$TESTFILE"
echo ""

echo "--- Extended Regex (-E) ---"
echo ""

echo "grep -E 'ERROR|WARNING' - Mehrere Muster (ODER):"
grep -E 'ERROR|WARNING' "$TESTFILE"
echo ""

echo "grep -E '[0-9]{2}:[0-9]{2}:[0-9]{2}' - Zeitformat HH:MM:SS:"
grep -oE '[0-9]{2}:[0-9]{2}:[0-9]{2}' "$TESTFILE" | head -5
echo "(-o zeigt nur den Match, nicht die ganze Zeile)"
echo ""

# ==============================================================================
echo "=== NUR MATCH ODER NUR DATEINAMEN ==="
# ==============================================================================

echo "grep -o 'User [a-z]*' - Nur den Match anzeigen:"
grep -o 'User [a-z]*' "$TESTFILE"
echo ""

# Mehrere Testdateien erstellen
echo "ERROR in file1" > "$TESTDIR/file1.log"
echo "alles ok" > "$TESTDIR/file2.log"
echo "ERROR hier auch" > "$TESTDIR/file3.log"

echo "grep -l 'ERROR' *.log - Nur Dateinamen mit Treffern:"
grep -l 'ERROR' "$TESTDIR"/*.log
echo ""

echo "grep -L 'ERROR' *.log - Dateinamen OHNE Treffer:"
grep -L 'ERROR' "$TESTDIR"/*.log
echo ""

# ==============================================================================
echo "=== WORTGRENZEN ==="
# ==============================================================================

echo "Problem: grep 'in' findet auch 'admin', 'Connection'..."
echo "grep 'in' (ohne -w):"
grep -o 'in' "$TESTFILE" | wc -l
echo "Treffer (inkl. 'adm*in*', 'logg*in*g', etc.)"
echo ""

echo "Lösung: grep -w 'in' - Nur ganze Wörter:"
grep -w 'in' "$TESTFILE" || echo "(keine Treffer - 'in' kommt nicht als eigenes Wort vor)"
echo ""

# ==============================================================================
echo "=== PRAKTISCHE REGEX-BEISPIELE ==="
# ==============================================================================

echo "--- IP-Adressen extrahieren ---"
grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$TESTFILE"
echo ""

echo "--- Prozentzahlen finden ---"
grep -oE '[0-9]+%' "$TESTFILE"
echo ""

echo "--- Alle ERROR-Nachrichten (nach ERROR:) ---"
grep 'ERROR' "$TESTFILE" | sed 's/.*ERROR *//'
echo ""

# ==============================================================================
echo "=== REKURSIVE SUCHE ==="
# ==============================================================================

echo "grep -r 'ERROR' verzeichnis/ - Rekursiv in Ordner suchen:"
grep -r 'ERROR' "$TESTDIR" 2>/dev/null
echo ""

echo "grep -rn 'ERROR' --include='*.log' - Nur in .log-Dateien:"
grep -rn 'ERROR' "$TESTDIR" --include='*.log' 2>/dev/null
echo ""

# ==============================================================================
echo "=== REGEX CHEATSHEET ==="
# ==============================================================================

echo "
┌────────────┬─────────────────────────────────────┐
│ Muster     │ Bedeutung                           │
├────────────┼─────────────────────────────────────┤
│ .          │ Ein beliebiges Zeichen              │
│ *          │ Null oder mehr vom Vorherigen       │
│ +          │ Eins oder mehr (Extended -E)        │
│ ?          │ Null oder eins (Extended -E)        │
│ ^          │ Zeilenanfang                        │
│ \$          │ Zeilenende                          │
│ [abc]      │ a, b oder c                         │
│ [^abc]     │ NICHT a, b, c                       │
│ [a-z]      │ Kleinbuchstaben                     │
│ [0-9]      │ Ziffern                             │
│ {n}        │ Exakt n mal (Extended -E)           │
│ {n,m}      │ Zwischen n und m mal                │
│ (a|b)      │ a ODER b (Extended -E)              │
│ \\b         │ Wortgrenze                          │
└────────────┴─────────────────────────────────────┘
"

# Aufräumen
rm -rf "$TESTDIR"
echo "Testumgebung aufgeräumt."

echo ""
echo "=== ENDE ==="
echo "Tipp: Nutze grep -E für erweiterte Regex und grep -P für Perl-Regex (falls verfügbar)"
