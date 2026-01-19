# Text-Verarbeitung: Die Unix-Philosophie in Aktion

## Fragen zum Nachdenken

**Warum ist Text so wichtig in Unix?**
- Konfigurationsdateien? Text. Logs? Text. Daten austauschen? Oft Text (CSV, JSON, XML). Warum hat sich das durchgesetzt?

**Die Pipe `|` - was passiert da eigentlich?**
- `cat datei.txt | grep "error" | wc -l` - drei Programme, eine Zeile. Wie "reden" die miteinander?

**grep, sed, awk - wozu drei Tools?**
- Alle drei verarbeiten Text. Warum nicht EIN Programm, das alles kann?

**Reguläre Ausdrücke - Magie oder Chaos?**
- `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$` - das soll eine Email-Adresse matchen. Wie liest man sowas?

---

## Aha-Momente

### Die Unix-Philosophie

> "Schreibe Programme, die eine Sache gut machen."
> "Schreibe Programme, die zusammenarbeiten."
> "Schreibe Programme, die Text verarbeiten, denn Text ist universell."

```bash
# Statt EINEM komplexen Programm:
super_tool --find "error" --count --file log.txt

# Kombiniere VIELE einfache:
cat log.txt | grep "error" | wc -l
```

Jedes Tool macht eine Sache - aber zusammen sind sie mächtig!

### Die Pipe: stdout → stdin

```
┌─────────┐    stdout    ┌─────────┐    stdout    ┌─────────┐
│  cat    │─────────────▶│  grep   │─────────────▶│   wc    │
└─────────┘              └─────────┘              └─────────┘
     │                        │                        │
     │ liest Datei           │ filtert                │ zählt
     │ schreibt auf stdout   │ schreibt auf stdout    │ gibt Zahl aus
```

Die Pipe `|` verbindet stdout des linken Programms mit stdin des rechten.

### Die drei Musketiere der Text-Verarbeitung

| Tool | Stärke | Typischer Einsatz |
|------|--------|-------------------|
| **grep** | Suchen | "Finde alle Zeilen mit X" |
| **sed** | Ersetzen | "Ändere X zu Y" |
| **awk** | Strukturieren | "Nimm Spalte 3, rechne damit" |

```bash
# grep = Global Regular Expression Print
grep "error" log.txt            # Finde Zeilen mit "error"

# sed = Stream EDitor
sed 's/alt/neu/g' datei.txt     # Ersetze "alt" durch "neu"

# awk = Aho, Weinberger, Kernighan (die Erfinder)
awk '{print $1, $3}' datei.txt  # Gib Spalte 1 und 3 aus
```

### Reguläre Ausdrücke (Regex) - Schritt für Schritt

```
Regex sind wie eine Mini-Sprache zur Musterbeschreibung:

.        = Ein beliebiges Zeichen
*        = Null oder mehr vom Vorherigen
+        = Eins oder mehr vom Vorherigen
?        = Null oder eins vom Vorherigen
^        = Zeilenanfang
$        = Zeilenende
[abc]    = a, b oder c
[^abc]   = NICHT a, b oder c
[a-z]    = Kleinbuchstaben
\d       = Ziffer (je nach Tool)
\s       = Whitespace
```

**Beispiel: Email-Regex dekodiert**
```
^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
│└──────────────┘ │└────────────┘  └─────────┘│
│       │        │       │              │     │
│  Benutzername  │    Domain         TLD     │
│  (Buchstaben,  │  (Buchstaben,  (mind. 2   │
│   Zahlen,      │   Zahlen,      Buchst.)   │
│   Sonderz.)    │   Punkte)                 │
│                │                           │
└─ Zeilenanfang  @-Zeichen          Zeilenende─┘
```

---

## Gedankenexperimente

### Experiment 1: Die Macht der Pipe

```bash
# Wie viele Prozesse laufen gerade?
ps aux | wc -l

# Was macht das genau?
ps aux              # Zeigt alle Prozesse
ps aux | wc -l      # Zählt die Zeilen

# Erweitere:
ps aux | grep "chrome" | wc -l   # Nur Chrome-Prozesse zählen
```

### Experiment 2: grep ist wählerisch

```bash
echo -e "Hallo\nhallo\nHALLO" | grep "hallo"
echo -e "Hallo\nhallo\nHALLO" | grep -i "hallo"
```
- Was ist der Unterschied?
- Was macht `-i`?

### Experiment 3: sed ist ein Transformer

```bash
echo "Ich mag Äpfel" | sed 's/Äpfel/Birnen/'
echo "Äpfel Äpfel Äpfel" | sed 's/Äpfel/Birnen/'
echo "Äpfel Äpfel Äpfel" | sed 's/Äpfel/Birnen/g'
```
- Warum wird beim zweiten nur einmal ersetzt?
- Was macht das `g`?

### Experiment 4: awk denkt in Spalten

```bash
echo "Max Mustermann 42" | awk '{print $2}'
echo "Max Mustermann 42" | awk '{print $1, $3}'
echo "Max Mustermann 42" | awk '{print $3 * 2}'
```
- Wie nummeriert awk die Spalten?
- Kann awk rechnen?

---

## Selbst ausprobieren

**Challenge 1:** Finde alle TODO-Kommentare in deinem Code
```bash
grep -r "TODO" ~/softwareprojekte_claude/ 2>/dev/null | head -10
```

**Challenge 2:** Zähle Wörter in einer Datei
```bash
cat /etc/hosts | wc -w
# Oder eleganter:
wc -w < /etc/hosts
```

**Challenge 3:** Extrahiere alle Email-Adressen aus einer Datei
```bash
grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" datei.txt
```

**Challenge 4:** Ersetze alle Tabs durch Leerzeichen
```bash
sed 's/\t/    /g' datei.txt
```

**Challenge 5:** Zeige nur die IP-Adressen aus /etc/hosts
```bash
awk '!/^#/ && NF {print $1}' /etc/hosts
```
(Ignoriere Kommentare und leere Zeilen, zeige erste Spalte)

---

## Die Kunst der Kombination

```bash
# Real-World Beispiel: Die 10 häufigsten Wörter in einer Datei

cat datei.txt |           # Datei lesen
  tr -s ' ' '\n' |        # Wörter auf eigene Zeilen
  tr '[:upper:]' '[:lower:]' |  # Kleinschreibung
  sort |                  # Sortieren
  uniq -c |               # Zählen
  sort -rn |              # Nach Häufigkeit sortieren
  head -10                # Top 10

# Jeder Schritt macht EINE Sache - zusammen: mächtig!
```

---

## Weiter geht's

- [CHEATSHEET.md](CHEATSHEET.md) - Alle Optionen im Überblick
- [scripts/](scripts/) - Praktische Beispiele zum Ausprobieren
