#!/bin/bash

sudo unzip ELM-Web-Installer-Linux-7.0.1.zip -d /opt/ELM
sudo mkdir /opt/ELM/im/repo
sudo unzip JazzAuthServer-offering-repo-7.0.1 -d /opt/jas
sudo mv /opt/jas/im/repo/jlip-auth-offering/offering-repo /opt/ELM/im/repo -v
cd /opt/ELM/im/linux.gtk.x86_64/
sudo ./installc -showVerboseProgress -input silent-install-jas2.xml --launcher.ini silent-install.ini -acceptLicense
sudo useradd jazz
sudo chown -R jazz:jazz /opt/IBM
sudo vi /opt/IBM/JazzAuthServer/wlp/usr/servers/jazzop/server.xml