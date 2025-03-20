#!/bin/bash

# Проверка на root права
if [ "$EUID" -ne 0 ]; then 
    echo "Пожалуйста, запустите скрипт с правами root"
    exit 1
fi

# Определение основного сетевого интерфейса
INTERFACE=$(ip -o -4 route show to default | awk '{print $5}' | head -n1)

# Запрос параметров сети
read -p "Введите IP-адрес хоста (например, 192.168.1.100): " IP_ADDRESS
read -p "Введите маску сети в формате CIDR (например, 24 для /24): " NETMASK
read -p "Введите адрес шлюза (например, 192.168.1.1): " GATEWAY
read -p "Введите первичный DNS-сервер: " DNS1
read -p "Введите вторичный DNS-сервер: " DNS2

# Создание файла конфигурации сети
echo "Создание конфигурации сети..."
cat > /etc/sysconfig/network-scripts/ifcfg-$INTERFACE << EOF
TYPE=Ethernet
BOOTPROTO=none
NAME=$INTERFACE
DEVICE=$INTERFACE
ONBOOT=yes
IPADDR=$IP_ADDRESS
PREFIX=$NETMASK
GATEWAY=$GATEWAY
DNS1=$DNS1
DNS2=$DNS2
EOF

# Перезапуск сетевого сервиса
echo "Перезапуск сетевого сервиса..."
systemctl restart NetworkManager

# Проверка настроек
echo -e "\nНовые настройки сети:"
echo "========================="
echo "Интерфейс: $INTERFACE"
echo "IP-адрес: $IP_ADDRESS/$NETMASK"
echo "Шлюз: $GATEWAY"
echo "DNS серверы: $DNS1, $DNS2"
echo "========================="

# Проверка подключения
echo -e "\nПроверка подключения..."
ping -c 3 $GATEWAY

if [ $? -eq 0 ]; then
    echo "Настройка сети успешно завершена!"
else
    echo "Предупреждение: Не удалось выполнить ping шлюза. Проверьте настройки."
fi

# Сохранение резервной копии
echo "Создание резервной копии настроек..."
cp /etc/sysconfig/network-scripts/ifcfg-$INTERFACE /etc/sysconfig/network-scripts/ifcfg-$INTERFACE.backup

# Обновление resolv.conf
echo "Обновление DNS настроек..."
cat > /etc/resolv.conf << EOF
nameserver $DNS1
nameserver $DNS2
EOF

echo -e "\nДля проверки настроек выполните:"
echo "ip addr show $INTERFACE"
echo "ip route show"
echo "cat /etc/resolv.conf" 
