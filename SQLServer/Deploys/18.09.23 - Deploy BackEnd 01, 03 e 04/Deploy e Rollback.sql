-- UP
INSERT INTO WebHook_Action (id, RestrictedEntityId, Name)
VALUES
(29, 4, 'Share'),
(30, 7, 'Share'),
(31, 66, 'Share')

ALTER TABLE Automation_Action
ADD [ShouldGenerateDocument] [bit] NULL
GO

DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)


-- DOWN -- Rollback

--DELETE WebHook_Action 
--WHERE ID IN (29, 30, 31)

--ALTER TABLE Automation_Action
--DROP COLUMN [ShouldGenerateDocument]
--GO

--DECLARE @sqlcmd NVARCHAR(MAX) = ''
--SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
--' 
--FROM sys.objects AS so 
--WHERE so.type = 'V' 

--EXEC(@sqlcmd)