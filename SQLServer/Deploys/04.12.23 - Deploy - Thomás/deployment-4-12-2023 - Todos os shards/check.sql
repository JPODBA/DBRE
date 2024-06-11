-- check up 1
-- Deve retornar 1
SELECT TOP 1 * FROM Integration_Field (NOLOCK) 
WHERE Id = 189;
-- Deve retornar 4
SELECT TOP 1 * FROM [Ploomes_CRM].[dbo].[Integration_Field_Language] (NOLOCK) WHERE FieldId = 189;
