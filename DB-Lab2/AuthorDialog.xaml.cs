using System.Windows;
using DB_Lab2.Models;

namespace DB_Lab2;

public partial class AuthorDialog : Window
{
    private readonly BookstoreContext _context;
    private readonly Author _author;
    private readonly bool _isEdit;

    public AuthorDialog(BookstoreContext context, Author author = null)
    {
        InitializeComponent();
        _context = context;
        _isEdit = author != null;
        _author = author ?? new Author();
        DataContext = _author;
    }

    private void SaveButton_Click(object sender, RoutedEventArgs e)
    {
        try
        {
            if (string.IsNullOrEmpty(_author.First_Name))
                throw new Exception("First name is required");
           
            if (string.IsNullOrEmpty(_author.Last_Name))
                throw new Exception("Last name is required");
           
            if (_author.Birth_Date > DateTime.Now)
                throw new Exception("Invalid birth date");

            if (!_isEdit)
                _context.Authors.Add(_author);
               
            _context.SaveChanges();
            DialogResult = true;
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Validation Error", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }
}