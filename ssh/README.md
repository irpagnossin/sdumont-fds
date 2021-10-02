# Configuração da conexão SSH

Se a VPN estiver ativa (veja [aqui](../vpn/README.md)), o cluster Santos Dumont (SDumont) pode ser acessado via SSH. Digite o seguinte na linha de comando e forneça sua senha quando solicitado (substitua SEU_USUÁRIO pelo seu usuário no SDumont, fornecido pelo Help Desk):
```
$ ssh SEU_USUÁRIO@login.sdumont.lncc.br
```

Porém, é possível simplificar esse processo. Para isso, primeiramente crie um par de chaves RSA na sua máquina local (apenas digite enter quando lhe for solicitada uma senha):
```
$ ssh-keygen -f ~/.ssh/sdumont
```

🤔 Esse comando cria dois arquivos na sua máquina: `~/.ssh/sdumont` (chave-privada) e `~/.ssh/sdumont.pub` (chave-pública).

Envie a chave para o host de entrada do SDumont (a VPN precisa estar ativa para executar esse passo):
```
$ ssh-copy-id -i sdumont.pub login.sdumont.lncc.br:
```
🤔 Esse comando adiciona sua chave-pública, conteúdo do recém-criado arquivo `~/.ssh/sdumont.pub`, ao final do arquivo `~/.ssh/known_hosts` existente na máquina remota (SDumont).

Crie o arquivo `~/.ssh/config` com o seguinte conteúdo:
```
Host sdumont
  Hostname login.sdumont.lncc.br
  User SEU_USUÁRIO
  IdentityFile ~/.ssh/sdumont
```

Pronto. A partir de agora, para conectar no SDumont basta digitar `ssh sdumont`. Nenhuma senha será requisitada.