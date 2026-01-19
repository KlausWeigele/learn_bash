# Datei-Operationen: Alles ist eine Datei

## Fragen zum Nachdenken

**Was ist eigentlich eine "Datei"?**
- Klar, `dokument.txt` ist eine Datei. Aber was ist mit `/dev/null`? Oder `/dev/random`? Sind das auch Dateien?

**Warum heißt es "alles ist eine Datei"?**
- In Unix/Linux wird fast alles als Datei behandelt: Festplatten, USB-Sticks, sogar deine Tastatur. Warum macht man das so?

**Die Nadel im Heuhaufen**
- Du hast 10.000 Dateien in verschachtelten Ordnern. Du suchst alle PDFs, die größer als 1 MB sind und in den letzten 7 Tagen geändert wurden. Wie lange dauert das per Hand?

**Wer darf was?**
- Warum kannst du manche Dateien nicht löschen? Was bedeutet `Permission denied`?

---

## Aha-Momente

### "Alles ist eine Datei" - wirklich alles?

```bash
# Das hier ist eine normale Datei
cat /etc/hosts

# Das hier ist... ein schwarzes Loch für Daten
echo "Weg damit" > /dev/null

# Das hier gibt Zufallsdaten zurück
head -c 10 /dev/random | xxd

# Das hier ist deine Festplatte (Vorsicht!)
ls -la /dev/disk0
```

Die Unix-Philosophie: Wenn alles eine Datei ist, brauchst du nur EIN Interface zum Lesen und Schreiben. Elegant!

### Dateipfade sind Wegbeschreibungen

```
/Users/klaus/Documents/projekt/README.md
│     │     │          │       └── Dateiname
│     │     │          └── Ordner
│     │     └── Ordner
│     └── Benutzername
└── Root (Wurzel des Dateisystems)
```

- **Absoluter Pfad**: Beginnt mit `/` - vollständige Adresse
- **Relativer Pfad**: Beginnt NICHT mit `/` - relativ zum aktuellen Ordner

### Die drei Berechtigungen

```
-rwxr-xr--
│└┬┘└┬┘└┬┘
│ │  │  └── Andere (others): r-- = nur lesen
│ │  └── Gruppe (group): r-x = lesen + ausführen
│ └── Besitzer (user): rwx = alles erlaubt
└── Dateityp: - = Datei, d = Verzeichnis, l = Link
```

Drei Berechtigungen, drei Gruppen - 9 Bits, die bestimmen, wer was darf.

---

## Gedankenexperimente

### Experiment 1: /dev/null - Das Datenloch

```bash
# Was passiert hier?
echo "Hallo Welt" > /dev/null
cat /dev/null
```
- Wohin verschwinden die Daten?
- Warum ist das nützlich? (Tipp: Denk an nervige Fehlermeldungen)

### Experiment 2: Versteckte Dateien

```bash
ls
ls -a
```
- Was ist der Unterschied?
- Wie "versteckt" man eine Datei in Unix?
- Warum beginnt `.bashrc` mit einem Punkt?

### Experiment 3: Inodes - Die wahre Identität

```bash
ls -i datei.txt
ln datei.txt hardlink.txt
ls -i datei.txt hardlink.txt
```
- Was ist eine Inode?
- Warum haben beide Dateien die gleiche Nummer?
- Was passiert, wenn du die Originaldatei löschst?

### Experiment 4: Der Unterschied zwischen cp und mv

```bash
# Erstelle eine große Datei
dd if=/dev/zero of=gross.bin bs=1M count=100

# Miss die Zeit für copy vs move im gleichen Dateisystem
time cp gross.bin kopie.bin
time mv gross.bin verschoben.bin
```
- Warum ist `mv` so viel schneller?
- Wann ist `mv` genauso langsam wie `cp`?

---

## Selbst ausprobieren

**Challenge 1:** Finde alle versteckten Dateien in deinem Home-Verzeichnis
```bash
ls -a ~ | grep '^\.'
```
Wie viele sind es? Was machen die alle?

**Challenge 2:** Erstelle eine Datei, die nur DU lesen kannst
```bash
touch geheim.txt
chmod ??? geheim.txt  # Welche Zahl?
```

**Challenge 3:** Finde die größten Dateien auf deinem System
```bash
find ~ -type f -size +100M 2>/dev/null
```
Überraschungen dabei?

**Challenge 4:** Wie voll ist deine Festplatte?
```bash
df -h
du -sh ~/*
```
Was frisst den meisten Platz?

---

## Weiter geht's

Wenn du diese Konzepte verstanden hast:
- [CHEATSHEET.md](CHEATSHEET.md) - Alle Befehle im Überblick
- [scripts/](scripts/) - Praktische Beispiele mit find, xargs und mehr
