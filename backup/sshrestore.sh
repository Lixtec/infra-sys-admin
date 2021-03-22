#!/bin/bash
#
# Synchronise d'un ensemble de répertoires en utilisant FTP

if [ -z "$BASH_VERSION" ]
then
    exec bash "$0" "$@"
fi

BACKUP_SSH_HOST="inconnu.ssh"
BACKUP_SSH_PATH="/backup"
BACKUP_SSH_LOGIN="userFtp"
BACKUP_SSH_PWD="userPwd"
APP_SRC_PATH="/var/data"
APP_VOLUMES=('vol1' 'vol2')
BACKUP_SSH_PORT="22"
BACKUP_TYPE='Other'

echo "Init param started"
if [ $# -gt 0 ]
then
   if [ ! -z $1 ]
   then
      BACKUP_SSH_HOST=$1
   fi
   if [ ! -z $2 ]
   then
      BACKUP_SSH_LOGIN=$2
   fi   
   if [ ! -z $3 ]
   then
      BACKUP_SSH_PWD=$3
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
      BACKUP_SSH_PATH=$6
   fi 
   if [ ! -z $7 ]
   then
      BACKUP_SSH_PORT=$7
   fi
   if [ ! -z $8 ]
   then
      BACKUP_TYPE=$8
   fi

fi
echo BACKUP_SSH_HOST=$BACKUP_SSH_HOST
echo BACKUP_SSH_PATH=$BACKUP_SSH_PATH
echo BACKUP_SSH_LOGIN=$BACKUP_SSH_LOGIN
echo APP_SRC_PATH=$APP_SRC_PATH
echo APP_VOLUMES=${APP_VOLUMES[*]}
echo BACKUP_TYPE=$BACKUP_TYPE
echo BACKUP_SSH_PORT=$BACKUP_SSH_PORT
echo -e "Init param finished\n"


for volume in ${APP_VOLUMES[@]}
do 
  echo "restore $BACKUP_SSH_LOGIN@$BACKUP_SSH_HOST:$BACKUP_SSH_PATH/$BACKUP_TYPE/$volume sur $APP_SRC_PATH/$volume"
  sshpass -p$BACKUP_SSH_PWD rsync -auv --delete -e="ssh -p$BACKUP_SSH_PORT" $BACKUP_SSH_LOGIN@$BACKUP_SSH_HOST:$BACKUP_SSH_PATH/$BACKUP_TYPE/$volume $APP_SRC_PATH/$volume
done
