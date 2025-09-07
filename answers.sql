-- Database Design and Normalization Assignment
-- Author: Student
-- Date: 2024

-- ========================================
-- Question 1: Achieving 1NF (First Normal Form)
-- ========================================

-- Original table ProductDetail violates 1NF because the Products column contains multiple values
-- We need to separate each product into its own row

-- Create the normalized table in 1NF
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    PRIMARY KEY (OrderID, Product)
);

-- Insert the normalized data
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');

-- Query to display the 1NF table
SELECT * FROM ProductDetail_1NF
ORDER BY OrderID, Product;

-- ========================================
-- Question 2: Achieving 2NF (Second Normal Form)
-- ========================================

-- The OrderDetails table has partial dependency: CustomerName depends only on OrderID
-- (not on the full composite key OrderID + Product)
-- To achieve 2NF, we need to separate this into two tables

-- Create Orders table (contains OrderID and CustomerName)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Create OrderItems table (contains OrderID, Product, and Quantity)
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert data into Orders table
INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Insert data into OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- Query to display the 2NF tables
-- Show Orders table
SELECT * FROM Orders
ORDER BY OrderID;

-- Show OrderItems table
SELECT * FROM OrderItems
ORDER BY OrderID, Product;

-- Query to join both tables and recreate the original view (if needed)
SELECT o.OrderID, o.CustomerName, oi.Product, oi.Quantity
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
ORDER BY o.OrderID, oi.Product;

-- ========================================
-- Summary of Normalization Process
-- ========================================

/*
Question 1 - 1NF Transformation:
- Problem: Products column contained multiple values (Laptop, Mouse)
- Solution: Split each product into separate rows
- Result: Each row now represents a single product for an order

Question 2 - 2NF Transformation:
- Problem: CustomerName had partial dependency on OrderID only
- Solution: Split into two tables:
  * Orders table: OrderID (PK) -> CustomerName
  * OrderItems table: (OrderID, Product) (Composite PK) -> Quantity
- Result: All non-key attributes now fully depend on the entire primary key
*/