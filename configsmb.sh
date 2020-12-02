#!/bin/bash
# Script de configuração do Samba para vms de teste do SIGER

# Verifica se está rodando como root (ou com sudo)
if [ "$EUID" -ne 0 ]; then
  echo "Rodar como root ou com sudo..."
  exit
fi

# Se não existe o arquivo de configuração do samba
if ! [ -f /etc/samba/smb.conf ]; then
   echo "Instalando samba..."
   if [ -f /etc/debian_version ]; then
      apt install -y samba
   else
      dnf install -y samba
   fi
fi

# Se não existe o diretório do SIGER
if ! [ -d "/usr/local/SIGER" ]; then
   echo "Criando diretório padrão do SIGER..."
   mkdir /usr/local/SIGER
   chmod 777 /usr/local/SIGER
   mkdir /usr/local/SIGER/RECH
   chmod 777 /usr/local/SIGER/RECH
   ln -s /usr/local/SIGER/RECH /RECH
fi

# Configurações globais sugeridas pela Rech
if [ -f /etc/debian_version ]; then
#   if [ -z "$(grep -i "follow symlinks" /etc/samba/smb.conf)" ]; then
#      sed -i '/\[global\]/a         follow symlinks = yes' /etc/samba/smb.conf
#   fi
   if ! [ -z "$(grep -i "wide symlinks" /etc/samba/smb.conf)" ]; then
      sed -i '/\[global\]/a         wide symlinks = yes' /etc/samba/smb.conf
   fi
   if [ -z "$(grep -i "unix extensions" /etc/samba/smb.conf)" ]; then
      sed -i '/\[global\]/a         unix extensions = no' /etc/samba/smb.conf
   fi
fi
if [ -z "$(grep -i "map to guest" /etc/samba/smb.conf)" ]; then
   sed -i '/\[global\]/a         map to guest = bad user' /etc/samba/smb.conf
fi
if [ -z "$(grep -i "usershare allow" /etc/samba/smb.conf)" ]; then
   sed -i '/\[global\]/a         usershare allow guests = yes' /etc/samba/smb.conf
fi
if [ -z "$(grep -i "locking = yes" /etc/samba/smb.conf)" ]; then
   sed -i '/\[global\]/a         locking = yes' /etc/samba/smb.conf
fi
if [ -z "$(grep -i "kernel oplocks" /etc/samba/smb.conf)" ]; then
   sed -i '/\[global\]/a         kernel oplocks = yes' /etc/samba/smb.conf
fi
if [ -z "$(grep -i "security = user" /etc/samba/smb.conf)" ]; then
   sed -i '/\[global\]/a         security = user' /etc/samba/smb.conf
fi
if [ -z "$(grep -i "min protocol = SMB2" /etc/samba/smb.conf)" ]; then
   sed -i '/\[global\]/a         min protocol = SMB2' /etc/samba/smb.conf
fi
#if [ -z "$(grep -i "socket options" /etc/samba/smb.conf)" ]; then
#   sed -i '/\[global\]/a         socket options = TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192' /etc/samba/smb.conf
#fi

# Se ainda não tem o compartilhamento do SIGER configurado
if [ -z "$(grep -i "\[SIGER\]" /etc/samba/smb.conf)" ]; then
   echo "Configurando compartilhamento do SIGER..."
   echo "[SIGER]" >> /etc/samba/smb.conf
   echo "        path = /usr/local/SIGER" >> /etc/samba/smb.conf
   echo "        read only = No" >> /etc/samba/smb.conf
   echo "        browseable = yes" >> /etc/samba/smb.conf
   echo "        create mask = 0777" >> /etc/samba/smb.conf
   echo "        directory mask = 0777" >> /etc/samba/smb.conf
   echo "        guest ok = yes" >> /etc/samba/smb.conf
   echo "        writable = yes" >> /etc/samba/smb.conf
   echo "        force create mode = 0777" >> /etc/samba/smb.conf
   echo "        force directory mode = 0777" >> /etc/samba/smb.conf
   echo "        force user = root" >> /etc/samba/smb.conf
fi

# Testa os parâmetros
echo "Testando os parâmetros..."
testparm

# Reinicia o serviço
echo "Reiniciando o serviço..."
systemctl restart smbd
