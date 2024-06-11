/*
    Script de subida da branch fix_add_whitelabelname_column
*/
USE Ploomes_CRM

ALTER TABLE Account
ADD WhiteLabelName [nvarchar](100) COLLATE Latin1_General_CI_AI NULL
GO
INSERT INTO Mapping_Column VALUES (303, 1,'WhiteLabelName','WhiteLabelName')
GO

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)