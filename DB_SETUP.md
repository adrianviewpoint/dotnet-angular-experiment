# Database Setup (PostgreSQL)

This project uses PostgreSQL for backend data storage. The recommended way to run the database locally is via Docker Compose.

## Quickstart

1. Start the PostgreSQL database:

   ```bash
   docker-compose up -d db
   ```
   This will start a local PostgreSQL instance with the following credentials:
   - Host: localhost
   - Port: 5432
   - Database: angularexperiment
   - Username: dev
   - Password: dev

2. Update the backend connection string if needed in `backend/appsettings.Development.json` and `backend/appsettings.json`.

3. Run Entity Framework Core migrations (to be added) to set up the database schema.

4. Start the backend:
   ```bash
   ./start.sh backend
   ```

## Troubleshooting
- If you see connection errors, ensure the database container is running and accessible on port 5432.
- You may need to install Docker if you haven't already: https://docs.docker.com/get-docker/
