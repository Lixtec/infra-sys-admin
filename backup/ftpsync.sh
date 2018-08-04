#!/bin/bash
#
# Synchronise deux répertoires en utilisant FTP

if [ -z "$BASH_VERSION" ]
then
    exec bash "$0" "$@"
fi

HOST="$1"
LOGIN="$2"
PASSWORD="$3"
LOCALDIR="$4"
REMOTEDIR="$5"
EXCLUDED="*.*~"

function Usage()
{
  echo -e "\n  Synchronise un répertoire local avec un répertoire distant en utilisant FTP";  
  echo -e "\n  USAGE: ftpsync.sh host login password localdir remotedir";
  echo;
}

if [ "$LOCALDIR" = "" ]
then
  echo -e "  ERREUR: Veuillez spécifier un répertoire local";
  Usage;
  exit 1;
fi

echo "backup $LOCALDIR on $LOGIN@$HOST:$REMOTEDIR"
  echo -e "Sauvegarde en cours"
  lftp -c "set ftp:ssl-allow no;
  open ftp://$LOGIN:$PASSWORD@$HOST; 
  lcd $LOCALDIR;
  cd $REMOTEDIR;
  mirror --reverse \
         --delete \
         --verbose \
         --exclude-glob $EXCLUDED";
