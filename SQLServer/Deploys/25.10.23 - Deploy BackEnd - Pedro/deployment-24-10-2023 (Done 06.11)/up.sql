-- up 1
-- https://app.asana.com/0/1177167803525649/1205608400592910/f
UPDATE icfl
SET icfl.Name = 
CASE 
	WHEN icfl.Id = 23 THEN 'Disparado (LetsSign)'
	WHEN icfl.Id = 24 THEN 'Disparado (LetsSign)'
	WHEN icfl.Id = 25 THEN 'Disparado (LetsSign)'
	WHEN icfl.Id = 10023 THEN 'Sent (LetsSign)'
	WHEN icfl.Id = 10024 THEN 'Sent (LetsSign)'
	WHEN icfl.Id = 10025 THEN 'Sent (LetsSign)'
	WHEN icfl.Id = 20023 THEN 'Enviado (LetsSign)'
	WHEN icfl.Id = 20024 THEN 'Enviado (LetsSign)'
	WHEN icfl.Id = 20025 THEN 'Enviado (LetsSign)'
	WHEN icfl.Id = 30024 THEN 'Despedido (LetsSign)'
	WHEN icfl.Id = 30025 THEN 'Despedido (LetsSign)'
	WHEN icfl.Id = 30026 THEN 'Despedido (LetsSign)'
END
FROM Integration_CustomField_Language icfl
WHERE icfl.Id IN (23, 24, 25, 10023, 10024, 10025, 20023, 20024, 20025, 30024, 30025, 30026);


UPDATE icfl
SET icfl.Name = 
  CASE 
    WHEN icfl.Id = 26 THEN 'Id (LetsSign)'
    WHEN icfl.Id = 27 THEN 'Id (LetsSign)'
    WHEN icfl.Id = 28 THEN 'Id (LetsSign)'
    WHEN icfl.Id = 10026 THEN 'ID (LetsSign)'
    WHEN icfl.Id = 10027 THEN 'ID (LetsSign)'
    WHEN icfl.Id = 10028 THEN 'ID (LetsSign)'
    WHEN icfl.Id = 20026 THEN 'Id (LetsSign)'
    WHEN icfl.Id = 20027 THEN 'Id (LetsSign)'
    WHEN icfl.Id = 20028 THEN 'Id (LetsSign)'
    WHEN icfl.Id = 30027 THEN 'Identificación (LetsSign)'
    WHEN icfl.Id = 30028 THEN 'Identificación (LetsSign)'
    WHEN icfl.Id = 30029 THEN 'Identificación (LetsSign)'
  END
FROM Integration_CustomField_Language icfl
WHERE icfl.Id IN (26, 27, 28, 10026, 10027, 10028, 20026, 20027, 20028, 30027, 30028, 30029);


UPDATE icfl
SET icfl.Name = 
  CASE 
    WHEN icfl.Id = 32 THEN 'Assinado (LetsSign)'
    WHEN icfl.Id = 33 THEN 'Assinado (LetsSign)'
    WHEN icfl.Id = 34 THEN 'Assinado (LetsSign)'
    WHEN icfl.Id = 10032 THEN 'Signed (LetsSign)'
    WHEN icfl.Id = 10033 THEN 'Signed (LetsSign)'
    WHEN icfl.Id = 10034 THEN 'Signed (LetsSign)'
    WHEN icfl.Id = 20032 THEN 'Assinado (LetsSign)'
    WHEN icfl.Id = 20033 THEN 'Assinado (LetsSign)'
    WHEN icfl.Id = 20034 THEN 'Assinado (LetsSign)'
    WHEN icfl.Id = 30033 THEN 'Firmado (LetsSign)'
    WHEN icfl.Id = 30034 THEN 'Firmado (LetsSign)'
    WHEN icfl.Id = 30035 THEN 'Firmado (LetsSign)'
  END
FROM Integration_CustomField_Language icfl
WHERE icfl.Id IN (32, 33, 34, 10032, 10033, 10034, 20032, 20033, 20034, 30033, 30034, 30035);

UPDATE Integration_Callback_Language
SET Name = 'Copie y pegue la URL a continuación en la ubicación indicada en LetsSign'
WHERE Id = 30006;

UPDATE Integration_Callback_Language
SET Name = 'Copie e cole a URL abaixo no local indicado no LetsSign'
WHERE Id = 20005;

UPDATE Integration_Callback_Language
SET Name = 'Copy and paste the URL below into the location indicated in the LetsSign'
WHERE Id = 10005;

UPDATE Integration_Callback_Language
SET Name = 'Copie e cole a URL abaixo no local indicado no LetsSign'
WHERE Id = 5;

UPDATE Integration_Language
SET Description = 'LetsSign optimizes and automates the generation of contracts, quotes and documents. It simplifies the bureaucratic work of the legal department. <br> <br> Use LetsSign to collect signatures of contracts, quotes, and others. When generating any document in Ploomes, you will have a new button on the right side menu allowing the document to be launched for signing.'
WHERE Id = 10010;

-- up 2
-- https://app.asana.com/0/1177167803525649/1205608400592916/f
DELETE FROM Integration_CustomField_Language
WHERE Id IN (29, 30, 31, 10029, 10030, 10031, 20029, 20030, 20031, 30030, 30031, 30032);

DELETE FROM [Ploomes_CRM].[dbo].[Integration_CustomField]
WHERE [Id] IN (29, 30, 31);

-- up 3
-- https://app.asana.com/0/626405171214145/1205720133856440/f
-- removido do pacote

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)