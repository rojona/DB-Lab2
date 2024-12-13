using System.ComponentModel.DataAnnotations.Schema;

namespace DB_Lab2.Models;

public class Book
{
    public string ISBN13 { get; set; }
    public string Title { get; set; }
    public string Language { get; set; }
    public decimal Price { get; set; }
    [Column("Publication Date")] public DateTime Publication_Date { get; set; }
    [Column("Author ID")] public int Author_ID { get; set; }
    public virtual Author Author { get; set; }
    public virtual ICollection<InventoryBalance> Inventory { get; set; }
}