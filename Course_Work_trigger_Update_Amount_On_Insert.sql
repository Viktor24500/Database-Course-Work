--USE COURSE_WORK

create trigger updateAmountAfterInsert
ON Invoice_Position
AFTER INSERT
as
BEGIN --updateAmountAfterInsert
		DECLARE @allAmount FLOAT, @invoiceAmount FLOAT, @type VARCHAR(10),
		@StItemPrice FLOAT, @insInvPosPrice FLOAT, @id INT, @stItemIDFK INT, @insInvPosItemIDFK INT,
		@insInvPosIDInvFK INT
		DECLARE CurentCursor CURSOR FOR
			SELECT id_invoice_position
			FROM inserted
		OPEN CurentCursor
		FETCH NEXT FROM CurentCursor INTO @id
		WHILE @@FETCH_STATUS = 0
		BEGIN
		--select id stock item from invoice
			BEGIN
				SELECT @insInvPosItemIDFK=(ins.id_item_fk) FROM inserted ins
				WHERE ins.id_invoice_position=@id
			END

		--select all amount from stock item 
			BEGIN
				SELECT @allAmount=(all_amount) FROM Stock_item Sti
				JOIN inserted ins ON Sti.id_item_fk=ins.id_item_fk
				WHERE @insInvPosItemIDFK=Sti.id_item_fk AND Sti.price=ins.price
			END

			--select amount from invoice
			BEGIN
				SELECT @invoiceAmount=(amount) FROM inserted ins
				JOIN Stock_item Sti ON Sti.id_item_fk=ins.id_item_fk
				JOIN Invoice Inv ON Inv.id_invoice=ins.id_invoice_fk
				JOIN Invoice_type InvT ON InvT.id_type=Inv.id_type_fk
				WHERE Sti.price=ins.price AND @insInvPosItemIDFK=Sti.id_item_fk AND ins.id_invoice_position=@id
			END
			--select price from from invoice
			BEGIN
				SELECT @insInvPosPrice=(ins.price) FROM inserted ins
				JOIN Stock_item Sti ON Sti.id_item_fk=ins.id_item_fk
				JOIN Invoice Inv ON Inv.id_invoice=ins.id_invoice_fk
				JOIN Invoice_type InvT ON InvT.id_type=Inv.id_type_fk
				WHERE Sti.price=ins.price AND @insInvPosItemIDFK=Sti.id_item_fk AND ins.id_invoice_position=@id
			END

			--select type from invoice type
			BEGIN
				SELECT @type=(name_type) FROM Invoice_type InvT
				JOIN Invoice Inv ON Inv.id_type_fk=InvT.id_type
				JOIN inserted ins ON Inv.id_invoice=ins.id_invoice_fk
				WHERE ins.id_invoice_fk=Inv.id_invoice AND ins.id_invoice_position=@id
			END

			--select price from stock item
			BEGIN
				SELECT @StItemPrice=(Sti.price) FROM Stock_item Sti
				JOIN inserted ins ON Sti.id_item_fk=ins.id_item_fk
				WHERE @insInvPosItemIDFK=Sti.id_item_fk AND Sti.price=@insInvPosPrice AND ins.id_invoice_position=@id
			END

			--select stock item id
			BEGIN
				SELECT @stItemIDFK=(Sti.id_item_fk) FROM Stock_item Sti
				JOIN inserted ins ON Sti.id_item_fk=ins.id_item_fk
				WHERE Sti.id_item_fk=@insInvPosItemIDFK AND Sti.price=@insInvPosPrice AND ins.id_invoice_position=@id
			END

			IF (@id=NULL OR @type=NULL OR @insInvPosItemIDFK=NULL Or @stItemIDFK=NULL OR @allAmount=NULL
			OR @invoiceAmount=NULL OR @insInvPosPrice=NULL OR @StItemPrice=NULL OR @insInvPosPrice=NULL OR @insInvPosPrice!=@StItemPrice)
				BEGIN
					print 'Denied. One of variable="NULL"'
					rollback tran
				END

			IF ((@invoiceAmount<@allAmount) AND (@insInvPosPrice=@StItemPrice) 
			AND (@insInvPosItemIDFK=@stItemIDFK) AND (@type='OUT'))
				BEGIN
					SET @allAmount=@allAmount-@invoiceAmount
					UPDATE Stock_item
					SET all_amount=@allAmount
					WHERE id_item_fk=@stItemIDFK AND price=@StItemPrice
				END
			ELSE
				BEGIN
					print 'Denied. If you output amount in Invoice can"t exceed all amount or price are difference'
					rollback tran
				END
			IF ((@insInvPosPrice=@StItemPrice)	AND (@insInvPosItemIDFK=@stItemIDFK)
			AND (@type='IN'))
			BEGIN
				SET @allAmount=@allAmount+@invoiceAmount
				UPDATE Stock_item
				SET all_amount=@allAmount
				WHERE id_item_fk=@stItemIDFK AND price=@StItemPrice
			END
			FETCH NEXT FROM CurentCursor INTO @id
		END --WHILE @@FETCH_STATUS = 0
		CLOSE CurentCursor
		DEALLOCATE CurentCursor
END --updateAmountAfterInsert