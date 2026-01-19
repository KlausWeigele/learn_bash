# Shell-Scripting Cheatsheet

## Shebang
```bash
#!/bin/zsh     # Für Zsh (macOS Standard)
#!/bin/bash    # Für Bash
```

## Variablen

```bash
# Setzen (KEIN Leerzeichen um =)
name="Klaus"
zahl=42
pfad="/Users/klaus"

# Lesen
echo $name
echo ${name}        # Sicherer in Strings
echo "${name}test"  # Ergibt: Klaustest

# Spezielle Variablen
$0    # Skript-Name
$1    # Erstes Argument
$#    # Anzahl Argumente
$@    # Alle Argumente
$?    # Exit-Code des letzten Befehls
$$    # Prozess-ID des Skripts
```

## Quoting

```bash
name="Klaus"
echo "$name"   # Klaus       (Variablen werden ersetzt)
echo '$name'   # $name       (Literal, keine Ersetzung)
echo `date`    # Datum       (Command Substitution, alt)
echo $(date)   # Datum       (Command Substitution, modern)
```

## Conditionals

```bash
# If-Statement
if [[ $x -eq 5 ]]; then
    echo "x ist 5"
elif [[ $x -gt 5 ]]; then
    echo "x ist größer als 5"
else
    echo "x ist kleiner als 5"
fi

# Einzeiler
[[ $x -eq 5 ]] && echo "ja" || echo "nein"
```

### Vergleichsoperatoren

| Zahlen | Bedeutung | Strings | Bedeutung |
|--------|-----------|---------|-----------|
| `-eq`  | gleich    | `=`     | gleich    |
| `-ne`  | ungleich  | `!=`    | ungleich  |
| `-lt`  | kleiner   | `<`     | kleiner (alphabetisch) |
| `-gt`  | größer    | `>`     | größer    |
| `-le`  | kleiner/gleich | | |
| `-ge`  | größer/gleich  | | |

### Datei-Tests

```bash
[[ -f $datei ]]   # Ist eine Datei
[[ -d $pfad ]]    # Ist ein Verzeichnis
[[ -e $pfad ]]    # Existiert
[[ -r $datei ]]   # Lesbar
[[ -w $datei ]]   # Schreibbar
[[ -x $datei ]]   # Ausführbar
[[ -s $datei ]]   # Nicht leer
```

## Loops

```bash
# For-Loop mit Liste
for name in Anna Bob Clara; do
    echo "Hallo $name"
done

# For-Loop mit Range
for i in {1..10}; do
    echo $i
done

# For-Loop mit Schritt
for i in {0..100..10}; do  # 0, 10, 20, ...
    echo $i
done

# For-Loop über Dateien
for file in *.txt; do
    echo "Datei: $file"
done

# While-Loop
counter=0
while [[ $counter -lt 5 ]]; do
    echo $counter
    ((counter++))
done

# Until-Loop (bis Bedingung wahr)
until [[ $counter -ge 10 ]]; do
    echo $counter
    ((counter++))
done
```

## Functions

```bash
# Definition
greet() {
    local name=$1    # Lokale Variable
    echo "Hallo $name"
}

# Aufruf
greet "Klaus"

# Mit Rückgabewert
add() {
    local result=$(($1 + $2))
    echo $result
}
summe=$(add 5 3)  # summe = 8
```

## Arrays

```bash
# Definieren
fruits=("Apfel" "Birne" "Kirsche")

# Zugriff
echo ${fruits[0]}     # Apfel
echo ${fruits[@]}     # Alle Elemente
echo ${#fruits[@]}    # Anzahl: 3

# Hinzufügen
fruits+=("Orange")

# Iterieren
for fruit in "${fruits[@]}"; do
    echo $fruit
done
```

## Nützliche Konstrukte

```bash
# Command Substitution
heute=$(date +%Y-%m-%d)
dateien=$(ls *.txt)

# Arithmetik
result=$((5 + 3))
((x++))
((x += 10))

# Default-Werte
name=${1:-"Unbekannt"}  # Wenn $1 leer, nutze "Unbekannt"

# String-Operationen
text="Hallo Welt"
echo ${#text}           # Länge: 10
echo ${text:0:5}        # Substring: Hallo
echo ${text/Welt/Bash}  # Ersetzen: Hallo Bash
```

## Exit Codes

```bash
# Erfolgreich beenden
exit 0

# Mit Fehler beenden
exit 1

# Letzten Exit-Code prüfen
if [[ $? -ne 0 ]]; then
    echo "Fehler!"
fi
```

## Skript ausführbar machen

```bash
chmod +x script.sh
./script.sh
```
