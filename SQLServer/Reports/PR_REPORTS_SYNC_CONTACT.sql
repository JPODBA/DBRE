USE Ploomes_IdentityProvider
GO
CREATE OR ALTER PROCEDURE PR_REPORTS_SYNC_CONTACT	
	@Debug bit = 0, 
	@id int = Null,
	@Shard varchar(15) = NULL
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

	Declare @Varexec Varchar(max)

	Select @Varexec ='DISABLE TRIGGER ALL ON [Contact];
	DISABLE TRIGGER ALL ON [ContactCollaboratorUser];'

	
	IF(@Debug = 1)
	Begin
		Select * from #id
		Select @Varexec
		Select @Shard
	End
	
	Exec(@Varexec)
	--Return

		       				 
	WHILE EXISTS (Select 1 from #id)
	BEGIN

		DECLARE @HostSetId INT, @Varexec3 varchar(max)	

		Select @HostSetId = id from #id order by id asc

		
		--- lOG Sincronização ---------------------------------------------------------------
		DECLARE @dataExec datetime = getdate()
		INSERT resync_reports_idp_log
			(DataInicio, Shard, procExecucao, erroId, erroLinha, erroMsg, hostsetID)
		SELECT 
			@dataExec, @Shard, OBJECT_NAME(@@PROCID), 0, 0, null, @HostSetId
		--- lOG Sincronização ---------------------------------------------------------------
		--return

		Select @HostSetId as HostSetId

		DROP TABLE if exists #OriginContacts
		DROP TABLE if exists #OriginCollaboratorUsers

		Select @Varexec3 = 'SELECT C.ID, C.ID_Responsavel, C.ID_Cliente, C.Suspenso, C.ID_Tipo, C.DataAtualizacao, C.DataCriacao
		INTO #OriginContacts
		FROM ['+@Shard+'].[Ploomes_CRM].[dbo].[Cliente] C (NOLOCK) 
		INNER JOIN ['+@Shard+'].[Ploomes_CRM].[dbo].[Ploomes_Cliente] PC (NOLOCK) ON C.ID_ClientePloomes = PC.ID
		WHERE PC.HostSetId = '+CONVERT(VARCHAR(20), @HostSetId)+'

		DELETE C
		FROM [Contact] C INNER JOIN #OriginContacts OC ON C.ID = OC.ID;

		INSERT INTO [Contact] (Id, OwnerId, CompanyId, Suspended, TypeId, LastUpdateDate)
		SELECT OC.ID, OC.ID_Responsavel, OC.ID_Cliente, OC.Suspenso, OC.ID_Tipo, ISNULL(OC.DataAtualizacao, OC.DataCriacao)
		FROM #OriginContacts OC;

		DELETE CCU
		FROM [ContactCollaboratorUser] CCU INNER JOIN #OriginContacts OC ON CCU.ContactId = OC.ID;

		SELECT CCU.ID_Cliente, CCU.ID_Usuario
		INTO #OriginCollaboratorUsers
		FROM ['+@Shard+'].[Ploomes_CRM].[dbo].[Cliente_Colaborador_Usuario] CCU (NOLOCK) INNER JOIN #OriginContacts C ON CCU.ID_Cliente = C.ID;

		INSERT INTO [ContactCollaboratorUser] (ContactId, UserId)
		SELECT OCU.ID_Cliente, OCU.ID_Usuario
		FROM #OriginCollaboratorUsers OCU;'		
	
		Exec(@Varexec3)
		----select @Varexec3 as Varexec3
		
		Select @HostSetId
		DELETE FROM #id WHERE ID = @HostSetId

		--- lOG Sincronização ---------------------------------------------------------------

		UPDATE resync_reports_idp_log 
		SET DataFim = GETDATE(), 
			erroId = isnull(ERROR_NUMBER(),0), 
			erroLinha = isnull(ERROR_LINE(),0), 
			erroMsg = isnull(ERROR_MESSAGE(),0) 
		WHERE DataInicio = @dataExec 
			AND hostsetID = @HostSetId
	    AND procExecucao = 'PR_REPORTS_SYNC_CONTACT'

		UPDATE resync_reports_idp_log 
		SET TempoDeExec_minutos = DATEDIFF(minute, datainicio, dataFim)
		WHERE DataInicio = @dataExec 
			AND hostsetID = @HostSetId
	    AND procExecucao = 'PR_REPORTS_SYNC_CONTACT'

		--- lOG Sincronização ---------------------------------------------------------------

	END -- while
	
	Declare @VarExec2 Varchar(max)

	Select @VarExec2 = 'ENABLE TRIGGER ALL ON [Contact];
	ENABLE TRIGGER ALL ON [ContactCollaboratorUser];'

	Exec(@Varexec2)

	DROP TABLE IF EXISTS #OriginContacts
	DROP TABLE IF EXISTS #OriginCollaboratorUsers
	 
END -- PROC

--SELECT * FROM sys.servers