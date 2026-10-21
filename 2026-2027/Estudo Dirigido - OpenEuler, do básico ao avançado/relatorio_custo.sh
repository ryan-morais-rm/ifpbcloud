#!/bin/bash
# relatorio_custo.sh - custo por projeto/dia a partir do CSV do laboratorio
# Codigos de saida: 0 ok | 2 uso incorreto | 3 arquivo inexistente
CSV=/opt/nuvemif/dados/uso_nuvem.csv
PROJETO=""; DATA=""

uso() {
    cat >&2 <<USO
uso: $(basename "$0") [-p PROJETO] [-d AAAA-MM-DD] [-a ARQUIVO.csv] [-h]
  -p PROJETO  custo e numero de registros do projeto
  -d DATA     custo e instancias ativas (status running) no dia
  -a ARQUIVO  CSV alternativo (padrao: $CSV)
  -h          esta ajuda
  sem opcoes: custo total
USO
}

while getopts ":p:d:a:h" opt; do
    case $opt in
        p) PROJETO=$OPTARG ;;
        d) DATA=$OPTARG ;;
        a) CSV=$OPTARG ;;
        h) uso; exit 0 ;;
        :) echo "opcao -$OPTARG requer argumento" >&2; uso; exit 2 ;;
        *) echo "opcao invalida: -$OPTARG" >&2; uso; exit 2 ;;
    esac
done

[[ -f $CSV ]] || { echo "arquivo nao encontrado: $CSV" >&2; exit 3; }

if [[ -n $PROJETO ]]; then
    awk -F, -v p="$PROJETO" 'NR>1 && $4==p {c+=$11; n++}
        END {printf "Projeto %s: %d registros, custo %.2f\n", p, n, c}' "$CSV"
elif [[ -n $DATA ]]; then
    awk -F, -v d="$DATA" 'NR>1 && $2==d {c+=$11; if ($12=="running") a[$3]=1}
        END {printf "Dia %s: custo %.2f, %d instancias ativas\n", d, c, length(a)}' "$CSV"
else
    awk -F, 'NR>1 {c+=$11} END {printf "Custo total: %.2f\n", c}' "$CSV"
fi
