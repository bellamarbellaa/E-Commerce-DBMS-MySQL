-- 1) Display the details of three most expensive items in the shop
SELECT * 
FROM Product
ORDER BY Price DESC
LIMIT 3;

-- 2) Display the details of official shops ordered by owner name in ascending pattern. 
-- Use the last character of IDShop column (Y = Official, N = Non-Official) in the WHERE clause
SELECT * 
FROM Shop
WHERE RIGHT (IDShop, 1) = 'Y'
ORDER BY Owner ASC; 

SELECT * 
FROM Shop
WHERE SUBSTRING_INDEX(IDShop, '', -1) = 'Y'
ORDER BY Owner ASC;

SELECT *
FROM Shop
WHERE SUBSTR(IDShop, 6, 1) = 'Y'
ORDER BY Owner ASC;

-- 3) Create a view named vw_CreditCardDoneTransaction that displays completed transactions using Credit Card payment.
CREATE VIEW vw_CreditCardDoneTransaction AS
SELECT *
FROM TrTransaction
WHERE PaymentMethod = 'Credit Card' 
	AND Done = 1;

SELECT * FROM vw_CreditCardDoneTransaction;

-- 4) Display the names of official shop owners in the format [ShopID + Last Name of Owner]. Use SUBSTRING_INDEX().
SELECT
	CONCAT (IDShop, ' ', SUBSTRING_INDEX(Owner, ' ', -1)) AS 'Owner Name'
FROM Shop
WHERE isOfficial = 1;

SELECT
    CONCAT(
        IDShop, ' ', SUBSTR(Owner, LOCATE(' ', Owner) + 1)
    ) AS 'Owner Name'
FROM Shop
WHERE isOfficial = 1;

-- 5) Display Product ID, Product Name, Product Stock, and Price 
-- formatted as 'Rp. ' + Price for products with stock greater than 50
SELECT
	IDProduct,
    Name,
    Stock,
    CONCAT('Rp.', Price) AS Price
FROM Product
WHERE Stock > 50;

-- 6) Display Shop ID, Shop Name formatted as shop_name + official or
-- non-official, Owner, Address for products priced greater than 100,000
-- Display distinct data only.
SELECT DISTINCT
    a.IDShop,
    CONCAT(
        a.Name,
        CASE
            WHEN isOfficial = 1 THEN ' (Official)'
            ELSE ' (Non-Official)'
        END
    ) AS Name,
    Owner,
    Address
FROM Shop a
JOIN Product b
ON a.IDShop = b.IDShop
WHERE Price > 100000; 

-- 7) Display Transaction ID, Product ID, Customer ID, Transaction Date in dd Month yyyy format, 
-- Quantity, Total Price, and Payment Method for transactions occurring in September and November.


-- 8) Display the shop name, owner name, official or non official category
-- the number of transactions using Debit payment method (Payment Count) shops.

SELECT
    s.Name AS 'Shop Name',
    s.Owner AS 'Owner Name',
    CASE
        WHEN s.isOfficial = 1 THEN 'Official'
        ELSE 'Non Official'
    END AS 'Category',
    COUNT(tr.IDTransaction)
    AS 'Payment Count'
FROM Shop s
JOIN Product p
    ON s.IDShop = p.IDShop
JOIN TrTransaction tr
    ON p.IDProduct = tr.IDProduct
WHERE tr.PaymentMethod = 'Debit'
GROUP BY
    s.Name,
    s.Owner,
    s.isOfficial;
    
-- 9) Display Customer ID, Customer Name, Phone Number, and Email for customers whose names consist of at least 3 words.
SELECT
	IDCustomer AS 'Cust ID',
    Name AS 'Customer',
    PhoneNumber AS 'Phone',
    Email AS 'Email'
FROM Customer
WHERE Name LIKE '% % %';


-- 10) Create a Stored Procedure named Search_Product that accepts a product name as a parameter and 
-- displays the shop name selling the product, Product ID, Product Name, Stock, and Price.
DELIMITER $$
CREATE PROCEDURE Search_Product (IN input VARCHAR(255))
BEGIN
	SELECT 
    s.Name AS 'Shop Name',
    p.IDProduct AS 'Product ID',
    p.Name AS 'Product Name',
    p.Stock AS 'Product Stock',
    p.Price AS 'Product Price'
    FROM Product p
    JOIN Shop s
		ON s.IDShop = p.IDShop
	WHERE p.Name = Input;
END$$

DELIMITER ;
CALL Search_Product('Mouse');

-- 11) Create a Stored Procedure named GetReviewByProductName that accepts a product name as a parameter
--  and displays the Product Name, total comments, and the average review star of the inputted product.
DELIMITER $$
CREATE PROCEDURE GetReviewByProductName (IN input VARCHAR(255)) 
BEGIN 
	SELECT 
		p.Name AS 'Product Name', 
		AVG(r.Star) AS 'Average Review Star',
		COUNT(r.Comment) AS 'Count of Comments'
	FROM Product p
    JOIN Review r
		ON p.IDProduct = r.IDProduct
	WHERE p.Name = input
    GROUP BY p.Name;
END $$

DELIMITER ;
CALL GetReviewByProductName('Fidget Box');

-- 12) Create a Stored Procedure named Search_Shop that accepts either a shop name or owner name as a 
-- parameter and displays all the shop data based on the input. Use LIKE seearch to ensure exhaustive search

DELIMITER $$ 
CREATE PROCEDURE Search_Shop (IN input VARCHAR(255)) 
BEGIN
	SELECT 
		Name as 'Shop Name',
        Owner as 'Owner Name',
        CASE
			WHEN isOfficial = 1 THEN 'Official'
			ELSE 'Not Official'
		END AS 'Category',
        Address AS 'Shop Address'
    FROM Shop 
    WHERE Name LIKE CONCAT ('%', input, '%')
		OR Owner LIKE CONCAT ('%', input, '%');
END $$
DELIMITER ;
CALL Search_Shop ('Al');
-- Searches for 'Al' anywhere inside the Shop Name and Owner Name columns using exhaustive LIKE search
-- (does not need to be exact) and only needs to be true for one of the columns for the record to be displayed

-- 13) Create a Stored Procedure named GetTotalQuantity that receive product name as a parameter and
--  that displays the product name, the shop that carries it, and the [Total Stock + Sold], where the value is the total stock added with the total quantity sold for each product.
DELIMITER $$
CREATE PROCEDURE GetTotalQuantity (IN input VARCHAR(255)) 
BEGIN 
	SELECT 
		p.Name as 'Product Name',
        p.IDProduct as 'Product ID',
        s.Name as 'Shop Name', 
        p.Stock + COALESCE(SUM(t.Quantity), 0) AS 'Total Quantity'
        -- COALESCE function is used to replace NULL value for SUM(t.Quantity) with 0 
	FROM Product p
    JOIN Shop s
		ON p.IDShop = s.IDShop
	LEFT JOIN TrtRANSACTION t
		ON p.IDProduct = t.IDProduct
	WHERE p.name = input
    GROUP BY 
		p.name,
        p.IDProduct,
        s.Name;
	END $$
DELIMITER ;
CALL GetTotalQuantity('Keyboard');
-- LEFT JOIN is only used for joining transaction table and not the shop table
-- because without LEFT JOIN, products with no transactions will be discounted,
-- but every product must belong to a shop so normal JOIN is used for shop table

-- 14)  Create a Stored Procedure named CountProductInCustomerCart that accepts a product name as a parameter and 
-- displays the product name and [Count Customer], which is the number of customers who saved the product in their cart.
DELIMITER $$
CREATE PROCEDURE CountProductInCustomerCart (IN input VARCHAR(255)) 
BEGIN
	SELECT 
		p.Name as 'Product Name', 
        COALESCE(COUNT(c.IDCustomer), 0) AS 'Count Customer' -- counts customers but if NULL is changed into 0
	FROM Product p
    LEFT JOIN Cart c -- LEFT JOIN keeps product even if no customer has added it to a curt
		ON p.IDProduct = c.IDProduct
	WHERE p.Name = input
    GROUP BY 
		p.Name;
END $$

DELIMITER ;
CALL CountProductInCustomerCart('Lego');

-- To view products that have entries in Cart table (so exist in customers' carts): 
SELECT
    p.IDProduct,
    p.Name,
    c.IDCustomer

FROM Product p
LEFT JOIN Cart c
    ON p.IDProduct = c.IDProduct;
    
    
-- 15) Create a Stored Procedure named CalculateCustomerPoint that accepts a customer name as a parameter 
-- using a LIKE search and calculates customer points based on total spending with the following conditions:
-- Condition 1: Total spending < Rp. 10,000 → 0 points
-- Condition 2: Rp. 10,000 – Rp. 50,000→ 20 points
-- Condition 3: Rp. 50,000 – Rp. 100,000 → 50 points
-- Condition 4: ≥ Rp. 100,000 → 100 points

DELIMITER $$
CREATE PROCEDURE CalculateCustomerPoint(
    IN input VARCHAR(255)
)
BEGIN
    DECLARE Total_Spending BIGINT;
    SET Total_Spending = (
        SELECT
            SUM(TotalPrice)
        FROM TrTransaction tr
        JOIN Customer c
            ON tr.IDCustomer = c.IDCustomer
        WHERE c.Name LIKE CONCAT('%', input, '%')
        GROUP BY tr.IDCustomer
    );

    SELECT
        c.IDCustomer AS 'Customer ID',
        c.Name AS 'Customer Name',
        CASE
            WHEN Total_Spending < 10000
                 OR Total_Spending IS NULL
            THEN 0
            WHEN Total_Spending >= 10000
                 AND Total_Spending < 50000
            THEN 20
            WHEN Total_Spending >= 50000
                 AND Total_Spending < 100000
            THEN 50
            ELSE 100
        END AS Point
    FROM Customer c
    WHERE c.Name LIKE CONCAT('%', input, '%');
END$$

DELIMITER ;
CALL CalculateCustomerPoint('Ja');

DROP PROCEDURE CalculateCustomerPoint;
-- -- DECLARE is used to create the Total_Spending variable, while SET is used to store the query result 
-- inside the variable because Total_Spending temporarily stores the customer's total spending
-- LIKE CONCAT('%', input, '%') is used to search customer names containing the input value anywhere 
-- inside the text, which means the input does not need to match the customer name exactly
