# dotnet-angular-experiment

A minimal app designed to be a clean base for experimenting with .NET and Angular.

- .NET 10 Web API
- Angular (frontend - to be added)
- C#

## Quickstart (new contributors)

Prerequisites:

- .NET SDK 10+ (install via `brew install --cask dotnet-sdk` on macOS)
- Node.js 20+ and npm (for Angular frontend)

### Quick Start (Recommended)

Use the provided startup script:

```bash
# Start backend only (default)
./start.sh

# Or explicitly specify backend
./start.sh backend

# When frontend is ready, start both in separate terminals
./start.sh all
```

The API will be available at:
- HTTPS: `https://localhost:7055`
- HTTP: `http://localhost:5119`

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

You can test the endpoints using curl or any HTTP client:

**Health Check:**
```bash
curl http://localhost:5000/api/health
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
curl -X POST http://localhost:5000/api/echo \
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

## Structure

### Backend (.NET Web API)

```
backend/
├── Controllers/
│   ├── EchoController.cs    # POST /api/echo - Echoes back JSON with timestamp
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

**CORS Configuration:**
- Configured to allow requests from `http://localhost:4200` (Angular default dev port)
- Allows all headers and methods for development

### Frontend (Angular - Coming Soon)

The Angular frontend will be added in the `frontend/` directory.

## Scripts

### Startup Script

From the project root:

- `./start.sh` or `./start.sh backend` — Start the backend server
- `./start.sh frontend` — Start the frontend server (when available)
- `./start.sh all` — Start both backend and frontend in separate terminals
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

## Next Steps

- [ ] Set up Angular frontend
- [ ] Add authentication/authorization
- [ ] Add database integration (Entity Framework Core)
- [ ] Add logging and monitoring
- [ ] Add unit and integration tests
- [ ] Add Docker support
