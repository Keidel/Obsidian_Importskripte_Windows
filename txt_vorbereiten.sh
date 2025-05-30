#!/bin/bash

#rm txt_dateien/*.txt
# Definiere eine Trennlinie für bessere Lesbarkeit der Ausgaben
#linie=$(echo -e " \n--------------------------------------------\n")

source Universalvariable.sh

# Funktion zum Umbenennen von Dateien mit Erstellungsdatum
rename_with_date() {
    local file="$1"
    local date_format="%d_%m_%Y"
    
    
    # Versuche zuerst das Erstellungsdatum zu bekommen, sonst das Änderungsdatum
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Für macOS Systeme
        date_str=$(stat -f "%Sm" -t "$date_format" "$file")
    else
        # Für Linux und andere Unix-ähnliche Systeme
        date_str=$(stat -c "%y" "$file" | cut -d' ' -f1 | tr '-' '_')
    fi
    
    # Extrahiere Verzeichnis und Dateinamen
    dir=$(dirname "$file")
    filename=$(basename "$file")
    
    # Erstelle neuen Dateinamen mit Datumspräfix
    new_filename="${date_str}_${filename}"
    
    # Benenne die Datei um
    mv "$file" "${dir}/${new_filename}"
    #echo "Dateiname bereinigt: $filename -> $new_filename"
}
#----------------------------------------------------------------------------------
# Verarbeite alle .txt Dateien im aktuellen Verzeichnis und Unterverzeichnissen
tput clear

find $QUELLE_TXT -type f -name "*.txt" | while read -r file
do
    rename_with_date "$file"
    #echo -e  "$file"
done
echo -e "$linie\ntxt-Dateien wurden umbenannt \n$linie"


# Funktion zur Konvertierung von Dateinamen (Umlaute, Leerzeichen etc.)
convert_filename () {
    local filename="$1"
    # Konvertiere Umlaute
    filename=$(echo "$filename" |  sed   's/ä/ae/g; s/ö/oe/g; s/ü/ue/g; s/Ä/Ae/g; s/Ö/Oe/g; s/Ü/Ue/g; s/ß/ss/g;s/\-/_/g;s/\=//g')
    # Entferne Leerzeichen und konvertiere zu Kleinbuchstaben
    filename=$(echo "$filename" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
    echo "$filename"
}

# Verarbeite jede .txt Datei
for txt_file in $QUELLE_TXT/*.txt; do
    if [ -f "$txt_file" ]; then
        # Extrahiere Basis-Dateinamen ohne Erweiterung
        base_name=$(basename "$txt_file"| awk -F. '{print $1}' | sed 's/__/_/g')
        # Konvertiere den Dateinamen
        new_name=$(convert_filename "$base_name")
        # Erstelle Ausgabedateipfad
        output_file="$MD_VERZ/${new_name}.md"
        
        # Verarbeite den Dateiinhalt
        {
            # Erste Zeile als Überschrift lesen
            if IFS= read -r first_line; then
                echo "# $first_line"
                echo
            fi
            
            # Verarbeite die restlichen Zeilen
            while IFS= read -r line; do
                # Konvertiere nummerierte Listen (z.B. "1. Item" zu "1. Item")
                if [[ $line =~ ^[0-9]+[\.\)]\  ]]; then
                    echo "$line"
                # Konvertiere Spiegelstriche zu Aufzählungspunkten
                elif [[ $line =~ ^- ]]; then
                    echo "*${line#-}"
                else
                    echo "$line"
                fi
            done
        } < "$txt_file" > "$output_file"
        
       # echo "konvertiert  $txt_file -> $output_file"
    fi
done

echo -e "$linie\ntxt-Dateien in Verzeichnis Markdown_Dateien verschoben\n$linie"

./eigenschaften_ergaenzen.sh