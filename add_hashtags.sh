#!/bin/bash

# Setze den Zielordner
TARGET_DIR="/home/petra/Zubehoer_Obsidian/Markdown_Dateien"

# Überprüfe, ob der Ordner existiert
if [ ! -d "$TARGET_DIR" ]; then
    echo "Fehler: Ordner $TARGET_DIR existiert nicht!"
    exit 1
fi

# Verarbeite alle .md Dateien im Ordner
find "$TARGET_DIR" -type f -name "*.md" -print0 | while IFS= read -r -d '' file; do
    # Erstelle temporäre Datei
    temp_file=$(mktemp)
    
    # Verarbeite die Datei:
    # 1. Finde Wörter, die mit einem Großbuchstaben beginnen
    # 2. Füge eine Raute davor ein
    # 3. Ignoriere bereits mit Raute markierte Wörter
    sed -E 's/([^#])\b([A-ZÄÖÜ][a-zäöüß]*)\b/\1#\2/g' "$file" > "$temp_file"
    
    # Ersetze die Originaldatei mit der bearbeiteten Version
    mv "$temp_file" "$file"
    
    echo "Verarbeitet: $file"
done

echo "Fertig! Alle Markdown-Dateien wurden aktualisiert." 