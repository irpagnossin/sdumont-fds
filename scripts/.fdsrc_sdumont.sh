#!/bin/bash
#
# Copie este arquivo para sua $HOME no SDumont e adicione a seguinte linha no
# seu .bashrc:
#
# source ~/.fdsrc_sdumont

# Usuário no SDumont
SDUMONT_USERNAME=

FDS_CASES_HOME=$HOME/fds/cases
FDS_CASES_SCRATCH=/scratch/motoretanol2/$SDUMONT_USERNAME/fds/cases

fds-sync() {
     echo "Sincronizando arquivos entre $FDS_CASES_HOME e $FDS_CASES_SCRATCH"
     # Sincroniza arquivos de entrada do FDS em $SCRATCH
     rsync --recursive --include='*/' --include='*.srm' --include='*.fds' --exclude='*' --exclude='.git' $FDS_CASES_HOME/ $FDS_CASES_SCRATCH/

     # Sincroniza arquivos de saída do FDS na $HOME
     rsync --recursive --exclude='*.srm' --exclude='*.fds' $FDS_CASES_SCRATCH/ $FDS_CASES_HOME/
     echo "Sincronizado."
}

file-exists() {
     if [[ ! -f $1 ]]; then
          echo "ERRO: $1 não existe."
          return 1
     fi
}

srm-file() {
     echo $FDS_CASES_SCRATCH/$1/$1.srm
}

srm-ok() {
     case_name=$1
     srm_file=$(srm-file $case_name)
     fds_file=$(echo $srm_file | sed 's/srm/fds/')

     if ! grep -q $case_name/$case_name.fds $srm_file ; then 
          echo "ERRO: o arquivo FDS não foi mencionado no arquivo SRM."
          return 1
     fi

     # Checa se a quantidade de &MESH no FDS coincide com ntasks em SRM
     n_tasks=$(grep -oP "ntasks=\d{1,3}" $srm_file | cut -d= -f2)
     n_meshes=$(grep -o "&MESH" $fds_file | wc -l)
     if [[ "$n_meshes" != "$n_tasks" ]]; then
          echo "ERRO: ntasks=$n_tasks (SRM), mas #meshes=$n_meshes (FDS)."
          return 1
     fi
}

fds-sbatch() {
     case_name=$1
     if [ -z $case_name ]; then
          echo "ERRO: faltou o nome do caso. Por exemplo: $ fds-sbatch hello-world"
     else
          srm_file=$(srm-file $case_name)
          fds_file=$FDS_CASES_SCRATCH/$case_name/$case_name.fds
          file-exists $fds_file && file-exists $srm_file && srm-ok $case_name &&  sbatch $srm_file
     fi
}

export -f fds-sync
export -f fds-sbatch