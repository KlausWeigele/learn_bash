# Archivierung & Backup Cheatsheet

## tar - Archive erstellen/entpacken

### Erstellen

```bash
# Nur packen (kein Komprimieren)
tar -cvf archiv.tar ordner/
tar -cvf archiv.tar datei1.txt datei2.txt

# Mit gzip-Kompression (.tar.gz / .tgz)
tar -czvf archiv.tar.gz ordner/

# Mit bzip2-Kompression (.tar.bz2)
tar -cjvf archiv.tar.bz2 ordner/

# Mit xz-Kompression (.tar.xz) - beste Kompression
tar -cJvf archiv.tar.xz ordner/

# Dateien/Ordner ausschließen
tar --exclude='*.log' -czvf archiv.tar.gz ordner/
tar --exclude='node_modules' --exclude='.git' -czvf archiv.tar.gz projekt/
```

### Entpacken

```bash
# Automatisch (erkennt Kompression)
tar -xvf archiv.tar.gz

# In bestimmten Ordner entpacken
tar -xvf archiv.tar.gz -C /ziel/ordner/

# Nur bestimmte Dateien
tar -xvf archiv.tar.gz pfad/datei.txt
```

### Anzeigen (ohne Entpacken)

```bash
tar -tvf archiv.tar.gz          # Inhalt auflisten
tar -tvf archiv.tar.gz | less   # Mit Pager
```

### Flags-Übersicht

| Flag | Bedeutung |
|------|-----------|
| `-c` | Create (erstellen) |
| `-x` | Extract (entpacken) |
| `-t` | List (auflisten) |
| `-v` | Verbose (Details zeigen) |
| `-f` | File (Dateiname folgt) |
| `-z` | gzip |
| `-j` | bzip2 |
| `-J` | xz |
| `-C` | Change directory (Zielordner) |

## gzip / gunzip - Einzeldateien komprimieren

```bash
# Komprimieren (Original wird ersetzt!)
gzip datei.txt              # → datei.txt.gz

# Original behalten
gzip -k datei.txt           # → datei.txt + datei.txt.gz

# Dekomprimieren
gunzip datei.txt.gz         # → datei.txt
gzip -d datei.txt.gz        # Alternative

# Kompressionsgrad (1-9, 9 = beste)
gzip -9 datei.txt

# Info anzeigen
gzip -l datei.txt.gz
```

## zip / unzip - Windows-kompatible Archive

```bash
# Erstellen
zip archiv.zip datei1.txt datei2.txt
zip -r archiv.zip ordner/           # Rekursiv (mit Unterordnern)
zip -r archiv.zip ordner/ -x "*.log"  # Mit Ausschluss

# Entpacken
unzip archiv.zip
unzip archiv.zip -d /ziel/ordner/   # In Zielordner
unzip archiv.zip "*.txt"            # Nur bestimmte Dateien

# Inhalt anzeigen
unzip -l archiv.zip

# Verschlüsselt (mit Passwort)
zip -e archiv.zip geheime-dateien/
```

## rsync - Intelligentes Synchronisieren

```bash
# Grundform
rsync -av quelle/ ziel/

# Optionen erklärt
rsync -a ...        # Archive: Berechtigungen, Timestamps, rekursiv
rsync -v ...        # Verbose: zeigt was passiert
rsync -z ...        # Kompression während Transfer
rsync -n ...        # Dry-run: zeigt nur was passieren würde
rsync --progress    # Fortschritt anzeigen
rsync --delete      # Gelöschte Dateien im Ziel auch löschen (Vorsicht!)

# Typische Kombinationen
rsync -avz quelle/ ziel/                    # Standard-Backup
rsync -avzn quelle/ ziel/                   # Dry-run erst
rsync -avz --delete quelle/ ziel/           # Exakter Spiegel
rsync -avz --exclude='*.log' quelle/ ziel/  # Mit Ausschluss

# Remote (über SSH)
rsync -avz ordner/ user@server:/pfad/
rsync -avz user@server:/pfad/ ordner/

# Mehrere Ausschlüsse
rsync -avz --exclude='node_modules' --exclude='.git' --exclude='*.log' quelle/ ziel/

# Ausschlüsse aus Datei
rsync -avz --exclude-from='exclude-list.txt' quelle/ ziel/
```

## WICHTIG: Trailing Slash bei rsync

```bash
# MIT Slash: Inhalt von quelle/ wird nach ziel/ kopiert
rsync -av quelle/ ziel/
# Ergebnis: ziel/datei1.txt, ziel/datei2.txt

# OHNE Slash: quelle selbst wird nach ziel/ kopiert
rsync -av quelle ziel/
# Ergebnis: ziel/quelle/datei1.txt, ziel/quelle/datei2.txt
```

## Backup-Strategien

### Einfaches Backup mit Datum

```bash
# Tägliches Backup mit Timestamp
backup_name="backup-$(date +%Y%m%d).tar.gz"
tar -czvf "$backup_name" wichtige-dateien/
```

### Rotierendes Backup

```bash
# Behalte nur die letzten 7 Backups
rsync -av --delete quelle/ backup/
cd backup-ordner
ls -t backup-*.tar.gz | tail -n +8 | xargs rm -f
```

### Inkrementelles Backup mit rsync

```bash
# Mit --link-dest für Hardlinks (spart Platz)
rsync -av --delete --link-dest=../gestern quelle/ heute/
```

## Nützliche Kombinationen

```bash
# Archiv erstellen und prüfen
tar -czvf archiv.tar.gz ordner/ && tar -tvf archiv.tar.gz | wc -l

# Backup mit Fortschritt
rsync -avz --progress quelle/ ziel/

# Große Datei splitten
split -b 100M grosse-datei.tar.gz teil-
# Wieder zusammensetzen
cat teil-* > grosse-datei.tar.gz

# Kompressionsvergleich
ls -lh original.txt
gzip -k original.txt && ls -lh original.txt.gz
bzip2 -k original.txt && ls -lh original.txt.bz2
xz -k original.txt && ls -lh original.txt.xz
```

## Fehlervermeidung

```bash
# IMMER erst Dry-run bei rsync mit --delete
rsync -avzn --delete quelle/ ziel/

# Archive vor dem Löschen der Quelle prüfen
tar -tvf archiv.tar.gz > /dev/null && echo "Archiv OK"

# Prüfsumme erstellen
shasum -a 256 archiv.tar.gz > archiv.tar.gz.sha256
# Später prüfen
shasum -c archiv.tar.gz.sha256
```
