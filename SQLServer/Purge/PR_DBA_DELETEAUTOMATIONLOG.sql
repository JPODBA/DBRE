USE BA_DBA
GO
IF (OBJECT_ID ('PR_DBA_DELETEAUTOMATIONLOG') IS NULL) EXEC ('Create Procedure PR_DBA_DELETEAUTOMATIONLOG as return')
GO
CREATE OR ALTER PROC PR_DBA_DELETEAUTOMATIONLOG 
	@Debug bit = 1
/************************************************************************
 Autor: João Paulo Oliveira \ DBA
 Data de criação: 22/03/2024
 Data de Atualização: 12/04/2024 - Atualizações do modelo de criação de LOG do processo.
 Data de Atualização: 24/04/2024 - Atualizações do modelo de criação de LOG do processo - UPDATE.    
 
 Funcionalidade: Faz o Expurgo de dados da tabela Automation_log do Ploomes_CRM. O Corte é 
 de 6 meses defino pelo até então CTO Vinicius Sampaio.. 
*************************************************************************/
AS
BEGIN

	SET NOCOUNT ON

	DECLARE 
		@Data_min								 Datetime = null, 
		@Data_Max								 Datetime = null, 
		@CountLinhas_ParaCorte   Int, 
		@CountLinhasMAIORqueSeis Int, 
		@DataInicio							 Datetime,
		@Datafim								 Datetime, 
		@CountLinhas_Total			 Int, 
		@Id											 Int
		
	Select 
		@Data_min = Convert(char(8), MIN(DATETIME), 112),
		@Data_Max = Convert(char(8), MAX(DATETIME), 112)
	From Ploomes_CRM.dbo.Automation_Log (nolock)
	Where datetime <= CONVERT(DATE, DATEADD(MONTH, -6, GETDATE()), 121)

	Select 
		@CountLinhas_ParaCorte = Count(1) 
	From Ploomes_CRM.dbo.Automation_Log (nolock)
	Where datetime <= CONVERT(DATE, DATEADD(MONTH, -6, GETDATE()-1), 121)

	Select @CountLinhas_Total = Count(1) From Ploomes_CRM.dbo.Automation_Log (nolock)
	
	If (@data_min is null)
	Begin 
		Print 'DataMin é null. Corte minimo ainda não aplicavél'
	End

	/* Tabela para performar melhor o Delete. */
	DROP TABLE IF EXISTS #Delete_Automation
	CREATE TABLE #Delete_Automation (id int)
	CREATE CLUSTERED INDEX DBA_PK ON #Delete_Automation (ID)


	--- lOG Delete Histórico -----------------------------------------------------
	SELECT @dataInicio = getdate()
	INSERT BA_DBA.DBO.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO 
 	(
		DataInicio_Expurgo_Corte, 
		CountLinhas_inicio_corte, 
		datahoraInicio_exec_proc, 
		datahoraFim_exec_proc, 
		DataFim_atual_Expurgo_Corte, 
		LinhasCountAtual_Total
	)
	SELECT 
 		@data_min, 
		@CountLinhas_ParaCorte, 
		@dataInicio, 
		null, 
		@Data_Max, 
		@CountLinhas_Total				
	
	Select @id = Max(id) From BA_DBA.DBO.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO (nolock)
  --- lOG Delete Histórico -----------------------------------------------------


	If (@debug = 1)
	Begin 
		SELECT 
			Convert(char(8), MIN(DATETIME), 112) as MinData,
			Convert(char(8), MAX(DATETIME), 112) as MaxData
		FROM Ploomes_CRM.dbo.Automation_Log (nolock)
		WHERE DateTime <= CONVERT(DATE, DATEADD(MONTH, -6, GETDATE()), 121) -- O Corte é sempre de 6 meses. 

		Select 
			'Checando Variáveis',
			@data_min as DataMin_V, 
			@Data_Max as DataMax_V, 
			@CountLinhas_ParaCorte as CountLinhas_ParaCorte, 
			@CountLinhas_Total as CountLinhas_Total, 
			@id as ID, 
			@dataInicio as DatahoraInicio_exec_proc
		
		
		Select 
			Count(1) as CountLinhas_ParaCorte_CountTbl
		From Ploomes_CRM.dbo.Automation_Log (nolock)
		Where datetime <= CONVERT(DATE, DATEADD(MONTH, -6, GETDATE()-1), 121)

		Select * 
		From DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO (nolock) 
		Where DatahoraInicio_exec_proc >= @dataInicio

		--return
	End
	 
	-- Inicio outro valor de linhas inicial, para que o Log seja mais preciso para cada Loop.
	Select 
		@CountLinhas_ParaCorte = Count(1) 
	From Ploomes_CRM.dbo.Automation_Log (nolock)
	Where datetime <= @data_min

	While @data_min <= @Data_Max
	Begin 
		Print '---- INICIANDO ' + convert(varchar(8), @data_min, 112) + '----------------------------------------------' 
		--return
		Exec BA_DBA.dbo.pr_dba_cronometro 

		--- lOG Delete Média por execução ---------------------------------------------
		Select @dataInicio = getdate()
		INSERT BA_DBA.DBO.DBA_LOG_DELETEAUTOMATIONLOG 
  		(datamin, DataInicio, DataFim, CountInicioLinhas,  LinhasDeletasCount)
		SELECT 
  		@data_min, @dataInicio, null, @CountLinhas_ParaCorte, 0
    --- lOG Delete Média por execução ---------------------------------------------
	
		While exists (Select 1 From Ploomes_CRM.dbo.Automation_Log (nolock) Where DateTime <= @data_min)
		Begin
			Select 'While na data ' + CONVERT(varchar(16), @data_min, 112)

			Declare @RowCont int

			 -- Faz o insert de 5000 ID ----------------------------------
			exec BA_DBA.dbo.pr_dba_cronometro

			insert #Delete_Automation (id)
			Select top 5000 Id From Ploomes_CRM.dbo.Automation_Log (nolock)
			Where DateTime <= @data_min

			Exec BA_DBA.dbo.pr_dba_cronometro 'Insert #Delete_Automation'
			 -- Faz o insert de 5000 ID ----------------------------------

			-- Fazendo o delete no quente ----------------------------------------
			Exec BA_DBA.dbo.pr_dba_cronometro
		
			DELETE D
			From Ploomes_CRM.dbo.Automation_Log			  D 
			Join #Delete_Automation   j on j.id = D.id	
			Select @RowCont = @@ROWCOUNT 
			Select 'Quantidade Linhas Deletadas:'+CONVERT(varchar(100), @RowCont) +'' 

			Exec BA_DBA.dbo.pr_dba_cronometro 'Deletando o quente (Automation_Log)'
			-- Fazendo o delete no quente ----------------------------------------
			
			-- Vai precisar de if @CountLinhas_ParaCorte >= @RowCont
			IF @CountLinhas_ParaCorte >=  @RowCont
			BEGIN
				Select @CountLinhas_ParaCorte -=  @RowCont
			END
			ELSE
			BEGIN
				Select @CountLinhas_ParaCorte = 0
			END	


			--- lOG Delete Média por execução -------------------------------------
			Select @datafim = getdate()

			INSERT BA_DBA.DBO.DBA_LOG_DELETEAUTOMATIONLOG 
  			(datamin, DataInicio, DataFim, CountInicioLinhas,  LinhasDeletasCount)
			SELECT 
  			@data_min, @dataInicio, @datafim, @CountLinhas_ParaCorte, @RowCont		
			--- lOG Delete Média por execução -------------------------------------


			-- Delete  #Delete_Automation -----------------------------------------
			Exec BA_DBA.dbo.pr_dba_cronometro
			Truncate table #Delete_Automation 
			Exec BA_DBA.dbo.pr_dba_cronometro 'Delete #Delete_Automation'
			 -- Delete  #Delete_Automation ----------------------------------------

			PRINT '!!!!!!!!!!!!!!!!!!! FINALIZADO '+ convert(varchar(4), @RowCont) +' !!!!!!!!'
			--return
		
		End -- While Select 1

							
		Select @data_min = @data_min + 1

		-- Reseto o valor para o dia em questão. 
		Select 
			@CountLinhas_ParaCorte = Count(1) 
		From Ploomes_CRM.dbo.Automation_Log (nolock)
		Where datetime <= @data_min
	
		If (@debug = 1)
		Begin 
			Select 'Debug fora do while. Datamin Após + 1. E o Count Tem que ser 0', count(1),  @data_min From #Delete_Automation		
		End

		Exec BA_DBA.dbo.pr_dba_cronometro  '!!!!!!!!!!!!!!!!!!! FINALIZADO EM: '  
		PRINT '!!!!!!!!!!!!!!!!!!! FINALIZADO TUDO NA DATA: ' + convert(varchar(8), @data_min, 112) + ' !!!!!!!!!!'

	End -- while @data_min

	--- lOG Delete Histórico -----------------------------------------------------
	Select @datafim = getdate()
	
	UPDATE BA_DBA.DBO.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO 
	SET datahoraFim_exec_proc = @datafim, 
		DataFim_atual_Expurgo_Corte = @data_min
	Where id = @id
  --- lOG Delete Histórico -----------------------------------------------------


END -- Proc
GO 
--Drop table if exists BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG 
IF (OBJECT_ID ('BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG') is null)
begin
	Create table BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG 
	(
	ID								 Int identity (1,1),
	Datamin            Date, 
	DataInicio         Datetime, 
	DataFim						 Datetime, 
	CountInicioLinhas  Int,
	LinhasDeletasCount Int
	)
End
GO
-- Drop table if exists BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO
IF (OBJECT_ID ('BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO') is null)
begin
	Create table BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO 
	(
	ID														  Int identity (1,1),
	DataInicio_Expurgo_Corte			  date, 
	CountLinhas_inicio_corte				int, 
	DatahoraInicio_exec_proc				datetime,
	DatahoraFim_exec_proc						datetime,
	DataFim_atual_Expurgo_Corte			date, 
	LinhasCountAtual_Total    			int
	)
End
--ALTER TABLE [BA_DBA].[dbo].[DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO] ADD CONSTRAINT [PK_DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO] PRIMARY KEY CLUSTERED 
--([ID] ASC) WITH (FILLFACTOR = 100) ON [PRIMARY]
--GO
--ALTER TABLE [BA_DBA].[dbo].[DBA_DBA_LOG_DELETEAUTOMATIONLOG] ADD  CONSTRAINT [PK_DBA_LOG_DELETEAUTOMATIONLOG] PRIMARY KEY CLUSTERED 
--([ID] ASC) WITH (FILLFACTOR = 100) ON [PRIMARY]
--GO

--Exec BA_DBA.dbo.PR_DBA_DELETEAUTOMATIONLOG @Debug = 0

--Select count(1) From Ploomes_CRM.dbo.Automation_log (Nolock) WHERE DATETIME <= '2023-10-24' --- SEMPRE COLOCAR A DATA MIN
--Select * from BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG Order by 4 desc
--Select * from BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO Order by 4 desc


/** 
Select * from BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO
Select count(1) from Ploomes_CRM.dbo.Automation_Log (nolock)

--Delete from BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG
--Delete from BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO

-- Shard01
insert BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO values ('2023-02-15', 308078739, null, null, '20240412',  141960520)

-- Shard02
insert BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO values ('2023-02-15', 116631799, null, null, '20240412',  31495473)

-- Shard03
insert BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO values ('2022-02-07', 568144, null, null, '20240412', 295850)

-- Shard04
insert BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO values ('2023-02-15', 104713918, null, null, '20240412',  53050252)

-- Shard05
insert BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO values ('2023-08-20', 218892759, null, null, '20240412',  141615615)

-- Shard06
insert BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO values ('2023-09-13', 82726228, null, null, '20240412', 78414895)

-- Shard07
insert BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO values ('2023-08-04', 55428958, null, null, '20240412',  41722636)

-- Shard08
insert BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO values ('2023-07-27', 2844139, null, null, '20240412',  2372843)

-- Shard09
insert BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO values ('2023-08-26', 21959497, null, null, '20240412',  20299503)

-- Shard10
insert BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO values (NULL, 0, null, null, '20240412',  6464812)

-- Shard11
insert BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG_HISTORICO values (NULL, 0, null, null, '20240412',  23744)
**/
