#!/usr/bin/env bash

#=============================================================================
# DB Setup

if [[ ! -d /var/www/public ]]; then
  mkdir /var/www/public
fi 

sudo chown -R vagrant:vagrant /var/www/public
sudo chmod a+rwx /var/www/public

rm -rf /var/www/public/*
launchversion="Latest"


echo "bootstrapping $launchversion"
filename=ChurchCRM-$launchversion.zip
wget -nv -O /tmp/$filename https://github.com/ChurchCRM/CRM/releases/download/$launchversion/$filename
unzip -d /tmp/churchcrm /tmp/$filename
shopt -s dotglob  
mv  /tmp/churchcrm/churchcrm/* /var/www/public/
CRM_DB_INSTALL_SCRIPT="/var/www/public/mysql/install/Install.sql"
CRM_DB_USER="churchcrm"
CRM_DB_PASS="churchcrm"
CRM_DB_NAME="churchcrm"


DB_USER="root"
DB_PASS="root"
DB_HOST="localhost"

echo "=========================================================="
echo "====================   DB Setup  ========================="
echo "=========================================================="
sudo sed -i 's/^bind-address.*$/bind-address=0.0.0.0/g' /etc/mysql/my.cnf
sudo service mysql restart
RET=1
while [[ RET -ne 0 ]]; do
    echo "Database: Waiting for confirmation of MySQL service startup"
    sleep 5
    sudo mysql -u"$DB_USER" -p"$DB_PASS" -e "status" > /dev/null 2>&1
    RET=$?
done

echo "Database: mysql started"

sudo mysql -u"$DB_USER" -p"$DB_PASS" -e "DROP DATABASE $CRM_DB_NAME;"
sudo mysql -u"$DB_USER" -p"$DB_PASS" -e "DROP USER '$CRM_DB_USER';"
echo "Database: cleared"

sudo mysql -u"$DB_USER" -p"$DB_PASS" -e "CREATE DATABASE $CRM_DB_NAME CHARACTER SET utf8;"

echo "Database: created"

sudo mysql -u"$DB_USER" -p"$DB_PASS" -e "CREATE USER '$CRM_DB_USER'@'%' IDENTIFIED BY '$CRM_DB_PASS';"
sudo mysql -u"$DB_USER" -p"$DB_PASS" -e "GRANT ALL PRIVILEGES ON $CRM_DB_NAME.* TO '$CRM_DB_NAME'@'%' WITH GRANT OPTION;"
sudo mysql -u"$DB_USER" -p"$DB_PASS" -e "FLUSH PRIVILEGES;"
echo "Database: user created with needed PRIVILEGES"

if [ -f "$CRM_DB_RESTORE_SCRIPT" ]; then
  sudo mysql -u"$CRM_DB_USER" -p"$CRM_DB_PASS" "$CRM_DB_NAME" < $CRM_DB_RESTORE_SCRIPT
fi

if [ -f "$CRM_DB_INSTALL_SCRIPT" ]; then
  sudo mysql -u"$CRM_DB_USER" -p"$CRM_DB_PASS" "$CRM_DB_NAME" < $CRM_DB_INSTALL_SCRIPT
fi

#=============================================================================
# Help info

echo "============================================================================="
echo "======== ChurchCRM is now hosted @ http://192.168.33.12/       =============="
echo "======== Version is: $launchversion                            =============="
echo "======== CRM User Name: admin                                  =============="
echo "======== 1st time login password for admin: changeme           =============="
echo "============================================================================="
