#!/bin/bash

header=$(head -n 1 "$1")
IFS=',' read -ra noms_colonnes <<< "$header"

# Extraire les pondérations des noms de colonnes
declare -A pondération  # Tableau associatif pour stocker les pondérations
for colonne in "${noms_colonnes[@]}"; do
    if [[ $colonne =~ ([A-Za-z0-9]+)\(([0-9.]+)\) ]]; then
        nom_colonne="${BASH_REMATCH[1]}"
        valeur_pondération="${BASH_REMATCH[2]}"
        pondération["$nom_colonne"]="$valeur_pondération"
    fi
done

# Créer le fichier notes.csv avec les notes pondérées
fichier_sortie="notes.csv"
echo "Code permanent,Nom,$header,Total" > "$fichier_sortie"

calculer_note_pondérée() {
    # On commence à partir de la deuxième colonne (après "Code permanent" et "Nom")
    local total=0
    local nb_colonnes=${#noms_colonnes[@]}
    local i=2  
    
    while [ $i -lt $nb_colonnes ]; do
        local nom_colonne="${noms_colonnes[$i]}"
        local valeur=$(echo "$1" | cut -d ',' -f $((i+1)))
        local pondération_colonne=${pondération["$nom_colonne"]}
        total=$(echo "scale=4; $total + ($valeur * $pondération_colonne)" | bc)
        ((i++))
    done
    
    echo "scale=4; $total / 100" | bc  # Diviser par 100 pour obtenir la note finale
}

# Lire le fichier liste.csv et calculer les notes pondérées pour chaque étudiant
tail -n +2 "$1" | while IFS=',' read -r code nom scores; do
    note_pondérée=$(calculer_note_pondérée "$code,$nom,$scores")
    echo "$code,$nom,$scores,$note_pondérée" >> "$fichier_sortie"
done

echo "Fichier '$fichier_sortie' généré avec les notes pondérées."
