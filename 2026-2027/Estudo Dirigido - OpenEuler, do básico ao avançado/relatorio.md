# Relatório — OpenEuler
---

# MÓDULO 1 — Primeiros passos

## T1.1 Identificar o sistema
```bash
cat /etc/os-release
uname -r ; uname -m
hostnamectl
```
- `/etc/os-release`: arquivo padrão (freedesktop) com nome/versão da distro; scripts leem `ID` e `VERSION_ID`.
- `uname -r` = versão do kernel; `uname -m` = arquitetura da CPU.
- `hostnamectl` = consulta o `systemd-hostnamed`: mostra hostname, machine-id, virtualização, kernel e SO **num só lugar**.

**(Sistema):** `ID="openEuler"`, `VERSION_ID="24.03"`, kernel `6.6.0-159.4.3.154.oe2403sp4.x86_64`, `x86_64`.
**Comparação:** `os-release` só descreve a distribuição; `hostnamectl` repete SO/kernel e acrescenta hostname (aqui `localhost`, *Static hostname: unset*), *Virtualization: oracle* (VirtualBox), chassis `vm`.

## T1.2 Recursos
```bash
lscpu ; free -h ; lsblk ; df -h / ; uptime
```
- `lscpu`: CPUs/modelo/cache. `free -h`: RAM e swap em unidades legíveis. `lsblk`: árvore de discos/partições. `df -h`: espaço por sistema de arquivos. `uptime`: tempo ligado + *load average* (1, 5, 15 min).

**(Sistema):** 2 CPUs (i7-1255U), 3,3 GiB de RAM, swap 4 GiB; `sda` 40G (`sda1` 1M, `sda2` 1G `/boot`, `sda3` 39G LVM → `openeuler-root` 35G `/` e `openeuler-swap` 4G) e `sdb` 2G **sem partições**; `/` com 35G, 27G livres (19% usado); uptime de poucos minutos, load ≈ 0,1.

## T1.3 Quem sou eu
```bash
id ; whoami ; echo $SHELL ; echo $HOME
sudo -i        
exit
```
- `id` mostra UID, GID, grupos (aqui `wheel` = pode usar sudo) e contexto SELinux. `sudo -i` abre shell **de login** do root (pede a *sua* senha); o prompt vira `[root@localhost ~]#` e o diretório vira `/root`. `exit` volta ao usuário comum.

**Esperado:** `uid=1000(ryan) … groups=1000(ryan),10(wheel)`, shell `/bin/bash`, home `/home/ryan`.

## T1.4 Pedir ajuda
```bash
man ls              
man 5 passwd
apropos calendar    
cal --help
type ls ; which ls
```
- **Ordenar por tamanho:** `ls -S` (maior primeiro; `-lS`, e `-r` inverte).
- **Seção 5 do manual** = *formatos de arquivo e convenções*. `man 5 passwd` descreve `/etc/passwd`: 7 campos `login:x:UID:GID:comentário:home:shell`.
- `apropos` pesquisa nas descrições das páginas man (precisa do banco `mandb`); revela o comando **`cal`** (calendário). `--help` dá resumo curto; `type` diz se é alias/builtin/arquivo; `which` mostra o caminho do executável.

## T1.5 Data e fuso
```bash
sudo timedatectl set-timezone America/Sao_Paulo
date ; timedatectl
```
- Sem `sudo` falha com *Interactive authentication required* (polkit) — como no histórico. O `timedatectl` altera o fuso e informa se o NTP sincroniza.

**Esperado:** `Time zone: America/Sao_Paulo (-03, -0300)`, `System clock synchronized: yes`, `NTP service: active`.

## T1.6 Editor (vim)
```bash
vim ~/notas.txt     
cat ~/notas.txt ; wc -l ~/notas.txt
```
| Tecla | Efeito |
|---|---|
| `i` / `Esc` | entra / sai do modo de inserção |
| `:w` / `:q` / `:wq` | salvar / sair / ambos |
| `:q!` | sair **sem** salvar |
| `/texto` (`n` próxima) | buscar |
| `:%s/a/b/g` | substituir `a` por `b` em todo o arquivo |

**Esperado:** 3 linhas (nome, kernel, fuso) → `wc -l` = `3`.

## T1.7 Histórico e atalhos
```bash
history                 
!42                     

echo "alias ll='ls -la'" >> ~/.bashrc
source ~/.bashrc
```
- O `alias` digitado direto no terminal **vale só para a sessão**; gravar no `~/.bashrc` (lido a cada novo shell) o torna **permanente**. `source` recarrega sem reabrir o terminal.

### Perguntas para pensar — Módulo 1
**1. `su -` × `sudo -i` × `sudo comando`; por que usuário comum?**
- `su -`: troca para root (ou outro usuário) com shell de login; pede a **senha do usuário-alvo** (root). Todos os comandos seguintes rodam como root sem trilha individual.
- `sudo -i`: shell de login de root, mas autenticando com **a senha de quem pede** e só se o `sudoers` permitir; o `sudo` registra quem entrou.
- `sudo comando`: eleva privilégio **apenas para um comando**; ao terminar volta ao usuário comum — é o mais seguro.
- Trabalhar como comum segue o **princípio do menor privilégio**: erros (ex.: `rm -rf` no lugar errado) e malwares têm alcance limitado; o `sudo` deixa **auditoria** (journal/`/var/log/secure`) de quem fez o quê; evita senha de root compartilhada.

**2. O que significa LTS?**
- **Distribuição:** openEuler LTS é a versão de longo prazo, com correções de segurança e bugs por vários anos (cerca de **4 anos** de ciclo, estendido por *Service Packs* como o SP4) e sem mudanças grandes de ABI — ideal para servidores. As versões *innovation* duram poucos meses.
- **Kernel:** o 6.6 é uma série LTS do kernel Linux upstream; o openEuler mantém **seu próprio kernel 6.6** e faz *backport* de correções durante todo o ciclo da distro, independentemente de o upstream encerrar a série antes. (Confirme prazos exatos na página oficial de ciclo de vida.)

### Ponto de conferência 1
| Tarefa | Verificação | Esperado | Obtido |
|---|---|---|---|
| T1.1 | `ID` / `VERSION_ID` | openEuler ; 24.03 | openEuler ; 24.03 |
| T1.1 | `uname -r` | 6.6.* | 6.6.0-159.4.3.154.oe2403sp4.x86_64 |
| T1.2 | `lsblk` | dois discos, o de 2 GB sem partições | `sda` 40G + `sdb` 2G sem partições |
| T1.5 | `timedatectl` | America/Sao_Paulo | America/Sao_Paulo |
| T1.6 | `wc -l ~/notas.txt` | 3 | 3 |

---

# MÓDULO 2 — Arquivos, diretórios e texto

## T2.1 Navegar e copiar
```bash
cd /opt/nuvemif ; ls -la
sudo dnf install -y tree ; tree /opt/nuvemif | head -30
du -sh /opt/nuvemif/*
mkdir -p ~/trabalho
cp -a /opt/nuvemif/arquivos ~/trabalho/arquivos
du -sh ~/trabalho/arquivos
```
- `ls -la` lista tudo com permissões; `tree` desenha a árvore; `du -sh` soma o tamanho. **`cp -a`** = *archive* (`-dR --preserve=all`): copia recursivamente **preservando datas, dono e permissões** — essencial porque T2.2 filtra por data/permissão (os arquivos são `root:root`; se der "Permission denied", use `sudo cp -a` + `sudo chown -R $USER:$USER ~/trabalho`).
- **Conferido:** `du -sh arquivos` → **18M**.

## T2.2 Encontrar por critério
```bash
cd ~/trabalho/arquivos
find . -type f -size +100k | wc -l                  
28
find . -type f -name '*.tmp' | wc -l               
12
find . -type f ! -newermt 2026-09-01 | wc -l       
38
find . -type f -perm -o+w | wc -l                  
3
find . -type f -name '*.bak' -size +1M | wc -l     
5
find . -type f -name '*.tmp' -delete
ls | wc -l                                         
48
```
- `-type f` só arquivos; `-size +100k` maior que 100 KiB; `-name` padrão (aspas evitam o shell expandir); `-newermt DATA` modificado depois da data → `!` nega (= antes de 01/09); `-perm -o+w` "outros" têm escrita; `-delete` apaga o que casou (**coloque sempre depois dos filtros**; teste antes sem ele).
- **Conferido:** 28; 12; 38; 3; 5; restam **48**.

## T2.3 Compactar
```bash
cd ~/trabalho
tar czf arquivos.tar.gz -C arquivos .      
tar tzf arquivos.tar.gz | head             
tar xzf arquivos.tar.gz -C /tmp ./relatorio_01.csv   
tar cJf arquivos.tar.xz -C arquivos .     
ls -lh arquivos.tar.*
```
- `-C dir` entra na pasta antes de empacotar (conteúdo sem prefixo). Extrair um membro = informar o caminho **exatamente como listado** no `tar tzf`.
- (**Conferido**): os arquivos de teste são só caracteres repetidos, então comprimem muitíssimo: `.tar.gz` de poucas dezenas de KB e `.tar.xz` **menor ainda** (xz comprime mais, porém é mais lento). Registre os dois tamanhos que o seu `ls -lh` mostrar.

## T2.4 Contar no log
```bash
cd /opt/nuvemif/logs
wc -l coletor.log                                  
6000
for n in INFO WARN ERROR; do echo $n $(grep -c "\[$n\]" coletor.log); done
awk '{print $3}' coletor.log | sort | uniq -c      
grep -c 'timeout ao conectar' coletor.log          
301
grep -c '^2026-09-16' coletor.log                  
200
```
- `grep -c` conta **linhas** que casam; `[` precisa de `\[` (senão é classe de caracteres); `^` ancora no início da linha. `awk '{print $3}'` imprime o 3º campo (o nível), `sort | uniq -c` agrupa e conta (`uniq` só junta linhas **adjacentes** — por isso o `sort` antes).
- **(Conferido):** total **6000**; INFO **4790**; WARN **616**; ERROR **594**; timeout **301**; dia 16/09 **200**.

## T2.5 Encontrar o atacante
```bash
grep 'falha de autenticacao' coletor.log | grep -o 'origem=[0-9.]*' | sort | uniq -c | sort -rn | head
grep '\[ERROR\]' coletor.log | grep -o 'instancia=[a-z0-9-]*' | sort | uniq -c | sort -rn | head
```
- `grep -o` imprime só o trecho que casou; `sort -rn` ordena numericamente do maior para o menor; `head` mostra o topo.
- **(Conferido):** `198.51.100.23` com **129** falhas (seguido de 203.0.113.7 = 37 e 192.0.2.55 = 25). Instância com mais erros: **10 linhas, com empate** (`ecs-d6c29b64` e `ecs-0adfcd0e`).

## T2.6 Somar no CSV
```bash
cd /opt/nuvemif/dados
awk -F, 'NR>1{t+=$11} END{printf "%.2f\n",t}' uso_nuvem.csv                       
65984.13
awk -F, 'NR>1 && $4=="PRJ-004"{t+=$11} END{printf "%.2f\n",t}' uso_nuvem.csv      
12486.39
awk -F, 'NR>1 && $2=="2026-09-16"{t+=$11} END{printf "%.2f\n",t}' uso_nuvem.csv   
2865.97
awk -F, 'NR>1 && $12=="error"{n++} END{print n}' uso_nuvem.csv                    
90
cut -d, -f3 uso_nuvem.csv | tail -n +2 | sort -u | wc -l                          
135
```
- `-F,` define vírgula como separador; `$11` = custo_brl, `$4` = projeto, `$12` = status; **`NR>1`** pula o cabeçalho (linha 1); somas em variável e `END{}` roda após ler tudo; `printf "%.2f"` fixa 2 casas decimais. `cut -d, -f3` extrai a coluna 3; `sort -u` remove duplicados.
- **(Conferido):** **65984.13**; **12486.39**; **2865.97**; **90**; **135**.

## T2.7 Agrupar
```bash
awk -F, 'NR>1{c[$4]+=$11} END{for(p in c) printf "%s %.2f\n",p,c[p]}' uso_nuvem.csv | sort -k2 -rn | head -3
cut -d, -f5 uso_nuvem.csv | tail -n +2 | sort | uniq -c
```
- `c[$4]+=$11` é um **array associativo** (soma por projeto); o `for(p in c)` imprime no `END`.
- **(Conferido):** top 3 → `PRJ-004 12486.39`, `PRJ-012 6900.82`, `PRJ-006 6170.72`. Regiões: `sa-brazil-1` **1718**, `la-south-2` 1009, `na-mexico-1` 664.

## T2.8 Substituir
```bash
cp uso_nuvem.csv ~/trabalho/uso_copia.csv
sed 's/sa-brazil-1/br-south-1/g' ~/trabalho/uso_copia.csv > ~/trabalho/uso_br.csv
diff ~/trabalho/uso_copia.csv ~/trabalho/uso_br.csv | grep -c '^<'      
1718
cp /opt/nuvemif/config/coletor.conf ~/trabalho/coletor.conf
sed -i 's/nivel_log=INFO/nivel_log=DEBUG/' ~/trabalho/coletor.conf
grep nivel_log ~/trabalho/coletor.conf
```
- `s/antigo/novo/g` substitui todas as ocorrências por linha; `-i` edita **no próprio arquivo** (use em cópia!). `diff` mostra `<` (versão antiga) e `>` (nova): contar linhas `<` = linhas alteradas. **Esperado:** 1718 linhas; `nivel_log=DEBUG`.

## T2.9 Redirecionar
```bash
grep '\[ERROR\]' /opt/nuvemif/logs/coletor.log > ~/trabalho/erros.txt   
594
ls /raiz-inexistente /opt > ~/trabalho/saida.txt 2> ~/trabalho/erro.txt
echo "nova linha" >> ~/trabalho/erros.txt
```
| Operador | Significado |
|---|---|
| `>` / `>>` | stdout para arquivo (sobrescreve / acrescenta) |
| `2>` | stderr (descritor 2) para arquivo |
| `2>&1` | manda stderr para **o mesmo destino atual** do stdout (ex.: `cmd > tudo.txt 2>&1`; a ordem importa) |
| `/dev/null` | "buraco negro": descarta o que for escrito (ex.: `cmd 2>/dev/null` esconde erros) |
| `\|` / `tee` | encadeia saída→entrada / grava e ainda mostra na tela |

**Conferido:** `saida.txt` com a listagem de `/opt` (`nuvemif`); `erro.txt` com `ls: cannot access '/raiz-inexistente': No such file or directory`.

## T2.10 Ligações
```bash
cd ~/trabalho
cp /opt/nuvemif/dados/uso_nuvem.csv orig.csv ; cp /opt/nuvemif/docs/README.txt readme_orig.txt
ln -s ~/trabalho/orig.csv ~/uso.csv            # simbólica
ln readme_orig.txt readme_hard.txt             # física
ls -li ~/uso.csv orig.csv readme_orig.txt readme_hard.txt
rm orig.csv readme_orig.txt
cat ~/uso.csv ; cat readme_hard.txt
```
- **Simbólica** (`ln -s`) = arquivo com *caminho* do destino, **inode próprio**, `l` no `ls -l`. Se o original some, ela **quebra** (`No such file`).
- **Física** (`ln`) = outro *nome* para o **mesmo inode** (contador de links = 2); só existe no mesmo sistema de arquivos. Apagar o original **não afeta** o conteúdo — ele só some quando o último nome é removido.
- **Conferido:** `uso.csv` dá erro após apagar `orig.csv`; `readme_hard.txt` continua exibindo o texto.

### Perguntas para pensar — Módulo 2
**1. `grep PRJ-004 uso_nuvem.csv` × `awk -F, '$4=="PRJ-004"'`.**
`grep` procura a *string* em **qualquer ponto da linha**; `awk` compara **exatamente a coluna 4**. Divergem se: o texto aparecer em outra coluna (ex.: equipe/nome); existir `PRJ-0041` (substring); o cabeçalho contiver a palavra; ou o CSV tiver vírgulas entre aspas (o `-F,` quebraria o campo). Aqui coincidem porque o padrão só existe na coluna do projeto.

**2. Hábitos contra `rm -rf` acidental.** Rodar `ls`/`find … -print` com o **mesmo** padrão antes de apagar; conferir `pwd`; evitar `rm -rf *` e variáveis possivelmente vazias (`rm -rf "$DIR"/` com `DIR` vazio vira `/`; usar `${DIR:?}`); usar `rm -i`/`-I`; trabalhar em cópia; não ser root sem necessidade; ter backup/snapshot.

### Ponto de conferência 2
| Tarefa | Verificação | Esperado | Obtido |
|---|---|---|---|
| T2.1 | `du -sh arquivos` | 18M | 18M |
| T2.2 | >100 KB; .tmp; antes de 01/09; graváveis por todos; .bak >1 MB | 28; 12; 38; 3; 5 | 28; 12; 38; 3; 5 |
| T2.2 | restantes após apagar .tmp | 48 | 48 |
| T2.4 | total; INFO; WARN; ERROR | 6000; 4790; 616; 594 | 6000; 4790; 616; 594 |
| T2.4 | timeout; eventos 16/09 | 301; 200 | 301; 200 |
| T2.5 | origem mais frequente | 198.51.100.23; 129 | 198.51.100.23; 129 |
| T2.5 | erros da instância (empate) | 10 | 10 |
| T2.6 | total; PRJ-004; 16/09 | 65984.13; 12486.39; 2865.97 | idem |
| T2.6 | `error`; instâncias distintas | 90; 135 | 90; 135 |
| T2.7 | registros em sa-brazil-1 | 1718 | 1718 |
| T2.8 | linhas alteradas pelo sed | 1718 | 1718 |

---

# MÓDULO 3 — Usuários, grupos e permissões

## T3.1 Contas
```bash
sudo groupadd -g 2500 nuvemif
for u in "ana 2501" "bruno 2502" "carla 2503"; do set -- $u
  sudo useradd -m -u $2 -G nuvemif -s /bin/bash $1 ; done
sudo passwd ana ; sudo passwd bruno ; sudo passwd carla
sudo useradd -r -M -s /sbin/nologin coletor
id ana ; getent passwd coletor ; getent group nuvemif
sudo tail -4 /etc/passwd ; sudo tail -4 /etc/group ; sudo tail -4 /etc/shadow
```
- `groupadd -g` cria grupo com GID fixo. `useradd`: `-u` UID, **`-G` grupos suplementares** (o grupo primário continua o de mesmo nome), `-s` shell, `-m` cria home. Conta de **sistema** `-r` (UID < 1000, sem envelhecimento de senha), `-M` sem home, **`/sbin/nologin`** impede login (serviço não precisa de shell); sem `passwd` fica sem senha (`!` no shadow).
- `/etc/passwd`: `login:x:UID:GID:comentário:home:shell`; `/etc/group`: `nome:x:GID:membros`; `/etc/shadow` (só root): `login:hash:data-troca:min:max:aviso:…`.
- **Esperado:** `uid=2501(ana) gid=2501(ana) groups=2501(ana),2500(nuvemif)`; `coletor:x:99x:99x::/home/coletor:/sbin/nologin`.

## T3.2 Política de senhas
```bash
sudo chage -M 90 -W 7 ana ; sudo chage -l ana
sudo usermod -L bruno ; sudo passwd -S bruno          
su - bruno          
sudo usermod -U bruno
sudo chage -E 2026-12-31 carla ; sudo chage -l carla
grep -E '^(PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_MIN_LEN|PASS_WARN_AGE)' /etc/login.defs
```
- `chage -M` validade máxima (dias), `-W` dias de aviso, `-E` data de expiração **da conta**. `usermod -L` põe `!` na frente do hash (bloqueia **senha**; login por chave SSH ainda funcionaria — para bloquear tudo use também `chage -E 0`). `-U` desfaz.
- **Esperado:** `Maximum number of days between password change : 90`, `Number of days of warning before password expires : 7`; `passwd -S bruno` → `LK`; `Account expires : Dec 31, 2026`. Em `login.defs`, anote os valores que aparecerem (`PASS_MAX_DAYS` costuma ser 99999 no padrão; `PASS_MIN_LEN`, quando definido, é o tamanho mínimo).

## T3.3 Corrigir permissões
```bash
cd /opt/nuvemif
sudo chown coletor:nuvemif config/segredos.env
sudo chmod 640 config/segredos.env                  
ls -l config/segredos.env                           
sudo find /opt/nuvemif -type f -perm -o+w -exec chmod o-w {} +
find /opt/nuvemif -type f -perm -o+w                
```
- `chown dono:grupo` troca dono e grupo; `chmod 640` = dono lê/escreve (6), grupo lê (4), outros nada (0). `find … -exec cmd {} +` roda o comando passando **vários arquivos de uma vez** (mais rápido que `\;`); `o-w` remove escrita de "outros".
- **Esperado:** `-rw-r----- 1 coletor nuvemif … segredos.env`; segundo `find` sem saída.

## T3.4 Diretório compartilhado
```bash
sudo mkdir /opt/nuvemif/compartilhado
sudo chgrp nuvemif /opt/nuvemif/compartilhado
sudo chmod 3770 /opt/nuvemif/compartilhado          
ls -ld /opt/nuvemif/compartilhado
sudo -u ana  bash -c 'touch /opt/nuvemif/compartilhado/de_ana.txt; ls -l /opt/nuvemif/compartilhado'
sudo -u bruno bash -c 'rm /opt/nuvemif/compartilhado/de_ana.txt'
```
- **SGID** (`2000`, `s` no grupo) em diretório → arquivos novos herdam o **grupo do diretório** (`nuvemif`). **Sticky** (`1000`, `t`) → só o dono do arquivo (ou do diretório/root) pode apagar/renomear. `770` → só dono e grupo entram (outros sem acesso — por isso o `t` aparece **maiúsculo `T`**, já que "outros" não têm `x`).
- **Esperado:** `drwxrws--T 2 root nuvemif …`; arquivo de ana `-rw-r--r-- ana nuvemif`; bruno recebe `rm: cannot remove '…/de_ana.txt': Operation not permitted`.

## T3.5 Máscara (umask)
```bash
umask ; sudo bash -c umask
touch f1 ; mkdir d1 ; ls -ld f1 d1
umask 077 ; touch f2 ; mkdir d2 ; ls -ld f2 d2
```
- A **umask é subtraída** das permissões máximas: arquivo parte de `666`, diretório de `777` (arquivo nunca nasce executável). Valores típicos: usuário comum `0002` (grupo com mesmo nome) → arquivo `664`, diretório `775`; root `0022` → `644` / `755`. Com **`077`**: arquivo `600` (`-rw-------`), diretório `700` (`drwx------`). A mudança vale só para a sessão atual.

## T3.6 ACL
```bash
sudo setfacl -R -m u:carla:rx /opt/nuvemif/dados
sudo setfacl -d -m u:carla:rx /opt/nuvemif/dados    
getfacl /opt/nuvemif/dados
ls -ld /opt/nuvemif/dados                           
sudo -u carla ls /opt/nuvemif/dados
```
- ACL dá permissão a **um usuário específico** sem mexer em dono/grupo/modo base. `-m` modifica, `-R` recursivo, `-d` define ACL *default*. `r-x` no diretório permite listar/entrar; nos CSVs, ler.
- **Esperado:** linha `user:carla:r-x` no `getfacl`; `drwxr-xr-x+` (o **`+`** indica ACL estendida). (O caminho `/opt/nuvemif` já é `755`, então carla consegue atravessar.)

## T3.7 Sudo delegado
```bash
sudo visudo -f /etc/sudoers.d/nuvemif      
sudo visudo -c                             
sudo -l -U ana
```
```
ana ALL=(root) NOPASSWD: /usr/bin/systemctl restart coletor, /usr/bin/journalctl -u coletor
%nuvemif ALL=(root) /usr/bin/dnf
```
- `visudo` bloqueia o arquivo e **valida a sintaxe antes de salvar** (um erro no sudoers pode deixar ninguém com sudo). `NOPASSWD:` dispensa senha; caminhos **absolutos** com argumentos exatos limitam o que pode ser feito; `%grupo` aplica ao grupo. Como ana é do grupo `nuvemif`, a listagem mostra também o `dnf` (com senha).
- **Esperado:** `sudo -l -U ana` lista os dois comandos `(root) NOPASSWD:` e `(root) /usr/bin/dnf`.

## T3.8 Bits especiais
```bash
find /usr/bin -perm -4000 -ls
ls -l /usr/bin/passwd ; ls -ld /tmp
```
- **SUID** (`s` no dono): o programa roda com o **UID do dono** (root). `passwd` precisa dele porque grava em `/etc/shadow` (somente root) — um usuário comum só consegue trocar a *própria* senha porque o programa, rodando como root, valida quem chamou. Outros SUID típicos: `sudo`, `su`, `mount`.
- `/tmp` é `drwxrwxrwt`: o **`t`** final = *sticky bit*: todos escrevem, mas **cada um só apaga os próprios arquivos**.

### Perguntas para pensar — Módulo 3
**1. Por que o serviço roda como `coletor` e não root?** Menor privilégio: se o agente for explorado, o invasor só tem as permissões de `coletor` (ler/escrever os próprios logs). Como **root**, teria controle total: ler `/etc/shadow`, alterar o sistema, instalar backdoors, atacar a rede toda.

**2. ACL × grupo suplementar × sudo (exemplos na NuvemIF).**
- **Grupo suplementar:** acesso coletivo e permanente — ana, bruno e carla no `nuvemif` usam `/opt/nuvemif/compartilhado`.
- **ACL:** exceção pontual para **um** usuário/grupo sem mudar dono nem modo — carla lendo `dados/` (CSV) sem entrar em grupo com mais acessos.
- **sudo:** executar **comando privilegiado** específico — ana reiniciando o `coletor`, ou o grupo rodando `dnf`.

### Ponto de conferência 3
| Tarefa | Verificação | Esperado |
|---|---|---|
| T3.1 | `id ana` | `uid=2501(ana)` e `2500(nuvemif)` entre os grupos |
| T3.1 | shell do coletor | `/sbin/nologin` |
| T3.2 | `chage -l ana` | Maximum = 90 |
| T3.3 | `ls -l segredos.env` | `-rw-r----- coletor nuvemif` |
| T3.3 | `find -type f -perm -o+w` | nenhum arquivo |
| T3.4 | `ls -ld compartilhado` | `drwxrws--T` (ou `t`), grupo nuvemif |
| T3.6 | `getfacl dados` | `user:carla:r-x` |
| T3.7 | `sudo -l -U ana` | os dois comandos com NOPASSWD |

---

# MÓDULO 4 — Processos, serviços e logs

## T4.1 Processos
```bash
ps aux | wc -l                          
pgrep -ox sshd ; ps -p 1 -o pid,comm    
ps -ef --forest | head -30 ; pstree -p | head
ps -eo pid,comm,%mem --sort=-%mem | head -6
```
- `ps aux` = todos os processos; `pgrep -o` pega o **mais antigo** (o `sshd` mestre; os outros são filhos por sessão); `-x` casa nome exato. `--forest`/`pstree` mostram a **hierarquia pai/filho**; `--sort=-%mem` ordena pelo maior uso de memória (`-` = decrescente). `top`/`htop` é a versão interativa.
- **Esperado:** PID 1 = **systemd**; sshd mestre com PPID 1.

## T4.2 Primeiro/segundo plano e sinais
```bash
cd /opt/nuvemif
COLETOR_LOG=/tmp/coletor-teste.log bin/coletor.sh &
jobs                                   # [1]+ Running
fg %1                                  # traz ao primeiro plano; Ctrl+Z suspende
bg %1                                  # retoma em segundo plano
kill -TERM %1 ; tail -2 /tmp/coletor-teste.log
COLETOR_LOG=/tmp/coletor-teste.log bin/coletor.sh & kill -KILL %1 ; tail -2 /tmp/coletor-teste.log
```
- `&` inicia em segundo plano; `jobs` lista; `fg`/`bg` movem; **Ctrl+Z** envia SIGTSTP (suspende).
- **`kill -TERM`** (15) pede encerramento: o script tem `trap … TERM` e escreve **`parando por SIGTERM`** antes de sair → **última linha do log** (checkpoint).
- **`kill -KILL`** (9) é entregue direto pelo kernel, **não pode ser capturado**: o processo morre na hora, **sem** a mensagem (o log termina em `batimento ok`/`iniciado`). Esta é a diferença.
- `nohup cmd &` → ignora SIGHUP (continua após fechar o terminal; saída vai a `nohup.out`). `nice -n 10 cmd` inicia com prioridade menor (valor de −20 mais prioritário a 19); `renice -n 5 -p PID` muda um processo em execução.

## T4.3 Unidade de serviço
Arquivo `/etc/systemd/system/coletor.service` (versão final em `systemd/coletor.service`):
```ini
[Unit]
Description=Agente coletor NuvemIF
After=network.target
[Service]
User=coletor
ExecStart=/opt/nuvemif/bin/coletor.sh
Restart=on-failure
RestartSec=5
LogsDirectory=nuvemif
[Install]
WantedBy=multi-user.target
```
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now coletor
systemctl status coletor ; journalctl -u coletor -n 20
```
- `[Unit]` metadados/ordem (`After=network.target` = inicia depois da rede); `[Service]` o que executar, com **qual usuário**, política de reinício; `[Install]` `WantedBy=multi-user.target` = habilita no boot normal (modo multiusuário). `daemon-reload` faz o systemd reler as unidades; `enable --now` = habilita **e** inicia.
- **Falha da 1ª tentativa:** na versão sem `LogsDirectory`, `journalctl -u coletor` mostra `mkdir: cannot create directory '/var/log/nuvemif': Permission denied` (o script faz `mkdir -p` e tem `set -e`; o usuário `coletor` não pode criar pasta em `/var/log`) e o serviço fica reiniciando/`failed`. **Correção:** criar a pasta com o dono certo (`sudo mkdir -p /var/log/nuvemif && sudo chown coletor: /var/log/nuvemif`) **ou** usar `LogsDirectory=nuvemif`, que o systemd cria sozinho com o `User=`. (Se aparecer `status=203/EXEC`, veja permissões de `/opt/nuvemif/bin/coletor.sh` e o contexto SELinux em `ausearch -m AVC -ts recent`.)
- **Esperado:** `active (running)`, `enabled`; linha do log `coletor iniciado pid=… usuario=coletor`.

## T4.4 Journal
```bash
journalctl -u coletor            
journalctl -u coletor -f         
journalctl --since "1 hour ago"
journalctl -p err -b             
sudo mkdir -p /var/log/journal
sudo sed -i 's/^#\?Storage=.*/Storage=persistent/' /etc/systemd/journald.conf
sudo systemctl restart systemd-journald
journalctl --disk-usage
```
- O journal é binário e, por padrão, pode ser **volátil** (`/run/log/journal`, some ao reiniciar). `Storage=persistent` (ou existir `/var/log/journal`) grava em disco. `-p err` filtra severidade; `-b` limita ao boot; `--disk-usage` mostra espaço ocupado.

## T4.5 Resiliência
```bash
sudo kill -9 $(systemctl show -p MainPID --value coletor)
sleep 15 ; systemctl is-active coletor ; systemctl show -p MainPID,NRestarts coletor
sudo reboot       
```
- O `kill -9` termina o processo por sinal → conta como **falha** → `Restart=on-failure` reinicia após `RestartSec` (5 s). `NRestarts` mostra quantas vezes. Após `reboot`, o serviço sobe sozinho porque está **enabled**.
- **Esperado:** 15 s depois `active` com **PID novo**; `NRestarts=1`; após reboot `active`.

## T4.6 Sistema como um todo
```bash
systemctl get-default
systemctl list-units --type=service --state=running | wc -l
systemd-analyze blame | head -5
sudo systemctl mask cups.service         
systemctl list-dependencies multi-user.target | head
```
- `get-default` = alvo (equivalente ao runlevel): **`multi-user.target`**. `blame` lista os serviços mais lentos no boot. **disable × mask:** `disable` só remove os links de início automático — o serviço ainda pode ser iniciado manualmente ou como dependência; `mask` aponta a unidade para `/dev/null` e **impede qualquer início** (inclusive por dependência) — erro `Unit … is masked`. Desfaz com `unmask`.

## T4.7 Rotação de logs
Arquivo `/etc/logrotate.d/nuvemif` (`config/nuvemif.logrotate`):
```
/var/log/nuvemif/coletor-servico.log {
    daily
    rotate 7
    compress
    dateext
    missingok
    notifempty
    copytruncate
    su coletor coletor
}
```
```bash
sudo logrotate -f /etc/logrotate.d/nuvemif
ls -l /var/log/nuvemif/
```
- `daily` rotação diária; `rotate 7` guarda 7 cópias; `compress` gzip; `copytruncate` **copia o log e zera o original no lugar** — necessário porque o script mantém o arquivo aberto (`>>`); sem isso ele continuaria escrevendo no arquivo rotacionado, e assim **não é preciso reiniciar o serviço**; `su coletor coletor` roda a rotação com o dono da pasta (evita erro de "permissões inseguras"); `-f` força para teste.
- **Esperado:** `coletor-servico.log-AAAAMMDD.gz` + `coletor-servico.log` vazio/novo.

### Perguntas para pensar — Módulo 4
**1. SIGTERM × SIGKILL.** SIGTERM (15) é um **pedido** educado: o processo pode capturá-lo (`trap`) e encerrar com ordem — fechar arquivos, terminar gravações, liberar locks, apagar temporários (o `coletor.sh` escreve "parando por SIGTERM"). SIGKILL (9) **não pode ser capturado nem ignorado**: o kernel remove o processo na hora, sem limpeza — pode deixar arquivos corrompidos/locks. Um serviço bem escrito trata SIGTERM para parar com segurança; o `systemctl stop` envia SIGTERM e só usa SIGKILL após `TimeoutStopSec`.

**2. `Restart=on-failure`.** Cobre: saída com código ≠ 0, morte por sinal (ex.: `kill -9`, segfault), timeout e watchdog. **Não cobre:** saída limpa (código 0) nem `systemctl stop`. (Atenção: o `coletor.sh` trata SIGTERM com `exit 0` → um `kill -TERM` no processo **não** dispara reinício.) `Restart=always` é melhor para daemons que devem estar sempre no ar, mesmo se saírem "limpos"; é pior para tarefas que terminam normalmente ou quando há erro de configuração — gera **laço infinito de reinícios** consumindo CPU/log (mitigue com `RestartSec` e `StartLimit…`).

### Ponto de conferência 4
| Tarefa | Verificação | Esperado |
|---|---|---|
| T4.1 | nome do PID 1 | `systemd` |
| T4.2 | última linha após `kill -TERM` | `… parando por SIGTERM` |
| T4.3 | `is-active` / `is-enabled` | `active` / `enabled` |
| T4.3 | log mostra | `usuario=coletor` |
| T4.5 | 15 s após `kill -9` | `active` com novo PID |
| T4.6 | `get-default` | `multi-user.target` |
| T4.7 | arquivo rotacionado | existe, com data, `.gz` |

---

# MÓDULO 5 — Pacotes e repositórios

## T5.1 Repositórios
```bash
dnf repolist ; dnf repolist -v | head -40
ls /etc/yum.repos.d/ ; cat /etc/yum.repos.d/openEuler.repo
sudo dnf makecache
```
- Repositórios do openEuler: **OS** (pacotes básicos), **everything** (conjunto completo), **EPOL** (extras mantidos pela comunidade), **update** (atualizações/correções), mais debuginfo/source (geralmente desabilitados).
- `baseurl` = endereço dos pacotes/metadados (`repo.openeuler.org/...`); `gpgcheck=1` = o dnf **verifica a assinatura** de cada RPM; `gpgkey` = onde está a chave pública usada. `makecache` baixa/atualiza os metadados locais.
- **Esperado:** `repolist` inclui `OS`, `everything`, `EPOL`, `update`.

## T5.2 Procurar e instalar
```bash
dnf search tree ; dnf provides /usr/bin/tree ; dnf provides nginx
dnf info nginx ; dnf repoquery --requires nginx
sudo dnf install -y tree nginx
```
- `search` procura por nome/descrição; `provides` descobre **qual pacote fornece um arquivo/comando**; `info` mostra versão/tamanho/repo; `repoquery --requires` lista dependências. Na instalação, o resumo da transação mostra "Installing: nginx" + "Installing dependencies: …" — **o número de dependências é o N−1 do "Install N Packages"** (registre o seu).
- **Esperado:** `rpm -q nginx tree` mostra as duas versões.

## T5.3 Auditar
```bash
rpm -qa | wc -l                 
rpm -qf /usr/bin/awk            
rpm -ql nginx ; rpm -qc nginx   
rpm -V bash                     
rpm -qi kernel                  
```
- Prefixos do `rpm`: `-q` consulta; `-a` todos; `-f` dono de um arquivo; `-l` arquivos; `-c` configs; `-i` informação; **`-V` verifica** tamanho/hash/permissões contra o banco RPM (letras `5`=hash MD5/SHA alterado, `S` tamanho, `M` modo).

## T5.4 Histórico e retorno
```bash
dnf history
dnf history info <N>            
sudo dnf history undo <N>
rpm -q nginx                    
sudo dnf install -y nginx       
```
- Cada operação do dnf é uma **transação numerada**; `undo` aplica o inverso (remove o que foi instalado, **inclusive dependências** trazidas por ela).

## T5.5 Atualizações
```bash
dnf check-update
dnf updateinfo list security
sudo dnf update --security -y
grubby --default-kernel
```
- `check-update` lista pacotes com versão nova; `updateinfo` lê os avisos (SA) classificados por tipo/severidade; `--security` aplica **só** as correções de segurança. **Kernel:** `dnf update` **instala um kernel novo ao lado do antigo** (`installonly`, mantém alguns) — nunca o substitui; só é usado **após reiniciar**. O padrão do GRUB vira o mais novo; para escolher: menu do GRUB no boot, ou `sudo grubby --set-default /boot/vmlinuz-<versão>` (veja `grubby --info=ALL`). Isso permite voltar ao kernel antigo se o novo der problema.

## T5.6 Pacote avulso e grupos
```bash
mkdir ~/rpms && cd ~/rpms
dnf download htop
rpm -qpi htop-*.rpm ; rpm -qpl htop-*.rpm
sudo dnf install -y ./htop-*.rpm
dnf group list ; dnf group info "Development Tools"
```
- `dnf download` baixa o `.rpm` sem instalar; `rpm -qp` consulta um **arquivo RPM** (p = *package file*) — `-qpi` info, `-qpl` conteúdo; instalar de arquivo local resolve dependências pelos repositórios. **Grupos** instalam conjuntos de pacotes (`dnf group install`).
- **Esperado:** `rpm -q htop` → instalado.

## T5.7 Repositório local
```bash
sudo dnf install -y createrepo_c
sudo mkdir -p /srv/repo && sudo cp ~/rpms/*.rpm /srv/repo/
sudo createrepo_c /srv/repo
sudo tee /etc/yum.repos.d/local.repo <<'EOF'
[local]
name=Repositorio local
baseurl=file:///srv/repo
enabled=1
gpgcheck=0
EOF
sudo dnf remove -y htop
sudo dnf --disablerepo='*' --enablerepo=local install -y htop
dnf repolist
```
- `createrepo_c` gera o diretório `repodata/` (índice XML dos RPMs) — sem ele o dnf não enxerga os pacotes. `gpgcheck=0` desativa verificação de assinatura (aceitável só aqui, em repo local de laboratório). `--disablerepo='*' --enablerepo=local` prova que a instalação veio **apenas** do repositório local.

### Perguntas para pensar — Módulo 5
**1. `rpm` × `dnf`.** `rpm` é a ferramenta **de baixo nível**: instala/remove/consulta *arquivos RPM individuais* e o banco local, mas **não resolve dependências nem baixa**. `dnf` é o **gerenciador**: usa repositórios, baixa, **resolve dependências automaticamente**, atualiza o sistema, mantém histórico/undo, grupos e verifica assinaturas — e chama o `rpm` por baixo.

**2. `gpgcheck=1`.** Garante **autenticidade e integridade**: o RPM foi assinado por quem tem a chave privada e não foi alterado. Sem assinatura, um atacante *man-in-the-middle* (ou um mirror comprometido) pode entregar pacotes **maliciosos** que rodam como root na instalação, ou trocar um pacote por uma versão vulnerável (*downgrade*); HTTPS ajuda, mas só a assinatura protege o pacote em si.

### Ponto de conferência 5
| Tarefa | Verificação | Esperado |
|---|---|---|
| T5.1 | `dnf repolist` | OS, everything, EPOL, update |
| T5.2 | `rpm -q nginx tree` | duas versões, sem *not installed* |
| T5.3 | `rpm -qf /usr/bin/awk` | `gawk-…` |
| T5.4 | `rpm -q nginx` após undo | `package nginx is not installed` |
| T5.6 | `rpm -q htop` | instalado |
| T5.7 | `dnf repolist` | inclui `local` |

---

# MÓDULO 6 — Rede, SSH e firewall

## T6.1 Reconhecer a rede
```bash
ip -br addr ; ip route ; nmcli device ; nmcli connection show
cat /etc/resolv.conf
ping -c 3 repo.openeuler.org ; getent hosts repo.openeuler.org
sudo dnf install -y bind-utils ; dig repo.openeuler.org +short
```
- `ip addr` interfaces/IPs (seu banner mostrou **10.0.0.6**); `ip route` tabela de rotas (a linha `default via <gateway>` é a **rota padrão**); `nmcli` = interface do NetworkManager; `resolv.conf` lista os **DNS**. `getent hosts` resolve nome como as aplicações fazem (usa `nsswitch`); `dig` consulta DNS direto; `ping -c 3` testa conectividade ICMP.

## T6.2 Nome e IP fixo
```bash
sudo hostnamectl set-hostname nuvemif-srv
nmcli -t -f NAME,DEVICE connection show          
CON="<nome-da-conexão>" ; IP=10.0.0.6/24 ; GW=<gateway do ip route>
sudo nmcli connection modify "$CON" ipv4.method manual ipv4.addresses $IP ipv4.gateway $GW ipv4.dns "$GW 8.8.8.8"
sudo nmcli connection up "$CON"
echo "10.0.0.6 painel.nuvemif.local" | sudo tee -a /etc/hosts
hostnamectl --static ; nmcli -g ipv4.method connection show "$CON"
```
- `ipv4.method manual` troca de DHCP para IP estático; `connection modify` **grava de forma persistente** no perfil; `up` reaplica. Mantenha o **mesmo IP/rede que a VM já usa** (senão perde o SSH). `/etc/hosts` resolve nomes localmente antes do DNS.
- **Esperado:** `nuvemif-srv`; `manual`.

## T6.3 Portas abertas
```bash
sudo systemctl enable --now nginx
sudo ss -tulnp
curl -I http://localhost
```
- `ss` (substitui `netstat`): `-t` TCP `-u` UDP `-l` *listening* `-n` números `-p` processo (precisa sudo). **Esperado:** `nginx` em `0.0.0.0:80`, `sshd` em `:22`; `curl -I` → `HTTP/1.1 200 OK` (cabeçalhos da página padrão).

## T6.4 Site de status na porta 8080
```bash
sudo mkdir -p /srv/painel
echo "<h1>$(hostname)</h1><p>Gerado em $(date)</p>" | sudo tee /srv/painel/index.html
sudo cp config/painel.conf /etc/nginx/conf.d/painel.conf        # listen 8080; root /srv/painel;
sudo nginx -t && sudo systemctl reload nginx
curl http://localhost:8080
```
- `nginx -t` valida a configuração **antes** de recarregar; `reload` aplica sem derrubar conexões.
- **Esperado agora:** `HTTP 403 Forbidden` (`curl -I` → `403`). Registre o erro: o nginx roda sob SELinux e o diretório `/srv/painel` tem rótulo padrão (`var_t`) que o processo `httpd_t` **não pode ler** — resolve-se no módulo 9 (T9.2). Evidência: `sudo tail /var/log/nginx/error.log` (`Permission denied`).

## T6.5 Firewall
```bash
sudo firewall-cmd --state ; sudo firewall-cmd --get-default-zone ; sudo firewall-cmd --list-all
sudo firewall-cmd --permanent --add-port=8080/tcp ; sudo firewall-cmd --reload
# teste feito a partir do hospedeiro:  curl http://10.0.0.6:8080
sudo firewall-cmd --permanent --remove-port=8080/tcp
sudo firewall-cmd --permanent --add-service=http ; sudo firewall-cmd --reload
sudo sed -i 's/listen 8080;/listen 80 default_server;/' /etc/nginx/conf.d/painel.conf
sudo nginx -t && sudo systemctl reload nginx
sudo firewall-cmd --list-services ; sudo firewall-cmd --list-ports
```
- `firewalld` trabalha com **zonas** (padrão geralmente `public`); `--permanent` grava na configuração; sem ele a regra é só **runtime**. `--reload` recarrega a configuração permanente.
- **Esperado:** `running`; zona `public`; services `ssh http` (pode vir `dhcpv6-client`); `--list-ports` **vazio**.

## T6.6 SSH por chave
```bash
# no HOSPEDEIRO
ssh-keygen -t ed25519
ssh-copy-id ryan@10.0.0.6 ; ssh ryan@10.0.0.6               
# no SERVIDOR (mantenha uma sessão aberta!)
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/;s/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sshd -t && sudo systemctl reload sshd
sudo sshd -T | grep -Ei '^(permitrootlogin|passwordauthentication)'
# no HOSPEDEIRO
ssh -o PubkeyAuthentication=no ryan@10.0.0.6
```
- `ssh-keygen` gera o par (privada fica no hospedeiro; **pública** vai para `~/.ssh/authorized_keys` do servidor via `ssh-copy-id`). `sshd -t` testa a sintaxe; `sshd -T` mostra a configuração **efetiva** (importante: arquivos em `sshd_config.d/` podem sobrepor; vale a primeira ocorrência). Manter outra sessão aberta evita **se trancar fora** se algo der errado.
- **Esperado:** `permitrootlogin no`, `passwordauthentication no`; tentativa sem chave → `Permission denied (publickey,…)`.

## T6.7 Transferir e diagnosticar
```bash
# no hospedeiro
scp ryan@10.0.0.6:/opt/nuvemif/dados/uso_nuvem.csv . ; scp teste.txt ryan@10.0.0.6:~/
rsync -avz ryan@10.0.0.6:/opt/nuvemif/dados/ ./dados/
# no servidor
ss -tnp state established '( sport = :22 )'
sudo dnf install -y tcpdump
sudo tcpdump -i any port 80 -c 10 &   curl -s localhost >/dev/null ; wait
```
- `scp` copia via SSH; `rsync` copia **só diferenças** (rápido para repetir). `ss -tnp state established` mostra a conexão TCP da sua sessão SSH (porta 22 ↔ seu IP). `tcpdump -c 10` captura 10 pacotes e para; `-i any` todas as interfaces.
- **Esperado na captura:** `Flags [S]` (SYN), `[S.]` (SYN-ACK), `[.]` (ACK) — o *three-way handshake* — seguido de `[P.]` com `GET / HTTP/1.1` e a resposta `HTTP/1.1 200 OK`, e `[F.]` no fechamento.

### Perguntas para pensar — Módulo 6
**1. `--permanent` × runtime.** Sem `--permanent` a regra vale **só na memória** (efeito imediato); com `--permanent` fica gravada em disco mas **só entra em vigor após `--reload`** (ou reinício). Uma regra runtime-only **desaparece no `--reload`** (e no reboot), pois o reload recarrega a configuração permanente. Para promover: `firewall-cmd --runtime-to-permanent`.

**2. Serviço `http` × porta 80.** O serviço é um **nome que agrupa porta/protocolo** (e módulos auxiliares): mais legível/auditável ("liberei http"), e se a definição mudar a regra acompanha; evita erros de digitação. A **porta é a única opção** quando o serviço não existe em `/usr/lib/firewalld/services` (aplicação própria como a 8080/8081), ou para faixas/portas não-padrão.

### Ponto de conferência 6
| Tarefa | Verificação | Esperado |
|---|---|---|
| T6.2 | `hostnamectl --static` | `nuvemif-srv` |
| T6.2 | `nmcli -g ipv4.method …` | `manual` |
| T6.3 | `ss -tlnp` | nginx :80 e sshd :22 |
| T6.5 | `--list-services` | inclui ssh e http |
| T6.5 | `--list-ports` | vazio |
| T6.6 | `sshd -T` | `permitrootlogin no` / `passwordauthentication no` |
| T6.6 | ssh sem chave | `Permission denied` |

---

# MÓDULO 7 — Armazenamento e LVM

## T7.1 Reconhecer
```bash
lsblk -f ; sudo fdisk -l /dev/sdb ; sudo blkid ; df -hT ; cat /etc/fstab
```
- `lsblk -f` mostra FSTYPE/UUID por partição; `sdb` aparece com 2G **sem filhos e sem FSTYPE**; `fdisk -l /dev/sdb` só mostra o disco, sem tabela de partições; `blkid` não lista `sdb`. O disco do sistema (`sda`): `sda1` 1M (BIOS boot), `sda2` 1G `/boot`, `sda3` LVM com `openeuler-root` (`/`) e `openeuler-swap` — `df -hT` e o `fstab` mostram os tipos de sistema de arquivos usados.

## T7.2 Particionar (GPT)
```bash
sudo parted /dev/sdb --script mklabel gpt \
  mkpart backup ext4 1MiB 501MiB \
  mkpart dados 501MiB 100% \
  set 2 lvm on
sudo partprobe /dev/sdb ; lsblk /dev/sdb
```
- **GPT** = tabela moderna (>2 TB, muitas partições). Começar em 1 MiB garante **alinhamento**. `501MiB − 1MiB = 500 MiB` (a 1ª partição). `partprobe` avisa o kernel da nova tabela.
- **Esperado:** `sdb1 500M`, `sdb2 ~1,5G`.

## T7.3 ext4 e montagem permanente
```bash
sudo mkfs.ext4 /dev/sdb1
sudo mkdir -p /mnt/backup
UUID=$(sudo blkid -s UUID -o value /dev/sdb1)
echo "UUID=$UUID /mnt/backup ext4 defaults 0 2" | sudo tee -a /etc/fstab
sudo mount -a ; findmnt /mnt/backup
sudo reboot ; findmnt /mnt/backup
```
- `mkfs.ext4` cria o sistema de arquivos. O `fstab` tem 6 campos: dispositivo, ponto, tipo, opções, `dump`, ordem do `fsck`. **`mount -a` testa o fstab sem reiniciar** (um erro no fstab pode impedir o boot). **Esperado:** `findmnt` → `/mnt/backup /dev/sdb1 ext4 rw,relatime`, igual após o reboot.

## T7.4 LVM
```bash
sudo pvcreate /dev/sdb2
sudo vgcreate vg_nuvemif /dev/sdb2
sudo lvcreate -L 800M -n lv_dados vg_nuvemif
sudo mkfs.xfs /dev/vg_nuvemif/lv_dados
sudo mkdir -p /srv/dados
echo "/dev/mapper/vg_nuvemif-lv_dados /srv/dados xfs defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a
sudo rsync -a /opt/nuvemif/dados/ /srv/dados/
sudo rm -rf /opt/nuvemif/dados
sudo ln -s /srv/dados /opt/nuvemif/dados
pvs ; vgs ; lvs ; ls /opt/nuvemif/dados/uso_nuvem.csv
```
- LVM em camadas: **PV** (volume físico = a partição) → **VG** (grupo = pool de espaço) → **LV** (volume lógico, o "disco" que se formata/monta). `lvcreate -L` define o tamanho, `-n` o nome. O LV tem nome estável em `/dev/mapper/` e `/dev/<vg>/<lv>`, por isso o fstab pode usá-lo. `rsync -a` copia preservando atributos antes de remover o original; a **ligação simbólica** mantém `/opt/nuvemif/dados` funcionando.
- **Esperado:** `lvs` → `lv_dados vg_nuvemif … 800.00m`; o CSV existe via link.

## T7.5 Crescer a quente
```bash
sudo lvextend -L +400M -r /dev/vg_nuvemif/lv_dados     
# equivalente: sudo lvextend -L +400M /dev/vg_nuvemif/lv_dados && sudo xfs_growfs /srv/dados
lvs ; vgs ; df -h /srv/dados
```
- O LV cresce com o volume **montado** e o `xfs_growfs` (XFS só **cresce**, nunca encolhe) expande o sistema de arquivos. **Esperado:** `lv_dados 1.17g` (800+400 = 1200 MiB) e `df` ≈ `1.2G`. O VG tem ~1,5 GiB; sobram ≈ **340 MiB** livres (`VFree` em `vgs`; anote o seu).

## T7.6 Swap em arquivo
```bash
free -h
sudo dd if=/dev/zero of=/swapfile bs=1M count=512 status=progress
sudo chmod 600 /swapfile ; sudo mkswap /swapfile ; sudo swapon /swapfile
echo "/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab
swapon --show ; free -h
```
- `chmod 600` é obrigatório (swap legível por outros vazaria memória); `mkswap` formata; `swapon` ativa; o `fstab` torna permanente. **Esperado:** `swapon --show` com `/swapfile 512M`; o swap total sobe de 4,0 GiB para ~4,5 GiB.

## T7.7 Quem ocupa o espaço
```bash
sudo du -xh --max-depth=1 /var | sort -rh | head -10
sudo find / -xdev -type f -size +50M -exec ls -lh {} + 2>/dev/null | sort -k5 -rh | head -5
df -i
```
- `du -x` não atravessa outros sistemas de arquivos; `sort -rh` ordena tamanhos legíveis (K/M/G) do maior ao menor; `-xdev` no `find` idem. **`df -i`** mostra uso de **inodes**.
- **Disco "cheio" com bytes livres:** acontece quando **os inodes acabaram** (milhões de arquivos minúsculos: `IUse% 100%`) — cada arquivo consome 1 inode independente do tamanho. Outras causas: espaço reservado a root (ext4) ou arquivos apagados ainda abertos por processos (`lsof +L1`).

## T7.8 Quebrar e consertar (com snapshot)
```bash
echo "UUID=00000000-0000-0000-0000-000000000000 /mnt/errado ext4 defaults 0 2" | sudo tee -a /etc/fstab
sudo reboot
```
- **O que se vê:** a tela fica em `A start job is running for /dev/disk/by-uuid/0000… (1min 30s)`; depois `Timed out waiting for device`, `Dependency failed for /mnt/errado`, `Dependency failed for Local File Systems` e `You are in emergency mode. … Give root password for maintenance`.
- **Correção** (no prompt de emergência, com a senha de root):
```bash
mount -o remount,rw /
vi /etc/fstab           
systemctl daemon-reload
mount -a                 
systemctl default        
```
- Prevenção: opção `nofail` para volumes não essenciais, e sempre `mount -a` antes de reiniciar.

### Perguntas para pensar — Módulo 7
**1. Por que UUID e não `/dev/sdb1`?** Os nomes `sdX` são atribuídos **na ordem de detecção** e podem mudar entre boots (disco novo, troca de porta/controlador, ordem de inicialização) — `sdb1` pode virar `sdc1` e o fstab montaria o disco errado (ou nenhum). O **UUID pertence ao sistema de arquivos** e acompanha os dados.

**2. Vantagens do LVM na T7.5 e limitação do XFS.** Sem desmontar nem reparticionar, o LV cresceu usando espaço livre do VG (poderia usar até outros discos adicionados ao VG); uma partição comum exigiria mover/recriar partições, com risco e parada. **XFS não pode ser reduzido**; o **ext4 pode** (offline, com `resize2fs`).

### Ponto de conferência 7
| Tarefa | Verificação | Esperado |
|---|---|---|
| T7.2 | `lsblk` do disco de 2 GB | duas partições, a 1ª de 500M |
| T7.3 | `findmnt /mnt/backup` após reboot | montado, ext4 |
| T7.4 | `lvs` | `lv_dados` em `vg_nuvemif`, 800.00m |
| T7.4 | `ls /opt/nuvemif/dados/uso_nuvem.csv` | existe (via link) |
| T7.5 | `lvs` / `df -h /srv/dados` | 1.17g / ≈1.2G |
| T7.6 | `swapon --show` | arquivo de 512M ativo |
| T7.8 | boot após a correção | sistema inicia normalmente |

---

# MÓDULO 8 — Shell script e automação

(Os scripts completos e **testados** estão em `scripts/`; copie para `~/bin` na VM e dê `chmod +x`.)

## T8.1 Consertar `relatorio_quebrado.sh`
```bash
bash -n scripts/relatorio_quebrado.sh      
bash -x scripts/relatorio_corrigido.sh /opt/nuvemif/dados/uso_nuvem.csv PRJ-004    
```
Erros encontrados e correções (versão em `scripts/relatorio_corrigido.sh`):
1. **Sintaxe:** `if [ -z $projeto ] then` — falta `;` (ou quebra de linha) antes do `then`. → `if [ -z "$projeto" ]; then`.
2. **Aspas:** `[ -z $projeto ]` e `[ ! -f $arquivo ]` sem aspas quebram com valor vazio ou com espaços (o `[` recebe argumentos errados). → sempre `"$var"`.
3. **Lógica na seleção:** `grep $projeto $arquivo` casa a *string* em qualquer coluna/linha (inclusive substrings como `PRJ-0041`) e deixa passar o cabeçalho. → comparar só a coluna 4 e pular a linha 1 (`[ "$proj" = "$projeto" ] || continue` com `tail -n +2`).
4. **Variável perdida no `while` com pipe:** `grep … | while …` roda o laço num **subshell**; `total` e `linhas` voltam a `0` ao final. → alimentar o `while` por redirecionamento: `done < <(tail -n +2 "$arquivo")`.

**Saída esperada (testada):** `Projeto PRJ-004: 539 registros, custo total R$ 12486.39`.

## T8.2 `~/bin/relatorio_custo.sh` (`scripts/relatorio_custo.sh`)
```bash
relatorio_custo.sh                         
Custo total: 65984.13
relatorio_custo.sh -p PRJ-004              
Projeto PRJ-004: 539 registros, custo 12486.39
relatorio_custo.sh -d 2026-09-16           
Dia 2026-09-16: custo 2865.97, 113 instancias ativas
relatorio_custo.sh -a /nao/existe ; echo $?    
3
relatorio_custo.sh -x ; echo $?                
2
```
- `getopts ":p:d:a:h"` lê as opções (o `:` depois da letra = leva argumento; `:` inicial = modo silencioso, tratamos erros no `case`); `case` decide a ação; `[[ -f ]]` valida o arquivo; **códigos de saída:** 0 sucesso, **2 uso incorreto**, **3 arquivo inexistente** (diferentes entre si e de 0, como exige o checkpoint); `awk` soma (mais rápido e correto com decimais do que `bc` em laço). "Instâncias ativas" = instâncias distintas com `status=running` no dia.

## T8.3 `~/bin/alerta_erros.sh` (`scripts/alerta_erros.sh`)
```bash
alerta_erros.sh            
# limite padrão 25
2026-09-07: 26 erros
2026-09-09: 26 erros
2026-09-12: 29 erros
echo $?                    
1
alerta_erros.sh 100 ; echo $?   
0
```
- `awk` conta linhas `[ERROR]` por data (`$1`), imprime as acima do limite (`$1` = limite padrão 25, alterável por argumento); o script termina com **1** se houver dias acima, **0** se não — útil em cron/monitoramento. **Esperado (conferido):** 3 dias; o maior é **2026-09-12 com 29**.

## T8.4 `~/bin/gera_relatorios.sh` (`scripts/gera_relatorios.sh`)
```bash
sudo mkdir -p /srv/dados/relatorios && sudo chown $USER /srv/dados/relatorios
gera_relatorios.sh ; ls /srv/dados/relatorios | wc -l
```
- `for/while read` percorre cada projeto único (`cut | sort -u`); a **função** `calcula` isola o cálculo (reuso/legibilidade); `mkdir -p` cria sem erro se existir; `printf` formata o arquivo. **Esperado (conferido):** `14 arquivos gerados em /srv/dados/relatorios`, e `PRJ-004.txt` com `Registros: 539` / `Custo total (R$): 12486.39`.

## T8.5 Agendar com cron
```bash
sudo dnf install -y cronie ; sudo systemctl enable --now crond
crontab -e
0 7 * * * /home/ryan/bin/alerta_erros.sh >> /home/ryan/alertas.log 2>&1
crontab -l
sudo tee /etc/cron.d/nuvemif-limpeza <<'EOF'
0 3 * * 0 root find /opt/nuvemif/arquivos -type f -name '*.tmp' -mtime +30 -delete
EOF
```
- Formato `min hora dia-mês mês dia-semana comando`: `0 7 * * *` = todo dia às 07:00; `0 3 * * 0` = domingo 03:00. Em `/etc/cron.d/` há um **campo extra de usuário** (`root`). `>> … 2>&1` anexa stdout **e** stderr ao log. Use **caminhos absolutos** (o cron tem `PATH` mínimo). `-mtime +30` = modificado há mais de 30 dias.

## T8.6 Agendar com systemd (`systemd/nuvemif-backup.service` e `.timer`)
```bash
sudo cp systemd/nuvemif-backup.* /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now nuvemif-backup.timer
sudo systemctl start nuvemif-backup.service
ls -l /mnt/backup ; systemctl list-timers | grep nuvemif
```
- `Type=oneshot` = executa uma tarefa e termina (o systemd considera concluído quando o processo sai). **`tar -czhf`**: o **`-h` segue a ligação simbólica** `/opt/nuvemif/dados → /srv/dados` (sem ele o backup guardaria só o *link*!). No unit, `%%` e `$$` escapam `%` e `$` para o `date` chegar ao bash. Timer: `OnCalendar=*-*-* 02:00:00` (todo dia 02:00) e **`Persistent=true`** (se a máquina estava desligada às 02:00, executa ao ligar).
- **Esperado:** `/mnt/backup/nuvemif-AAAA-MM-DD.tar.gz` e `nuvemif-backup.timer` em `list-timers`.

## T8.7 Scripts que falham bem
```bash
set -euo pipefail
TMP=$(mktemp) ; trap 'rm -f "$TMP"' EXIT
[[ -f $CSV ]] || { echo "erro: CSV nao encontrado: $CSV" >&2; exit 2; }
```
```bash
gera_relatorios.sh /nao/existe ; echo $?
erro: CSV nao encontrado: /nao/existe        # (testado)   → saída 2, nenhum temporário sobra
```
- `-e` aborta no primeiro comando que falha; `-u` erro em variável não definida; `-o pipefail` uma falha em qualquer parte do pipe falha o pipe todo; `trap … EXIT` executa a limpeza **sempre que o script termina** (sucesso, erro ou Ctrl+C), e a validação explícita dá mensagem clara.

### Perguntas para pensar — Módulo 8
**1. cron × timer; duas coisas que o timer faz e o cron não.** Cron é simples e universal para "rodar X na hora Y". O **timer** do systemd: (a) **`Persistent=true`** — recupera execuções perdidas com a máquina desligada (o cron simplesmente perde); (b) integra com o **journal** (logs/`status` por unidade), **dependências e ordem**, `systemctl list-timers`, limites de recursos (cgroups), `RandomizedDelaySec`, e timers **relativos ao boot** (`OnBootSec`), além de evitar sobreposição (não inicia se o serviço ainda roda).

**2. `while read` com pipe perde variáveis; duas formas de evitar.** Cada lado do `|` roda num **subshell** (processo filho) e as variáveis alteradas nele **somem** quando termina. Soluções: (1) **redirecionar** em vez de pipe — `done < arquivo` ou **substituição de processo** `done < <(comando)`; (2) `shopt -s lastpipe` (bash não-interativo: o último comando do pipe roda no shell atual) ou fazer a soma dentro do `awk`/usar here-string.

### Ponto de conferência 8
| Tarefa | Verificação | Esperado |
|---|---|---|
| T8.1 | script corrigido com PRJ-004 | 539 registros, R$ 12486.39 |
| T8.2 | `-p PRJ-004`; `-d 2026-09-16`; sem opções | 12486.39; 2865.97; 65984.13 |
| T8.2 | saída com `-a /nao/existe` | 3 (≠0 e ≠ 2 de uso incorreto) |
| T8.3 | dias > 25 erros; maior | 3; 2026-09-12 com 29 |
| T8.4 | arquivos em `/srv/dados/relatorios/` | 14 |
| T8.5 | `crontab -l` | linha `0 7 * * *` com o script |
| T8.6 | `list-timers` / `/mnt/backup` | `nuvemif-backup.timer` / `nuvemif-AAAA-MM-DD.tar.gz` |

---

# MÓDULO 9 — Segurança

> Snapshot antes de começar.

## T9.1 Estado do SELinux
```bash
getenforce ; sestatus ; grep '^SELINUX=' /etc/selinux/config
sudo setenforce 0 ; getenforce ; sudo setenforce 1 ; getenforce
```
- `getenforce` mostra o modo; `sestatus` detalha **política carregada** (`targeted`), modo atual e do arquivo; **`/etc/selinux/config`** (`SELINUX=enforcing|permissive|disabled`) define o modo do **próximo boot**; `setenforce 0|1` alterna entre permissivo e restritivo **em tempo de execução** (sem reiniciar).
- **Modos:** *Enforcing* — aplica a política e **bloqueia** violações (registra no audit); *Permissive* — **só registra** (AVC), não bloqueia — útil para diagnóstico; *Disabled* — desligado (reativar exige reboot e relabel do sistema de arquivos).
- **Esperado final:** `Enforcing`.

## T9.2 Contexto de arquivos (corrigir o 403)
```bash
ls -Zd /srv/painel /usr/share/nginx/html ; ls -Z /srv/painel/index.html
sudo ausearch -m AVC -ts recent | tail
sudo ausearch -m AVC -ts recent | audit2why
sudo dnf install -y policycoreutils-python-utils
sudo semanage fcontext -a -t httpd_sys_content_t "/srv/painel(/.*)?"
sudo restorecon -Rv /srv/painel
curl -s -o /dev/null -w '%{http_code}\n' http://localhost:8080/
```
- `ls -Z` mostra o **contexto** (`usuário:papel:tipo:nível`); o que importa é o **tipo**: `/usr/share/nginx/html` é `httpd_sys_content_t` (o nginx pode ler), mas `/srv/painel` herdou `var_t`. O `ausearch -m AVC` mostra a negação (`denied { read } … scontext=…httpd_t tcontext=…var_t`); `audit2why` explica a causa.
- **`semanage fcontext -a`** grava uma **regra permanente** de rotulagem (sobrevive a `restorecon`/relabel); `restorecon -Rv` aplica a regra aos arquivos. **Por que não `chcon`:** ele muda só o arquivo, **temporariamente** (se perde num relabel/`restorecon`).
- **Esperado:** `httpd_sys_content_t` em `index.html` e `200`.

## T9.3 Portas e booleanos
```bash
sudo sed -i 's/listen 80 default_server;/listen 8088;/' /etc/nginx/conf.d/painel.conf
sudo nginx -t ; sudo systemctl reload nginx          
falha: bind() to 0.0.0.0:8088 failed (13: Permission denied)
sudo semanage port -l | grep http_port_t
sudo semanage port -a -t http_port_t -p tcp 8088
sudo systemctl reload nginx ; curl -s -o /dev/null -w '%{http_code}\n' http://localhost:8088/
getsebool -a | grep httpd
sudo setsebool -P httpd_can_network_connect on       
sudo sed -i 's/listen 8088;/listen 80 default_server;/' /etc/nginx/conf.d/painel.conf && sudo systemctl reload nginx
```
- O SELinux também controla **quais portas cada serviço pode abrir**: o nginx (`httpd_t`) só pode escutar em portas do tipo `http_port_t` (80, 443, 8008, 8009, 8443…); a 8088 não está → *Permission denied*. `semanage port -a` registra a porta. **Booleanos** (`getsebool -a`) são "chaves" da política (`setsebool -P` = persistente): **`httpd_can_network_connect`** permite que processos do httpd/nginx façam **conexões de rede de saída** (ex.: *proxy reverso*/aplicação consultando banco ou API externa); desligado por padrão.
- **Esperado:** `semanage port -l | grep http_port_t` inclui **8088**; ao final o site volta à porta 80.

## T9.4 Endurecimento do openEuler
```bash
sudo less /etc/openEuler_security/security.conf        
sudo grep -n -i sshd /etc/openEuler_security/security.conf
sudo less /etc/openEuler_security/usr-security.conf    
sudo systemctl restart openEuler-security.service
sudo tail /var/log/openEuler-security.log
sudo sshd -T | grep -i permitrootlogin
```
- A ferramenta de *hardening* do openEuler aplica, a cada boot (serviço `openEuler-security.service`), itens de segurança definidos em arquivos: `security.conf` (padrão do sistema) e `usr-security.conf` (**customizações do administrador**, que não são sobrescritas em atualizações). Cinco categorias de itens que você deve identificar no seu arquivo (copie as linhas reais): **política de senha/expiração** (ex.: máximo de dias), **umask** padrão restritiva, **timeout de sessão** (`TMOUT`), **permissões de arquivos sensíveis** (`/etc/passwd`, `/etc/shadow`…) e **configurações do sshd** (ciphers/MACs, banner, limites de tentativas). O resultado fica registrado em `/var/log/openEuler-security.log`.
- **Esperado:** `permitrootlogin no` e a ação do item registrada no log. (O formato exato das linhas varia por versão; sempre copie um item de sshd existente como modelo.)

## T9.5 Auditoria (auditd)
```bash
sudo dnf install -y audit ; sudo systemctl enable --now auditd
sudo auditctl -w /opt/nuvemif/config -p wa -k nuvemif_config
echo '-w /opt/nuvemif/config -p wa -k nuvemif_config' | sudo tee /etc/audit/rules.d/nuvemif.rules
sudo augenrules --load ; sudo auditctl -l
sudo sed -i 's/^intervalo=.*/intervalo=15/' /opt/nuvemif/config/coletor.conf
sudo ausearch -k nuvemif_config -i | tail -20
sudo aureport -au
```
- `-w caminho` observa; `-p wa` = **w**rite e **a**ttribute change; `-k` define a **chave** de busca. Regras em `auditctl` valem até o reboot; em **`/etc/audit/rules.d/`** + `augenrules --load` ficam **persistentes**. `ausearch -k … -i` traduz IDs: mostra `type=SYSCALL … auid=ryan uid=root comm="sed" exe="/usr/bin/sed"` (quem — `auid` é o usuário original de login — e **com qual comando**) e o `PATH` alterado. `aureport -au` resume eventos de **autenticação** (logins, falhas).
- **Esperado:** `auditctl -l` → `-w /opt/nuvemif/config -p wa -k nuvemif_config`.

## T9.6 Senhas e bloqueio
```bash
# complexidade
sudo sed -i 's/^#\? *minlen.*/minlen = 12/;s/^#\? *minclass.*/minclass = 3/' /etc/security/pwquality.conf
# bloqueio: /etc/security/faillock.conf
printf 'deny = 5\nunlock_time = 600\n' | sudo tee -a /etc/security/faillock.conf
# nos arquivos /etc/pam.d/system-auth e password-auth, adicionar (antes/depois de pam_unix):
#   auth     required   pam_faillock.so preauth silent
#   auth     [default=die] pam_faillock.so authfail
#   account  required   pam_faillock.so
sudo -u bruno passwd              # senha curta → "BAD PASSWORD: The password is shorter than 12 characters"
for i in 1 2 3 4 5; do su - ana -c true <<< "errada"; done      # cinco falhas
sudo faillock --user bruno ; sudo faillock --user bruno --reset
```
- `pwquality` define regras ao **trocar** a senha: `minlen=12` (comprimento) e `minclass=3` (precisa de 3 das 4 classes: minúsculas, maiúsculas, dígitos, símbolos). O **`pam_faillock`** conta falhas por usuário: `deny=5` e `unlock_time=600` s (10 min). `faillock --user` mostra os registros de falha e `--reset` **desbloqueia**. **Cuidado:** edite PAM com uma sessão root aberta e salve cópia antes — erro em PAM pode impedir login.
- **Esperado:** senha fraca recusada; após cinco falhas `faillock --user bruno` lista **5 registros** e a conta fica bloqueada por 10 min.

## T9.7 Integridade e atualizações
```bash
sudo rpm -Va | grep '^..5'             
dnf updateinfo list security
dnf updateinfo info | head -40
dnf updateinfo list security | grep -i openssh
```
- `rpm -Va` verifica **todos** os pacotes; o filtro `^..5` mantém quem teve o **checksum alterado**; os arquivos de configuração (`c`) alterados são esperados (ex.: `/etc/ssh/sshd_config`, `/etc/sudoers`, os que você editou), enquanto binários alterados são alerta de comprometimento. `updateinfo list security` mostra os **avisos de segurança (SA)** `openEuler-SA-AAAA-NNNN` com **severidade** (Critical/Important/Moderate/Low). Registre os resultados reais; se não houver avisos pendentes, indique "nenhum".

## T9.8 secGear (resposta ≤ 10 linhas)
> O **secGear** é o framework de **computação confidencial** do openEuler: unifica o desenvolvimento de aplicações que executam código sensível dentro de um **TEE** (*Trusted Execution Environment* — ambiente de execução confiável, uma área isolada pelo hardware, como o *enclave* do Intel SGX ou o TrustZone da Arm, onde código e dados ficam protegidos até do SO e do administrador). Ele resolve a **proteção de dados em uso** (criptografia protege dados em repouso/trânsito, não durante o processamento) e a **dificuldade de portar** apps entre SDKs de TEE diferentes, fornecendo uma API única. **Exige CPU com suporte a TEE** (SGX em x86, TrustZone/virtCCA em Arm/Kunpeng). Entra na etapa de **desenvolvimento**: o programador **particiona** a aplicação em parte segura e não segura, descrevendo a interface em um arquivo `.edl`, a ferramenta de geração de código cria os *stubs* e as chamadas (ECALL/OCALL) e então se compila e executa. Como a VM (VirtualBox) não tem esse hardware, não foi possível instalar/compilar o exemplo.

### Perguntas para pensar — Módulo 9
**1. O nginx rodava como root? Por que o SELinux ainda bloqueou?** O processo **mestre** roda como root (para abrir a porta 80), mas os *workers* que atendem as requisições rodam como o usuário **`nginx`**, sem privilégios. As permissões tradicionais (DAC: dono/grupo/outros) **não eram o problema** — `/srv/painel` e `index.html` eram legíveis (755/644). O SELinux é **controle de acesso obrigatório (MAC)**, avaliado **em adição** ao DAC e baseado em **tipos**: o processo no domínio `httpd_t` só pode ler arquivos de tipos permitidos (`httpd_sys_content_t`), e `/srv/painel` estava como `var_t` → negado — vale **até para root** (processo confinado).

**2. Por que desligar o SELinux é errado; qual a sequência?** Desligar remove uma camada de proteção do **sistema inteiro** por causa de um problema localizado — se o serviço for explorado, o invasor deixa de ser contido. A sequência certa: (1) reproduzir o erro; (2) ler a negação (`ausearch -m AVC -ts recent`, `journalctl -t setroubleshoot`) e `audit2why`; (3) verificar **rótulo** (`ls -Z`, corrigir com `semanage fcontext` + `restorecon`); (4) verificar **porta** (`semanage port`); (5) verificar **booleano** (`getsebool`/`setsebool -P`); (6) só em último caso, módulo de política personalizado (`audit2allow`); para depurar use modo permissivo **temporário** (`setenforce 0`, ou `semanage permissive -a httpd_t` só para o domínio) e depois volte a `Enforcing`.

### Ponto de conferência 9
| Tarefa | Verificação | Esperado |
|---|---|---|
| T9.1 | `getenforce` ao final | `Enforcing` |
| T9.2 | `ls -Z /srv/painel/index.html` | `httpd_sys_content_t` |
| T9.2 | `curl -s -o /dev/null -w '%{http_code}' http://localhost/` | `200` |
| T9.3 | `semanage port -l \| grep http_port_t` | inclui 8088 |
| T9.4 | `sshd -T \| grep permitrootlogin` | `permitrootlogin no` |
| T9.5 | `auditctl -l` | regra com `-k nuvemif_config` |
| T9.6 | `faillock --user bruno` após 5 falhas | 5 registros, conta bloqueada |

---

# MÓDULO 10 — Desempenho e recursos próprios do openEuler

## T10.1 Medir antes de ajustar
```bash
sudo dnf install -y sysstat stress-ng
uptime ; vmstat 1 5 ; iostat -x 1 5 ; free -h ; ss -s ; top -bn1 | head -15      # BASE
for i in 1 2; do (timeout 60 sh -c 'while :; do sha256sum /opt/nuvemif/dados/uso_nuvem.csv >/dev/null; done' &); done
# (ou: stress-ng --cpu 2 --timeout 60s)  — e, durante a carga, repita os comandos acima
```
- `uptime` carga média; **`vmstat 1 5`**: `r` (fila de execução), `us/sy/id/wa` (% CPU usuário/sistema/ocioso/espera de E/S), `si/so` (swap), `bi/bo` (disco); `iostat -x` (precisa de `sysstat`) mostra `%util`/`await` por disco; `sar` registra histórico; `ss -s` resume sockets.
- **Qual indicador mudou mais?** A **CPU**: `%us` sobe de ~0–2% para ~100% (e `id` cai a ~0), a fila `r` ≥ 2 e o **load average** sobe de ~0,1 para ≈ 2 (2 vCPUs saturadas). Memória, swap, disco (o arquivo fica em cache) e rede ficam praticamente iguais — a carga é **CPU-bound**.

## T10.2 Parâmetros do kernel
```bash
sysctl vm.swappiness net.core.somaxconn fs.file-max
sudo tee /etc/sysctl.d/90-nuvemif.conf <<'EOF'
vm.swappiness = 10
net.core.somaxconn = 4096
EOF
sudo sysctl --system
sysctl vm.swappiness net.core.somaxconn
ulimit -n ; ulimit -Hn
echo "ryan soft nofile 65535" | sudo tee /etc/security/limits.d/90-nuvemif.conf
echo "ryan hard nofile 65535" | sudo tee -a /etc/security/limits.d/90-nuvemif.conf
```
- **`vm.swappiness`** (0–100): quão agressivo o kernel usa swap (padrão 60; 10 = prefere manter dados na RAM); **`net.core.somaxconn`**: tamanho máximo da fila de conexões pendentes de um `listen()` (servidores web com muitos acessos); **`fs.file-max`**: limite global de arquivos abertos. `sysctl -w` muda **só em tempo de execução**; um arquivo em `/etc/sysctl.d/` + `sysctl --system` torna **persistente**. `ulimit -n` mostra o limite de arquivos abertos **do usuário** (padrão 1024 soft); para elevar, `limits.d` (vale em **novo login**); para serviços systemd, use `LimitNOFILE=` na unit.
- **Esperado após reiniciar:** `vm.swappiness = 10` e `net.core.somaxconn = 4096`.

## T10.3 A-Tune
```bash
sudo dnf search atune ; sudo dnf install -y atune atune-engine
sudo systemctl enable --now atuned atune-engine ; systemctl is-active atuned
atune-adm list
sysctl -a > /tmp/antes.txt
sudo atune-adm profile web-nginx-http-long-connection
sysctl -a > /tmp/depois.txt ; diff /tmp/antes.txt /tmp/depois.txt
sudo atune-adm rollback
atune-adm list                  # nenhum perfil com Active = true
while true; do curl -s http://localhost >/dev/null; done &      # carga
sudo atune-adm analysis ; kill %1
```
- O **A-Tune** é o motor de **ajuste automático de desempenho** do openEuler: `atuned` (serviço local), `atune-engine` (inteligência/modelos) e `atune-adm` (cliente). Ele **identifica o tipo de carga** (CPU, rede, E/S, web…) e aplica um **perfil** (conjunto de parâmetros de kernel/sistema). `atune-adm list` mostra os perfis e a coluna **Active**; `profile` aplica; **`rollback`** restaura o estado anterior. O `diff` mostrará parâmetros alterados (tipicamente `net.*`, `vm.*`, filas/buffers de rede).
- **Esperado:** `atuned` = `active`; após o rollback nenhum perfil com `Active true`. O perfil recomendado pelo `analysis` **depende da carga medida** — copie o nome que o seu comando retornar (para tráfego HTTP em laço costuma sugerir um perfil `web-nginx-*`/de rede). Se o pacote não existir no repositório, procure no EPOL (`dnf --enablerepo=EPOL search atune`).

## T10.4 iSulad
```bash
sudo dnf install -y iSulad ; sudo systemctl enable --now isulad
sudo vi /etc/isulad/daemon.json        # incluir:  "registry-mirrors": ["docker.io"]
sudo systemctl restart isulad
sudo isula pull openeuler/openeuler:24.03-lts-sp4
sudo isula run -tid --memory 256m --cpus 1 --name teste openeuler/openeuler:24.03-lts-sp4 bash
sudo isula exec -it teste bash ; cat /etc/os-release ; exit
sudo isula ps -a ; sudo isula images
sudo isula stop teste ; sudo isula rm teste ; sudo isula ps -a
```
- O **iSulad** é um motor de contêineres **leve** (escrito em C/C++), compatível com imagens **OCI** e com a **CRI** do Kubernetes. `registry-mirrors` informa de onde baixar imagens. `run -tid` = **t**erminal, **i**nterativo, **d**etached; `--memory 256m`/`--cpus 1` aplicam limites por **cgroups**; `exec` abre shell dentro do contêiner em execução.
- **Esperado:** dentro do contêiner `NAME="openEuler"`, `VERSION="24.03 (LTS-SP4)"`; após o `rm`, `isula ps -a` sem contêineres.
- **Comparação com Docker:** a sintaxe é praticamente idêntica (`isula` ↔ `docker`: `pull`, `run`, `exec`, `ps`, `images`, `stop`, `rm`, mesmas flags comuns); diferenças: o daemon é `isulad` (mais leve em memória e com foco em Kubernetes/CRI e em ARM/embarcados), e recursos como *build* ficam em ferramentas à parte (`isula-build`) em vez de embutidos.

## T10.5 Contêiner como serviço
```bash
sudo isula run -d --name painel -p 8081:80 -v /srv/painel:/usr/share/nginx/html:ro nginx
sudo firewall-cmd --permanent --add-port=8081/tcp ; sudo firewall-cmd --reload
curl -s -o /dev/null -w '%{http_code}\n' http://localhost:8081/
```
- `-p 8081:80` publica a porta 80 do contêiner na 8081 do host; `-v origem:destino:ro` monta o diretório **somente leitura** (o contêiner não altera o painel). Como a porta foi aberta só para este teste, **remova-a depois** se quiser manter o firewall mínimo (`--remove-port=8081/tcp`). Se retornar 403, é rótulo SELinux do volume (veja `ausearch -m AVC`).
- **Esperado:** `200`.

## T10.6 Virtualização
```bash
ls -l /dev/kvm ; lscpu | grep -i -E 'virtualization|vmx|svm'
sudo dnf install -y stratovirt
```
- **/dev/kvm** só existe se o hospedeiro expõe virtualização aninhada. **No seu laboratório não existe:** o `lscpu` registrou `Itlb multihit: KVM: Mitigation: VMX unsupported` (a VM no VirtualBox não expõe VMX), então **não é possível iniciar a micro-VM** — registre essa evidência no relatório.
- **O que o StratoVirt tem em comum com o QEMU:** ambos são *monitores de VM* em espaço de usuário que usam o **KVM** do kernel e dispositivos **virtio**, emulando a máquina para o SO convidado. **Diferenças:** o StratoVirt é escrito em **Rust** (segurança de memória), tem modelo de dispositivos **mínimo** (tipo de máquina *microvm*: sem BIOS/PCI legados), com **inicialização muito rápida (dezenas de ms)**, **pouca memória** e **superfície de ataque pequena**; o QEMU é generalista, com enorme catálogo de dispositivos/arquiteturas, mas mais pesado. **Quando a Huawei indica:** nuvem nativa/*serverless*, **contêineres seguros** (isolamento por VM, p.ex. com iSulad/Kata), alta densidade e implantação rápida, **borda/embarcado**; também suporta VMs padrão (*standard VM*).

## T10.7 Kernel e manutenção
```bash
rpm -q kernel ; sudo grubby --info=ALL ; sudo grubby --default-kernel
```
- `rpm -q kernel` lista os kernels instalados; `grubby --info=ALL` mostra as entradas de boot; `--default-kernel` o caminho do padrão (**esperado:** `/boot/vmlinuz-6.6.0-…oe2403sp4.x86_64`).
- **nvwa (atualização de kernel sem reinicialização):** permite trocar o kernel **preservando os processos em execução**: salva o estado dos processos (*checkpoint*), carrega o novo kernel via **kexec** e **restaura** os processos, reduzindo drasticamente a indisponibilidade (sem passar por firmware/boot completo). **Limitações:** funciona com certos tipos de processos e recursos que consiga salvar/restaurar (conexões de rede, dispositivos e estados específicos podem não ser suportados); exige kernel compatível/ configuração e arquitetura suportada; ainda há uma **breve interrupção**; não é para qualquer aplicação (precisa de teste prévio).
- **KAE (Kunpeng Accelerator Engine):** usa **aceleradores de hardware integrados aos processadores Kunpeng 920** para **criptografia** (RSA, AES, SM3/SM4…) e **compressão** (zlib/gzip), expostos via *engine* do OpenSSL e bibliotecas zlib. Só faz sentido em **Kunpeng** porque depende desse hardware e dos drivers correspondentes — em x86 não há o acelerador.

## T10.8 Migração (x2openEuler)
> O **x2openEuler** é a ferramenta de **avaliação e migração** de sistemas (principalmente **CentOS**) para o openEuler. Na **avaliação** ele inventaria o sistema de origem e verifica a **compatibilidade**: pacotes de software e dependências (se existem equivalentes nos repositórios openEuler), **kernel/módulos e drivers**, configurações, serviços e a **arquitetura/hardware**, gerando um **relatório** com itens compatíveis e riscos. As etapas gerais: (1) instalar a ferramenta e coletar informações do sistema; (2) **avaliar** e gerar o relatório; (3) **corrigir pendências** e fazer backup; (4) **executar a migração** (troca de repositórios e pacotes, kernel e boot); (5) **reiniciar e validar** serviços e aplicações. (Confirme comandos e versões na documentação oficial.)

### Perguntas para pensar — Módulo 10
**1. Risco de aplicar um perfil do A-Tune em produção sem medir antes?** Os perfis alteram parâmetros **globais** de kernel/sistema; um perfil pensado para uma carga pode **degradar outra** (ou o próprio serviço), consumir mais memória, gerar instabilidade e **perder desempenho sem que ninguém perceba**, pois não existe linha de base para comparar. O `rollback` desfaz os parâmetros, mas não evita o impacto durante o teste. Boas práticas: **medir antes e depois**, testar em homologação, aplicar em janela controlada e documentar.

**2. Contêiner × micro-VM × VM completa.**
| | Contêiner | Micro-VM | VM completa |
|---|---|---|---|
| Isolamento | **Menor** — compartilha o kernel do host (namespaces/cgroups) | **Alto** — kernel próprio, isolado por hardware (KVM) | **Mais alto** — máquina completa, mais dispositivos |
| Tempo de início | milissegundos | dezenas/centenas de ms | segundos a dezenas de segundos |
| Memória | MBs (só o processo) | dezenas de MB | centenas de MB a GB |
- **Para o agente coletor:** um **contêiner** (iSulad) — é um processo simples, de confiança, que precisa subir rápido e gastar pouco; se fosse executar código de terceiros/multi-inquilino, a micro-VM (StratoVirt) seria a melhor escolha.

### Ponto de conferência 10
| Tarefa | Verificação | Esperado |
|---|---|---|
| T10.2 | `sysctl vm.swappiness net.core.somaxconn` após reiniciar | 10 ; 4096 |
| T10.3 | `systemctl is-active atuned` | `active` |
| T10.3 | `atune-adm list` após rollback | nenhum perfil com Active = true |
| T10.4 | `isula ps -a` após `rm` | nenhum contêiner |
| T10.5 | `curl … localhost:8081/` | `200` |
| T10.7 | `grubby --default-kernel` | caminho do kernel 6.6 em `/boot` |

---

## Arquivos entregues (caminhos originais na VM)
| Arquivo | Destino na VM |
|---|---|
| `scripts/relatorio_corrigido.sh` | `/opt/nuvemif/scripts/` (T8.1) |
| `scripts/relatorio_custo.sh`, `alerta_erros.sh`, `gera_relatorios.sh` | `~/bin/` (T8.2–T8.4, T8.7) |
| `systemd/coletor.service` | `/etc/systemd/system/` (T4.3) |
| `systemd/nuvemif-backup.service` / `.timer` | `/etc/systemd/system/` (T8.6) |
| `config/nuvemif.logrotate` | `/etc/logrotate.d/nuvemif` (T4.7) |
| `config/nuvemif.sudoers` | `/etc/sudoers.d/nuvemif` (T3.7) |
| `config/painel.conf` | `/etc/nginx/conf.d/painel.conf` (T6.4) |
| `config/90-nuvemif.conf` | `/etc/sysctl.d/` (T10.2) |
| `config/nuvemif.rules` | `/etc/audit/rules.d/` (T9.5) |
