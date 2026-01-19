# Text-Verarbeitung Cheatsheet

## Pipes und Umleitung

```bash
# Pipe: stdout → stdin
cmd1 | cmd2              # Output von cmd1 als Input für cmd2

# Umleitung
cmd > datei              # stdout in Datei (überschreiben)
cmd >> datei             # stdout in Datei (anhängen)
cmd < datei              # stdin aus Datei
cmd 2> datei             # stderr in Datei
cmd &> datei             # stdout UND stderr in Datei
cmd 2>&1                 # stderr zu stdout umleiten

# Kombinationen
cmd1 | cmd2 | cmd3       # Mehrere Pipes
cmd > out.txt 2> err.txt # stdout und stderr getrennt
```

## grep - Suchen

```bash
# Grundsyntax
grep [optionen] "muster" datei(en)

# Einfache Suche
grep "error" log.txt           # Zeilen mit "error"
grep "error" *.log             # In mehreren Dateien
grep -r "TODO" .               # Rekursiv in Ordner

# Wichtige Optionen
grep -i "error"                # Case-insensitive
grep -v "debug"                # Invertiert (NICHT matching)
grep -n "error"                # Mit Zeilennummern
grep -c "error"                # Nur Anzahl
grep -l "error" *.log          # Nur Dateinamen
grep -L "error" *.log          # Dateien OHNE Match
grep -w "error"                # Nur ganze Wörter
grep -x "exact line"           # Ganze Zeile muss matchen

# Kontext anzeigen
grep -A 3 "error"              # 3 Zeilen NACH Match
grep -B 3 "error"              # 3 Zeilen VOR Match
grep -C 3 "error"              # 3 Zeilen VOR und NACH

# Regex
grep -E "error|warning"        # Extended Regex (ODER)
grep -E "^Start"               # Zeilenanfang
grep -E "End$"                 # Zeilenende
grep -E "[0-9]{3}"             # Drei Ziffern
```

## Reguläre Ausdrücke (Regex)

### Basis-Metazeichen
```
.        Beliebiges Zeichen (außer Newline)
^        Zeilenanfang
$        Zeilenende
\        Escape-Zeichen
```

### Quantifizierer
```
*        Null oder mehr
+        Eins oder mehr (Extended)
?        Null oder eins (Extended)
{n}      Exakt n mal (Extended)
{n,}     Mindestens n mal (Extended)
{n,m}    Zwischen n und m mal (Extended)
```

### Zeichenklassen
```
[abc]    a, b oder c
[^abc]   NICHT a, b, c
[a-z]    Kleinbuchstaben
[A-Z]    Großbuchstaben
[0-9]    Ziffern
[a-zA-Z] Alle Buchstaben
```

### Spezielle Klassen (Extended/PCRE)
```
\d       Ziffer [0-9]
\D       Keine Ziffer
\w       Wortzeichen [a-zA-Z0-9_]
\W       Kein Wortzeichen
\s       Whitespace
\S       Kein Whitespace
\b       Wortgrenze
```

### Gruppen und Alternativen (Extended)
```
(abc)    Gruppe
a|b      a ODER b
```

### Praktische Regex-Beispiele
```bash
# IP-Adresse (vereinfacht)
grep -E "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"

# Email (vereinfacht)
grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"

# Datum (YYYY-MM-DD)
grep -E "[0-9]{4}-[0-9]{2}-[0-9]{2}"

# URL
grep -E "https?://[a-zA-Z0-9./?=_-]+"
```

## sed - Stream Editor

```bash
# Grundsyntax
sed [optionen] 'befehl' datei

# Ersetzen (s = substitute)
sed 's/alt/neu/' datei         # Erstes Vorkommen pro Zeile
sed 's/alt/neu/g' datei        # Alle Vorkommen (global)
sed 's/alt/neu/gi' datei       # Global + case-insensitive
sed 's/alt/neu/2' datei        # Nur 2. Vorkommen

# In-Place bearbeiten
sed -i '' 's/alt/neu/g' datei  # macOS: -i ''
sed -i 's/alt/neu/g' datei     # Linux: -i ohne ''

# Andere Delimiter
sed 's|/pfad/alt|/pfad/neu|g'  # | statt / als Delimiter
sed 's#alt#neu#g'              # # als Delimiter

# Zeilen löschen
sed '5d' datei                 # Zeile 5 löschen
sed '5,10d' datei              # Zeilen 5-10 löschen
sed '/muster/d' datei          # Zeilen mit Muster löschen
sed '/^$/d' datei              # Leere Zeilen löschen
sed '/^#/d' datei              # Kommentare löschen

# Zeilen ausgeben
sed -n '5p' datei              # Nur Zeile 5
sed -n '5,10p' datei           # Zeilen 5-10
sed -n '/muster/p' datei       # Zeilen mit Muster

# Einfügen
sed '3i\Neue Zeile' datei      # VOR Zeile 3 einfügen
sed '3a\Neue Zeile' datei      # NACH Zeile 3 einfügen
sed '1i\Kopfzeile' datei       # Am Anfang einfügen
sed '$a\Fußzeile' datei        # Am Ende einfügen

# Mehrere Befehle
sed -e 's/a/A/g' -e 's/b/B/g'  # Mit -e
sed 's/a/A/g; s/b/B/g'         # Mit Semikolon

# Backreferences (Gruppen wiederverwenden)
sed 's/\(.*\)/[\1]/' datei     # Zeile in [] setzen
sed -E 's/([0-9]+)/[\1]/g'     # Extended: Zahlen in []
```

## awk - Daten verarbeiten

```bash
# Grundsyntax
awk 'muster {aktion}' datei
awk '{aktion}' datei           # Auf alle Zeilen

# Spalten ausgeben (Felder)
awk '{print $1}' datei         # Erste Spalte
awk '{print $1, $3}' datei     # Spalte 1 und 3
awk '{print $NF}' datei        # Letzte Spalte
awk '{print $(NF-1)}' datei    # Vorletzte Spalte
awk '{print $0}' datei         # Ganze Zeile

# Eingebaute Variablen
$0       # Ganze Zeile
$1..$n   # Feld 1 bis n
NF       # Anzahl Felder (Number of Fields)
NR       # Zeilennummer (Number of Records)
FS       # Feldtrenner (Field Separator)
OFS      # Output Field Separator
RS       # Record Separator (Zeilentrenner)

# Feldtrenner setzen
awk -F':' '{print $1}' /etc/passwd    # : als Trenner
awk -F',' '{print $2}' data.csv       # CSV
awk -F'\t' '{print $1}' data.tsv      # Tab-separiert

# Muster/Bedingungen
awk '/error/' datei                    # Zeilen mit "error"
awk '!/comment/' datei                 # OHNE "comment"
awk '$3 > 100' datei                   # Spalte 3 > 100
awk '$1 == "admin"' datei              # Spalte 1 ist "admin"
awk 'NR > 1' datei                     # Ab Zeile 2 (Skip Header)
awk 'NF > 0' datei                     # Nicht-leere Zeilen

# Rechnen
awk '{sum += $1} END {print sum}'      # Summe von Spalte 1
awk '{print $1 * $2}' datei            # Multiplizieren
awk '{print $1 / $2}' datei            # Dividieren
awk 'BEGIN {print 3.14 * 2}'           # Berechnung ohne Datei

# Formatierte Ausgabe
awk '{printf "%s: %d\n", $1, $2}'      # printf wie in C
awk '{printf "%-10s %5d\n", $1, $2}'   # Ausgerichtet

# BEGIN und END
awk 'BEGIN {print "Start"} {print} END {print "Ende"}' datei

# Mehrere Befehle
awk '{count++; sum+=$1} END {print sum/count}' datei  # Durchschnitt
```

## Weitere nützliche Tools

### cut - Spalten ausschneiden
```bash
cut -d':' -f1 /etc/passwd      # Feld 1, Delimiter :
cut -c1-10 datei               # Zeichen 1-10
cut -f2,4 datei.tsv            # Felder 2 und 4 (Tab-separiert)
```

### tr - Zeichen ersetzen
```bash
tr 'a-z' 'A-Z'                 # Klein → Groß
tr -d '\r'                     # Windows-Zeilenenden entfernen
tr -s ' '                      # Mehrere Leerzeichen → eins
tr ':' '\n'                    # : durch Newline ersetzen
```

### sort - Sortieren
```bash
sort datei                     # Alphabetisch
sort -n datei                  # Numerisch
sort -r datei                  # Umgekehrt
sort -k2 datei                 # Nach Spalte 2
sort -t',' -k3 -n datei        # CSV, Spalte 3, numerisch
sort -u datei                  # Unique (Duplikate entfernen)
```

### uniq - Duplikate
```bash
uniq datei                     # Aufeinanderfolgende Duplikate entfernen
sort datei | uniq              # Alle Duplikate entfernen
uniq -c datei                  # Vorkommen zählen
uniq -d datei                  # Nur Duplikate zeigen
```

### wc - Zählen
```bash
wc -l datei                    # Zeilen
wc -w datei                    # Wörter
wc -c datei                    # Bytes
wc -m datei                    # Zeichen
```

### head/tail - Anfang/Ende
```bash
head -10 datei                 # Erste 10 Zeilen
tail -10 datei                 # Letzte 10 Zeilen
tail -f log.txt                # Live-Monitoring (follow)
head -n -5 datei               # Alles außer letzte 5
tail -n +2 datei               # Ab Zeile 2 (Skip Header)
```

## Kombinationsbeispiele

```bash
# Top 10 Wörter
cat text.txt | tr -s ' ' '\n' | sort | uniq -c | sort -rn | head -10

# Fehler in Logs zählen
grep -c "ERROR" *.log

# CSV: Spalte 2 extrahieren, sortieren, Duplikate zählen
cut -d',' -f2 data.csv | sort | uniq -c | sort -rn

# Apache-Log: Top IPs
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10

# Dateien > 1MB finden und formatiert ausgeben
find . -size +1M -exec ls -lh {} \; | awk '{print $5, $9}'

# JSON-artig: Key-Value extrahieren
grep -E '"name":' data.json | sed 's/.*"name": *"\([^"]*\)".*/\1/'
```
