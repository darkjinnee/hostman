#!/bin/bash

USER_NAME=$USER;

function backup_create() {
    echo "Backup create...$(date +%H:%M:%S)";
    cp /etc/hosts ~/hostman/backups/$(date +%Y-%m-%d)'_'$(date +%H-%M-%S);
    echo "Done...$(date +%H:%M:%S)";

    read -p "Continue? (y/n) " choice
    case "$choice" in 
        y|Y ) /home/${1}/hostman/hostman.sh; break ;;
        n|N ) exit; break ;;
        * ) echo "invalid";;
    esac
}

function backupUse() {
    echo "Backup use...$(date +%H:%M:%S)";
    BACKUP_FILES=$(cd /home/${1}/hostman/backups && ls);
    PS3='Select: ';
    select FILE in ${BACKUP_FILES}
    do
      BACKUP_FILE_NAME=${FILE};
      break;
    done
    sudo cp /home/${1}/hostman/backups/${BACKUP_FILE_NAME} /etc/hosts
    echo "Done...$(date +%H:%M:%S)";

    read -p "Continue? (y/n) " choice
    case "$choice" in 
        y|Y ) /home/${1}/hostman/hostman.sh; break ;;
        n|N ) exit; break ;;
        * ) echo "invalid";;
    esac
}

function add() {
    echo "Add...$(date +%H:%M:%S)";
    echo "Enter domain";
    read PROJECT_DOMAIN

    project_host_conf="127.0.0.1 ${PROJECT_DOMAIN} www.${PROJECT_DOMAIN}"
    sudo echo "$project_host_conf" >> /etc/hosts
    echo "Done...$(date +%H:%M:%S)";

    read -p "Continue? (y/n) " choice
    case "$choice" in 
        y|Y ) /home/${1}/hostman/hostman.sh; break ;;
        n|N ) exit; break ;;
        * ) echo "invalid";;
    esac
}

function remove() {
    echo "Remove...$(date +%H:%M:%S)";
    echo "Enter domain";
    read PROJECT_DOMAIN

    sudo sed -i /${PROJECT_DOMAIN}/d /etc/hosts
    echo "Done...$(date +%H:%M:%S)";

    read -p "Continue? (y/n) " choice
    case "$choice" in 
        y|Y ) /home/${1}/hostman/hostman.sh; break ;;
        n|N ) exit; break ;;
        * ) echo "invalid";;
    esac
}

function edit() {
    echo "Edit...$(date +%H:%M:%S)";
    sudo nano /etc/hosts
    echo "Done...$(date +%H:%M:%S)";

    read -p "Continue? (y/n) " choice
    case "$choice" in 
        y|Y ) /home/${1}/hostman/hostman.sh; break ;;
        n|N ) exit; break ;;
        * ) echo "invalid";;
    esac
}

function ports() {
    echo "Ports...$(date +%H:%M:%S)";
    sudo lsof -nP -i | grep LISTEN;
    echo "Done...$(date +%H:%M:%S)";

    read -p "Continue? (y/n) " choice
    case "$choice" in 
        y|Y ) /home/${1}/hostman/hostman.sh; break ;;
        n|N ) exit; break ;;
        * ) echo "invalid";;
    esac
}

# Изменение строки приветствия
sudo echo "---=== hostman ===---"
PS3='Выберите нужное действие: '
MENU=(
    "Add (domain)"
    "Remove (domain)"
    "Edit (hosts file)"
    "Backup (use)"
    "Backup (make)"
    "Ports (local)"
);
select menu in "${MENU[@]}" ;do
    case $REPLY in
        1) sudo bash -c "$(declare -f add); add "${USER_NAME}""; break ;;
        2) sudo bash -c "$(declare -f remove); remove "${USER_NAME}""; break ;;
        3) sudo bash -c "$(declare -f edit); edit "${USER_NAME}""; break ;;
        4) sudo bash -c "$(declare -f backupUse); backupUse "${USER_NAME}""; break ;;
        5) backup_create "${USER_NAME}"; break ;;
        6) sudo bash -c "$(declare -f ports); ports "${USER_NAME}""; break ;;
        0) break ;;
    esac
done
