-- chap 03

-- p. 65 all data from invoices table
SELECT *
  FROM Invoices;

-- select a few columns from invoices and sort by invoice total ascending
SELECT InvoiceNumber, InvoiceDate, InvoiceTotal
  FROM Invoices
 ORDER BY InvoiceTotal;

 SELECT InvoiceNumber, InvoiceDate, InvoiceTotal
  FROM Invoices
 ORDER BY InvoiceTotal DESC;

-- calculated value for a specific row (AS is optional)
SELECT InvoiceID, InvoiceTotal, CreditTotal + PaymentTotal TotalCredits
  FROM Invoices
 WHERE InvoiceID = 98;

-- invoices between given dates?
 SELECT InvoiceNumber, InvoiceDate, InvoiceTotal
  FROM Invoices
 WHERE InvoiceDate BETWEEN '2023-01-01' AND '2023-03-31'
 ORDER BY InvoiceDate;

-- empty result set returned
SELECT *
  FROM Invoices
 WHERE InvoiceTotal > 50000
 ORDER BY InvoiceTotal DESC;

-- whats the balance due for each invoice? p. 67
SELECT InvoiceNumber, InvoiceTotal - (PaymentTotal + CreditTotal) AS BalanceDue
  FROM Invoices;

-- what invoices have a balance due?
SELECT InvoiceNumber, InvoiceTotal - (PaymentTotal + CreditTotal) AS BalanceDue
  FROM Invoices
 WHERE InvoiceTotal - (PaymentTotal + CreditTotal) > 0
 ORDER BY BalanceDue;

-- concatenation - vendor contact full names
SELECT VendorContactLName + ', ' + VendorContactFName
  FROM Vendors;

SELECT CONCAT(VendorContactLName, ', ', VendorContactFName)
  FROM Vendors;

SELECT InvoiceNumber, InvoiceDate, GETDATE()
  FROM Invoices;

-- p. 69 Named columns
SELECT InvoiceNumber AS [Invoice Number],
	   InvoiceDate AS Date,
	   InvoiceTotal Total
  FROM Invoices;

-- p. 71 including apostrophes in string literal values
-- ex: VendorA's Address: 111 Street Ave.
SELECT VendorName + '''s Address: ' + VendorCity + ', ' + 
	   VendorState + ' ' +VendorZipCode
  FROM Vendors;

-- p. 73 order of operation and parenthesis
SELECT InvoiceID,
	   InvoiceID + 7 * 3 AS OrderOfPrecedence,
	   (InvoiceID + 7) * 3 AS AddFirst
  FROM Invoices
 ORDER BY InvoiceId;

 SELECT InvoiceID,
	   InvoiceID / 10 AS Quotient,
	   InvoiceID % 10 AS Remainder
  FROM Invoices
 ORDER BY InvoiceId;

-- p. 75 LEFT Function
SELECT VendorContactFName, VendorContactLName, 
       LEFT(VendorContactFName, 1) +
	   LEFT(VendorContactLName, 1) AS Initials
  FROM Vendors;

-- p. 75 CONVERT function
-- change yyyy-mm-dd to mm/dd/yy
-- Make paymentTotal currency
SELECT InvoiceId, 
	   CONVERT(char(8), PaymentDate, 1),
	   '$' + CONVERT(varchar(9), PaymentTotal, 1)
  FROM Invoices;

-- p. 75 Age of invoices
SELECT InvoiceDate, GETDATE() AS [Today's Date],
		DATEDIFF(year, InvoiceDate,GETDATE()) AS AgeInYears
  FROM Invoices;

-- p. 77 DISTINCT keyword
-- all vendors city, state
SELECT DISTINCT VendorCity, VendorState
  FROM Vendors
 ORDER BY VendorCity, VendorState;

-- p. 79 TOP
SELECT TOP 5 *
  FROM Invoices
 ORDER BY InvoiceTotal DESC;

SELECT TOP 10 PERCENT *
  FROM Invoices
 ORDER BY InvoiceTotal DESC;

-- p. 81 WHERE clauses...
SELECT * 
  FROM Vendors
 WHERE VendorState = 'OH';

-- vendors with names from A to L
SELECT *
  FROM Vendors
 WHERE VendorName < 'M'
 ORDER BY VendorName;

-- invoices w/ credits not equal to 0
SELECT *
  FROM Invoices
 WHERE CreditTotal <> 0;

-- p. 83 logical operators - vendors NOT in California
SELECT *
  FROM Vendors
 WHERE NOT VendorState = 'CA';

SELECT *
  FROM Vendors
 WHERE NOT VendorState = 'CA'
   AND VendorPhone IS NOT NULL;

-- combine AND and OR
SELECT *
  FROM Invoices
 WHERE (InvoiceDate > '01/01/2023'
    OR InvoiceTotal > 500)
   AND InvoiceTotal - PaymentTotal - CreditTotal > 0;

-- p. 85 IN Clause
SELECT *
  FROM Terms
 WHERE TermsID = 1
    OR TermsID = 3
	OR TermsID = 4;

SELECT *
  FROM Terms
 WHERE TermsID in (1, 3, 4);

SELECT *
  FROM Vendors
 WHERE VendorState NOT IN ('CA', 'NV', 'OR')
 ORDER BY VendorState;

-- p. 87 BETWEEN & NOT - zips not in a range
SELECT *
  FROM Vendors
 WHERE VendorZipCode NOT BETWEEN 93600 and 93799
 ORDER BY VendorZipCode;

-- p. 89 where values are 'like' San...
SELECT *
  FROM Vendors
 WHERE VendorCity LIKE 'San%'
 ORDER BY VendorCity;

-- vendor names like ...
SELECT *
  FROM Vendors
 WHERE VendorName LIKE 'COMPU_ER%';

 -- p. 89
 -- VendorState NC and NJ but not NV or NY
 SELECT *
   FROM Vendors
   WHERE VendorState LIKE 'N[A-J]';

-- zip codes that start with a leading zero
SELECT *
  FROM Vendors
 WHERE VendorZipCode LIKE '0%';

SELECT *
  FROM Vendors
 WHERE VendorZipCode NOT LIKE '[1-9]%';

-- p. 91 Examples DB - NULL values
SELECT *
  FROM NullSample;

-- zero values
SELECT *
  FROM NullSample
  WHERE InvoiceTotal = 0;

-- non-zero values
SELECT *
  FROM NullSample
 WHERE InvoiceTotal <> 0;

-- null values
SELECT *
  FROM NullSample
 WHERE InvoiceTotal IS NULL;

 -- NOT NULL
 SELECT *
  FROM NullSample
 WHERE InvoiceTotal IS NOT NULL;

-- p. 95 ORDER BY using an expression
SELECT VendorName, VendorCity + ', ' + VendorState + ' ' + VendorZipCode AS Address
  FROM Vendors
 Order by 2, 1;

-- p. 97 retrieving first x rows by offset
SELECT VendorID, InvoiceTotal
  FROM Invoices
 ORDER BY InvoiceTotal DESC
	OFFSET 0 ROWS
	FETCH FIRST 5 ROWS ONLY;

-- retrieve rows 11 through 20
SELECT VendorID, InvoiceTotal
  FROM Invoices
 ORDER BY InvoiceTotal DESC
	OFFSET 10 ROWS
	FETCH NEXT 10 ROWS ONLY;
