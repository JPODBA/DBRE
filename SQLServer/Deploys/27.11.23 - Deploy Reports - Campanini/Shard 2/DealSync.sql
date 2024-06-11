USE Ploomes_IdentityProvider
-- 002
go
Create table #id (id int)

insert #id values(21)
insert #id values(22)
insert #id values(23)
insert #id values(27)
insert #id values(100022)
insert #id values(100023)

GO

DISABLE TRIGGER ALL ON [Deal]
GO
DISABLE TRIGGER ALL ON [DealCollaboratorUser]
GO

--Select * from #id
set nocount on
While exists (Select 1 from #id)
Begin

	
	DECLARE @HostSetId INT 

	Select @HostSetId = id from #id order by id asc
	DROP TABLE if exists #OriginDeals
	DROP TABLE if exists #OriginCollaboratorUsers

	SELECT O.Id, O.ID_Responsavel, O.ID_Cliente, O.Suspenso, O.DataAtualizacao, O.DataCriacao
	INTO #OriginDeals
	FROM [Shard02].[Ploomes_CRM].[dbo].[Oportunidade] O (NOLOCK) INNER JOIN [Shard02].[Ploomes_CRM].[dbo].[Ploomes_Cliente] PC (NOLOCK) ON O.ID_ClientePloomes = PC.ID
	WHERE PC.HostSetId = @HostSetId

	DELETE D
	FROM Deal D INNER JOIN #OriginDeals OD ON D.ID = OD.ID

	INSERT Deal (Id, OwnerId, ContactId, Suspended, LastUpdateDate)
	SELECT OD.Id, OD.ID_Responsavel, OD.ID_Cliente, OD.Suspenso, ISNULL(OD.DataAtualizacao, OD.DataCriacao)
	FROM #OriginDeals OD

	DELETE DCU
	FROM DealCollaboratorUser DCU INNER JOIN #OriginDeals OD ON DCU.DealId = OD.ID

	SELECT OCU.ID_Usuario, OCU.ID_Oportunidade, OCU.Sistema
	INTO #OriginCollaboratorUsers
	FROM [Shard02].[Ploomes_CRM].[dbo].[Oportunidade_Colaborador_Usuario] OCU (NOLOCK) INNER JOIN #OriginDeals OD ON OCU.ID_Oportunidade = OD.ID

	INSERT INTO [DealCollaboratorUser] (UserId, DealId, System)
	SELECT OCU.ID_Usuario, OCU.ID_Oportunidade, OCU.Sistema
	FROM #OriginCollaboratorUsers OCU

	Select @HostSetId
	DELETE FROM #id WHERE ID = @HostSetId


END
GO

ENABLE TRIGGER ALL ON Deal
GO
ENABLE TRIGGER ALL ON DealCollaboratorUser

DROP TABLE #OriginDeals
DROP TABLE #OriginCollaboratorUsers

