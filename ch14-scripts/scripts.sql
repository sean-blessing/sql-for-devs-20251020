-- ch14 Scripts
-- p. 399 Script w/ two batches
--USE master;
--GO

--DROP DATABASE IF EXISTS ClubRoster;
--GO

--CREATE DATABASE ClubRoster; 
--GO

--USE ClubRoster; 
--CREATE TABLE Members
--	(MemberID int NOT NULL IDENTITY PRIMARY KEY, LastName varchar(75) NOT NULL, 
--	 FirstName varchar(50) NOT NULL, 
--	 MiddleName varchar(50) NULL);

--CREATE TABLE Committees
--	(CommitteeID int NOT NULL IDENTITY PRIMARY KEY, 
--	CommitteeName varchar(50) NOT NULL);

--CREATE TABLE CommitteeAssignments
--	(MemberID int NOT NULL REFERENCES Members(MemberID), 
--	CommitteeID int NOT NULL REFERENCES Committees(CommitteeID));

-- p. 401 T-SQL Statements
PRINT 'Hello';

USE AP;
DECLARE @TotalDue money;
SET @TotalDue = (SELECT SUM(InvoiceTotal - PaymentTotal - CreditTotal) 
                   FROM Invoices);
IF @TotalDue > 0 
	PRINT 'Total invoices due = $' + CONVERT(varchar,@TotalDue,1); 
ELSE
	PRINT 'Invoices paid in full';

-- p. 403
USE AP;
DECLARE @MaxInvoice money, @MinInvoice money, @InvoiceCount int,
		@PercentDifference decimal(8,2), @VendorIDVar int = 95;
SELECT @MaxInvoice = MAX(InvoiceTotal), 
	   @MinInvoice = MIN(InvoiceTotal), 
	   @InvoiceCount = COUNT(*)
  FROM Invoices 
 WHERE VendorID = @VendorIDVar; 

SET @PercentDifference = (@MaxInvoice - @MinInvoice) / @MinInvoice * 100;
PRINT 'Maximum invoice is $' + CONVERT(varchar,@MaxInvoice,1) + '.'; 
PRINT 'Minimum invoice is $' + CONVERT(varchar,@MinInvoice,1) + '.'; 
PRINT 'Maximum is ' + CONVERT(varchar,@PercentDifference) + '% more than minimum.';
PRINT 'Number of invoices: ' + CONVERT(varchar,@InvoiceCount) + '.';

-- p. 405 table variable
USE AP;
DECLARE @BigVendors table (VendorID int,
						   VendorName varchar(50)); 
INSERT @BigVendors
	SELECT VendorID, VendorName 
	  FROM Vendors 
	 WHERE VendorID IN
		(SELECT VendorID 
		   FROM Invoices 
		  WHERE InvoiceTotal > 5000); 

SELECT * FROM @BigVendors;

-- p. 407 local temporary table
SELECT TOP 1 VendorID, AVG(InvoiceTotal) AS AvgInvoice 
INTO #TopVendors 
  FROM Invoices 
 GROUP BY VendorID
 ORDER BY AvgInvoice DESC;

SELECT i.VendorID, MAX(InvoiceDate) AS LatestInv 
  FROM Invoices AS i 
  JOIN #TopVendors AS tv ON i.VendorID = tv.VendorID 
 GROUP BY i.VendorID;

-- global temporary table
CREATE TABLE ##RandomSSNs 
(
  SSN_ID int     IDENTITY,
  SSN    char(9) DEFAULT
    LEFT(CAST(CAST(CEILING(RAND()*10000000000) AS bigint) 
         AS varchar),9)
);

INSERT INTO ##RandomSSNs VALUES (DEFAULT); 
INSERT INTO ##RandomSSNs VALUES (DEFAULT);

SELECT * FROM ##RandomSSNs; 

-- p. 415
USE AP;
IF OBJECT_ID('tempdb..#InvoiceCopy') IS NOT NULL DROP TABLE #InvoiceCopy;
SELECT * INTO #InvoiceCopy 
  FROM Invoices 
 WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0;

WHILE (SELECT SUM(InvoiceTotal - CreditTotal - PaymentTotal) 
         FROM #InvoiceCopy) >= 20000
BEGIN 
	UPDATE #InvoiceCopy SET CreditTotal = CreditTotal + .05 
	 WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0;
	IF (SELECT MAX(CreditTotal) FROM #InvoiceCopy) > 3000 
		BREAK;
	ELSE
		--(SELECT MAX(CreditTotal) FROM #InvoiceCopy) <= 3000
		CONTINUE;
END;

SELECT InvoiceDate, InvoiceTotal, CreditTotal 
  FROM #InvoiceCopy;

-- p. 416 and 417
SELECT *
  FROM Invoices;

USE AP;
DECLARE @InvoiceIDVar int, 
		@InvoiceTotalVar money, 
		@UpdateCount int = 0;

DECLARE Invoices_Cursor CURSOR 
FOR
	SELECT InvoiceID, InvoiceTotal 
	  FROM Invoices 
	 WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0; 
OPEN Invoices_Cursor;

FETCH NEXT FROM Invoices_Cursor 
	INTO @InvoiceIDVar, @InvoiceTotalVar; 
WHILE @@FETCH_STATUS <> -1 
	BEGIN
		IF @InvoiceTotalVar > 1000 
		BEGIN
			UPDATE Invoices
			   SET CreditTotal = CreditTotal + (InvoiceTotal * .1) 
			 WHERE InvoiceID = @InvoiceIDVar;

			SET @UpdateCount = @UpdateCount + 1;
		END; 
		FETCH NEXT FROM Invoices_Cursor 
		INTO @InvoiceIDVar, @InvoiceTotalVar;
	END;
CLOSE Invoices_Cursor; 
DEALLOCATE Invoices_Cursor;
PRINT ''; 
PRINT CONVERT(varchar, @UpdateCount) + ' row(s) updated.';

-- p. 421 surround with snippets
DECLARE @i int = 1;
WHILE( @i <= 10 )
BEGIN

PRINT @i;
PRINT 'Hello World'; 
SET @i = @i + 1;

END


