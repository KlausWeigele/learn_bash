#!/bin/zsh
# ==============================================================================
# awk-reports.sh - Daten auswerten mit awk
# ==============================================================================

echo "=== AWK: DATENVERARBEITUNG WIE EIN PROFI ==="
echo "awk denkt in Spalten (Felder) und kann rechnen!"
echo ""

# Testdaten erstellen
TESTDIR=$(mktemp -d)
DATAFILE="$TESTDIR/sales.csv"
LOGFILE="$TESTDIR/access.log"

# Verkaufsdaten erstellen
cat > "$DATAFILE" << 'EOF'
Name,Produkt,Menge,Preis
Anna,Laptop,2,999.99
Bob,Maus,5,29.99
Clara,Tastatur,3,79.99
Anna,Monitor,1,349.99
Bob,Laptop,1,999.99
Diana,Maus,10,29.99
Anna,Tastatur,2,79.99
Clara,Laptop,1,999.99
EOF

# Webserver-Log erstellen
cat > "$LOGFILE" << 'EOF'
192.168.1.100 - - [15/Jan/2024:10:00:01] "GET /index.html HTTP/1.1" 200 1234
192.168.1.101 - - [15/Jan/2024:10:00:02] "GET /about.html HTTP/1.1" 200 5678
192.168.1.100 - - [15/Jan/2024:10:00:03] "GET /api/users HTTP/1.1" 200 890
192.168.1.102 - - [15/Jan/2024:10:00:04] "GET /index.html HTTP/1.1" 404 123
192.168.1.100 - - [15/Jan/2024:10:00:05] "POST /api/login HTTP/1.1" 200 456
192.168.1.103 - - [15/Jan/2024:10:00:06] "GET /products HTTP/1.1" 500 789
192.168.1.101 - - [15/Jan/2024:10:00:07] "GET /index.html HTTP/1.1" 200 1234
EOF

echo "=== TESTDATEN ==="
echo ""
echo "sales.csv:"
echo "─────────────────────────────────────────────────────────"
cat "$DATAFILE"
echo "─────────────────────────────────────────────────────────"
echo ""

# ==============================================================================
echo "=== GRUNDLAGEN: SPALTEN (FELDER) ==="
# ==============================================================================

echo "awk teilt jede Zeile in Felder (Spalten): \$1, \$2, \$3, ..."
echo "\$0 ist die ganze Zeile"
echo ""

echo "awk '{print \$1}' - Erste Spalte (Standard: Leerzeichen als Trenner):"
echo "Anna Bob Clara" | awk '{print $1}'
echo ""

echo "awk -F',' '{print \$1}' - Mit Komma als Trenner (CSV):"
awk -F',' '{print $1}' "$DATAFILE"
echo ""

echo "awk -F',' '{print \$1, \$3}' - Spalte 1 und 3:"
awk -F',' '{print $1, $3}' "$DATAFILE" | head -5
echo "..."
echo ""

# ==============================================================================
echo "=== EINGEBAUTE VARIABLEN ==="
# ==============================================================================

echo "NR = Zeilennummer (Number of Records)"
echo "NF = Anzahl Felder (Number of Fields)"
echo ""

echo "awk -F',' '{print NR, \$1}' - Mit Zeilennummer:"
awk -F',' '{print NR, $1}' "$DATAFILE" | head -5
echo "..."
echo ""

echo "awk -F',' '{print \$NF}' - Letztes Feld:"
awk -F',' '{print $NF}' "$DATAFILE" | head -5
echo "..."
echo ""

# ==============================================================================
echo "=== BEDINGUNGEN (PATTERN) ==="
# ==============================================================================

echo "awk 'bedingung {aktion}' - Nur bei Treffer ausführen"
echo ""

echo "awk -F',' '\$1==\"Anna\"' - Zeilen wo Spalte 1 = Anna:"
awk -F',' '$1=="Anna"' "$DATAFILE"
echo ""

echo "awk -F',' '\$3 > 2' - Zeilen wo Menge > 2:"
awk -F',' '$3 > 2' "$DATAFILE"
echo ""

echo "awk -F',' 'NR > 1' - Ab Zeile 2 (Header überspringen):"
awk -F',' 'NR > 1 {print $1, $2}' "$DATAFILE"
echo ""

echo "awk '/Laptop/' - Zeilen mit 'Laptop' (wie grep):"
awk '/Laptop/' "$DATAFILE"
echo ""

# ==============================================================================
echo "=== RECHNEN ==="
# ==============================================================================

echo "awk kann rechnen - direkt mit Feldwerten!"
echo ""

echo "Gesamtpreis berechnen (Menge * Preis):"
awk -F',' 'NR > 1 {printf "%s: %.2f€\n", $1, $3 * $4}' "$DATAFILE"
echo ""

echo "Summe einer Spalte:"
awk -F',' 'NR > 1 {sum += $4} END {printf "Summe Preise: %.2f€\n", sum}' "$DATAFILE"
echo ""

echo "Durchschnitt berechnen:"
awk -F',' 'NR > 1 {sum += $4; count++} END {printf "Durchschnitt: %.2f€\n", sum/count}' "$DATAFILE"
echo ""

# ==============================================================================
echo "=== BEGIN UND END ==="
# ==============================================================================

echo "BEGIN: Vor der ersten Zeile ausführen"
echo "END: Nach der letzten Zeile ausführen"
echo ""

echo "Mit Header und Footer:"
awk -F',' '
BEGIN {print "=== VERKAUFSREPORT ==="}
NR > 1 {print $1, "kaufte", $3, $2}
END {print "=== ENDE ==="}
' "$DATAFILE"
echo ""

# ==============================================================================
echo "=== FORMATIERTE AUSGABE ==="
# ==============================================================================

echo "printf für formatierte Ausgabe (wie in C):"
echo ""

awk -F',' 'NR > 1 {printf "%-10s %-12s %3d x %8.2f€\n", $1, $2, $3, $4}' "$DATAFILE"
echo ""

echo "Formatcodes:"
echo "  %s   = String"
echo "  %d   = Integer"
echo "  %f   = Float"
echo "  %.2f = Float mit 2 Dezimalstellen"
echo "  %-10s = Linksbündig, 10 Zeichen breit"
echo ""

# ==============================================================================
echo "=== AGGREGATIONEN ==="
# ==============================================================================

echo "--- Verkäufe pro Person ---"
awk -F',' '
NR > 1 {
    sales[$1] += $3 * $4
}
END {
    for (name in sales) {
        printf "%s: %.2f€\n", name, sales[name]
    }
}
' "$DATAFILE" | sort -t':' -k2 -rn
echo ""

echo "--- Verkäufe pro Produkt ---"
awk -F',' '
NR > 1 {
    count[$2] += $3
}
END {
    for (prod in count) {
        printf "%s: %d Stück\n", prod, count[prod]
    }
}
' "$DATAFILE"
echo ""

# ==============================================================================
echo "=== LOG-ANALYSE BEISPIEL ==="
# ==============================================================================

echo ""
echo "access.log:"
echo "─────────────────────────────────────────────────────────"
cat "$LOGFILE"
echo "─────────────────────────────────────────────────────────"
echo ""

echo "--- Requests pro IP ---"
awk '{count[$1]++} END {for (ip in count) print ip, count[ip]}' "$LOGFILE" | sort -k2 -rn
echo ""

echo "--- Status-Code Verteilung ---"
awk '{status[$9]++} END {for (s in status) print "HTTP", s":", status[s]}' "$LOGFILE"
echo ""

echo "--- Nur 200er Requests ---"
awk '$9 == 200 {print $7}' "$LOGFILE"
echo ""

echo "--- Traffic pro IP (Bytes) ---"
awk '{traffic[$1] += $10} END {for (ip in traffic) printf "%s: %d bytes\n", ip, traffic[ip]}' "$LOGFILE"
echo ""

# ==============================================================================
echo "=== PRAKTISCHE EINZEILER ==="
# ==============================================================================

echo "--- Spalten tauschen ---"
echo "eins zwei drei" | awk '{print $3, $2, $1}'
echo ""

echo "--- Nur eindeutige Werte ---"
awk -F',' 'NR > 1 && !seen[$1]++ {print $1}' "$DATAFILE"
echo ""

echo "--- Zeilen mit mehr als 3 Feldern ---"
echo -e "a b c\na b c d\na b" | awk 'NF > 3'
echo ""

echo "--- Summe der letzten Spalte ---"
echo -e "1 2 3\n4 5 6\n7 8 9" | awk '{sum += $NF} END {print "Summe:", sum}'
echo ""

# ==============================================================================
echo "=== AWK CHEATSHEET ==="
# ==============================================================================

echo "
┌──────────────────┬─────────────────────────────────────┐
│ Element          │ Bedeutung                           │
├──────────────────┼─────────────────────────────────────┤
│ \$0               │ Ganze Zeile                         │
│ \$1, \$2, ...     │ Feld 1, 2, ...                      │
│ \$NF              │ Letztes Feld                        │
│ NR               │ Zeilennummer                        │
│ NF               │ Anzahl Felder                       │
│ FS               │ Feldtrenner (oder -F)               │
│ OFS              │ Output Feldtrenner                  │
├──────────────────┼─────────────────────────────────────┤
│ /regex/          │ Zeilen die matchen                  │
│ \$1 == \"x\"       │ Feld 1 gleich \"x\"                   │
│ \$1 > 10          │ Feld 1 größer 10                    │
│ NR > 1           │ Ab Zeile 2                          │
├──────────────────┼─────────────────────────────────────┤
│ BEGIN {}         │ Vor erster Zeile                    │
│ END {}           │ Nach letzter Zeile                  │
│ {action}         │ Für jede Zeile                      │
└──────────────────┴─────────────────────────────────────┘
"

# Aufräumen
rm -rf "$TESTDIR"
echo "Testumgebung aufgeräumt."

echo ""
echo "=== ENDE ==="
echo "Tipp: awk ist perfekt für CSV-Dateien und Log-Analyse!"
