USE Ploomes_IdentityProvider
GO
CREATE OR ALTER PROCEDURE PR_REPORTS_SYNC_USER
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

	Select @VarExec = 'DISABLE TRIGGER ALL ON [User];
	DISABLE TRIGGER ALL ON [UserOwner];'

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

		DROP TABLE IF EXISTS #OriginUsers
		DROP TABLE IF EXISTS #OriginOwnerUsers

		--- lOG Sincronização ---------------------------------------------------------------
		DECLARE @dataExec datetime = getdate()
		INSERT resync_reports_idp_log
			(DataInicio, Shard, procExecucao, erroId, erroLinha, erroMsg, hostsetID)
		SELECT 
			@dataExec, @Shard, OBJECT_NAME(@@PROCID), 0, 0, null, @HostSetId
		--- lOG Sincronização ---------------------------------------------------------------
	
		Select @Varexec3 = 'SELECT U.ID, U.ID_ClientePloomes, U.Nome, U.Email, U.Senha, U.Chave, U.ChaveSecreta, U.ID_Perfil,  U.ID_Criador, U.DataCriacao, u.ID_Atualizador, U.DataAtualizacao, U.Suspenso
		INTO #OriginUsers
		FROM ['+@Shard+'].[Ploomes_CRM].[dbo].[Usuario] U (NOLOCK) 
		INNER JOIN ['+@Shard+'].[Ploomes_CRM].[dbo].[Ploomes_Cliente] PC (NOLOCK) ON U.ID_ClientePloomes = PC.ID
		WHERE PC.HostSetId = '+CONVERT(VARCHAR(20), @HostSetId)+'

		DELETE UO
		FROM [UserOwner] UO INNER JOIN [User] U ON UO.UserId = U.Id
		INNER JOIN #OriginUsers OU ON OU.ID = U.ID

		DELETE U
		FROM [User] U INNER JOIN #OriginUsers OU ON OU.ID = U.ID

		INSERT INTO [User] (Id, AccountId, Name, Email, Password, UserKey, SecretKey, ProfileId, CreatorId, CreateDate, UpdaterId, UpdateDate, Suspended)
		SELECT U.ID, U.ID_ClientePloomes, U.Nome, U.Email, U.Senha, U.Chave, U.ChaveSecreta, U.ID_Perfil,  U.ID_Criador, U.DataCriacao, u.ID_Atualizador, U.DataAtualizacao, U.Suspenso
		FROM #OriginUsers U

		SELECT UR.ID_Usuario, UR.ID_Responsavel, UR.ID_Tipo
		INTO #OriginOwnerUsers
		FROM ['+@Shard+'].[Ploomes_CRM].[dbo].[Usuario_Responsavel] UR (NOLOCK) INNER JOIN #OriginUsers U ON UR.ID_Usuario = U.ID
		WHERE UR.ID_Item IS NULL

		INSERT INTO [UserOwner] (UserId, OwnerId, EntityId)
		SELECT UR.ID_Usuario, UR.ID_Responsavel, UR.ID_Tipo
		FROM #OriginOwnerUsers UR

		INSERT INTO [UserOwner] (UserId, OwnerId, EntityId)
		SELECT UR.ID_Usuario, UR.ID_Responsavel, 7
		FROM #OriginOwnerUsers UR
		WHERE UR.ID_Tipo = 2'

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
	    AND procExecucao = 'PR_REPORTS_SYNC_USER'

		UPDATE resync_reports_idp_log 
		SET TempoDeExec_minutos = DATEDIFF(minute, datainicio, dataFim)
		WHERE DataInicio = @dataExec 
			AND hostsetID = @HostSetId
	    AND procExecucao = 'PR_REPORTS_SYNC_USER'

		--- lOG Sincronização ---------------------------------------------------------------

	END -- While

	Declare @VarExec2 Varchar(Max)
	Select @VarExec2 = 'ENABLE TRIGGER ALL ON [User];
	ENABLE TRIGGER ALL ON [UserOwner];'

	Exec(@VarExec2)
 
END -- PROC