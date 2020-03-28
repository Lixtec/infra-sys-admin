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
BACKUP_FTP_PWD="userPwd"
APP_SRC_PATH="/var/data"
APP_VOLUMES=('vol1' 'vol2')
EXCLUDED="--exclude-glob *.*~"
BACKUP_TYPE=''
if [ $(date +%A) == "Sunday" ]
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
      BACKUP_FTP_PWD=$3
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
   if [ ! -z $7 ]
   then
      EXCLUDED=$7
   fi  
fi
echo BACKUP_FTP_HOST=$BACKUP_FTP_HOST
echo BACKUP_FTP_PATH=$BACKUP_FTP_PATH
echo BACKUP_FTP_LOGIN=$BACKUP_FTP_LOGIN
#echo BACKUP_FTP_PWD=$BACKUP_FTP_PWD
echo APP_SRC_PATH=$APP_SRC_PATH
echo APP_VOLUMES=${APP_VOLUMES[*]}
echo BACKUP_TYPE=$BACKUP_TYPE
echo EXCLUDED=$EXCLUDED
echo -e "Init param finished\n"


for volume in ${APP_VOLUMES[@]}
do 
  echo "backup $APP_SRC_PATH/$volume sur $BACKUP_FTP_LOGIN@$BACKUP_FTP_HOST/$BACKUP_FTP_PATH/$BACKUP_TYPE";
  export RCLONE_CONFIG_LIXTEC_HOME_TYPE=ftp
  export RCLONE_CONFIG_LIXTEC_HOME_USER=$BACKUP_FTP_LOGIN
  export RCLONE_CONFIG_LIXTEC_HOME_PASS=`rclone obscure $BACKUP_FTP_PWD`
  export RCLONE_CONFIG_LIXTEC_HOME_HOST=$BACKUP_FTP_HOST
  export RCLONE_CONFIG_LIXTEC_HOME_CONCURRENCY=4
  rclone sync -vv $APP_SRC_PATH/$volume lixtec_home:/$BACKUP_FTP_PATH/$BACKUP_TYPE
done
