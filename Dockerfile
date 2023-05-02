FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libcurl4-openssl-dev \
    libssl-dev \
    lib32gcc-s1 \
    lib32stdc++6 \
    lib32z1 \
    python3 \
    curl \
	pip

RUN pip install youtube-dl

RUN mkdir /app
WORKDIR /app

RUN wget https://www.byond.com/download/build/514/514.1589_byond_linux.zip
RUN unzip 514.1589_byond_linux.zip -d /usr/local
RUN rm 514.1589_byond_linux.zip

RUN wget https://github.com/yogstation13/Yogstation/archive/refs/heads/master.zip
RUN unzip master.zip -d /app
RUN rm master.zip

COPY . /app/Yogstation-master/

RUN LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/byond/bin /usr/local/byond/bin/DreamMaker -max_errors 0 /app/Yogstation-master/yogstation.dme

RUN echo "#!/bin/sh" > dock.sh \
	&& echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/byond/bin /usr/local/byond/bin/DreamDaemon /app/Yogstation-master/yogstation.dmb -port 1337 -invisible -trusted -verbose 2>&1 | tee -a log" >> dock.sh \
    && chmod +x ./dock.sh

EXPOSE 1337
VOLUME [ "/app/Yogstation-master/data", "/app/Yogstation-master/config"]
ENTRYPOINT [ "./dock.sh" ]
