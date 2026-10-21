#!/bin/bash
# Relatorio de custo por projeto (versao corrigida de relatorio_quebrado.sh)
# Uso: relatorio_corrigido.sh ARQUIVO_CSV PROJETO
arquivo=$1

projeto=$2

if [ -z "$projeto" ]; then                 
    echo "uso: $0 arquivo projeto"
    exit 1
fi

if [ ! -f "$arquivo" ]; then               
    echo "arquivo nao encontrado: $arquivo"
    exit 2
fi

total=0

linhas=0

while IFS=, read -r id data inst proj regiao flavor so cpu mem horas custo status amb equipe; do
    [ "$proj" = "$projeto" ] || continue   
    total=$(echo "$total + $custo" | bc)
    linhas=$((linhas + 1))
done < <(tail -n +2 "$arquivo")
echo "Projeto $projeto: $linhas registros, custo total R\$ $total"
