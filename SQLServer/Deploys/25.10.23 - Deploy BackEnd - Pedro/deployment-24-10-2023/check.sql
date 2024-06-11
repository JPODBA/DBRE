-- check up 2
-- Não deve retornar nada
SELECT TOP 1 * FROM Integration_CustomField_Language (NOLOCK) 
WHERE Id IN (29, 30, 31, 10029, 10030, 10031, 20029, 20030, 20031, 30030, 30031, 30032);
-- Não deve retornar nada
SELECT TOP 1 * FROM [Ploomes_CRM].[dbo].[Integration_CustomField] (NOLOCK) WHERE [Id] IN (29, 30, 31);

