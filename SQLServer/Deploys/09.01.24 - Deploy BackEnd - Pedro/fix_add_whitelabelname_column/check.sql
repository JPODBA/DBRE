/*
    Script de verificação da branch fix_add_whitelabelname_column
*/
USE Ploomes_CRM

-- Deve retornar ao menos NULL
SELECT TOP 1 WhiteLabelName from Account
GO

-- Deve retornar (303, 1,'WhiteLabelName','WhiteLabelName')
SELECT * FROM Mapping_Column WHERE Id = 303
