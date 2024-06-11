/*
    Script de subida da branch fix_add_whitelabelname_column
*/
USE Ploomes_CRM
GO

-- up 1
-- https://app.asana.com/0/1177167803525649/1206206524814180/f
ALTER TABLE Account
ADD [AllowAutomationsEdition] [bit] NULL
GO

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)