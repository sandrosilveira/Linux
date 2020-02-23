# Script para criar diretório
mkdir $1
if [ -d "$1" ] ; then
   chmod 775 $1;
fi
