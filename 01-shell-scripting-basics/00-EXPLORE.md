# Shell-Scripting: Warum eigentlich?

## Fragen zum Nachdenken

Bevor du in die Syntax einsteigst, nimm dir einen Moment:

**Warum tippen statt klicken?**
- Du hast einen Ordner mit 500 Fotos. Alle sollen umbenannt werden von `IMG_1234.jpg` zu `urlaub-2024-001.jpg`. Wie lange dauert das per Hand? Wie lange mit einem Script?

**Was macht ein Skript zu einem Skript?**
- Ein Befehl wie `ls -la` ist kein Skript. Ab wann wird es eins? Ist es die Datei? Der Shebang? Etwas anderes?

**Wiederholung ist der Schlüssel**
- Denk an eine Aufgabe, die du regelmäßig am Computer machst. Backup? Logs aufräumen? Dateien sortieren? Könnte das automatisiert werden?

---

## Aha-Momente

### Die Shell ist ein Interpreter
Wenn du `echo "Hallo"` tippst, passiert folgendes:
1. Die Shell liest deine Eingabe
2. Sie **interpretiert** sie (erkennt `echo` als Befehl)
3. Sie führt den Befehl aus
4. Sie zeigt das Ergebnis

Das ist wie Python oder JavaScript - nur dass die "Programmiersprache" dein Terminal ist.

### Alles ist Text
```bash
# Das hier ist ein Programm:
echo "Hello World"

# Das hier auch:
ls | grep ".txt" | wc -l
```
Kein Compiler, kein Build-Prozess. Speichern, ausführen, fertig.

### Die Shell hat ein Gedächtnis
```bash
name="Klaus"
echo $name  # Später noch verfügbar
```
Variablen bleiben - aber nur für diese Shell-Session. Schließt du das Terminal, sind sie weg. Oder?

---

## Gedankenexperimente

### Experiment 1: Was passiert hier?
```bash
#!/bin/zsh
for i in {1..5}; do
    echo "Durchlauf $i"
done
```
- Was macht `{1..5}`?
- Was ist `$i`?
- Führe es aus und beobachte.

### Experiment 2: Der Shebang
```bash
#!/bin/zsh
echo "Ich bin ein Zsh-Skript"
```
```bash
#!/bin/bash
echo "Ich bin ein Bash-Skript"
```
- Was passiert, wenn du das falsche Shebang verwendest?
- Probiere: `bash script.sh` vs. `./script.sh` - Unterschied?

### Experiment 3: Exit Codes
```bash
ls /existiert-nicht
echo $?
```
```bash
ls /
echo $?
```
- Was bedeutet die Zahl?
- Warum ist das wichtig für Skripte?

---

## Selbst ausprobieren

**Challenge 1:** Finde heraus, welche Shell du verwendest
```bash
echo $SHELL
echo $0
```
Sind die Ausgaben gleich? Was könnte der Unterschied sein?

**Challenge 2:** Schreibe dein erstes Skript
1. Erstelle eine Datei `hello.sh`
2. Schreibe `#!/bin/zsh` und `echo "Mein erstes Skript!"`
3. Mach sie ausführbar: `chmod +x hello.sh`
4. Führe sie aus: `./hello.sh`

**Challenge 3:** Variablen-Mysterium
```bash
x=5
echo $x
echo "$x"
echo '$x'
```
Was passiert bei den drei `echo`-Befehlen? Warum?

---

## Weiter geht's

Wenn du diese Fragen durchdacht hast, bist du bereit für:
- [CHEATSHEET.md](CHEATSHEET.md) - Die Syntax im Überblick
- [scripts/](scripts/) - Praktische Beispiele zum Rumspielen
