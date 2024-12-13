using System.ComponentModel.DataAnnotations.Schema;

namespace DB_Lab2.Models;
using System.Collections.Generic;

public class Author
{
    public int ID { get; set; }
    [Column("First Name")] public string First_Name { get; set; }
    [Column("Last Name")] public string Last_Name { get; set; }
    [Column("Birth Date")] public DateTime Birth_Date { get; set; }
    public virtual ICollection<Book> Books { get; set; }
}