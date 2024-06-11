/*
    Script de rollback da branch fix_add_whitelabelname_column
*/
USE Ploomes_CRM
GO

-- down do up 1
ALTER TABLE Account
DROP COLUMN [AllowAutomationsEdition]
GO

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)