#!/bin/bash

# Dieses Skript konvertiert .eml-Dateien in Markdown-Dateien


# Verzeichnisse für Ein- und Ausgabe
SOURCE_DIR="/home/petra/Bash_Uebungen/Materialien_Obsidian/eml_dateien"
TARGET_DIR="/home/petra/Bash_Uebungen/Materialien_Obsidian/Markdown_Dateien"

# Temporäres Verzeichnis für die Extraktion der E-Mail-Inhalte
# $$ fügt die Prozess-ID hinzu, um Konflikte zu vermeiden
TMP_DIR="/tmp/ripmime_extract_$$"

# Prüfen, ob das Quellverzeichnis existiert
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Quellverzeichnis $SOURCE_DIR existiert nicht"
    exit 1
fi

# Prüfen, ob das Zielverzeichnis existiert, sonst erstellen
if [ ! -d "$TARGET_DIR" ]; then
    echo "Erstelle Zielverzeichnis $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

# Prüfen, ob ripmime installiert ist
# ripmime ist ein Tool zum Extrahieren von MIME-Inhalten aus E-Mails
if ! command -v ripmime &> /dev/null; then
    echo "Error: ripmime ist nicht installiert. Bitte installieren Sie es zuerst."
    exit 1
fi

# Erstellen des temporären Verzeichnisses für die Extraktion
mkdir -p "$TMP_DIR"

# Zähler für die fortlaufende Nummerierung der Ausgabedateien
counter=1

# Durchlaufe alle .eml-Dateien im Verzeichnis
for eml_file in "$SOURCE_DIR"/*.eml; do
    if [ -f "$eml_file" ]; then
        # Extrahiere Metadaten (Absender und Datum)
        from=$(grep -i "^From:" "$eml_file" | sed 's/^From: //')
        date=$(grep -i "^Date:" "$eml_file" | sed 's/^Date: //')
        
        # Formatiere das Datum für den Dateinamen (YYYY-MM-DD)
        # Extrahiere das Datum aus dem Date-Header und konvertiere es
        filedate=$(date -d "$date" +"%Y-%m-%d" 2>/dev/null)
        if [ $? -ne 0 ]; then
            # Fallback: Verwende das aktuelle Datum, wenn die Konvertierung fehlschlägt
            filedate=$(date +"%Y-%m-%d")
        fi
        
        # Erstelle den Namen für die neue Markdown-Datei mit Nummer, Datum und Mail-Suffix
        md_file="$TARGET_DIR/${filedate}_Mail_${counter}.md"
        
        # Extrahiere den Betreff und ersetze Leerzeichen durch Unterstriche
        subject=$(grep -i "^Subject:" "$eml_file" | sed 's/^Subject: //' | tr ' ' '_')
        
        # Extrahiere den E-Mail-Inhalt mit ripmime
        # Lösche zuerst alte Dateien im temporären Verzeichnis
        rm -f "$TMP_DIR"/*
        # Extrahiere den Inhalt in das temporäre Verzeichnis
        ripmime -i "$eml_file" -d "$TMP_DIR" > /dev/null 2>&1
        
        # Suche nach der ersten Textdatei (plain text)
        # file --mime-type bestimmt den MIME-Typ jeder Datei
        # grep 'text/plain' filtert nach Textdateien
        # head -n1 nimmt die erste gefundene Datei
        textfile=$(find "$TMP_DIR" -type f -exec file --mime-type {} + | grep 'text/plain' | head -n1 | cut -d: -f1)
        
        # Wenn eine Textdatei gefunden wurde, lese ihren Inhalt
        # Sonst setze einen Platzhaltertext
        if [ -n "$textfile" ]; then
            body=$(cat "$textfile")
        else
            body="[Kein Textteil gefunden]"
        fi
        
        # Erstelle die Markdown-Datei mit formatierter Struktur
        {
            echo "# $subject"                    # Titel (Betreff)
            echo ""
            echo "## Metadaten"                  # Metadaten-Bereich
            echo "- Von: $from"                  # Absender
            echo "- Datum: $date"                # Datum
            echo ""
            echo "## E-Mail Inhalt"              # Inhalt-Bereich
            echo ""
            echo "$body"                         # E-Mail-Inhalt
        } > "$md_file"
        
        # Ausgabe der Konvertierungsinformation
        echo "Konvertiert: $(basename "$eml_file") -> $(basename "$md_file")"
        
        # Erhöhe den Zähler für die nächste Datei
        ((counter++))
    fi
done

# Aufräumen: Lösche das temporäre Verzeichnis
echo "Konvertierung abgeschlossen! $((counter-1)) Dateien wurden konvertiert."
rm -rf "$TMP_DIR" 