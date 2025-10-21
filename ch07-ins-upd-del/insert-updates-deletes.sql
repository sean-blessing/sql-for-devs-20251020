-- ch07 insert, update, delete

-- create a copy of a table
SELECT *
  INTO CopyTerms
  FROM Terms;
SELECT *
  FROM CopyTerms;

INSERT INTO CopyTerms (TermsDescription, TermsDueDays)
	VALUES ('Test Net Due XX Days', 100);

-- delete the bad data
-- DELETE
--  FROM CopyTerms
--  WHERE TermsDescription LIKE 'Test%';
--DELETE
--  FROM CopyTerms
-- WHERE TermsID = 15;

INSERT INTO CopyTerms (TermsDescription, TermsDueDays)
VALUES 
	('Test1', 200),
	('Test2', 210),
	('Test3', 220),
	('Test4', 230),
	('Test5', 240),
	('Test6', 250);

-- UPDATE
-- update id 17 'Net due 120 days', 120
UPDATE CopyTerms
   SET TermsDescription = 'Net due 120 days',
       TermsDueDays = 120
 WHERE TermsID = 17;

 DELETE
   FROM CopyTerms
  WHERE TermsID > 17;

-- p. 294 / 207 Referential/Data Integrity Violation
SELECT *
  FROM Vendors;
SELECT *
  FROM Invoices;

DELETE
  FROM Vendors
 WHERE VendorID = 122;

