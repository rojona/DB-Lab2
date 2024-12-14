### DB-Lab2
### Robin Andersson .Net24 GBG
---

## Setup
1. Klona projektet
2. Kör det medföljande database_setup.sql skriptet i SQL Server Management Studio för att skapa och populera databasen
3. Högerklicka på projektet i Solution Explorer och välj "Manage User Secrets"
4. Lägg till följande i secrets.json och uppdatera connection string med din egen server:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR-SERVER;Database='Robin Andersson''s Book Shop';Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

----

![image](https://github.com/user-attachments/assets/ceb789f7-0593-406a-b692-c1a98751da6c)
