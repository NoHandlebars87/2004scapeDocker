FROM oven/bun:latest

# What version are you interested in? --> 225 = May 18, 2004 // 244 = June 28, 2004
# If you change versions, you will need to rebuild this cleanly / with nocache
ARG REV=225

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    openjdk-17-jre-headless \
    python3 \
    make \
    g++ \
    curl \
    && ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

WORKDIR /app

RUN git clone https://github.com/LostCityRS/Engine-TS engine -b ${REV} && \
    git clone https://github.com/LostCityRS/Content content -b ${REV} && \
    git clone https://github.com/LostCityRS/Client-TS webclient -b ${REV} && \
    git clone https://github.com/LostCityRS/Client-Java javaclient -b ${REV}

RUN if [ "$REV" != "225" ]; then \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    cd /app/webclient && \
    bun install && \
    bun run build && \
    mkdir -p /app/engine/public/client && \
    cp out/client.js out/deps.js /app/engine/public/client/ && \
    if [ -f rs2.cgi ]; then cp rs2.cgi /app/engine/public/; \
    elif [ -f out/rs2.cgi ]; then cp out/rs2.cgi /app/engine/public/; fi; \
fi


WORKDIR /app/engine
ENV HUSKY=0
RUN bun install

EXPOSE 43594 8888

CMD ["bun", "run", "src/app.ts"]
