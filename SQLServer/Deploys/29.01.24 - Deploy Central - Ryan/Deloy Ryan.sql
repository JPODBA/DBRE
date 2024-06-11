--DEPLOY RYAN
Use Ploomes_CRM
go

ALTER TABLE Account ADD [MaxColumnsExported] [int] NULL
ALTER TABLE Account ADD [MaxItemsExported] [int] NULL
GO
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)
GO
INSERT INTO Mapping_Column VALUES (305, 1,'MaxColumnsExported','MaxColumnsExported')
GO
INSERT INTO Mapping_Column VALUES (306, 1,'MaxItemsExported','MaxItemsExported')
GO


-- Shards all
Use Ploomes_CRM
go
ALTER TABLE Ploomes_Cliente ADD [MaxColumnsExported] [int] NULL
ALTER TABLE Ploomes_Cliente ADD [MaxItemsExported] [int] NULL
GO
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)