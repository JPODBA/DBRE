USE BA_DBA
GO 
IF (OBJECT_ID ('PR_DBA_ALTERINDEX') IS NULL) EXEC ('Create Procedure PR_DBA_ALTERINDEX as return')
GO
ALTER PROC PR_DBA_ALTERINDEX
	@ba varchar(50) = null, 
	@Debug bit = 1
/************************************************************************
 Autor: João Paulo Oliveira
 Data de criação: 30/08/2022
 Data de Atualização: 05/09/2022 -- Ajuste para Rebuild e Organize de forma única e não no mesmo dia. 
 Data de Atualização: 12/09/2022 -- Ajuste da tabela que verifica o Index que foi feita a manutenção. Estava repetindo o index no insert.
 Data de Atualização: 14/11/2022 -- Alteração na ordem de manutenção por % de Fragmentação. 
 Data de Atualização: 16/11/2022 -- Criação de um Try Catch para erro de Deadlock e tabela Temp para validar os que já foi feito no dia e não dba_verifica_indexManutencao
 Data de Atualização: 08/05/2023 -- Tirei a tabela historico. Não funcionou e na Ploomes a manutenção é bem tranquila. 
 Data de Atualização: 08/01/2024 -- Aumentei o valor da variável @index para resolver o problema de index em loop. 
   
 Funcionalidade: Novo modo para realizar manutenção de index, sengundo Microsoft. 
 Por fragmentação e não mais todos de uma vez. 
*************************************************************************/
AS
BEGIN
  SET NOCOUNT ON 

	-- Contigência do ERROR deadlock (temporário)
	DECLARE @COUNT_EXEC INT 
	SELECT @COUNT_EXEC = COUNT(1) FROM DBA_LOGMANUTENCAO Where DataInicio >= CONVERT(CHAR(8), GETDATE(), 112)

	IF(@COUNT_EXEC >= 3) -- Criei esse processo na contigência de parar por causa de deadlock. Vale ressaltar que só é possível pois é bem rapido o processo. E não for, tem que ser revisto. 
	BEGIN
		PRINT 'Mais de 3 execuções'
		Return
	END

  DECLARE @index          varchar(380),		-- Pega o nome do Index
          @table          varchar(80),		-- Pega o nome da tabela
          @percent        float,					-- Pega a procentagem % de fragmentação do Index
          @schema         varchar(80),		-- Pega o Schema da tabela, que é necessário para rodar o comando. 
          @varExec        nvarchar(max),  -- Executa o comando de insert na tabela #indexRebuild
          @varExec2       varchar(max),   -- Executa o comando ou de Rebuil ou de Reorganize
          @RAISERROR      varchar(300),   -- MSG que aparece no cronometro. Ou no erro.  
          @alterIndex     varchar(100),	  -- Valida se será REBUILD ou REORGANIZE
          @fazRebuild     char(1),				-- Valida se é Rebuild = S
          @fazReorganize  char(1),				-- Valida se é Reorganize = S
          @LOGMANUTENCAO  varchar(200),	  -- Pega a tabela, o index, e a % para salvar na log_manutençao
					@Day						Varchar(20)			-- Ideia para Small e Large databases. IF por dia da semana, Com filtro geral dos large e Small.

  -- Fazendo insert dos Bancos para manutenção
  DECLARE @DatabasesManutencao as TABLE (name varchar(100))
	

	IF (@ba is null)
	BEGIN
		INSERT @DatabasesManutencao
		SELECT 
			name
		FROM MASTER.DBO.sysdatabases (nolock)
		WHERE NAME = isNull(NULL, name)
			AND dbid > 4 
			AND NAME NOT IN ('BA_DBA')
		ORDER BY 1

	END -- IF @BA
	ELSE 
	BEGIN
		INSERT @DatabasesManutencao
			(name)
		Select @ba		
	END

	
	IF(@Debug = 1) Begin
		Select * from @DatabasesManutencao
		--return
	END
   
  WHILE EXISTS (SELECT 1 FROM @DatabasesManutencao) BEGIN
		SELECT TOP 1 @ba = NAME FROM @DatabasesManutencao ORDER BY 1 

		--- lOG Manutenção ---------------------------------------------------------------
		DECLARE @dataExec datetime = getdate()
		INSERT BA_DBA.DBO.DBA_LOGMANUTENCAO 
			(DataInicio, ba, procExecucao, erroId, erroLinha, erroMsg)
		SELECT 
			@dataExec, @ba, OBJECT_NAME(@@PROCID), 0, 0, null
		--- lOG Manutenção ---------------------------------------------------------------
		
        
    --DECLARE #indexRebuild as TABLE (SchemaName varchar(100), tbl_name varchar(100), index_name Varchar(100), fragmentation decimal) 
		IF(OBJECT_ID('TEMPDB..#indexRebuild') is not null) BEGIN
			Drop table TEMPDB..#indexRebuild
		END

		Create table #indexRebuild (
			SchemaName		varchar(600) COLLATE Latin1_General_CI_AI NULL, 
			tbl_name			varchar(3000) COLLATE Latin1_General_CI_AI NULL, 
			index_name    Varchar(3000) COLLATE Latin1_General_CI_AI NULL, 
			fragmentation decimal,
			fazRebuild		char(1) COLLATE Latin1_General_CI_AI NULL,
			fazReorganize Char(1) COLLATE Latin1_General_CI_AI NULL, 
			DataInsert		datetime
		) 



    
		Select @varExec = '
			use '+@ba+'; 
			insert #indexRebuild (SchemaName, tbl_name, index_name, fragmentation, DataInsert)
			SELECT  
				sc.name as nameSchema,
				OBJECT_NAME(IDX.OBJECT_ID) AS Table_Name, 
				IDX.name AS Index_Name, 
				IDXPS.avg_fragmentation_in_percent  Fragmentation_Percentage,
				Getdate()
			FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) IDXPS 
			JOIN sys.indexes IDX (Nolock)ON IDX.object_id = IDXPS.object_id AND IDX.index_id = IDXPS.index_id
			JOIN SYS.OBJECTS sb  (Nolock)ON sb.object_id = IDX.object_id
			JOIN SYS.schemas sc  (Nolock)ON sc.schema_id  = sb.schema_id
			WHERE IDXPS.index_type_desc NOT LIKE ''HEAP''
				AND IDXPS.avg_fragmentation_in_percent > 5
			ORDER BY Fragmentation_Percentage DESC'    


	exec(@varExec)

	/* Faz os filtros dos index que terão manutenção. E se serão Rebuild ou reorganize.*/
  Select @Day = SUBSTRING(UPPER(DATENAME(WEEKDAY, GETDATE())), 1, 3)

	IF(@Day = 'SUN') 
	Begin	
		DELETE FROM #indexRebuild WHERE fragmentation > 30		
	End
	ELSE
	BEGIN
		DELETE FROM #indexRebuild WHERE fragmentation < 50  			
	END



	UPDATE #indexRebuild 
	SET fazRebuild = 'S', fazReorganize = 'N'
	Where fragmentation >= 50

	UPDATE #indexRebuild
	SET fazRebuild = 'N', fazReorganize = 'S'
	Where fragmentation <= 30
	
	
	IF(@Debug = 1) 
	Begin
		--Select count(1) as dba_verifica_indexManutencao from dba_verifica_indexManutencao (Nolock)
		Select  count(1) as #indexRebuild from #indexRebuild 
		Select @varExec as varExec	
		Select * from #indexRebuild order by fragmentation 
		--return
	END

	WHILE EXISTS (SELECT 1 FROM #indexRebuild) 
	BEGIN

		--	-- Trava de Contingência 
		--Declare @TimeNow time, @timeOut time = '05:30'
		--Select @TimeNow = GETDATE()

		--IF (@TimeNow >= @timeOut)
		--BEgin 
		--	PRINT 'Trava de segunrança acionada'
		--	return
		--END

		SELECT TOP 1 
			@index = index_name, 
			@table = '['+tbl_name+']',
			@schema = SchemaName,
			@percent = fragmentation, 
			@alterindex = null,  
			@fazRebuild = fazRebuild, 
			@fazReorganize = fazReorganize 
     FROM #indexRebuild
		 Order by fragmentation desc
		
     IF(@percent >= 50 and @fazRebuild = 'S') BEGIN
				SELECT @alterindex = ' REBUILD WITH (FILLFACTOR = 100); '
     END
     ELSE       
     IF (@percent <= 30 and @fazReorganize = 'S') BEGIN
				SELECT @alterindex = ' REORGANIZE; '        
     END

		 IF(@debug = 1)
		 BEGIN			
			SELECT  
				@index					[@index], 
				@table					[@Table],
				@schema					[@schema],
				@percent				[@Percent], 
				@alterindex			[@AlterIndex], 
				@fazRebuild			[@fazRebuild], 
				@fazReorganize  [@fazReorganize]   
				--return 
		 END

				-- Apenas o @alterIndex funcionaria neste index. Mas deve ter existindo um debug para incluir o OR
		 IF((@fazRebuild = 'S' OR @fazReorganize = 'S') and @alterIndex is not null) 
		 BEGIN
				
				-- Alterar DBA_LOGMANUTENCAO_INDEX. ADD COLUMN @LOGMANUTENCAO
				SELECT @LOGMANUTENCAO = @schema+'.'+@table + '('+@index+','+ CONVERT(varchar(21),@percent) +'%,'+@alterindex+')'        

				

				SELECT @varExec2 = 'Use '+@ba+'; ALTER INDEX '+@index+' ON '+@schema+'.'+@table + @alterindex
				SELECT @RAISERROR = @varExec2 + ' : ' + convert(varchar(8),getdate(),108) 

				--- lOG Manutenção Index---------------------------------------------------------------
				DECLARE @HoraInicio datetime = getdate()
				INSERT BA_DBA.DBO.DBA_LOGMANUTENCAO_INDEX 
					(HoraInicio, Banco, tabela,IndexName, Porcent ,AlterIndex, LOGMANUTENCAO, VarExec )
				Select 
					 @HoraInicio, @ba, @table, @index, @percent,@alterIndex, @LOGMANUTENCAO, @varExec2
				--- lOG Manutenção Index---------------------------------------------------------------
				              
		
				BEGIN TRY  
							--- Execução do comando ---------------------------------------------------------------
					--Declare @error int 
				
					EXEC BA_DBA.DBO.pr_dba_cronometro 
						
					EXEC (@varExec2)
					--Select @error = @@ERROR
																
					EXEC BA_DBA.DBO.pr_dba_cronometro @RAISERROR

					UPDATE BA_DBA.DBO.DBA_LOGMANUTENCAO_INDEX 
					SET HoraFim = getdate(), Status = 'Success'
					WHERE IndexName = @index 
							AND HoraInicio = @HoraInicio
							AND tabela = @table
							AND Banco = @ba

					-- Atualizando o Tempo de Execução.
					
					UPDATE BA_DBA.DBO.DBA_LOGMANUTENCAO_INDEX 
					SET TempoDeExec_minutos = DATEDIFF(minute, HoraInicio, HoraFim)
					WHERE IndexName = @index 
							AND HoraInicio = @HoraInicio
							AND tabela = @table
							AND Banco = @ba

				END TRY  
				BEGIN CATCH  

					DECLARE @ERROR INT
					SELECT @ERROR = ERROR_NUMBER()
					
					UPDATE BA_DBA.DBO.DBA_LOGMANUTENCAO_INDEX 
					SET HoraFim = getdate(), Status = 'Failure'
					WHERE IndexName = @index 
						AND HoraInicio = @HoraInicio
						AND tabela = @table
						AND Banco = @ba

					UPDATE BA_DBA.DBO.DBA_LOGMANUTENCAO_INDEX 
					SET TempoDeExec_minutos = DATEDIFF(minute, HoraInicio, HoraFim)
					WHERE IndexName = @index 
							AND HoraInicio = @HoraInicio
							AND tabela = @table
							AND Banco = @ba 



					IF(@ERROR = 1205) -- 1205 Deadlock
					BEGIN
						Exec BA_DBA.DBO.PR_DBA_ALTERINDEX
					END					

				END CATCH;   
			
			--DELETE FROM #indexRebuild WHERE index_name = @index 

				      			
			END -- IF De entrada para aplicar o comando. 

			DELETE FROM #indexRebuild WHERE index_name = @index 
				
		END -- 2 While

		UPDATE BA_DBA.DBO.DBA_LOGMANUTENCAO 
		SET DataFim = GETDATE(), 
			--ba = @ba, 
			--procExecucao = isnull(ERROR_PROCEDURE(),0), 
			erroId = isnull(ERROR_NUMBER(),0), 
			erroLinha = isnull(ERROR_LINE(),0), 
			erroMsg = isnull(ERROR_MESSAGE(),0) 
		WHERE DataInicio = @dataExec 
			AND ba = @ba
			--AND procExecucao = OBJECT_NAME(@@PROCID)

		UPDATE BA_DBA.DBO.DBA_LOGMANUTENCAO 
		SET TempoDeExec_minutos = DATEDIFF(minute, datainicio, dataFim)
		WHERE DataInicio = @dataExec 
			AND ba = @ba
			--AND procExecucao = OBJECT_NAME(@@PROCID)
     
		DELETE FROM @DatabasesManutencao WHERE name = @ba 
    
	END -- 1 While

	-- Controle do tamanho das tabelas.  
	Delete from BA_DBA.DBO.DBA_LOGMANUTENCAO where DataFim <= CONVERT(CHAR(8),DATEADD(WEEK, -1, GETDATE()),112)
	Delete from BA_DBA.DBO.DBA_LOGMANUTENCAO_INDEX where HoraFim <= CONVERT(CHAR(8),DATEADD(WEEK, -1, GETDATE()),112)
	


   
END --Proc

GO 
IF (OBJECT_ID('BA_DBA.DBO.DBA_LOGMANUTENCAO')is null)Begin 
Create table BA_DBA.DBO.DBA_LOGMANUTENCAO(
	DataInicio					datetime, 
	DataFim							datetime, 
	TempoDeExec_minutos int,
	ba									varchar(100), 
	procExecucao				Varchar(100), 
	erroId							int, 
	erroLinha						int, 
	erroMsg							Varchar(200)
)
End
GO
IF (OBJECT_ID ('BA_DBA..DBA_LOGMANUTENCAO_INDEX') IS NULL) BEGIN
CREATE TABLE BA_DBA.DBO.DBA_LOGMANUTENCAO_INDEX (
	HoraInicio  				Datetime, 
	HoraFim							Datetime,
	TempoDeExec_minutos int,
	Banco								Varchar(70), 
	Tabela							Varchar(3000),
	IndexName						Varchar(3000), 
	Porcent							int,
	Status							varchar(10),
	AlterIndex					Varchar(3000),
	LOGMANUTENCAO				varchar(3000), 
	VarExec							Varchar(3000)
)
END
GO 
--IF (OBJECT_ID('BA_DBA.DBO.dba_verifica_indexManutencao') is null) BEGIN
--create table BA_DBA.DBO.DBA_VERIFICA_INDEXMANUTENCAO (
--	Ba								varchar(100), 
--	SchemaName				varchar(100), 
--	tbl_name					varchar(3000), 
--	index_name				Varchar(3000), 
--	fragmentation			decimal, 
--	DataProcessamento datetime
--)
--END
--GO
--drop table BA_DBA.DBO.DBA_LOGMANUTENCAO
--drop table BA_DBA.DBO.DBA_LOGMANUTENCAO_INDEX
--drop table BA_DBA.DBO.dba_verifica_indexManutencao

--Delete from BA_DBA.DBO.DBA_LOGMANUTENCAO where datafim is null
--Delete from BA_DBA.DBO.DBA_LOGMANUTENCAO_INDEX
--Delete from BA_DBA.DBO.dba_verifica_indexManutencao

--Select * from BA_DBA.DBO.DBA_LOGMANUTENCAO
--Select * from BA_DBA.DBO.DBA_LOGMANUTENCAO_INDEX order by 1 desc
--Select * from BA_DBA.DBO.dba_verifica_indexManutencao


--Exec BA_DBA.DBO.PR_DBA_ALTERINDEX @ba = 'GENERALI_TIM', @debug = 1






