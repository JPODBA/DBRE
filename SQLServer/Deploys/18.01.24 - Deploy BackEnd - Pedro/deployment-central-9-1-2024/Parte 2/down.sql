/*
    Script de rollback da branch fix_add_whitelabelname_column
*/
USE Ploomes_CRM

ALTER TABLE Account
DROP COLUMN WhiteLabelName
GO
DELETE FROM Mapping_Column WHERE ID = 303
GO

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)