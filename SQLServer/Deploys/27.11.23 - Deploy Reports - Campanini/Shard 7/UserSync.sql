USE Ploomes_IdentityProvider

go
Create table #id (id int)

--005
insert #id values(71)
insert #id values(72)
insert #id values(73)
insert #id values(100071)
insert #id values(100073)
GO

DISABLE TRIGGER ALL ON [User]
GO
DISABLE TRIGGER ALL ON [UserOwner]
GO

set nocount on
While exists (Select 1 from #id)
Begin
	
	DECLARE @HostSetId INT 

	Select @HostSetId = id from #id order by id asc
	DROP TABLE IF EXISTS #OriginUsers
	DROP TABLE IF EXISTS #OriginOwnerUsers
	
	SELECT U.ID, U.ID_ClientePloomes, U.Nome, U.Email, U.Senha, U.Chave, U.ChaveSecreta, U.ID_Perfil,  U.ID_Criador, U.DataCriacao, u.ID_Atualizador, U.DataAtualizacao, U.Suspenso
	INTO #OriginUsers
	FROM [Shard07].[Ploomes_CRM].[dbo].[Usuario] U (NOLOCK) INNER JOIN [Shard07].[Ploomes_CRM].[dbo].[Ploomes_Cliente] PC (NOLOCK) ON U.ID_ClientePloomes = PC.ID
	WHERE PC.HostSetId = @HostSetId

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
	FROM [Shard07].[Ploomes_CRM].[dbo].[Usuario_Responsavel] UR (NOLOCK) INNER JOIN #OriginUsers U ON UR.ID_Usuario = U.ID

	INSERT INTO [UserOwner] (UserId, OwnerId, EntityId)
	SELECT UR.ID_Usuario, UR.ID_Responsavel, UR.ID_Tipo
	FROM #OriginOwnerUsers UR

	INSERT INTO [UserOwner] (UserId, OwnerId, EntityId)
	SELECT UR.ID_Usuario, UR.ID_Responsavel, 7
	FROM #OriginOwnerUsers UR
	WHERE UR.ID_Tipo = 2

	Select @HostSetId
	DELETE FROM #id WHERE ID = @HostSetId

END
GO

ENABLE TRIGGER ALL ON [User]
GO
ENABLE TRIGGER ALL ON [UserOwner]
GO

DROP TABLE #OriginUsers
DROP TABLE #OriginOwnerUsers

