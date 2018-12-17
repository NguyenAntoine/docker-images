FROM mysql:5.7
LABEL maintainer="Antoine NGUYEN"

ENV LANG='fr_FR.UTF-8' \
    LANGUAGE='fr_FR.fr' \
    LC_ALL='fr_FR.UTF-8' \
    TZ='Europe/Paris'

COPY etc/* /etc/mysql/conf.d/
COPY wait-for-it/wait-for-it.sh /usr/local/bin

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
 && apt-get update && apt-get install -y \
    dos2unix \
    curl \
    wget \
    vim \
    nano \
 && rm -rf /var/lib/apt/lists/* \
 && chmod a-w etc/mysql/conf.d/* \
 && chmod +x /usr/local/bin/wait-for-it.sh