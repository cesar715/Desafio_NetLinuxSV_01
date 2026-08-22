# Solución de Almacenamiento - RAID 1

**Autor:** Cesar Israel Amaya Carias (AC232575)

## 1. Problema

El servidor principal presenta fallos de disco y no tiene redundancia. Esto significa que una falla física puede dejar inaccesible la información y afectar la continuidad del negocio.

Para InnovaCloud Solutions, el almacenamiento es crítico porque contiene información y servicios necesarios para las operaciones. La prioridad es evitar que la falla de un solo disco provoque una interrupción completa.

## 2. Solución propuesta: RAID 1

Se propone **RAID 1 (mirroring o espejo)** usando `mdadm`.

RAID 1 trabaja con dos discos y mantiene los mismos datos en ambos. Si un disco falla, el otro conserva la información y puede mantener disponible el servicio mientras se reemplaza el disco dañado.

### ¿Por qué RAID 1?

- Es sencillo de entender y administrar.
- Tolera la falla de uno de los dos discos.
- No necesita cálculos de paridad.
- Es apropiado para un servidor donde la disponibilidad de los datos es prioritaria.

### Limitación

La capacidad útil es aproximadamente la capacidad de un solo disco. Además, RAID 1 no sustituye los backups.

## 3. Verificar los discos

Antes de crear el RAID se deben identificar correctamente los dispositivos:

```bash
lsblk
sudo fdisk -l
```

> En este ejemplo se supone que los discos son `/dev/sdb` y `/dev/sdc`. **Nunca ejecutar los comandos de creación sobre discos que contengan datos importantes.**

## 4. Instalar mdadm

```bash
sudo apt update
sudo apt install mdadm -y
```

## 5. Crear el RAID 1

```bash
sudo mdadm --create --verbose /dev/md0 \
  --level=1 \
  --raid-devices=2 \
  /dev/sdb /dev/sdc
```

Comprobar el estado:

```bash
cat /proc/mdstat
sudo mdadm --detail /dev/md0
```

## 6. Crear el sistema de archivos

Ejemplo usando ext4:

```bash
sudo mkfs.ext4 /dev/md0
```

Crear el punto de montaje:

```bash
sudo mkdir -p /srv/datos
sudo mount /dev/md0 /srv/datos
```

Verificar:

```bash
df -h /srv/datos
```

## 7. Guardar la configuración del RAID

```bash
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u
```

## 8. Montaje automático

Obtener el UUID:

```bash
sudo blkid /dev/md0
```

Después se registra el UUID en `/etc/fstab`, por ejemplo:

```text
UUID=UUID_DEL_RAID  /srv/datos  ext4  defaults,nofail  0  2
```

Probar sin reiniciar:

```bash
sudo umount /srv/datos
sudo mount -a
```

## 9. Simular una falla de disco

En laboratorio se puede marcar un disco como fallido:

```bash
sudo mdadm /dev/md0 --fail /dev/sdb
sudo mdadm /dev/md0 --remove /dev/sdb
```

Verificar:

```bash
cat /proc/mdstat
sudo mdadm --detail /dev/md0
```

Para reincorporar un disco nuevo del mismo tamaño:

```bash
sudo mdadm /dev/md0 --add /dev/sdb
```

## 10. Resultado esperado

Con RAID 1, una falla de un disco no implica la pérdida inmediata de la información del arreglo. El administrador puede reemplazar el disco y permitir que `mdadm` reconstruya el espejo.

### Importante

RAID mejora la disponibilidad, pero el diseño final debe incluir también un **backup independiente**. Para producción se recomienda aplicar una política de respaldo fuera del servidor.
