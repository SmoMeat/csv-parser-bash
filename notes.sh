#!/bin/bash

# Separe la 1e ligne aux virgules
IFS=',' read -r -a pairs <<< $(head -n 1 $1)

# Assigne la ponderation (val) a chaque examen (var)
for pair in "${pairs[@]:2}"; do
    var_name=$(echo "$pair" | cut -d'(' -f1)
    var_value=$(echo "$pair" | cut -d'(' -f2 | cut -d')' -f1)
    declare "ponderation_$var_name=$var_value"
done

echo "Code permanent,Nom,Note ponderee" > notes.csv

while IFS=',' read -r CODE NOM TP1 INTRA TP2 TP3 FINAL TP4; do
    if [[ $CODE != "Code permanent" ]]; then
        NOTE_PONDEREE=$(echo "scale=2; ($TP1 * $ponderation_TP1 + $INTRA * $ponderation_Intra + $TP2 * $ponderation_TP2 + $TP3 * $ponderation_TP3 + $FINAL * $ponderation_Final + $TP4 * $ponderation_TP4) / ($ponderation_TP1 + $ponderation_Intra + $ponderation_TP2 + $ponderation_TP3 + $ponderation_Final + $ponderation_TP4)" | bc)
	echo "$CODE,$NOM,$NOTE_PONDEREE"
    fi
done < "$1" >> notes.csv

echo "Les notes sont accessibles dans le fichier notes.csv"
