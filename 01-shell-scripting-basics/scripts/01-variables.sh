#!/bin/zsh
# ==============================================================================
# 01-variables.sh - Variablen in der Shell verstehen
# ==============================================================================

echo "=== VARIABLEN BASICS ==="

# Einfache Zuweisung (KEIN Leerzeichen um das =)
name="Klaus"
alter=42
echo "Name: $name, Alter: $alter"

# Unterschied: Quotes
echo ""
echo "=== QUOTING ==="
wort="Welt"
echo "Doppelte Quotes: Hallo $wort"    # Variable wird ersetzt
echo 'Einfache Quotes: Hallo $wort'    # Literal, keine Ersetzung

# Command Substitution
echo ""
echo "=== COMMAND SUBSTITUTION ==="
heute=$(date +%Y-%m-%d)
echo "Heute ist: $heute"

anzahl_dateien=$(ls | wc -l)
echo "Dateien im aktuellen Ordner: $anzahl_dateien"

# Spezielle Variablen
echo ""
echo "=== SPEZIELLE VARIABLEN ==="
echo "Skript-Name: $0"
echo "Erstes Argument: ${1:-'(keins übergeben)'}"
echo "Anzahl Argumente: $#"
echo "Alle Argumente: $@"
echo "Prozess-ID: $$"

# Arithmetik
echo ""
echo "=== ARITHMETIK ==="
x=10
y=3
echo "$x + $y = $((x + y))"
echo "$x - $y = $((x - y))"
echo "$x * $y = $((x * y))"
echo "$x / $y = $((x / y))"     # Ganzzahl-Division!
echo "$x % $y = $((x % y))"     # Modulo

# Inkrement/Dekrement
((x++))
echo "Nach x++: $x"

# String-Operationen
echo ""
echo "=== STRING-OPERATIONEN ==="
text="Shell Scripting lernen"
echo "Originaltext: $text"
echo "Länge: ${#text}"
echo "Erste 5 Zeichen: ${text:0:5}"
echo "Ab Zeichen 6: ${text:6}"
echo "Ersetzen: ${text/lernen/macht Spaß}"

# Default-Werte
echo ""
echo "=== DEFAULT-WERTE ==="
unset unbekannt
echo "Mit Default: ${unbekannt:-'Fallback-Wert'}"
echo "Variable selbst: ${unbekannt}"  # Immer noch leer!

# Mit := wird der Default auch gesetzt
echo "Mit Zuweisung: ${unbekannt:='Jetzt gesetzt'}"
echo "Variable jetzt: ${unbekannt}"

echo ""
echo "=== ENDE ==="
echo "Tipp: Führe das Skript mit Argumenten aus:"
echo "  ./01-variables.sh Hallo Welt 123"
