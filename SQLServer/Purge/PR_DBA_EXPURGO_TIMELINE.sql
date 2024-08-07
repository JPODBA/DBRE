use BA_DBA
go
CREATE or ALTER  PROC PR_DBA_EXPURGO_TIMELINE
	@Debug bit = 1, 
	@AccountId INT,
	@timeout  Time = '02:45',
	@Top INT
/************************************************************************
 Autor: Joao Paulo Oliveira \ DBA
 Data de criacao: 22/03/2024
 Data de att:      
 Funcionalidade: Faz o Expurgo de dados da tabela TIMELINE do Ploomes_CRM. 
*************************************************************************/
AS
BEGIN
	SET NOCOUNT ON

	IF EXISTS (SELECT 1 FROM BA_DBA.DBO.DBA_LOG_EXPURGO WHERE AcountID = @AccountId AND SPROC = 'PR_DBA_EXPURGO_TIMELINE' AND CountFim = 0)
	BEGIN
		PRINT 'PR_DBA_EXPURGO_TIMELINE já  zerou esse accountID. Segue o próximo!'
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
		

	-- # Carrega as AccountID. Para carregar os IDs uma vez so e fazer o loop sem precisar ficar voltando. 
	DROP TABLE IF EXISTS #TempTimeline
	CREATE TABLE #TempTimeline (Id INT PRIMARY KEY)

	-- # Uma tabela Del para o JOIN com a Quente e delete da #TempTimeline. É mais performático que direto do quente ou com a  #TempTimeline.
	DROP TABLE IF EXISTS #TempTimelineDel
	CREATE TABLE #TempTimelineDel (Id INT PRIMARY KEY)

	-- # Nao temos o controle exato de quantas linhas sera, por isso o loop é muito bom e melhor prática. 
	INSERT #TempTimeline (Id)
	SELECT  
		[T].Id
	FROM Ploomes_CRM.dbo.[Timeline] T (nolock)
	WHERE [T].[ID_ClientePloomes] = @AccountId   

	-- Sempre faz um count para seguirmos monitorando quanto foi deletado. 
	SELECT 
		@CountLinhas_Inicio = COUNT(1) 
	FROM Ploomes_CRM.dbo.Timeline (nolock) WHERE [ID_ClientePloomes] = @AccountId 


	--- lOG Delete Historico  ------------------------------------------------------------------------------
	SELECT @Data_Inicio = getdate()

	INSERT BA_DBA.DBO.DBA_LOG_EXPURGO 
 	  (DataInicio, DataFim, SPROC, CountInicio, CountFim, AcountID)
	Select @Data_Inicio, null, 'PR_DBA_EXPURGO_TIMELINE', @CountLinhas_Inicio, null, @AccountId			
	
	SELECT @ID_LogManutencao = id FROM BA_DBA.DBO.DBA_LOG_EXPURGO WHERE DataInicio = @Data_Inicio and SPROC = 'PR_DBA_EXPURGO_TIMELINE'
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
		
		Select Count(1) as TempTimeline From #TempTimeline -- 1461914
	End
	

	WHILE EXISTS(SELECT 1 FROM #TempTimeline) and (@TimeNow < @timeout)
	BEGIN
			TRUNCATE TABLE #TempTimelineDel

			-- Margem do Loop para evitar OverHead
			INSERT #TempTimelineDel (Id)
			SELECT 
				TOP (convert(int, @Top)) ID  -- ERRO BIZARRO! Convert Resolveu.
			FROM #TempTimeline
			ORDER BY Id ASC
            
			-- Pega o MIN e MAX ID da PK, que é o Index Mais performático. 
			SELECT @MinId = min(id), @MaxId =  max(id) From #TempTimelineDel

			-- Exclui pelo index. 
			DELETE T
			FROM Ploomes_CRM.dbo.[Timeline] T 
			JOIN #TempTimelineDel TempTimelineDel ON [T].ID = TempTimelineDel.Id
			WHERE [T].ID >= @MinId 
			  AND [T].ID <= @MaxId
            
      
			DELETE #TempTimeline
			FROM #TempTimeline TempTimeline 
			JOIN #TempTimelineDel TempTimelineDel ON TempTimeline.ID = TempTimelineDel.Id
			Select @TimeNow = Getdate()
	END

	DROP TABLE IF EXISTS #TempTimeline
	DROP TABLE IF EXISTS #TempTimelineDel

	--- lOG Delete Hist�rico -----------------------------------------------------
	SELECT @Data_Fim = getdate()
	SELECT @CountLinhas_fim = COUNT(1) FROM Ploomes_CRM.dbo.Timeline (nolock) WHERE [ID_ClientePloomes] = @AccountId  -- Tem que ser 0 se concluir até as 02:45

	UPDATE BA_DBA.DBO.DBA_LOG_EXPURGO 
	SET DataFim = @Data_Fim, CountFim = @CountLinhas_fim
	WHERE id = @ID_LogManutencao
	--- lOG Delete Hist�rico -----------------------------------------------------
	
END -- Proc


