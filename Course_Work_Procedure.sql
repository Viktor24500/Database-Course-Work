USE COURSE_WORK

create proc select_stock_item
@name VARCHAR(200)
as
	SELECT St.all_amount, St.price, Ic.name_category,
	I.name_item, S.sector_name
	FROM Stock_item St
	JOIN Item I ON I.id_item=st.id_item_fk
	JOIN Sector S ON I.id_sector_fk=S.id_sector
	JOIN Item_Category Ic ON Ic.id_category=St.id_category_fk
	WHERE I.name_item=@name

exec select_stock_item 'small infantry shovel'

create proc select_invoice
@InvNumber VARCHAR(200)
as
	SELECT Inv.date_invoice, Inv.invoice_number,Ds.name_destination_sender as Destination,
	Sd.name_destination_sender as Sender
	FROM Invoice Inv
	JOIN Destination_Sender Ds ON Ds.id_destination_sender=Inv.id_destination_fk
	JOIN Destination_Sender Sd ON Sd.id_destination_sender=Inv.id_sender_fk
	WHERE Inv.invoice_number=@InvNumber AND Ds.id_destination_sender=Inv.id_destination_fk
	AND Sd.id_destination_sender=Inv.id_sender_fk

exec select_invoice '241K'

SELECT * FROM Invoice

create proc select_invoice_position
@InvNumber VARCHAR(200)
as
	SELECT Inv.invoice_number, Inv.date_invoice, Item.name_item, InvPos.amount,
	InvPos.price, ItemCat.name_category, Ds.name_destination_sender as Destination,
	Sd.name_destination_sender as Sender
	FROM Invoice_position InvPos
	JOIN Item_Category ItemCat ON ItemCat.id_category=InvPos.id_category_fk
	JOIN Stock_item StItem ON StItem.price=InvPos.price AND StItem.id_item_fk=InvPos.id_item_fk
	JOIN Item ON Item.id_item=StItem.id_item_fk
	JOIN Invoice Inv ON InvPos.id_invoice_fk=Inv.id_invoice
	JOIN Destination_Sender Ds ON Ds.id_destination_sender=Inv.id_sender_fk
	JOIN Destination_Sender Sd ON Sd.id_destination_sender=Inv.id_destination_fk
	WHERE Inv.invoice_number=@InvNumber
	
exec select_invoice_position '310H'

SELECT * FROM Invoice_position

SELECT * FROM Stock_item