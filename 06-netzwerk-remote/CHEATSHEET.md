# Netzwerk & Remote Cheatsheet

## curl - Daten übertragen

```bash
# GET Request
curl https://example.com
curl -s https://example.com          # Silent (kein Progress)
curl -o datei.html https://example.com  # In Datei speichern
curl -O https://example.com/file.zip    # Original-Dateiname behalten

# Header anzeigen
curl -I https://example.com          # Nur Header
curl -i https://example.com          # Header + Body

# POST Request
curl -X POST https://api.example.com/data
curl -d "name=Klaus&age=30" https://api.example.com/form
curl -d '{"name":"Klaus"}' -H "Content-Type: application/json" https://api.example.com/json

# Authentication
curl -u user:password https://api.example.com
curl -H "Authorization: Bearer TOKEN" https://api.example.com

# Weitere Optionen
curl -L https://example.com          # Redirects folgen
curl -k https://example.com          # SSL-Fehler ignorieren (Vorsicht!)
curl -A "My User Agent" https://example.com  # User-Agent setzen
curl --max-time 10 https://example.com       # Timeout 10 Sekunden
```

## wget - Dateien herunterladen

```bash
# Einfacher Download
wget https://example.com/file.zip

# Mit anderem Dateinamen speichern
wget -O neuername.zip https://example.com/file.zip

# Im Hintergrund
wget -b https://example.com/large-file.zip

# Ganze Webseite rekursiv (Mirror)
wget -m -p -k https://example.com
```

## SSH - Secure Shell

```bash
# Verbinden
ssh user@hostname
ssh user@hostname -p 2222           # Anderer Port
ssh -i ~/.ssh/key user@hostname     # Spezifischer Key

# Befehl remote ausführen
ssh user@hostname "ls -la"
ssh user@hostname "cd /var/log && tail -f syslog"

# Tunnel (Port Forwarding)
ssh -L 8080:localhost:80 user@server   # Lokal: Server-Port 80 auf localhost:8080
ssh -R 9000:localhost:3000 user@server # Remote: Dein Port 3000 auf Server:9000
ssh -D 1080 user@server                # SOCKS Proxy

# Hintergrund/Keep-alive
ssh -N -f user@hostname               # Nur Tunnel, kein Terminal
ssh -o ServerAliveInterval=60 user@hostname  # Keep-alive alle 60s
```

## SSH-Keys

```bash
# Key generieren
ssh-keygen -t ed25519 -C "email@example.com"    # Modern (empfohlen)
ssh-keygen -t rsa -b 4096 -C "email@example.com" # RSA (kompatibel)

# Public Key auf Server kopieren
ssh-copy-id user@hostname
ssh-copy-id -i ~/.ssh/mykey.pub user@hostname

# Manuell: Key anzeigen und kopieren
cat ~/.ssh/id_ed25519.pub
```

## SCP - Secure Copy

```bash
# Lokal → Remote
scp datei.txt user@hostname:/pfad/
scp -r ordner/ user@hostname:/pfad/   # Rekursiv (Ordner)

# Remote → Lokal
scp user@hostname:/pfad/datei.txt ./
scp -r user@hostname:/pfad/ordner/ ./

# Mit Port
scp -P 2222 datei.txt user@hostname:/pfad/
```

## rsync - Intelligentes Synchronisieren

```bash
# Lokal → Remote
rsync -avz ordner/ user@hostname:/pfad/ordner/

# Remote → Lokal
rsync -avz user@hostname:/pfad/ordner/ ./ordner/

# Optionen
rsync -a ...    # Archive (Berechtigungen, Timestamps, etc.)
rsync -v ...    # Verbose
rsync -z ...    # Kompression
rsync -n ...    # Dry-run (nur anzeigen, nichts tun)
rsync --delete ...  # Gelöschte Dateien auch remote löschen
rsync --exclude '*.log' ...  # Dateien ausschließen
rsync --progress ...         # Fortschritt anzeigen
```

## Netzwerk-Diagnose

```bash
# Erreichbarkeit testen
ping hostname
ping -c 5 hostname              # Nur 5 Pakete

# Route verfolgen
traceroute hostname

# DNS-Auflösung
nslookup hostname
dig hostname
host hostname

# Offene Verbindungen
netstat -an                     # Alle Verbindungen
netstat -an | grep LISTEN       # Nur lauschende Ports
lsof -i                         # Prozesse mit Netzwerk
lsof -i :8080                   # Wer nutzt Port 8080?

# Lokale IP herausfinden
ifconfig | grep "inet "
ipconfig getifaddr en0          # macOS: WLAN
```

## Schnelle Server starten

```bash
# Python HTTP-Server
python3 -m http.server 8000
python3 -m http.server 8000 --bind 127.0.0.1  # Nur lokal

# PHP Server (wenn installiert)
php -S localhost:8000

# Node.js (mit npx)
npx serve
npx http-server
```

## ~/.ssh/config - SSH vereinfachen

```bash
# ~/.ssh/config
Host meinserver
    HostName 192.168.1.100
    User klaus
    Port 22
    IdentityFile ~/.ssh/id_ed25519

Host prod
    HostName production.example.com
    User deploy
    IdentityFile ~/.ssh/deploy_key
```

Danach einfach: `ssh meinserver` statt `ssh klaus@192.168.1.100`

## Nützliche Kombinationen

```bash
# JSON-API abfragen und formatieren
curl -s https://api.github.com/users/octocat | jq .

# Datei herunterladen mit Fortschritt
curl -# -O https://example.com/large-file.zip

# Prüfen ob Website online
curl -s -o /dev/null -w "%{http_code}" https://example.com

# Öffentliche IP herausfinden
curl -s https://ifconfig.me
curl -s https://ipinfo.io/ip
```
