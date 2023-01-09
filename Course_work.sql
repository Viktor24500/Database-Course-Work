CREATE DATABASE COURSE_WORK

USE COURSE_WORK

CREATE TABLE Item_Category(
id_category INT IDENTITY PRIMARY KEY,
name_category Varchar(100) NOT NULL
)

CREATE TABLE Invoice_type(
id_type INT IDENTITY PRIMARY KEY,
name_type VARCHAR(100) NOT NULL
)

CREATE TABLE Sector(
id_sector INT IDENTITY PRIMARY KEY,
sector_name VARCHAR(100) NOT NULL
)

CREATE TABLE Destination_Sender(
id_destination_sender INT IDENTITY PRIMARY KEY,
id_parent_fk INT FOREIGN KEY REFERENCES Destination_Sender(id_destination_sender),
name_destination_sender VARCHAR(100) NOT NULL
)

CREATE TABLE Item(
id_item INT IDENTITY PRIMARY KEY,
name_item VARCHAR(100) NOT NULL,
id_sector_fk INT FOREIGN KEY REFERENCES Sector(id_sector)
)

CREATE TABLE Stock_item(
id_stock_item INT IDENTITY PRIMARY KEY,
all_amount INT NOT NULL,
id_item_fk INT FOREIGN KEY REFERENCES Item(id_item),
id_category_fk INT FOREIGN KEY REFERENCES Item_Category(id_category),
price FLOAT
CONSTRAINT idStockItemPrice UNIQUE (id_stock_item, price) --unique pare
)

CREATE TABLE Destination_stock_item(
id_destination_stock_item INT IDENTITY PRIMARY KEY,
id_destination_fk INT FOREIGN KEY REFERENCES Destination_Sender(id_destination_sender),
id_stock_item INT FOREIGN KEY REFERENCES Stock_item(id_stock_item)
)

CREATE TABLE Invoice(
id_invoice INT IDENTITY PRIMARY KEY,
date_invoice DATETIME,
invoice_number VARCHAR(100),
id_destination_fk INT FOREIGN KEY REFERENCES Destination_Sender(id_destination_sender),
id_sender_fk INT FOREIGN KEY REFERENCES Destination_Sender(id_destination_sender),
id_type_fk INT FOREIGN KEY REFERENCES Invoice_type(id_type),
id_sector_fk INT FOREIGN KEY REFERENCES Sector(id_sector)
)

CREATE TABLE Invoice_position(
id_invoice_position INT IDENTITY PRIMARY KEY,
id_invoice_fk INT FOREIGN KEY REFERENCES Invoice(id_invoice),
amount INT,
price FLOAT,
id_stock_item_fk INT FOREIGN KEY REFERENCES Stock_item(id_stock_item),
id_category_fk INT FOREIGN KEY REFERENCES Item_Category(id_category),
)

CREATE TABLE History_delete_Destination_Sender(
id_history_delete INT IDENTITY,
id_destination_sender_in_main INT,
id_parent_fk INT,
name_destination_sender VARCHAR(100) NOT NULL
)

CREATE TABLE History_Delete_Invoice_position(
id_hist_del_inv_pos INT IDENTITY PRIMARY KEY,
id_invoice_position_main INT,
id_invoice_fk INT FOREIGN KEY REFERENCES Invoice(id_invoice),
amount INT,
price FLOAT,
id_stock_item_fk INT FOREIGN KEY REFERENCES Stock_item(id_stock_item),
id_category_fk INT FOREIGN KEY REFERENCES Item_Category(id_category),
)

DROP TABLE History_Delete_Invoice_position
DBCC CHECKIDENT ('History_Delete_Invoice_position', RESEED, 1) --set IDENTITY counter to 1
GO

SELECT * FROM Invoice_position

SELECT * FROM Stock_item