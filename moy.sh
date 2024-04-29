#!/bin/bash
# moy.sh script
# Génère à partir d'un fichier csv de notes d'éléves passer en 
# paramètre un second fichier avec la note finale pondéré
# Mathieu Ducharme, Thomas Coté, Thomas Racine

# Separe la 1e ligne aux virgules
IFS=',' read -r -a pairs <<< $(head -n 1 $1)

# Crée une liste des pondérations des examens
ponderation=()
for pair in "${pairs[@]:2}"; do
    var_name=$(echo "$pair" | cut -d'(' -f1)
    var_value=$(echo "$pair" | cut -d'(' -f2 | cut -d')' -f1)
    ponderation+=( $var_value )
done

# Pondération total (utile pour la moyenne)
IFS='+' ponderation_totale=$(echo "scale=2; ${ponderation[*]}" | bc)

echo "Code permanent,Nom,Note ponderee" > notes.csv

calcul_ponderation() {
    local elements=("$@")
    local sum=0
    local i=0
    for element in "${elements[@]:2}"; do
        note=$(echo $element*${ponderation[$i]} | bc)
	    sum=$(echo "scale=2; ($sum + $note)" | bc)
        ((i++))
    done
    echo $(echo "scale=2; ($sum / $ponderation_totale)" | bc)
}

while IFS=, read -ra elements; do
    note_ponderee=$(calcul_ponderation "${elements[@]}")
    echo ${elements[0]} ${elements[1]} $note_ponderee
done < <(tail -n +2 $1) >> notes.csv

echo "Les notes sont accessibles dans le fichier notes.csv"
