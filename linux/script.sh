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
# clients (Windows 10 - Windows 11).
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

# Done
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}Please run as root.${ENDCOLOR}"
        exit
    fi
}

# Done
starting() {
    clear

    while true; do 
        clear
        echo -e "${BLUE}-----------------${ENDCOLOR}"
        echo -e "${BLUE}    Welcome    ${ENDCOLOR}"
        echo -e "${BLUE}-----------------${ENDCOLOR}\n"

        echo -e "To ensure that the configuration runs smoothly, we're going to ask you"
        echo -e "a few questions about the services we're going to set up.\n"

        # 6 variables : HOSTNAME, SERVERNAME, DOMAIN, IPADDRESS, NETWORKADDRESS, SUBNETMASK

        read -p "Enter the hostname (ex : [fedora].WindowsServer2019.lan) : " HOSTNAME; echo "HOSTNAME=$HOSTNAME" > ./config.conf
        read -p "Enter the server name (ex : [WindowsServer2019].lan) : " SERVERNAME;     echo "SERVERNAME=$SERVERNAME" >> ./config.conf
        read -p "Enter the domain (ex : .[lan]) : " DOMAIN; echo "DOMAIN=$DOMAIN" >> ./config.conf

        echo -e "\nHere is the informations about your Network."
        echo -e "Please, answer to the next questions\n"
        ip address
        echo -e "\n"

        read -p "Enter the IP Address (ex : [192.168.1.120]) : " IPADDRESS; echo "IPADDRESS=$IPADDRESS" >> ./config.conf
        read -p "Enter the Network Address (ex : [192.168.1.0]) : " NETWORKADDRESS; echo "NETWORKADDRESS=$NETWORKADDRESS" >> ./config.conf
        read -p "Enter the Subnet Mask (ex : 192.168.1.80/[24]) : " SUBNETMASK; echo "SUBNETMASK=$SUBNETMASK" >> ./config.conf

        echo -e "Config.conf file :\n"
        cat ./config.conf
        echo -e ""
        while true; do
            read -p "Is it good for you [yes/no] ?" YESORNO
            if [[ $YESORNO == "yes" || $YESORNO == "no" ]]
            then
                break
            else
                echo -e "${RED}Invalid value, please try again.${ENDCOLOR}"
            fi
        done

        if [[ $YESORNO == "yes" ]]
        then 
            echo -e "Good, go to the next step."
            break
        fi 
    done 
    echo -e "\n${GREEN}File {config.conf} created.${ENDCOLOR}\n"
}

# Done
update_system() {
    clear
    echo -e "${BLUE}------------${ENDCOLOR}"
    echo -e "${BLUE}   Update   ${ENDCOLOR}"
    echo -e "${BLUE}------------${ENDCOLOR}\n"

    dnf update -y 
    dnf upgrade -y 

    echo -e "\n${GREEN}Update done.${ENDCOLOR}\n"
}

# Done
delete_users() {
    clear
    echo -e "${BLUE}----------------${ENDCOLOR}"
    echo -e "${BLUE}   Delete User  ${ENDCOLOR}"
    echo -e "${BLUE}----------------${ENDCOLOR}\n"

    read -p "Enter the UID of the user to delete : " UID
    find / -uid $UID -exec rm -rf {} \;
    userdel -r $UID

    echo -e "\n${GREEN}User deleted.${ENDCOLOR}\n"
}

# Done
global_configuration() {
    clear
    echo -e "\n${BLUE}--------------------------${ENDCOLOR}"
    echo -e "${BLUE}   Global Configurations  ${ENDCOLOR}"
    echo -e "${BLUE}--------------------------${ENDCOLOR}\n"
    
    source ./config.conf
    
    updatedb
    dnf -y install git
    hostnamectl set-hostname $HOSTNAME
    rm -rf /etc/resolv.conf
    systemctl restart NetworkManager

    systemctl enable --now cockpit.socket

    echo -e "\n${GREEN}Hostname changed.${ENDCOLOR}\n"

    # All users will got as name : [familyname].[firstname]
    users_list=()

    while true; do
        read -p "How many people need access to the server ? : [number] " NUMBERPEOPLE
        if [[ $NUMBERPEOPLE -ge 1 ]]; then
            break
        else
            echo -e "${RED}Invalid value, please try again.${ENDCOLOR}"
        fi
    done
    
    for (( user=1; user<=$NUMBERPEOPLE; user++ )); do 
        echo -e "\nUser number : $user"
        echo -e "----------------\n"
        read -p "What's the username number ? : [string] " USERNAME

        if [ $(id -u $USERNAME) ]
        then
            echo -e "${RED}This username already exists.${ENDCOLOR}"
            sudo -u $USERNAME ssh-keygen -t rsa -b 4096 -C "$USERNAME@$IPADDRESS"
            mv /home/$USERNAME/.ssh/id_rsa.pub /home/$USERNAME/.ssh/authorized_keys

            users_list+=($USERNAME)

            continue
        fi 

        while true; do 
            read -p "Does this person need to have full access to the server? : [no/yes] " ACCESSCHOICE

            if [[ $ACCESSCHOICE == "yes" || $ACCESSCHOICE == "no" ]]
            then
                break
            else
                echo -e "${RED}Invalid value, please try again.${ENDCOLOR}"
            fi
        done 

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

# Done
ssh_configuration() {
    clear
    echo -e "\n${BLUE}---------------------${ENDCOLOR}"
    echo -e "${BLUE}  SSH Configuration  ${ENDCOLOR}"
    echo -e "${BLUE}---------------------${ENDCOLOR}\n"

    while true; do 
        read -p "Choose port for ssh : " PORT
        if [[ $PORT -ge 1024 && $PORT -le 65535 ]]; then
            echo "PORT=$PORT" >> ./config.conf
            break
        else
            echo -e "${RED}Invalid port, please try again.${ENDCOLOR}"
        fi
    done

    sed -i "21s/#//; 21s/22/$PORT/" /etc/ssh/sshd_config
    sed -i "40s/#//; 40s/prohibit-password/no/" /etc/ssh/sshd_config
    sed -i "65s/#//; 65s/yes/no/" /etc/ssh/sshd_config
    sed -i "66s/#//" /etc/ssh/sshd_config
    sed -i "69s/#//; 69s/yes/no/" /etc/ssh/sshd_config
    sed -i "96s/#//; 96s/no/yes/" /etc/ssh/sshd_config

    semanage port -a -t ssh_port_t -p tcp $PORT 

    firewall-cmd --add-port=$PORT/tcp --permanent
    firewall-cmd --remove-service=ssh --permanent
    firewall-cmd --reload

    systemctl restart sshd

    echo -e "\n${GREEN}SSH and firewalld configurations done.${ENDCOLOR}\n"
}

# Done
backup_configuration() {
    clear
    echo -e "\n${BLUE}---------------${ENDCOLOR}"
    echo -e "${BLUE}    Backup     ${ENDCOLOR}"
    echo -e "${BLUE} Configuration ${ENDCOLOR}"
    echo -e "${BLUE}---------------${ENDCOLOR}\n"

    touch /sbin/dailybackup
    chmod 755 /sbin/dailybackup

    cat <<EOF > /sbin/dailybackup
#!/bin/bash
clear
read -p "Enter the path where you want to save the backups : " BACKUPPATH

BACKUPPATH="\$BACKUPPATH"
TIMESTAMP=\$(date +%Y-%m-%d_%H-%M-%S)
mkdir /\$BACKUPPATH/\$TIMESTAMP

# Backup of the system
rsync -avz --delete /etc/ \$BACKUPPATH/\$TIMESTAMP/etc
rsync -avz --delete /web/ \$BACKUPPATH/\$TIMESTAMP/web
rsync -avz --delete /var/ \$BACKUPPATH/\$TIMESTAMP/var
rsync -avz --delete /home/ \$BACKUPPATH/\$TIMESTAMP/home
rsync -avz --delete /root/ \$BACKUPPATH/\$TIMESTAMP/root

# Compression of backups
tar -czf \$BACKUPPATH/\$TIMESTAMP/etc.tar.gz -C \$BACKUPPATH/\$TIMESTAMP etc
tar -czf \$BACKUPPATH/\$TIMESTAMP/web.tar.gz -C \$BACKUPPATH/\$TIMESTAMP web
tar -czf \$BACKUPPATH/\$TIMESTAMP/var.tar.gz -C \$BACKUPPATH/\$TIMESTAMP var
tar -czf \$BACKUPPATH/\$TIMESTAMP/home.tar.gz -C \$BACKUPPATH/\$TIMESTAMP home
tar -czf \$BACKUPPATH/\$TIMESTAMP/root.tar.gz -C \$BACKUPPATH/\$TIMESTAMP root

# Remove uncompressed backups
rm -rf \$BACKUPPATH/\$TIMESTAMP/etc
rm -rf \$BACKUPPATH/\$TIMESTAMP/web
rm -rf \$BACKUPPATH/\$TIMESTAMP/var
rm -rf \$BACKUPPATH/\$TIMESTAMP/home
rm -rf \$BACKUPPATH/\$TIMESTAMP/root

echo -e ""
EOF
    mkdir -p /root/.cache/crontab
    bash -c "(crontab -l 2>/dev/null; echo '0 12 * * * /sbin/dailybackup') | crontab -"

    echo -e "${GREEN}Backup configuration done.${ENDCOLOR}\n"
}

# Done
restore_backup() {
    clear
    echo -e "\n${BLUE}-----------------${ENDCOLOR}"
    echo -e "${BLUE}  Restore Backup ${ENDCOLOR}"
    echo -e "${BLUE}-----------------${ENDCOLOR}\n"

    touch /sbin/restorebackup
    chmod 755 /sbin/restorebackup

    cat <<EOF > /sbin/restorebackup
#!/bin/bash
read -p "Enter the path where the backups are stored : " BACKUPPATH
echo -e "\nAvailable backups :\n"
ls -1 \$BACKUPPATH
echo -e "-------------------\n"
read -p "Enter the date of the backup to restore (format: YYYY-MM-DD_H-m-s) : " BACKUPDATE

for dir in etc web var home root; do
    BACKUP_FILE="\$BACKUPPATH/\$BACKUPDATE/\${dir}.tar.gz"
    if [ ! -f "\$BACKUP_FILE" ]; then
        echo -e "Backup file \$BACKUP_FILE does not exist."
        return 1
    fi
done

for dir in etc web var home root; do
    BACKUP_FILE="\$BACKUPPATH/\$BACKUPDATE/\${dir}.tar.gz"
    echo -e "Restoring \$BACKUP_FILE to /\$dir"
    tar -xzf "\$BACKUP_FILE" -C "/"
done
EOF
    echo -e "${GREEN}Backup restoration configuration completed.\n${ENDCOLOR}"
}

######################
# SERVICES FUNCTIONS #
######################

# Done
add_services() {

    while true; do 
        clear
        echo -e "\n${BLUE}---------------${ENDCOLOR}"
        echo -e "${BLUE}   Services    ${ENDCOLOR}"
        echo -e "${BLUE} configuration ${ENDCOLOR}"
        echo -e "${BLUE}---------------${ENDCOLOR}\n"

        echo -e "1. ClamAV ${RED}[security]${ENDCOLOR}"
        echo -e "2. Fail2ban ${RED}[security]${ENDCOLOR}"
        echo -e "3. Grub ${RED}[security]${ENDCOLOR}"
        echo -e "4. Fstab ${RED}[security]${ENDCOLOR}"
        echo -e "5. Nmap ${RED}[security]${ENDCOLOR}"
        echo -e "6. Httpd ${BLUE}[web]${ENDCOLOR}"
        echo -e "7. MariaDB ${BLUE}[web]${ENDCOLOR}"
        echo -e "8. PhpMyAdmin ${BLUE}[web]${ENDCOLOR}"
        echo -e "9. Automatic configuration"
        echo -e "10. Previous menu\n"

        read -p "Enter your choice : " CHOICESERVICE

        case $CHOICESERVICE in 
            1) clamav_configuration; add_services; break ;;
            2) fail2ban_configuration; add_services; break ;;
            3) grub_configuration; add_services; break ;;
            4) fstab_configuration; add_services; break ;;
            5) nmap_configuration; add_services; break ;;
            6) httpd_configuration; add_services; break ;;
            7) mariaDB_configuration; add_services; break ;;
            8) phpMyAdmin_configuration; add_services; break ;;
            9) clamav_configuration; fail2ban_configuration; grub_configuration; nmap_configuration; httpd_configuration; break;;
            10) main; break;; 
            *) echo -e "Invalid value, please try again";; 
        esac
    done
}

# Done
clamav_configuration() {
    clear 
    echo -e "\n${BLUE}-----------------${ENDCOLOR}"
    echo -e "${BLUE}     ClamAV      ${ENDCOLOR}"
    echo -e "${BLUE}  Configuration  ${ENDCOLOR}"
    echo -e "${BLUE}-----------------${ENDCOLOR}\n"

    dnf -y install clamav clamd 

    mkdir /var/log/clamav
    touch /var/log/clamav/clamav-scan.log

    # Every day at 12:30, the server will scan the entire system.
    bash -c "(crontab -l 2>/dev/null; echo '30 12 * * * /usr/bin/clamscan -ri / >> /var/log/clamav/clamav-scan.log') | crontab -"

    # Every Wednesday at 12:00, the server will update the antivirus database.
    bash -c "(crontab -l 2>/dev/null; echo '0 12 3 * * freshclam') | crontab -"

    systemctl start clamav-freshclam
    systemctl enable clamav-freshclam

    firewall-cmd --add-port=3310/tcp --permanent
    firewall-cmd --reload

    echo -e "\n${GREEN}ClamAV configuration done.${ENDCOLOR}\n"
}

# Done
fail2ban_configuration() {
    clear 
    echo -e "\n${BLUE}-----------------${ENDCOLOR}"
    echo -e "${BLUE}    Fail2Ban     ${ENDCOLOR}"
    echo -e "${BLUE}  Configuration  ${ENDCOLOR}"
    echo -e "${BLUE}-----------------${ENDCOLOR}\n"

    source ./config.conf

    dnf -y install fail2ban

    systemctl start fail2ban
    systemctl enable fail2ban

    # Command to unban an IP : fail2ban-client set sshd unbanip [ip]

    cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    mv /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.bak

    # Condition si la variable $PORT existe dans le fichier ./config.conf 
    if grep -q 'PORT' ./config.conf; then 
        sed -i "92s/.*/ignoreip = 127.0.0.1/32 ::1 $NETWORKADDRESS/$SUBNETMASK" /etc/fail2ban/jail.local
        sed -i "103s/10m/1d/" /etc/fail2ban/jail.local
        sed -i "110s/5/3/" /etc/fail2ban/jail.local
        sed -i "162s/normal/aggressive/" /etc/fail2ban/jail.local
        sed -i "279s/#//; 279s/normal/aggressive/" /etc/fail2ban/jail.local
        sed -i "280s/ssh/$PORT/" /etc/fail2ban/jail.local
        sed -i "283s/^$/enabled = true/" /etc/fail2ban/jail.local
        sed -i "287s/ssh/$PORT/" /etc/fail2ban/jail.local
        sed -i "293s/^$/enabled = true/" /etc/fail2ban/jail.local
        sed -i "294s/ssh/$PORT/" /etc/fail2ban/jail.local
    else 
        sed -i "103s/10m/1d/" /etc/fail2ban/jail.local
        sed -i "110s/5/3/" /etc/fail2ban/jail.local
        sed -i "162s/normal/aggressive/" /etc/fail2ban/jail.local
        sed -i "279s/#//; 279s/normal/aggressive/" /etc/fail2ban/jail.local
        sed -i "280s/ssh/22/" /etc/fail2ban/jail.local
        sed -i "283s/^$/enabled = true/" /etc/fail2ban/jail.local
        sed -i "287s/ssh/22/" /etc/fail2ban/jail.local
        sed -i "293s/^$/enabled = true/" /etc/fail2ban/jail.local
        sed -i "294s/ssh/22/" /etc/fail2ban/jail.local
    fi 
    systemctl restart fail2ban

    echo -e "\n${GREEN}Fail2Ban configuration done.${ENDCOLOR}\n"
}

# Done
nmap_configuration() {
    clear
    source ./config.conf
    echo -e "\n${BLUE}-----------------${ENDCOLOR}"
    echo -e "${BLUE}      Nmap       ${ENDCOLOR}"
    echo -e "${BLUE}  Configuration  ${ENDCOLOR}"
    echo -e "${BLUE}-----------------${ENDCOLOR}\n"

    source ./config.conf
    
    dnf -y install nmap

    chmod 750 /usr/bin/nmap
    setfacl -m o::0 /usr/bin/nmap

    nmap $IPADDRESS 

    echo -e "\n${GREEN}Nmap configuration done.${ENDCOLOR}\n"
}

# Done
grub_configuration() {
    clear
    echo -e "\n${BLUE}-----------------${ENDCOLOR}"
    echo -e "${BLUE}      Grub       ${ENDCOLOR}"
    echo -e "${BLUE}  Configuration  ${ENDCOLOR}"
    echo -e "${BLUE}-----------------${ENDCOLOR}\n"
    
    # use this function before changing /etc/fstab
    read -p "Enter the username : " USERNAMEGRUB
    echo -n "Enter the password : " && read -s PASSWORDGRUB && echo

    echo 'cat << EOF' >> /etc/grub.d/00_header
    echo 'set superusers="$USERNAMEGRUB"' >> /etc/grub.d/00_header
    echo 'password $USERNAMEGRUB $PASSWORDGRUB' >> /etc/grub.d/00_header
    echo 'EOF' >> /etc/grub.d/00_header

    grub2-mkconfig -o /boot/grub2/grub.cfg

    echo -e "\n${GREEN}Grub configuration done.${ENDCOLOR}\n"
}

# Done
fstab_configuration() {
    clear
    echo -e "\n${BLUE}-----------------${ENDCOLOR}"
    echo -e "${BLUE}     Fstab       ${ENDCOLOR}"
    echo -e "${BLUE}  Configuration  ${ENDCOLOR}"
    echo -e "${BLUE}-----------------${ENDCOLOR}\n"

    echo -e "Available mounting options :"
    echo -e "----------------------------\n"
    echo -e "nodev : Do not interpret character or block special devices on the file system."
    echo -e "noexec : Do not allow execution of any binaries on the mounted file system."
    echo -e "nosuid : Do not allow set-user-identifier or set-group-identifier bits to take effect."
    echo -e "ro : Mount the file system read-only."
    echo -e "relatime : Update inode access times relative to modify or change time."
    echo -e "defaults : Use the default options : rw, suid, dev, exec, auto, nouser, and async."

    for (( partition=12; partition<=19; partition++ )); do
        second_column=$(awk -v partition="$partition" 'NF && $1 !~ /^#/ {if (NR==partition) print $2}' /etc/fstab)
        
        echo -e "\n----------------"
        echo -e "Partition : $second_column"
        echo -e "----------------\n"

        read -p "Enter the mounting options (ex : defaults,nodev,noexec,...) : " MOUNTINGOPTIONS

        case $second_column in

            /) sed -i "${partition}s/defaults/$MOUNTINGOPTIONS/" /etc/fstab ;;
            /backup) sed -i "${partition}s/defaults/$MOUNTINGOPTIONS/" /etc/fstab ;; 
            /boot/efi) echo -e "No available mouting options.";;
            /boot) sed -i "${partition}s/defaults/$MOUNTINGOPTIONS/" /etc/fstab ;;
            /home) sed -i "${partition}s/defaults/$MOUNTINGOPTIONS/" /etc/fstab ;;
            /tmp) sed -i "${partition}s/defaults/$MOUNTINGOPTIONS/" /etc/fstab ;; 
            /var) sed -i "${partition}s/defaults/$MOUNTINGOPTIONS/" /etc/fstab ;;
            /web) sed -i "${partition}s/defaults/$MOUNTINGOPTIONS/" /etc/fstab ;;
            *) echo -e "No available mouting options.";;
        esac
    done

    echo -e "\n${GREEN}Fstab configuration done.${ENDCOLOR}\n"

    echo -e "The system will restart."
    read -p "Press any key to continue... " -n1 -s

    shutdown -r now
}

httpd_configuration() {

    # YOU NEED TO DESACTIVATE IPV6 

    echo -e "${BLUE}---------------{ENDCOLOR}"
    echo -e "${BLUE}     Httpd     {ENDCOLOR}"
    echo -e "${BLUE} Configuration {ENDCOLOR}"
    echo -e "${BLUE}---------------{ENDCOLOR}\n"

    source ./config.conf

    dnf -y install httpd 
    dnf -y install mod_ssl

    systemctl start httpd
    systemctl enable httpd

    read -p "Enter where the website will be stored : " WEBSITEPATH
    read -p "Enter the parent folder of the website : " PARENTFOLDER

    echo "WEBSITEPATH=$WEBSITEPATH" >> ./config.conf
    echo "PARENTFOLDER=$PARENTFOLDER" >> ./config.conf

    HTTPD_CONF="/etc/httpd/conf/httpd.conf"

    cp $HTTPD_CONF $HTTPD_CONF.bak

    sed -i "47s/.*/Listen $IPADDRESS:80/" $HTTPD_CONF
    sed -i "100s/.*/ServerName $HOSTNAME.$SERVERNAME.$DOMAIN:80/" $HTTPD_CONF
    sed -i "124s|/var/www/html|$WEBSITEPATH|" $HTTPD_CONF sed -i
    sed -i "129s|/var/www|$PARENTFOLDER|" $HTTPD_CONF
    sed -i "136s|/var/www/html|$WEBSITEPATH|" $HTTPD_CONF
    sed -i "149s/.*/Options FollowSymLinks/" $HTTPD_CONF
    sed -i "156s/.*/AllowOverride All/" $HTTPD_CONF
    sed -i "169s/.*/DirectoryIndex index.html index.php index.cgi/" $HTTPD_CONF
    echo "# server's response header" >> $HTTPD_CONF
    echo "ServerTokens Prod" >> $HTTPD_CONF

    openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout /etc/ssl/certs/httpd-selfsigned.key -out /etc/ssl/certs/httpd-selfsigned.crt

    cat <<EOF > /etc/httpd/conf.d/main.conf          
<VirtualHost *:80>
    ServerName $HOSTNAME.$SERVERNAME.$DOMAIN
    ServerAlias www.$SERVERNAME.$DOMAIN
    Redirect permanent / https://$HOSTNAME.$SERVERNAME.$DOMAIN/
</VirtualHost>

<VirtualHost *:80>
    ServerName www.$SERVERNAME.$DOMAIN
    Redirect permanent / https://www.$SERVERNAME.$DOMAIN/
</VirtualHost>

<VirtualHost _default_:443>
    ServerName $HOSTNAME.$SERVERNAME.$DOMAIN
    ServerAlias www.$SERVERNAME.$DOMAIN
    DocumentRoot $WEBSITEPATH
    SSLEngine On
    SSLCertificateFile /etc/ssl/certs/httpd-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/certs/httpd-selfsigned.key
</VirtualHost>
EOF

    mkdir -p $WEBSITEPATH

    firewall-cmd --permanent --add-service=http
    firewall-cmd --permanent --add-service=https
    firewall-cmd --reload

    semanage fcontext -a -e /var/www $WEBSITEPATH
    
    # Don't forget to use these commands 
    # when you're putting new file(s) in 
    # your website path(s)
    
    restorecon -Rv $PARENTFOLDER
    chcon -R -t httpd_sys_content_t $WEBSITEPATH
    chown -R apache:apache $WEBSITEPATH
    chmod -R 755 $WEBSITEPATH

    reload_website_path_command

    echo -e "\n${GREEN}Httpd configuration done.${ENDCOLOR}\n"
}

reload_website_path_command() {
    source ./config.conf
    dnf install -y inotify-tools
    cat <<EOF > /sbin/monitor-website
#!/bin/bash

reload_website_path() {

    restorecon -Rv $PARENTFOLDER
    chcon -R -t httpd_sys_content_t $WEBSITEPATH
    chown -R apache:apache $WEBSITEPATH
    chmod -R 755 $WEBSITEPATH
    systemctl restart httpd

}

monitor_website_path() {

    while inotifywait -r -e modify,create,delete $WEBSITEPATH; do 
        reload_website_path
    done

}

monitor_website_path
EOF

    chmod 750 /sbin/monitor-website

    cat <<DEL > /etc/systemd/system/monitor_website.service
[Unit]
Description=Monitor Website Path and Reload Configuration
After=network.target

[Service]
ExecStart=/sbin/monitor-website
Restart=alwais
User=root

[Install]
WantedBy=multi-user.target
DEL 
    chmod +x /etc/systemd/system/monitor_website.service
    systemctl daemon-reload
    systemctl enable monitor_website.service
    systemctl start monitor_website.service
}

mariaDB_configuration() {
    dnf install mariadb-server -y
    systemctl start mariadb 
    systemctl enable mariadb
    mysql_secure_installation
    # n, y, y, y, y, y
}

phpMyAdmin_configuration() {
    dnf install php php-common php-mysqlnd php-curl php-xml php-json php-gd php-mbstring -y
}

dns_configuration() {
}

dhcp_configuration() {
}

#################
# MAIN FUNCTION #
#################

# Done
main() {
    check_root
    while true; do 
        clear
        echo -e "${BLUE}------${ENDCOLOR}"
        echo -e "${BLUE} Menu ${ENDCOLOR}"
        echo -e "${BLUE}------${ENDCOLOR}\n"

        echo -e "1. Update the system"
        echo -e "2. Global configurations"
        echo -e "3. SSH configuration"
        echo -e "4. Add services"
        echo -e "5. Backup configuration"
        echo -e "6. Restore backup"
        echo -e "7. Automatic configuration"
        echo -e "8. Exit\n"

        read -p "Enter your choice : " CHOICE

        case $CHOICE in 
            1) update_system; main; break ;;
            2) starting; global_configuration; main; break ;;
            3) ssh_configuration; main; break ;;
            4) add_services; break ;;
            5) backup_configuration; main; break ;;
            6) restore_backup; main; break ;;
            7) starting; update_system; global_configuration; ssh_configuration; backup_configuration; restore_backup; add_services; break ;;
            8) echo -e "Ciao !"; break ;;
            *) echo -e "Invalid value, please try again";; 
        esac
    done 
}

main