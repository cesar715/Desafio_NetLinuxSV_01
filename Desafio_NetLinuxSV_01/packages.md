# Gestión de Paquetes - Repositorio Espejo Local

**Autor:** Ryan Axel Benítez Campos (BC181438)

## 1. Problema

Actualmente los paquetes se instalan de forma manual. Esto provoca varios problemas:

- Cada servidor puede terminar con versiones diferentes.
- Se repiten descargas desde Internet.
- Se consume ancho de banda innecesariamente.
- Aumenta el tiempo de instalación y actualización.
- Es más difícil mantener una configuración consistente.

## 2. Solución propuesta

Se propone utilizar un **repositorio espejo local (local mirror)** para paquetes APT.

La idea es tener un servidor interno que descargue los paquetes desde los repositorios oficiales y que los demás equipos de la empresa los obtengan desde la red local.

### Beneficios

**Eficiencia:** la descarga principal desde Internet se realiza en el servidor espejo y los clientes reutilizan esos archivos por la LAN.

**Consistencia:** varios equipos pueden trabajar contra la misma fuente de paquetes.

**Ancho de banda:** se reducen descargas repetidas hacia Internet.

**Administración:** se centraliza la fuente de paquetes utilizada por los clientes.

## 3. Instalar apt-mirror y un servidor web

En el servidor que funcionará como espejo:

```bash
sudo apt update
sudo apt install apt-mirror nginx -y
```

## 4. Configurar apt-mirror

Editar:

```bash
sudo nano /etc/apt/mirror.list
```

Ejemplo de configuración para Ubuntu:

```text
set base_path    /var/spool/apt-mirror
set mirror_path  $base_path/mirror
set skel_path    $base_path/skel
set var_path     $base_path/var
set cleanscript  $var_path/clean.sh
set defaultarch  amd64
set nthreads     10
set _tilde 0

deb http://archive.ubuntu.com/ubuntu noble main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu noble-security main restricted universe multiverse

clean http://archive.ubuntu.com/ubuntu
```

> El repositorio debe coincidir con la versión de Ubuntu utilizada por los servidores cliente. El ejemplo usa Ubuntu 24.04 LTS (noble).

## 5. Descargar el espejo

Ejecutar:

```bash
sudo apt-mirror
```

El proceso descargará los paquetes al almacenamiento local definido en `mirror.list`.

## 6. Publicar el espejo por HTTP

Para que los clientes puedan acceder al contenido, Nginx puede publicar el directorio del espejo.

Crear un bloque de servidor, por ejemplo:

```bash
sudo nano /etc/nginx/sites-available/apt-mirror
```

Contenido de ejemplo:

```nginx
server {
    listen 80;
    server_name apt-mirror.innovacloud.local;

    root /var/spool/apt-mirror/mirror;
    autoindex on;
}
```

Activar la configuración:

```bash
sudo ln -s /etc/nginx/sites-available/apt-mirror /etc/nginx/sites-enabled/apt-mirror
sudo nginx -t
sudo systemctl restart nginx
```

## 7. Configurar los clientes APT

En un cliente, guardar el repositorio local en un archivo dentro de `/etc/apt/sources.list.d/`.

Ejemplo:

```bash
sudo nano /etc/apt/sources.list.d/innovacloud.list
```

Contenido de ejemplo:

```text
deb http://apt-mirror.innovacloud.local/ubuntu/ noble main restricted universe multiverse
deb http://apt-mirror.innovacloud.local/ubuntu/ noble-updates main restricted universe multiverse
deb http://apt-mirror.innovacloud.local/ubuntu/ noble-security main restricted universe multiverse
```

Actualizar la información de paquetes:

```bash
sudo apt update
```

Instalar normalmente:

```bash
sudo apt install curl -y
```

## 8. Operación recomendada

El servidor espejo debe ejecutar `apt-mirror` de forma programada, por ejemplo mediante cron o un temporizador de systemd, para mantener actualizados los repositorios.

## 9. Resultado esperado

Los clientes de InnovaCloud Solutions podrán descargar paquetes desde el servidor interno. Esto disminuye el uso de Internet, facilita la administración y permite una fuente de paquetes más controlada.
