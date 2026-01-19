#!/bin/zsh
# ==============================================================================
# macos-internals.sh - Die tiefen Geheimnisse von macOS
# ==============================================================================

echo "=== MACOS INTERNALS: UNTER DER HAUBE ==="
echo ""
echo "Dieses Skript zeigt dir die technischen Details deines macOS-Systems."
echo ""

# ==============================================================================
echo "=== 1. SYSTEM INTEGRITY PROTECTION (SIP) ==="
# ==============================================================================

echo "SIP schützt kritische System-Ordner vor Veränderungen."
echo "Selbst root kann dort nichts ändern!"
echo ""

# SIP Status prüfen
sip_status=$(csrutil status 2>/dev/null)
echo "SIP Status:"
echo "  $sip_status"
echo ""

echo "Von SIP geschützte Ordner:"
echo "  /System"
echo "  /bin"
echo "  /sbin"
echo "  /usr (außer /usr/local)"
echo ""

echo "Test: Versuche in /bin zu schreiben (sollte fehlschlagen):"
touch /bin/test_sip 2>&1 | head -1 || echo "  → Zugriff verweigert (SIP funktioniert!)"
echo ""

# ==============================================================================
echo "=== 2. APFS UND VOLUMES ==="
# ==============================================================================

echo "macOS nutzt APFS (Apple File System) seit High Sierra."
echo ""

echo "Deine APFS-Container und Volumes:"
diskutil apfs list 2>/dev/null | head -40 || echo "  (Fehler beim Auslesen)"
echo ""

echo "Alle gemounteten Dateisysteme:"
df -h | grep -E "^/dev|Filesystem"
echo ""

# ==============================================================================
echo "=== 3. FIRMLINKS (APFS-MAGIE) ==="
# ==============================================================================

echo "Seit Catalina (10.15) sind System und Daten auf getrennten Volumes."
echo "Firmlinks verbinden sie nahtlos."
echo ""

echo "System Volume (read-only, signiert):"
ls /System/Volumes/ 2>/dev/null || echo "  (Nicht verfügbar)"
echo ""

echo "Firmlink-Beispiele:"
echo "  /Users         →  Data Volume"
echo "  /Applications  →  Data Volume"
echo ""

# Prüfe ob wir auf APFS mit Firmlinks sind
if [[ -d /System/Volumes/Data ]]; then
    echo "Dein System nutzt APFS mit getrennten Volumes:"
    echo "  System: $(df -h / | tail -1 | awk '{print $1}')"
    echo "  Data:   $(df -h /System/Volumes/Data 2>/dev/null | tail -1 | awk '{print $1}')"
fi
echo ""

# ==============================================================================
echo "=== 4. DER BOOT-PROZESS ==="
# ==============================================================================

echo "So startet dein Mac:"
echo ""
echo "
  1. Firmware (iBoot auf Apple Silicon / EFI auf Intel)
     └── Prüft Hardware, lädt Boot-Loader

  2. Boot-Loader
     └── Lädt den Kernel (XNU)

  3. Kernel (XNU = X is Not Unix)
     └── Initialisiert Hardware, startet launchd

  4. launchd (PID 1)
     └── Der erste Prozess, startet alles andere
         ├── System-Daemons
         ├── Login-Window
         └── User-Session
"

echo "launchd ist der Ur-Prozess (PID 1):"
ps -p 1 -o pid,comm
echo ""

echo "Von launchd gestartete Dienste (Auswahl):"
launchctl list 2>/dev/null | head -10
echo "... ($(launchctl list 2>/dev/null | wc -l | tr -d ' ') insgesamt)"
echo ""

# ==============================================================================
echo "=== 5. KERNEL-INFORMATIONEN ==="
# ==============================================================================

echo "Kernel-Version (XNU):"
uname -a
echo ""

echo "Darwin-Version:"
sw_vers
echo ""

echo "Hardware-Architektur:"
arch=$(uname -m)
echo "  $arch"
if [[ $arch == "arm64" ]]; then
    echo "  → Apple Silicon (M-Serie)"
else
    echo "  → Intel-Prozessor"
fi
echo ""

# ==============================================================================
echo "=== 6. VERSTECKTE DATEIEN UND METADATEN ==="
# ==============================================================================

echo "macOS erstellt viele versteckte Dateien:"
echo ""

echo ".DS_Store - Finder-Einstellungen pro Ordner:"
ds_count=$(find ~ -name ".DS_Store" 2>/dev/null | wc -l | tr -d ' ')
echo "  Du hast $ds_count .DS_Store-Dateien in deinem Home"
echo ""

echo ".localized - Zeigt lokalisierte Ordnernamen:"
echo "  z.B. 'Desktop' wird auf Deutsch 'Schreibtisch'"
ls -la ~/Desktop/.localized 2>/dev/null && echo "  (vorhanden)" || echo "  (nicht vorhanden)"
echo ""

echo "Extended Attributes (xattr):"
echo "  macOS speichert Metadaten als erweiterte Attribute"
echo "  Beispiel für eine beliebige Datei:"
sample_file=$(find ~/Downloads -type f 2>/dev/null | head -1)
if [[ -n $sample_file ]]; then
    echo "  Datei: $sample_file"
    xattr "$sample_file" 2>/dev/null || echo "  (keine Attribute)"
else
    echo "  (keine Beispieldatei gefunden)"
fi
echo ""

# ==============================================================================
echo "=== 7. SPOTLIGHT UND INDEXIERUNG ==="
# ==============================================================================

echo "Spotlight-Index Status:"
mdutil -s / 2>/dev/null
echo ""

echo "Spotlight-Datenbank Speicherort:"
echo "  /.Spotlight-V100 (auf jedem Volume)"
ls -la /.Spotlight-V100 2>/dev/null | head -3 || echo "  (Zugriff verweigert oder nicht vorhanden)"
echo ""

# ==============================================================================
echo "=== 8. GATEKEEPER UND QUARANTÄNE ==="
# ==============================================================================

echo "Gatekeeper prüft heruntergeladene Apps."
echo ""

echo "Gatekeeper-Status:"
spctl --status 2>/dev/null || echo "  (Nicht verfügbar)"
echo ""

echo "Quarantäne-Attribut (com.apple.quarantine):"
echo "  Wird an Downloads aus dem Internet angehängt"
echo "  Löst den 'Diese App wurde aus dem Internet geladen'-Dialog aus"
echo ""

# ==============================================================================
echo "=== 9. SANDBOX UND ENTITLEMENTS ==="
# ==============================================================================

echo "Apps aus dem App Store laufen in einer Sandbox:"
echo "  - Eingeschränkter Zugriff auf Dateisystem"
echo "  - Kontrollierte Netzwerk-Zugriffe"
echo "  - Entitlements bestimmen Berechtigungen"
echo ""

echo "Sandbox-Container für Apps:"
ls ~/Library/Containers 2>/dev/null | head -5
echo "... ($(ls ~/Library/Containers 2>/dev/null | wc -l | tr -d ' ') Container insgesamt)"
echo ""

# ==============================================================================
echo "=== 10. SYSTEM-INFORMATIONEN ==="
# ==============================================================================

echo "Schnelle System-Übersicht:"
echo ""
echo "  macOS Version:     $(sw_vers -productVersion)"
echo "  Build:             $(sw_vers -buildVersion)"
echo "  Kernel:            $(uname -r)"
echo "  Hostname:          $(hostname)"
echo "  Uptime:            $(uptime | sed 's/.*up //' | sed 's/,.*//')"
echo "  Prozessor:         $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "Apple Silicon")"
echo "  RAM:               $(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 )) GB"
echo ""

# ==============================================================================
echo "=== ZUSAMMENFASSUNG ==="
# ==============================================================================

echo "
macOS Sicherheitsebenen:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. SIP         → Schützt System-Ordner
2. Gatekeeper  → Prüft App-Signaturen
3. Sandbox     → Isoliert App-Store-Apps
4. APFS SSV    → Signiertes System-Volume
5. Firmlinks   → Trennt System von Daten
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Dein Mac ist mehrfach geschützt!
"
