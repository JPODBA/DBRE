USE Ploomes_CRM
GO

-------------------------------------------------------------------------------------------------------------------------------------
PRINT 'Usuario'

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

-------------------------------------------------------------------------------------------------------------------------------------
PRINT 'Tarefa_Conclusao'

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


-------------------------------------------------------------------------------------------------------------------------------------
PRINT 'Cliente'

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


-------------------------------------------------------------------------------------------------------------------------------------
PRINT 'Oportunidade'
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