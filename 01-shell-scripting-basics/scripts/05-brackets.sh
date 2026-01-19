#!/bin/zsh
# ==============================================================================
# 05-brackets.sh - Alle Klammerarten in der Shell
# ==============================================================================
# Die verschiedenen Klammern sind oft verwirrend - hier die Übersicht!

echo "=== ÜBERSICHT KLAMMERARTEN ==="
echo "
  (( ))    Arithmetik
  \$(( ))   Arithmetik mit Ergebnis
  [ ]      Test (POSIX, alt)
  [[ ]]    Test (modern, empfohlen)
  ( )      Subshell
  \$( )     Command Substitution
  { }      Brace Expansion / Gruppierung
  \${ }     Parameter Expansion
"

# ==============================================================================
echo "=== (( )) - ARITHMETIK ==="
# ==============================================================================
# Für Berechnungen und Zahlenvergleiche

x=10
y=3

# Berechnung ohne Ergebnis (verändert Variablen)
((x++))
echo "Nach ((x++)): x = $x"

((x += 5))
echo "Nach ((x += 5)): x = $x"

# Vergleiche (gibt Exit-Code zurück: 0=wahr, 1=falsch)
if ((x > 10)); then
    echo "$x ist größer als 10"
fi

# Mehrere Operationen
((a = 5, b = 3, c = a + b))
echo "a=$a, b=$b, c=$c"

# ==============================================================================
echo ""
echo "=== \$(( )) - ARITHMETIK MIT ERGEBNIS ==="
# ==============================================================================
# Gibt das Ergebnis der Berechnung zurück

result=$((10 + 5))
echo "10 + 5 = $result"

echo "Direkt in echo: 7 * 8 = $((7 * 8))"

# Variablen brauchen kein $ innerhalb $(( ))
zahl=42
echo "zahl * 2 = $((zahl * 2))"

# Komplexe Ausdrücke
echo "Modulo: 17 % 5 = $((17 % 5))"
echo "Potenz: 2^8 = $((2 ** 8))"

# ==============================================================================
echo ""
echo "=== [ ] - TEST (POSIX/ALT) ==="
# ==============================================================================
# Alte Syntax, POSIX-kompatibel, mehr Einschränkungen

name="Klaus"

# ACHTUNG: Leerzeichen nach [ und vor ] sind PFLICHT!
if [ "$name" = "Klaus" ]; then
    echo "[ ] Test: Name ist Klaus"
fi

# Datei-Test
if [ -f /etc/hosts ]; then
    echo "[ ] Test: /etc/hosts existiert"
fi

# Problem mit [ ]: Variablen MÜSSEN gequotet werden!
leer=""
# if [ $leer = "" ]; then  # FEHLER wenn $leer leer ist!
if [ "$leer" = "" ]; then  # Korrekt mit Quotes
    echo "[ ] Test: Variable ist leer"
fi

# ==============================================================================
echo ""
echo "=== [[ ]] - TEST (MODERN) ==="
# ==============================================================================
# Moderne Syntax, mehr Features, sicherer

name="Klaus"

# Kein Quoting nötig (aber trotzdem guter Stil)
if [[ $name = "Klaus" ]]; then
    echo "[[ ]] Test: Name ist Klaus"
fi

# Pattern Matching mit =~
email="test@example.com"
if [[ $email =~ ^[a-zA-Z]+@[a-zA-Z]+\.[a-zA-Z]+$ ]]; then
    echo "[[ ]] Regex: '$email' sieht wie eine Email aus"
fi

# Glob Pattern mit ==
datei="script.sh"
if [[ $datei == *.sh ]]; then
    echo "[[ ]] Glob: '$datei' ist ein Shell-Skript"
fi

# Logische Operatoren innerhalb [[ ]]
alter=25
if [[ $alter -ge 18 && $alter -lt 65 ]]; then
    echo "[[ ]] Logik: Alter $alter ist im Arbeitsalter"
fi

# ==============================================================================
echo ""
echo "=== ( ) - SUBSHELL ==="
# ==============================================================================
# Führt Befehle in einer Kind-Shell aus (isoliert)

var="außen"
echo "Vor Subshell: var = $var"

# Änderungen in ( ) beeinflussen die äußere Shell NICHT
(
    var="innen"
    echo "In Subshell: var = $var"
    cd /tmp
    echo "In Subshell: pwd = $(pwd)"
)

echo "Nach Subshell: var = $var"
echo "Nach Subshell: pwd = $(pwd)"  # Unverändert!

# Praktisch für temporäre Änderungen
(cd /tmp && ls -la | head -3)

# ==============================================================================
echo ""
echo "=== \$( ) - COMMAND SUBSTITUTION ==="
# ==============================================================================
# Führt Befehl aus und gibt dessen Output zurück

# Einfache Verwendung
heute=$(date +%Y-%m-%d)
echo "Heute ist: $heute"

# In Strings eingebettet
echo "Aktueller User: $(whoami)"
echo "Anzahl Dateien hier: $(ls | wc -l | tr -d ' ')"

# Verschachtelt
echo "Home von root: $(dirname $(eval echo ~root))"

# Alternative alte Syntax mit Backticks (nicht empfohlen)
# heute=`date +%Y-%m-%d`  # Funktioniert, aber schwer lesbar

# ==============================================================================
echo ""
echo "=== { } - BRACE EXPANSION ==="
# ==============================================================================
# Generiert Sequenzen und Listen

echo "Liste: {A,B,C} wird zu:" {A,B,C}
echo "Range: {1..5} wird zu:" {1..5}
echo "Range mit Schritt: {0..10..2} wird zu:" {0..10..2}
echo "Buchstaben: {a..e} wird zu:" {a..e}

# Praktische Anwendungen
echo ""
echo "Mehrere Dateien erstellen (simuliert):"
echo "  touch datei{1,2,3}.txt  →  datei1.txt datei2.txt datei3.txt"

echo ""
echo "Backup-Name generieren:"
original="config"
echo "  ${original}{,.bak}  →  " ${original}{,.bak}

# Kombinationen
echo ""
echo "Kombiniert: {A,B}{1,2} wird zu:" {A,B}{1,2}

# ==============================================================================
echo ""
echo "=== { } - BEFEHLSGRUPPIERUNG ==="
# ==============================================================================
# Gruppiert Befehle in der AKTUELLEN Shell (keine Subshell)

var="start"

# Gruppierung ohne Subshell
{
    var="geändert"
    echo "In Gruppe: var = $var"
}
echo "Nach Gruppe: var = $var"  # WURDE geändert (anders als Subshell!)

# Nützlich für Redirects
{
    echo "Zeile 1"
    echo "Zeile 2"
    echo "Zeile 3"
} > /dev/null  # Alle drei Zeilen werden umgeleitet

# ==============================================================================
echo ""
echo "=== \${ } - PARAMETER EXPANSION ==="
# ==============================================================================
# Erweiterte Variablen-Manipulation

name="Shell-Scripting"

# Einfache Expansion (Abgrenzung)
echo "Wort: ${name}Test"  # Ohne {} würde $nameTest gesucht

# Länge
echo "Länge von '$name': ${#name}"

# Substring
echo "Zeichen 0-5: ${name:0:5}"
echo "Ab Zeichen 6: ${name:6}"

# Default-Werte
unset missing
echo "Default mit :-: ${missing:-'nicht gesetzt'}"
echo "Variable bleibt: ${missing}"  # Immer noch leer

echo "Default mit :=: ${missing:='jetzt gesetzt'}"
echo "Variable jetzt: ${missing}"  # Wurde gesetzt!

# Suchen und Ersetzen
text="Hallo Welt Welt"
echo "Original: $text"
echo "Erstes ersetzen: ${text/Welt/World}"
echo "Alle ersetzen: ${text//Welt/World}"

# Präfix/Suffix entfernen
datei="/pfad/zu/script.sh"
echo "Dateiname: $datei"
echo "Nur Datei (##*/): ${datei##*/}"      # script.sh
echo "Nur Pfad (%%/*): ${datei%/*}"        # /pfad/zu
echo "Ohne Extension (%.*): ${datei%.*}"   # /pfad/zu/script

# ==============================================================================
echo ""
echo "=== {{ }} - KEINE SHELL-SYNTAX! ==="
# ==============================================================================
# Häufige Verwechslung: {{ }} sieht man oft, ist aber NICHT Teil der Shell!

echo "
{{ }} kommt aus Template-Engines und anderen Tools:

  {{ variable }}      Jinja2 (Python), Ansible
  {{ .Title }}        Hugo, Go Templates
  {{ .Values.name }}  Helm (Kubernetes)
  \${{ secrets.X }}    GitHub Actions

In der Shell passiert bei {{ }} nichts Besonderes:
"

echo "  echo {{a,b}} ergibt:" {{a,b}}
echo "  (Das ist nur Brace Expansion mit leerem erstem Element)"

echo ""
echo "Wenn du {{ }} siehst, bist du vermutlich NICHT in einem Shell-Skript,"
echo "sondern in einer Template-Datei (z.B. .yml, .j2, .html.tmpl)"

# ==============================================================================
echo ""
echo "=== VERGLEICHSTABELLE ==="
echo "
┌─────────────┬────────────────────────────────────────────┐
│ Syntax      │ Verwendung                                 │
├─────────────┼────────────────────────────────────────────┤
│ (( ))       │ Arithmetik, Zahlenvergleiche               │
│ \$(( ))      │ Arithmetik mit Rückgabewert                │
│ [ ]         │ Tests (POSIX, veraltet)                    │
│ [[ ]]       │ Tests (modern, mit Regex/Glob)             │
│ ( )         │ Subshell (isolierte Ausführung)            │
│ \$( )        │ Command Substitution                       │
│ { }         │ Brace Expansion / Gruppierung              │
│ \${ }        │ Parameter Expansion                        │
└─────────────┴────────────────────────────────────────────┘
"

echo "=== ENDE ==="
echo "Tipp: Im Zweifel [[ ]] für Tests und \$(( )) für Mathe!"
