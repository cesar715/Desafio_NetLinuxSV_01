#!/bin/bash
# Plantilla de apoyo para red. No modifica Netplan automaticamente.
# Autor: NetLinuxSV

set -u

echo '=== Interfaces ==='
ip -br link

echo
echo '=== Direcciones ==='
ip -br addr

echo
echo '=== Rutas ==='
ip route

echo
echo 'Edite el YAML de /etc/netplan y despues ejecute:'
echo '  sudo netplan try'
echo '  sudo netplan apply'
