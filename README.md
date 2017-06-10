Ubuntu personalizado para la Universidad de Costa Rica
=================================

Este proyecto toma como base la úlitma versión LTS de Ubuntu y lo configura de manera que incluya herramientas de uso común en la Universidad de Costa Rica.

Todas las modificaciones se han escrito en un script bash para poder recrear la personalización fácilmente, tanto en una instalación en limpio como para generar un ISO para la distribución.

Se toma como base Ubuntu por las siguientes razones:

- Ubuntu es un sistema GNU/Linux muy popular, con mucha documentación y mucho soporte.
- Fuerte enfoce en el usuario final.
- Al tener una versión de soporte extendido, ofrece mucha estabilidad.

Criterios para la personalización
---------------------------

- Se incluye únicamente software estable, no en desarrollo, no experimental
- Las modificaciones al entorno de escritorio son mínimas, después de todo existe un equipo enfocado en experiencia de usuario (UX) detrás de su desarrollo, con criterios suficientes para diseñar el entorno de esa manera.
- No intenta parecerse a ningún otro sistema, si no que ofrece las innovadoras características de los entornos libres.
- Se modifica el aspecto gráfico para mostrar una alternativa atractiva pero sin sacrificar la usabilidad del sistema. Todo tema o set de íconos debe ser de fácil visualización, sin que confunda al usuario.
- Se enfoca en el usuario final o en los usuarios que inician en GNU/Linux. Los usuarios avanzados sabrán buscar distribuciones alternativas, instalar sus herramientas o personalizar los entornos de escritorio a su manera.
- Los entornos a utilizar son: Gnome-shell, el próximo entorno predeterminado de Ubuntu y MATE, ideal para equipos antiguos.

Capturas de pantalla
---------------------------
![Ubuntu Gnome 16.04 UCR](https://raw.githubusercontent.com/leojimenezcr/ubuntu-ucr/master/screenshot-1.png)

![Ubuntu Gnome 16.04 UCR](https://raw.githubusercontent.com/leojimenezcr/ubuntu-ucr/master/screenshot-2.png)

![Ubuntu Gnome 16.04 UCR](https://raw.githubusercontent.com/leojimenezcr/ubuntu-ucr/master/screenshot-3.png)

![Ubuntu Gnome 16.04 UCR](https://raw.githubusercontent.com/leojimenezcr/ubuntu-ucr/master/screenshot-4.png)

¿Cómo ejecutar el script?
---------------------------

1. Realice una instalación en limpio de Ubuntu 16.04 LTS
2. Conéctese a Internet
3. Descargue el proyecto: `wget https://github.com/leojimenezcr/ubuntu-ucr/archive/master.zip`
4. Descomprima: `unzip master.zip`
5. Ingrese al directorio: `cd ubuntu-ucr-master`
6. De permisos de ejecución al script: `chmod +x ubuntu-16.04-ucr-config.sh`
7. Ejecútelo: `./ubuntu-16.04-ucr-config.sh`


Comunidad de Software Libre de la Universidad de Costa Rica

http://softwarelibre.ucr.ac.cr
