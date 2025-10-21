-- ch05 aggregates / summary queries
SELECT *
  FROM Invoices;

-- count unpaid invoices and calculate the total due
-- unpaid invoice: (invoicetotal - payments total - credit total) > 0
SELECT count(*) AS NumberOfInvoices, 
	   SUM(InvoiceTotal - PaymentTotal - CreditTotal) AS TotalDue
  FROM Invoices
 WHERE (InvoiceTotal - PaymentTotal - CreditTotal) > 0;

SELECT COUNT(*)
  FROM Invoices;

  -- p. 139 Count, Avg, Sum
SELECT 'After 1/1/2023' AS SelectionDate, COUNT(*) AS NumberOfInvoices, 
       AVG(InvoiceTotal) AS AverageInvoiceAmount, 
	   SUM(InvoiceTotal) AS TotalInvoiceAmount
  FROM Invoices 
 WHERE InvoiceDate > '2023-01-01';

--p. 141 group by and having clauses
SELECT *
  FROM Invoices
 ORDER BY VendorID;

-- what is the average invoice amount per vendor
SELECT VendorID, AVG(InvoiceTotal) AS AverageInvoiceAmount 
  FROM Invoices 
 GROUP BY VendorID
 HAVING AVG(InvoiceTotal) > 2000 
 ORDER BY AverageInvoiceAmount DESC;

-- p. 143 # of invoices by vendor
SELECT VendorId, count(*) AS InvoiceQty
  FROM Invoices
 GROUP BY VendorID;

-- number of invoices and the average invoice amount 
-- for the vendors in each state and city
SELECT VendorState, VendorCity, COUNT(*) AS InvoiceQty, 
       AVG(InvoiceTotal) AS InvoiceAvg 
  FROM Invoices i 
  JOIN Vendors v ON i.VendorID = v.VendorID 
 GROUP BY VendorState, VendorCity 
 HAVING COUNT(*) > 1
 ORDER BY VendorState, VendorCity;

-- p. 145
SELECT VendorName, COUNT(*) AS InvoiceQty, AVG(InvoiceTotal) AS InvoiceAvg 
  FROM Vendors 
  JOIN Invoices ON Vendors.VendorID = Invoices.VendorID 
 GROUP BY VendorName
HAVING AVG(InvoiceTotal) > 500 
 ORDER BY InvoiceQty DESC;

 -- same query with WHERE instead of HAVING
SELECT VendorName, COUNT(*) AS InvoiceQty, AVG(InvoiceTotal) AS InvoiceAvg 
  FROM Vendors 
  JOIN Invoices ON Vendors.VendorID = Invoices.VendorID 
 WHERE InvoiceTotal > 500 
 GROUP BY VendorName
 ORDER BY InvoiceQty DESC;

-- p. 147
SELECT InvoiceDate, COUNT(*) AS InvoiceQty, SUM(InvoiceTotal) AS InvoiceSum 
  FROM Invoices 
 GROUP BY InvoiceDate
HAVING InvoiceDate BETWEEN '2023-01-01' AND '2023-01-31' 
   AND COUNT(*) > 1
   AND SUM(InvoiceTotal) > 100 
 ORDER BY InvoiceDate DESC;

 -- same query w/ a where clause
SELECT InvoiceDate, COUNT(*) AS InvoiceQty, SUM(InvoiceTotal) AS InvoiceSum 
  FROM Invoices
 WHERE InvoiceDate BETWEEN '2023-01-01' AND '2023-01-31' 
 GROUP BY InvoiceDate 
HAVING COUNT(*) > 1
   AND SUM(InvoiceTotal) > 100 
 ORDER BY InvoiceDate DESC;

 -- p. 149 ROLLUP
 -- A summary query that includes a summary row for each grouping level
SELECT VendorState, VendorCity, COUNT(*) AS QtyVendors 
  FROM Vendors
 WHERE VendorState IN ('IA', 'NJ') 
 GROUP BY ROLLUP (VendorState, VendorCity)
 ORDER BY VendorState DESC, VendorCity DESC;

-- CUBE p. 151
SELECT VendorState, VendorCity, COUNT(*) AS QtyVendors 
  FROM Vendors
 WHERE VendorState IN ('IA', 'NJ') 
 GROUP BY CUBE (VendorState, VendorCity)
 ORDER BY VendorState DESC, VendorCity DESC;

-- p. 153 GROUPING SETS
SELECT VendorState, VendorCity, COUNT(*) AS QtyVendors 
  FROM Vendors
 WHERE VendorState IN ('IA', 'NJ', 'OH') 
 GROUP BY GROUPING SETS (VendorState, VendorCity)
 ORDER BY VendorState DESC, VendorCity DESC;


