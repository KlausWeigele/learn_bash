# Archivierung & Backup: Nichts geht verloren

## Fragen zum Nachdenken

Bevor du loslegst, nimm dir einen Moment:

**Warum archivieren?**
- Du willst jemandem 50 Dateien schicken. Eine E-Mail pro Datei? Oder vielleicht... eine Datei?
- Ein Projekt hat 10.000 kleine Dateien. Kopieren dauert ewig. Warum ist ein Archiv schneller?

**Kompression - Magie oder Mathematik?**
- Wie kann eine 100 MB Datei auf 10 MB schrumpfen - ohne Informationsverlust?
- Warum lassen sich manche Dateien gut komprimieren (Text) und andere kaum (JPG, MP4)?

**Backup-Philosophie**
- Wie viele Kopien deiner wichtigen Daten hast du?
- Was passiert, wenn dein Mac morgen kaputt geht?

---

## Aha-Momente

### tar ist kein Komprimierer

```bash
# tar = Tape ARchiver (ja, Magnetband!)
# Packt Dateien zusammen, komprimiert aber NICHT

# Archiv erstellen (nur zusammenpacken)
tar -cvf archiv.tar ordner/

# Archiv + Kompression (gzip)
tar -czvf archiv.tar.gz ordner/

# Die Flags:
# c = create (erstellen)
# v = verbose (zeigen was passiert)
# f = file (Dateiname folgt)
# z = gzip-Kompression
```

`tar` packt zusammen, `gzip` drückt zusammen. Zusammen: `.tar.gz`

### Die Anatomie einer Archiv-Endung

```
backup.tar      → Nur gepackt, nicht komprimiert
backup.tar.gz   → tar + gzip (häufigster Standard)
backup.tgz      → Kurzform von .tar.gz
backup.tar.bz2  → tar + bzip2 (bessere Kompression, langsamer)
backup.tar.xz   → tar + xz (beste Kompression, noch langsamer)
backup.zip      → Windows-Standard, alles in einem
```

### rsync ist schlau

```bash
# Erster Lauf: Kopiert alles (1000 Dateien)
rsync -av quelle/ ziel/

# Zweiter Lauf: Nur Änderungen (vielleicht 3 Dateien)
rsync -av quelle/ ziel/
```

rsync vergleicht und kopiert nur das Nötige. Perfekt für Backups!

---

## Gedankenexperimente

### Experiment 1: Kompressionsvergleich

```bash
# Erstelle eine Testdatei
yes "Hello World" | head -100000 > test.txt
ls -lh test.txt

# Komprimiere mit verschiedenen Tools
gzip -k test.txt      # -k = keep original
bzip2 -k test.txt
xz -k test.txt
zip test.zip test.txt

# Vergleiche die Größen
ls -lh test.*
```

Welches ist am kleinsten? Welches am schnellsten?

### Experiment 2: Was ist in diesem Archiv?

```bash
# Inhalt anzeigen, ohne zu entpacken
tar -tvf archiv.tar.gz
unzip -l archiv.zip
```

Super nützlich bevor du etwas entpackst!

### Experiment 3: Der Trailing Slash

```bash
# MIT Slash: Inhalt von 'ordner' nach 'ziel'
rsync -av ordner/ ziel/

# OHNE Slash: 'ordner' selbst nach 'ziel' (wird zu ziel/ordner/)
rsync -av ordner ziel/
```

Ein kleiner Unterschied mit großer Wirkung!

---

## Selbst ausprobieren

**Challenge 1:** Projekt archivieren
```bash
# Erstelle ein tar.gz deines Projekts (ohne node_modules, .git, etc.)
tar --exclude='node_modules' --exclude='.git' -czvf projekt.tar.gz projekt/
```

**Challenge 2:** Selektiv entpacken
```bash
# Nur bestimmte Dateien aus Archiv holen
tar -xzvf archiv.tar.gz pfad/zur/datei.txt

# Nur .txt Dateien aus zip
unzip archiv.zip "*.txt"
```

**Challenge 3:** Inkrementelles Backup mit rsync
```bash
# Erstelle zwei Ordner
mkdir -p quelle ziel
echo "Test 1" > quelle/datei1.txt
echo "Test 2" > quelle/datei2.txt

# Erstes Backup
rsync -av quelle/ ziel/

# Ändere eine Datei
echo "Test 1 geändert" > quelle/datei1.txt

# Zweites Backup - beobachte was kopiert wird
rsync -av quelle/ ziel/
```

**Challenge 4:** Backup mit Datum
```bash
# Archiv mit Timestamp erstellen
tar -czvf "backup-$(date +%Y%m%d-%H%M%S).tar.gz" wichtige-dateien/
```

---

## Weiter geht's

Wenn du diese Experimente gemeistert hast:
- [CHEATSHEET.md](CHEATSHEET.md) - Alle Befehle kompakt
- [scripts/](scripts/) - Backup-Skripte zum Anpassen
