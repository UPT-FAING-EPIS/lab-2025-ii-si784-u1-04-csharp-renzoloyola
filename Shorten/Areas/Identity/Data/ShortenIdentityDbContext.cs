using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Shorten.Areas.Identity.Data;

namespace Shorten.Areas.Identity.Data;

public class ShortenIdentityDbContext : DbContext
{
    public ShortenIdentityDbContext(DbContextOptions<ShortenIdentityDbContext> options)
        : base(options)
    {
    }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);
    }
}
