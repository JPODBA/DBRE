-- Script de verificação do pacote deployment-2-4-2024
USE Ploomes_CRM

-- Check do UP 1
-- Precisa retornar 4
SELECT count(*) FROM Automation_AllowedEntity_Action where id in (71, 72, 73, 74)

-- Check do UP 2
-- Precisa retornar algo para garantir que a coluna foi criada
SELECT TOP 1 MaxValue FROM Integration_Field
-- Tem que retornar 1000
SELECT MaxValue FROM Integration_Field WHERE ID = 174
-- Não deve retornar nada
SELECT 1 FROM Ploomes_Cliente_Integration_Field_Value WHERE IntegerValue > 1000 AND FieldId = 174