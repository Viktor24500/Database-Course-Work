USE COURSE_WORK

INSERT INTO Item_Category
(name_category)
VALUES
('Category1'),
('Category2'),
('Category3'),
('Category4'),
('Category5');

INSERT INTO Invoice_type
(name_type)
VALUES
('IN'),
('OUT');

INSERT INTO Destination_Sender
(id_parent_fk, name_destination_sender)
VALUES
(NULL, 'A7580'), --1
(NULL, 'A8960'), --2
(2, 'A9899'), --3
(1, 'A7477'), --4 
(1, 'A0989'), --5
(2, 'A9810'), --6
(2, 'A9786'), --7
(5, 'A0580'), --8
(6, 'A2540'), --9
(7, 'A0245'); --10

--service
INSERT INTO Sector 
(sector_name)
VALUES
('Engineering'),
('RKhBZ'), --radio-bio-chem protect
('Engineering warfare');


INSERT INTO Item
(name_item, id_sector_fk)
VALUES
('wood', 1), --1
('small infantry shovel', 1), --2
('sand', 1), --3
('mask', 2), --4
('grenade',3), --5 
('explosion',3 ), --6
('Geiger_counter', 2), --7
('big sapper shovel', 1), --8
('bag', 1), --9
('metal', 1); --10


INSERT INTO Stock_item
(id_item_fk, id_category_fk, all_amount, price)
VALUES
(1, 1, 40, 100.50), --1
(1, 1, 30, 50), --2
(2, 2, 100, 80), --3
(3, 3, 10, 5), --4
(4, 2, 40, 15), --5
(5, 3, 60, 56.78), --6 
(5, 1, 100, 40), --7 
(7, 2, 150, 67.89), --8
(8, 3, 200, 70), --9
(9, 2, 20, 50); --10

INSERT INTO Destination_stock_item
(id_destination_fk, id_stock_item)
VALUES
(4, 5), --1
(3, 1), --2
(3, 1), --3
(7, 4), --4
(7, 7), --5
(8, 1), --6
(5, 7), --7
(2, 8), --8
(2, 4), --9
(2, 7); --10

INSERT INTO Invoice
(date_invoice, invoice_number, id_destination_fk, id_sender_fk, id_sector_fk, id_type_fk)
VALUES
('2022-10-12 00:00:00', '240K', 4, 1, 3, 1), --1
('2022-10-14 00:00:00', '310H', 3, 2, 1, 1), --2
('2022-10-20 00:00:00', '220H', 7, 2, 2, 1), --3
('2022-11-10 00:00:00', '250K', 8, 5, 2, 1), --4
('2022-11-12 00:00:00', '241K', 5, 8, 2, 2), --5 
('2022-11-13 00:00:00', '221H', 2, 7, 2, 2), --6
('2022-11-13 00:00:00', '248K', 2, 1, 3, 2), --7
('2022-12-01 00:00:00', '380P', 2, 6, 1, 2); --8
 
INSERT INTO Invoice_position
(id_invoice_fk, amount, price, id_stock_item_fk, id_category_fk)
VALUES
(1, 30, 56.78, 6, 3), --1 
(2, 30, 100.50, 1, 1),--2
(2, 20, 100.50, 1, 1), --3
(3, 30, 15, 5, 2), --4
(3, 100, 40, 7, 2), --5
(4, 20, 100.50, 1, 1), --6
(5, 50, 40, 7, 2), --7
(6, 150, 67.89, 8, 3), --8
(7, 10, 5, 4, 2), --9
(8, 50, 40, 7, 3); --10