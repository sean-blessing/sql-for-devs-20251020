-- ch13 Views
-- p. 379
-- Create View VendorsMin
-- CREATE VIEW VendorsMin AS
--	SELECT VendorName, VendorState, VendorPhone 
--	  FROM Vendors;

-- use the view in a query
/*
SELECT *
  FROM VendorsMin
 WHERE VendorSTate = 'CA'
 ORDER BY VendorName;
*/

-- p. 383 
--CREATE VIEW VendorShortList AS
--SELECT VendorName, VendorContactLName, VendorContactFName, VendorPhone 
--  FROM Vendors
-- WHERE VendorID IN (SELECT VendorID FROM Invoices);

--SELECT *
-- FROM VendorShortList;

-- p. 385 - named columns
--CREATE VIEW OutstandingInvoices
--	(InvoiceNumber, InvoiceDate, InvoiceTotal, BalanceDue) AS
--	SELECT InvoiceNumber, InvoiceDate, InvoiceTotal, InvoiceTotal - PaymentTotal - CreditTotal
--	  FROM Invoices 
--	 WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0;

--SELECT *
--  FROM OutstandingInvoices;

-- p. 387 updateable view
--CREATE VIEW InvoiceCredit AS
--	SELECT InvoiceNumber, InvoiceDate, InvoiceTotal, PaymentTotal, CreditTotal 
--	  FROM Invoices
--     WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0;

-- p. name and schema for each table
SELECT t.name AS TableName, s.name AS SchemaName 
  FROM sys.tables t 
  JOIN sys.schemas s ON t.schema_id = s.schema_id; 