#!/bin/bash

# Проверка на root права
if [ "$EUID" -ne 0 ]; then 
    echo "Пожалуйста, запустите скрипт с правами root"
    exit 1
fi

# Определение основного сетевого интерфейса
INTERFACE=$(ip -o -4 route show to default | awk '{print $5}' | head -n1)

# Получение текущего имени соединения
CONNECTION_NAME=$(nmcli -g NAME connection show --active | grep -v 'lo' | head -n1)

if [ -z "$CONNECTION_NAME" ]; then
    CONNECTION_NAME="static-$INTERFACE"
fi

# Запрос параметров сети
read -p "Введите IP-адрес хоста (например, 192.168.1.100): " IP_ADDRESS
read -p "Введите маску сети в формате CIDR (например, 24 для /24): " NETMASK
read -p "Введите адрес шлюза (например, 192.168.1.1): " GATEWAY
read -p "Введите первичный DNS-сервер: " DNS1
read -p "Введите вторичный DNS-сервер: " DNS2

echo "Создание резервной копии текущих настроек..."
nmcli connection show "$CONNECTION_NAME" > "/tmp/network_backup_$(date +%Y%m%d_%H%M%S).txt"

echo "Настройка нового соединения..."
# Удаляем старое соединение, если оно существует
nmcli connection down "$CONNECTION_NAME" 2>/dev/null
nmcli connection delete "$CONNECTION_NAME" 2>/dev/null

# Создаем новое соединение
nmcli connection add \
    type ethernet \
    con-name "$CONNECTION_NAME" \
    ifname "$INTERFACE" \
    ipv4.method manual \
    ipv4.addresses "$IP_ADDRESS/$NETMASK" \
    ipv4.gateway "$GATEWAY" \
    ipv4.dns "$DNS1,$DNS2" \
    ipv4.never-default no \
    connection.autoconnect yes

# Активация соединения
echo "Активация нового соединения..."
nmcli connection up "$CONNECTION_NAME"

# Проверка настроек
echo -e "\nНовые настройки сети:"
echo "========================="
echo "Интерфейс: $INTERFACE"
echo "Соединение: $CONNECTION_NAME"
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

echo -e "\nДля проверки настроек выполните:"
echo "nmcli connection show $CONNECTION_NAME"
echo "ip addr show $INTERFACE"
echo "ip route show"
echo "nmcli device show $INTERFACE | grep IP4"

echo -e "\nДля восстановления предыдущих настроек используйте резервную копию в /tmp/network_backup_*.txt" 
