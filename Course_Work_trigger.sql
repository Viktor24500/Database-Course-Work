--USE COURSE_WORK

create trigger HistoryDeleteDestSend
ON Destination_Sender
AFTER DELETE
as
INSERT INTO History_delete_Destination_Sender (id_destination_sender_in_main, id_parent_fk,
name_destination_sender)
SELECT *
FROM DELETED

--sp_helptext @objname='history_delete'

--sp_helptext @objname='history_delete_invoice_pos'

--sp_helptrigger @tabname='Invoice_Position'

--drop trigger UpdateAmountAfterDelete

--DISABLE TRIGGER HistoryDeleteDestSend
--ON Destination_Sender

--DISABLE TRIGGER UpdateAmountAfterDelete
--ON Invoice_Position

--DISABLE TRIGGER UpdateAmountAfterUpdate
--ON Invoice_Position

--DISABLE TRIGGER updateAmountAfterInsert
--ON Invoice_Position

--ENABLE TRIGGER HistoryDeleteDestSend
--ON Destination_Sender

--ENABLE TRIGGER UpdateAmountAfterDelete
--ON Invoice_Position

--ENABLE TRIGGER UpdateAmountAfterUpdate
--ON Invoice_Position

--ENABLE TRIGGER updateAmountAfterInsert
--ON Invoice_Position