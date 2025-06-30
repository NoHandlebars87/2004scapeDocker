FROM oven/bun:latest

# What version are you interested in? example - 225 = May 18, 2004 // 244 = June 28, 2004
# If you change versions, you will need to rebuild this cleanly / with nocache
ARG REV=225

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        gnupg \
        ca-certificates \
        git \
        openjdk-17-jre-headless \
        python3 \
        make \
        g++ && \
    curl -fsSL https://ftp-master.debian.org/keys/archive-key-12.asc | \
        gpg --dearmor -o /etc/apt/trusted.gpg.d/debian-archive-keyring.gpg && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/LostCityRS/Engine-TS engine -b ${REV} && \
    git clone https://github.com/LostCityRS/Content content -b ${REV} && \
    git clone https://github.com/LostCityRS/Client-TS webclient -b ${REV} && \
    git clone https://github.com/LostCityRS/Client-Java javaclient -b ${REV}


WORKDIR /app/engine
ENV HUSKY=0
RUN bun install

EXPOSE 43594 8888

CMD ["bun", "run", "src/app.ts"]
