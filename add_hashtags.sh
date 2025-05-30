#!/bin/bash

source Universalvariable.sh
# Verarbeite alle .md Dateien im Ordner
find "$MD_VERZ" -type f -name "*.md" -print0 | while IFS= read -r -d '' file; do
    # Erstelle temporäre Datei
    temp_file=$(mktemp)
    
    # Lese die Wörter aus der Auswahldatei
    while IFS= read -r wort; do
        # Entferne Leerzeichen am Anfang und Ende
        wort=$(echo "$wort" | xargs)
        # Überspringe leere Zeilen
        [ -z "$wort" ] && continue
        
        # Füge Hashtag vor dem Wort ein, wenn es noch nicht mit # beginnt
        sed -i "s/\b$wort\b/#$wort/g" "$file"
    done < "$ARB/1.txt"
    
    echo "Verarbeitet: $file"
done

echo "Fertig! Alle Markdown-Dateien wurden aktualisiert." 