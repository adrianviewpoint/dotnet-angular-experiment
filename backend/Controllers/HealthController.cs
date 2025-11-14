using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class HealthController : ControllerBase
{
    /// <summary>
    /// Health check endpoint
    /// </summary>
    /// <returns>Health status with timestamp</returns>
    [HttpGet]
    public IActionResult Get()
    {
        return Ok(new
        {
            ok = true,
            status = "healthy",
            timestamp = DateTime.UtcNow.ToString("o")
        });
    }
}
