#!/bin/zsh
# ==============================================================================
# 02-conditionals.sh - Bedingte Ausführung
# ==============================================================================

echo "=== IF-STATEMENTS ==="

# Einfaches If
zahl=42
if [[ $zahl -eq 42 ]]; then
    echo "Die Antwort auf alles!"
fi

# If-Else
echo ""
alter=25
if [[ $alter -ge 18 ]]; then
    echo "Volljährig"
else
    echo "Minderjährig"
fi

# If-Elif-Else
echo ""
note=2
if [[ $note -eq 1 ]]; then
    echo "Sehr gut"
elif [[ $note -eq 2 ]]; then
    echo "Gut"
elif [[ $note -le 4 ]]; then
    echo "Bestanden"
else
    echo "Durchgefallen"
fi

echo ""
echo "=== VERGLEICHSOPERATOREN (ZAHLEN) ==="
a=5
b=10
echo "a=$a, b=$b"
[[ $a -eq $b ]] && echo "a == b" || echo "a != b"
[[ $a -lt $b ]] && echo "a < b"
[[ $a -le $b ]] && echo "a <= b"
[[ $a -gt $b ]] && echo "a > b" || echo "a nicht > b"

echo ""
echo "=== VERGLEICHSOPERATOREN (STRINGS) ==="
name1="Anna"
name2="Bob"
echo "name1='$name1', name2='$name2'"

if [[ $name1 = $name2 ]]; then
    echo "Namen sind gleich"
else
    echo "Namen sind unterschiedlich"
fi

# Leerer String prüfen
leer=""
if [[ -z $leer ]]; then
    echo "Variable 'leer' ist leer"
fi

nicht_leer="Inhalt"
if [[ -n $nicht_leer ]]; then
    echo "Variable 'nicht_leer' hat Inhalt"
fi

echo ""
echo "=== DATEI-TESTS ==="
test_datei="/etc/hosts"

if [[ -e $test_datei ]]; then
    echo "$test_datei existiert"
fi

if [[ -f $test_datei ]]; then
    echo "$test_datei ist eine reguläre Datei"
fi

if [[ -r $test_datei ]]; then
    echo "$test_datei ist lesbar"
fi

if [[ -d /tmp ]]; then
    echo "/tmp ist ein Verzeichnis"
fi

echo ""
echo "=== LOGISCHE OPERATOREN ==="
x=15

# UND (&&)
if [[ $x -gt 10 && $x -lt 20 ]]; then
    echo "$x liegt zwischen 10 und 20"
fi

# ODER (||)
if [[ $x -lt 5 || $x -gt 10 ]]; then
    echo "$x ist kleiner 5 ODER größer 10"
fi

# NICHT (!)
if [[ ! -f "/gibts/nicht" ]]; then
    echo "Datei existiert NICHT"
fi

echo ""
echo "=== EINZEILER (SHORT-CIRCUIT) ==="
# && = wenn wahr, dann...
# || = wenn falsch, dann...
[[ -d /tmp ]] && echo "/tmp existiert" || echo "/tmp fehlt"

echo ""
echo "=== CASE-STATEMENT ==="
frucht="Apfel"
case $frucht in
    Apfel)
        echo "Rot oder grün"
        ;;
    Banane)
        echo "Gelb und krumm"
        ;;
    Orange|Mandarine)  # Mehrere Optionen
        echo "Zitrusfrüchte"
        ;;
    *)  # Default
        echo "Unbekannte Frucht"
        ;;
esac

echo ""
echo "=== EXIT CODES ==="
ls /tmp > /dev/null 2>&1
echo "Exit-Code von 'ls /tmp': $?"

ls /gibts-nicht > /dev/null 2>&1
echo "Exit-Code von 'ls /gibts-nicht': $?"

echo ""
echo "Tipp: Exit-Code 0 = Erfolg, alles andere = Fehler"
