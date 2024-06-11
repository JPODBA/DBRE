-- Down up 1
DELETE FROM Integration_Field WHERE Id = 189
GO

DELETE FROM Integration_Field_Language WHERE Id IN (189, 10189, 20189, 30189)
go