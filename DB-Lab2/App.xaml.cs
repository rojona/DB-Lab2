using System.Configuration;
using System.Data;
using System.IO;
using System.Windows;
using Microsoft.Extensions.Configuration;

namespace DB_Lab2;

/// <summary>
/// Interaction logic for App.xaml
/// </summary>
public partial class App : Application
{
    protected override void OnStartup(StartupEventArgs e)
    {
        base.OnStartup(e);
        
        var builder = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
            .AddUserSecrets<App>();

        IConfiguration configuration = builder.Build();
        
        var mainWindow = new MainWindow(configuration);
        mainWindow.Show();
    }
}