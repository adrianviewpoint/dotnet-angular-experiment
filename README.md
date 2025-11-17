# dotnet-angular-experiment

A minimal app designed to be a clean base for experimenting with .NET and Angular.

- .NET 10 Web API (ASP.NET Core Identity + EF Core + PostgreSQL)
- Angular 20 frontend (standalone components)
- C#

## Quickstart (new contributors)

Prerequisites:

- .NET SDK 10+ (install via `brew install --cask dotnet-sdk` on macOS)
- Node.js 20+ and npm (for Angular frontend)

### Quick Start (Recommended)

Use the provided startup script:

```bash
# Start database
./start.sh db

# Start backend only (default)
./start.sh

# Or explicitly specify backend
./start.sh backend

# Start frontend only
./start.sh frontend

# Start DB, backend and frontend in separate terminals
./start.sh all
```

The API will be available at:
- HTTPS: `https://localhost:7055`
- HTTP: `http://localhost:5119`

The Angular app runs at:
- `http://localhost:4200` (dev server)

### Manual Backend Setup

If you prefer to start manually:

1) Navigate to the backend directory
   ```bash
   cd backend
   ```

2) Restore dependencies
   ```bash
   dotnet restore
   ```

3) Trust the development certificate (first-time only)
   ```bash
   dotnet dev-certs https --trust
   ```

4) Start the backend API
   ```bash
   dotnet run
   ```

### Testing the API

You can test the endpoints using VS Code's HTTP client or curl.

Quick option (VS Code): open `backend/backend.http` and click "Send Request" on any block.

Using curl:

**Health Check:**
```bash
curl http://localhost:5119/api/health
```

Expected response:
```json
{
  "ok": true,
  "status": "healthy",
  "timestamp": "2025-11-14T12:34:56.789Z"
}
```

**Echo Endpoint:**
```bash
curl -X POST http://localhost:5119/api/echo \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello, World!", "user": "test"}'
```

Expected response:
```json
{
  "received": {
    "message": "Hello, World!",
    "user": "test"
  },
  "at": "2025-11-14T12:34:56.789Z"
}
```

## Database Setup (PostgreSQL)

This project uses PostgreSQL for backend data storage. The recommended way to run the database locally is via Docker Compose.

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

2. The backend is preconfigured to use this database. Connection strings are in `backend/appsettings.Development.json` and `backend/appsettings.json`.

3. Run Entity Framework Core migrations to set up the database schema (first time only):
   ```bash
   # optional if you don't have the tool yet
   dotnet tool install --global dotnet-ef
   
   # apply migrations
   cd backend
   dotnet ef database update
   ```

4. Start the backend:
   ```bash
   ./start.sh backend
   ```

See `DB_SETUP.md` for more details.

---

## Structure

### Backend (.NET Web API)

```
backend/
├── Controllers/
│   ├── EchoController.cs    # POST /api/echo - Echoes back JSON with timestamp
│   ├── AuthController.cs    # /api/auth/* - Signup/Signin/Signout/Session
│   └── HealthController.cs  # GET /api/health - Health check endpoint
├── Properties/
│   └── launchSettings.json  # Development server configuration
├── Program.cs               # Application entry point and configuration
├── appsettings.json        # Application settings
├── appsettings.Development.json # Development-specific settings
└── backend.csproj          # Project file with dependencies
```

**API Endpoints:**
- `GET /api/health` - Health check endpoint returning status and timestamp
- `POST /api/echo` - Echo endpoint that returns received JSON body with timestamp
- `POST /api/auth/signup` - Create user and sign in (cookie)
- `POST /api/auth/signin` - Sign in with email/password (cookie)
- `POST /api/auth/signout` - Sign out (clear cookie)
- `GET /api/auth/session` - Returns `{ authenticated: boolean, user?: string }`

**CORS Configuration:**
- Configured to allow requests from `http://localhost:4200` (Angular default dev port)
- Allows all headers and methods for development

### Frontend (Angular)

```
frontend/
├── src/app/
│   ├── home.component.ts     # Calls /api/echo and auth endpoints
│   └── home.component.html   # UI with signup/signin/signout + session display
├── proxy.conf.json           # Proxies /api to http://localhost:5119
└── package.json              # Scripts (npm start/build)
```

Development:
- Start: `npm start` in `frontend/` (or `./start.sh frontend` from repo root)
- The dev server runs on `http://localhost:4200`
- Requests to `/api/*` are proxied to the backend at `http://localhost:5119`

## Scripts

### Startup Script

From the project root:

- `./start.sh db` — Start the PostgreSQL database
- `./start.sh` or `./start.sh backend` — Start the backend server
- `./start.sh frontend` — Start the frontend server
- `./start.sh all` — Start DB, backend and frontend in separate terminals
- `./start.sh help` — Show help and available commands

### Backend

From the `backend/` directory:

- `dotnet run` — Start the development server
- `dotnet build` — Build the project
- `dotnet test` — Run tests (when added)
- `dotnet watch run` — Start with hot reload

## Development

### Adding New Controllers

1. Create a new controller in `backend/Controllers/`
2. Inherit from `ControllerBase`
3. Add the `[ApiController]` and `[Route("api/[controller]")]` attributes
4. Implement your endpoints with appropriate HTTP method attributes (`[HttpGet]`, `[HttpPost]`, etc.)

Example:
```csharp
using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MyController : ControllerBase
{
    [HttpGet]
    public IActionResult Get()
    {
        return Ok(new { message = "Hello from MyController!" });
    }
}
```

### CORS Configuration

CORS is configured in `Program.cs` to allow the Angular frontend to communicate with the API. The current configuration allows:
- Origin: `http://localhost:4200`
- All headers
- All HTTP methods

To modify CORS settings, edit the `AddCors` configuration in `Program.cs`.

