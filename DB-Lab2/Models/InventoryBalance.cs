using System.ComponentModel.DataAnnotations.Schema;

namespace DB_Lab2.Models;

[Table("Inventory Balance")]
public class InventoryBalance
{
    [Column("Store ID")] public int Store_ID { get; set; }
    public string ISBN13 { get; set; }
    public int Quantity { get; set; }
    public virtual Store Store { get; set; }
    public virtual Book Book { get; set; }
}