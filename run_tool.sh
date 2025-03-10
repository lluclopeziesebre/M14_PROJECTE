#!/bin/bash

# Nombre del contenedor temporal (en minúsculas)
CONTAINER_NAME="temp_projecte_container"

# Nombre de la imagen (en minúsculas)
IMAGE_NAME="projectemp14_app"

# Verifica si Docker está instalado
if ! command -v docker &> /dev/null
then
    echo "Docker no está instalado. Por favor, instala Docker y vuelve a intentarlo."
    exit 1
fi

# Verifica si la variable DISPLAY está definida (necesaria para X11)
if [ -z "$DISPLAY" ]; then
    echo "La variable DISPLAY no está definida. No se puede ejecutar en modo gráfico."
    exit 1
fi

# Comprueba si la variable XAUTHORITY está definida (para autenticación en X11)
if [ -z "$XAUTHORITY" ]; then
    echo "La variable XAUTHORITY no está definida. No se puede autenticar en X11."
    exit 1
fi

# Construir la imagen Docker (nombre en minúsculas)
echo "[*] Construyendo la imagen de Docker..."
docker build -t $IMAGE_NAME .

# Ejecutar el contenedor con privilegios de red y acceso gráfico
echo "[*] Iniciando el contenedor con acceso completo a la red y X11..."
docker run --rm -it \
    --name "$CONTAINER_NAME" \
    --env DISPLAY="$DISPLAY" \
    --env XAUTHORITY="$XAUTHORITY" \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --volume "$XAUTHORITY:$XAUTHORITY" \
    --network host \
    --privileged \
    $IMAGE_NAME python3 /app/script3.py

# Comando adicional dentro del contenedor
# Ejemplo de uso de Nmap si es necesario:
# nmap -sP 192.168.1.0/24


