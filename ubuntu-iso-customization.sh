#!/bin/bash

# se espera al menos una variable
if [[ $# < 1 ]]
then
  echo "Modo de empleo: $0 IMAGEN.ISO [DESTINO]

Donde:
  IMAGEN.ISO es la ruta al archivo ISO original
  DESTINO es la ruta en dónde se copiará el ISO personalizado. Si no se indica un destino, se guardará en el directorio actual.

Toma una imagen de Ubuntu, la personaliza de acuerdo al script de configuración y genera el archivo ISO personalizado para ser distribuido."

  exit 1
fi

## VARIABLES
# ruta al archivo ISO original
ISOPATH=$1

# ruta en donde se copiara el ISO personalizado
if [[ -n $2 ]]
then
  WORKINGDIR=$2
# si no se indica un destino, se guardara en el directorio actual
else
  SCRIPTPATH=$(readlink -f $0)
  WORKINGDIR=$(dirname "$SCRIPTPATH")
fi

# nombre del archivo ISO original
ISONAME=$(basename "$ISOPATH")
# nombre del archivo ISO personalizado, de la forma nombre-original-ucr-yyyymmdd.iso
CUSTOMISONAME="${ISONAME%.*}-ucr-`date +%Y%m%d`.iso"
