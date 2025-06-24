FROM oven/bun:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends git openjdk-17-jre-headless && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

WORKDIR /app

# What version are you interested in? --> 225 = May 18, 2004 // 244 = June 28, 2004
# If you change versions, you will need to rebuild this cleanly / with nocache
RUN git clone https://github.com/LostCityRS/Engine-TS engine -b 225 && \
    git clone https://github.com/LostCityRS/Content content -b 225 && \
    git clone https://github.com/LostCityRS/Client-TS webclient -b 225 && \
    git clone https://github.com/LostCityRS/Client-Java javaclient -b 225

WORKDIR /app/engine

ENV HUSKY=0

RUN bun install

EXPOSE 43594 8888

# Requires that tools/server/setup.ts (sudo docker compose run --rm lostcity bun run tools/server/setup.ts) has already been run once to configure the world.
CMD ["bun", "run", "src/app.ts"]