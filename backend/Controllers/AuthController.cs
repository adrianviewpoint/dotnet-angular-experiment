using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using System.Threading.Tasks;

namespace backend.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly UserManager<IdentityUser> _userManager;
    private readonly SignInManager<IdentityUser> _signInManager;

    public AuthController(UserManager<IdentityUser> userManager, SignInManager<IdentityUser> signInManager)
    {
        _userManager = userManager;
        _signInManager = signInManager;
    }

    [HttpPost("signup")]
    public async Task<IActionResult> Signup([FromBody] SignupRequest req)
    {
        var user = new IdentityUser { UserName = req.Email, Email = req.Email };
        var result = await _userManager.CreateAsync(user, req.Password);
        if (!result.Succeeded)
            return BadRequest(result.Errors);
        await _signInManager.SignInAsync(user, isPersistent: false);
        return Ok(new { message = "Signup successful" });
    }

    [HttpPost("signin")]
    public async Task<IActionResult> Signin([FromBody] SigninRequest req)
    {
        var result = await _signInManager.PasswordSignInAsync(req.Email, req.Password, isPersistent: false, lockoutOnFailure: false);
        if (!result.Succeeded)
            return Unauthorized(new { message = "Invalid credentials" });
        return Ok(new { message = "Signin successful" });
    }

    [HttpPost("signout")]
    public async Task<IActionResult> Signout()
    {
        await _signInManager.SignOutAsync();
        return Ok(new { message = "Signed out" });
    }

    [HttpGet("session")]
    public IActionResult Session()
    {
        if (User.Identity?.IsAuthenticated == true)
            return Ok(new { authenticated = true, user = User.Identity.Name });
        return Ok(new { authenticated = false });
    }
}

public class SignupRequest
{
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}

public class SigninRequest
{
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}
