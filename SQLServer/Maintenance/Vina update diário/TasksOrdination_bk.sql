USE Ploomes_CRM
GO

DECLARE @UserId INT, @Qtd INT

DECLARE UserCursor CURSOR FOR
	SELECT U.ID, COUNT(1) as Qtd
		FROM Tarefa T INNER JOIN Tarefa_Usuario TU ON T.ID = TU.ID_Tarefa
			INNER JOIN Usuario U ON TU.ID_Usuario = U.ID AND U.Integracao = 0
			INNER JOIN Tarefa_Conclusao TC ON T.ID = TC.ID_Tarefa AND T.Suspenso = 'False' AND TC.Concluido = 'False' AND DATEDIFF(day, GETDATE(), TC.DataRecorrencia) <= 0
		GROUP BY U.ID
		
OPEN UserCursor
FETCH NEXT FROM UserCursor INTO @UserId, @Qtd
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE Usuario SET TasksCounter = @Qtd WHERE ID = @UserId
	
	
FETCH NEXT FROM UserCursor INTO @UserId, @Qtd
END
CLOSE UserCursor
DEALLOCATE UserCursor
GO

DECLARE @TaskId INT

DECLARE TaskCursor CURSOR FOR
	SELECT TC.ID
		FROM Tarefa T INNER JOIN Tarefa_Conclusao TC ON T.ID = TC.ID_Tarefa AND T.Suspenso = 'False' AND TC.Concluido = 'False' AND DATEDIFF(day, GETDATE(), TC.DataRecorrencia) <= 0 AND ISNULL(TC.Pending, 0) = 0
		ORDER BY ID DESC
		
OPEN TaskCursor
FETCH NEXT FROM TaskCursor INTO @TaskId
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @TaskId
	UPDATE Tarefa_Conclusao SET Pending = 1 WHERE ID = @TaskId


	
FETCH NEXT FROM TaskCursor INTO @TaskId
END
CLOSE TaskCursor
DEALLOCATE TaskCursor
GO


DECLARE @ContactId INT

DECLARE ContactsCursor CURSOR FOR
	SELECT ID FROM Cliente WHERE Data_PrimeiraTarefa IS NOT NULL AND DATEDIFF(day, Data_PrimeiraTarefa, GETDATE()) = 0
		
OPEN ContactsCursor
FETCH NEXT FROM ContactsCursor INTO @ContactId
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE Cliente SET OrdemTarefas = 1 WHERE ID = @ContactId
	
FETCH NEXT FROM ContactsCursor INTO @ContactId
END
CLOSE ContactsCursor
DEALLOCATE ContactsCursor
GO

DECLARE @DealId INT
DECLARE DealsCursor CURSOR FOR
	SELECT ID FROM Oportunidade WHERE Data_PrimeiraTarefa IS NOT NULL AND DATEDIFF(day, Data_PrimeiraTarefa, GETDATE()) = 0
		
OPEN DealsCursor
FETCH NEXT FROM DealsCursor INTO @DealId
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE Oportunidade SET OrdemTarefas = 1 WHERE ID = @DealId
	
FETCH NEXT FROM DealsCursor INTO @DealId
END
CLOSE DealsCursor
DEALLOCATE DealsCursor
GO

-------------------------------------------------------------------------------------

--DECLARE @IndexName NVARCHAR(300), @TableName NVARCHAR(300)
--DECLARE IndexesCursor CURSOR FOR
--	SELECT I.name as 'Index',
--		T.name as 'Table'
--		FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS DDIPS
--		INNER JOIN sys.tables T on T.object_id = DDIPS.object_id
--		INNER JOIN sys.schemas S on T.schema_id = S.schema_id
--		INNER JOIN sys.indexes I ON I.object_id = DDIPS.object_id
--		AND DDIPS.index_id = I.index_id
--		WHERE DDIPS.database_id = DB_ID()
--		and I.name is not null
--		AND DDIPS.avg_fragmentation_in_percent > 50 AND DDIPS.page_count > 100
--		ORDER BY DDIPS.avg_fragmentation_in_percent desc

--OPEN IndexesCursor
--FETCH NEXT FROM IndexesCursor INTO @IndexName, @TableName
--WHILE @@FETCH_STATUS = 0
--BEGIN
--	DECLARE @Statement NVARCHAR(MAX) = 'ALTER INDEX ' + @IndexName + ' ON ' + @TableName + ' REBUILD'

--	EXECUTE sp_executesql @Statement

--	PRINT @IndexName

--	FETCH NEXT FROM IndexesCursor INTO @IndexName, @TableName
--END
--CLOSE IndexesCursor
--DEALLOCATE IndexesCursor
--GO