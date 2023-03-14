#!/bin/bash

# Überprüfen, ob Wine installiert ist
if ! [ -x "$(command -v wine)" ]; then
  echo "Fehler: Wine ist nicht installiert." >&2
  exit 1
fi

# Überprüfen, ob die Wine-Sandbox installiert ist
if ! [ -x "$(command -v firejail)" ]; then
  echo "Fehler: Firejail (Wine-Sandbox) ist nicht installiert." >&2
  exit 1
fi

# Pfad zur Wine-Installation
wine_path=$(which wine)

# Sandbox-Konfigurationsdatei erstellen
sandbox_config_file="$HOME/.config/firejail/wine.profile"
if ! [ -f "$sandbox_config_file" ]; then
  echo "include /etc/firejail/wine.profile" > "$sandbox_config_file"
  echo "whitelist ~/.wine" >> "$sandbox_config_file"
fi

# Wine mit der Sandbox ausführen
firejail --profile="$sandbox_config_file" "$wine_path" "$@"
