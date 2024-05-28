USE Ploomes_IdentityProvider
GO
CREATE OR ALTER PROCEDURE PR_REPORTS_SYNC_TEAM
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

	Declare @VarExec Varchar(Max)

	Select @VarExec = 'DISABLE TRIGGER ALL ON [Team];
	DISABLE TRIGGER ALL ON [TeamUser];'
	
	If(@Debug = 1)
	Begin
		Select * From #id
		Select @VarExec
		--Return
	End

	Exec(@VarExec)

	While exists (Select 1 from #id)
	Begin
	
		DECLARE @HostSetId INT, @Varexec3 varchar(max), @Varexec4 varchar(max) 

		Select @HostSetId = id from #id order by id asc

		DROP TABLE if exists #OriginTeams
		DROP TABLE if exists #OriginTeamUser

		--- lOG Sincronização ---------------------------------------------------------------
		DECLARE @dataExec datetime = getdate()
		INSERT resync_reports_idp_log
			(DataInicio, Shard, procExecucao, erroId, erroLinha, erroMsg, hostsetID)
		SELECT 
			@dataExec, @Shard, OBJECT_NAME(@@PROCID), 0, 0, null, @HostSetId
		--- lOG Sincronização ---------------------------------------------------------------


		Select @Varexec3 = 'SELECT EQ.ID, EQ.ID_ClientePloomes, EQ.Descricao, EQ.ID_Criador, EQ.DataCriacao, EQ.ID_Atualizador, EQ.DataAtualizacao, EQ.Suspenso
		INTO #OriginTeams
		FROM ['+@Shard+'].[Ploomes_CRM].[dbo].[Equipe] EQ (NOLOCK) 
		INNER JOIN ['+@Shard+'].[Ploomes_CRM].[dbo].[Ploomes_Cliente] PC (NOLOCK) ON EQ.ID_ClientePloomes = PC.ID
		WHERE PC.HostSetId = '+CONVERT(VARCHAR(20), @HostSetId)+';

		DELETE TU
		FROM [TeamUser] TU INNER JOIN Team T ON TU.TeamId = T.Id  INNER JOIN #OriginTeams OT ON T.ID = OT.ID;

		DELETE T
		FROM [Team] T INNER JOIN #OriginTeams OT ON T.ID = OT.ID;

		INSERT INTO [Team] (Id, AccountId, Name, CreatorId, CreateDate, UpdaterId, UpdateDate, Suspended)
		SELECT EQ.ID, EQ.ID_ClientePloomes, EQ.Descricao, EQ.ID_Criador, EQ.DataCriacao, EQ.ID_Atualizador, EQ.DataAtualizacao, EQ.Suspenso
		FROM #OriginTeams EQ;

		SELECT EU.ID_Equipe, EU.ID_Usuario
		INTO #OriginTeamUser
		FROM ['+@Shard+'].[Ploomes_CRM].[dbo].[Equipe_Usuario] EU (NOLOCK) 
		INNER JOIN #OriginTeams OT ON EU.ID_Equipe = OT.ID;

		INSERT INTO [TeamUser] (TeamId, UserId)
		SELECT OTU.ID_Equipe, OTU.ID_Usuario
		FROM #OriginTeamUser OTU;'

		Exec(@Varexec3)
				
		DELETE FROM #ID WHERE ID = @HostSetId

		--- lOG Sincronização ---------------------------------------------------------------

		UPDATE resync_reports_idp_log 
		SET DataFim = GETDATE(), 
			erroId = isnull(ERROR_NUMBER(),0), 
			erroLinha = isnull(ERROR_LINE(),0), 
			erroMsg = isnull(ERROR_MESSAGE(),0) 
		WHERE DataInicio = @dataExec 
			AND hostsetID = @HostSetId
	    AND procExecucao = 'PR_REPORTS_SYNC_TEAM'

		UPDATE resync_reports_idp_log 
		SET TempoDeExec_minutos = DATEDIFF(minute, datainicio, dataFim)
		WHERE DataInicio = @dataExec 
			AND hostsetID = @HostSetId
	    AND procExecucao = 'PR_REPORTS_SYNC_TEAM'

		--- lOG Sincronização ---------------------------------------------------------------

	END -- While 

	Declare @VarExec2 Varchar(Max)
	Select @VarExec2 = 'ENABLE TRIGGER ALL ON [Team];
	ENABLE TRIGGER ALL ON [TeamUser];'

	Exec(@VarExec2)
 
END -- PROC