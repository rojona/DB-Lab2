using System.Windows;
using DB_Lab2.Models;
using Microsoft.EntityFrameworkCore;

namespace DB_Lab2;

public partial class InventoryDialog : Window
{
    private readonly BookstoreContext _context;
    private readonly Store _store;

    public InventoryDialog(BookstoreContext context, Store store)
    {
        InitializeComponent();
        _context = context;
        _store = store;
        BookComboBox.ItemsSource = _context.Books
            .Include(b => b.Author)
            .ToList();
    }

    private void SaveButton_Click(object sender, RoutedEventArgs e)
    {
        try
        {
            if (BookComboBox.SelectedItem is not Book book)
                throw new Exception("Book selection is required");

            if (!int.TryParse(QuantityTextBox.Text, out int quantity) || quantity < 0)
                throw new Exception("Invalid quantity");

            var inventory = _context.InventoryBalance
                                .FirstOrDefault(ib => 
                                    ib.Store_ID == _store.ID && 
                                    ib.ISBN13 == book.ISBN13) 
                            ?? new InventoryBalance 
                            {
                                Store_ID = _store.ID,
                                ISBN13 = book.ISBN13
                            };

            inventory.Quantity = quantity;

            if (!_context.InventoryBalance.Contains(inventory))
                _context.InventoryBalance.Add(inventory);

            _context.SaveChanges();
            DialogResult = true;
        }
        catch (Exception ex)
        {
            MessageBox.Show(ex.Message, "Validation Error", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }
}