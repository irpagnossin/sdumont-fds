# FDS no Docker

Esta pasta contém os arquivos e instruções necessárias para criar uma imagem e container Docker com o código-fonte do FDS e as dependências necessárias para compilá-lo.

Desse modo, você pode editar o código-fonte do FDS e compilá-lo no próprio container, sem a necessidade de instalá-lo na sua máquina local (o que pode ser trabalhoso).

## Imagem

Para construir a imagem, apenas execute:
```
$ ./build.sh
```

## Container

Após a criação da imagem, crie um container seguindo a receita (arquivo `run.sh.sample`):
```
FDS_SRC=$HOME/Documents/research/fds/src

docker run -d \
    --name fds_sandbox \
    --mount "type=bind,source=$FDS_SRC,target=/root/fds/src" \
    fds_sandbox:0.4.0
```

Note que a variável `FDS_SRC` indica uma pasta na sua máquina local contendo o código-fonte. Desse modo, você pode editá-lo normalmente, com qualquer IDE ou editor, e ainda assim compilar o código através do container.

obs.: a última linha, `fds_sandbox:0.4.0`, deve bater com a tag da imagem criada. Confira no arquivo `build.sh`.