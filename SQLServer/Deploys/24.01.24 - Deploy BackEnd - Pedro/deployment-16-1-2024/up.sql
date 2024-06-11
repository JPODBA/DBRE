/*
    Script de subida do deployment 16-1-2024
*/
USE Ploomes_CRM;
GO

-- up 1
-- https://app.asana.com/0/1177167803525649/1206206524814180/f
ALTER TABLE Ploomes_Cliente
ADD [AllowAutomationsEdition] [bit] NULL
GO

-- up 2
-- https://app.asana.com/0/1177167803525649/1206163463770840/f
ALTER TABLE WebHook_Log
ADD [TimeSpanFromCreationToExecutionInMilliseconds] [int] NULL
GO

-- up 3
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