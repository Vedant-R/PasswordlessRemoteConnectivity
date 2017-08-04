#!/usr/bin/env bash
#Script developed by----Vedant Ruparelia

#'passwordOfRemoteMachine' = Enter your remote machine password
#'usernameOfRemoteMachine' = Enter your remote machine username
#'ipOfRemoteMachine' = Enter your remote machine ipaddress
#'RemoteMachineName' = Enter your remote machine name (Ideally any name can be given)
#'usernameOfLocalMachine' = Enter your local machine username

#Tool for non-interactivly performing password authentication
sudo yum install sshpass -y

#Developing script for installating ssh-keygen
#This script will check if ssh-keygen is already installed and if not then only it will install it
sudo echo -e \" [ -f /root/.ssh/id_rsa ] || ( mkdir -p /root/.ssh ; chmod 700 /root/.ssh ; sudo ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa ) \" > /tmp/keygen.sh

#Giving executable permission to the script
sudo chmod +x /tmp/keygen.sh

#Executing the script to install ssh-keygen
sudo sh /tmp/keygen.sh

sleep 5

#Creating .ssh directory in remote machine to pass public keygen
sudo sshpass -p 'passwordOfRemoteMachine' sudo ssh -o StrictHostKeyChecking=no 'usernameOfRemoteMachine'@'ipOfRemoteMachine' mkdir /home/users/'usernameOfRemoteMachine'/.ssh

#Fixing the permissions of .ssh directory on remote machine
sudo sshpass -p 'passwordOfRemoteMachine' sudo ssh -o StrictHostKeyChecking=no 'usernameOfRemoteMachine'@'ipOfRemoteMachine' chmod 700 /home/users/'usernameOfRemoteMachine'/.ssh/

#Copying the public key in remote machine
sudo sshpass -p 'passwordOfRemoteMachine' sudo scp -o StrictHostKeyChecking=no /root/.ssh/id_rsa.pub 'usernameOfRemoteMachine'@'ipOfRemoteMachine':/home/users/'usernameOfRemoteMachine'/.ssh/

#Renaming the public key on remote machine to authorized_keys as required
sudo sshpass -p 'passwordOfRemoteMachine' sudo ssh -o StrictHostKeyChecking=no 'usernameOfRemoteMachine'@'ipOfRemoteMachine' mv /home/users/'usernameOfRemoteMachine'/.ssh/id_rsa.pub /home/users/'usernameOfRemoteMachine'/.ssh/authorized_keys

#Fixing the permissions of authorized_keys on remote machine
sudo sshpass -p 'passwordOfRemoteMachine' sudo ssh -o StrictHostKeyChecking=no 'usernameOfRemoteMachine'@'ipOfRemoteMachine' chmod 600 /home/users/'usernameOfRemoteMachine'/.ssh/authorized_keys

#Generating .ppk key from ssh key
sudo puttygen /root/.ssh/id_rsa -o /root/.ssh/id_rsa.ppk

#Creating a putty session in a script file
sudo echo -e \"sudo putty -ssh -l 'usernameOfRemoteMachine'@'ipOfRemoteMachine' -i /root/.ssh/id_rsa.ppk\" > /tmp/putty.sh

#Giving executable permission to the script
sudo chmod +x /tmp/putty.sh

#Creating a putty desktop icon for remote machine
sudo echo -e \"[Desktop Entry]\nEncoding=UTF-8\nName='RemoteMachineName'Putty\nComment='RemoteMachineName'Putty\nExec=/tmp/putty.sh\nIcon=putty\nTerminal=false\nType=Application\nCategories=GNOME;Application;Development;\nStartupNotify=true\" > /home/users/'usernameOfLocalMachine'/Desktop/'RemoteMachineName'Putty.desktop

#Giving executable permission to the desktop icon
sudo chmod +x /tmp/'RemoteMachineName'Putty.desktop


