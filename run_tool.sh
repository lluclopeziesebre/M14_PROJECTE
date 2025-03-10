#!/bin/bash

# Nom del contenidor temporal (en minúscules)
CONTAINER_NAME="temp_projecte_container"

# Nom de la imatge (en minúscules)
IMAGE_NAME="projectemp14_app"

# Comprova si Docker està instal·lat
if ! command -v docker &> /dev/null
then
    echo "Docker no està instal·lat. Si us plau, instal·la Docker i torna-ho a provar."
    exit 1
fi

# Comprova si la variable DISPLAY està definida (necessària per a X11)
if [ -z "$DISPLAY" ]; then
    echo "La variable DISPLAY no està definida. No es pot executar en mode gràfic."
    exit 1
fi

# Comprova si la variable XAUTHORITY està definida (per a l'autenticació en X11)
if [ -z "$XAUTHORITY" ]; then
    echo "La variable XAUTHORITY no està definida. No es pot autenticar en X11."
    exit 1
fi

# Construir la imatge Docker (nom en minúscules)
echo "[*] Construint la imatge de Docker..."
docker build -t $IMAGE_NAME .

# Executar el contenidor amb privilegis de xarxa i accés gràfic
echo "[*] Iniciant el contenidor amb accés complet a la xarxa i X11..."
docker run --rm -it \
    --name "$CONTAINER_NAME" \
    --env DISPLAY="$DISPLAY" \
    --env XAUTHORITY="$XAUTHORITY" \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --volume "$XAUTHORITY:$XAUTHORITY" \
    --network host \
    --privileged \
    $IMAGE_NAME python3 /app/script3.py
