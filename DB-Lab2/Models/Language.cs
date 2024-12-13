using System.ComponentModel.DataAnnotations.Schema;

namespace DB_Lab2.Models;

public class Language
{
    public int ID { get; set; }
    [Column("Language")]
    public string LanguageName { get; set; }
}