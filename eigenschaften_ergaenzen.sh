#!/bin/bash

source Universalvariable.sh 

# Verarbeite jede Markdown-Datei
for file in "$MD_VERZ"/*.md; do
    if [ -f "$file" ]; then
        # Extrahiere Dateinamen ohne Pfad und Erweiterung für den Titel
        filename=$(basename "$file" | awk -F. '{print $1}')
        jahr=$(basename "$file".md | awk -F_ '{print $1}')
        # Erstelle temporäre Datei
        temp_file=$(mktemp)
        
        # Füge YAML-Frontmatter hinzu
        echo "---" > "$temp_file"
        echo "Titel: $filename" >> "$temp_file"
        echo "Erstellung: $jahr" >> "$temp_file"
        echo "Datum:" >> "$temp_file"
        echo "Priorität:" >> "$temp_file"
        echo "Status:" >> "$temp_file"
        echo "Tags:" >> "$temp_file"
        echo "---" >> "$temp_file"
        
        # Füge den ursprünglichen Inhalt hinzu
        cat "$file" >> "$temp_file"
        
        # Ersetze die Originaldatei mit dem neuen Inhalt
        mv "$temp_file" "$file"
        
        #echo "Eigenschaften ergänzt für  $file"
    fi
done

echo -e  "$linie\nEigenschaften wurden ergänzt \n$linie"

./zerlegen_md.sh