#!/bin/bash 

# ID : 10092024
# Author : Maximilien Bruyère
# OS : Fedora 40 - Server Edition

###############
# DESCRIPTION #
###############
#
# This script is used to install a LAMP stack on a Fedora 40 Server Edition.
#
# LAMP : 
#   L : Linux
#   A : Apache
#   M : MariaDB
#   P : PHP
#
# It will work with an AD and DNS server (Windows Server 2019) and 
# a client (Windows 10).
#
###############

############
# WARNINGS #
############
#
# Must be run after dos2unix command.
# Must be run as root.
# Must be run on a Fedora 40 Server Edition.
# Must be run after the installation of the AD and DNS server (Windows Server 2019).
#
############

####################
# GLOBAL FUNCTIONS #
####################

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run as root.${ENDCOLOR}"
        exit
    fi
}

update_system() {
    clear
    echo -e "\n${BLUE}------------${ENDCOLOR}"
    echo -e "${BLUE}   Update   ${ENDCOLOR}"
    echo -e "${BLUE}------------${ENDCOLOR}\n"

    dnf update -y 
    dnf upgrade -y 

    echo -e "\n${GREEN}Update done.${ENDCOLOR}\n"
}

delete_users() {
    clear
    echo -e "\n${BLUE}----------------${ENDCOLOR}"
    echo -e "${BLUE}   Delete User  ${ENDCOLOR}"
    echo -e "${BLUE}----------------${ENDCOLOR}\n"

    read -p "Enter the UID of the user to delete : " UID
    find / -uid $UID -exec rm -rf {} \;
    userdel -r $UID

    echo -e "\n${GREEN}User deleted.${ENDCOLOR}\n"
    clear
}

global_configuration() {
    clear
    echo -e "\n${BLUE}--------------------------${ENDCOLOR}"
    echo -e "${BLUE}   Global Configurations  ${ENDCOLOR}"
    echo -e "${BLUE}--------------------------${ENDCOLOR}\n"

    read -p "Enter the hostname (ex : [fedora].WindowsServer2019.lan) : " HOSTNAME
    read -p "Enter the server name (ex : [WindowsServer2019].lan) : " SERVERNAME
    read -p "Enter the domain (ex : .[lan]) : " DOMAIN
    echo "HOSTNAME=$HOSTNAME" >> ./config.conf
    echo "DOMAIN=$DOMAIN" >> ./config.conf
    echo "SERVERNAME=$SERVERNAME" >> ./config.conf
    hostnamectl set-hostname $HOSTNAME
    rm -rf /etc/resolv.conf
    systemctl restart NetworkManager

    echo -e "\n${GREEN}Hostname changed.${ENDCOLOR}\n"

    # All users will got as name : [familyname].[firstname]
    users_list=()
    read -p "How many people need access to the server ? : [number] " NUMBERPEOPLE
    for (( user=1; user<=$NUMBERPEOPLE; user++)); do 
        echo -e "\nUser number : $user"
        echo -e "----------------\n"
        read -p "What's the username number ? : [string] " USERNAME

        if [ $(id -u $USERNAME) ]
        then
            echo -e "${RED}This username already exists.${ENDCOLOR}"
            sudo -u $USERNAME ssh-keygen -t rsa -b 4096 -C "$USERNAME@$HOSTNAME.$SERVERNAME.$DOMAIN"
            mv /home/$USERNAME/.ssh/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys

            users_list+=($USERNAME)

            continue
        fi

        read -p "Does this person need to have full access to the server? : [no/yes] " ACCESSCHOICE

        if [[ $ACCESSCHOICE == "yes" ]]
        then 
            useradd -m $USERNAME
            passwd $USERNAME
            usermod -aG wheel $USERNAME

            users_list+=($USERNAME)

            sudo -u $USERNAME ssh-keygen -t rsa -b 4096 -C "$USERNAME@$HOSTNAME.$SERVERNAME.$DOMAIN"
            mv /home/$USERNAME/.ssh/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys

        else 
            useradd -m $USERNAME
            passwd $USERNAME

            users_list+=($USERNAME)

            sudo -u $USERNAME ssh-keygen -t rsa -b 4096 -C "$USERNAME@$HOSTNAME.$SERVERNAME.$DOMAIN"
            mv /home/$USERNAME/.ssh/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys
        fi 
    done

    echo -e "\n${GREEN}Users and ssh key created.${ENDCOLOR}\n"
    
    echo -e "-----------------------------------"
    echo -e "${RED}scp [user]@[server-ip]:/home/[user]/.ssh/id_rsa C:/users/[windows-user]/.ssh/${ENDCOLOR}"
    echo -e "${RED}Please, transfer the private keys to : ${ENDCOLOR}\n" 

    # After the loop, please transfer the private keys generated
    # to the users who need them. 
    # To transfer them, use the scp command : 
    # scp -P [port] [user]@[server-ip]:/home/[user]/.ssh/id_rsa C:/users/[windows-user]/.ssh/
    # 
    # In this project, I advise you to use Termius / Putty to connect yourself to the server.
    # To have access to the server, you MUST use PuttyGen (load the private key) and
    # save the private key in the .ppk format.
    # -n1 : one character
    # -s : silent

    for user in ${users_list[@]}; do
        echo -e "- $user" 
    done 

    echo -e ""
    read -p "Press any key to continue... " -n1 -s 
    echo -e "\n-----------------------------------"

    echo -e "\n${GREEN}Configuration done.${ENDCOLOR}\n"
}

ssh_configuration() {
    echo -e "\n${BLUE}---------------------${ENDCOLOR}"
    echo -e "${BLUE}  SSH Configuration  ${ENDCOLOR}"
    echo -e "${BLUE}---------------------${ENDCOLOR}\n"

    read -p "Choose port for ssh : " PORT
    sed -i "21s/#//; 21s/22/$PORT/" /etc/ssh/sshd_config
    sed -i "40s/#//; 40s/prohibit-password/no/" /etc/ssh/sshd_config
    sed -i "65s/#//; 65s/yes/no/" /etc/ssh/sshd_config
    sed -i "66s/#//" /etc/ssh/sshd_config
    sed -i "69s/#//; 65s/yes/no/" /etc/ssh/sshd_config
    sed -i "96s/#//; 96s/no/yes/" /etc/ssh/sshd_config

    semanage port -a -t ssh_port_t -p tcp $PORT 

    firewall-cmd --add-port=$PORT/tcp --permanent
    firewall-cmd --remove-service=ssh --permanent

    systemctl restart firewalld
    systemctl restart sshd

    echo -e "\n${GREEN}SSH and firewalld configurations done.${ENDCOLOR}\n"
    clear
}

add_services() {
    echo -e "${BLUE}---------------${ENDCOLOR}"
    echo -e "${BLUE}   Services    ${ENDCOLOR}"
    echo -e "${BLUE} configuration ${ENDCOLOR}"
    echo -e "${BLUE}---------------${ENDCOLOR}\n"

    apache_configuration
    database_configuration
    php_configuration

    echo -e "\n${GREEN}Services configurations done.${ENDCOLOR}\n"
}

backup_configuration() {
}

antimalware_configuration() {
}

exit_configuration() {
}

######################
# SERVICES FUNCTIONS #
######################

apache_configuration() {
}

database_configuration() {
}

php_configuration() {
}

#################
# MAIN FUNCTION #
#################

main() {
}

check_root
main