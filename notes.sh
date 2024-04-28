#!/bin/bash

HEADER=$(head -n 1 liste.csv)
REGEX="([A-Za-z0-9]+)\(([0-9.]+)\)"

definir_ponderation() {
    local HEADER="$1"
    while [[ $HEADER =~ $REGEX ]]; do
        local VARIABLE="${BAS_REMATCH[1]}"
        local VALEUR="${BAS_REMATCH[2]}"
        echo "$VARIABLE=$VALEUR"
        declare "$VARIABLE=$VALEUR"
        HEADER="${HEADER/${BASH_REMATCH[0]}/}"
    done
}
#definir_ponderation "$HEADER"

# Définition des pondérations
# Faire en sorte que ca se calcule tout seul
POND_TP1=7.5
POND_INTRA=3
POND_TP2=3
POND_TP3=3
POND_FINAL=3
POND_TP4=3

echo $POND_TP1
echo $POND_TP2
echo $POND_FINAL

while IFS=',' read -r CODE NOM TP1 INTRA TP2 TP3 FINAL TP4; do
    if [[ $CODE != "Code permanent" ]]; then
        NOTE_PONDEREE=$(echo "scale=2; ($TP1 * $POND_TP1 + $INTRA * $POND_INTRA + $TP2 * $POND_TP2 + $TP3 * $POND_TP3 + $FINAL * $POND_FINAL + $TP4 * $POND_TP4) / ($POND_TP1 + $POND_INTRA + $POND_TP2 + $POND_TP3 + $POND_FINAL + $POND_TP4)" | bc)
	echo "$CODE,$NOM,$NOTE_PONDEREE"
    fi
done < "$1" > notes.csv
