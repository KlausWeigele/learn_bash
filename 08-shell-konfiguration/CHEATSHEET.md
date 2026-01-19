# Shell-Konfiguration Cheatsheet

## Konfigurationsdateien

### Zsh (macOS Standard)

| Datei | Wann geladen | Verwendung |
|-------|-------------|------------|
| `~/.zshenv` | Immer | Umgebungsvariablen (selten genutzt) |
| `~/.zprofile` | Login-Shell | Wie .zshenv, aber nur bei Login |
| `~/.zshrc` | Interaktive Shell | **Hauptconfig:** Aliase, Prompt, PATH |
| `~/.zlogin` | Login-Shell | Nach .zshrc |
| `~/.zlogout` | Beim Logout | Aufräumen |

**Für die meisten Fälle:** Alles in `~/.zshrc`

### Bash

| Datei | Wann geladen | Verwendung |
|-------|-------------|------------|
| `~/.bash_profile` | Login-Shell | PATH, Umgebungsvariablen |
| `~/.bashrc` | Interaktive Shell | Aliase, Funktionen |
| `~/.bash_logout` | Beim Logout | Aufräumen |

## Umgebungsvariablen

```bash
# Setzen (nur aktuelle Shell)
MEINE_VAR="Wert"

# Setzen (auch für Kindprozesse)
export MEINE_VAR="Wert"

# Lesen
echo $MEINE_VAR
echo ${MEINE_VAR}

# Löschen
unset MEINE_VAR

# Alle anzeigen
env
printenv

# Eine bestimmte
echo $HOME
printenv PATH
```

### Wichtige Umgebungsvariablen

```bash
$HOME       # Home-Verzeichnis (/Users/klaus)
$USER       # Benutzername (klaus)
$PATH       # Suchpfad für Programme
$SHELL      # Standard-Shell (/bin/zsh)
$PWD        # Aktuelles Verzeichnis
$OLDPWD     # Vorheriges Verzeichnis (cd -)
$EDITOR     # Standard-Editor (nano, vim, code)
$LANG       # Sprache/Locale (de_DE.UTF-8)
$TERM       # Terminal-Typ (xterm-256color)
```

## PATH verwalten

```bash
# PATH anzeigen (lesbar)
echo $PATH | tr ':' '\n'

# Am Anfang hinzufügen (hat Vorrang)
export PATH="$HOME/bin:$PATH"

# Am Ende hinzufügen
export PATH="$PATH:/neuer/pfad"

# Mehrere Pfade
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# In ~/.zshrc für Permanenz
```

### Typische PATH-Einträge

```bash
# Homebrew (Apple Silicon)
export PATH="/opt/homebrew/bin:$PATH"

# Homebrew (Intel)
export PATH="/usr/local/bin:$PATH"

# Eigene Skripte
export PATH="$HOME/bin:$PATH"

# Node.js global
export PATH="$HOME/.npm-global/bin:$PATH"

# Python
export PATH="$HOME/.local/bin:$PATH"

# Go
export PATH="$HOME/go/bin:$PATH"
```

## Aliase

```bash
# Syntax
alias kurzname='langer befehl'

# Beispiele
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git-Aliase
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'

# Sicherheit
alias rm='rm -i'        # Nachfragen vor Löschen
alias cp='cp -i'        # Nachfragen vor Überschreiben
alias mv='mv -i'        # Nachfragen vor Überschreiben

# Convenience
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias df='df -h'
alias du='du -h'

# Alias anzeigen
alias ll          # Zeigt Definition
alias             # Zeigt alle

# Alias löschen
unalias ll
```

## Funktionen

```bash
# Einfache Funktion
greet() {
    echo "Hallo, $1!"
}
# Nutzung: greet Klaus

# Funktion mit mehreren Argumenten
mkcd() {
    mkdir -p "$1" && cd "$1"
}
# Nutzung: mkcd neuer-ordner

# Projektverzeichnis wechseln
p() {
    cd "$HOME/Projects/$1"
}
# Nutzung: p mein-projekt

# Git add, commit, push in einem
gacp() {
    git add .
    git commit -m "$1"
    git push
}
# Nutzung: gacp "Commit message"

# Schnell Notiz erstellen
note() {
    echo "$(date '+%Y-%m-%d %H:%M'): $*" >> ~/notes.txt
}
# Nutzung: note Das muss ich mir merken
```

## Prompt anpassen (Zsh)

### Einfache Prompts

```bash
# Standard
PROMPT='%n@%m %~ %# '

# Mit Farben
PROMPT='%F{cyan}%n%f@%F{green}%m%f:%F{yellow}%~%f$ '

# Minimalistisch
PROMPT='%F{blue}%~%f $ '

# Mit Zeit
PROMPT='[%T] %F{cyan}%~%f$ '
```

### Prompt-Variablen

| Code | Bedeutung |
|------|-----------|
| `%n` | Benutzername |
| `%m` | Hostname (kurz) |
| `%M` | Hostname (voll) |
| `%~` | Verzeichnis (~ für Home) |
| `%/` | Verzeichnis (voller Pfad) |
| `%T` | Zeit (24h) |
| `%t` | Zeit (12h) |
| `%D` | Datum |
| `%#` | # für root, % sonst |
| `%?` | Exit-Code des letzten Befehls |

### Farben

```bash
%F{farbe}text%f    # Vordergrund
%K{farbe}text%k    # Hintergrund

# Farben: black, red, green, yellow, blue, magenta, cyan, white
# Oder Nummern: %F{208} (orange)
```

## Oh My Zsh

```bash
# Installation
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Theme ändern (in ~/.zshrc)
ZSH_THEME="robbyrussell"    # Standard
ZSH_THEME="agnoster"        # Powerline-Style
ZSH_THEME="simple"          # Minimal

# Plugins aktivieren (in ~/.zshrc)
plugins=(
    git
    docker
    npm
    macos
    zsh-autosuggestions
    zsh-syntax-highlighting
)
```

## Änderungen übernehmen

```bash
# Datei neu laden
source ~/.zshrc
# oder Kurzform:
. ~/.zshrc

# Oder: Neues Terminal öffnen
```

## Nützliche Einstellungen

```bash
# In ~/.zshrc

# History-Einstellungen
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS      # Keine Duplikate
setopt HIST_IGNORE_SPACE     # Befehle mit Space am Anfang ignorieren
setopt SHARE_HISTORY         # History zwischen Sessions teilen

# Verzeichnis-Navigation
setopt AUTO_CD               # Verzeichnisname ohne cd
setopt AUTO_PUSHD            # cd pusht auf Stack
setopt CDABLE_VARS           # cd zu benannten Variablen

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# Korrektur
setopt CORRECT               # Befehle korrigieren
setopt CORRECT_ALL           # Auch Argumente korrigieren
```

## Dotfiles-Backup

```bash
# Wichtige Dotfiles sichern
cp ~/.zshrc ~/.zshrc.backup

# Dotfiles-Repository erstellen
cd ~
git init dotfiles
cd dotfiles
cp ~/.zshrc .
cp ~/.gitconfig .
git add .
git commit -m "Initial dotfiles"

# Symlinks erstellen
ln -sf ~/dotfiles/.zshrc ~/.zshrc
```
