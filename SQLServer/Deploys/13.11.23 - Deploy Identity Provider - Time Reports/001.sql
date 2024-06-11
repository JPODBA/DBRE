USE Ploomes_IdentityProvider

GO

drop table if exists  #id
Create table #id (id int)

--001
insert #id values(21)
insert #id values(22)
insert #id values(23)
insert #id values(27)
--insert #id values(100022)
--insert #id values(100023)
go

DISABLE TRIGGER ALL ON [Contact]
GO
DISABLE TRIGGER ALL ON [ContactCollaboratorUser]
GO

--select * from #id

while exists (Select 1 from #id)
Begin

	DECLARE @HostSetId INT 
	Select @HostSetId = id from #id order by id asc

	DROP TABLE if exists #OriginContacts
  DROP TABLE if exists #OriginCollaboratorUsers
	
	SELECT C.ID, C.ID_Responsavel, C.ID_Cliente, C.Suspenso, C.ID_Tipo, C.DataAtualizacao, C.DataCriacao
	INTO #OriginContacts
	FROM [Shard02].[Ploomes_CRM].[dbo].[Cliente] C (NOLOCK) 
	INNER JOIN [Shard02].[Ploomes_CRM].[dbo].[Ploomes_Cliente] PC (NOLOCK) ON C.ID_ClientePloomes = PC.ID
	WHERE PC.HostSetId = @HostSetId

	DELETE C
	FROM [Contact] C INNER JOIN #OriginContacts OC ON C.ID = OC.ID

	INSERT INTO [Contact] (Id, OwnerId, CompanyId, Suspended, TypeId, LastUpdateDate)
	SELECT OC.ID, OC.ID_Responsavel, OC.ID_Cliente, OC.Suspenso, OC.ID_Tipo, ISNULL(OC.DataAtualizacao, OC.DataCriacao)
	FROM #OriginContacts OC

	DELETE CCU
	FROM [ContactCollaboratorUser] CCU INNER JOIN #OriginContacts OC ON CCU.ContactId = OC.ID

	SELECT CCU.ID_Cliente, CCU.ID_Usuario
	INTO #OriginCollaboratorUsers
	FROM [Shard02].[Ploomes_CRM].[dbo].[Cliente_Colaborador_Usuario] CCU (NOLOCK) INNER JOIN #OriginContacts C ON CCU.ID_Cliente = C.ID 

	INSERT INTO [ContactCollaboratorUser] (ContactId, UserId)
	SELECT OCU.ID_Cliente, OCU.ID_Usuario
	FROM #OriginCollaboratorUsers OCU


	Select @HostSetId
	DELETE FROM #id WHERE ID = @HostSetId

END
GO

ENABLE TRIGGER ALL ON [Contact]
GO
ENABLE TRIGGER ALL ON [ContactCollaboratorUser]
GO

DROP TABLE #OriginContacts
DROP TABLE #OriginCollaboratorUsers

