USE [master]
GO
/****** Object:  Database [Robin Andersson's Book Shop]    Script Date: 2024-12-13 13:31:38 ******/
CREATE DATABASE [Robin Andersson's Book Shop]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Bokhandel', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Bokhandel.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Bokhandel_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Bokhandel_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Robin Andersson's Book Shop].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET ARITHABORT OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET RECOVERY FULL 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET  MULTI_USER 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Robin Andersson''s Book Shop', N'ON'
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET QUERY_STORE = OFF
GO
USE [Robin Andersson's Book Shop]
GO
/****** Object:  Table [dbo].[Authors]    Script Date: 2024-12-13 13:31:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Authors](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[First Name] [nvarchar](50) NOT NULL,
	[Last Name] [nvarchar](50) NOT NULL,
	[Birth Date] [date] NULL,
 CONSTRAINT [PK_Författare] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Books]    Script Date: 2024-12-13 13:31:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Books](
	[ISBN13] [char](13) NOT NULL,
	[Title] [nvarchar](100) NOT NULL,
	[Language] [nvarchar](50) NOT NULL,
	[Price] [decimal](10, 2) NOT NULL,
	[Publication Date] [date] NOT NULL,
	[Author ID] [int] NOT NULL,
 CONSTRAINT [PK_Books] PRIMARY KEY CLUSTERED 
(
	[ISBN13] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inventory Balance]    Script Date: 2024-12-13 13:31:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inventory Balance](
	[Store ID] [int] NOT NULL,
	[ISBN13] [char](13) NOT NULL,
	[Quantity] [int] NOT NULL,
 CONSTRAINT [PK_Inventory Balance] PRIMARY KEY CLUSTERED 
(
	[Store ID] ASC,
	[ISBN13] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[TitlesPerAuthor]    Script Date: 2024-12-13 13:31:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TitlesPerAuthor] AS
SELECT 
   CONCAT(a.[First Name], ' ', a.[Last Name]) as Name,
   CAST(DATEDIFF(YEAR, a.[Birth Date], GETDATE()) AS VARCHAR) + ' years' as Age,
   COUNT(DISTINCT b.ISBN13) AS Titles,
   SUM(b.Price * ib.Quantity) AS StockValue
FROM 
   Authors a
   LEFT JOIN Books b ON a.ID = b.[Author ID]
   LEFT JOIN [Inventory Balance] ib ON b.ISBN13 = ib.ISBN13
GROUP BY 
   a.[First Name], 
   a.[Last Name], 
   a.[Birth Date];
GO
/****** Object:  Table [dbo].[Stores]    Script Date: 2024-12-13 13:31:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stores](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Store Name] [nvarchar](50) NOT NULL,
	[Street Address] [nvarchar](100) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[Postal Code] [nvarchar](10) NOT NULL,
	[Phone Number] [nvarchar](20) NOT NULL,
	[E-Mail] [nvarchar](100) NOT NULL,
	[Manager] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Stores] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Genres IDs]    Script Date: 2024-12-13 13:31:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genres IDs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Genre] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](100) NULL,
 CONSTRAINT [PK_Genre IDs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Genres]    Script Date: 2024-12-13 13:31:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genres](
	[ISBN13] [char](13) NOT NULL,
	[Genre ID] [int] NOT NULL,
 CONSTRAINT [PK_Genres] PRIMARY KEY CLUSTERED 
(
	[ISBN13] ASC,
	[Genre ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reviews]    Script Date: 2024-12-13 13:31:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reviews](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ISBN13] [char](13) NOT NULL,
	[Rating] [int] NOT NULL,
	[ReviewDate] [date] NOT NULL,
 CONSTRAINT [PK_Reviews] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[CompleteBookView]    Script Date: 2024-12-13 13:31:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CompleteBookView] AS
SELECT 
    b.ISBN13,
    b.Title,
    b.[Language],
    b.Price,
    b.[Publication Date],
    CONCAT(a.[First Name], ' ', a.[Last Name]) as Author,
    gid.Genre,
    gid.Description as [Genre Description],
    s.[Store Name],
    s.City,
    ib.Quantity as [Stock],
    (b.Price * ib.Quantity) as [Stock Value],
    r.Rating as [Average Rating],
    r.ReviewDate as [Latest Review]
FROM 
    Books b
    LEFT JOIN Authors a ON b.[Author ID] = a.ID
    LEFT JOIN Genres g ON b.ISBN13 = g.ISBN13
    LEFT JOIN [Genres IDs] gid ON g.[Genre ID] = gid.ID
    LEFT JOIN [Inventory Balance] ib ON b.ISBN13 = ib.ISBN13
    LEFT JOIN Stores s ON ib.[Store ID] = s.ID
    LEFT JOIN Reviews r ON b.ISBN13 = r.ISBN13;
GO
/****** Object:  Table [dbo].[Languages]    Script Date: 2024-12-13 13:31:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Languages](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Language] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reviews] ADD  DEFAULT (getdate()) FOR [ReviewDate]
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD  CONSTRAINT [FK_Books_Author] FOREIGN KEY([Author ID])
REFERENCES [dbo].[Authors] ([ID])
GO
ALTER TABLE [dbo].[Books] CHECK CONSTRAINT [FK_Books_Author]
GO
ALTER TABLE [dbo].[Genres]  WITH CHECK ADD  CONSTRAINT [FK_Genres_Books] FOREIGN KEY([ISBN13])
REFERENCES [dbo].[Books] ([ISBN13])
GO
ALTER TABLE [dbo].[Genres] CHECK CONSTRAINT [FK_Genres_Books]
GO
ALTER TABLE [dbo].[Genres]  WITH CHECK ADD  CONSTRAINT [FK_Genres_GenreIDs] FOREIGN KEY([Genre ID])
REFERENCES [dbo].[Genres IDs] ([ID])
GO
ALTER TABLE [dbo].[Genres] CHECK CONSTRAINT [FK_Genres_GenreIDs]
GO
ALTER TABLE [dbo].[Inventory Balance]  WITH CHECK ADD  CONSTRAINT [FK_Inventory Balance_Books] FOREIGN KEY([ISBN13])
REFERENCES [dbo].[Books] ([ISBN13])
GO
ALTER TABLE [dbo].[Inventory Balance] CHECK CONSTRAINT [FK_Inventory Balance_Books]
GO
ALTER TABLE [dbo].[Inventory Balance]  WITH CHECK ADD  CONSTRAINT [FK_Inventory Balance_Stores] FOREIGN KEY([Store ID])
REFERENCES [dbo].[Stores] ([ID])
GO
ALTER TABLE [dbo].[Inventory Balance] CHECK CONSTRAINT [FK_Inventory Balance_Stores]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [FK_Reviews_Books] FOREIGN KEY([ISBN13])
REFERENCES [dbo].[Books] ([ISBN13])
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [FK_Reviews_Books]
GO
ALTER TABLE [dbo].[Books]  WITH CHECK ADD  CONSTRAINT [CHK_ISBN13] CHECK  ((NOT [ISBN13] like '%[^0-9]%' AND len([ISBN13])=(13)))
GO
ALTER TABLE [dbo].[Books] CHECK CONSTRAINT [CHK_ISBN13]
GO
ALTER TABLE [dbo].[Inventory Balance]  WITH CHECK ADD  CONSTRAINT [CHK_Quantity] CHECK  (([Quantity]>=(0)))
GO
ALTER TABLE [dbo].[Inventory Balance] CHECK CONSTRAINT [CHK_Quantity]
GO
ALTER TABLE [dbo].[Reviews]  WITH CHECK ADD  CONSTRAINT [CHK_Rating] CHECK  (([Rating]>=(1) AND [Rating]<=(5)))
GO
ALTER TABLE [dbo].[Reviews] CHECK CONSTRAINT [CHK_Rating]
GO
USE [master]
GO
ALTER DATABASE [Robin Andersson's Book Shop] SET  READ_WRITE 
GO
