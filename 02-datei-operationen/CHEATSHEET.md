# Datei-Operationen Cheatsheet

## Grundlegende Befehle

```bash
ls              # Dateien auflisten
ls -la          # Alle Dateien, lange Ausgabe
ls -lh          # Mit menschenlesbaren Größen
ls -lt          # Nach Zeit sortiert

cd /pfad        # Verzeichnis wechseln
cd ~            # Home-Verzeichnis
cd -            # Vorheriges Verzeichnis
pwd             # Aktuelles Verzeichnis anzeigen

mkdir ordner           # Verzeichnis erstellen
mkdir -p a/b/c         # Verschachtelte Verzeichnisse
rmdir ordner           # Leeres Verzeichnis löschen

cp quelle ziel         # Datei kopieren
cp -r ordner/ ziel/    # Ordner rekursiv kopieren
cp -p quelle ziel      # Berechtigungen beibehalten

mv alt neu             # Umbenennen/Verschieben
rm datei               # Datei löschen
rm -r ordner           # Ordner rekursiv löschen
rm -rf ordner          # Ohne Nachfrage (VORSICHT!)

touch datei            # Datei erstellen/Timestamp aktualisieren
```

## find - Dateien suchen

```bash
# Grundsyntax
find [pfad] [optionen] [aktion]

# Nach Name
find . -name "*.txt"           # Alle .txt-Dateien
find . -iname "*.txt"          # Case-insensitive
find . -name "test*"           # Beginnt mit "test"

# Nach Typ
find . -type f                 # Nur Dateien
find . -type d                 # Nur Verzeichnisse
find . -type l                 # Nur Symlinks

# Nach Größe
find . -size +10M              # Größer als 10 MB
find . -size -1k               # Kleiner als 1 KB
find . -size 100c              # Exakt 100 Bytes
# Einheiten: c=Bytes, k=KB, M=MB, G=GB

# Nach Zeit
find . -mtime -7               # Geändert in letzten 7 Tagen
find . -mtime +30              # Geändert vor mehr als 30 Tagen
find . -mmin -60               # Geändert in letzten 60 Minuten
find . -newer referenz.txt     # Neuer als referenz.txt

# Nach Berechtigungen
find . -perm 644               # Exakt diese Berechtigung
find . -perm -644              # Mindestens diese Berechtigung
find . -user klaus             # Gehört Benutzer klaus
find . -group staff            # Gehört Gruppe staff

# Kombinationen
find . -name "*.log" -size +1M
find . -type f -name "*.sh" -perm -100
find . \( -name "*.jpg" -o -name "*.png" \)  # ODER

# Aktionen
find . -name "*.tmp" -delete           # Löschen
find . -name "*.sh" -exec chmod +x {} \;   # Befehl ausführen
find . -type f -exec ls -lh {} \;      # Für jede Datei ls
find . -name "*.txt" -print0           # Null-terminiert (für xargs)
```

## xargs - Argumente übergeben

```bash
# Grundprinzip: Wandelt stdin in Argumente um

# Einfach
echo "datei1 datei2 datei3" | xargs rm

# Mit find (sicher mit Leerzeichen im Dateinamen)
find . -name "*.txt" -print0 | xargs -0 rm

# Anzahl Argumente begrenzen
echo "1 2 3 4 5" | xargs -n 2 echo
# Ausgabe:
# 1 2
# 3 4
# 5

# Platzhalter verwenden
find . -name "*.txt" | xargs -I {} cp {} backup/

# Parallel ausführen (macOS)
find . -name "*.jpg" | xargs -P 4 -I {} convert {} {}.png

# Bestätigung vor Ausführung
find . -name "*.tmp" | xargs -p rm
```

## Berechtigungen (chmod, chown)

### Symbolische Notation
```bash
chmod u+x datei        # User: ausführbar hinzufügen
chmod g-w datei        # Group: schreiben entfernen
chmod o=r datei        # Others: nur lesen setzen
chmod a+r datei        # All: lesen hinzufügen
chmod u+x,g-w datei    # Kombiniert

# Wer?
# u = user (Besitzer)
# g = group (Gruppe)
# o = others (Andere)
# a = all (Alle)

# Was?
# + = hinzufügen
# - = entfernen
# = = setzen

# Welche Berechtigung?
# r = read (lesen)
# w = write (schreiben)
# x = execute (ausführen)
```

### Numerische Notation (Oktal)
```bash
chmod 755 datei        # rwxr-xr-x
chmod 644 datei        # rw-r--r--
chmod 600 datei        # rw-------
chmod 777 datei        # rwxrwxrwx (VORSICHT!)

# Berechnung:
# r = 4
# w = 2
# x = 1
# Summe pro Gruppe

# Beispiel: 754
# User:   7 = 4+2+1 = rwx
# Group:  5 = 4+0+1 = r-x
# Others: 4 = 4+0+0 = r--
```

### Besitzer ändern
```bash
chown klaus datei          # Besitzer ändern
chown klaus:staff datei    # Besitzer und Gruppe
chown :staff datei         # Nur Gruppe
chown -R klaus ordner/     # Rekursiv
```

## Links

```bash
# Hardlink (gleiche Inode, gleicher Inhalt)
ln original hardlink

# Symlink (Verweis auf Pfad)
ln -s original symlink
ln -s /pfad/zu/ordner link

# Unterschied prüfen
ls -li           # Zeigt Inode-Nummer
readlink symlink # Zeigt Ziel des Symlinks
```

## Disk Usage

```bash
df -h              # Freier Speicher (Dateisystem)
du -sh ordner/     # Größe eines Ordners
du -sh *           # Größe aller Einträge
du -sh * | sort -h # Sortiert nach Größe

# Größte Dateien finden
du -ah . | sort -rh | head -20
```

## Spezielle Dateien

```bash
/dev/null          # Schwarzes Loch (verwirft alles)
/dev/zero          # Unendlich Nullen
/dev/random        # Zufallsdaten
/dev/stdin         # Standardeingabe
/dev/stdout        # Standardausgabe
/dev/stderr        # Fehlerausgabe
```

## Nützliche Kombinationen

```bash
# Alle leeren Dateien löschen
find . -type f -empty -delete

# Alle .bak-Dateien älter als 30 Tage löschen
find . -name "*.bak" -mtime +30 -delete

# Alle Skripte ausführbar machen
find . -name "*.sh" -exec chmod +x {} \;

# Dateien nach Extension zählen
find . -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn

# Doppelte Dateien finden (nach Größe)
find . -type f -exec ls -s {} \; | sort -n | uniq -d -w 10

# Backup mit Timestamp
cp datei.txt datei.txt.$(date +%Y%m%d)
```
