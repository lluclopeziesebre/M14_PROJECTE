# Utilizar Python 3.11-slim como imagen base
FROM python:3.11-slim

# Configurar modo no interactivo para evitar prompts
ENV DEBIAN_FRONTEND=noninteractive

# Establecer el directorio de trabajo
WORKDIR /app

# Instalar dependencias mínimas necesarias
RUN apt-get update && apt-get install -y \
    git whois sublist3r exiftool dnsrecon iproute2 nmap whatweb instaloader xvfb python3-pip net-tools samba smbclient ssh-audit nmap ldap-utils python3-tk \
    xorg && apt-get clean

# Copiar los archivos del proyecto al contenedor
COPY . /app/

# Clonar enum4linux y theHarvester
RUN git clone https://github.com/portcullislabs/enum4linux.git /app/enum4linux
RUN git clone https://github.com/s0md3v/Photon.git /app/Photon

RUN rm -rf /app/theHarvester && git clone https://github.com/laramies/theHarvester.git /app/theHarvester

# Instalar dependencias de Python
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r /app/requirements.txt

RUN pip install --no-cache-dir -r /app/Photon/requirements.txt || echo "No s'han trobat requirements.txt en Photon"

RUN pip install --no-cache-dir -r /app/theHarvester/requirements.txt || echo "No s'han trobat requirements.txt en theHarvester"

# Comando para iniciar Xvfb y luego ejecutar el script
CMD ["bash", "-c", "Xvfb :99 -screen 0 1280x1024x24 & export DISPLAY=:99 && python3 /app/script3.py"]
