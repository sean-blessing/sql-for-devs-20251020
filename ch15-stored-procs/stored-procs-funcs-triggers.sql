-- ch 15 Stored Procedures
-- p. 435
USE AP; GO

--CREATE PROC spInvoiceReport AS
--	SELECT VendorName, InvoiceNumber, InvoiceDate, InvoiceTotal 
--	  FROM Invoices i 
--	  JOIN Vendors v ON i.VendorID = v.VendorID
--     WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0 
--	 ORDER BY VendorName;

--EXEC spInvoiceReport;

--SELECT *
--  FROM Invoices;
-- p. 439
--CREATE PROC spInvTotal2 
--@DateVar date = NULL
--AS IF @DateVar IS NULL 
--SELECT @DateVar = MIN(InvoiceDate) FROM Invoices;
--SELECT SUM(InvoiceTotal) FROM Invoices
--	WHERE InvoiceDate >= @DateVar;
--DECLARE @ADate date = '2022-12-24';

--EXEC spInvTotal2 @ADate;
--EXEC spInvTotal2;

-- p. 441 output keyword
--DROP PROC IF EXISTS spInvTotal3;
--GO

--CREATE PROC spInvTotal3
--	@InvTotal money OUTPUT, 
--	@DateVar date = NULL, 
--	@VendorVar varchar(40) = '%'

--AS 

--IF @DateVar IS NULL 
--	SELECT @DateVar = MIN(InvoiceDate) FROM Invoices;

--SELECT @InvTotal = SUM(InvoiceTotal) 
--  FROM Invoices i 
--  JOIN Vendors v ON i.VendorID = v.VendorID 
-- WHERE InvoiceDate >= @DateVar
--   AND VendorName LIKE @VendorVar;


-- DECLARE @MyInvTotal money;
--EXEC spInvTotal3 @MyInvTotal OUTPUT, '2023-01-01', 'P%';
--PRINT @MyInvTotal;

-- TESTING THE PROC
--SELECT SUM(InvoiceTotal) 
--  FROM Invoices i 
--  JOIN Vendors v ON i.VendorID = v.VendorID 
-- WHERE InvoiceDate >= '2023-01-01'
--   AND VendorName LIKE 'P%';

--EXEC spInvTotal3 @MyInvTotal;

-- p. 443
-- PROC w/ return value
--CREATE PROC spInvCount 
--@DateVar date = NULL, 
--@VendorVar varchar(40) = '%'
--AS 
--IF @DateVar IS NULL
--	SELECT @DateVar = MIN(InvoiceDate) FROM Invoices; 
--DECLARE @InvCount int;

--SELECT @InvCount = COUNT(InvoiceID) 
--  FROM Invoices i 
--  JOIN Vendors v ON i.VendorID = v.VendorID 
-- WHERE (InvoiceDate >= @DateVar) 
--   AND (VendorName LIKE @VendorVar);

--RETURN @InvCount;

--DECLARE @InvCount int;

--EXEC @InvCount = spInvCount '2023-01-01', 'P%';

--PRINT 'Invoice count: ' + CONVERT(varchar, @InvCount);

-- p. 445 Stored PROC that throws an error
--USE AP;
--GO

--DROP PROC IF EXISTS spInsertInvoice;
--GO

--CREATE PROC spInsertInvoice
--       @VendorID    int,  @InvoiceNumber  varchar(50),
--       @InvoiceDate date, @InvoiceTotal   money,
--       @TermsID     int,  @InvoiceDueDate date
--AS

--IF EXISTS(SELECT * FROM Vendors WHERE VendorID = @VendorID)
--    INSERT Invoices
--    VALUES (@VendorID, @InvoiceNumber,
--            @InvoiceDate, @InvoiceTotal, 0, 0,
--            @TermsID, @InvoiceDueDate, NULL);
--ELSE 
--    THROW 50001, 'Not a valid VendorID!', 1;
--BEGIN TRY
--    EXEC spInsertInvoice 
--         799,'ZXK-799','2023-03-01',299.95,1,'2023-04-01';
--END TRY
--BEGIN CATCH
--    PRINT 'An error occurred.';
--    PRINT 'Message: ' + CONVERT(varchar, ERROR_MESSAGE());
--    IF ERROR_NUMBER() >= 50000
--        PRINT 'This is a custom error message.';
--END CATCH;

-- p. 453 user defined table type
--USE AP;

---- drop stored procedure if it exists already
--DROP PROC IF EXISTS spInsertLineItems;
--GO

---- drop table type if it exists already
--DROP TYPE IF EXISTS LineItems;
--GO

-- create the user-defined table type named LineItems
--CREATE TYPE LineItems AS
--TABLE
--(InvoiceID        int           NOT NULL,
-- InvoiceSequence  smallint      NOT NULL,
-- AccountNo        int           NOT NULL,
-- ItemAmount       money         NOT NULL,
-- ItemDescription  varchar(100)  NOT NULL,
--PRIMARY KEY (InvoiceID, InvoiceSequence));

--GO

---- create a stored procedure that accepts the LineItems type
--CREATE PROC spInsertLineItems
--    @NewLineItems LineItems READONLY
--AS
--    INSERT INTO InvoiceLineItems
--    SELECT *
--    FROM @NewLineItems;

--GO

--DELETE FROM InvoiceLineItems 
--WHERE InvoiceID = 114
--  AND InvoiceSequence > 1;

---- declare a variable for the LineItems type
--DECLARE @NewLineItems LineItems;

---- insert rows into the LineItems variable
--INSERT INTO @NewLineItems VALUES (114, 2, 553, 152.25, 'Freight');
--INSERT INTO @NewLineItems VALUES (114, 3, 553, 29.25, 'Freight');
--INSERT INTO @NewLineItems VALUES (114, 4, 553, 48.50, 'Freight');

---- execute the stored procedure
--EXEC spInsertLineItems @NewLineItems;

-- p. 457
--EXEC sp_HelpText spInsertInvoice;
--EXEC sp_Help;
--EXEC sp_Help spInsertInvoice;
--EXEC sp_Who;
--EXEC sp_Columns Invoices;
--EXEC sp_who2;

-- p. 459 user defined functions
--CREATE FUNCTION fnVendorID (@VendorName varchar(50)) 
--	RETURNS int
--BEGIN 
--	RETURN 
--	(SELECT VendorID FROM Vendors WHERE VendorName = @VendorName); 
--END; 

--PRINT dbo.fnVendorID('IBM');

-- p. 461
--CREATE FUNCTION fnBalanceDue() 
--	RETURNS money
--BEGIN
--	RETURN 
--	(SELECT SUM(InvoiceTotal - PaymentTotal - CreditTotal) 
--	   FROM Invoices
--      WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0); 
--END;

--SELECT dbo.fnBalanceDue();

--
--SELECT *
--  FROM Invoices;

--SELECT *
--  FROM InvoiceLineItems;

--SELECT InvoiceNumber, InvoiceTotal, InvoiceLineItemAmount
--  FROM Invoices I
--  JOIN InvoiceLineItems ILI ON I.InvoiceID = ILI.InvoiceID
-- WHERE I.InvoiceID = 12;

-- function that gets Inv#, InvTotal, LI Amts for a specific InvoiceId?
--CREATE FUNCTION fnLineItemDetail(@VendorID int)
--	RETURNS table
--RETURN
--	SELECT TOP 50 InvoiceNumber, InvoiceSequence, InvoiceTotal, InvoiceLineItemAmount
--	  FROM Invoices I
--      JOIN InvoiceLineItems ILI ON I.InvoiceID = ILI.InvoiceID
--     WHERE I.InvoiceID = @VendorID
--	ORDER BY InvoiceSequence;

SELECT *
  FROM dbo.fnLineItemDetail(12);

