using System.Windows;
using System.Windows.Controls;
using DB_Lab2.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace DB_Lab2;

/// <summary>
/// Interaction logic for MainWindow.xaml
/// </summary>
public partial class MainWindow : Window
{
    private readonly BookstoreContext _context;

    public MainWindow(IConfiguration configuration)
    {
        try
        {
            InitializeComponent();
            _context = new BookstoreContext(configuration);
            LoadData();
            RefreshBooks();
            RefreshAuthors();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Detailed error: {ex.ToString()}\n\nInner exception: {ex.InnerException?.Message}");
        }
    }

    private void LoadData()
    {
        StoreSelector.ItemsSource = _context.Stores.ToList();
        StoreSelector.SelectionChanged += StoreSelector_SelectionChanged;
    }

    private void StoreSelector_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if (StoreSelector.SelectedItem is Store selectedStore)
        {
            var inventory = _context.InventoryBalance
                .Include(ib => ib.Book)
                .Where(ib => ib.Store_ID == selectedStore.ID)
                .ToList();
            InventoryGrid.ItemsSource = inventory;
        }
    }
    
    private void AddBookBtn_Click(object sender, RoutedEventArgs e)
    {
        var dialog = new BookDialog(_context);
        dialog.Owner = this;
        if (dialog.ShowDialog() == true)
            RefreshBooks();
    }

    private void EditBookBtn_Click(object sender, RoutedEventArgs e)
    {
        if (BooksGrid.SelectedItem is Book selectedBook)
        {
            try
            {
                var bookToEdit = _context.Books
                    .Include(b => b.Author)
                    .FirstOrDefault(b => b.ISBN13 == selectedBook.ISBN13);

                if (bookToEdit != null)
                {
                    _context.Entry(bookToEdit).State = EntityState.Detached;
                    var dialog = new BookDialog(_context, bookToEdit);
                    dialog.Owner = this;
                    if (dialog.ShowDialog() == true)
                    {
                        RefreshBooks();
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error editing book: {ex.Message}");
            }
        }
    }
    
    private void DeleteBookBtn_Click(object sender, RoutedEventArgs e)
    {
        if (BooksGrid.SelectedItem is Book book)
        {
            if (MessageBox.Show("Are you sure?", "Confirm Delete", MessageBoxButton.YesNo) == MessageBoxResult.Yes)
            {
                HandleDatabaseOperation(() =>
                {
                    _context.Books.Remove(book);
                    _context.SaveChanges();
                    RefreshBooks();
                }, "Failed to delete book");
            }
        }
    }

    public void RefreshBooks()
    {
        BooksGrid.ItemsSource = _context.Books
            .Include(b => b.Author)
            .ToList();
    }
    
    private void AddAuthorBtn_Click(object sender, RoutedEventArgs e)
    {
        var dialog = new AuthorDialog(_context);
        if (dialog.ShowDialog() == true)
            RefreshAuthors();
    }

    private void EditAuthorBtn_Click(object sender, RoutedEventArgs e)
    {
        if (AuthorsGrid.SelectedItem is Author author)
        {
            var dialog = new AuthorDialog(_context, author);
            if (dialog.ShowDialog() == true)
                RefreshAuthors();
        }
    }

    private void DeleteAuthorBtn_Click(object sender, RoutedEventArgs e)
    {
        if (AuthorsGrid.SelectedItem is Author author)
        {
            if (MessageBox.Show("Are you sure?", "Confirm Delete", MessageBoxButton.YesNo) == MessageBoxResult.Yes)
            {
                HandleDatabaseOperation(() =>
                {
                    var hasBooks = _context.Books.Any(b => b.Author_ID == author.ID);
                    if (hasBooks)
                        throw new Exception("Cannot delete author with existing books");
                
                    _context.Authors.Remove(author);
                    _context.SaveChanges();
                    RefreshAuthors();
                }, "Failed to delete author");
            }
        }
    }

    private void RefreshAuthors()
    {
        AuthorsGrid.ItemsSource = _context.Authors.ToList();
    }

    private void AddInventoryBtn_Click(object sender, RoutedEventArgs e)
    {
        if (StoreSelector.SelectedItem is Store store)
        {
            var dialog = new InventoryDialog(_context, store);
            if (dialog.ShowDialog() == true)
                RefreshInventory(store);
        }
    }

    private void DeleteInventoryBtn_Click(object sender, RoutedEventArgs e)
    {
        if (InventoryGrid.SelectedItem is InventoryBalance inventory)
        {
            if (MessageBox.Show("Delete this book from inventory?", "Confirm", MessageBoxButton.YesNo) == MessageBoxResult.Yes)
            {
                HandleDatabaseOperation(() =>
                {
                    _context.InventoryBalance.Remove(inventory);
                    _context.SaveChanges();
                    RefreshInventory((Store)StoreSelector.SelectedItem);
                }, "Failed to remove book from inventory");
            }
        }
    }

    private void RefreshInventory(Store store)
    {
        var inventory = _context.InventoryBalance
            .Include(ib => ib.Book)
            .Where(ib => ib.Store_ID == store.ID)
            .ToList();
        InventoryGrid.ItemsSource = inventory;
    }
    
    private void BookSearchBox_TextChanged(object sender, TextChangedEventArgs e)
    {
        var search = BookSearchBox.Text.ToLower();
        BooksGrid.ItemsSource = _context.Books
            .Include(b => b.Author)
            .Where(b => b.Title.ToLower().Contains(search) || 
                        b.Author.First_Name.ToLower().Contains(search) ||
                        b.Author.Last_Name.ToLower().Contains(search))
            .ToList();
    }

    private void AuthorSearchBox_TextChanged(object sender, TextChangedEventArgs e)
    {
        var search = AuthorSearchBox.Text.ToLower();
        AuthorsGrid.ItemsSource = _context.Authors
            .Where(a => a.First_Name.ToLower().Contains(search) || 
                        a.Last_Name.ToLower().Contains(search))
            .ToList();
    }
    
    private void HandleDatabaseOperation(Action operation, string errorMessage)
    {
        try
        {
            operation();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"{errorMessage}: {ex.Message}", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }


}