/*
    Script de rollback do deployment 6-2-2024
*/
USE Ploomes_CRM;
GO

-- Up 1
-- https://app.asana.com/0/626405171214145/1206151195204053/f
ALTER TABLE [Checklist_Field_Condition]
DROP COLUMN [Ordination];
GO

-- Up 2
-- https://app.asana.com/0/626405171214145/1206254038864851/f
UPDATE CampoFixo2
SET Editavel = 1
WHERE ID = 1057;
GO

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)
GO

-- Update LastUpdateDate
UPDATE Campo_Tabela_LastUpdate 
SET LastUpdateDate = GETDATE() 
WHERE EntityId = 77