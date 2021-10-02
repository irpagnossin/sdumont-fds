# Scripts úteis

Siga os passos abaixo para disponibilizar, na sua linha de comando (shell), os seguintes comandos:
- `fds-sync`: sincroniza sua pasta de trabalho local com a `$HOME` e `$SCRATCH` no SDumont.
- `fds-sbatch`: submete um job do FDS ao Slurm do SDumont.

Esta pasta contém dois arquivos ocultos:
- `.fdsrc_sdumont`
- `.fdsrc_localhost`

Note que os dois comandos acima são executados a partir da **máquina local**. Você só precisa garantir que a máquina SDumont esteja acessível (VPN ativa).

## Instalação
Atenção: para executar os passos abaixo você precisa já ter configurado sua conexão   SSH conforme explicado [aqui](../ssh/README.md)

### Pasta dos cenários de simulação

Crie as pastas para conter os cenários de simulação do FDS na `$HOME` e `$SCRATCH` do SDumont, bem como na sua máquina local:
```
$ ssh sdumont 'mkdir -p $HOME/fds/cases'
$ ssh sdumont 'mkdir -p $SCRATCH/fds/cases'
$ mkdir -p $HOME/research/fds/cases
```

### Script em SDumont

Edite o arquivo `.fdsrc_sdumont`, definindo a variável `$SDUMONT_USERNAME` com seu usuário no SDumont (fornecido pelo Help Desk).

Copie esse arquivo para sua `$HOME` do SDumont e configure seu `.bashrc` para executá-lo ao iniciar uma nova sessão:
```
$ scp .fdsrc_sdumont sdumont:
$ ssh sdumont "echo 'source ~/.fdsrc_sdumont' >> ~/.bashrc"
```

### Script local

Edite o arquivo `.fdsrc_localhost`, definindo a variável `SDUMONT_USERNAME` com seu usuário no SDumont (fornecido pelo Help Desk). Defina também a pasta onde você guarda os cenários de simulação na sua máquina, através da variável `FDS_LOCALHOST_CASES`.

Copie esse arquivo para a `$HOME` da sua **máquina local** e configure seu `.bashrc` ou análogo (depende do shell que você usa) para executá-lo ao iniciar uma nova sessão:
```
$ cp .fdsrc_localhost $HOME
$ echo 'source ~/.fdsrc_sdumont' >> ~/.bashrc
```

## Utilização

Após executar os passos acima, inicie uma nova sessão ou shell na sua **máquina local**. Você terá à sua disposição os comandos `fds-sync` e `fds-sbatch`.

### `fds-sync`

O comando `fds-sync` é executado sem qualquer argumento. Ele sincroniza sua pasta de cenários de simulação na sua máquina local com sua `HOME` e `$SCRATCH` no Sdumont (essas variáveis de ambiente são automaticamente definidas pelo SDumont ao conectar nele).

### `fds-sbatch`

Este comando submete um job FDS ao Slurm do SDumont. Para fazer isso, basta passar o **nome do caso** como argumento. Por exemplo, se você tem um cenário de simulação chamado `meu_cenario`, basta executar:
```
$ fds-sbatch meu_cenario
```
