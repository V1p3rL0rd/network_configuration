#!/bin/bash

# Проверка прав root
if [[ $EUID -ne 0 ]]; then
    echo "Этот скрипт должен быть запущен с правами root" 
    exit 1
fi

# Запрос параметров у пользователя
read -p "Введите имя сетевого интерфейса (например, enp0s3): " INTERFACE
read -p "Введите IP-адрес (например, 192.168.1.100): " IP
read -p "Введите маску подсети (например, 24 или 255.255.255.0): " MASK
read -p "Введите адрес шлюза (например, 192.168.1.1): " GATEWAY
read -p "Введите первичный DNS-сервер (например, 8.8.8.8): " DNS1
read -p "Введите вторичный DNS-сервер (например, 8.8.4.4): " DNS2

# Проверка существования интерфейса
if ! ip link show dev "$INTERFACE" &> /dev/null; then
    echo "Ошибка: Интерфейс $INTERFACE не существует"
    exit 1
fi

# Функция для конвертации маски подсети в префикс
mask_to_prefix() {
    local mask=$1
    if [[ $mask =~ ^[0-9]{1,2}$ ]]; then
        echo "$mask"
        return
    fi
    
    local prefix=0
    local octets=( ${mask//./ } )
    for octet in "${octets[@]}"; do
        case $octet in
            255) ((prefix += 8)) ;;
            254) ((prefix += 7)) ;;
            252) ((prefix += 6)) ;;
            248) ((prefix += 5)) ;;
            240) ((prefix += 4)) ;;
            224) ((prefix += 3)) ;;
            192) ((prefix += 2)) ;;
            128) ((prefix += 1)) ;;
            0)   ;;
            *)    echo "Ошибка: Неверная маска подсети $mask" >&2; exit 1 ;;
        esac
    done
    echo "$prefix"
}

PREFIX=$(mask_to_prefix "$MASK") || exit 1

# Настройка сети с помощью netplan
echo "Настройка сети для Ubuntu..."

# Создание конфигурационного файла netplan
NETPLAN_FILE="/etc/netplan/99-custom.yaml"
cat > "$NETPLAN_FILE" << EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      addresses: [$IP/$PREFIX]
      routes:
        - to: default
          via: $GATEWAY
      nameservers:
        addresses: [$DNS1, $DNS2]
EOF

# Применение конфигурации
netplan apply

echo "Настройка сети успешно завершена!" 
