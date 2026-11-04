-- 1. ЕСЛИ ТАБЛИЦЫ СУЩЕСТВУЮТ — УДАЛЯЕМ ИХ, ЧТОБЫ СОЗДАТЬ ЗАНОВО
IF OBJECT_ID('OrderItems', 'U') IS NOT NULL DROP TABLE OrderItems;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;
IF OBJECT_ID('BookCategories', 'U') IS NOT NULL DROP TABLE BookCategories;
IF OBJECT_ID('Books', 'U') IS NOT NULL DROP TABLE Books;
IF OBJECT_ID('Categories', 'U') IS NOT NULL DROP TABLE Categories;
IF OBJECT_ID('Authors', 'U') IS NOT NULL DROP TABLE Authors;
GO

-- 2. СОЗДАНИЕ ТАБЛИЦ СХЕМЫ (3NF)
CREATE TABLE Authors (
    AuthorID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50)
);

CREATE TABLE Categories (
    CategoryID INT IDENTITY PRIMARY KEY,
    CategoryName NVARCHAR(100)
);

CREATE TABLE Books (
    BookID INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(255),
    AuthorID INT FOREIGN KEY REFERENCES Authors(AuthorID),
    Price DECIMAL(10, 2),
    StockQuantity INT
);

CREATE TABLE BookCategories (
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    PRIMARY KEY (BookID, CategoryID) -- Тут всё исправлено на CategoryID
);

CREATE TABLE Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATETIME,
    Status NVARCHAR(20)
);

CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    Quantity INT,
    PriceAtPurchase DECIMAL(10, 2)
);
GO

-- 3. ЗАПОЛНЕНИЕ ДАННЫМИ
INSERT INTO Authors (FirstName, LastName) VALUES (N'Лев', N'Толстой'), (N'Федор', N'Достоевский'), (N'Джордж', N'Оруэлл'), (N'Стивен', N'Кинг');
INSERT INTO Categories (CategoryName) VALUES (N'Классика'), (N'Фантастика'), (N'Ужасы'), (N'Философия');

INSERT INTO Books (Title, AuthorID, Price, StockQuantity) VALUES 
(N'Война и мир', 1, 1200, 15), (N'Преступление и наказание', 2, 650, 25),
(N'Идиот', 2, 700, 10), (N'1984', 3, 550, 40),
(N'Оно', 4, 890, 8), (N'Сияние', 4, 750, 12);

INSERT INTO BookCategories (BookID, CategoryID) VALUES (1, 1), (1, 4), (2, 1), (3, 1), (4, 2), (5, 3), (6, 3);

INSERT INTO Customers (FirstName, LastName, Email) VALUES 
(N'Иван', N'Иванов', 'ivan@mail.ru'), (N'Петр', N'Петров', 'petr@mail.ru'),
(N'Анна', N'Сидорова', 'anna@mail.ru'), (N'Елена', N'Смирнова', 'elena@mail.ru'),
(N'Алексей', N'Козлов', 'alex@mail.ru');

INSERT INTO Orders (CustomerID, OrderDate, Status) VALUES 
(1, '20260301', N'Доставлен'), (1, '20260310', N'Оплачен'), (2, '20260302', N'Доставлен'), (3, '20260305', N'Доставлен'),
(4, '20260312', N'Новый'), (5, '20260314', N'Новый'), (2, '20260315', N'Оплачен'), (3, '20260316', N'Отменен');

INSERT INTO OrderItems (OrderID, BookID, Quantity, PriceAtPurchase) VALUES 
(1, 1, 1, 1200), (2, 2, 1, 650), (2, 3, 2, 700), (3, 4, 3, 550),
(4, 1, 1, 1200), (4, 5, 1, 890), (5, 4, 1, 550), (6, 2, 2, 650);
GO

-- 4. СКРИПТЫ ЗАДАНИЙ 1 и 2
-- Задание 1 (Индексы)
CREATE INDEX IX_Books_Price ON Books(Price);
CREATE INDEX IX_Orders_OrderDate ON Orders(OrderDate);
CREATE INDEX IX_Customers_LastName ON Customers(LastName);
GO

-- Задание 2 (Конструкция IF-ELSE)
DECLARE @BookID INT = 4;
DECLARE @Нужно INT = 5;
DECLARE @Остаток INT;

SELECT @Остаток = StockQuantity FROM Books WHERE BookID = @BookID;

IF @Остаток >= @Нужно
    PRINT N'Книг хватает, можно оформлять заказ.';
ELSE
    PRINT N'Ошибка! На складе мало книг.';
GO
