/*
    Script de verificação do deployment 6-2-2024
*/
USE Ploomes_CRM;
GO

-- Check 1
-- https://app.asana.com/0/626405171214145/1206151195204053/f
-- Deve trazer a nova coluna Ordination criada
SELECT TOP 1 Ordination, * FROM Checklist_Field_Condition;

-- Check 2
-- https://app.asana.com/0/626405171214145/1206254038864851/f
-- Deve trazer a propriedade do campo ID 1057 como false
SELECT EDITAVEL, * FROM CampoFixo2 WHERE ID = 1057