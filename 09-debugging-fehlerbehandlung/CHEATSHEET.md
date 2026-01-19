# Debugging & Fehlerbehandlung Cheatsheet

## Exit-Codes

```bash
# Letzten Exit-Code abfragen
echo $?

# Konvention
0     # Erfolg
1     # Allgemeiner Fehler
2     # Falsche Verwendung (z.B. falsche Argumente)
126   # Befehl nicht ausführbar
127   # Befehl nicht gefunden
128+n # Durch Signal n beendet (z.B. 130 = Ctrl+C)

# Eigenen Exit-Code setzen
exit 0    # Erfolg
exit 1    # Fehler

# Exit-Code in Bedingung nutzen
if befehl; then
    echo "Erfolg"
else
    echo "Fehler"
fi

# Kurzformen
befehl && echo "OK" || echo "FEHLER"
```

## set-Optionen für robuste Skripte

```bash
#!/bin/zsh

# Einzeln setzen
set -e    # Bei Fehler abbrechen
set -u    # Ungesetzte Variablen sind Fehler
set -x    # Debug: Befehle anzeigen
set -o pipefail  # Pipe-Fehler weitergeben

# Kombiniert (empfohlen für Produktions-Skripte)
set -euo pipefail

# Optionen deaktivieren
set +e    # -e wieder ausschalten
set +x    # Debug ausschalten
```

### Was die Optionen bewirken

| Option | Wirkung |
|--------|---------|
| `-e` (errexit) | Skript stoppt bei erstem Fehler |
| `-u` (nounset) | Fehler bei ungesetzten Variablen |
| `-x` (xtrace) | Jeden Befehl vor Ausführung ausgeben |
| `-o pipefail` | Pipe gibt Fehlercode des fehlgeschlagenen Befehls zurück |
| `-v` (verbose) | Zeilen vor Verarbeitung ausgeben |

## Debugging-Techniken

### Trace-Modus

```bash
# Ganzes Skript im Debug-Modus
bash -x script.sh
zsh -x script.sh

# Nur einen Teil debuggen
set -x
# ... debug diesen Teil ...
set +x

# Noch detaillierter
set -xv
```

### Debug-Funktion

```bash
DEBUG=${DEBUG:-0}

debug() {
    [[ $DEBUG -eq 1 ]] && echo "[DEBUG] $*" >&2
}

# Nutzung
debug "Variable x = $x"

# Aktivieren
DEBUG=1 ./script.sh
```

### Logging

```bash
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S')] $*" >&2
}

log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# In Datei loggen
exec > >(tee -a logfile.log)
exec 2>&1
```

## Fehlerbehandlung

### if-Prüfung

```bash
if ! befehl; then
    echo "Fehler bei befehl" >&2
    exit 1
fi

# Oder
befehl || { echo "Fehler!" >&2; exit 1; }
```

### Fehler ignorieren

```bash
# Bestimmten Fehler ignorieren
befehl || true

# Oder mit set -e
set -e
befehl || true    # Skript läuft weiter
andere_befehl     # Hier würde bei Fehler gestoppt
```

### trap - Aufräumen bei Exit/Signal

```bash
#!/bin/zsh

# Bei jedem Exit aufräumen
cleanup() {
    echo "Räume auf..."
    rm -f "$temp_file"
}
trap cleanup EXIT

# Bei Ctrl+C
trap "echo 'Abgebrochen!'; exit 1" INT

# Bei mehreren Signalen
trap cleanup EXIT INT TERM

# Trap entfernen
trap - EXIT
```

### Typische trap-Muster

```bash
# Temp-Dateien aufräumen
temp_file=$(mktemp)
trap "rm -f $temp_file" EXIT

# Lock-Datei entfernen
trap "rm -f /tmp/script.lock" EXIT

# Ursprüngliches Verzeichnis wiederherstellen
original_dir=$(pwd)
trap "cd $original_dir" EXIT
```

## Sichere Variablen-Nutzung

### Parameter Expansion

```bash
# Default-Wert wenn leer/ungesetzt
${var:-default}       # Nutzt default, setzt var nicht
${var:=default}       # Nutzt default, SETZT var

# Fehler wenn leer/ungesetzt
${var:?Fehlermeldung} # Bricht ab mit Meldung

# Beispiele
name=${1:-"Anonymous"}
config=${CONFIG_FILE:?CONFIG_FILE muss gesetzt sein}

# Gefährlich
rm -rf $ORDNER/*                  # Wenn ORDNER leer: rm -rf /*

# Sicher
rm -rf "${ORDNER:?}/"*            # Fehler wenn leer
[[ -n "$ORDNER" ]] && rm -rf "$ORDNER"/*
```

### Variablen immer quoten

```bash
# Falsch
if [ $name = "Klaus" ]; then    # Fehler wenn name leer

# Richtig
if [ "$name" = "Klaus" ]; then

# Noch besser (Zsh/Bash)
if [[ "$name" = "Klaus" ]]; then
```

## ShellCheck

```bash
# Installieren
brew install shellcheck

# Skript prüfen
shellcheck script.sh

# Nur bestimmte Checks
shellcheck -e SC2034 script.sh    # SC2034 ignorieren

# Schweregrad filtern
shellcheck --severity=warning script.sh

# Als Teil von CI
shellcheck -f gcc script.sh       # Compiler-Format
shellcheck -f json script.sh      # JSON-Format
```

### Häufige ShellCheck-Warnungen

```bash
# SC2086: Quote your variables
echo $var       # → echo "$var"

# SC2046: Quote command substitution
files=$(ls)     # → files="$(ls)"

# SC2006: Use $() instead of backticks
date=`date`     # → date=$(date)

# SC2035: Use ./* or -- to prevent glob expansion
rm *.txt        # → rm ./*.txt

# Inline ignorieren
# shellcheck disable=SC2034
unused_var="OK, ich weiß es"
```

## Syntax-Prüfung

```bash
# Nur Syntax prüfen, nicht ausführen
bash -n script.sh
zsh -n script.sh

# Mit set -n im Skript
set -n    # noexec - Befehle nur parsen
```

## Fehlerbehandlung in Pipes

```bash
# Problem: Nur letzter Exit-Code zählt
falsch | grep pattern
echo $?    # Exit-Code von grep, nicht von falsch

# Lösung: pipefail
set -o pipefail
falsch | grep pattern
echo $?    # Jetzt Exit-Code von falsch

# Einzelne Pipe-Exit-Codes (Bash)
falsch | grep pattern
echo "${PIPESTATUS[@]}"    # Array aller Exit-Codes
```

## Robustes Skript-Template

```bash
#!/bin/zsh
set -euo pipefail

# Konstanten
readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# Logging
log()       { echo "[INFO]  $*"; }
log_error() { echo "[ERROR] $*" >&2; }
die()       { log_error "$*"; exit 1; }

# Cleanup
cleanup() {
    # Aufräumen hier
    :
}
trap cleanup EXIT

# Argumente prüfen
[[ $# -lt 1 ]] && die "Verwendung: $SCRIPT_NAME <argument>"

# Hauptlogik
main() {
    log "Start"
    # ...
    log "Ende"
}

main "$@"
```

## Interaktives Debugging

```bash
# Pause im Skript
read -p "Drücke Enter zum Fortfahren..."

# Variable anzeigen und pausieren
echo "DEBUG: x = $x"; read

# Breakpoint
trap 'read -p "Zeile $LINENO: "' DEBUG
```
