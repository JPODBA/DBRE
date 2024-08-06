use BA_DBA
go
CREATE OR ALTER PROC PR_DBA_EXPURGO 
  @mes      int = 6, -- Pensando no Futuro
  @timeout  Time = '16:45',
  @Data_max datetime = null, -- Pensando no Futuro
  @top      int = 500, 
  @debug    bit = 0
AS
/************************************************************************
 Autor: João Paulo OLiveira / DBA
 Data de criação: 29/07/2024
 Data de Atualização: 
 Funcionalidade: Faz o expurgo do Ploomes_CRM.
*************************************************************************/
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON

	DECLARE 
		@TimeNow				Time = Getdate(),
		@Data_Inicio			Datetime, 
		@Data_Fim				Datetime, 
		@CountLinhas_Inicio     Int, 
		@CountLinhas_fim		Int,
		@ID_LogManutencao		Int,
		@AccountId				Int
		

	-- Vai ser refeito o INSERT
	--INSERT BA_DBA.dbo.DBA_LOG_EXPURGO_ACCOUNT (ACCOUNT_ID)
	--SELECT 7000001

	--INSERT BA_DBA.dbo.DBA_LOG_EXPURGO_ACCOUNT (ACCOUNT_ID)
	--SELECT 25614

	--- lOG Delete Historico ------------------------------------------------------------------------------
	SELECT @Data_Inicio = getdate()
	INSERT BA_DBA.DBO.DBA_LOG_EXPURGO 
 	      (DataInicio, DataFim, SPROC)
	Select @Data_Inicio, null, 'PR_DBA_EXPURGO'

	SELECT @ID_LogManutencao = id FROM BA_DBA.DBO.DBA_LOG_EXPURGO WHERE DataInicio = @Data_Inicio
	--- lOG Delete Historico ------------------------------------------------------------------------------
	

	If (@debug = 1) 
	begin
		Select @TimeNow			    as TimeNow			
		Select @Data_Inicio		    as Data_Inicio		
		Select @Data_Fim			as Data_Fim			
		Select @CountLinhas_Inicio  as CountLinhas_Inicio 
		Select @CountLinhas_fim	    as CountLinhas_fim	
		Select @ID_LogManutencao	as ID_LogManutencao	
		Select @AccountId			as AccountId			
	End

	While exists (Select 1 From BA_DBA.dbo.DBA_LOG_EXPURGO_ACCOUNT) and (@TimeNow < @timeout)
	begin

		Select @AccountId = ACCOUNT_ID From BA_DBA.dbo.DBA_LOG_EXPURGO_ACCOUNT (nolock)
		--Select count(ID_ClientePloomes), ID_ClientePloomes from Ploomes_CRM.dbo.Timeline group by ID_ClientePloomes ## VAlIDAÇÂO DE DEBUG
	
		-- ## INICIO EXPURGOS
		Exec BA_DBA.dbo.PR_DBA_EXPURGO_TIMELINE @Debug = 0, @AccountId = @AccountId, @Top = @top, @timeout = @timeout
			 		
									   					
		Select @TimeNow = GETDATE()
		Delete FROM BA_DBA.dbo.DBA_LOG_EXPURGO_ACCOUNT where ACCOUNT_ID = @AccountId 
	END

	--- lOG Delete Historico -----------------------------------------------------
	SELECT @Data_Fim = getdate()
	
	UPDATE BA_DBA.DBO.DBA_LOG_EXPURGO 
	SET DataFim = @Data_Fim
	WHERE id = @ID_LogManutencao
	--- lOG Delete Historico -----------------------------------------------------

END
GO
--drop table if exists BA_DBA..DBA_LOG_EXPURGO_ACCOUNT
IF OBJECT_ID('BA_DBA..DBA_LOG_EXPURGO_ACCOUNT') is null
BEGIN
	CREATE TABLE [dbo].[DBA_LOG_EXPURGO_ACCOUNT](
		 ACCOUNT_ID     [int] NULL
	) ON [PRIMARY]
END
GO
--CREATE NONCLUSTERED INDEX [IX_DBA_LOG_EXPURGO_ACCOUNT_ID] ON [dbo].[DBA_LOG_EXPURGO_ACCOUNT]
--(ACCOUNT_ID) WITH (FILLFACTOR = 100) ON [PRIMARY]
--GO
--drop table if exists BA_DBA..DBA_LOG_EXPURGO
IF OBJECT_ID('BA_DBA..DBA_LOG_EXPURGO') is null
BEGIN
	CREATE TABLE [dbo].[DBA_LOG_EXPURGO](
		[ID]			   [int] IDENTITY(1,1) NOT NULL,
		[DataInicio]	   [datetime] NULL,
		[DataFim]		   [datetime] NULL,
		[SPROC]			   Varchar(200) NULL,
		[CountInicio]	   [int] NULL,
		[CountFim]		   [int] NULL,
		[AcountID]		   [int] NULL,
		[DataInicio_Corte] [datetime] NULL, -- Para o Futuro
		[DataFim_Corte]	   [datetime] NULL, -- Para o Futuro
	 CONSTRAINT [PK_DBA_LOG_EXPURGO] PRIMARY KEY CLUSTERED (ID) WITH (FILLFACTOR = 100) ON [PRIMARY]
	) ON [PRIMARY]
END
GO
--Select DataInicio, DataFim, SPROC from BA_DBA..DBA_LOG_EXPURGO

--Select * from BA_DBA..DBA_LOG_EXPURGO_ACCOUNT
--Select * from BA_DBA..DBA_LOG_EXPURGO

--Delete from BA_DBA..DBA_LOG_EXPURGO_ACCOUNT
--Delete from BA_DBA..DBA_LOG_EXPURGO