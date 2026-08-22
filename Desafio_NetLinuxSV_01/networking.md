# Configuración de Red - VirtualBox y Netplan

**Autor:** Ryan Axel Benítez Campos (BC181438)

## 1. Problema

Las máquinas virtuales utilizan NAT por defecto. NAT es útil para dar acceso a Internet rápidamente, pero crea una red virtual separada. Esto dificulta que las máquinas virtuales se comuniquen de forma directa con otros equipos y recursos de la red corporativa.

Para un entorno de desarrollo colaborativo, necesitamos que las máquinas virtuales puedan comunicarse entre ellas y con los recursos autorizados de la red.

## 2. Comparación de modos de VirtualBox

| Modo | Característica principal | Uso típico |
|---|---|---|
| NAT | La VM sale a Internet a través del equipo anfitrión. | Navegación y pruebas sencillas. |
| Puente (Bridged) | La VM se conecta a la misma red física que el anfitrión. | Laboratorios y servidores que deben ser visibles en la LAN. |
| Red Interna | Solo comunica VMs conectadas a la misma red interna de VirtualBox. | Laboratorios aislados sin acceso directo a la LAN. |

## 3. Propuesta

Se propone usar **Adaptador puente (Bridged Adapter)** para la red de desarrollo, siempre que la política de la organización permita que las VMs participen en la LAN.

### Razón

La VM obtiene conectividad dentro de la red local y puede comunicarse con otros recursos autorizados. Esto es más apropiado que NAT para un laboratorio que necesita interacción con otros servicios de la empresa.

## 4. Configuración en VirtualBox

1. Apagar la máquina virtual.
2. Abrir **Configuración > Red**.
3. Seleccionar **Adaptador 1**.
4. Marcar **Habilitar adaptador de red**.
5. En **Conectado a**, seleccionar **Adaptador puente**.
6. Seleccionar la interfaz física usada por el equipo anfitrión (Ethernet o Wi-Fi).
7. Iniciar la máquina virtual.

## 5. Identificar la interfaz en Ubuntu

```bash
ip link
```

Ejemplo de interfaz:

```text
enp0s3
```

La interfaz real puede tener otro nombre.

## 6. Configuración de IP estática con Netplan

Identificar el archivo Netplan:

```bash
ls /etc/netplan/
```

Editar el archivo correspondiente:

```bash
sudo nano /etc/netplan/01-network-manager-all.yaml
```

Ejemplo:

```yaml
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: no
      addresses:
        - 192.168.1.50/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
```

> Cambiar `enp0s3`, la IP, la puerta de enlace y los DNS según la red real de InnovaCloud Solutions. No copiar estos valores literalmente a producción sin validarlos.

## 7. Aplicar la configuración

Primero validar:

```bash
sudo netplan try
```

Si todo funciona, aplicar:

```bash
sudo netplan apply
```

## 8. Verificación

Comprobar la IP:

```bash
ip addr show enp0s3
```

Comprobar la ruta:

```bash
ip route
```

Comprobar conectividad con el gateway:

```bash
ping -c 4 192.168.1.1
```

Comprobar conectividad por nombre:

```bash
ping -c 4 google.com
```

## 9. Resultado esperado

Las máquinas virtuales tendrán una dirección IP estática dentro de la red de desarrollo y podrán comunicarse con los recursos autorizados de InnovaCloud Solutions sin depender de la traducción NAT.
