using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;
using DB_Lab2.Models;

namespace DB_Lab2;

public partial class BookDialog : Window
{
    private readonly BookstoreContext _context;
    private readonly Book _book;
    private readonly bool _isEdit;
    public List<Language> LanguageList { get; set; }
    
    public BookDialog(BookstoreContext context, Book book = null)
    {
        InitializeComponent();

        try
        {
            _context = context;
            _isEdit = book != null;

            if (_isEdit)
            {
                MessageBox.Show($"Editing book {book.Title}", "Book Edit", MessageBoxButton.OK, MessageBoxImage.Information);
                _book = new Book
                {
                    ISBN13 = book.ISBN13,
                    Title = book.Title,
                    Language = book.Language,
                    Author = book.Author,
                    Price = book.Price,
                    Publication_Date = book.Publication_Date,
                    Author_ID = book.Author_ID
                };
            }
        
            else
                _book = new Book();
        
            LanguageList = _context.Languages.ToList();
            AuthorComboBox.ItemsSource = _context.Authors.ToList();

            if (_isEdit)
            {
                AuthorComboBox.SelectedItem = AuthorComboBox.Items.Cast<Author>()
                    .FirstOrDefault(a => a.ID == _book.Author_ID);
                LanguageComboBox.SelectedItem = LanguageList
                    .FirstOrDefault(l => l.LanguageName == _book.Language);
            }

            ISBN13.DataContext = _book;
            Title.DataContext = _book;
            Price.DataContext = _book;
            DatePicker.DataContext = _book;
            AuthorComboBox.DataContext = _book;
            LanguageComboBox.DataContext = this;
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }

    private void SaveButton_Click(object sender, RoutedEventArgs e)
    {
        try
        {
            if (_context == null)
                throw new Exception("Database connection is missing");
            
            if (_book == null)
                throw new Exception("Book object is not initialized");
            
            if (string.IsNullOrEmpty(_book.ISBN13) || _book.ISBN13.Length != 13 || !IsValidISBN(_book.ISBN13))
                throw new Exception("Invalid ISBN - must be 13 digits");
           
            if (string.IsNullOrEmpty(_book.Title))
                throw new Exception("Title is required");
            
            if (string.IsNullOrEmpty(_book.Language))
                throw new Exception("Language is required"); 
            
            if (_book.Author == null)
                throw new Exception("Author is required");
            
            if (_book.Price <= 0)
                throw new Exception("Price must be greater than 0");

            if (_isEdit)
            {
                var existingBook = _context.Books.Find(_book.ISBN13);
                if (existingBook != null)
                {
                    _context.Entry(existingBook).CurrentValues.SetValues(_book);
                }
            }
            else
            {
                _context.Books.Add(_book);
            }
               
            _context.SaveChanges();
            
            DialogResult = true;

            if (Owner is MainWindow mainWindow)
                mainWindow.RefreshBooks();
            else
                MessageBox.Show("RefreshBooks as Owner failed.");
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Error saving book: {ex.Message}\n\nDetails: {ex.InnerException?.Message}");
        }
    }
    
    private void LanguageComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if (LanguageComboBox.SelectedItem is Language selectedLanguage)
        {
            _book.Language = selectedLanguage.LanguageName;
        }
    }
    
    private bool IsValidISBN(string isbn)
    {
        return isbn.All(char.IsDigit);
    }
}