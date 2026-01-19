#!/bin/zsh
# ==============================================================================
# 04-functions.sh - Funktionen in der Shell
# ==============================================================================

echo "=== EINFACHE FUNKTION ==="

# Definition
say_hello() {
    echo "Hallo, Welt!"
}

# Aufruf
say_hello

echo ""
echo "=== FUNKTION MIT PARAMETER ==="

greet() {
    local name=$1  # Erster Parameter, lokal zur Funktion
    echo "Hallo, $name!"
}

greet "Klaus"
greet "Anna"

echo ""
echo "=== MEHRERE PARAMETER ==="

introduce() {
    local name=$1
    local age=$2
    local city=$3
    echo "$name ist $age Jahre alt und wohnt in $city."
}

introduce "Bob" 30 "Berlin"
introduce "Clara" 25 "München"

echo ""
echo "=== ALLE PARAMETER ==="

list_args() {
    echo "Anzahl Parameter: $#"
    echo "Alle Parameter: $@"

    local count=1
    for arg in "$@"; do
        echo "  Param $count: $arg"
        ((count++))
    done
}

list_args Apfel Birne Kirsche

echo ""
echo "=== RÜCKGABEWERTE ==="

# Methode 1: echo (für Strings/Werte)
get_date() {
    echo $(date +%Y-%m-%d)
}
today=$(get_date)
echo "Heute ist: $today"

# Methode 2: return (nur für Exit-Codes 0-255)
is_even() {
    local num=$1
    if [[ $((num % 2)) -eq 0 ]]; then
        return 0  # Erfolg = gerade
    else
        return 1  # Fehler = ungerade
    fi
}

echo ""
for n in 4 7 10; do
    if is_even $n; then
        echo "$n ist gerade"
    else
        echo "$n ist ungerade"
    fi
done

echo ""
echo "=== LOKALE VS GLOBALE VARIABLEN ==="

global_var="Ich bin global"

test_scope() {
    local local_var="Ich bin lokal"
    global_var="Global wurde geändert!"  # Ändert die globale Variable

    echo "In Funktion:"
    echo "  global_var = $global_var"
    echo "  local_var = $local_var"
}

echo "Vor Funktionsaufruf: global_var = $global_var"
test_scope
echo "Nach Funktionsaufruf: global_var = $global_var"
echo "local_var außerhalb: ${local_var:-'(nicht definiert)'}"

echo ""
echo "=== REKURSIVE FUNKTION ==="

factorial() {
    local n=$1
    if [[ $n -le 1 ]]; then
        echo 1
    else
        local prev=$(factorial $((n - 1)))
        echo $((n * prev))
    fi
}

for i in 1 5 10; do
    result=$(factorial $i)
    echo "$i! = $result"
done

echo ""
echo "=== PRAKTISCHES BEISPIEL: LOGGING ==="

# Log-Level Konstanten (simuliert)
LOG_INFO="INFO"
LOG_WARN="WARN"
LOG_ERROR="ERROR"

log() {
    local level=$1
    local message=$2
    local timestamp=$(date "+%H:%M:%S")
    echo "[$timestamp] [$level] $message"
}

log $LOG_INFO "Skript gestartet"
log $LOG_WARN "Dies ist eine Warnung"
log $LOG_ERROR "Etwas ist schiefgelaufen"

echo ""
echo "=== FUNKTION MIT VALIDIERUNG ==="

divide() {
    local a=$1
    local b=$2

    # Validierung
    if [[ -z $a || -z $b ]]; then
        echo "Fehler: Zwei Zahlen erforderlich"
        return 1
    fi

    if [[ $b -eq 0 ]]; then
        echo "Fehler: Division durch 0"
        return 1
    fi

    echo $((a / b))
    return 0
}

echo "10 / 2 = $(divide 10 2)"
echo "10 / 0 = $(divide 10 0)"

echo ""
echo "=== FUNKTION ALS FILTER ==="

# Funktion die als Filter in einer Pipeline funktioniert
uppercase() {
    while IFS= read -r line; do
        echo "${line:u}"  # Zsh-Syntax für uppercase
    done
}

echo "Filter-Beispiel:"
echo -e "hallo\nwelt\ntest" | uppercase

echo ""
echo "=== ENDE ==="
echo "Tipp: Funktionen sollten eine Aufgabe gut erledigen (Unix-Philosophie)"
