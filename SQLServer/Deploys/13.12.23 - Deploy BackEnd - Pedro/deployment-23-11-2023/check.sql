/*
    scrip de confirmação do deploy 23-11-2023
*/
USE Ploomes_CRM;
GO

-- Check do up 1
-- Não deve retornar nada em nenhum dos SELECT
DECLARE @DeletedId INT = 121;
SELECT * FROM Icon WHERE ID = @DeletedId;
SELECT * FROM Oportunidade_Funil WHERE IconId = @DeletedId;
SELECT * FROM Integration_Button WHERE IconId = @DeletedId;
SELECT * FROM Email_Folder WHERE IconId = @DeletedId;
SELECT * FROM Ploomes_Cliente 
    WHERE DealsModuleIconId = @DeletedId
        OR ContactsProductsModuleIconId = @DeletedId
        OR LibraryModuleIconId = @DeletedId;


-- Check do up 2
-- Deve retornar 0
SELECT Editavel FROM CampoFixo2 WHERE ID = 1375;