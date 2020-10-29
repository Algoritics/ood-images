#!/bin/bash
set -e

yum -y install mailx openssh-server
install -D -m644 /opt/slurm/etc/slurmctld.service /etc/systemd/system/
install -D -m644 /opt/slurm/etc/slurmd.service /etc/systemd/system/
install -d -o slurm -g slurm /var/spool/slurm
install -d -o slurm -g slurm /var/log/slurm
install -d -o slurm -g slurm /var/run/slurm
install -d /var/spool/slurmd
/usr/sbin/sshd-keygen
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
cp /build/launch-head /usr/local/sbin/launch

echo "[TurboVNC]" >> /etc/yum.repos.d/TurboVNC.repo
echo "name=TurboVNC official RPMs" >> /etc/yum.repos.d/TurboVNC.repo
echo "baseurl=https://sourceforge.net/projects/turbovnc/files" >> /etc/yum.repos.d/TurboVNC.repo
echo "gpgcheck=1 >> /etc/yum.repos.d/TurboVNC.repo"
echo "gpgkey=https://sourceforge.net/projects/turbovnc/files/VGL-GPG-KEY" >> /etc/yum.repos.d/TurboVNC.repo
echo "enabled=1" >> /etc/yum.repos.d/TurboVNC.repo

# interactive desktop setup
yum -y update
yum -y install nmap turbovnc xorg-x11-xauth
pip3 install websockify
yum -y groupinstall "MATE Desktop"
dbus-uuidgen > /etc/machine-id

# jupyter setup
pip3 install jupyter

yum clean all && rm -rf /var/cache/yum/*


