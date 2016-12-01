#!/bin/bash

repos=0
my_repos=( $(/usr/bin/yum repolist all |awk '{print $1}') )
for i in "${!my_repos[@]}"; do
    if [[ ${my_repos[$i]} == *'rhel-7-server-optional-rpms'* || ${my_repos[$i]} == *'rhel-7-server-rh-common-rpms'* ]]; then
	((repos++))
    fi
done

if [ $repos -eq 2 ]; then
    /usr/bin/ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
    /usr/bin/ssh-copy-id root@localhost
    /usr/sbin/subscription-manager repos --disable="*" --enable="rhel-7-server-rpms"
    /usr/bin/yum install -y wget git
    /usr/bin/wget -P /tmp https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    /usr/bin/rpm -i /tmp/epel-release-latest-7.noarch.rpm
    /usr/bin/yum install -y ansible
    /usr/bin/git clone https://github.com/eddiechen/tower_install.git /opt/tower_install
    /usr/bin/ansible-playbook -i "localhost," /opt/tower_install/tower-install.yml
    rm -rf /opt/tower_install /root/install_tower.sh
else
    echo "Please verify that \"RHEL Extras\" and \"RHEL Optional\" yum repositories are available"
fi
