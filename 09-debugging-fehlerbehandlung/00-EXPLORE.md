# Debugging & Fehlerbehandlung: Wenn Skripte rebellieren

## Fragen zum Nachdenken

Bevor du Fehler jagst, nimm dir einen Moment:

**Warum Skripte scheitern**
- Dein Skript funktioniert auf deinem Mac. Auf dem Server nicht. Warum?
- Ein Leerzeichen kann ein Skript zerstören. Wie kann so etwas Kleines so große Wirkung haben?

**Der unsichtbare Erfolg**
- Woher weiß ein Skript, ob der vorherige Befehl geklappt hat?
- `rm datei.txt` gibt keine Ausgabe. Heißt das, es hat funktioniert?

**Defensive Programmierung**
- Was passiert, wenn eine Variable leer ist und du `rm -rf $ORDNER/*` ausführst?
- Sollte ein Skript weitermachen, wenn ein Befehl fehlschlägt?

---

## Aha-Momente

### Jeder Befehl hat einen Exit-Code

```bash
ls /existiert
echo $?    # 0 = Erfolg

ls /gibts-nicht
echo $?    # 1 = Fehler (oder eine andere Zahl > 0)
```

`0` = alles gut. Alles andere = etwas ist schiefgegangen.

### set -e ist dein Sicherheitsnetz

```bash
#!/bin/zsh
set -e    # Bei JEDEM Fehler sofort abbrechen

echo "Schritt 1"
falsch_geschrieben_befehl    # Skript stoppt hier
echo "Schritt 2"              # Wird nie ausgeführt
```

Ohne `set -e` würde das Skript fröhlich weitermachen!

### Debugging mit set -x

```bash
#!/bin/zsh
set -x    # Jeden Befehl vor Ausführung ausgeben

name="Klaus"
echo "Hallo $name"
```

Ausgabe:
```
+name=Klaus
+echo 'Hallo Klaus'
Hallo Klaus
```

Du siehst genau, was die Shell macht.

### ShellCheck ist dein Freund

```bash
# Installieren
brew install shellcheck

# Skript prüfen
shellcheck mein-skript.sh
```

ShellCheck findet Fehler, die du nie bemerkt hättest.

---

## Gedankenexperimente

### Experiment 1: Exit-Codes verstehen

```bash
# Erstelle ein Test-Skript
cat > test-exit.sh << 'EOF'
#!/bin/zsh
ls /tmp
echo "Exit-Code: $?"
ls /gibts-nicht
echo "Exit-Code: $?"
EOF

chmod +x test-exit.sh
./test-exit.sh
```

Was sind die Exit-Codes?

### Experiment 2: set -e in Aktion

```bash
cat > test-set-e.sh << 'EOF'
#!/bin/zsh
echo "Mit set -e:"
set -e
echo "Vor dem Fehler"
ls /gibts-nicht
echo "Nach dem Fehler"
EOF

chmod +x test-set-e.sh
./test-set-e.sh
echo "Skript Exit-Code: $?"
```

Kommentiere `set -e` aus und vergleiche.

### Experiment 3: Die gefährliche leere Variable

```bash
# ACHTUNG: Nur gedanklich durchspielen!
ORDNER=""
echo "rm -rf $ORDNER/*"    # Was würde hier passieren?

# Sichere Variante
ORDNER=""
echo "rm -rf ${ORDNER:?Variable ist leer}/*"
```

Was macht das `:?`?

### Experiment 4: trap - Aufräumen garantiert

```bash
cat > test-trap.sh << 'EOF'
#!/bin/zsh
temp_file=$(mktemp)
echo "Temp-Datei: $temp_file"

trap "rm -f $temp_file; echo 'Aufgeräumt!'" EXIT

echo "Arbeite..."
sleep 2
echo "Fertig!"
EOF

chmod +x test-trap.sh
./test-trap.sh
# Auch bei Ctrl+C wird aufgeräumt!
```

---

## Selbst ausprobieren

**Challenge 1:** Robustes Skript-Template
```bash
#!/bin/zsh
set -euo pipefail    # Stricter Modus

# e = Exit bei Fehler
# u = Fehler bei ungesetzten Variablen
# o pipefail = Pipe-Fehler nicht ignorieren

echo "Dieses Skript ist robust!"
```

**Challenge 2:** Fehler abfangen und loggen
```bash
#!/bin/zsh
log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $1" >&2
}

if ! ls /gibts-nicht 2>/dev/null; then
    log_error "Verzeichnis nicht gefunden"
    exit 1
fi
```

**Challenge 3:** ShellCheck-Fehler fixen
```bash
# Erstelle ein "schlechtes" Skript
cat > bad-script.sh << 'EOF'
#!/bin/bash
for f in $(ls *.txt); do
    cat $f
done
name=Klaus
echo 'Hallo $name'
EOF

# Prüfe mit ShellCheck
shellcheck bad-script.sh

# Fixe alle Warnungen!
```

**Challenge 4:** Debug-Modus einbauen
```bash
#!/bin/zsh
DEBUG=${DEBUG:-0}

debug() {
    [[ $DEBUG -eq 1 ]] && echo "[DEBUG] $*" >&2
}

debug "Skript startet"
echo "Normale Ausgabe"
debug "Variable x = $x"
```

Teste mit: `DEBUG=1 ./script.sh`

---

## Weiter geht's

Wenn du diese Techniken beherrschst:
- [CHEATSHEET.md](CHEATSHEET.md) - Alle Debugging-Optionen
- [scripts/](scripts/) - Robuste Skript-Beispiele
