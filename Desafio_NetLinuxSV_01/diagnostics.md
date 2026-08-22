# Verificación y Diagnóstico de Red y Servicios

**Autor:** Ryan Axel Benítez Campos (BC181438)

## 1. Problema

La empresa no cuenta con un procedimiento estandarizado para revisar servicios, interfaces y conectividad.

Sin un procedimiento fijo, cada administrador puede utilizar métodos diferentes y se tarda más en encontrar la causa de una falla.

## 2. Procedimiento estándar

La revisión propuesta se divide en cinco etapas:

1. Revisar interfaces y direcciones IP.
2. Revisar rutas y DNS.
3. Probar conectividad.
4. Revisar puertos abiertos.
5. Revisar servicios activos.

## 3. Verificar interfaces

```bash
ip addr
```

Ver las interfaces de forma resumida:

```bash
ip -br addr
```

Verificar si una interfaz está activa:

```bash
ip link show
```

## 4. Verificar rutas

```bash
ip route
```

La salida debe mostrar una ruta por defecto si el servidor necesita comunicarse fuera de su subred.

## 5. Verificar DNS

Con `resolvectl`:

```bash
resolvectl status
```

Probar resolución de nombre:

```bash
resolvectl query google.com
```

## 6. Verificar conectividad de extremo a extremo

Primero probar el gateway:

```bash
ping -c 4 192.168.1.1
```

Después probar otro equipo del segmento:

```bash
ping -c 4 192.168.1.20
```

Finalmente probar un dominio:

```bash
ping -c 4 google.com
```

### Interpretación sencilla

- Si falla el gateway: puede existir un problema de interfaz, cableado, VLAN o configuración IP.
- Si funciona el gateway pero falla otro host: revisar el host destino, firewall o rutas.
- Si funciona la red por IP pero falla por nombre: revisar DNS.

## 7. Revisar puertos abiertos

Instalar `ss` normalmente no es necesario porque forma parte de las herramientas de red modernas del sistema.

```bash
sudo ss -tulpn
```

Para revisar un puerto concreto, por ejemplo 22:

```bash
sudo ss -ltnp | grep ':22'
```

## 8. Auditar servicios activos

Ver servicios en ejecución:

```bash
systemctl --type=service --state=running
```

Ver el estado de un servicio concreto:

```bash
systemctl status ssh
```

Comprobar si está habilitado para iniciar con el sistema:

```bash
systemctl is-enabled ssh
```

## 9. Revisar procesos

```bash
ps aux --sort=-%cpu | head
```

También se puede usar:

```bash
top
```

## 10. Verificar firewall

Si se usa UFW:

```bash
sudo ufw status verbose
```

## 11. Procedimiento rápido de diagnóstico

```bash
ip -br addr
ip route
resolvectl status
ping -c 4 192.168.1.1
ping -c 4 google.com
sudo ss -tulpn
systemctl --type=service --state=running
```

## 12. Resultado esperado

Este procedimiento permite que los administradores sigan los mismos pasos ante una incidencia, reduciendo el tiempo de diagnóstico y facilitando la documentación del problema.
