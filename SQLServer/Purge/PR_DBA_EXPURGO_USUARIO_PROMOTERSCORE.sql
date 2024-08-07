use BA_DBA
go
CREATE or ALTER  PROC PR_DBA_EXPURGO_USUARIO_PROMOTERSCORE
	@Debug bit = 1, 
	@AccountId INT,
	@timeout  Time = '02:45',
	@Top INT
/************************************************************************
 Autor: Joao Paulo Oliveira / DBA
 Data de criacao: 07/08/2024
 Data de att:      
 Funcionalidade: Faz o Expurgo de dados da tabela USUARIO_PROMOTERSCORE do Ploomes_CRM. 
*************************************************************************/
AS
BEGIN
	SET NOCOUNT ON

	IF EXISTS (SELECT 1 FROM BA_DBA.DBO.DBA_LOG_EXPURGO WHERE AcountID = @AccountId AND SPROC = 'PR_DBA_EXPURGO_USUARIO_PROMOTERSCORE' AND CountFim = 0)
	BEGIN
		PRINT 'PR_DBA_EXPURGO_USUARIO_PROMOTERSCORE já zerou esse accountID. Segue o próximo!!'
		RETURN
	END

	DECLARE 
		@Data_Inicio		Datetime = null, 
		@Data_Fim			Datetime = null, 
		@CountLinhas_Inicio Int, 
		@CountLinhas_fim	Int,
		@ID_LogManutencao	Int,
		@MaxId				Int, 
		@MinId				Int, 
		@TimeNow            Time = getdate()
		

	DROP TABLE IF EXISTS #Temp_ID
	CREATE TABLE #Temp_ID (Id INT PRIMARY KEY)

	DROP TABLE IF EXISTS #Temp_Del
	CREATE TABLE #Temp_Del (Id INT PRIMARY KEY)


	-- # Nao temos o controle exato de quantas linhas sera, por isso o loop é muito bom e a melhor prática. 
	INSERT #Temp_ID (Id)
	SELECT DISTINCT T.Id
    FROM Ploomes_CRM.dbo.[USUARIO_PROMOTERSCORE] T
    JOIN Ploomes_CRM.dbo.[Usuario] U ON T.[UserId] = U.[ID]
    WHERE [U].[ID_ClientePloomes] = @AccountId
		
	-- Faz o COUNT inicial e valida ao vim para ter noção do quanto ficou faltando para determinado ID
	SELECT @CountLinhas_Inicio = COUNT(1) FROM #Temp_ID

	--- lOG Delete Historico  ------------------------------------------------------------------------------
	SELECT @Data_Inicio = getdate()

	INSERT BA_DBA.DBO.DBA_LOG_EXPURGO 
 	  (DataInicio, DataFim, SPROC, CountInicio, CountFim, AcountID)
	Select @Data_Inicio, null, 'PR_DBA_EXPURGO_USUARIO_PROMOTERSCORE', @CountLinhas_Inicio, null, @AccountId			
	
	SELECT @ID_LogManutencao = id FROM BA_DBA.DBO.DBA_LOG_EXPURGO WHERE DataInicio = @Data_Inicio and SPROC = 'PR_DBA_EXPURGO_USUARIO_PROMOTERSCORE'
	--- lOG Delete Historico  ------------------------------------------------------------------------------
	 
	
	IF(@Debug = 1)
	Begin
		Select 
			 @Data_Inicio		   as Data_Inicio		
			,@Data_Fim		       as Data_Fim			
			,@CountLinhas_Inicio   as CountLinhas_Inicio
			,@CountLinhas_fim	   as CountLinhas_fim	
			,@ID_LogManutencao     as ID_LogManutencao	
			,@MaxId			       as MaxId				
			,@MinId			       as MinId				
			,@TimeNow              as TimeNow    
		
		Select Count(1) as Temp_ID  From #Temp_ID 
	End
	

	WHILE EXISTS(SELECT 1 FROM #Temp_ID) and (@TimeNow < @timeout)
	BEGIN
			TRUNCATE TABLE #Temp_Del

			-- Margem do Loop para evitar OverHead
			INSERT #Temp_Del (Id)
			SELECT 
				TOP (convert(int, @Top)) ID  -- ERRO BIZARRO! Convert Resolveu.
			FROM #Temp_ID
			ORDER BY Id ASC            
			
			SELECT @MinId = min(id), @MaxId =  max(id) From #Temp_Del
						
			DELETE T
			FROM Ploomes_CRM.dbo.[USUARIO_PROMOTERSCORE] T 
			JOIN #Temp_Del			          TDel ON [T].ID = TDel.Id
			WHERE [T].ID >= @MinId 
			  AND [T].ID <= @MaxId            
      
			DELETE Temp_AccountID
			FROM #Temp_ID  Temp_AccountID 
			JOIN #Temp_Del Temp_Del ON Temp_Del.ID = Temp_AccountID.Id

			Select @TimeNow = Getdate()
	END
	
	--- lOG Delete Hist�rico -----------------------------------------------------
	SELECT @Data_Fim = getdate()
	SELECT @CountLinhas_fim = COUNT(1) FROM #Temp_ID  -- Tem que ser 0 se concluir até as 02:45

	UPDATE BA_DBA.DBO.DBA_LOG_EXPURGO 
	SET DataFim = @Data_Fim, CountFim = @CountLinhas_fim
	WHERE id = @ID_LogManutencao
	--- lOG Delete Hist�rico -----------------------------------------------------

	DROP TABLE IF EXISTS #Temp_ID
	DROP TABLE IF EXISTS Temp_Del
	
END -- Proc


