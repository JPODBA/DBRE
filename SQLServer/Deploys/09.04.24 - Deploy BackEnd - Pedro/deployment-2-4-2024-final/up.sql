-- Script de subida do pacote deployment-2-4-2024
USE Ploomes_CRM

-- UP 1 https://app.asana.com/0/626405171214145/1206145177853109/f
INSERT INTO Automation_AllowedEntity_Action VALUES (71,4,10)
INSERT INTO Automation_AllowedEntity_Action VALUES (72,7,10)
INSERT INTO Automation_AllowedEntity_Action VALUES (73,12,10)
INSERT INTO Automation_AllowedEntity_Action VALUES (74,66,10)
INSERT INTO Automation_AllowedEntity_Action VALUES (75,2,2)
INSERT INTO Automation_AllowedEntity_Action VALUES (76,2,3)

-- UP 2 https://app.asana.com/0/1177167803525649/1206753790585228/f
ALTER TABLE [Integration_Field] ADD [MaxValue] [int] NULL

UPDATE [Integration_Field]
SET [MaxValue] = 1000
WHERE [Id] = 174

UPDATE [Ploomes_Cliente_Integration_Field_Value]
SET [IntegerValue] = 1000
WHERE [FieldId] = 174 AND [Integervalue] > 1000

GO
-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)