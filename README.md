# Скрипты настройки сети для Ubuntu и RHEL

Эти скрипты предназначены для автоматизации процесса настройки сети на серверах Ubuntu и RHEL. Они позволяют быстро настроить статический IP-адрес, маску сети, шлюз и DNS-серверы.

## Особенности

- Автоматическое определение основного сетевого интерфейса
- Интерактивный ввод сетевых параметров
- Создание резервных копий конфигурационных файлов
- Проверка подключения после настройки
- Подробный вывод новых настроек

## Требования

### Для Ubuntu:
- Ubuntu 24.04 или новее
- Права root
- Установленный netplan

### Для RHEL:
- RHEL 9.5 или новее
- Права root
- NetworkManager

## Использование

1. Сделайте скрипты исполняемыми:
```bash
chmod +x netconfig-ubuntu.sh
chmod +x netconfig-rhel.sh
```

2. Запустите соответствующий скрипт:

Для Ubuntu:
```bash
sudo ./netconfig-ubuntu.sh
```

Для RHEL:
```bash
sudo ./netconfig-rhel.sh
```

3. Следуйте инструкциям и введите запрашиваемые параметры:
- IP-адрес хоста
- Маску сети (в формате CIDR)
- Адрес шлюза
- Первичный DNS-сервер
- Вторичный DNS-сервер

## Расположение конфигурационных файлов

### Ubuntu:
- Основной файл конфигурации: `/etc/netplan/01-netcfg.yaml`
- Резервная копия: `/etc/netplan/01-netcfg.yaml.backup`

### RHEL:
- Основной файл конфигурации: `/etc/sysconfig/network-scripts/ifcfg-[INTERFACE]`
- Резервная копия: `/etc/sysconfig/network-scripts/ifcfg-[INTERFACE].backup`
- DNS настройки: `/etc/resolv.conf`

## Проверка настроек

После выполнения скрипта вы можете проверить настройки следующими командами:

```bash
ip addr show
ip route show
```

Для проверки DNS:
- Ubuntu: `systemd-resolve --status`
- RHEL: `cat /etc/resolv.conf`

## Восстановление из резервной копии

В случае проблем вы можете восстановить предыдущие настройки из резервной копии:

Для Ubuntu:
```bash
sudo cp /etc/netplan/01-netcfg.yaml.backup /etc/netplan/01-netcfg.yaml
sudo netplan apply
```

Для RHEL:
```bash
sudo cp /etc/sysconfig/network-scripts/ifcfg-[INTERFACE].backup /etc/sysconfig/network-scripts/ifcfg-[INTERFACE]
sudo systemctl restart NetworkManager
```

## Безопасность

- Скрипты требуют прав root
- Создаются резервные копии всех изменяемых файлов
- Проверка подключения после применения настроек

## Поддержка

При возникновении проблем:
1. Проверьте правильность введенных параметров
2. Убедитесь, что у вас есть права root
3. Проверьте логи системы: `journalctl -xe`
4. При необходимости восстановите настройки из резервной копии 
