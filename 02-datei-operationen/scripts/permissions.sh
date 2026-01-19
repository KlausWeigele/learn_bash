#!/bin/zsh
# ==============================================================================
# permissions.sh - Dateiberechtigungen verstehen
# ==============================================================================

echo "=== UNIX DATEIBERECHTIGUNGEN ==="
echo "Wer darf was mit welcher Datei?"
echo ""

# Testverzeichnis erstellen
TESTDIR=$(mktemp -d)
cd "$TESTDIR"

# ==============================================================================
echo "=== DIE DREI BERECHTIGUNGSGRUPPEN ==="
# ==============================================================================

echo "
Jede Datei hat drei Berechtigungsgruppen:

  1. User (u)   - Der Besitzer der Datei
  2. Group (g)  - Die Gruppe der Datei
  3. Others (o) - Alle anderen

Und drei mögliche Berechtigungen:

  r (read)    - Lesen erlaubt
  w (write)   - Schreiben erlaubt
  x (execute) - Ausführen erlaubt
"

# ==============================================================================
echo "=== WIE LIEST MAN BERECHTIGUNGEN? ==="
# ==============================================================================

touch beispiel.txt
chmod 754 beispiel.txt
echo "Beispieldatei erstellt mit chmod 754:"
ls -l beispiel.txt
echo ""

echo "
Aufschlüsselung von: -rwxr-xr--

  -         rwx       r-x       r--
  │          │         │         │
  │          │         │         └── Others: r-- (nur lesen)
  │          │         └── Group: r-x (lesen + ausführen)
  │          └── User: rwx (alles)
  └── Dateityp: - = Datei, d = Verzeichnis, l = Link
"

# ==============================================================================
echo "=== CHMOD: SYMBOLISCHE NOTATION ==="
# ==============================================================================

echo "Syntax: chmod [wer][operator][berechtigung] datei"
echo ""

touch demo.txt
echo "Ausgangssituation:"
ls -l demo.txt
echo ""

echo "chmod u+x demo.txt (User: +ausführbar):"
chmod u+x demo.txt
ls -l demo.txt
echo ""

echo "chmod g+w demo.txt (Group: +schreibbar):"
chmod g+w demo.txt
ls -l demo.txt
echo ""

echo "chmod o-r demo.txt (Others: -lesbar):"
chmod o-r demo.txt
ls -l demo.txt
echo ""

echo "chmod a=r demo.txt (All: nur lesen):"
chmod a=r demo.txt
ls -l demo.txt
echo ""

echo "
Operatoren:
  +  Berechtigung hinzufügen
  -  Berechtigung entfernen
  =  Berechtigung setzen (ersetzt alles)

Wer:
  u = user (Besitzer)
  g = group (Gruppe)
  o = others (Andere)
  a = all (Alle)
"

# ==============================================================================
echo "=== CHMOD: NUMERISCHE NOTATION (OKTAL) ==="
# ==============================================================================

echo "Jede Berechtigung hat einen Zahlenwert:"
echo ""
echo "  r = 4  (read)"
echo "  w = 2  (write)"
echo "  x = 1  (execute)"
echo ""
echo "Die Summe ergibt die Berechtigung pro Gruppe:"
echo ""

echo "
┌─────┬───────────┬──────────────────────────────┐
│ Zahl│ Bedeutung │ Berechnung                   │
├─────┼───────────┼──────────────────────────────┤
│  7  │ rwx       │ 4 + 2 + 1 = 7                │
│  6  │ rw-       │ 4 + 2 + 0 = 6                │
│  5  │ r-x       │ 4 + 0 + 1 = 5                │
│  4  │ r--       │ 4 + 0 + 0 = 4                │
│  3  │ -wx       │ 0 + 2 + 1 = 3                │
│  2  │ -w-       │ 0 + 2 + 0 = 2                │
│  1  │ --x       │ 0 + 0 + 1 = 1                │
│  0  │ ---       │ 0 + 0 + 0 = 0                │
└─────┴───────────┴──────────────────────────────┘
"

echo "Beispiele:"
echo ""

for mode in 755 644 600 777 700; do
    touch "test_$mode.txt"
    chmod $mode "test_$mode.txt"
    echo "chmod $mode:"
    ls -l "test_$mode.txt"
done
echo ""

echo "
Häufige Kombinationen:

  755 = rwxr-xr-x  Standard für Skripte/Programme
  644 = rw-r--r--  Standard für normale Dateien
  600 = rw-------  Private Dateien (z.B. SSH Keys)
  777 = rwxrwxrwx  VORSICHT! Jeder darf alles
  700 = rwx------  Private Verzeichnisse
"

# ==============================================================================
echo "=== VERZEICHNIS-BERECHTIGUNGEN ==="
# ==============================================================================

echo "Bei Verzeichnissen bedeuten die Berechtigungen etwas anderes:"
echo ""
echo "  r = Inhalt auflisten (ls) - Dateinamen sehen
  w = Einträge verändern (BRAUCHT auch x!)
  x = Verzeichnis betreten (cd) + auf Inhalte zugreifen"
echo ""

echo "WICHTIG: Um Dateien zu erstellen oder zu löschen, brauchst du w UND x!"
echo ""

mkdir testordner
chmod 755 testordner
echo "Verzeichnis mit 755 (Standard):"
ls -ld testordner
echo ""

echo "Ohne x: kein 'cd', kein Zugriff auf Dateien darin!"
echo "Ohne r: Inhalt nicht auflistbar (aber Zugriff möglich wenn x)"
echo "Ohne w+x: keine Dateien erstellen/löschen möglich!"
echo ""

# ==============================================================================
echo "=== CHOWN: BESITZER ÄNDERN ==="
# ==============================================================================

echo "Syntax: chown [user][:group] datei"
echo ""
echo "Beispiele (benötigen root/sudo):"
echo "  chown klaus datei.txt        # Besitzer ändern"
echo "  chown klaus:staff datei.txt  # Besitzer und Gruppe"
echo "  chown :staff datei.txt       # Nur Gruppe"
echo "  chown -R klaus ordner/       # Rekursiv"
echo ""

echo "Aktueller Benutzer und Gruppen:"
echo "  User: $(whoami)"
echo "  Gruppen: $(groups)"
echo ""

# ==============================================================================
echo "=== SPEZIELLE BERECHTIGUNGEN ==="
# ==============================================================================

echo "Es gibt noch drei spezielle Bits:"
echo ""
echo "  SUID (4xxx) - Programm läuft als Besitzer"
echo "  SGID (2xxx) - Programm läuft als Gruppe"
echo "  Sticky (1xxx) - Nur Besitzer kann löschen"
echo ""

echo "Beispiel: /tmp hat das Sticky-Bit:"
ls -ld /tmp
echo "  Das 't' am Ende bedeutet: Jeder kann Dateien erstellen,"
echo "  aber nur der Besitzer kann seine eigenen löschen."
echo ""

# ==============================================================================
echo "=== UMASK: STANDARD-BERECHTIGUNGEN ==="
# ==============================================================================

echo "umask bestimmt, welche Berechtigungen bei neuen Dateien ENTFERNT werden:"
echo ""
echo "Aktuelle umask: $(umask)"
echo ""

echo "Wenn umask = 022:"
echo "  Neue Datei:  666 - 022 = 644 (rw-r--r--)"
echo "  Neues Verz:  777 - 022 = 755 (rwxr-xr-x)"
echo ""

touch neue_datei.txt
mkdir neuer_ordner
echo "Neu erstellte Datei:"
ls -l neue_datei.txt
echo "Neu erstelltes Verzeichnis:"
ls -ld neuer_ordner
echo ""

# ==============================================================================
echo "=== PRAKTISCHE SZENARIEN ==="
# ==============================================================================

echo "
Szenario 1: Skript ausführbar machen
  chmod +x script.sh
  # oder: chmod 755 script.sh

Szenario 2: Private SSH-Keys schützen
  chmod 600 ~/.ssh/id_rsa
  # SSH verweigert Keys mit zu offenen Berechtigungen!

Szenario 3: Webserver-Dateien
  chmod 644 index.html      # Lesbar für alle
  chmod 755 uploads/        # Verzeichnis betretbar

Szenario 4: Geteiltes Verzeichnis
  chmod 775 shared/         # Gruppe darf schreiben
  chgrp team shared/        # Gruppe setzen
"

# Aufräumen
cd - > /dev/null
rm -rf "$TESTDIR"
echo "Testumgebung aufgeräumt."

echo ""
echo "=== ENDE ==="
echo "Tipp: Mit 'stat -f %A datei' siehst du die oktale Berechtigung"
