-- up 1
-- https://app.asana.com/0/1177167803525649/1205102256431596/f
ALTER TABLE Mapping_Table ADD [EntityId] [int] NULL;
UPDATE Mapping_Table SET
EntityId = 74
WHERE id = 14;
UPDATE Mapping_Table SET
EntityId = 15
WHERE id = 1;
UPDATE Mapping_Table SET
EntityId = 22
WHERE id = 8;

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)