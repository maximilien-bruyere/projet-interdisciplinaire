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
    echo -e "\n${BLUE}------------${ENDCOLOR}"
    echo -e "${BLUE}   Update   ${ENDCOLOR}"
    echo -e "${BLUE}------------${ENDCOLOR}\n"
    dnf update -y 
    dnf upgrade -y 
}

delete_users() {
    echo -e "\n${BLUE}----------------${ENDCOLOR}"
    echo -e "${BLUE}   Delete User  ${ENDCOLOR}"
    echo -e "${BLUE}----------------${ENDCOLOR}\n"

    read -p "Enter the UID of the user to delete : " UID
    find / -uid $UID -exec rm -rf {} \;
    userdel -r $UID
}

global_configuration() {
    echo -e "\n${BLUE}--------------------------${ENDCOLOR}"
    echo -e "${BLUE}   Global Configurations  ${ENDCOLOR}"
    echo -e "${BLUE}--------------------------${ENDCOLOR}\n"

    read -p "Enter the hostname : " HOSTNAME
    read -p "Enter the domain (ex : .[com, be, lan]) : " DOMAIN
    read -p "Enter the server name (ex : [WindowsServer2019].lan) : " SERVERNAME

    echo "HOSTNAME=$HOSTNAME" >> ./config.conf
    echo "DOMAIN=$DOMAIN" >> ./config.conf
    echo "SERVERNAME=$SERVERNAME" >> ./config.conf

    hostnamectl set-hostname $HOSTNAME
    rm -rf /etc/resolv.conf

    read -p "How many people need access to the server ? : [number] " NUMBERPEOPLE
    for (( user=1; user<=$NUMBERPEOPLE; user++))
    do 
        echo -e "\nUser number : $user"
        echo -e " ----------------\n"
        read -p "What's the username number ? : [string] " USERNAME

        if [ $(id -u $USERNAME) ]
        then
            echo -e "${RED}This username already exists.${ENDCOLOR}"
            sudo -u $USERNAME ssh-keygen -t rsa -b 4096 -C "$USERNAME@$HOSTNAME.$SERVERNAME.$DOMAIN"
            mv /home/$USERNAME/.ssh/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys

            continue
        fi

        read -p "Does this person need to have full access to the server? : [no/yes] " ACCESSCHOICE

        if [[ $ACCESSCHOICE == "yes" ]]
        then 
            useradd -m $USERNAME
            passwd $USERNAME
            usermod -aG wheel $USERNAME

            sudo -u $USERNAME ssh-keygen -t rsa -b 4096 -C "$USERNAME@$HOSTNAME.$SERVERNAME.$DOMAIN"
            mv /home/$USERNAME/.ssh/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys

        else 
            useradd -m $USERNAME
            passwd $USERNAME

            sudo -u $USERNAME ssh-keygen -t rsa -b 4096 -C "$USERNAME@$HOSTNAME.$SERVERNAME.$DOMAIN"
            mv /home/$USERNAME/.ssh/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys
        fi 
    done

    # scp avec port 


    # After the loop, please transfer the private keys generated
    # to the users who need them. 
    # To transfer them, use the scp command : 
    # scp -P [port] [user]@[server-ip]:/home/[user]/.ssh/id_rsa C:/users/[windows-user]/.ssh/
    # 
    # In this project, I advise you to use Termius / Putty to connect yourself to the server.
    # To have access to the server, you MUST use PuttyGen (load the private key) and
    # save the private key in the .ppk format.

    echo -e "\n${RED}Please, transfer the private keys to the users who need them.${ENDCOLOR}"
    echo -e "${RED}To transfer them, use the scp command :${ENDCOLOR}"
    echo -e "${RED}scp [user]@[server-ip]:/home/[user]/.ssh/id_rsa C:/users/[windows-user]/.ssh/${ENDCOLOR}\n"

    # -n1 : one character
    # -s : silent
    read -p "Press any key to continue..." -n1 -s 
    systemctl restart NetworkManager
    clear
}

ssh_configuration() {
    echo -e "\n${BLUE}---------------------${ENDCOLOR}"
    echo -e "${BLUE}  SSH Configuration  ${ENDCOLOR}"
    echo -e "${BLUE}---------------------${ENDCOLOR}\n"

    read -p "Choose port for ssh : [number]" PORT
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