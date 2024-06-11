USE Ploomes_IdentityProvider

go
Create table #id (id int)

--004
insert #id values(51)
insert #id values(52)
insert #id values(53)
insert #id values(54)
insert #id values(55)
insert #id values(57)
insert #id values(58)
insert #id values(59)
insert #id values(100053)
insert #id values(100054)
insert #id values(100055)
insert #id values(100057)


GO

DISABLE TRIGGER ALL ON [Team]
GO
DISABLE TRIGGER ALL ON [TeamUser]
GO


set nocount on
While exists (Select 1 from #id)
Begin
	
	DECLARE @HostSetId INT 

	Select @HostSetId = id from #id order by id asc
	DROP TABLE if exists #OriginTeams
	DROP TABLE if exists #OriginTeamUser

	SELECT EQ.ID, EQ.ID_ClientePloomes, EQ.Descricao, EQ.ID_Criador, EQ.DataCriacao, EQ.ID_Atualizador, EQ.DataAtualizacao, EQ.Suspenso
	INTO #OriginTeams
	FROM [Shard05].[Ploomes_CRM].[dbo].[Equipe] EQ (NOLOCK) INNER JOIN [Shard05].[Ploomes_CRM].[dbo].[Ploomes_Cliente] PC (NOLOCK) ON EQ.ID_ClientePloomes = PC.ID
	WHERE PC.HostSetId = @HostSetId

	DELETE TU
	FROM [TeamUser] TU INNER JOIN Team T ON TU.TeamId = T.Id  INNER JOIN #OriginTeams OT ON T.ID = OT.ID

	DELETE T
	FROM [Team] T INNER JOIN #OriginTeams OT ON T.ID = OT.ID

	INSERT INTO [Team] (Id, AccountId, Name, CreatorId, CreateDate, UpdaterId, UpdateDate, Suspended)
	SELECT EQ.ID, EQ.ID_ClientePloomes, EQ.Descricao, EQ.ID_Criador, EQ.DataCriacao, EQ.ID_Atualizador, EQ.DataAtualizacao, EQ.Suspenso
			FROM #OriginTeams EQ

	SELECT EU.ID_Equipe, EU.ID_Usuario
	INTO #OriginTeamUser
	FROM [Shard05].[Ploomes_CRM].[dbo].[Equipe_Usuario] EU (NOLOCK) INNER JOIN #OriginTeams OT ON EU.ID_Equipe = OT.ID

	INSERT INTO [TeamUser] (TeamId, UserId)
	SELECT OTU.ID_Equipe, OTU.ID_Usuario
	FROM #OriginTeamUser OTU

	Select @HostSetId
	DELETE FROM #ID WHERE ID = @HostSetId

END
GO

ENABLE TRIGGER ALL ON [Team]
GO
ENABLE TRIGGER ALL ON [TeamUser]
GO



