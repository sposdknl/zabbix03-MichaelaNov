#!/usr/bin/env bash

set -e

ZABBIX_SERVER="192.168.1.2"  # IP vašeho Zabbix serveru appliance
HOST_METADATA="SPOS"
ZABBIX_VERSION="7.0"

# Instalace základních nástrojů
sudo dnf install -y net-tools wget uuidd

# Přidání Zabbix repozitáře
sudo rpm -Uvh https://repo.zabbix.com/zabbix/${ZABBIX_VERSION}/rhel/8/x86_64/zabbix-release-${ZABBIX_VERSION}-1.el8.noarch.rpm

sudo dnf clean all
sudo dnf makecache

# Instalace agenta
sudo dnf install -y zabbix-agent2 zabbix-agent2-plugin-*

CONFIG_FILE="/etc/zabbix/zabbix_agent2.conf"

# Generování unikátního hostname (např. alma-UUID)
UUID=$(uuidgen)
UNIQUE_HOSTNAME="alma-${UUID}"
SHORT_HOSTNAME=$(echo "$UNIQUE_HOSTNAME" | cut -d'-' -f1,2)

# Záloha konfigurace
sudo cp -v $CONFIG_FILE ${CONFIG_FILE}.orig

# Nastavení Server a ServerActive
sudo sed -i "s/^Server=.*/Server=${ZABBIX_SERVER}/" $CONFIG_FILE
sudo sed -i "s/^ServerActive=.*/ServerActive=${ZABBIX_SERVER}/" $CONFIG_FILE

# Nastavení unikátního hostname
if grep -q "^Hostname=" $CONFIG_FILE; then
    sudo sed -i "s/^Hostname=.*/Hostname=${SHORT_HOSTNAME}/" $CONFIG_FILE
else
    echo "Hostname=${SHORT_HOSTNAME}" | sudo tee -a $CONFIG_FILE
fi

# Nastavení HostMetadata pro auto-registraci
if grep -q "^HostMetadata=" $CONFIG_FILE; then
    sudo sed -i "s/^HostMetadata=.*/HostMetadata=${HOST_METADATA}/" $CONFIG_FILE
else
    echo "HostMetadata=${HOST_METADATA}" | sudo tee -a $CONFIG_FILE
fi

# Povolení a restart služby
sudo systemctl enable zabbix-agent2
sudo systemctl restart zabbix-agent2

echo "Zabbix agent2 byl nainstalován a nakonfigurován s hostname: $SHORT_HOSTNAME a HostMetadata: $HOST_METADATA"
