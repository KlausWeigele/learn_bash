# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Zweck dieses Repositories

Dies ist ein **Lern-Repository** für CLI-Befehle und Bash/Zsh-Programmierung - kein Softwareprodukt. Der Fokus liegt auf:

- **CLI-Tools verstehen**: `top`, `ps`, `grep`, `find`, `awk`, `sed`, `xargs`, etc.
- **Bash/Zsh-Scripting**: Variablen, Loops, Conditionals, Functions, Pipes
- **macOS-spezifisch**: Zsh als Standard-Shell, BSD-Varianten der Tools

## Arbeitsweise in diesem Repository

### Lernmaterialien erstellen
- Beispiel-Skripte in thematischen Ordnern organisieren (z.B. `process-management/`, `text-processing/`)
- Jedes Skript sollte ausführbar sein: `chmod +x script.sh`
- Shebang verwenden: `#!/bin/zsh` oder `#!/bin/bash`

### Skripte testen
```bash
# Skript ausführbar machen
chmod +x script.sh

# Skript ausführen
./script.sh

# Syntax prüfen ohne Ausführung
zsh -n script.sh
bash -n script.sh

# Debugging mit Trace-Output
zsh -x script.sh
bash -x script.sh
```

### ShellCheck für Qualität
```bash
# ShellCheck installieren (falls nicht vorhanden)
brew install shellcheck

# Skript prüfen
shellcheck script.sh
```

## Wichtige Hinweise für Claude

- **Keine Produktentwicklung**: Keine komplexen Architekturen oder Frameworks nötig
- **Didaktischer Fokus**: Code-Beispiele sollen lehrreich und gut kommentiert sein
- **macOS-Kontext**: Klaus arbeitet auf Darwin/macOS mit Zsh
- **Interaktives Lernen**: Erkläre CLI-Befehle detailliert mit Beispielen und Optionen
