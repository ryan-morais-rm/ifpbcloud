#!/bin/bash
# alerta_erros.sh [LIMITE] [LOG] - lista dias com mais de LIMITE erros (padrao 25)
# Saida 1 se algum dia passar do limite, 0 caso contrario.
LIMITE=${1:-25}
LOG=${2:-/opt/nuvemif/logs/coletor.log}
[[ -f $LOG ]] || { echo "log nao encontrado: $LOG" >&2; exit 2; }

saida=$(awk -v lim="$LIMITE" '/\[ERROR\]/ {c[$1]++}
    END {for (d in c) if (c[d] > lim) printf "%s: %d erros\n", d, c[d]}' "$LOG" | sort)
if [[ -n $saida ]]; then
    echo "$saida"
    exit 1
fi
exit 0
