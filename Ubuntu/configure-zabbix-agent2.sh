<<<<<<< HEAD
#!/usr/bin/env bash

# Vygeneruj unikátní hostname
UNIQUE_HOSTNAME="ubuntu-$(uuidgen)"
SHORT_HOSTNAME=$(echo "$UNIQUE_HOSTNAME" | cut -d'-' -f1,2)

# Změna hostname systému 
sudo hostnamectl set-hostname "$SHORT_HOSTNAME"

# Záloha původního konfiguračního souboru
sudo cp -v /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf-orig

# Úprava konfiguračního souboru
sudo sed -i "s/^Hostname=.*/Hostname=$SHORT_HOSTNAME/" /etc/zabbix/zabbix_agent2.conf
sudo sed -i "s/^Server=.*/Server=192.168.1.2/" /etc/zabbix/zabbix_agent2.conf
sudo sed -i "s/^ServerActive=.*/ServerActive=192.168.1.2/" /etc/zabbix/zabbix_agent2.conf
sudo sed -i "s/^# Timeout=.*/Timeout=30/" /etc/zabbix/zabbix_agent2.conf
sudo sed -i "s/^# HostMetadata=.*/HostMetadata=SPOS/" /etc/zabbix/zabbix_agent2.conf

# Zobraz rozdíly oproti původnímu souboru
sudo diff -u /etc/zabbix/zabbix_agent2.conf-orig /etc/zabbix/zabbix_agent2.conf

# Restart služby
sudo systemctl restart zabbix-agent2

echo "Konfigurace dokončena. Hostname: $SHORT_HOSTNAME"
=======
#!/usr/bin/env bash

# Unikatni hostname ubuntu (Lepší než hostname školní stanice)
UNIQUE_HOSTNAME="ubuntu-$(uuidgen)"
SHORT_HOSTNAME=$(echo $UNIQUE_HOSTNAME | cut -d'-' -f1,2)

# # Konfigurace zabbix_agent2.conf
sudo cp -v /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf-orig
sudo sed -i "s/Hostname=Zabbix server/Hostname=$SHORT_HOSTNAME/g" /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/Server=127.0.0.1/Server=enceladus.pfsense.cz/g' /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/ServerActive=127.0.0.1/ServerActive=enceladus.pfsense.cz/g' /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/# Timeout=3/Timeout=30/g' /etc/zabbix/zabbix_agent2.conf
sudo sed -i 's/# HostMetadata=/HostMetadata=SPOS/g' /etc/zabbix/zabbix_agent2.conf
sudo diff -u /etc/zabbix/zabbix_agent2.conf-orig /etc/zabbix/zabbix_agent2.conf

# Restart sluzby zabbix-agent2
sudo systemctl restart zabbix-agent2

# EOF
>>>>>>> 2caed50927572c387b36483daefd5f0eea555536
