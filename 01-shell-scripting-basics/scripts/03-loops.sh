#!/bin/zsh
# ==============================================================================
# 03-loops.sh - Schleifen in der Shell
# ==============================================================================

echo "=== FOR-LOOP: LISTE ==="
for name in Anna Bob Clara Diego; do
    echo "Hallo $name!"
done

echo ""
echo "=== FOR-LOOP: RANGE ==="
echo "Zahlen 1 bis 5:"
for i in {1..5}; do
    echo "  $i"
done

echo ""
echo "Range mit Schritt (0 bis 10, Schritt 2):"
for i in {0..10..2}; do
    echo "  $i"
done

echo ""
echo "=== FOR-LOOP: DATEIEN ==="
echo "Shell-Skripte in diesem Ordner:"
for script in *.sh; do
    echo "  - $script"
done

echo ""
echo "=== FOR-LOOP: COMMAND OUTPUT ==="
echo "Erste 3 Dateien in /tmp:"
for file in $(ls /tmp 2>/dev/null | head -3); do
    echo "  $file"
done

echo ""
echo "=== C-STYLE FOR-LOOP ==="
echo "Countdown:"
for ((i=5; i>=1; i--)); do
    echo "  $i..."
done
echo "  Lift off!"

echo ""
echo "=== WHILE-LOOP ==="
counter=1
while [[ $counter -le 3 ]]; do
    echo "While-Durchlauf: $counter"
    ((counter++))
done

echo ""
echo "=== UNTIL-LOOP ==="
# Läuft BIS Bedingung wahr ist (Gegenteil von while)
counter=1
until [[ $counter -gt 3 ]]; do
    echo "Until-Durchlauf: $counter"
    ((counter++))
done

echo ""
echo "=== WHILE MIT DATEI LESEN ==="
# Erstelle temporäre Testdatei
temp_file=$(mktemp)
echo -e "Zeile 1\nZeile 2\nZeile 3" > "$temp_file"

echo "Datei zeilenweise lesen:"
while IFS= read -r line; do
    echo "  > $line"
done < "$temp_file"

rm "$temp_file"

echo ""
echo "=== BREAK UND CONTINUE ==="
echo "Break bei 5:"
for i in {1..10}; do
    if [[ $i -eq 5 ]]; then
        echo "  Abbruch bei $i!"
        break
    fi
    echo "  $i"
done

echo ""
echo "Continue bei geraden Zahlen (nur ungerade ausgeben):"
for i in {1..10}; do
    if [[ $((i % 2)) -eq 0 ]]; then
        continue  # Überspringe gerade Zahlen
    fi
    echo "  $i"
done

echo ""
echo "=== VERSCHACHTELTE LOOPS ==="
echo "Multiplikationstabelle (1-3):"
for i in {1..3}; do
    for j in {1..3}; do
        result=$((i * j))
        printf "%d x %d = %d\t" $i $j $result
    done
    echo ""  # Neue Zeile nach jeder Reihe
done

echo ""
echo "=== LOOP MIT ARRAY ==="
fruits=("Apfel" "Birne" "Kirsche" "Dattel")
echo "Früchte:"
for fruit in "${fruits[@]}"; do
    echo "  - $fruit"
done

echo ""
echo "Mit Index:"
for i in {1..${#fruits[@]}}; do
    echo "  [$i] = ${fruits[$i]}"
done

echo ""
echo "=== PRAKTISCHES BEISPIEL ==="
echo "Dateien mit Größe auflisten:"
for file in *.sh; do
    if [[ -f $file ]]; then
        size=$(wc -c < "$file")
        echo "  $file: $size Bytes"
    fi
done
