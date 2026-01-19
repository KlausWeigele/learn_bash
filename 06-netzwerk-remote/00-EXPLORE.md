# Netzwerk & Remote: Die Welt ist dein Terminal

## Fragen zum Nachdenken

Bevor du in die Befehle einsteigst, nimm dir einen Moment:

**Das Internet ist überall**
- Wie lädt dein Browser eigentlich eine Webseite? Was passiert "unter der Haube"?
- Kannst du eine API abfragen, ohne einen Browser zu öffnen?

**Fernzugriff**
- Du sitzt am Mac, aber dein Code soll auf einem Server laufen. Wie kommst du da hin?
- Was ist der Unterschied zwischen einer Datei kopieren und sich auf einem Server einloggen?

**Vertrauen und Sicherheit**
- Warum fragt `ssh` beim ersten Verbinden nach einem "Fingerprint"?
- Wieso sind Passwörter für Server eigentlich schlecht?

---

## Aha-Momente

### curl ist dein Schweizer Taschenmesser

```bash
# Eine Webseite abrufen
curl https://example.com

# Nur die Header sehen
curl -I https://example.com

# Eine API abfragen
curl https://api.github.com/users/octocat
```

Das Terminal kann alles, was dein Browser kann - nur ohne das ganze Drumherum.

### SSH ist wie Teleportation

```bash
# Auf Server einloggen
ssh benutzer@server.example.com

# Befehl auf Server ausführen (ohne einzuloggen)
ssh benutzer@server.example.com "ls -la"

# Datei zum Server kopieren
scp datei.txt benutzer@server.example.com:/home/benutzer/
```

Du bist nicht mehr an deinen Rechner gebunden.

### Ports sind wie Wohnungstüren

Ein Server hat 65.535 "Türen" (Ports). Jeder Dienst hat seine eigene:
- Port 22: SSH
- Port 80: HTTP
- Port 443: HTTPS
- Port 3000: Dein Node.js-Dev-Server?

```bash
# Wer hört auf welchem Port?
lsof -i :3000
```

---

## Gedankenexperimente

### Experiment 1: Was sieht der Server?

```bash
curl https://httpbin.org/ip
curl https://httpbin.org/headers
curl https://httpbin.org/user-agent
```

- Welche Informationen sendest du automatisch mit?
- Kannst du den User-Agent ändern? (Tipp: `curl -A`)

### Experiment 2: Download vs. Ansehen

```bash
# Inhalt im Terminal anzeigen
curl https://example.com

# In Datei speichern
curl -o example.html https://example.com

# Mit Original-Dateiname speichern
curl -O https://example.com/robots.txt
```

Wann brauchst du was?

### Experiment 3: Ist der Server erreichbar?

```bash
ping -c 3 google.com
ping -c 3 192.168.1.1
```

- Was bedeuten die Zahlen?
- Was ist, wenn kein Ping zurückkommt?

---

## Selbst ausprobieren

**Challenge 1:** API erkunden
```bash
# GitHub API: Hole deine eigenen Infos (ersetze USERNAME)
curl https://api.github.com/users/USERNAME
```
Kannst du die Ausgabe mit `jq` formatieren? (`brew install jq`)

**Challenge 2:** Netzwerk-Diagnose
```bash
# Welche Verbindungen hat dein Mac gerade?
netstat -an | head -20

# Welche Prozesse nutzen das Netzwerk?
lsof -i -P | head -20
```

**Challenge 3:** Lokalen Server starten
```bash
# Starte einen einfachen Webserver im aktuellen Ordner
python3 -m http.server 8000
```
Öffne dann `http://localhost:8000` im Browser. Magie!

**Challenge 4:** SSH-Key erstellen (falls noch keiner existiert)
```bash
# Prüfen ob schon ein Key existiert
ls -la ~/.ssh/

# Neuen Key erstellen
ssh-keygen -t ed25519 -C "dein@email.com"
```

---

## Weiter geht's

Wenn du diese Experimente durchgespielt hast, bist du bereit für:
- [CHEATSHEET.md](CHEATSHEET.md) - Alle Befehle im Überblick
- [scripts/](scripts/) - Praktische Beispiele
