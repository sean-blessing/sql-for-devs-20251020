-- make TermsID in Terms table a PK
USE AP;
GO

-- alter stmt
ALTER TABLE CopyTerms
ADD CONSTRAINT PK_CopyTerms PRIMARY KEY (TermsID);