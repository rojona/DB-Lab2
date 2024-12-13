namespace DB_Lab2.Models;
using Microsoft.EntityFrameworkCore;

public class BookstoreContext : DbContext
{
    public DbSet<Author> Authors { get; set; }
    public DbSet<Language> Languages { get; set; }
    public DbSet<Book> Books { get; set; }
    public DbSet<Store> Stores { get; set; }
    public DbSet<InventoryBalance> InventoryBalance { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer(@"Server=DESKTOP-HS0U309;Database='Robin Andersson''s Book Shop';Trusted_Connection=True;TrustServerCertificate=True;");
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<InventoryBalance>()
            .HasKey(ib => new { ib.Store_ID, ib.ISBN13 });
           
        modelBuilder.Entity<Book>()
            .HasKey(b => b.ISBN13);
           
        modelBuilder.Entity<Book>()
            .HasOne(b => b.Author)
            .WithMany(a => a.Books)
            .HasForeignKey(b => b.Author_ID);

        modelBuilder.Entity<InventoryBalance>()
            .HasOne(ib => ib.Book)
            .WithMany(b => b.Inventory)
            .HasForeignKey(ib => ib.ISBN13);

        modelBuilder.Entity<InventoryBalance>()
            .HasOne(ib => ib.Store)
            .WithMany(s => s.Inventory)
            .HasForeignKey(ib => ib.Store_ID);
    }
}