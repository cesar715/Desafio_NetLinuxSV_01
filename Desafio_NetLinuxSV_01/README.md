# Desafío - NetLinuxSV - 01

## Consultoría de infraestructura para InnovaCloud Solutions

**Asignatura:** Admin. e Impl. Serv. de Red con Sistemas Operativos Libres (ASI104 G01T)  
**Ciclo:** 02/2026  
**Fecha:** 22/08/2026

## Equipo consultor

| Integrante | Carné | Rol |
|---|---|---|
| Cesar Israel Amaya Carias | AC232575 | Líder de proyecto y responsable de almacenamiento |
| Ryan Axel Benítez Campos | BC181438 | Responsable de redes, paquetes y diagnóstico |

> **Nombre de la firma consultora:** NetLinuxSV

## 1. Resumen ejecutivo

InnovaCloud Solutions presenta cuatro problemas principales: falta de redundancia en el almacenamiento, instalación manual de software, uso de NAT en VirtualBox para la red de desarrollo y ausencia de un procedimiento estándar de diagnóstico.

La propuesta de NetLinuxSV es implementar una solución basada en Linux que sea fácil de administrar y que reduzca el riesgo de pérdida de información y de errores de configuración.

### Soluciones propuestas

- **Almacenamiento:** RAID 1 con `mdadm` para mantener una copia exacta de los datos en dos discos. Si un disco falla, el servicio puede continuar con el disco restante.
- **Gestión de paquetes:** repositorio espejo local mediante `apt-mirror` y un servidor web interno. Los servidores descargan los paquetes desde la red local en lugar de repetir las descargas desde Internet.
- **Red de desarrollo:** modo **Adaptador puente (Bridged Adapter)** en VirtualBox, para que las máquinas virtuales participen en la misma red que los demás recursos autorizados. Se usará Netplan para definir una IP estática.
- **Diagnóstico:** procedimiento estándar usando `ip`, `ping`, `ss`, `systemctl`, `ip route`, `resolvectl` y otras herramientas de consola.

## 2. Estructura del repositorio

```text
Desafio_NetLinuxSV_01/
├── README.md
├── storage.md
├── packages.md
├── networking.md
├── diagnostics.md
├── scripts/
│   ├── diagnostics.sh
│   ├── raid_setup.sh
│   └── network_config.sh
└── evidence/
```

## 3. Archivos de la solución

- [storage.md](storage.md) - Redundancia y RAID 1.
- [packages.md](packages.md) - Repositorio espejo local con APT.
- [networking.md](networking.md) - VirtualBox, modo puente y Netplan.
- [diagnostics.md](diagnostics.md) - Procedimiento de verificación y diagnóstico.

## 4. Beneficios para InnovaCloud Solutions

La propuesta busca:

1. Disminuir el impacto de una falla de disco.
2. Reducir tráfico innecesario hacia Internet.
3. Mantener versiones de paquetes más consistentes entre servidores.
4. Facilitar la comunicación entre las máquinas virtuales de desarrollo y los recursos autorizados de la empresa.
5. Estandarizar la revisión de red y servicios.

## 5. Consideraciones importantes

RAID **no reemplaza un respaldo (backup)**. RAID 1 protege principalmente ante la falla de un disco, pero no protege contra eliminación accidental, corrupción lógica, ransomware o errores humanos.

Las pruebas deben realizarse primero en un entorno de laboratorio y después trasladarse a producción mediante una ventana de mantenimiento planificada.

## 6. Autores

### Cesar Israel Amaya Carias
Responsable de análisis de almacenamiento, propuesta RAID 1 y coordinación general.

### Ryan Axel Benítez Campos
Responsable de red, gestión de paquetes, diagnóstico y verificación técnica.
