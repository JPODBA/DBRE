/*
    scrip de subida do deploy 23-11-2023
*/
USE Ploomes_CRM;
GO

-- Up 1
-- https://app.asana.com/0/1177167803525649/1204217502986727/f
DELETE FROM Icon WHERE ID = 121

DECLARE @DeletedId INT = 121, @ContinuedId INT = 120;

UPDATE Oportunidade_Funil
SET IconId = @ContinuedId
WHERE IconId = @DeletedId

UPDATE Integration_Button
SET IconId = @ContinuedId
WHERE IconId = @DeletedId

UPDATE Email_Folder
SET IconId = @ContinuedId
WHERE IconId = @DeletedId

UPDATE Ploomes_Cliente
SET DealsModuleIconId = @ContinuedId
WHERE DealsModuleIconId = @DeletedId

UPDATE Ploomes_Cliente
SET ContactsProductsModuleIconId = @ContinuedId
WHERE ContactsProductsModuleIconId = @DeletedId

UPDATE Ploomes_Cliente
SET LibraryModuleIconId = @ContinuedId
WHERE LibraryModuleIconId = @DeletedId

-- Up 2
-- https://app.asana.com/0/626405171214145/1205428709444781/f
UPDATE CampoFixo2
SET Editavel = 0
WHERE ID = 1375