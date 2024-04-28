#!/bin/bash

# Input string
input_string=$(head -n 1 liste.csv)

# Separe la 1e ligne aux virgules
IFS=',' read -r -a pairs <<< "$input_string"

# Assigne la ponderation (val) a chaque examen (var)
for pair in "${pairs[@]:2}"; do
    var_name=$(echo "$pair" | cut -d'(' -f1)
    var_value=$(echo "$pair" | cut -d'(' -f2 | cut -d')' -f1)
    declare "ponderation_$var_name=$var_value"
done

# Print les variables de ponderations
for var in $(declare -p); do
    #echo $var
    if [[ $var == ponderation_* ]]; then
	echo $var
    fi
done

