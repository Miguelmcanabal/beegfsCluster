#!/bin/bash



# Install basic software
yum install -y ntp vim nano sshpass unzip python-apt dnsutils dos2unix whois
timedatectl set-timezone Europe/Madrid
systemctl enable ntpd
systemctl start ntpd

# Populate /etc/hosts
sed -i "/$HOSTNAME/d" /etc/hosts

if ! grep -Fq 192.168.44.1 /etc/hosts ; then
    echo -e "192.168.44.1 \t master" >> /etc/hosts
fi

if ! grep -Fq 192.168.44.10 /etc/hosts ; then
    echo -e "192.168.44.10 \t mgmt" >> /etc/hosts
fi

if ! grep -Fq 192.168.44.20 /etc/hosts ; then
    echo -e "192.168.44.20 \t meta" >> /etc/hosts
fi


if ! grep -Fq 192.168.44.30 /etc/hosts ; then
    echo -e "192.168.44.30 \t storage" >> /etc/hosts
fi
  
if ! grep -Fq 192.168.44.40 /etc/hosts ; then
    echo -e "192.168.44.40 \t client" >> /etc/hosts
fi
  
if ! grep -Fq 192.168.44.50 /etc/hosts ; then
    echo -e "192.168.44.50 \t admon" >> /etc/hosts
fi


# SSH config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
