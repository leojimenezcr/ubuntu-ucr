#!/bin/bash

# Realiza una configuracion base de un sistema Ubuntu 16.04 LTS.
#
# La configuracion y programas instalados se ajustan al uso tipico de
# estudiantes, docentes y administrativos de la Unversidad de Costa Rica.
# Esta personalizacion no intenta imitar otros sistemas, si no ofrecer la
# innovadora experiencia de usuario de un entorno de escritorio libre.
#
# Escrito por la Comunidad de Software Libre de la Universidad de Costa Rica
# http://softwarelibre.ucr.ac.cr
#
# Github: https://github.com/leojimenezcr/ubuntu-ucr


# Mensaje de advertencia
echo ""
echo "Este script podría sobreescribir la configuración actual, se recomienda ejecutarlo en una instalación limpia. Si este no es un sistema recién instalado o no ha realizado un respaldo, cancele la ejecución."
echo ""
read -p "¿Desea continuar? [s/N] " -r
if [[ ! $REPLY =~ ^[SsYy]$ ]]
then
	exit
fi


# Identifica el directorio en el que se esta ejecutando
SCRIPTPATH=$(readlink -f $0)
BASEDIR=$(dirname "$SCRIPTPATH")

# Identifica la arquitectura de la computadora (x86_64, x86, ...)
arch=$(uname -m)

# En esta variable se iran concatenando los nombres de los paquetes que se
# instalaran mas adelante, de la forma:
#  packages="$packages paquete1 paquete2 paquete3"
packages=""


# Actualizaciones desatendidas
#
# Incluye las actualizaciones del sistema ademas de las de seguridad
# que se configuran de manera predeterminada.
#
#
# Nota: puede anadir origenes de terceros de la forma:
#  Unattended-Upgrade::Allowed-Origins {
#    "Origin:Suite";
#    ...
#  };
# en el archivo /etc/apt/apt.conf.d/50unattended-upgrades
#
# Consulte los valores 'Origin' y 'Suite' en los archivos *_InRelease o *_Release
# ubicados en /var/lib/apt/lists/
#
sudo sed -i \
-e 's/^\/\/."\${distro_id}:\${distro_codename}-updates";/\t"\${distro_id}:\${distro_codename}-updates";/' \
-e 's/^\/\/Unattended-Upgrade::Remove-Unused-Dependencies "false";/Unattended-Upgrade::Remove-Unused-Dependencies "true";/' \
/etc/apt/apt.conf.d/50unattended-upgrades


# Codecs, tipografias de Microsoft y Adobe Flash
#
# Se aprueba previamente la licencia de uso de las tipografias Microsoft
# utilizando la herramienta debconf-set-selections
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
packages="$packages ubuntu-restricted-extras"

# Oracle Java 8
#
# Se sustituye la version de Java por la desarrollada por Oracle.
sudo add-apt-repository -y ppa:webupd8team/java

sudo sed -i \
-e 's/Unattended-Upgrade::Allowed-Origins {/Unattended-Upgrade::Allowed-Origins {\n\t"LP-PPA-webupd8team-java:xenial";/' \
/etc/apt/apt.conf.d/50unattended-upgrades

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
packages="$packages oracle-java8-installer"

# LibreOffice 5.3
#
# Se anade el repositorio de LibreOffice para actualizar a la ultima version
# estable. Los repositorios de Ubuntu 16.04 tienen una version antigua.
sudo add-apt-repository -y ppa:libreoffice/libreoffice-5-3

sudo sed -i \
-e 's/Unattended-Upgrade::Allowed-Origins {/Unattended-Upgrade::Allowed-Origins {\n\t"LP-PPA-libreoffice-libreoffice-5-3:xenial";/' \
/etc/apt/apt.conf.d/50unattended-upgrades

packages="$packages libreoffice"

# Google Chrome o Chromium
#
# Para sistemas de 64bits se anade el repositorio de Google Chrome. Este no
# soporta sistemas de 32bis por lo que, en este caso, se instala Chromium, el
# proyecto base de Google Chrome.
if [ "$arch" == 'x86_64' ]
then
  sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 

  sudo sed -i \
  -e 's/Unattended-Upgrade::Allowed-Origins {/Unattended-Upgrade::Allowed-Origins {\n\t"Google, Inc.:stable";/' \
  /etc/apt/apt.conf.d/50unattended-upgrades

  packages="$packages google-chrome-stable"
else
  packages="$packages chromium-browser"
fi

# Dropbox
#
# Añade el repositorio de dropbox, pero no instala el paquete. Si no que
# lo deja disponible para cuando un usuario requiera utilizarlo.
sudo sh -c 'echo "deb http://linux.dropbox.com/ubuntu/ xenial main" > /etc/apt/sources.list.d/dropbox.list'
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E

sudo sed -i \
-e 's/Unattended-Upgrade::Allowed-Origins {/Unattended-Upgrade::Allowed-Origins {\n\t"Dropbox.com:wily";/' \
/etc/apt/apt.conf.d/50unattended-upgrades

#packages="$packages dropbox"

# GIMP
#
# Ultima version estable
sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp

sudo sed -i \
-e 's/Unattended-Upgrade::Allowed-Origins {/Unattended-Upgrade::Allowed-Origins {\n\t"LP-PPA-otto-kesselgulasch-gimp-edge:xenial";/' \
/etc/apt/apt.conf.d/50unattended-upgrades

packages="$packages gimp"

# Arc gtk theme
#
# Popular tema gtk que ofrece un mayor atractivo visual. Este se configura,
# una vez instalado, en la seccion de Gnome-shell.
sudo add-apt-repository -y ppa:noobslab/themes
packages="$packages arc-theme"

# Numix icon theme
#
# Conjundo de iconos visualmente atractivos y de facil lectura. El paquete
# incluye todos o casi todos los iconos utilizados. Este paquete se configura,
# una vez instalado, en la seccion de Gnome-shell.
sudo add-apt-repository -y ppa:numix/ppa

sudo sed -i \
-e 's/Unattended-Upgrade::Allowed-Origins {/Unattended-Upgrade::Allowed-Origins {\n\t"LP-PPA-noobslab-themes:xenial";/' \
/etc/apt/apt.conf.d/50unattended-upgrades

packages="$packages numix-icon-theme numix-icon-theme-circle"

# Spotify
#
# Alternativa a YouTube para escuchar musica, haciendo un uso mucho menor del
# ancho de banda.
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886

sudo sed -i \
-e 's/Unattended-Upgrade::Allowed-Origins {/Unattended-Upgrade::Allowed-Origins {\n\t"Spotify LTD:stable";/' \
/etc/apt/apt.conf.d/50unattended-upgrades

packages="$packages spotify-client"

# Paquetes varios
# - Thunderbird, al ser multiplataforma, su perfil se puede migrar facilmente
# - unattended-upgrades para actualizaciones automaticas
packages="$packages thunderbird thunderbird-locale-es unattended-upgrades"


# Actualizacion del sistema e instalacion de los paquetes indicados
sudo apt-get update
sudo apt-get -y dist-upgrade
sudo apt-get -y install $packages
sudo apt-get -y autoremove
sudo apt-get clean


# Gnome-shell
#
# El esquema, nombre y valor utilizado puede ser obtenido
# facilmente con el Editor de dconf

# Fondo de pantalla y la imagen en la pantalla de bloqueo
sudo mkdir -p /usr/share/backgrounds/ucr-gnome/
sudo cp "$BASEDIR"/ubuntu-16.04-ucr-background.jpg /usr/share/backgrounds/ucr-gnome/

# Plugins de Gnome-shell
sudo wget -O TopIcons@phocean.net.shell-extension.zip "https://extensions.gnome.org/download-extension/TopIcons@phocean.net.shell-extension.zip?version_tag=6608"
sudo unzip TopIcons@phocean.net.shell-extension.zip -d /usr/share/gnome-shell/extensions/TopIcons@phocean.net/
sudo chmod -R 755 /usr/share/gnome-shell/extensions/TopIcons@phocean.net/
sudo rm TopIcons@phocean.net.shell-extension.zip

# Copia esquema que sobrescribe configuracion de Gnome-shell y lo compila
sudo cp "$BASEDIR"/30_ucr-gnome-default-settings.gschema.override /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

# Reinicia todos los valores redefinidos en archivo override para la sesion actual
# Si no existe una sesion X11 falla y no hace nada
gsettings reset org.gnome.desktop.background picture-uri
gsettings reset org.gnome.desktop.screensaver picture-uri
gsettings reset org.gnome.desktop.input-sources sources
gsettings reset org.gnome.desktop.interface clock-format
gsettings reset org.gnome.desktop.interface clock-show-date
gsettings reset org.gnome.desktop.interface gtk-theme
gsettings reset org.gnome.desktop.interface icon-theme
gsettings reset org.gnome.desktop.wm.preferences button-layout
gsettings reset org.gnome.shell enabled-extensions
#gsettings reset org.gnome.shell.extensions.topicons icon-opacity
#gsettings reset org.gnome.shell.extensions.topicons icon-saturation
#gsettings reset org.gnome.shell.extensions.topicons tray-order
gsettings reset org.gnome.shell.extensions.user-theme name
gsettings reset org.gnome.shell favorite-apps
gsettings reset org.gnome.nautilus.preferences show-directories-first

echo "*** *** *** *** *** ***"
echo ""
echo "AVISO: Si tiene una sesión gráfica abierta, deberá reiniciarla."
echo ""
echo "*** *** *** *** *** ***"

# Desabilita apport para no mostrar molestos mensajes de fallos
sudo sed -i \
-e 's/enabled=1/enabled=0/' \
/etc/default/apport

# Terminal
#
# Se habilitan los colores del interprete de comandos para facilitar el uso
# a los usuarios mas novatos.
sudo sed -i \
-e 's/^#force_color_prompt=yes/force_color_prompt=yes/' \
/etc/skel/.bashrc

# AURI
#
# Descarga la herramienta de configuracion de AURI y Eduroam y crea el
# respectivo .desktop para que se muestre entre las apliciones.
wget --no-check-certificate -qO- https://ci.ucr.ac.cr/auri/instaladores/AURI-eduroam-UCR-Linux.tar.gz | sudo tar zx -C /opt

sudo sh -c 'echo "[Desktop Entry]
Name=Configurar AURI
Comment=Configurar red Wifi de la UCR y Eduroam
Exec=/opt/AURI-eduroam-UCR-linux.sh
Icon=network-wireless
Terminal=false
Type=Application
Categories=Settings;HardwareSettings;
Keywords=Network;Wireless;Wi-Fi;Wifi;LAN;AURI;Eduroam;Internet;Red" > /usr/share/applications/auri.desktop'

