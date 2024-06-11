/*
    Script de rollback do deployment 16-1-2024
*/
USE Ploomes_CRM;
GO

-- down 1
-- https://app.asana.com/0/1177167803525649/1206206524814180/f
ALTER TABLE Ploomes_Cliente
DROP COLUMN [AllowAutomationsEdition]
GO

-- down 2
-- https://app.asana.com/0/1177167803525649/1206163463770840/f
ALTER TABLE WebHook_Log
DROP COLUMN [TimeSpanFromCreationToExecutionInMilliseconds]
GO

-- down 3
-- https://app.asana.com/0/626405171214145/1206282962374120/f
-- removido do pacote

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)
GO