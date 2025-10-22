-- ch09 Functions
SELECT 5;
SELECT 'Hello There';
SELECT '   SQL Server   ';
-- trim functions p. 241
SELECT LTRIM('           SQL SERVER    ');
SELECT RTRIM('           SQL SERVER    ');
SELECT TRIM('             SQL Server             ') AS Text;
SELECT LOWER('ABCD');
SELECT UPPER('AbCDefg');

SELECT LOWER(VendorName)
  FROM Vendors;

DECLARE @fullName VARCHAR(50) = 'Mr. Susan Alan Smith';
SELECT @fullName;
-- index and substring
-- where is the first space?
DECLARE @firstSpace INT = CHARINDEX(' ', @fullName);
SELECT 'First space is position ' + CAST(@firstSpace AS VARCHAR(20));
SELECT 'First name: ' +SUBSTRING(@fullName, @firstSpace + 1, 4);
DECLARE @secondSpace INT = CHARINDEX(' ', @fullName, @firstSpace + 1);
SELECT 'Second space is position ' + CAST(@secondSpace AS VARCHAR(20));
SELECT 'First name: ' + SUBSTRING(@fullName, @firstSpace +1, @secondSpace - @firstSpace - 1);

-- p. 243 sorting 
SELECT *
  FROM StringSample
 ORDER BY CAST(ID AS int);

-- p. 245 rounding
SELECT *, ROUND(SalesTotal, 0)
  FROM SalesTotals;

-- p. 249 Date Functions
SELECT GETDATE();
SELECT MONTH(GETDATE());
SELECT YEAR(GETDATE());
SELECT DAY(GETDATE());
SELECT DATEPART(month, GETDATE());
SELECT DATEPART(wk, GETDATE()) AS wk;
SELECT DATEPART(ww, GETDATE()) AS ww;
SELECT DATEPART(q, GETDATE()) AS q;
SELECT DATEPART(qq, GETDATE()) AS qq;

-- p. 263CASE Expressions
SELECT InvoiceNumber, TermsID, 
	CASE TermsID
		WHEN 1 THEN 'Net due 10 days' 
		WHEN 2 THEN 'Net due 20 days' 
		WHEN 3 THEN 'Net due 30 days' 
		WHEN 4 THEN 'Net due 60 days' 
		WHEN 5 THEN 'Net due 90 days'
		ELSE 'Error invalid'
	END AS Terms 
  FROM Invoices;

-- searched CASE expression
SELECT InvoiceNumber, InvoiceTotal, InvoiceDate, InvoiceDueDate, 
	CASE
		WHEN DATEDIFF(day, InvoiceDueDate, GETDATE()) > 30 THEN 'Over 30 days past due'
		WHEN DATEDIFF(day, InvoiceDueDate, GETDATE()) > 0 THEN '1 to 30 days past due' 
		ELSE 'Current'
	END AS Status 
  FROM Invoices 
 WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0;

-- p. 265 IF and IIF
/*
SELECT VendorID, SUM(InvoiceTotal) AS SumInvoices
--	IF (SUM(InvoiceTotal) < 1000)
--	ELSE (SELECT 'High') AS InvoiceRange
  FROM Invoices 
 GROUP BY VendorID;
*/

SELECT VendorID, SUM(InvoiceTotal) AS SumInvoices, 
	IIF(SUM(InvoiceTotal) < 1000, 'Low', 'High') AS InvoiceRange
  FROM Invoices 
 GROUP BY VendorID;

-- p. 265 CHOOSE
SELECT InvoiceNumber, InvoiceDate, InvoiceTotal,
	CHOOSE(TermsID, '10 days', '20 days', '30 days', '60 days', '90 days') AS NetDue
  FROM Invoices 
 WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0;

-- p. 267 COALESCE
SELECT PaymentDate, COALESCE(PaymentDate, '1900-01-01') AS NewDate 
  FROM Invoices;

SELECT VendorName,
	COALESCE(CAST(InvoiceTotal AS varchar), 'No invoices') AS InvoiceTotal 
  FROM Vendors v
  LEFT JOIN Invoices i ON v.VendorID = i.VendorID 
 ORDER BY VendorName;

-- p. 269 GROUPING
SELECT
CASE
WHEN GROUPING(VendorState) = 1 THEN 'All' ELSE VendorState END AS VendorState, CASE
WHEN GROUPING(VendorCity) = 1 THEN 'All' ELSE VendorCity END AS VendorCity, COUNT(*) AS QtyVendors
  FROM Vendors
 WHERE VendorState IN ('IA', 'NJ') GROUP BY VendorState, VendorCity 
WITH ROLLUP 
ORDER BY VendorState DESC, VendorCity DESC;

-- p. 271 GREATEST AND LEAST
SELECT
	LEAST(1,2,3) AS LeastNumber, 
	GREATEST(1,2,3) AS GreatestNumber, 
	LEAST('Apple','Bannana','Pear') AS LeastString, 
	GREATEST('Apple','Bannana','Pear') AS GreatestString, 
	LEAST(CONVERT(DATE, '2023-01-01'), CONVERT(DATE, '2023-01-31')) AS LeastDate, 
	GREATEST(CONVERT(DATE, '2023-01-01'),CONVERT(DATE, '2023-01-31')) AS GreatestDate;

-- p. 273 ROW_NUMBER(), partition by
SELECT ROW_NUMBER() OVER(ORDER BY VendorName) AS RowNumber, VendorName 
  FROM Vendors;

SELECT ROW_NUMBER() OVER(PARTITION BY VendorState ORDER BY VendorName) As RowNumber, 
	VendorName, VendorState
  FROM Vendors; 
