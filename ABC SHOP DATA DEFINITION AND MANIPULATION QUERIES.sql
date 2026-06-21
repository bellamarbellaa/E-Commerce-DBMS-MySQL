DROP DATABASE ABCShop;

CREATE DATABASE ABCShop;

USE ABCShop;

CREATE TABLE Customer (
    IDCustomer INT AUTO_INCREMENT,
    Name VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20),
    Email VARCHAR(50),

    PRIMARY KEY (IDCustomer)
);

CREATE TABLE Shop (
    IDShop VARCHAR(6),
    Name VARCHAR(50) NOT NULL,
    Owner VARCHAR(50) NOT NULL,
    isOfficial BIT NOT NULL,
    Address VARCHAR(50),

    PRIMARY KEY (IDShop)
);

CREATE TABLE Product (
    IDProduct INT AUTO_INCREMENT,
    IDShop VARCHAR(6),
    Name VARCHAR(50) NOT NULL,
    Stock INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (IDProduct),

    FOREIGN KEY (IDShop)
        REFERENCES Shop(IDShop)
);

CREATE TABLE TrTransaction (
    IDTransaction VARCHAR(6),
    IDProduct INT,
    IDCustomer INT,
    TransactionDate DATETIME,
    Quantity INT NOT NULL,
    TotalPrice INT NOT NULL,
    Done BIT NOT NULL,
    PaymentMethod VARCHAR(50) NOT NULL,

    PRIMARY KEY (IDTransaction),

    FOREIGN KEY (IDCustomer)
        REFERENCES Customer(IDCustomer),

    FOREIGN KEY (IDProduct)
        REFERENCES Product(IDProduct)
);

CREATE TABLE Review (
    IDReview INT AUTO_INCREMENT,
    IDProduct INT,
    Comment VARCHAR(50),
    Star INT NOT NULL,

    CONSTRAINT chk_review
        CHECK (Star BETWEEN 1 AND 5),

    PRIMARY KEY (IDReview),

    FOREIGN KEY (IDProduct)
        REFERENCES Product(IDProduct)
);

CREATE TABLE Cart (
    IDCart INT AUTO_INCREMENT,
    IDProduct INT,
    IDCustomer INT,

    PRIMARY KEY (IDCart),

    FOREIGN KEY (IDProduct)
        REFERENCES Product(IDProduct),

    FOREIGN KEY (IDCustomer)
        REFERENCES Customer(IDCustomer)
);

INSERT INTO Customer(Name, PhoneNumber, Email)
VALUES
('Christiana Willis Cockle','202-555-0106','christiana@email.com'),
('James Butterscotch','202-555-0174','james@email.com'),
('Suzanne Jones Greenway','202-555-0102','suzanne@email.com'),
('Morwenna Doop','202-555-0170','morwenna@email.com'),
('Beth Giantbulb Barlow','202-555-0140','beth@email.com'),
('Morwenna Doop','202-555-0160','morwenna@email.com'),
('Jeff Ferguson Platt','202-555-0120','jeff@email.com'),
('Jenna Thornhill','202-555-01900','jenna@email.com'),
('Charlotte Donaldson Hemingway','202-555-0270','charlotte@email.com'),
('Steven Smith','202-555-0820','steven@email.com');

INSERT INTO Shop(IDShop, Name, Owner, isOfficial, Address)
VALUES
('SH145N','Fortune Shop','Clarke Platt',0,'204 Peed Smith Rd, Hamilton, GA, 31811'),
('SH223Y','Jaya Shop','Fred Wilson',1,'4932 Reuter St, Dearborn, MI, 48126'),
('SH359Y','Surya Shop','Naomi Rockatansky',1,'4971 Good Luck Rd, Aynor, SC, 29511'),
('SH483N','Sinar Shop','Jenna Vader',0,'5401 A Tech Cir, Moorpark, CA, 93021'),
('SH592Y','Terang Shop','Mary Parkes',1,'7120 Crestwood Ave, Jenison, MI, 49428'),
('SH673N','Parlor Shop','Sophia Willis',0,'185 Red Maple Dr, Hampton, GA, 30228'),
('SH778N','Inn Shop','Suzanne Ball',0,'106 Southwind Dr, Pleasant Hill, CA, 94523'),
('SH832N','Deli Shop','Alex Barker',0,'2337 School House Rd, Fairmont, WV, 26554'),
('SH912Y','Buzz Shop','Sandie Doop',1,'5544 East Torino, Port Saint Lucie, FL, 34986'),
('SH102Y','Fushion Shop','Alex Fish',1,'89068 Fir Butte Rd, Eugene, OR, 97402');

INSERT INTO Product(IDShop, Name, Stock, Price)
VALUES
('SH145N', 'Fidget Spinner', 110, 49000),
('SH145N', 'Fidget Box', 78, 39000),
('SH145N', 'Slime', 40, 12000),
('SH145N', 'Lego', 103, 56000),
('SH145N', 'Gundam Master Grade', 5, 405000),
('SH223Y', 'Computer', 5, 5000000),
('SH223Y', 'VGA', 26, 1000000),
('SH223Y', 'Mouse', 98, 340000),
('SH223Y', 'Keyboard', 63, 760000),
('SH223Y', 'Earphone', 120, 120000);

INSERT INTO TrTransaction(IDTransaction, IDProduct, IDCustomer, TransactionDate, Quantity, TotalPrice, Done, PaymentMethod)
VALUES
('TR001',1,1,'2018-03-12 12:23:01',2,98000,0,'Credit Card'),
('TR002',2,2,'2018-05-01 07:21:01',1,39000,1,'Debit'),
('TR003',3,3,'2018-02-23 20:45:56',1,12000,1,'Credit Card'),
('TR004',4,4,'2018-09-15 17:38:59',1,56000,1,'Credit Card'),
('TR005',5,5,'2018-08-05 10:11:01',2,105000,0,'Debit');

INSERT INTO Review(IDProduct, Comment, Star)
VALUES
(1,'Good',5),
(1,'Nice',4),
(2,'I dont like it',2),
(2,'Best product',5),
(3,'Not really..',3),
(3,'Never buy this item again',1),
(4,'Good job',5),
(4,'Awesome',5),
(3,'So So',3),
(5,'OK',3);

INSERT INTO Cart(IDProduct, IDCustomer)
VALUES
(1,1),
(3,2),
(4,2),
(5,1),
(7,1),
(12,1),
(33,1),
(44,1),
(25,1),
(17,1);

TRUNCATE Cart;

INSERT INTO Cart(IDProduct, IDCustomer)
VALUES
(1,1),
(1,2),
(2,3),
(2,4),
(3,2),
(4,2),
(4,5),
(5,1),
(6,3),
(7,4),
(8,1),
(8,5),
(9,2),
(9,3),
(10,1);

    