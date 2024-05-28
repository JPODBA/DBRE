USE Ploomes_IdentityProvider
GO
CREATE OR ALTER PROCEDURE PR_REPORTS_SYNC_DEAL
	@Debug bit = 0, 
	@id int = Null,
	@Shard Varchar(30) = null
AS
/************************************************************************
 Autor: Equipe DBA
 Data de criação: 20/12/2023
 Funcionalidade:  
 *************************************************************************/
BEGIN 
	Set nocount on

	Drop table if exists  #id
	Create table #id (id int)
	
	If (@id is null)
	Begin
		insert #id
		Select hostset_id from resync_reports_idp where shard = @Shard
	End
	Else
	Begin
		insert #id values(@id)
	End

	Declare @VarExec Varchar(max)
	Select @VarExec = 'DISABLE TRIGGER ALL ON [Deal];
	DISABLE TRIGGER ALL ON [DealCollaboratorUser];'
	
	IF(@Debug = 1)
	Begin
		Select * From #id
		Select @VarExec
	END

	Exec(@VarExec)
	
	While exists (Select 1 from #id)
	Begin

		DECLARE @HostSetId INT, @Varexec3 varchar(max)

		Select @HostSetId = id from #id order by id asc
				
		--- lOG Sincronização ---------------------------------------------------------------
		DECLARE @dataExec datetime = getdate()
		INSERT resync_reports_idp_log
			(DataInicio, Shard, procExecucao, erroId, erroLinha, erroMsg, hostsetID)
		SELECT 
			@dataExec, @Shard, OBJECT_NAME(@@PROCID), 0, 0, null, @HostSetId
		--- lOG Sincronização ---------------------------------------------------------------
	
		DROP TABLE if exists #OriginDeals
		DROP TABLE if exists #OriginCollaboratorUsers

		Select @Varexec3 ='SELECT O.Id, O.ID_Responsavel, O.ID_Cliente, O.Suspenso, O.DataAtualizacao, O.DataCriacao
		INTO #OriginDeals
		FROM ['+@Shard+'].[Ploomes_CRM].[dbo].[Oportunidade] O (NOLOCK) 
		INNER JOIN ['+@Shard+'].[Ploomes_CRM].[dbo].[Ploomes_Cliente] PC (NOLOCK) ON O.ID_ClientePloomes = PC.ID
		WHERE PC.HostSetId = '+CONVERT(VARCHAR(20), @HostSetId)+';

		DELETE D
		FROM Deal D INNER JOIN #OriginDeals OD ON D.ID = OD.ID;

		INSERT Deal (Id, OwnerId, ContactId, Suspended, LastUpdateDate)
		SELECT OD.Id, OD.ID_Responsavel, OD.ID_Cliente, OD.Suspenso, ISNULL(OD.DataAtualizacao, OD.DataCriacao)
		FROM #OriginDeals OD;

		DELETE DCU
		FROM DealCollaboratorUser DCU INNER JOIN #OriginDeals OD ON DCU.DealId = OD.ID;

		SELECT OCU.ID_Usuario, OCU.ID_Oportunidade, OCU.Sistema
		INTO #OriginCollaboratorUsers
		FROM ['+@Shard+'].[Ploomes_CRM].[dbo].[Oportunidade_Colaborador_Usuario] OCU (NOLOCK) INNER JOIN #OriginDeals OD ON OCU.ID_Oportunidade = OD.ID;

		INSERT INTO [DealCollaboratorUser] (UserId, DealId, System)
		SELECT OCU.ID_Usuario, OCU.ID_Oportunidade, OCU.Sistema
		FROM #OriginCollaboratorUsers OCU;'

		exec(@Varexec3)

		--Select @HostSetId
		DELETE FROM #id WHERE ID = @HostSetId


		--- lOG Sincronização ---------------------------------------------------------------

		UPDATE resync_reports_idp_log 
		SET DataFim = GETDATE(), 
			erroId = isnull(ERROR_NUMBER(),0), 
			erroLinha = isnull(ERROR_LINE(),0), 
			erroMsg = isnull(ERROR_MESSAGE(),0) 
		WHERE DataInicio = @dataExec 
			AND hostsetID = @HostSetId
	    AND procExecucao = 'PR_REPORTS_SYNC_DEAL'

		UPDATE resync_reports_idp_log 
		SET TempoDeExec_minutos = DATEDIFF(minute, datainicio, dataFim)
		WHERE DataInicio = @dataExec 
			AND hostsetID = @HostSetId
	    AND procExecucao = 'PR_REPORTS_SYNC_DEAL'

		--- lOG Sincronização ---------------------------------------------------------------
		
	END -- While

	Declare @VarExec2 Varchar(max)
	Select @VarExec2 = 'ENABLE TRIGGER ALL ON Deal;
	ENABLE TRIGGER ALL ON DealCollaboratorUser;'

	Exec(@VarExec2)

	DROP TABLE IF EXISTS #OriginDeals
	DROP TABLE IF EXISTS #OriginCollaboratorUsers

 
END -- PROC