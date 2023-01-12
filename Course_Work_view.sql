create view StockItemView
as
SELECT StItem.all_amount, StItem.price, I.name_item
FROM Item I, Stock_item StItem
WHERE StItem.id_item_fk=I.id_item

SELECT * FROM StockItemView

create view StockItemSectorView
as
SELECT StItem.price, I.name_item, StItem.all_amount as AllAmount, Sec.sector_name
FROM Stock_item StItem, Item I, Sector Sec
WHERE StItem.id_item_fk=I.id_item AND I.id_sector_fk=Sec.id_sector

SELECT * FROM StockItemSectorView