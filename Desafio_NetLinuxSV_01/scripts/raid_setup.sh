#!/bin/bash
# EJEMPLO EDUCATIVO - NO EJECUTAR EN PRODUCCION SIN VALIDAR DISCOS
# Autor: NetLinuxSV

set -e

echo 'Discos disponibles:'
lsblk

echo
echo 'Instalando mdadm...'
sudo apt update
sudo apt install mdadm -y

echo
echo 'IMPORTANTE: este script supone que /dev/sdb y /dev/sdc son discos vacios.'
read -r -p 'Escribe CONFIRMAR para continuar: ' CONFIRM

if [[ "$CONFIRM" != 'CONFIRMAR' ]]; then
  echo 'Operacion cancelada.'
  exit 1
fi

sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u
sudo mkfs.ext4 /dev/md0
sudo mkdir -p /srv/datos
sudo mount /dev/md0 /srv/datos

echo
echo 'RAID creado. Verificar con:'
cat /proc/mdstat
sudo mdadm --detail /dev/md0
