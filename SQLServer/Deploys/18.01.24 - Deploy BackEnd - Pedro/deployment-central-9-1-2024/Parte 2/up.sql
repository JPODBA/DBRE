/*
    Script de subida da branch fix_add_whitelabelname_column
*/
USE Ploomes_CRM

-- garante que a coluna existe na central
SELECT TOP 1 WhiteLabelName FROM Account
GO
INSERT INTO Mapping_Column VALUES (303, 1,'WhiteLabelName','WhiteLabelName')
GO
