#!/bin/bash
# Script para criar diretório e atribuir permissão completa ao diretório criado
mkdir $1
if [ -d "$1" ] ; then
   chmod 775 $1;
fi
