LostCity Docker Setup

1. Create your directory

Create a working directory for the server files.

---

2. Download or create the Dockerfile

Place the Dockerfile inside your project directory.

This is where you set the revision version (e.g., 225 or 244) by editing the -b flags in the git clone lines.

---

3. Build the Docker container

sudo docker compose build

Optional (clean rebuild):

sudo docker compose build --no-cache

To clear build cache manually:

sudo docker builder prune -f

---

4. Run the world setup script (interactive)

sudo docker compose run --rm lostcity bun run tools/server/setup.ts

---

5. Launch the game server

sudo docker compose up -d

Check it's running:

sudo docker ps

View logs:

sudo docker compose logs -f
