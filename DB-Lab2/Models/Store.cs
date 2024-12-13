using System.ComponentModel.DataAnnotations.Schema;

namespace DB_Lab2.Models;

public class Store
{
    public int ID { get; set; }
    [Column("Store Name")] public string Store_Name { get; set; }
    [Column("Street Address")] public string Street_Address { get; set; }
    public string City { get; set; }
    [Column("Postal Code")] public string Postal_Code { get; set; }
    [Column("Phone Number")] public string Phone_Number { get; set; }
    [Column("E-Mail")] public string E_Mail { get; set; }
    public string Manager { get; set; }
    public virtual ICollection<InventoryBalance> Inventory { get; set; }
}