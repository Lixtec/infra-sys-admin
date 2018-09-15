#!/bin/bash
#
# Ce script update un système linux de type Ubuntu

if [ -z "$BASH_VERSION" ]
then
    exec bash "$0" "$@"
fi

HOST="$1"
SSH_LOGIN="$2"
SSH_PWD="$3"

function Usage()
{
  echo -e "\n  Ce script update un système linux de type Ubuntu";  
  echo -e "\n  USAGE: updateUbuntu.sh host login password";
  echo;
}

if [ "$SSH_PWD" = "" ]
then
  echo -e "  ERREUR: Veuillez spécifier un répertoire local";
  Usage;
  exit 1;
fi

echo "Update $HOST"
sshpass -p "$SSH_PWD" ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $SSH_LOGIN@$HOST "echo "$SSH_PWD" | sudo -S -i apt-get update"
sshpass -p "$SSH_PWD" ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $SSH_LOGIN@$HOST "echo "$SSH_PWD" | sudo -S -i apt-get upgrade -y"
sshpass -p "$SSH_PWD" ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $SSH_LOGIN@$HOST "echo "$SSH_PWD" | sudo -S -i apt-get autoremove -y"
