# Obsidian_Importskripte_Windows

Diese Dokumentation beschreibt die verschiedenen Skripte, die für die Verarbeitung und den Import von Dateien in Obsidian verwendet werden.

## Verzeichnisstruktur

Die Skripte arbeiten mit folgenden Verzeichnissen:
- `/home/petra/Zubehoer_Obsidian/txt_dateien`: Quellverzeichnis für Textdateien
- `/home/petra/Zubehoer_Obsidian/eml_dateien`: Quellverzeichnis für E-Mail-Dateien
- `/home/petra/Zubehoer_Obsidian/Markdown_Dateien`: Zielverzeichnis für Markdown-Dateien
- `/home/petra/Zubehoer_Obsidian/Arbeitsdateien`: Verzeichnis für temporäre Arbeitsdateien

## Skripte im Detail

### Universalvariable.sh
Dieses Skript definiert die grundlegenden Verzeichnispfade und Variablen, die von allen anderen Skripten verwendet werden. Es muss vor der Ausführung anderer Skripte eingebunden werden.

### eml_zu_md.sh
Konvertiert E-Mail-Dateien (.eml) in Markdown-Format. Das Skript:
- Verarbeitet E-Mail-Dateien aus dem EML-Quellverzeichnis
- Konvertiert sie in Markdown-Format
- Speichert die konvertierten Dateien im Markdown-Verzeichnis

### txt_vorbereiten.sh
Bereitet Textdateien für die Konvertierung in Markdown vor. Das Skript:
- Verarbeitet Textdateien aus dem TXT-Quellverzeichnis
- Führt Vorbereitungsarbeiten durch
- Erstellt eine vorbereitete Version für die weitere Verarbeitung

### md_zerlegen.sh
Teilt große Markdown-Dateien in einzelne Wörter auf. Das Skript:
- Analysiert Markdown-Dateien
- Teilt sie nach bestimmten Kriterien in Wörter auf
- Erstellt Datei `woerter_auswahl.txt` zur Weiterverwendung
- schliesst Wörter aus 

### eigenschaften_ergaenzen.sh
Ergänzt Markdown-Dateien um zusätzliche Eigenschaften und Metadaten. Das Skript:
- Fügt YAML-Frontmatter hinzu
- Ergänzt Tags und Kategorien
- Aktualisiert bestehende Metadaten

### add_hashtags.sh
Fügt Hashtags zu bestimmten Wörtern in Markdown-Dateien hinzu. Das Skript:
- Liest eine Liste von Wörtern aus der Datei `woerter_auswahl.txt`
- Sucht diese Wörter in allen Markdown-Dateien
- Fügt ein # vor jedem gefundenen Wort ein
- Berücksichtigt dabei nur vollständige, großgeshriebene Wörter

## Verwendung

1. Stellen Sie sicher, dass die Verzeichnisstruktur korrekt eingerichtet ist
2. Führen Sie die Skripte in der folgenden Reihenfolge aus:
   - `eml_zu_md.sh` oder `txt_vorbereiten.sh` (je nach Quelldateityp)
   -  `eigenschaften_ergaenzen.sh`
   - `md_zerlegen.sh` (falls erforderlich)
   - `add_hashtags.sh`

## Hinweise

- Verzeichnisstruktur s Universalvariable.sh

