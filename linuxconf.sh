#!/bin/bash
# Script de configura��o autom�tica do ambiente linux

# Adiciona usu�rio ao grupo de compartilhamento de pastas do virtualbox
echo "Configurando grupo do vboxsf..."
sudo usermod -a -G vboxsf $USERNAME
# Coloca permiss�o nas pastas compartilhadas
echo "Atribuindo permiss�o nas pastas compartilhadas..."
sudo chmod 777 /media
# Se ainda n�o tem o alias do cls configurado
if [ -z "$(grep "alias cls" /etc/bash.bashrc)" ]; then
   echo "Configurando aliases no bashrc ..."
   sudo echo "alias cls='tput reset'" >> /etc/bash.bashrc
   sudo echo "alias lf='ls -F'" >> /etc/bash.bashrc
   sudo echo "alias lt='ls -lrt'" >> /etc/bash.bashrc
   sudo echo "alias ltr='ls -lt'" >> /etc/bash.bashrc
   sudo echo "alias grep='grep --directories=skip --color=auto'" >> /etc/bash.bashrc
   sudo echo "alias is='cd \$ISCOBOL'" >> /etc/bash.bashrc
   sudo echo "alias iscs='cd \$ISCOBOL/sample;sh isControlset.sh &'" >> /etc/bash.bashrc
   sudo echo "alias sb='cd /usr/local/bin'" >> /etc/bash.bashrc
   sudo echo "alias s='cd /RECH/USR'" >> /etc/bash.bashrc
   sudo echo "alias ctree='cd /usr/local/CtreeSQLServer/BASES/00571S004'" >> /etc/bash.bashrc
   sudo echo "alias go='. godir'" >> /etc/bash.bashrc
   sudo echo "alias ccat='pygmentize -g'" >> /etc/bash.bashrc
fi
# Se ainda n�o tem a fun��o do change_dir configurada
if [ -z "$(grep "change_dir" /etc/bash.bashrc)" ]; then
   echo "Configurando change_dir ..."
   sudo echo "function change_dir() {" >> /etc/bash.bashrc
   sudo echo "    cd \$1" >> /etc/bash.bashrc
   sudo echo "}" >> /etc/bash.bashrc
   sudo echo "export -f change_dir" >> /etc/bash.bashrc
fi
# Se ainda n�o tem a configura��o de completamento do bash
if [ -z "$(grep "completion-ignore-case" /etc/inputrc)" ]; then
   echo "Configurando tab completion..."
   sudo echo "TAB: menu-complete" >> /etc/inputrc
   sudo echo "set completion-ignore-case on" >> /etc/inputrc
   sudo echo "\"\e[Z\": \"\e-1\C-i\"" >> /etc/inputrc
fi
