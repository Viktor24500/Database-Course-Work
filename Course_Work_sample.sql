USE COURSE_WORK

SELECT * FROM Invoice

SELECT * FROM Stock_item
ORDER BY all_amount 

SELECT COUNT(id_category)
FROM Item_Category

SELECT COUNT( DISTINCT id_invoice_fk)
FROM Invoice_position

SELECT * FROM Invoice

SELECT * FROM Invoice
WHERE Invoice.id_sender_fk in (SELECT id_sender_fk FROM Destination_Sender
WHERE id_destination_sender=2 AND Invoice.id_sender_fk=Destination_Sender.id_destination_sender
AND date_invoice BETWEEN '2022-10-01' AND '2022-10-31')

SELECT St.price, St.all_amount, I.name_item
FROM Stock_item St
JOIN Item I on I.id_item=St.id_stock_item
WHERE St.price BETWEEN 10 AND 100

SELECT I.name_item, InvPos.amount, InvPos.price, Inv.date_invoice,
Inv.invoice_number, DS.name_destination_sender as Destination,
SD.name_destination_sender as Sender
FROM Invoice_position InvPos
JOIN Invoice Inv ON Inv.id_invoice=InvPos.id_invoice_fk
JOIN Destination_Sender DS ON DS.id_destination_sender=Inv.id_destination_fk
JOIN Destination_Sender SD ON SD.id_destination_sender=Inv.id_sender_fk
JOIN Stock_item St ON St.id_item_fk=InvPos.id_item_fk AND InvPos.price=St.price
JOIN Item I ON I.id_item=St.id_item_fk
WHERE DS.name_destination_sender LIKE 'A8%'

SELECT I.name_item, InvPos.price,
COUNT (InvPos.amount) as 'Amount item'
FROM Invoice_position InvPos
JOIN Stock_item St ON St.id_item_fk=InvPos.id_item_fk AND InvPos.price=St.price
JOIN Item I ON I.id_item=St.id_item_fk
GROUP BY I.name_item, InvPos.price

SELECT Inv.date_invoice, Inv.invoice_number, InvT.name_type,
I.name_item, InvPos.amount, St.price
FROM Invoice Inv
JOIN Invoice_type InvT ON InvT.id_type=Inv.id_type_fk
JOIN Invoice_position InvPos ON Inv.id_invoice=InvPos.id_invoice_fk
JOIN Stock_item St ON St.id_item_fk=InvPos.id_item_fk AND InvPos.price=St.price
JOIN Item I ON St.id_item_fk=I.id_item