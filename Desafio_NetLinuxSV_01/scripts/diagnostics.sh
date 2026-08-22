#!/bin/bash
# Diagnóstico básico para InnovaCloud Solutions
# Autor: NetLinuxSV

set -u

echo '=== INTERFACES Y DIRECCIONES ==='
ip -br addr

echo
echo '=== RUTAS ==='
ip route

echo
echo '=== DNS ==='
resolvectl status 2>/dev/null | head -n 40 || true

echo
echo '=== PUERTOS ESCUCHANDO ==='
sudo ss -tulpn 2>/dev/null || ss -tulpn

echo
echo '=== SERVICIOS ACTIVOS ==='
systemctl --type=service --state=running --no-pager | head -n 40

echo
echo '=== FIN DEL DIAGNOSTICO ==='
