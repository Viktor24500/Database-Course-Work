--USE COURSE_WORK


--create trigger UpdateAmountAfterDelete
--ON Invoice_Position
--AFTER DELETE
--as
----INSERT INTO History_Delete_deleted (id_deleted_main, id_invoice_fk,
----amount, price, id_item_fk, id_category_fk)
--SELECT *
--FROM DELETED
--exec update_amount_after_delete

create trigger UpdateAmountAfterDelete
ON Invoice_Position
AFTER DELETE
as
	BEGIN --UpdateAmountAfterDelete
		DECLARE @allAmount FLOAT, @invoiceAmount FLOAT, @type VARCHAR(10),
		@StItemPrice FLOAT, @delInvPosPrice FLOAT, @id INT, @stItemIDFK INT, @delInvPosItemIDFK INT,
		@delInvPosIDInvFK INT
		DECLARE CurentCursor CURSOR FOR
			SELECT id_invoice_position
			FROM deleted
		OPEN CurentCursor
		FETCH NEXT FROM CurentCursor INTO @id
		WHILE @@FETCH_STATUS = 0
		BEGIN
		--SELECT @id as DelPosId
			BEGIN
				SELECT @delInvPosItemIDFK=(del.id_item_fk) FROM deleted del
				WHERE del.id_invoice_position=@id
			END

			--select all amount from stock item 
			BEGIN
				SELECT @allAmount=(all_amount) FROM Stock_item Sti
				JOIN deleted del ON Sti.id_item_fk=del.id_item_fk
				WHERE @delInvPosItemIDFK=Sti.id_item_fk AND Sti.price=del.price AND del.id_invoice_position=@id
			END

			--select amount from invoice
			BEGIN
				SELECT @invoiceAmount=(amount) FROM deleted del
				JOIN Stock_item Sti ON Sti.id_item_fk=del.id_item_fk
				JOIN Invoice Inv ON Inv.id_invoice=del.id_invoice_fk
				JOIN Invoice_type InvT ON InvT.id_type=Inv.id_type_fk
				WHERE Sti.price=del.price AND @delInvPosItemIDFK=Sti.id_item_fk AND del.id_invoice_position=@id
			END

			--select price from invoice
			BEGIN
				SELECT @delInvPosPrice=(del.price) FROM deleted del
				JOIN Stock_item Sti ON Sti.id_item_fk=del.id_item_fk
				JOIN Invoice Inv ON Inv.id_invoice=del.id_invoice_fk
				JOIN Invoice_type InvT ON InvT.id_type=Inv.id_type_fk
				WHERE Sti.price=del.price AND @delInvPosItemIDFK=Sti.id_item_fk AND del.id_invoice_position=@id
			END

			--select type from invoice type
			BEGIN
				SELECT @type=(name_type) FROM Invoice_type InvT
				JOIN Invoice Inv ON Inv.id_type_fk=InvT.id_type
				JOIN deleted del ON Inv.id_invoice=del.id_invoice_fk
				WHERE del.id_invoice_fk=Inv.id_invoice AND del.id_invoice_position=@id
			END

			--select stock item id
			BEGIN
				SELECT @stItemIDFK=(Sti.id_item_fk) FROM Stock_item Sti
				JOIN deleted del ON Sti.id_item_fk=del.id_item_fk
				WHERE @delInvPosItemIDFK=Sti.id_item_fk AND Sti.price=@delInvPosPrice AND del.id_invoice_position=@id
			END

			--select price from stock item
			BEGIN
				SELECT @StItemPrice=(Sti.price) FROM Stock_item Sti
				JOIN deleted del ON Sti.id_item_fk=del.id_item_fk
				WHERE @delInvPosItemIDFK=Sti.id_item_fk AND Sti.price=@delInvPosPrice AND del.id_invoice_position=@id
			END
			IF (@id=NULL OR @type=NULL OR @delInvPosItemIDFK=NULL Or @stItemIDFK=NULL OR @allAmount=NULL
			OR @invoiceAmount=NULL OR @delInvPosPrice=NULL OR @StItemPrice=NULL OR @delInvPosPrice!=@StItemPrice)
				BEGIN
					print 'Denied. One of variable="NULL" or price are difference'
					rollback tran
				END

			IF ((@delInvPosPrice=@StItemPrice) AND (@delInvPosItemIDFK=@stItemIDFK) AND (@type='OUT'))
				BEGIN
					SET @allAmount=@allAmount+@invoiceAmount
					UPDATE Stock_item
					SET all_amount=@allAmount
					WHERE id_item_fk=@stItemIDFK AND price=@StItemPrice
				END
			IF ((@delInvPosPrice=@StItemPrice) AND (@delInvPosItemIDFK=@stItemIDFK) AND (@type='IN'))
			BEGIN
				SET @allAmount=@allAmount-@invoiceAmount
				UPDATE Stock_item
				SET all_amount=@allAmount
				WHERE id_item_fk=@stItemIDFK AND price=@StItemPrice
			END
			FETCH NEXT FROM CurentCursor INTO @id
		END --WHILE @@FETCH_STATUS = 0
		CLOSE CurentCursor
		DEALLOCATE CurentCursor
	END --UpdateAmountAfterDelete