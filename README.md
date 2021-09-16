# Fire Dynamics Simulator (FDS) _sandbox_

Este projeto cria uma imagem Docker com o FDS instalado a partir do código-fonte. Os objetivos são:
- Prover um ambiente padronizado aos usuários do FDS.
- Detalhar as instruções de instalação do FDS via Dockerfile e o script `sdumont_install.sh`.
- Simplificar o acesso a novos membros do grupo de trabalho/pesquisa.

## Imagem e _container_

- Execute `./preinstall.sh` para baixar as dependências e o FDS.
- Execute `./build.sh` para construir a imagem Docker `fds_sandbox`.
- Execute algo como `run.sh.sample` para criar um container.

# FDS no SDumont

Para instalar o FDS via código-fonte no cluster Santos Dumont (SDumont), do Laboratório Nacional de Computação Científica (LNCC), execute o script `sdumont_install.sh` ou siga-o passo-a-passo. Você precisará já ter baixado na sua máquina alguns arquivos de instalação, conforme  `preinstall.sh`.