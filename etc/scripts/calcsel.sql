USE [SmartEDI]
GO
/****** Object:  StoredProcedure [dbo].[gen_selinv]    Script Date: 30.10.2015 г. 18:04:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[gen_selinv] AS 
BEGIN
SET NOCOUNT ON
DECLARE @getprod CURSOR

DECLARE @pn VARCHAR(32)
DECLARE @hp_stock INT
DECLARE @most_stock INT

DELETE FROM selinv3

SET @getprod = CURSOR FOR
SELECT prod_base_no,
        hp_stock,
        most_stock
FROM   selprod

OPEN @getprod
FETCH NEXT FROM @getprod INTO @pn, @hp_stock, @most_stock
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT N'PROCESSING PROD ' + @pn

    DECLARE @getinv CURSOR
    DECLARE @cmqty INT
    SET @cmqty = 0

    DECLARE @qty INT
    DECLARE @invno VARCHAR(32)
	DECLARE @invdate DATE

    SET @getinv = CURSOR FOR
    SELECT invoic.InvoiceNo as invno,
        Quantity as qty,
		invoic.InvoiceDate
	FROM invdet
    INNER JOIN invoic on (invoic.InvoiceNo = invdet.InvoiceNo)
    WHERE dbo.ven2clean(VendorPArtNo) = @pn
    ORDER by InvoiceDate desc

    OPEN @getinv
    FETCH NEXT FROM @getinv INTO @invno, @qty, @invdate
    WHILE @@FETCH_STATUS = 0 AND ( @cmqty < @hp_stock )
    BEGIN 
		INSERT INTO selinv3 VALUES (@invno, @pn)
	    PRINT N'CONSIDERING INVOICE' + @invno 
			+ ' / invoice QTY: ' + cast ( @qty as VarChar(6) )
			+ ' / invoice Date: ' + cast ( @invdate as VarChar(8))
			+ ' / so far: ' + cast ( @cmqty as VarChar(6)) 
			+ ' / hpstock: ' + cast ( @hp_stock as VarChar(6)) 
			+ ' / mostock ' + cast ( @most_stock as VarChar(6))
        SET @cmqty = @cmqty + @qty
	    FETCH NEXT FROM @getinv INTO @invno, @qty, @invdate
    END

    CLOSE @getinv
    DEALLOCATE @getinv
	FETCH NEXT FROM @getprod INTO @pn, @hp_stock, @most_stock
END

CLOSE @getprod
DEALLOCATE @getprod

END

