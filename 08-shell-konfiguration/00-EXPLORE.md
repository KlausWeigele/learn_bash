# Shell-Konfiguration: Mach die Shell zu DEINER Shell

## Fragen zum Nachdenken

Bevor du deine Shell anpasst, nimm dir einen Moment:

**Warum konfigurieren?**
- Jedes Mal `ls -la` tippen ist lästig. Wäre `ll` nicht schöner?
- Du wechselst oft in `/Users/klaus/Projects/current-client/frontend`. Geht das kürzer?

**Was passiert beim Terminal-Start?**
- Woher "weiß" dein Terminal, welche Befehle es kennt?
- Warum funktioniert `python` nach der Installation manchmal nicht?

**Dotfiles - die versteckten Schätze**
- Warum heißen Konfigurationsdateien `.zshrc` und nicht `zshrc`?
- Wie viele Dotfiles hast du eigentlich? (`ls -la ~ | grep "^\."`)

---

## Aha-Momente

### Die Shell liest beim Start eine Datei

```bash
# Für Zsh (macOS Standard seit Catalina)
~/.zshrc

# Für Bash
~/.bashrc      # Interaktive Shells
~/.bash_profile # Login Shells
```

Alles was hier steht, wird bei jedem neuen Terminal ausgeführt!

### PATH ist wie ein Telefonbuch

```bash
echo $PATH
# /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

Wenn du `python` tippst, sucht die Shell in diesen Ordnern - von links nach rechts.

```bash
# Python installiert in /usr/local/bin?
# → wird gefunden

# Tool installiert in ~/bin?
# → wird NICHT gefunden (wenn ~/bin nicht im PATH ist)
```

### Alias = Abkürzung

```bash
# In ~/.zshrc:
alias ll='ls -la'
alias gs='git status'
alias ..='cd ..'
```

Ab jetzt: `ll` statt `ls -la`. Weniger Tippen, gleiche Wirkung.

### Export macht's global

```bash
# Nur in dieser Shell:
MEINE_VAR="Hallo"

# Für diese Shell UND alle Kindprozesse:
export MEINE_VAR="Hallo"
```

---

## Gedankenexperimente

### Experiment 1: Was steht in deiner .zshrc?

```bash
cat ~/.zshrc
```

- Verstehst du jede Zeile?
- Welche Aliase hast du vielleicht vergessen?

### Experiment 2: Wo ist mein Befehl?

```bash
which python
which python3
which ls
```

- Sind es die Versionen die du erwartest?
- Was passiert bei `which notexistent`?

### Experiment 3: PATH manipulieren

```bash
# Aktuellen PATH anzeigen
echo $PATH

# Temporär einen Ordner hinzufügen
export PATH="$HOME/bin:$PATH"

# Jetzt nochmal prüfen
echo $PATH
```

Schließe das Terminal und öffne neu. Ist ~/bin noch im PATH? Warum (nicht)?

### Experiment 4: Die Startup-Reihenfolge

```bash
# Füge diese Zeilen am Anfang deiner Configs hinzu:
echo "zshrc wird geladen..."   # in ~/.zshrc
echo "zprofile wird geladen..." # in ~/.zprofile
```

Öffne ein neues Terminal. Was wird in welcher Reihenfolge geladen?

---

## Selbst ausprobieren

**Challenge 1:** Praktische Aliase erstellen
```bash
# Öffne ~/.zshrc
nano ~/.zshrc  # oder: code ~/.zshrc

# Füge hinzu:
alias ll='ls -la'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Speichern und neu laden
source ~/.zshrc
```

**Challenge 2:** Einen eigenen bin-Ordner einrichten
```bash
# Ordner erstellen
mkdir -p ~/bin

# Zum PATH hinzufügen (in ~/.zshrc)
export PATH="$HOME/bin:$PATH"

# Ein einfaches Skript erstellen
echo '#!/bin/zsh
echo "Hallo, es ist $(date)"' > ~/bin/hallo
chmod +x ~/bin/hallo

# Neu laden und testen
source ~/.zshrc
hallo
```

**Challenge 3:** Custom Prompt
```bash
# In ~/.zshrc - einfacher farbiger Prompt
PROMPT='%F{cyan}%n%f@%F{green}%m%f:%F{yellow}%~%f$ '

# Mit Git-Branch (wenn oh-my-zsh nicht installiert)
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
PROMPT='%F{cyan}%~%f%F{yellow}${vcs_info_msg_0_}%f$ '
```

**Challenge 4:** Projekt-Shortcuts
```bash
# In ~/.zshrc
export PROJECTS="$HOME/Projects"
alias proj='cd $PROJECTS'
alias current='cd $PROJECTS/current-client'

# Funktion für schnelles Projekt-Wechseln
p() {
    cd "$PROJECTS/$1"
}
# Nutzung: p mein-projekt
```

---

## Weiter geht's

Wenn du deine Shell personalisiert hast:
- [CHEATSHEET.md](CHEATSHEET.md) - Alle Konfigurations-Optionen
- [scripts/](scripts/) - Beispiel-Konfigurationen
