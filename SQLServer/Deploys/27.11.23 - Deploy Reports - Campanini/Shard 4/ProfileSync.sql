USE Ploomes_IdentityProvider

go
Create table #id (id int)

--003
insert #id values(41)
insert #id values(42)
insert #id values(43)
insert #id values(44)
insert #id values(45)
insert #id values(200)
insert #id values(100041)
insert #id values(100043)


GO

DISABLE TRIGGER ALL ON [Profile]
GO

set nocount on
While exists (Select 1 from #id)
Begin

	
	DECLARE @HostSetId INT 

	Select @HostSetId = id from #id order by id asc
	DROP TABLE IF EXISTS #OriginProfiles
	DROP TABLE IF EXISTS #OriginAllowedChatUser


	SELECT UP.ID, UP.Id_ClientePloomes, UP.Descricao, UP.ID_Criador, UP.DataCriacao, UP.ID_Atualizador, UP.DataAtualizacao, UP.Suspenso, UP.Cliente_Cria, UP.Cliente_Ve, UP.Cliente_Edita, UP.Cliente_Exclui, UP.Cliente_Modulo,
	UP.ContactsCompanyCreatePermission, UP.ContactsPersonCreatePermission, UP.ImportaExcel, UP.ExportaExcel, UP.ContactsProductsCreatePermission, UP.ContactsProductsEditPermission, 
	UP.ContactsProductsDeletePermission, UP.ContactsProductsViewPermission, UP.Lead_Cria, UP.Lead_Ve, UP.Lead_Edita, UP.Lead_Exclui, UP.Lead_Modulo, UP.Lead_Manipula, UP.Oportunidade_Cria, 
	UP.Cliente_Oportunidade_Ve, UP.Cliente_Oportunidade_Edita, UP.Oportunidade_Exclui, UP.Oportunidade_Modulo, UP.Oportunidade_Cliente_Ve, UP.Oportunidade_Cliente_Edita, UP.Oportunidade_Cliente_Exclui,
	UP.Oportunidade_Ganha, UP.Oportunidade_Reabre, UP.Proposta_Cria, UP.Proposta_Edita, UP.Proposta_Exclui, UP.Proposta_Modulo,
	UP.Documento_Cria, UP.Documento_Edita, UP.Documento_Exclui, UP.Documento_Modulo, UP.Venda_Cria, UP.Cliente_Venda_Ve, Cliente_Venda_Edita, Venda_Exclui, UP.Venda_Modulo,
	UP.Produto_Cria, UP.Produto_Edita, UP.Produto_Exclui, UP.Produto_Administra, UP.Usuario_Ve, UP.HomeMessagesCreate, UP.LogsViewPermission, UP.TeamsView, UP.ChatPermission,
	UP.GoalsModule, UP.Meta_Cliente_Cria, UP.Meta_Oportunidade_Cria, UP.Meta_Venda_Cria, UP.Meta_Documento_Cria, UP.Meta_Lead_Cria, UP.Meta_Relatorio_Cria, UP.Meta_Tarefa_Cria, UP.FieldsCreatePermission, 
	UP.FieldsEditPermission, UP.FieldsDeletePermission, UP.OutrasOpcoes_Cria, UP.Email_Ve, UP.Timeline_Empresa, UP.Tabela_Cria, UP.Etiqueta_Cria, 
	UP.Cidade_Cria, UP.Tarefa_Modulo,UP.Email_Modulo,UP.Relatorios_Modulo, UP.ChatModule
	INTO #OriginProfiles
	FROM [Shard04].[Ploomes_CRM].[dbo].[Usuario_Perfil] UP (NOLOCK) INNER JOIN [Shard04].[Ploomes_CRM].[dbo].[Ploomes_Cliente] PC (NOLOCK) ON UP.ID_ClientePloomes = PC.ID
	WHERE PC.HostSetId = @HostSetId

	DELETE PMEO
	FROM [ProfileModuleEntityOtherOption] PMEO 
	INNER JOIN [ProfileModuleEntity] PME ON PMEO.ProfileModuleEntityId = PME.Id
	INNER JOIN #OriginProfiles P ON PME.ProfileId = P.Id

	DELETE PME 
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles P ON PME.ProfileId = P.ID

	DELETE P
	FROM [Profile] P INNER JOIN #OriginProfiles OP ON P.ID = OP.ID

	INSERT INTO [Profile] (Id, AccountId, Name, CreatorId, CreateDate, UpdaterId, UpdateDate, Suspended)
	SELECT OP.ID, OP.Id_ClientePloomes, OP.Descricao, OP.ID_Criador, OP.DataCriacao, OP.ID_Atualizador, OP.DataAtualizacao, OP.Suspenso
	FROM #OriginProfiles OP


	-- begin sync contact permission
	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 1, UP.ID, UP.Cliente_Cria, UP.Cliente_Ve, UP.Cliente_Edita, UP.Cliente_Exclui
	FROM #OriginProfiles UP
	WHERE UP.Cliente_Modulo = 'True'
	
	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 1, CAST(UP.ContactsCompanyCreatePermission AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 1

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 2, CAST(UP.ContactsPersonCreatePermission AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 1

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 18, CAST(UP.ImportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 1

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 19, CAST(UP.ExportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 1

	-- end sync contact permission

	-- begin sync contact_product permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 13, UP.ID, UP.ContactsProductsCreatePermission, IIF(ContactsProductsCreatePermission = 'True', 1, 4), IIF(UP.ContactsProductsEditPermission = 'True', 1, 4), IIF(UP.ContactsProductsDeletePermission = 'True', 1, 4)
	FROM #OriginProfiles UP
	WHERE UP.ContactsProductsViewPermission = 'True'

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 18, CAST(UP.ImportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 13

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 19, CAST(UP.ExportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 13

	-- end sync contact_product permission

	-- begin sync lead permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 3, UP.ID, UP.Lead_Cria, UP.Lead_Ve, UP.Lead_Edita, UP.Lead_Exclui
	FROM #OriginProfiles UP
	WHERE UP.Lead_Modulo = 'True'

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 3, CAST(UP.Lead_Manipula AS INT)
	FROM [ProfileModuleEntity] PME 
	INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 3

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 18, CAST(UP.ImportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 3

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 19, CAST(UP.ExportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 3

	-- end sync lead permission

	-- begin sync deal permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 2, UP.ID, UP.Oportunidade_Cria, UP.Cliente_Oportunidade_Ve, UP.Cliente_Oportunidade_Edita, UP.Oportunidade_Exclui
	FROM #OriginProfiles UP
	WHERE UP.Oportunidade_Modulo = 'True'

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 8, CAST(UP.Oportunidade_Cliente_Ve AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 2

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 9, CAST(UP.Oportunidade_Cliente_Edita AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 2

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 10, CAST(UP.Oportunidade_Cliente_Exclui AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 2

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 4, CAST(UP.Oportunidade_Ganha AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 2

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 5, CAST(UP.Oportunidade_Reabre AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 2

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 18, CAST(UP.ImportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 2

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 19, CAST(UP.ExportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 2

	-- end sync deal permission

	-- begin sync quote permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 5, UP.ID, UP.Proposta_Cria, UP.Cliente_Oportunidade_Ve, IIF(UP.Proposta_Edita = 'True', 1, 4), IIF(UP.Proposta_Exclui = 'True', 1, 4)
	FROM #OriginProfiles UP
	WHERE UP.Proposta_Modulo = 'True'

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 18, CAST(UP.ImportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 5

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 19, CAST(UP.ExportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 5

	-- end sync quote permission

	-- begin sync document permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 6, UP.ID, UP.Documento_Cria, UP.Cliente_Oportunidade_Ve, IIF(UP.Documento_Edita = 'True', 1, 4), IIF(UP.Documento_Exclui = 'True', 1, 4)
	FROM #OriginProfiles UP
	WHERE UP.Documento_Modulo = 'True'

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 18, CAST(UP.ImportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 6

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 19, CAST(UP.ExportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 6

	-- end sync document permission

	-- begin sync order permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 4, UP.ID, UP.Venda_Cria, UP.Cliente_Venda_Ve, Cliente_Venda_Edita, Venda_Exclui
	FROM #OriginProfiles UP
	WHERE UP.Venda_Modulo = 'True'

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 18, CAST(UP.ImportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 4

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 19, CAST(UP.ExportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 4

	-- end sync order permission

	-- begin sync product permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 8, UP.ID, UP.Produto_Cria, 1, IIF(UP.Produto_Edita ='True', 1, 4), IIF(UP.Produto_Exclui ='True', 1, 4)
	FROM #OriginProfiles UP
	WHERE UP.Produto_Administra = 'True'

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 18, CAST(UP.ImportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 8

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 19, CAST(UP.ExportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 8

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 9, UP.ID, UP.Produto_Cria, 1, IIF(UP.Produto_Edita ='True', 1, 4), IIF(UP.Produto_Exclui ='True', 1, 4)
	FROM #OriginProfiles UP
	WHERE UP.Produto_Administra = 'True'

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 18, CAST(UP.ImportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 9

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 19, CAST(UP.ExportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 9

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 11, UP.ID, UP.Produto_Cria, 1, IIF(UP.Produto_Edita ='True', 1, 4), IIF(UP.Produto_Exclui ='True', 1, 4)
	FROM #OriginProfiles UP
	WHERE UP.Produto_Administra = 'True'

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 18, CAST(UP.ImportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 11

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 19, CAST(UP.ExportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 11

	-- end sync product permission

	-- begin sync user permission 
	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 7, UP.ID, IIF(UP.ID = 1, 1, 0), UP.Usuario_Ve, 3, 4
	FROM #OriginProfiles UP

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 6, CAST(UP.HomeMessagesCreate AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 7

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 7, CAST(UP.LogsViewPermission AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 7

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 19, CAST(UP.ExportaExcel AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 7

	-- end sync user permission

	-- begin sync team permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 14, UP.ID, IIF(UP.ID = 1, 1, 0), UP.TeamsView, IIF(UP.ID = 1, 1, 4),  IIF(UP.ID = 1, 1, 4)
	FROM #OriginProfiles UP

	-- end sync team permission

	-- begin sync chat permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 15, UP.ID, 1, UP.ChatPermission, 3,  3
	FROM #OriginProfiles UP
	WHERE UP.ChatModule = 'True'

	SELECT UPA.ProfileId, UPA.UserId
	INTO #OriginAllowedChatUser
	FROM [Shard04].[Ploomes_CRM].[dbo].[Usuario_Perfil_AllowedChatUser] UPA (NOLOCK) INNER JOIN #OriginProfiles UP ON UPA.ProfileId = UP.ID

	INSERT INTO [AllowedChatUser] (ProfileModuleEntityId, UserId)
	SELECT PME.Id, UPA.UserId
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginAllowedChatUser UPA ON UPA.ProfileId = PME.ProfileId
	WHERE PME.ModuleEntityId = 15

	-- end sync chat permission

	-- begin sync goal permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 16, UP.ID, IIF(UP.Id = 1, 1, 0), 1, IIF(UP.Id = 1, 1, 4),  IIF(UP.Id = 1, 1, 4)
	FROM #OriginProfiles UP
	WHERE UP.GoalsModule = 'True'

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 11, CAST(UP.Meta_Cliente_Cria AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 16

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 12, CAST(UP.Meta_Oportunidade_Cria AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 16

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 13, CAST(UP.Meta_Venda_Cria AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 16

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 14, CAST(UP.Meta_Documento_Cria AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 16

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 15, CAST(UP.Meta_Lead_Cria AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 16

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 16, CAST(UP.Meta_Relatorio_Cria AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 16

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 17, CAST(UP.Meta_Tarefa_Cria AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 16

	-- end sync goal permission

	-- begin sync field permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 12, UP.ID, UP.FieldsCreatePermission, 1, IIF(UP.FieldsEditPermission = 'True', 1, 4),  IIF(UP.FieldsDeletePermission = 'True', 1, 4)
	FROM #OriginProfiles UP

	-- end sync field permission

	-- begin sync field_table_option permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 17, UP.ID, UP.OutrasOpcoes_Cria, 1, IIF(UP.ID = 1, 1, 4),  IIF(UP.ID = 1, 1, 4)
	FROM #OriginProfiles UP

	-- end sync field_table_option permission


	-- begin sync task permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 17, UP.ID, UP.OutrasOpcoes_Cria, 1, IIF(UP.ID = 1, 1, 4),  IIF(UP.ID = 1, 1, 4)
	FROM #OriginProfiles UP

	-- end sync task permission

	-- begin sync task permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 10, UP.ID, 1, 3, 3,  3
	FROM #OriginProfiles UP
	WHERE UP.Tarefa_Modulo = 'True'

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 16, CAST(UP.Meta_Relatorio_Cria AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 10

	INSERT INTO [ProfileModuleEntityOtherOption] (ProfileModuleEntityId, ProfileOtherOptionId, Value)
	SELECT PME.Id, 17, CAST(UP.Meta_Tarefa_Cria AS INT)
	FROM [ProfileModuleEntity] PME INNER JOIN #OriginProfiles UP ON PME.ProfileId = UP.ID
	WHERE PME.ModuleEntityId = 10

	-- end sync task permission

	-- begin sync email permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 18, UP.ID, 1, UP.Email_Ve, 3,  3
	FROM #OriginProfiles UP
	WHERE UP.Email_Modulo = 'True'

	-- end sync email permission

	-- begin sync reports permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 19, UP.ID, 1, 3, 3,  3
	FROM #OriginProfiles UP
	WHERE UP.Relatorios_Modulo = 'True'

	-- end sync reports permission

	-- begin sync timeline permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 20, UP.ID, 1, IIF(UP.Timeline_Empresa = 'True', 1, 3), 4,  4
	FROM #OriginProfiles UP

	-- end sync timeline permission

	-- begin sync table permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 21, UP.ID, UP.Tabela_Cria, 3, 3,  3
	FROM #OriginProfiles UP

	-- end sync table permission

	-- begin sync tag permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 22, UP.ID, UP.Etiqueta_Cria, 1, IIF(UP.ID = 1, 1, 4),  IIF(UP.ID = 1, 1, 4)
	FROM #OriginProfiles UP

	-- end sync tag permission

	-- begin sync city permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 23, UP.ID, UP.Cidade_Cria, 1, IIF(UP.ID = 1, 1, 4),  IIF(UP.ID = 1, 1, 4)
	FROM #OriginProfiles UP

	-- end sync city permission

	-- begin sync city permission

	INSERT INTO [ProfileModuleEntity] (ModuleEntityId, ProfileId, AllowCreate, ViewProfileOptionId, EditProfileOptionId, DeleteProfileOptionId)
	SELECT 24, UP.ID, UP.Cidade_Cria, 1, IIF(UP.ID = 1, 1, 4),  IIF(UP.ID = 1, 1, 4)
	FROM #OriginProfiles UP

	Select @HostSetId
	DELETE FROM #id WHERE ID = @HostSetId


END

-- end sync city permission
GO

ENABLE TRIGGER ALL ON [Profile]
GO

DROP TABLE #OriginProfiles
DROP TABLE #OriginAllowedChatUser

