#!/bin/bash
#
# Synchronise d'un ensemble de répertoires en utilisant FTP

if [ -z "$BASH_VERSION" ]
then
    exec bash "$0" "$@"
fi

BACKUP_FTP_HOST="inconnu.ftp"
BACKUP_FTP_PATH="/backup"
BACKUP_FTP_LOGIN="userFtp"
BACKUP_FTP_PASSWORD="userPwd"
APP_SRC_PATH="/var/data"
APP_VOLUMES=('vol1' 'vol2')
EXCLUDED="*.*~"
BACKUP_TYPE=''
if [ $(date +%A) == "Friday" -o $(date +%A) == "Wednesday" ]
then
  BACKUP_TYPE=$(date +%A);
else
  BACKUP_TYPE="Other";
fi

echo "Init param started"
if [ $# -gt 0 ]
then
   if [ ! -z $1 ]
   then
      BACKUP_FTP_HOST=$1
   fi
   if [ ! -z $2 ]
   then
      BACKUP_FTP_LOGIN=$2
   fi   
   if [ ! -z $3 ]
   then
      BACKUP_FTP_PASSWORD=$3
   fi
   if [ ! -z $4 ]
   then
   	  APP_SRC_PATH=$4
   fi   
   if [ ! -z $5 ]
   then
      IFS=';' APP_VOLUMES=( $5 )
   fi
   if [ ! -z $6 ]
   then
   	  APP_NFS_PATH=$5
   fi
   if [ ! -z $6 ]
   then
      BACKUP_FTP_PATH=$6
   fi   
fi
echo BACKUP_FTP_HOST=$BACKUP_FTP_HOST
echo BACKUP_FTP_PATH=$BACKUP_FTP_PATH
echo BACKUP_FTP_LOGIN=$BACKUP_FTP_LOGIN
echo APP_SRC_PATH=$APP_SRC_PATH
echo APP_VOLUMES=${APP_VOLUMES[*]}
echo BACKUP_TYPE=$BACKUP_TYPE
echo -e "Init param finished\n"

echo "backup $APP_SRC_PATH on $BACKUP_FTP_LOGIN@$BACKUP_FTP_HOST:$BACKUP_FTP_PATH"

for volume in ${APP_VOLUMES[@]}
do 
  lftp -c "set ftp:ssl-allow no;
  open ftp://$BACKUP_FTP_LOGIN:$BACKUP_FTP_PWD@$BACKUP_FTP_HOST; 
  lcd $APP_SRC_PATH/$volume;
  cd $BACKUP_FTP_PATH/$volume;
  mirror --reverse \
         --delete \
         --verbose \
         --exclude-glob $EXCLUDED";
done
