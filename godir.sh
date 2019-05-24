function listaConfiguracao(){
   if [ ! -f $ARQPRE ]; then
      echo "*** N�o existe nenhum diret�rio preferido para o usu�rio!"
      return
   fi
   echo "Diret�rios preferidos:"
   sort $ARQPRE
   echo " "
   #echo "Diret�rios do perfil do usu�rio ($HOME)"
   #find $HOME -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | grep -i -v "^\."
}

function deletaConfiguracao(){
   if [ ! -f $ARQPRE ]; then
      return
   fi
   if [ -z "$ALIAS" ]; then
      if [ ! -z "$DIRETORIO" ]; then
         ALIAS=!DIRETORIO!
         DIRETORIO=
      else 
         echo "Informe um Alias para excluir!"
         return
      fi
   fi
   LINHA=`grep -i "^$ALIAS\=" $ARQPRE`
   if [ -z "$LINHA" ]; then
      echo "Alias '$ALIAS' n�o encontrado na lista de preferidos do usu�rio!"
      return
   fi
   sed -i /"$ALIAS="/Id $ARQPRE
}

function adicionaConfiguracao(){
   if [ -z "$DIRETORIO" ]; then
      echo "setando diret�rio n�o informado"
      DIRETORIO=`pwd`
   fi
   if [ -z "$ALIAS" ]; then
      echo "saindo com alias n�o informado"
      return
   fi
   if [ -f $ARQPRE ]; then
      LINHA=`grep -i "^$ALIAS\=" $ARQPRE`
      if [ ! -z "$LINHA" ]; then
         DIRETORIO=`echo $LINHA | cut -d "=" -f 2`
         RESPOSTA=N
         read -p "Alias '$ALIAS' j� existe para diret�rio $DIRETORIO, gostaria de substitu�-lo (S/N)?" RESPOSTA
         declare -u RESPOSTA=$RESPOSTA
         if [ "$RESPOSTA" == "S" ]; then
            deletaConfiguracao
         else 
            return
         fi
      fi
   fi
   echo "$ALIAS=$DIRETORIO" >> $ARQPRE
}

function mudaDiretorio(){
   if [ -f $ARQPRE ]; then
      LINHA=`grep -i "^$ALIAS\=" $ARQPRE`
      if [ ! -z "$LINHA" ]; then
         DIRETORIO=`echo $LINHA | cut -d "=" -f 2`
         change_dir $DIRETORIO
      fi
   fi
}

COMANDO=
ALIAS=
DIRETORIO=
CD_DIR=
ARQPRE=$HOME/go.properties

for ARG in "$@" ; do
    declare -l PRM=$ARG
    case "$PRM" in
    add|a|adiciona) 
        COMANDO=add
        ;;
    del|d|deleta)    
        COMANDO=del
        ;;
    lst|l|list|lista)    
        COMANDO=lst
        ;;
    *)
        if [ -d "$ARG" ]; then
            DIRETORIO=$ARG
        else
            ALIAS=$PRM
        fi
        ;;
    esac
done

if [ -z "$COMANDO" ]; then
   mudaDiretorio
else
    case "$COMANDO" in
    add) 
        adicionaConfiguracao
        ;;
    del)    
        deletaConfiguracao
        ;;
    lst)    
        listaConfiguracao
        ;;
    esac
fi
