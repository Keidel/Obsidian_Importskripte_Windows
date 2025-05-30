#!/bin/bash

source Universalvariable.sh 

zerlegen_woerter () { tr -cs "[:alpha:]" "\n" ; }

rausfiltern_wortliste () {
          #rausfiltern am Anfang Jahreszahl und Kombi klein-groß und klein-klein-Buchstaben
          pcregrep -v "^[a-z][A-Z]|^[a-z][a-z]|^\D?\D{0}$"
 }

wortliste_neu_erzeugen () {
    echo "Wortliste gesamt neu erzeugen"
     #Gesamt
     find $MD_VERZ -iname "*.md" -exec cat {} \; | zerlegen_woerter | rausfiltern_wortliste | sort -f | uniq -i > "$ARB"/wortliste_gesamt.txt

     #Häufigkeit
     find $MD_VERZ -iname "*.md" -exec cat {} \; | zerlegen_woerter | rausfiltern_wortliste | sort -f | uniq -c | sort -nr | awk -F" " '{print $2 "  -  " $1}' > "$ARB"/woerter_haufigkeit.txt

     cat "$ARB"/woerter_haufigkeit.txt | grep -Ev -f "$ARB"/stopwoerter.txt   > "$ARB"/woerter_auswahl.txt

     cat  "$ARB"/woerter_auswahl.txt | awk -F"-" '{print $1}' > "$ARB"/1.txt
}

 #---------------------------------------
 wortliste_neu_erzeugen