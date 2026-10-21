#!/bin/bash
# grava PROJETO.txt (registros e custo) para cada projeto do CSV
set -euo pipefail

CSV=${1:-/opt/nuvemif/dados/uso_nuvem.csv}

DESTINO=${2:-/srv/dados/relatorios}

TMP=$(mktemp)

trap 'rm -f "$TMP"' EXIT                      

[[ -f $CSV ]] || { echo "erro: CSV nao encontrado: $CSV" >&2; exit 2; }

calcula() {                                   
    awk -F, -v p="$1" 'NR>1 && $4==p {c+=$11; n++} END {printf "%d %.2f", n, c}' "$CSV"
}

mkdir -p "$DESTINO"
tail -n +2 "$CSV" | cut -d, -f4 | sort -u > "$TMP"
gerados=0
while read -r proj; do
    read -r n custo <<< "$(calcula "$proj")"
    printf 'Projeto: %s\nRegistros: %s\nCusto total (R$): %s\n' "$proj" "$n" "$custo" > "$DESTINO/$proj.txt"
    gerados=$((gerados + 1))
done < "$TMP"
echo "$gerados arquivos gerados em $DESTINO"
