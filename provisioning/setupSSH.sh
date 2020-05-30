#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Sintaxis: $0 PASSWD "
    exit
fi

USER_DIR=/home/$USER/.ssh
PASSWORD=$1

if [ "$HOSTNAME" = "master" ]; then
    if [[ ! -f $USER_DIR/id_rsa.pub ]]; then
        echo "Creating ssh public key"
        ansible cluster -e "ansible_password=$PASSWORD" -i /vagrant/ansible/inventory -m shell -a "echo -e 'y\n' | ssh-keygen -t rsa -f $USER_DIR/id_rsa -q -N ''"
        chmod 0600 $USER_DIR/id_rsa
        chmod 0644 $USER_DIR/id_rsa.pub
    fi
    
    rm $USER_DIR/host-ids.pub >& /dev/null
    rm $USER_DIR/known_hosts >& /dev/null
    cat $USER_DIR/id_rsa.pub > $USER_DIR/host-ids.pub
    
    # For vagrant user, do NOT delete the key inserted by vagrant (the first one)
    if [[ "$USER" = "vagrant" ]]; then
        sed -i '1!d' $USER_DIR/authorized_keys >& /dev/null
    else
        sed -i d $USER_DIR/authorized_keys >& /dev/null
    fi
    
    chmod 0600 $USER_DIR/authorized_keys >& /dev/null
    
    if [[ "$USER" = "vagrant" ]]; then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no "mgmt" "sed -i '1!d' $USER_DIR/authorized_keys"
    else
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no "mgmt" "sed -i d $USER_DIR/authorized_keys"
    fi
    sshpass -p $PASSWORD ssh "mgmt" "chmod 0600 $USER_DIR/authorized_keys" >& /dev/null
    sshpass -p $PASSWORD ssh "mgmt" "cat $USER_DIR/id_rsa.pub" >> $USER_DIR/host-ids.pub


    if [[ "$USER" = "vagrant" ]]; then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no "storage" "sed -i '1!d' $USER_DIR/authorized_keys"
    else
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no "storage" "sed -i d $USER_DIR/authorized_keys"
    fi
    sshpass -p $PASSWORD ssh "storage" "chmod 0600 $USER_DIR/authorized_keys" >& /dev/null
    sshpass -p $PASSWORD ssh "storage" "cat $USER_DIR/id_rsa.pub" >> $USER_DIR/host-ids.pub
    
    if [[ "$USER" = "vagrant" ]]; then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no "meta" "sed -i '1!d' $USER_DIR/authorized_keys"
    else
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no "meta" "sed -i d $USER_DIR/authorized_keys"
    fi
    sshpass -p $PASSWORD ssh "client" "chmod 0600 $USER_DIR/authorized_keys" >& /dev/null
    sshpass -p $PASSWORD ssh "client" "cat $USER_DIR/id_rsa.pub" >> $USER_DIR/host-ids.pub

    if [[ "$USER" = "vagrant" ]]; then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no "client" "sed -i '1!d' $USER_DIR/authorized_keys"
    else
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no "client" "sed -i d $USER_DIR/authorized_keys"
    fi
    sshpass -p $PASSWORD ssh "meta" "chmod 0600 $USER_DIR/authorized_keys" >& /dev/null
    sshpass -p $PASSWORD ssh "meta" "cat $USER_DIR/id_rsa.pub" >> $USER_DIR/host-ids.pub

    if [[ "$USER" = "vagrant" ]]; then
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no "admon" "sed -i '1!d' $USER_DIR/authorized_keys"
    else
        sshpass -p $PASSWORD ssh -oStrictHostKeyChecking=no "admon" "sed -i d $USER_DIR/authorized_keys"
    fi
    sshpass -p $PASSWORD ssh "admon" "chmod 0600 $USER_DIR/authorized_keys" >& /dev/null
    sshpass -p $PASSWORD ssh "admon" "cat $USER_DIR/id_rsa.pub" >> $USER_DIR/host-ids.pub









    sshpass -p $PASSWORD ssh-copy-id -f -i $USER_DIR/host-ids.pub "storage"
    sshpass -p $PASSWORD ssh-copy-id -f -i $USER_DIR/host-ids.pub "mgmt"
    sshpass -p $PASSWORD ssh-copy-id -f -i $USER_DIR/host-ids.pub "client"
    sshpass -p $PASSWORD ssh-copy-id -f -i $USER_DIR/host-ids.pub "meta"
    sshpass -p $PASSWORD ssh-copy-id -f -i $USER_DIR/host-ids.pub "admon"

    
    cat $USER_DIR/host-ids.pub >> $USER_DIR/authorized_keys
fi
