-- ch6 - Subqueries
-- p. 161 subquery in the where clase
-- invoices whose invoiceTotal is > avg invoiceTotal
SELECT InvoiceNumber, InvoiceDate, InvoiceTotal
  FROM Invoices
 WHERE InvoiceTotal > 
	(SELECT AVG(InvoiceTotal)
	   FROM Invoices)
 ORDER BY InvoiceTotal;

SELECT AVG(InvoiceTotal)
  FROM Invoices;

-- p. 163 inner join vs subquery
-- inner join - vendors in CA, show 3 cols
SELECT InvoiceNumber, InvoiceDate, InvoiceTotal 
  FROM Invoices i 
  JOIN Vendors v ON i.VendorID = v.VendorID 
 WHERE VendorState = 'CA' 
 ORDER BY InvoiceDate;

-- subquery version
SELECT InvoiceNumber, InvoiceDate, InvoiceTotal 
  FROM Invoices 
 WHERE VendorID IN 
	(SELECT VendorID FROM Vendors
	  WHERE VendorState = 'CA') 
ORDER BY InvoiceDate;

--p. 165
-- vendors without invoices
SELECT VendorID, VendorName, VendorState 
  FROM Vendors
 WHERE VendorID NOT IN
	(SELECT DISTINCT VendorID FROM Invoices);

-- same thing w/ a join
SELECT v.VendorID, VendorName, VendorState 
  FROM Vendors v
  LEFT JOIN Invoices i ON v.VendorID = i.VendorID 
 WHERE i.VendorID IS NULL;

-- p. 169 ALL Keyword
-- invoices larger than the largest invoice
SELECT VendorName, InvoiceNumber, InvoiceTotal 
  FROM Invoices i 
  JOIN Vendors v ON i.VendorID = v.VendorID 
 WHERE InvoiceTotal > ALL 
	(SELECT InvoiceTotal 
	   FROM Invoices
	  WHERE VendorID = 34) 
 ORDER BY VendorName;

 SELECT VendorName, InvoiceNumber, InvoiceTotal 
  FROM Invoices i 
  JOIN Vendors v ON i.VendorID = v.VendorID 
 WHERE InvoiceTotal >  
	(SELECT MAX(InvoiceTotal) 
	   FROM Invoices
	  WHERE VendorID = 34) 
 ORDER BY VendorName;

-- p. 175 EXISTS
SELECT VendorID, VendorName, VendorState 
  FROM Vendors v 
 WHERE NOT EXISTS 
	(SELECT * FROM Invoices i WHERE i.VendorID = v.VendorID);

-- p. 177 subquery in the FROM clause
SELECT i.VendorID, MAX(InvoiceDate) AS LatestInv, 
	AVG(InvoiceTotal) AS AvgInvoice 
  FROM Invoices i 
  JOIN
	(SELECT TOP 5 VendorID, AVG(InvoiceTotal) AS AvgInvoice 
	   FROM Invoices 
	  GROUP BY VendorID 
	  ORDER BY AvgInvoice DESC) tv 
	  ON i.VendorID = tv.VendorID  --tv -> TopVendor
GROUP BY i.VendorID 
ORDER BY LatestInv DESC;

