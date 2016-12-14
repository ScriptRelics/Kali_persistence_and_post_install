#!/bin/bash

echo "Easy Installer for NoMachine"
echo "Downloading NoMachine"
wget http://download.nomachine.com/download/5.1/Linux/nomachine_5.1.54_1_amd64.deb
sleep 1
echo "Installing NoMachine"
sudo dpkg -i nomachine_5.1.54_1_amd64.deb
#For more info go to: https://www.nomachine.com/download/download&id=9
#For more info go to: https://www.nomachine.com/

#for windows DL go to: https://www.nomachine.com/download/download&id=17
