using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

namespace backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class EchoController : ControllerBase
{
    /// <summary>
    /// Echo endpoint that returns the received JSON body with a timestamp
    /// </summary>
    /// <param name="body">The JSON body to echo back</param>
    /// <returns>The received body with timestamp</returns>
    [HttpPost]
    public IActionResult Post([FromBody] JsonElement body)
    {
        try
        {
            return Ok(new
            {
                received = body,
                at = DateTime.UtcNow.ToString("o")
            });
        }
        catch (Exception)
        {
            return BadRequest(new { error = "Invalid JSON" });
        }
    }
}
