/*
    Script de subida do deployment 14-12-2023
*/
USE Ploomes_CRM;
GO

-- up 1
-- https://app.asana.com/0/626405171214145/1205798561945482/f
ALTER PROCEDURE [dbo].[Create_Default_Account]
	@CompanyName NVARCHAR(150),
	@RootUserName NVARCHAR(150),
	@Phone NVARCHAR(80),
	@Email NVARCHAR(200),
	@Password NVARCHAR(250),
	@OriginPartner NVARCHAR(50) = NULL,
	@HostSetId INT = 1,
	@AccountId INT = NULL OUTPUT,
    @UserId INT = NULL OUTPUT,
    @AutomationUserId INT = NULL OUTPUT
AS BEGIN
	DECLARE @MailBody NVARCHAR(MAX)
	DECLARE @ChaveIntegracao NVARCHAR(300)
	
	INSERT INTO Ploomes_Cliente (Nome, Email, Telefone, DataCriacao, Expira, ID_Plano, ID_TipoPlano, Cultura, LanguageId, ID_Moeda, ParceiroOrigem,
			Vendas, Cotacoes, Documentos, Leads, URL_Login, HostSetId, DiasBoleto_Pagamento, DocumentsUrl, FirstLoginTypeId, ConfiguracoesIniciais, WhatsAppExtension, ReportsModule, ReportsModuleType, TimeZone, DocumentsUseERPFormat, OrdersUseERPFormat, QuotesUseERPFormat, ShouldSanitizeBigStringField,
			MaxItemsExportedPerMinuteInApi2, MaxPowerBILinks, MinIntervalToUpdatePowerBILinkInMinutes)
		VALUES (@CompanyName, @Email, @Phone, GETDATE(), DATEADD(d, 14, GETDATE()), 2, 3, 'pt-BR', 1, 1, @OriginPartner,
			1, 1, 1, 0, 'https://app.ploomes.com/Public/Login.aspx?uk=', @HostSetId, 7, 'https://documents.ploomes.com/', 1, 1, 1, 0, 'new', 'America/Sao_Paulo', 1, 1, 1, 1,
			1000, 10, 480)
		
	SET @AccountId = SCOPE_IDENTITY()

	INSERT INTO Usuario (ID_ClientePloomes, Email, Senha, Nome, ID_Perfil, SenhaInicial, TasksCounter, Cultura, LanguageId)
		VALUES (@AccountId, CONVERT(NVARCHAR(200), @Email), @Password, CONVERT(NVARCHAR(100), @RootUserName), 1, 1, 3,'pt-BR',1)
			
	SET @UserId = SCOPE_IDENTITY()

	INSERT INTO Usuario (ID_ClientePloomes, Email, Senha, Nome, AvatarUrl, ID_Perfil, Integracao, IntegracaoNativa, Cortesia, Chave,Cultura,LanguageId)
		VALUES (@AccountId, 'noreply@ploomes.com', '-', 'Automação', 'https://stgploomescrmprd01.blob.core.windows.net/crm-prd/automation.png', 1, 1, 1, 1,
			STUFF(CONVERT(NVARCHAR(128), HASHBYTES('SHA2_512', CONVERT(NVARCHAR(10), @AccountId) + CONVERT(VARCHAR(8), GETDATE(), 108) + 'AD9484845F7A4FC40AREDDINOSAUR2C3AEEE3265B942F1B13F6' + CONVERT(NVARCHAR(2), DAY(GETDATE())) + CONVERT(NVARCHAR(4), YEAR(GETDATE())) + CONVERT(NVARCHAR(2), MONTH(GETDATE()))), 2), 50, 0, CONVERT(NVARCHAR(10), @AccountId)),'pt-BR',1)
			
	SET @AutomationUserId = SCOPE_IDENTITY()

	INSERT INTO Usuario_Suspenso_Historico (ID_Usuario, Suspenso, ID_Atualizador, Pagamento_Contabiliza) VALUES (@UserId, 0, @UserId, 1)

	INSERT INTO Field (
       AccountId,
	   [Key],
	   FieldId,
	   [Dynamic]
	)
	SELECT @AccountId, CF.Chave, CF.ID, 0 FROM CampoFixo2 CF WHERE EXISTS(SELECT 1 FROM CampoFixo2_Cultura CFC WHERE CF.ID = CFC.ID_Campo)

	--GHOST CONTACT
	INSERT INTO Cliente (ID_ClientePloomes, Nome, ID_Tipo, ID_Status, ID_Criador, DataCriacao, Suspenso, Ghost)
		VALUES (@AccountId, '', 0, 0, @UserId, GETDATE(), 1, 1)
		
	UPDATE Ploomes_Cliente
		SET ID_Criador = @UserId, ID_UsuarioAutomacao = @AutomationUserId,
			ChaveIntegracao = STUFF(CONVERT(NVARCHAR(128), HASHBYTES('SHA2_512', CONVERT(NVARCHAR(10), ID) + 'AD9484845F7A4FBLUECOW40A2C3AEEE3265B942F1B13F6'), 2), 50, 0, CONVERT(NVARCHAR(10), ID)),
			ChaveSecreta = STUFF(CONVERT(NVARCHAR(128), HASHBYTES('SHA2_512', CONVERT(NVARCHAR(10), ID) + '44828273F95B188AREDDINOSAUR174B97B49819EC46668DEA6B'), 2), 50, 0, CONVERT(NVARCHAR(10), ID)),
			Pasta = CONVERT(NVARCHAR(12), STUFF(CONVERT(NVARCHAR(128), HASHBYTES('SHA2_512', CONVERT(NVARCHAR(10), ID) + '4UIOJHGR8NB77FF95B188'), 2), 4, 0, CONVERT(NVARCHAR(10), ID)))
		WHERE ID = @AccountId

	SELECT @ChaveIntegracao = ChaveIntegracao
		FROM Ploomes_Cliente
		WHERE ID = @AccountId

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, SingularUnitName, PluralUnitName, GenderId)
		VALUES (@AccountId, 2, 'Negócio', 'Negócios', 1)

	EXEC ReplaceEntityTexts @AccountId, 2

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, SingularUnitName, PluralUnitName, GenderId)
		VALUES (@AccountId, 44, 'Funil', 'Funis', 1)

	EXEC ReplaceEntityTexts @AccountId, 44

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, SingularUnitName, PluralUnitName, GenderId)
		VALUES (@AccountId, 75, 'Produto de cliente', 'Produtos de cliente', 1)

	EXEC ReplaceEntityTexts @AccountId, 75

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, SingularUnitName, PluralUnitName, GenderId)
		VALUES (@AccountId, 96, 'Coleção', 'Coleções', 1)

	EXEC ReplaceEntityTexts @AccountId, 96

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, SingularUnitName, PluralUnitName, GenderId)
		VALUES (@AccountId, 97, 'Arquivo', 'Arquivos', 1)

	EXEC ReplaceEntityTexts @AccountId, 97

	INSERT INTO Lead_MotivoDescarte (ID_ClientePloomes, Descricao, ID_Criador, BaseNameId) VALUES (@AccountId, 'Dados incorretos', @UserId, 22)
	INSERT INTO Lead_MotivoDescarte (ID_ClientePloomes, Descricao, ID_Criador, BaseNameId) VALUES (@AccountId, 'Não era um cliente em potencial', @UserId, 23)
	INSERT INTO Lead_MotivoDescarte (ID_ClientePloomes, Descricao, ID_Criador, BaseNameId) VALUES (@AccountId, 'Não existe', @UserId, 24)
	INSERT INTO Lead_MotivoDescarte (ID_ClientePloomes, Descricao, ID_Criador, BaseNameId) VALUES (@AccountId, 'Não tem interesse', @UserId, 25)

	INSERT INTO Lead_Status (ID_ClientePloomes, Descricao, ID_Criador, CSS_Icon, CSS_Icon_SPA, BaseNameId) VALUES (@AccountId, 'Fim da fila', @UserId, 'bluecow-clock icon-helper text-muted', 'fa-arrow-alt-down', 20)

	DECLARE @ID_Funil INT, @ID_Formulario INT, @ID_FormularioRapido INT, @ID_Secao INT
	INSERT INTO Oportunidade_Funil (ID_ClientePloomes, Descricao, PassaTodosEstagios, ProibidoVoltarEstagios, AdicionaPropostas, ID_Criador, IconId, Color, SingularUnitName, PluralUnitName, GenderId)
		VALUES (@AccountId, 'Funil de vendas', 0, 0, 1, @UserId, 2, '#92aab0', 'Negócio', 'Negócios', 1)

	SET @ID_Funil = SCOPE_IDENTITY()


	--DEAL FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, ID_Criador)
		VALUES (@AccountId, 2, 'deal_form', 'Negócios', 1, @UserId)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1046, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_Formulario, 1052, 1, 15, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_Formulario, 1053, 1, 20, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1047, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1070, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1071, 1, 50, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1179, 1, 60, 0)

	INSERT INTO Formulario_Secao (ID_Formulario, Ordem, Descricao)
		VALUES (@ID_Formulario, 100, 'Outras informações')

	SET @ID_Secao = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1050, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1049, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1072, 1, 30, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1075, 1, 40, 1)

	INSERT INTO Formulario_Secao_Language (SectionId, LanguageId, [Name])
		VALUES (@ID_Secao, 1, 'Outras informações'), 
			   (@ID_Secao, 2, 'Other informations'),
			   (@ID_Secao, 3, 'Outras Informações'),
			   (@ID_Secao, 4, 'Otras informaciones')



	--DEAL QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, ID_Criador)
		VALUES (@AccountId, 2, 'deal_quick_form', 'Negócios (mini)', 1, @UserId)

	SET @ID_FormularioRapido = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido, 1046, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioRapido, 1052, 1, 15, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioRapido, 1053, 1, 20, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido, 1049, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido, 1075, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido, 1179, 1, 50, 0)


	UPDATE Oportunidade_Funil SET FormId = @ID_Formulario, QuickFormId = @ID_FormularioRapido WHERE ID = @ID_Funil

	UPDATE Campo_Tabela_LastUpdate
	SET LastUpdateDate = GETDATE()
	WHERE EntityId = 81 AND AccountId = @AccountId



	INSERT INTO Oportunidade_MotivoPerda (ID_ClientePloomes, Descricao, PipelineId, ID_Criador) VALUES (@AccountId, 'Vitória da concorrência', @ID_Funil, @UserId)
	INSERT INTO Oportunidade_MotivoPerda (ID_ClientePloomes, Descricao, PipelineId, ID_Criador) VALUES (@AccountId, 'Sem recursos financeiros', @ID_Funil, @UserId)
	INSERT INTO Oportunidade_MotivoPerda (ID_ClientePloomes, Descricao, PipelineId, ID_Criador) VALUES (@AccountId, 'Desinteresse pelos produtos', @ID_Funil, @UserId)

	INSERT INTO Oportunidade_Status (ID_ClientePloomes, ID_Funil, Descricao, Ordem, ID_Criador) VALUES (@AccountId, @ID_Funil, 'Primeiros contatos', 1, @UserId)
	INSERT INTO Oportunidade_Status (ID_ClientePloomes, ID_Funil, Descricao, Ordem, ID_Criador) VALUES (@AccountId, @ID_Funil, 'Frio', 2, @UserId)
	INSERT INTO Oportunidade_Status (ID_ClientePloomes, ID_Funil, Descricao, Ordem, ID_Criador) VALUES (@AccountId, @ID_Funil, 'Morno', 3, @UserId)
	INSERT INTO Oportunidade_Status (ID_ClientePloomes, ID_Funil, Descricao, Ordem, ID_Criador) VALUES (@AccountId, @ID_Funil, 'Quente', 4, @UserId)
	INSERT INTO Oportunidade_Status (ID_ClientePloomes, ID_Funil, Descricao, Ordem, ID_Criador) VALUES (@AccountId, @ID_Funil, 'Fechamento', 5, @UserId)

	INSERT INTO Cliente_Status (ID_ClientePloomes, Descricao, CSS_Label, CSS_Icon, CSS_Color, Img, Prospeccao, ID_Criador) VALUES (@AccountId, 'Prospecção', 'motivblue', 'icon-spinner', 'text-info', 'prospect.png', 1, @UserId)
	INSERT INTO Cliente_Status (ID_ClientePloomes, Descricao, CSS_Label, CSS_Icon, CSS_Color, Img, ID_Criador) VALUES (@AccountId, 'Ativo', 'motivsuccess', 'icon-ok', 'text-success', 'active.png', @UserId)
	INSERT INTO Cliente_Status (ID_ClientePloomes, Descricao, CSS_Label, CSS_Icon, CSS_Color, Img, ID_Criador) VALUES (@AccountId, 'Inativo', 'motivred', 'icon-minus-sign', 'text-danger', 'inactive.png', @UserId)
	INSERT INTO Cliente_Status (ID_ClientePloomes, Descricao, CSS_Label, CSS_Icon, CSS_Color, Img, Descartado, ID_Criador) VALUES (@AccountId, 'Descartado', 'motivdark', 'icon-trash', NULL, 'discarded.png', 1, @UserId)

	INSERT INTO Assinatura_Status (ID_ClientePloomes, Descricao, Ordem, ID_Criador) VALUES (@AccountId, 'Ativas', 1, @UserId)
	INSERT INTO Assinatura_Status (ID_ClientePloomes, Descricao, Ordem, ID_Criador) VALUES (@AccountId, 'Canceladas', 2, @UserId)

	INSERT INTO Usuario_Perfil (ID_ClientePloomes, Descricao, Cliente_Ve, Cliente_Edita, Cliente_Tarefa_Ve, Cliente_Tarefa_Edita,
			Cliente_Oportunidade_Ve, Cliente_Oportunidade_Edita, Cliente_Oportunidade_Tarefa_Ve, Cliente_Oportunidade_Tarefa_Edita,
			Cliente_Venda_Ve, Cliente_Venda_Edita, Lead_Ve, Lead_Edita, ExportaExcel, Origem_Cria, Cargo_Cria, Produto_Cria,
			Motivo_Cria, Cidade_Cria, Etiqueta_Cria, Comissao_Cria, Cliente_Exclui, Oportunidade_Exclui, Venda_Exclui, Lead_Exclui,
			ID_Criador)
		VALUES (@AccountId, 'Funcionário', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, @UserId)

	INSERT INTO Usuario_Perfil (ID_ClientePloomes, Descricao, Cliente_Ve, Cliente_Edita, Cliente_Tarefa_Ve, Cliente_Tarefa_Edita,
			Cliente_Oportunidade_Ve, Cliente_Oportunidade_Edita, Cliente_Oportunidade_Tarefa_Ve, Cliente_Oportunidade_Tarefa_Edita,
			Cliente_Venda_Ve, Cliente_Venda_Edita, Lead_Ve, Lead_Edita, ExportaExcel, Origem_Cria, Cargo_Cria, Produto_Cria,
			Motivo_Cria, Cidade_Cria, Etiqueta_Cria, Comissao_Cria, Cliente_Exclui, Oportunidade_Exclui, Venda_Exclui, Lead_Exclui,
			ID_Criador)
		VALUES (@AccountId, 'Gestor Geral', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, @UserId)

	INSERT INTO Usuario_Perfil (ID_ClientePloomes, Descricao, Cliente_Ve, Cliente_Edita, Cliente_Tarefa_Ve, Cliente_Tarefa_Edita,
			Cliente_Oportunidade_Ve, Cliente_Oportunidade_Edita, Cliente_Oportunidade_Tarefa_Ve, Cliente_Oportunidade_Tarefa_Edita,
			Cliente_Venda_Ve, Cliente_Venda_Edita, Lead_Ve, Lead_Edita, ExportaExcel, Origem_Cria, Cargo_Cria, Produto_Cria,
			Motivo_Cria, Cidade_Cria, Etiqueta_Cria, Comissao_Cria, Cliente_Exclui, Oportunidade_Exclui, Venda_Exclui, Lead_Exclui,
			ID_Criador)
		VALUES (@AccountId, 'Gestor de Equipe', 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, @UserId)

	INSERT INTO Usuario_Perfil (ID_ClientePloomes, Descricao, Cliente_Ve, Cliente_Edita, Cliente_Tarefa_Ve, Cliente_Tarefa_Edita,
			Cliente_Oportunidade_Ve, Cliente_Oportunidade_Edita, Cliente_Oportunidade_Tarefa_Ve, Cliente_Oportunidade_Tarefa_Edita,
			Cliente_Venda_Ve, Cliente_Venda_Edita, Lead_Ve, Lead_Edita, ExportaExcel, Origem_Cria, Cargo_Cria, Produto_Cria,
			Motivo_Cria, Cidade_Cria, Etiqueta_Cria, Comissao_Cria, Cliente_Exclui, Oportunidade_Exclui, Venda_Exclui, Lead_Exclui,
			ID_Criador)
		VALUES (@AccountId, 'Vendedor', 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 1, 1, 1, 1, 1, 1, 1, 0, 3, 3, 3, 3, @UserId)

	INSERT INTO Usuario_Perfil (ID_ClientePloomes, Descricao, Cliente_Ve, Cliente_Edita, Cliente_Tarefa_Ve, Cliente_Tarefa_Edita,
			Cliente_Oportunidade_Ve, Cliente_Oportunidade_Edita, Cliente_Oportunidade_Tarefa_Ve, Cliente_Oportunidade_Tarefa_Edita,
			Cliente_Venda_Ve, Cliente_Venda_Edita, Lead_Ve, Lead_Edita, ExportaExcel, Origem_Cria, Cargo_Cria, Produto_Cria,
			Motivo_Cria, Cidade_Cria, Etiqueta_Cria, Comissao_Cria, Cliente_Exclui, Oportunidade_Exclui, Venda_Exclui, Lead_Exclui,
			ID_Criador)
		VALUES (@AccountId, 'Representante', 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, @UserId)

	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Presidente', @UserId)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Diretor', @UserId)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Gerente', @UserId)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Coordenador', @UserId)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Supervisor', @UserId)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Analista', @UserId)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Assistente', @UserId)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Estagiário', @UserId)

	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Administrativo', @UserId)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Financeiro', @UserId)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Recursos Humanos', @UserId)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Comercial', @UserId)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Operacional', @UserId)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Marketing', @UserId)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Pós-vendas', @UserId)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Suprimentos', @UserId)

	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Agricultura / Pecuária', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Arquitetura e Urbanismo', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Bancário / Financeiro', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Comércio Varejista', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Concessionária / Auto Peças', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Consultoria', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Energia/ Eletricidade', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Indústria', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Gráfica/ Editora', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Incorporadora', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Imprensa', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Logística / Armazém', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Construção Civil', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Órgão Público', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Publicidade / Propaganda', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Restaurante', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Sindicato / Associação / ONG', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Telecomunicações', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Turismo / Hotelaria', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Contabilidade / Auditoria', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Educação/ Idiomas', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Engenharia', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Tecnologia da Informação', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Jurídica', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Metalúrgica / Siderúrgica', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Outros Serviços', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Representação Comercial', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Supermercado', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Seguros', @UserId)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Transportes', @UserId)

	INSERT INTO Cliente_Origem (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Indicação', @UserId)
	INSERT INTO Cliente_Origem (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Site', @UserId)
	INSERT INTO Cliente_Origem (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Telefone', @UserId)
	INSERT INTO Cliente_Origem (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Facebook', @UserId)
	INSERT INTO Cliente_Origem (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Linkedin', @UserId)
	INSERT INTO Cliente_Origem (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@AccountId, 'Marketing Pago', @UserId)


	--ABAS
	DECLARE @ID_FiltroGeral INT, @ID_FiltroGeralCampo INT, @ID_Tabela INT, @ID_TabelaCampo INT

	--ABA DE CLIENTES EMPRESAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Empresas', '$filter=((TypeId+eq+1))', 1, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1042, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 1, 'Empresas', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1016, 1, 0, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1027, 1, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1027, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1040, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1040, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1093, 1, 3)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1164, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1020, 1, 4)


	--ABA DE CLIENTES PESSOAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Pessoas', '$filter=((TypeId+eq+2))', 1, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1042, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 2)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 1, 'Pessoas', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1016, 1, 0, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1021, 1, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1021, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1032, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1032, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1022, 1, 3)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1030, 1, 4)


	--ABA DE PRODUTOS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Produtos do cliente', '$filter=true', 75, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@AccountId, 75, 'Produtos do cliente', @ID_FiltroGeral, @UserId, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1374, 1, 0, 1)


	--ABA DE PRODUTOS DE CLIENTES
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Produtos de clientes', '$filter=true', 75, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel) VALUES (@AccountId, 75, 'Produtos de clientes', @ID_FiltroGeral, @UserId, 0)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1373, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1374, 1, 1, 0)


	--ABA DE CONTATOS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Contatos do cliente', '$filter=true', 1, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@AccountId, 1, 'Contatos do cliente', @ID_FiltroGeral, @UserId, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1016, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1032, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1030, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1022, 1, 3, 0)


	--ABA DE NEGÓCIOS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Negócios do cliente', '$filter=true', 2, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@AccountId, 2, 'Negócios do cliente', @ID_FiltroGeral, @UserId, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1046, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1050, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1053, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1265, 1, 3, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1049, 1, 4, 0)


	--ABA DE VENDAS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Vendas do cliente', '$filter=true', 4, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@AccountId, 4, 'Vendas do cliente', @ID_FiltroGeral, @UserId, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1171, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1172, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1173, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1177, 1, 3, 0)


	--ABA DE PRODUTOS DE VENDAS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Produtos de vendas do cliente', '$filter=true', 20, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@AccountId, 20, 'Produtos de vendas do cliente', @ID_FiltroGeral, @UserId, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1200, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1203, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1201, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1204, 1, 3, 0)


	--ABA DE PROPOSTAS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Propostas do cliente', '$filter=true', 7, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@AccountId, 7, 'Propostas do cliente', @ID_FiltroGeral, @UserId, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1110, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1117, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1124, 1, 3, 0)


	--ABA DE PRODUTOS DE PROPOSTAS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Produtos de propostas do cliente', '$filter=true', 14, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@AccountId, 14, 'Produtos de propostas do cliente', @ID_FiltroGeral, @UserId, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1130, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1133, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1131, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1134, 1, 3, 0)


	--ABA DE DOCUMENTOS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Documentos do cliente', '$filter=true', 66, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@AccountId, 66, 'Documentos do cliente', @ID_FiltroGeral, @UserId, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1328, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1329, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1331, 1, 2, 0)


	--ABA DE PRODUTOS DE DOCUMENTOS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Produtos de documentos do cliente', '$filter=true', 68, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@AccountId, 68, 'Produtos de documentos do cliente', @ID_FiltroGeral, @UserId, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1316, 1, 0, 1)


	--ABA DE OPORTUNIDADES EM ABERTO
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Em aberto', '$filter=StatusId+eq+1', 2, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 2, 'Em aberto', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1046, 1, 0, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1047, 1, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1047, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1049, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1049, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1053, 1, 3)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1048, 1, 4)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1082, 1, 5)

	INSERT INTO Oportunidade_Funil_Tabela (ID_Funil, ID_Tabela) VALUES (@ID_Funil, @ID_Tabela)


	--ABA DE OPORTUNIDADES GANHAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Ganhas', '$filter=StatusId+eq+2', 2, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 2)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 2, 'Ganhas', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1046, 1, 0, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1047, 1, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1047, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1049, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1049, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1053, 1, 3)

	INSERT INTO Oportunidade_Funil_Tabela (ID_Funil, ID_Tabela) VALUES (@ID_Funil, @ID_Tabela)


	--ABA DE OPORTUNIDADES PERDIDAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Perdidas', '$filter=StatusId+eq+3', 2, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 3)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 2, 'Perdidas', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1046, 1, 0, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1047, 1, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1047, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1049, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1049, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1053, 1, 3)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1080, 1, 4)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1080, 1, 1)

	INSERT INTO Oportunidade_Funil_Tabela (ID_Funil, ID_Tabela) VALUES (@ID_Funil, @ID_Tabela)


	--ABA DE PROPOSTAS EM ABERTO
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Propostas em aberto', '$filter=Deal/StatusId+eq+1', 7, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 1)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_FiltroGeralCampo, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 7, 'Propostas em aberto', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1112, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1047, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1047, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1115, 1, 3)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1115, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1117, 1, 4)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1110, 1, 5)
	
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1048, 1, 6)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)


	--ABA DE PROPOSTAS GANHAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Propostas ganhas', '$filter=Deal/StatusId+eq+2', 7, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 2)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_FiltroGeralCampo, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 7, 'Propostas ganhas', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1112, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1047, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1047, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1117, 1, 3)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1110, 1, 4)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1051, 1, 5)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)


	--ABA DE PROPOSTAS PERDIDAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Propostas perdidas', '$filter=Deal/StatusId+eq+3', 7, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 3)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_FiltroGeralCampo, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 7, 'Propostas perdidas', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1112, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1047, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1047, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1117, 1, 3)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1110, 1, 4)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1051, 1, 5)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1080, 1, 6)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1080, 1, 2)


	--ABA DE PRODUTOS DE PROPOSTAS EM ABERTO
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Propostas em aberto', '$filter=Deal/StatusId+eq+1', 14, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 1)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_FiltroGeralCampo, 1263, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 14, 'Propostas em aberto', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1138, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1140, 1, 1, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1138, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1102, 1, 2, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1130, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1133, 1, 3, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1131, 1, 4, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1135, 1, 5, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1134, 1, 6, 0)


	--ABA DE PRODUTOS DE PROPOSTAS GANHAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Propostas ganhas', '$filter=Deal/StatusId+eq+2', 14, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 2)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_FiltroGeralCampo, 1263, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 14, 'Propostas ganhas', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1138, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1140, 1, 1, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1138, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1102, 1, 2, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1130, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1133, 1, 3, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1131, 1, 4, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1135, 1, 5, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1134, 1, 6, 0)


	--ABA DE PRODUTOS DE PROPOSTAS PERDIDAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Propostas perdidas', '$filter=Deal/StatusId+eq+3', 14, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 3)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_FiltroGeralCampo, 1263, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 14, 'Propostas perdidas', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1138, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1140, 1, 1, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1138, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1102, 1, 2, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1130, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1133, 1, 3, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1131, 1, 4, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1135, 1, 5, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1134, 1, 6, 0)


	--ABA DE VENDAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Vendas', '$filter=true', 4, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 4, 'Vendas', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito, Crescente) VALUES (@ID_Tabela, 1171, 1, 0, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1189, 1, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1173, 1, 2)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1172, 1, 3)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1208, 1, 4)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1177, 1, 5)


	--ABA DE PRODUTOS DE VENDAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Produtos de vendas', '$filter=true', 20, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 20, 'Produtos de vendas', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito, Crescente) VALUES (@ID_Tabela, 1171, 1, 0, 1, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1207, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1189, 1, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1207, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1200, 1, 2)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1203, 1, 3)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1201, 1, 4)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1205, 1, 5)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1204, 1, 6)


	--ABA DE DOCUMENTOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Documentos', '$filter=true', 66, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, Url, ID_Filtro, ID_Criador) VALUES (@AccountId, 66, 'Documentos', '$select=Name,Id,DocumentNumber,Date&$expand=Contact($select=Id,Name)', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Crescente) VALUES (@ID_Tabela, 1328, 1, 0, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1306, 1, 1, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1308, 1, 2)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1329, 1, 3)


	--ABA DE LEADS DISPONÍVEIS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Leads disponíveis', '$filter=((Status/Id+ne+4+and+Status/Id+ne+5+and+Status/Id+ne+6))', 3, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1254, 1, 1, 2)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 4)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1254, 1, 1, 2)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 5)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1254, 1, 1, 2)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 6)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 3, 'Leads disponíveis', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1240, 1, 10)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1243, 1, 20)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1247, 1, 30)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1245, 1, 40)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1246, 1, 50)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1254, 1, 60)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1256, 1, 70)


	--ABA DE LEADS DISPONÍVEIS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Leads descartados', '$filter=((Status/Id+eq+4))', 3, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1254, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 4)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 3, 'Leads descartados', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1240, 1, 10)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1243, 1, 20)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1247, 1, 30)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1245, 1, 40)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1246, 1, 50)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1254, 1, 60)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1256, 1, 70)


	--ABA DE LEADS DISPONÍVEIS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Leads convertidos', '$filter=((Status/Id+eq+5+or++Status/Id+eq+6))', 3, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1254, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 5)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1254, 1, 2, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 6)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 3, 'Leads convertidos', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1240, 1, 10)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1243, 1, 20)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1247, 1, 30)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1245, 1, 40)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1246, 1, 50)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1254, 1, 60)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1256, 1, 70)


	--ABA DE PRODUTOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Produtos', '$filter=true', 10, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 10, 'Produtos', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1259, 1, 0, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1102, 1, 1, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1107, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1167, 1, 3, 0)


	--ABA DE GRUPOS DE PRODUTOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Grupos de produtos', '$filter=true', 11, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 11, 'Grupos de produtos', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1108, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1168, 1, 1, 0)


	--ABA DE FAMÍLIAS DE PRODUTOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Famílias de produtos', '$filter=true', 43, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 43, 'Famílias de produtos', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1169, 1, 0, 1)


	--ABA DE LISTAS DE PRODUTOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Listas de produtos', '$filter=true', 76, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 76, 'Listas de produtos', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1388, 1, 0, 1)


	--ABA DE REGISTROS DE INTERAÇÃO
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Registros de interação', '$filter=true', 36, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 36, 'Registros de interação', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1091, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Crescente) VALUES (@ID_Tabela, 1093, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1165, 1, 2)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1096, 1, 3)


	--ABA DE USUÁRIOS ATIVOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Usuários ativos', '$filter=not+Suspended', 24, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1348, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorBooleano) VALUES (@ID_FiltroGeralCampo, 0)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 24, 'Usuários ativos', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1055, 1, 10)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1054, 1, 20)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1220, 1, 30)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1158, 1, 40)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1159, 1, 50)



	--ABA DE USUÁRIOS INATIVOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Usuários inativos', '$filter=Suspended', 24, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1348, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorBooleano) VALUES (@ID_FiltroGeralCampo, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 24, 'Usuários inativos', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1055, 1, 10)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1054, 1, 20)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1220, 1, 30)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1158, 1, 40)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1159, 1, 50)



	--FORMS
	DECLARE @ID_FormularioRapido_Segmento INT, @ID_FormularioRapido_Origem INT,
		@ID_FormularioRapido_Cargo INT, @ID_FormularioRapido_Departamento INT, @ID_FormularioRapido_Cidade INT,
		@ID_FormularioRapido_Marcador INT, @ID_Formulario_Empresa INT, @ID_FormularioRapido_Empresa INT, @ID_FormularioRapido_QtdFuncionarios INT,
		@ID_Formulario_Pessoa INT, @ID_FormularioRapido_Pessoa INT,
		@ID_Formulario_Lead INT,
		@ID_Formulario_Produto INT, @ID_Formulario_Produto_Grupo INT, @ID_Formulario_Produto_Familia INT,
		@ID_FormularioRapido_Produto INT, @ID_FormularioRapido_Produto_Grupo INT


	--LINE OF BUSINESS QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@AccountId, 37, 'contact_line_of_business_quick_form')

	SET @ID_FormularioRapido_Segmento = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Segmento, 1098, 1, 10, 0)



	--ORIGIN QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@AccountId, 35, 'contact_origin_quick_form')

	SET @ID_FormularioRapido_Origem = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Origem, 1087, 1, 10, 0)



	--ROLE QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@AccountId, 38, 'role_quick_form')

	SET @ID_FormularioRapido_Cargo = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Cargo, 1099, 1, 10, 0)



	--DEPARTMENT QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@AccountId, 39, 'department_quick_form')

	SET @ID_FormularioRapido_Departamento = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Departamento, 1100, 1, 10, 0)



	--NUMBER OF EMPLOYEES QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@AccountId, 40, 'contact_number_of_employees_quick_form')

	SET @ID_FormularioRapido_QtdFuncionarios = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_QtdFuncionarios, 1101, 1, 10, 0)



	--CITY QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@AccountId, 25, 'city_quick_form')

	SET @ID_FormularioRapido_Cidade = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Cidade, 1056, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Cidade, 1058, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Cidade, 1057, 1, 30, 0)



	--TAG QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@AccountId, 23, 'tag_quick_form')

	SET @ID_FormularioRapido_Marcador = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Marcador, 1044, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Marcador, 1045, 1, 20, 0)



	--PRODUCT GROUP QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@AccountId, 11, 'product_group_quick_form')

	SET @ID_FormularioRapido_Produto_Grupo = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Produto_Grupo, 1108, 1, 10, 0)



	--PRODUCT QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 10, 'product_quick_form', 'Produtos (mini)', 1, 9)

	SET @ID_FormularioRapido_Produto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Produto, 1102, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Produto, 1107, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Produto, 1103, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Produto, 1106, 1, 40, 0)



	--COMPANY QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 1, 'contact_company_quick_form', 'Empresas (mini)', 1, 2)

	SET @ID_FormularioRapido_Empresa = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Empresa, 1016, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Empresa, 1024, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Empresa, 1025, 1, 50, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Empresa, 1043, 1, 60, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Empresa, 1030, 1, 70, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Empresa, 1022, 1, 80, 0)



	--PERSON QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 1, 'contact_person_quick_form', 'Pessoas (mini)', 1, 4)

	SET @ID_FormularioRapido_Pessoa = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Pessoa, 1016, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Pessoa, 1032, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Pessoa, 1033, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Pessoa, 1030, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Pessoa, 1022, 1, 50, 0)



	--TASK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@AccountId, 12, 'task_form')

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Secao (ID_Formulario, Ordem)
		VALUES (@ID_Formulario, 10)

	SET @ID_Secao = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1001, 1, 10, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1002, 1, 20, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1003, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1004, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1005, 1, 50, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_Formulario, @ID_Secao, 1006, 1, 60, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_Formulario, @ID_Secao, 1007, 1, 65, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1008, 1, 70, 1)

	INSERT INTO Formulario_Secao (ID_Formulario, Ordem)
		VALUES (@ID_Formulario, 20)

	SET @ID_Secao = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1009, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1010, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1013, 1, 30, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1011, 1, 40, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1014, 1, 50, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1012, 1, 60, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1015, 1, 70, 1)



	--COMPANY FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 1, 'contact_company_form', 'Empresas', 1, 1)

	SET @ID_Formulario_Empresa = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1016, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1017, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1024, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1025, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1018, 1, 50, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1022, 1, 60, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1043, 1, 70, 1)

	INSERT INTO Formulario_Secao (ID_Formulario, Descricao, Ordem)
		VALUES (@ID_Formulario_Empresa, 'Localização', 80)

	SET @ID_Secao = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1036, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1037, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1038, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1039, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1040, 1, 50, 0)

	INSERT INTO Formulario_Secao_Language (SectionId, LanguageId, [Name])
		VALUES (@ID_Secao, 1, 'Localização'), 
			   (@ID_Secao, 2, 'Localization'),
			   (@ID_Secao, 3, 'Localização'),
			   (@ID_Secao, 4, 'Localización')

	INSERT INTO Formulario_Secao (ID_Formulario, Descricao, Ordem)
		VALUES (@ID_Formulario_Empresa, 'Outras informações', 90)

	SET @ID_Secao = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1030, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1031, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1027, 1, 70, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1023, 1, 100, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1029, 1, 120, 1)
	
	INSERT INTO Formulario_Secao_Language (SectionId, LanguageId, [Name])
		VALUES (@ID_Secao, 1, 'Outras informações'), 
			   (@ID_Secao, 2, 'Other informations'),
			   (@ID_Secao, 3, 'Outras Informações'),
			   (@ID_Secao, 4, 'Otras informaciones')



	--PERSON FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 1, 'contact_person_form', 'Pessoas', 1, 3)

	SET @ID_Formulario_Pessoa = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, 1016, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, 1021, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, 1022, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, 1030, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, 1032, 1, 50, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, 1033, 1, 60, 0)

	INSERT INTO Formulario_Secao (ID_Formulario, Descricao, Ordem)
		VALUES (@ID_Formulario_Pessoa, 'Outras informações', 70)

	SET @ID_Secao = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, @ID_Secao, 1019, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, @ID_Secao, 1028, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, @ID_Secao, 1027, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, @ID_Secao, 1029, 1, 40, 1)

	INSERT INTO Formulario_Secao_Language (SectionId, LanguageId, [Name])
		VALUES (@ID_Secao, 1, 'Outras informações'), 
			   (@ID_Secao, 2, 'Other informations'),
			   (@ID_Secao, 3, 'Outras Informações'),
			   (@ID_Secao, 4, 'Otras informaciones')



	--CONTACT PRODUCT FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 75, 'contact_product_form', 'Produtos de clientes', 1, 5)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1373, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1374, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente)
		VALUES (@ID_Formulario, 1425, 1, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1426, 1, 1)


	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, FilterForm, BaseNameId)
		VALUES (@AccountId, 75, 'contact_product_filter_form', 'Filtro de produtos de clientes', 1, 1, 6)



	--CONTACT PRODUCT QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 75, 'contact_product_quick_form', 'Produtos de clientes (mini)', 1, 28)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1373, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1374, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente)
		VALUES (@ID_Formulario, 1425, 1, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1426, 1, 1)



	--INTERACTION RECORD FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 36, 'interaction_record_form', 'Registros de interação', 1, 18)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem,  Expandido)
		VALUES (@ID_Formulario, 1091, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1092, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1093, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1095, 1, 40, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1096, 1, 50, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1094, 1, 60, 1)



	--INTERACTION RECORD EDIT FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@AccountId, 36, 'interaction_record_edit_form')

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1093, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1095, 1, 40, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1096, 1, 50, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1094, 1, 60, 1)



	--LEAD FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 3, 'lead_form', 'Leads', 1, 7)

	SET @ID_Formulario_Lead = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Lead, 1240, 1, 10, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1241, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1242, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Lead, 1243, 1, 40, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1244, 1, 50, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1245, 1, 60, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1246, 1, 70, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1247, 1, 80, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1256, 1, 90, 1)



	--PRODUCT FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 10, 'product_form', 'Produtos', 1, 8)

	SET @ID_Formulario_Produto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto, 1102, 1, 10, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto, 1103, 1, 20, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto, 1107, 1, 30, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto, 1104, 1, 40, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto, 1106, 1, 50, 0, 0)


	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, FilterForm, BaseNameId)
		VALUES (@AccountId, 10, 'product_filter_form', 'Filtro de produtos da base', 1, 1, 14)



	--PRODUCT GROUP FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 11, 'product_group_form', 'Grupos de produtos', 1, 10)

	SET @ID_Formulario_Produto_Grupo = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto_Grupo, 1108, 1, 10, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto_Grupo, 1168, 1, 20, 0, 0)



	--PRODUCT FAMILY FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 43, 'product_family_form', 'Famílias de produtos', 1, 11)

	SET @ID_Formulario_Produto_Familia = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto_Familia, 1169, 1, 10, 0, 1)



	--PRODUCT LIST FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel)
		VALUES (@AccountId, 76, 'product_list_form', 'Listas de produtos', 1)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1388, 1, 10, 0, 1)


	--ORDER FORM
	DECLARE @ID_FormularioVenda INT, @ID_FormularioBloco INT, @ID_FormularioBloco2 INT, @ID_FormularioBloco3 INT,
	@ID_FormularioProduto INT, @ID_FormularioProduto2 INT, @ID_FormularioProduto3 INT,
	@ID_FormularioParte INT, @ID_Modelo INT
	
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel)
		VALUES (@AccountId, 20, 'order_product_form', 'Produtos das vendas', 0)

	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioProduto, 1200, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioProduto, 1201, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioProduto, 1202, 1, 30, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioProduto, 1203, 1, 35, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioProduto, 1205, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioProduto, 1202, 1, 50, 0, 2)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioProduto, 1204, 1, 55, 0, 2)


	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel)
		VALUES (@AccountId, 5, 'order_section_form', 'Seções das vendas', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1198, 1, 10, 1, @ID_FormularioProduto)
	

	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel)
		VALUES (@AccountId, 4, 'order_form', 'Vendas', 0)

	SET @ID_FormularioVenda = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1190, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1191, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1172, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1183, 1, 50, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1192, 1, 60, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1189, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, ID_FormularioRapido, Codigo_Bloco)
		VALUES (@ID_FormularioVenda, 1196, 1, 70, 1, @ID_FormularioBloco, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1193, 1, 80, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1194, 1, 90, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioVenda, 1195, 1, 100, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioVenda, 1173, 1, 105, 0, 1)

	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, HTML, Margem_Superior, Margem_Inferior, Margem_Lateral, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@AccountId, 4, @ID_FormularioVenda, 'Modelo padrão', @UserId, 1,
			N'<table border="0" cellpadding="0" cellspacing="0" style="width:758px"><tbody><tr><td style="border-bottom:2px solid #aaaaaa; border-left-color:#ffffff; border-right-color:#ffffff; border-top-color:#ffffff; padding-bottom:10px; width:385px"><span style="font-size:0.875em"><span style="color:#808080"><field format="dd/MM/yyyy" key="order_date">[Venda.Data]</field></span></span></td><td style="border-bottom:2px solid #aaaaaa; border-left-color:#ffffff; border-right-color:#ffffff; border-top-color:#ffffff; padding-bottom:10px; text-align:right; width:370px"><span style="color:#808080"><span style="font-size:11.375px">Venda&nbsp;</span></span><span style="font-size:1.000em"><strong><field class="h-card" key="order_number">[Venda.Número]</field></strong></span>&nbsp;</td></tr></tbody></table><div style="height:5px">&nbsp;</div><table border="0" cellpadding="0" cellspacing="0" style="width:758px"><tbody><tr><td style="border-color:white; vertical-align:middle; width:114px"><div style="border:1px solid #aaaaaa; display:inline-block; height:98px; line-height:0; width:98px"><img alt="" field-key="account_logo_url" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/default_company_logo.png" width="98" /></div></td><td style="border-color:white; vertical-align:top; width:641px"><p><span style="font-size:1.000em"><strong><field class="h-card" key="account_name">[Sua Empresa.Nome]</field></strong></span></p><div style="display:block"><span style="font-size:0.875em"><field class="h-card" key="account_phone">[Sua Empresa.Telefone]</field></span></div><div style="display:block"><span style="font-size:0.875em"><field class="h-card" key="account_email">[Sua Empresa.E-mail]</field></span></div><div style="display:block"><span style="font-size:0.875em"><field class="h-card" key="account_street_address">[Sua Empresa.Endereço]</field></span></div><div style="display:block"><span style="font-size:0.875em"><field class="h-card" key="account_website">[Sua Empresa.Website]</field></span></div></td></tr></tbody></table><div style="height:5px">&nbsp;</div><div style="border-bottom:2px solid #aaaaaa; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div><table border="0" cellpadding="0" cellspacing="0" style="width:758px"><tbody><tr><td style="border-color:white; width:482px"><p><span style="font-size:1.000em"><strong>Cliente:&nbsp;<field class="h-card" key="contact_name">[Cliente.Nome]</field></strong></span></p><div style="display:block"><field class="h-card" key="contact_cnpj">[Cliente.CPF / CNPJ]</field></div><div style="display:block"><field class="h-card" key="contact_street_address">[Cliente.Endereço]</field></div><div style="display:block"><field class="h-card" key="contact_neighborhood">[Cliente.Bairro]</field></div><div style="display:block"><field class="h-card" key="city_name">[Cliente.Cidade]</field>&nbsp;<field class="h-card" key="state_short">[Cliente.UF]</field></div><div style="display:block"><field class="h-card" format="00000-000" key="contact_zipcode">[Cliente.CEP]</field></div></td></tr></tbody></table><div style="height:5px">&nbsp;</div><div style="border-bottom:2px solid #aaaaaa; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div><div style="font-size:0.875em"><p>&nbsp;</p></div><condition field-key="order_discount" operation="&gt;" value="0"> </condition><table border="1" cellpadding="4" cellspacing="0" section-code="0" section-name="Lista de produtos/serviços" style="border-color:#aaaaaa; width:758px"><tbody><tr style="background-color:#eeeeee; border-color:#aaaaaa"><th style="border-top-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-left-color: rgb(170, 170, 170); border-right: 0px; break-inside: avoid; width: 43px;"><span style="font-size:0.875em">Item</span></th><th style="border-top-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-right: 0px; border-left: 0px; break-inside: avoid; width: 123px; text-align: left;"><span style="font-size:0.875em">Grupo</span></th><th style="border-top-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-right: 0px; border-left: 0px; break-inside: avoid; width: 140px; text-align: left;"><span style="font-size:0.875em">Produto/Serviço</span></th><th style="border-top-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-right: 0px; border-left: 0px; break-inside: avoid; width: 61px; text-align: left;"><span style="font-size:0.875em">Qtd.</span></th><th style="border-top-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-right: 0px; border-left: 0px; break-inside: avoid; width: 99px; text-align: left;"><span style="font-size:0.875em">Valor unitário</span></th><th style="border-top-color: rgb(170, 170, 170); border-right-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-left: 0px; break-inside: avoid; width: 108px; text-align: left;"><span style="font-size:0.875em">Desconto</span></th><th style="border-top-color: rgb(170, 170, 170); border-right-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-left: 0px; break-inside: avoid; width: 125px; text-align: right;"><span style="font-size:0.875em">Total</span></th></tr><tr class="h-card" multiple-field-key="order_section_products"><td style="border-color:#aaaaaa; break-inside:avoid; text-align:center; width:43px"><span style="font-size:0.875em"><index field-key="order_section_products">1</index></span></td><td style="border-color:#aaaaaa; break-inside:avoid; width:122px"><span style="font-size:0.875em"><field class="h-card" key="product_group_name">[Grupo do Produto.Nome]</field></span></td><td style="border-color:#aaaaaa; break-inside:avoid; width:139px"><span style="font-size:0.875em"><field class="h-card" key="product_name">[Produto.Nome]</field></span></td><td style="border-color:#aaaaaa; break-inside:avoid; width:60px"><span style="font-size:0.875em"><field class="h-card" key="order_product_quantity">[Produto.Quantidade]</field></span></td><td style="border-color:#aaaaaa; break-inside:avoid; width:98px"><span style="font-size:0.875em"><field class="h-card" key="order_product_currency">[Produto.Moeda]</field>&nbsp;<field class="h-card" format="n2" key="order_product_unit_price">[Produto.Valor unitário]</field></span></td><td style="border-color:#aaaaaa; break-inside:avoid; width:107px"><condition field-key="order_product_discount" operation="&gt;" value="0"><span style="font-size:0.875em"><field class="h-card" format="n1" key="order_product_discount">[Produto.Desconto]</field>%</span></condition></td><td style="border-color:#aaaaaa; break-inside:avoid; text-align:right; width:125px"><span style="font-size:0.875em"><field class="h-card" key="order_product_currency">[Produto.Moeda]</field>&nbsp;<field class="h-card" format="n2" key="order_product_total">[Produto.Total]</field></span></td></tr><tr style="background-color:#eeeeee"><td colspan="6" rowspan="1" style="border-color:#aaaaaa; break-inside:avoid; text-align:right; width:614px"><span style="font-size:0.875em">Desconto:</span></td><td style="border-color:#aaaaaa; break-inside:avoid; text-align:right; width:125px"><span style="font-size:0.875em"><field class="h-card" format="n1" key="order_discount">[Venda.Desconto]</field>%</span></td></tr><tr style="background-color:#eeeeee"><td colspan="6" rowspan="1" style="border-color:#aaaaaa; break-inside:avoid; text-align:right; width:614px"><span style="font-size:0.875em"><strong>Total:</strong></span></td><td style="border-color:#aaaaaa; break-inside:avoid; text-align:right; width:125px"><span style="font-size:0.875em"><strong><field class="h-card" key="order_currency">[Venda.Moeda]</field>&nbsp;<field class="h-card" format="n2" key="order_amount">[Venda.Valor]</field></strong></span></td></tr></tbody></table><p>&nbsp;</p><p><span style="font-size:0.875em"><strong>Informações da venda</strong></span></p><p><span style="font-size:0.875em"><field class="h-card" key="order_description">[Venda.Informações]</field></span></p><p>&nbsp;</p><div style="height:5px">&nbsp;</div><div style="border-bottom:2px solid #aaaaaa; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div><p><span style="font-size:0.875em"><strong>Responsável</strong></span></p><div style="font-size:0.875em"><p><field class="h-card" key="user_name">[Responsável.Nome]</field></p><p><field class="h-card" key="user_email">[Responsável.E-mail]</field></p><p><field class="h-card" key="user_phone">[Responsável.Telefone]</field></p></div>',
			10, 10, 5, 'True', 1173, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_FormularioVenda, @ID_FormularioBloco, @ID_FormularioProduto)



	--QUOTES FORMS: PADRÃO
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1131, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1133, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1135, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1134, 1, 40)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1136, 1, 10, @ID_FormularioProduto)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco, 1128, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 7, 'quote_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1110, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1115, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 30, 0, 'Produtos', @ID_FormularioBloco)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1117, 1, 40)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1122, 1, 50)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1121, 1, 60)



	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@AccountId, 7, @ID_Formulario, '[MODELO 0] Padrão', @UserId, 1, 1, 1117, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_Formulario, @ID_FormularioBloco, @ID_FormularioProduto)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Seção 1',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><style type="text/css">p {font-family:Trebuchet MS,Helvetica,sans-serif}</style><div style="position:relative"><span><span><span><span><span><span><img alt="" height="1122.5" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/b9d0c0c75db243f09025d99f09d8fea6.png" width="800" /></span></span></span></span></span></span><div style="position:absolute; top:300px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:77px">&nbsp;</td><td style="width:619px"><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:23px"><span style="font-size:48px"><strong>PROPOSTA<br />COMERCIAL</strong></span></span></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><span style="font-size:23px"><span><span><span><span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></span></span></span></span></span></p><p style="text-align:center">&nbsp;</p></td><td style="width:97px">&nbsp;</td></tr></tbody></table></div></div>',
			'', 0, '', 0, 0, 0, 0, 10)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Seção 2',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><style type="text/css">p {font-family:Trebuchet MS,Helvetica,sans-serif;}</style><p>&nbsp;</p><div style="height:5px">&nbsp;</div><div style="border-bottom:5px solid #331f4d; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="background-color:#331f4d; border-color:#ffffff; text-align:center; width:193px"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><span style="color:#ffffff"><span><span><field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></strong></span></span></td><td style="background-color:#eeeeee; border-color:#cccccc; text-align:right; width:446px"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999">Proposta nº&nbsp;<span><span><span><field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.Código]</field></span>&nbsp;&nbsp;</span></span></span></span></span></td></tr></tbody></table><p style="text-align:center">&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><strong><span style="font-size:14px"><span><span><span><span><span><span><span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></span></span></span></span></span></span></strong></span></span></p><p style="text-align:center">&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><span style="font-size:14px"><strong>A/C:</strong> <span><span><span><span><span><span><span><span><span><span><span><field key="contact_name" path-id="64">[Contato.Nome]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p field-path-id="64" multiple-field-key="contact_phones"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><span style="font-size:14px"><strong>Telefone:</strong> <span><span><span><span><span><span><span><span><span><span><span><field key="contact_phones" path-id="64">[Contato.Telefones]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><span style="font-size:14px"><strong>E-mail:</strong>&nbsp;<span><span><span><span><span><span><span><span><span><span><span><field key="contact_email" path-id="64">[Contato.E-mail]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p>&nbsp;</p><p>&nbsp;</p><p><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><span style="color:#331f4d">Seguem condições da proposta comercial:</span></strong></span></span></p><p>&nbsp;</p><table border="2" cellpadding="3" cellspacing="0" class="no-border" section-code="0" section-name="Produtos" section-no-products="" style="width:100%"><tbody><tr style="border-bottom:2px solid #331f4d !important; page-break-inside:avoid"><th style="width: 87px; background-color: rgb(238, 238, 238); border-color: rgb(238, 238, 238);"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px">Item</span></span></span></th><th style="width: 168px; background-color: rgb(238, 238, 238); border-color: rgb(238, 238, 238);"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px">Nome</span></span></span></th><th style="width: 98px; background-color: rgb(238, 238, 238); border-color: rgb(238, 238, 238);"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px">Quantidade</span></span></span></th><th style="width: 15%; background-color: rgb(238, 238, 238); border-color: rgb(238, 238, 238);"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px">Valor unitário</span></span></span></th><th style="width: 15%; background-color: rgb(238, 238, 238); border-color: rgb(238, 238, 238);"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px">Desconto</span></span></span></th><th style="width: 15%; background-color: rgb(238, 238, 238); border-color: rgb(238, 238, 238);"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px">Total</span></span></span></th></tr><tr multiple-field-key="quote_section_products" style="border-bottom:2px solid #eeeeee !important; page-break-inside:avoid"><td style="background-color:#ffffff; border-color:#bbbbbb; text-align:center; width:87px"><span style="font-size:12px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><index field-key="quote_section_products">[Produtos.Índice]</index></span></span></span></span></td><td style="background-color:#ffffff; border-color:#bbbbbb; text-align:center; width:168px"><span style="font-size:12px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><field key="product_name" path-id="19">[Produtos / Produto.Nome]</field></span></span></span></span></td><td style="background-color:#ffffff; border-color:#bbbbbb; text-align:center; width:98px"><span style="font-size:12px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><field format="n0" formattable="number" key="quote_product_quantity" path-id="3">[Produtos.Quantidade]</field></span></span></span></span></td><td style="background-color:#ffffff; border-color:#bbbbbb; text-align:center"><span style="font-size:12px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">R$&nbsp; <span><span><field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unitário]</field></span></span></span></span></td><td style="background-color:#ffffff; border-color:#bbbbbb; text-align:center"><span style="font-size:12px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><field format="n1" key="quote_product_discount" path-id="3">[Produtos.Desconto]</field></span></span>%</span></span></td><td style="background-color:#ffffff; border-color:#bbbbbb; text-align:center"><span style="font-size:12px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span>R$&nbsp;</span></span> <span><span><field format="n2" formattable="number" key="quote_product_total" path-id="3">[Produtos.Total]</field></span></span></span></span></td></tr><tr style="page-break-inside:avoid"><td colspan="5" rowspan="1" style="background-color:#eeeeee; border-color:#bbbbbb; text-align:right; width:73px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><strong>Total&nbsp; &nbsp;</strong></span></span></td><td style="background-color:#eeeeee; border-color:#bbbbbb; text-align:center"><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:12px">R$<span style="font-size:14px"> </span><span><span><field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></span></span></span></span></p></td></tr></tbody></table><p><span style="color:#c0392b"><field format="n2" formattable="number" key="quote_amount" path-id="56" style="display: none;">[Proposta.Valor]</field></span></p><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" style="width:100%"><tbody><tr><td style="background-color:#eeeeee; border-bottom:2px solid #331f4d !important; border-color:#ffffff"><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px"><strong>&nbsp;Forma de Pagamento</strong></span></span></span></p></td></tr><tr><td style="background-color:#eeeeee; border-color:#ffffff"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><span><span><span><span><span><span><span><span><span><span><span>&nbsp;<span><field key="quote_payment_method" path-id="56">[Proposta.Método de pagamento]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></td></tr><tr><td style="background-color:#ffffff; border-color:#ffffff">&nbsp;</td></tr><tr><td style="background-color:#eeeeee; border-bottom:2px solid #331f4d !important; border-color:#ffffff"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px"><strong>&nbsp;Prazo de Entrega</strong></span></span></span></td></tr><tr><td style="background-color:#eeeeee; border-color:#ffffff"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><span><span><span><span><span><span><span><span><span><span><span>&nbsp;<span><field key="quote_delivery_time" path-id="56">[Proposta.Prazo de entrega]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></td></tr></tbody></table><p>&nbsp;</p><div style="height:5px">&nbsp;</div><div style="border-bottom:4px solid #eeeeee; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div>',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="width:57px">&nbsp;</td><td style="width:179px">&nbsp;</td><td style="width:6px">&nbsp;</td><td style="width:541px">&nbsp;</td></tr><tr><td style="width:57px">&nbsp;</td><td style="width:179px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><img alt="" height="84" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/d4bbf421917a4eb09d4071aab7025555.png" width="156" /></span></span></span></td><td style="width:6px">&nbsp;</td><td style="width:541px"><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:#331f4d"><span><span><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></span></span></strong></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><strong>CNPJ:</strong> <span><span><field key="account_register" path-id="32">[Sua Empresa.CNPJ]</field></span></span></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><span><span><field key="account_phone" path-id="32">[Sua Empresa.Telefone]</field></span></span></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><span><span><field key="account_city" path-id="32">[Sua Empresa.Cidade]</field></span></span> - <span><span><field key="account_street_address_line2" path-id="32">[Sua Empresa.Complemento]</field></span></span></span></span></p></td></tr></tbody></table>',
			29, '', 0, 15, 0, 20, 20)



	--QUOTES FORMS: SERVIÇO SIMPLES
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1133, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1134, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1136, 1, 10, @ID_FormularioProduto)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco, 1128, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 7, 'quote_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1110, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1119, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 30, 0, 'Serviços', @ID_FormularioBloco)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1118, 1, 40)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1122, 1, 50)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1117, 1, 60)



	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@AccountId, 7, @ID_Formulario, '[MODELO 1] Serviço Simples', @UserId, 0, 1, 1117, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_Formulario, @ID_FormularioBloco, @ID_FormularioProduto)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Capa',
			'<div style="background-image:url(''https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/21747d940bfe4d7bae311227975158ff.png''); background-size:cover; height:1122.5px; overflow:hidden; position:relative; text-align:center; width:100%"><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p><strong><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:48px"><span style="color:#26668c">PROPOSTA</span></span></span></strong></p><div style="border-bottom:3px solid #26668c; height:2px; margin-left:auto; margin-right:auto; width:350px">&nbsp;</div><p><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:48px"><span style="color:#26668c">COMERCIAL</span></span></span></p><div style="bottom:170px; left:0; position:absolute; right:0; text-align:center"><span><span><span><span><span><span><span><span><span><span><img alt="" height="52" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/d4bbf421917a4eb09d4071aab7025555.png" width="96" /></span></span></span></span></span></span></span></span></span></span></div></div>',
			'', 0, '', 0, 0, 0, 0, 10)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Corpo',
			'<style type="text/css">.border-gray, .border-gray td, .border-gray th {border: 1px solid #bfced1!important;}</style><style type="text/css">p {font-family:Verdana,Geneva,sans-serif;}</style><p><strong style="color:#26668c; font-size:20px"><span style="font-family:Verdana,Geneva,sans-serif">Proposta comercial</span></strong></p><p>&nbsp;</p><table border="0" cellpadding="0" cellspacing="1" class="border-gray" style="width:100%"><tbody><tr><td style="border-bottom:1px solid #bfced1; border-left:1px solid #ffffff !important; border-top:1px solid #ffffff !important; padding-bottom:10px; padding-right:10px; padding-top:10px; width:493px"><p><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:1.125em">Direcionada para:</span></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:1.125em"><strong><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></strong></span></span></p></td><td style="background-color:#f6f8f8; border-style:solid; border-width:1px; padding:10px; text-align:right; width:159px"><p><span style="font-size:12px"><span style="font-family:Verdana,Geneva,sans-serif">Data</span></span></p><p><span style="font-size:12px"><span style="font-family:Verdana,Geneva,sans-serif"><strong><span><span><span><span><field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span></strong></span></span></p></td></tr></tbody></table><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="border-color:#ffffff!important; width:346px"><p><span style="font-family:Verdana,Geneva,sans-serif"><strong>Validade da proposta</strong></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field format="d" formattable="date" key="quote_expiration_date" path-id="56">[Proposta.Data de validade]</field></span></span></span></span></span></p></td><td style="border-color:#ffffff!important; text-align:right; width:291px"><p><span style="font-family:Verdana,Geneva,sans-serif"><strong>Número da proposta</strong></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.Código]</field></span></span></span></span></span></p></td></tr></tbody></table><p>&nbsp;</p><table border="0" cellpadding="5" cellspacing="0" class="border-gray" section-code="0" section-name="Serviços" section-no-products="" style="width:100%"><tbody><tr><th style="padding: 5px; width: 1px; text-align: left; background-color: rgb(38, 102, 140); border-top: 1px solid rgb(191, 206, 209);">&nbsp;</th><th colspan="3" rowspan="1" style="padding: 10px; width: 424px; text-align: left; background-color: rgb(246, 248, 248); border-top: 1px solid rgb(191, 206, 209);"><span style="font-family:Verdana,Geneva,sans-serif">Serviço</span></th><th style="padding: 10px; width: 156px; border-top: 1px solid rgb(191, 206, 209); border-right: 1px solid rgb(191, 206, 209); background-color: rgb(246, 248, 248);"><span style="font-family:Verdana,Geneva,sans-serif">Valor</span></th></tr><tr multiple-field-key="quote_section_products" style="page-break-inside:avoid"><td colspan="4" style="border-style:solid; border-width:1px; padding:10px; text-align:left; width:179px"><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:1.000em"><span><span><span><span><index field-key="quote_section_products">[Produtos.Índice]</index></span></span></span></span>.&nbsp;<span><span><span><span><field key="product_name" path-id="19">[Produtos / Produto.Nome]</field></span></span></span></span></span></span></td><td style="border-style:solid; border-width:1px; padding:10px; text-align:right; width:156px"><p style="text-align:center"><span style="font-family:Verdana,Geneva,sans-serif">R$&nbsp;<span><span><span><span><field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unitário]</field></span></span></span></span></span><span style="color:#c0392b"><span style="font-family:Verdana,Geneva,sans-serif"><field format="n2" formattable="number" key="quote_product_total" path-id="3" style="display: none;">[Produtos.Total]</field></span></span></p></td></tr><tr><td colspan="3" rowspan="1" style="border-bottom:1px solid #ffffff!important; border-left:1px solid #ffffff!important; padding:10px; text-align:center; width:290px"><p><span style="font-family:Verdana,Geneva,sans-serif">Forma de pagamento</span></p></td><td style="border-bottom:1px solid #bfced1; border-left:1px solid #bfced1; border-right:1px solid #bfced1; border-top-style:none; padding:10px; text-align:center; width:134px"><span style="font-family:Verdana,Geneva,sans-serif">Desconto</span></td><td style="border-bottom:1px solid #bfced1; border-left:1px solid #bfced1; border-right:1px solid #bfced1; border-top-style:none; padding:10px; text-align:center; width:156px"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field format="n1" key="quote_discount" path-id="56">[Proposta.Desconto]</field></span></span></span></span>&nbsp;%</span></td></tr><tr><td colspan="3" rowspan="1" style="border-bottom:1px solid #ffffff!important; border-left:1px solid #ffffff!important; padding:10px; text-align:center; width:290px"><span style="font-family:Verdana,Geneva,sans-serif"><strong><span><span><span><span><field key="quote_payment_method" path-id="56">[Proposta.Método de pagamento]</field></span></span></span></span></strong></span></td><td style="background-color:#f6f8f8; border-bottom:1px solid #bfced1; border-left:1px solid #bfced1; border-right:1px solid #bfced1; padding:10px; text-align:center; width:134px"><span style="font-family:Verdana,Geneva,sans-serif"><strong>Total</strong></span></td><td style="background-color:#f6f8f8; border-bottom:1px solid #bfced1; border-right:1px solid #bfced1; padding:10px; text-align:center; width:156px"><span style="font-family:Verdana,Geneva,sans-serif"><strong>R$&nbsp;<span><span><span><span><field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></span></span></span></span></strong></span></td></tr></tbody></table><p>&nbsp;</p><p><strong>R$&nbsp;<field format="n2" formattable="number" key="quote_amount" path-id="56">[Proposta.Valor]</field></strong></p><p>&nbsp;</p><table border="0" cellpadding="10" cellspacing="0" class="border-gray" style="width:100%"><tbody><tr><th style="width: 330px; text-align: left; background-color: rgb(246, 248, 248); border-left: 10px solid rgb(38, 102, 140); border-bottom: 1px solid rgb(191, 206, 209); border-top: 1px solid rgb(191, 206, 209);"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></span></span></span></span></th><th style="width: 312px; text-align: left; background-color: rgb(246, 248, 248); border-width: 1px 1px 1px 10px; border-style: solid; border-color: rgb(191, 206, 209) rgb(191, 206, 209) rgb(191, 206, 209) rgb(38, 102, 140);"><span style="font-family:Verdana,Geneva,sans-serif">Responsável</span></th></tr><tr><td style="border-color:#ffffff !important; text-align:left; width:330px"><p><span style="font-family:Verdana,Geneva,sans-serif"><strong><span><span><span><span><field key="account_website" path-id="32">[Sua Empresa.Site]</field></span></span></span></span></strong></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field key="account_street_address" path-id="32">[Sua Empresa.Endereço]</field></span></span></span></span></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field key="account_phone" path-id="32">[Sua Empresa.Telefone]</field></span></span></span></span></span></p></td><td style="border-color:#ffffff !important; text-align:left; width:312px"><p><span style="font-family:Verdana,Geneva,sans-serif"><strong><span><span><span><span><field key="user_name" path-id="80">[Proposta / Usuário.Nome]</field></span></span></span></span></strong></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field key="user_email" path-id="80">[Proposta / Usuário.E-mail]</field></span></span></span></span></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field key="user_phone" path-id="80">[Proposta / Usuário.Telefone]</field></span></span></span></span></span></p></td></tr></tbody></table>',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><table border="1" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="text-align:right; width:90px">&nbsp;</td><td style="text-align:right; width:643px"><p>&nbsp;</p><p>&nbsp;</p></td><td style="width:57px">&nbsp;</td></tr><tr><td style="text-align:right; width:90px">&nbsp;</td><td style="text-align:right; width:643px"><span><span><span><span><img alt="" height="54" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/d4bbf421917a4eb09d4071aab7025555.png" width="100" /></span></span></span></span></td><td style="width:57px">&nbsp;</td></tr></tbody></table>',
			27, '', 0, 15, 5, 20, 20)



	--QUOTES FORMS: PROJETOS
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1131, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1133, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1135, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1134, 1, 40)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1136, 1, 10, @ID_FormularioProduto)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco, 1128, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 7, 'quote_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1110, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1368, 1, 20, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1119, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1365, 1, 40, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 50, 0, 'Produtos', @ID_FormularioBloco)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1117, 1, 60)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1122, 1, 70)



	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@AccountId, 7, @ID_Formulario, '[MODELO 2] Projeto', @UserId, 0, 1, 1117, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_Formulario, @ID_FormularioBloco, @ID_FormularioProduto)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Seção 1',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><style type="text/css">p {font-family:Trebuchet MS,Helvetica,sans-serif}</style><div style="position:relative"><span><span><span><span><span><span><span><img alt="" height="1122.5" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/872e5d57f8da4a5c9f662d2ddae345d5.png" width="800" /></span></span></span></span></span></span></span><div style="position:absolute; top:136px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:60px">&nbsp;</td><td style="width:633px"><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><span><span><span><img alt="" height="92" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/dd92ae76c50c49808622e05a3c795eb3.png" style="float:right" width="170" /></span></span></span></span></span></span></span></span></p></td><td style="width:97px">&nbsp;</td></tr></tbody></table></div><div style="position:absolute; top:580px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:60px">&nbsp;</td><td style="width:645px"><p style="text-align:right"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span><span><span><span><span><span><field key="deal_title" path-id="24">[Negócio.Título]</field></span></span></span></span></span></span></span></span></span></p><p style="text-align:right"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><span style="color:#ffffff"><span><span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></span></strong></span></span></p><p>&nbsp;</p><div style="height:5px">&nbsp;</div><div style="border-bottom:2px solid #aaaaaa; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div><p>&nbsp;</p><p style="text-align:right"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span><span><span><span><span><span><field key="account_city" path-id="32">[Sua Empresa.Cidade]</field></span></span></span></span></span></span>,&nbsp;<span><span><span><span><span><field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span></span><br /><span><span><span><span><span><span><field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56" style="display: none;">[Proposta.Data]</field></span></span></span></span></span></span></span></span></span></p><p style="text-align:right">&nbsp;</p><p style="text-align:right"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span><span><span><span><span><span><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></span></span></span></span></span></span></span></span></p><p style="text-align:right"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><strong><span><span><span><span><span><span><field key="user_name" path-id="80">[Proposta / Usuário.Nome]</field></span></span></span></span></span></span></strong></span></span></span></p><p style="text-align:right"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span><span><span><span><span><span><field key="user_email" path-id="80">[Proposta / Usuário.E-mail]</field></span></span></span></span></span></span></span></span></span></p><p style="text-align:right">&nbsp;</p><p style="text-align:right">&nbsp;</p><p style="text-align:right">&nbsp;</p><p style="margin-left:196.35pt; text-align:right"><span style="color:#aaaaaa"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>Essa proposta é confidencial e endereçada<br />exclusivamente para&nbsp; <span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span>.<br />Não deve ser divulgada, utilizada ou duplicada,<br />em parte ou no todo, para qualquer outra finalidade<br />além da avaliação do negócio</em></span></span></span></p></td><td style="width:89px">&nbsp;</td></tr></tbody></table></div></div>',
			'', 0, '', 0, 0, 0, 0, 10)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Seção 2',
			'<style type="text/css">p {font-family:Trebuchet MS,Helvetica,sans-serif}</style><style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="background-color:#333333"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span style="font-size:20px"><strong>&nbsp;|&nbsp;<span><span><span><span><span><span><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></span></span></span></span></span></strong></span></span></span></td></tr></tbody></table><p>&nbsp;</p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:1.125em"><strong>SOBRE NÓS - ATUANDO DESDE 1996</strong></span></span></p><p>&nbsp;</p><p style="text-align:justify"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:11.375px; line-height:18.2px"><em>Aqui podemos contar um pouco sobre a história de nossa empresa. Temos diversos anos de experiência e excelência. Nossos clientes atestam a qualidade do serviço que prestamos.</em></span></span></p><p>&nbsp;</p><p style="text-align:justify"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:11.375px; line-height:18.2px"><em>Buscamos&nbsp;sempre entender a necessidade do cliente afundo antes de partirmos para qualquer tipo de solução. Aprendizado corre em nossas veias e colocamos o cliente sempre em primeiro lugar.&nbsp;</em></span></span></p><p>&nbsp;</p><p style="text-align:justify">&nbsp;</p><p style="text-align:justify"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><span><span><img alt="" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/893121A5CEA3/Imagem/80095ac51e304c7694ec98f204ebf35f.jpg" width="646" /></span></span></span></span></span></span></span></p><p style="text-align:justify">&nbsp;</p><p style="text-align:justify"><span style="font-size:14px"><strong><span style="font-family:Trebuchet MS,Helvetica,sans-serif">Conheça alguns de nossos Clientes:</span></strong></span></p><p style="text-align:justify">&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:644px"><tbody><tr><td style="width:22px">&nbsp;</td><td style="text-align:center; width:127px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>Tech Software</em></span></span></td><td style="text-align:center; width:165px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>Rio Engenharia</em></span></span></td></tr><tr><td style="width:22px">&nbsp;</td><td style="text-align:center; width:127px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>JSM Construtora</em></span></span></td><td style="text-align:center; width:165px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>Inovatti Pisos</em></span></span></td></tr><tr><td style="width:22px">&nbsp;</td><td style="text-align:center; width:127px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>Nativa Group</em></span></span></td><td style="text-align:center; width:165px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>Hello Ingredientes</em></span></span></td></tr><tr><td style="width:22px">&nbsp;</td><td style="text-align:center; width:127px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>HSO Empreendimentos</em></span></span></td><td style="text-align:center; width:165px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>RollTech</em></span></span></td></tr></tbody></table><p>&nbsp;</p><p style="text-align:center">&nbsp;</p><p>&nbsp;</p><table border="0" cellpadding="2" cellspacing="0" class="no-border" style="width:644px"><tbody><tr><td style="border-color:#ffffff; width:552px"><p><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>Descrição do projeto</strong></span></span></p><p><span style="font-size:12px"><span><span><span><field key="quote_description" path-id="56">[Proposta.Descrição]</field></span></span></span></span></p></td></tr></tbody></table>',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><table border="1" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="text-align:right; width:90px">&nbsp;</td><td style="text-align:right; width:645px">&nbsp;</td><td style="width:55px">&nbsp;</td></tr><tr><td style="text-align:right; width:90px">&nbsp;</td><td style="text-align:right; width:645px"><span><span><span><img alt="" height="60" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/dd92ae76c50c49808622e05a3c795eb3.png" width="111" /></span></span></span></td><td style="width:55px">&nbsp;</td></tr></tbody></table><p>&nbsp;</p><div style="height:5px">&nbsp;</div><div style="border-bottom:2px solid #aaaaaa; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div>',
			32,
			'<div style="height:5px">&nbsp;</div><div style="border-bottom:2px solid #aaaaaa; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div><p style="text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><field key="account_street_address" path-id="32">[Sua Empresa.Endereço]</field>&nbsp;-&nbsp;<field key="account_city" path-id="32">[Sua Empresa.Cidade]</field></span></p><p style="text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><field key="account_website" path-id="32">[Sua Empresa.Site]</field></strong>&nbsp;</span></p><p style="text-align:center">&nbsp;</p><p style="text-align:center">&nbsp;</p>',
			24, 15, 5, 20, 20)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Seção 3',
			'<style type="text/css">p {font-family:Trebuchet MS,Helvetica,sans-serif}</style><style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="background-color:#333333"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span style="font-size:20px"><strong>&nbsp;| PROPOSTA COMERCIAL</strong></span></span></span></td></tr></tbody></table><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif">&nbsp;</span></p><table border="0" cellpadding="1" cellspacing="1" style="width:100%"><tbody><tr><td style="border-color:#ffffff; vertical-align:top"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><span style="font-size:1.000em">Cliente:</span></strong>&nbsp;<span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></td><td style="border-color:#ffffff; text-align:right; width:390px"><p><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:1.000em"><strong>Número da proposta</strong>:</span>&nbsp;#<span><span><span><span><field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.Código]</field></span></span></span></span></span></span></p><p><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:1.000em">Data:</span>&nbsp;<span><span><span><span><field format="d" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span><br /><span style="font-size:0.875em"><em><strong>Validade:</strong><em>&nbsp;</em><span><span><span><span><field format="d" formattable="date" key="quote_expiration_date" path-id="56">[Proposta.Data de validade]</field></span></span></span></span></em></span></span></span></p></td></tr></tbody></table><p>&nbsp;</p><p><strong><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:1.000em">OBSERVAÇÕES</span></span></span></strong></p><p>&nbsp;</p><p><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><field key="quote_notes" path-id="56">[Proposta.Observações]</field></span></span></span></span></span></span></p><p>&nbsp;</p><p>&nbsp;</p><table border="0" cellpadding="2" cellspacing="0" class="no-border" section-code="0" section-name="Produtos" style="width:100%"><tbody><tr style="background-color:#849daa; border-bottom:2px solid #333333 !important; border-style:none; color:white"><td style="background-color:#ffffff; border-style:none; padding:10px; text-align:center; width:199px"><span style="color:#333333"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">&nbsp; <strong>Projeto</strong></span></span></span></td><td style="background-color:#ffffff; border-style:none; padding:10px; text-align:center; width:43px"><span style="color:#333333"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>Qtd.</strong></span></span></span></td><td style="background-color:#ffffff; border-style:none; padding:10px; text-align:center; width:135px"><span style="color:#333333"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>Valor unitário (R$)</strong></span></span></span></td><td style="background-color:#ffffff; border-style:none; padding:10px; text-align:center; width:92px"><span style="color:#333333"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>Desconto (%)</strong></span></span></span></td><td style="background-color:#ffffff; border-style:none; padding:10px; text-align:center; width:122px"><span style="color:#333333"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>Total (R$)</strong></span></span></span></td></tr><tr multiple-field-key="quote_section_products" style="border-bottom:2px solid #eeeeee !important; page-break-inside:avoid"><td style="border-style:none; padding:10px; text-align:center; width:199px"><span style="font-size:12px"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><field key="product_name" path-id="19">[Produtos / Produto.Nome]</field></span></span></span></span></span></span></span></td><td style="border-style:none; padding:10px; text-align:center; width:43px"><span style="font-size:12px"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><field format="n0" formattable="number" key="quote_product_quantity" path-id="3">[Produtos.Quantidade]</field></span></span></span></span></span></span></span></td><td style="border-style:none; padding:10px; text-align:center; width:135px"><span style="font-size:12px"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unitário]</field></span></span></span></span></span></span></span></td><td style="border-style:none; padding:10px; text-align:center; width:92px"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:0.875em"><span style="font-size:12px"><span><span><span><span><field format="n1" key="quote_product_discount" path-id="3">[Produtos.Desconto]</field></span></span></span></span></span></span></span></span></td><td style="border-style:none; padding:10px; text-align:center; width:122px"><span style="font-size:12px"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><field format="n2" formattable="number" key="quote_product_total" path-id="3">[Produtos.Total]</field></span></span></span></span></span></span></span></td></tr><tr><td colspan="3" rowspan="1" style="border-style:none; padding:10px; text-align:right; width:412px">&nbsp;</td><td style="border-style:none; color:white; padding:10px; text-align:center; width:92px"><strong><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">TOTAL (R$)</span></span></strong></td><td style="border-style:none; color:white; padding:10px; text-align:center; width:122px"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></span></span></span></span></span></span></td></tr></tbody></table><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:#000000">Valor Final</span></strong></span></span></p><p><strong>R$&nbsp;<field format="n2" formattable="number" key="quote_amount" path-id="56">[Proposta.Valor]</field></strong></p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:#000000">Forma de pagamento</span></strong></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#000000"><span><span><span><field key="quote_payment_method" path-id="56">[Proposta.Método de pagamento]</field></span></span></span></span></span></p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><span style="color:#000000"><span><span><span><field key="user_name" path-id="80">[Proposta / Usuário.Nome]</field></span></span></span></span></strong></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><field key="user_email" path-id="80">[Proposta / Usuário.E-mail]</field></span></span></span></span></p>',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><table border="1" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="text-align:right; width:90px">&nbsp;</td><td style="text-align:right; width:645px">&nbsp;</td><td style="width:55px">&nbsp;</td></tr><tr><td style="text-align:right; width:90px">&nbsp;</td><td style="text-align:right; width:645px"><span><span><span><span><img alt="" height="60" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/dd92ae76c50c49808622e05a3c795eb3.png" width="111" /></span></span></span></span></td><td style="width:55px">&nbsp;</td></tr></tbody></table><p>&nbsp;</p><div style="height:5px">&nbsp;</div><div style="border-bottom:2px solid #aaaaaa; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div>',
			32,
			'<div style="height:5px">&nbsp;</div><div style="border-bottom:2px solid #aaaaaa; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div><p style="text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><field key="account_street_address" path-id="32">[Sua Empresa.Endereço]</field></span>&nbsp;-&nbsp;<span><field key="account_city" path-id="32">[Sua Empresa.Cidade]</field></span></span></p><p style="text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><span><field key="account_website" path-id="32">[Sua Empresa.Site]</field></span></strong>&nbsp;</span></p><p style="text-align:center">&nbsp;</p><p style="text-align:center">&nbsp;</p>',
			24, 15, 5, 20, 30)



	--QUOTES FORMS: PRODUTOS
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1131, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1133, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1135, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1134, 1, 40)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1136, 1, 10, @ID_FormularioProduto)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco, 1128, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 7, 'quote_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1110, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1115, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 30, 0, 'Produtos', @ID_FormularioBloco)

		INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1366, 1, 40)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1365, 1, 50, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1367, 1, 60)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1117, 1, 70)



	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@AccountId, 7, @ID_Formulario, '[MODELO 3] Produtos', @UserId, 0, 1, 1117, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_Formulario, @ID_FormularioBloco, @ID_FormularioProduto)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Seção 1',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><div style="position:relative"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="1122.5" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/c95a1b9ef3a9449eb16413a083a37b90.png" style="float:left" width="800" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span><div style="position:absolute; top:460px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:93px">&nbsp;</td><td style="width:635px"><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><strong><span style="font-size:36px">Proposta&nbsp;</span></strong></span></span><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span style="font-size:36px">Comercial</span></span></span></p><p style="text-align:center">&nbsp;</p><p style="text-align:center">&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span style="font-size:22px"><strong><span><span><span><span><span><span><span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></span></span></span></span></span></strong></span></span></span></p><p><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span><span><span><span><span><span><span><span><span><span><field format="d" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></p></td><td style="width:60px">&nbsp;</td></tr></tbody></table></div><div style="position:absolute; top:940px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:93px">&nbsp;</td><td style="width:610px"><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="76" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/845b2c0a288943909161b1d0b0b3e07b.png" style="float:right" width="140" /></span></span></span></span></span></span></span></span></span></span></span></span></span></td><td style="width:87px">&nbsp;</td></tr></tbody></table></div></div>',
			'', 0, '', 0, 0, 0, 0, 10)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Seção 2',
			'<style type="text/css">.imagem150 img{width:150px !important; height: auto!important}</style><style type="text/css">p {font-family:Trebuchet MS,Helvetica,sans-serif}</style><style type="text/css">.border-white, .border-white td, .border-white th {border:2px solid #eeeeee!important;}</style><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><style type="text/css">.imagem120 img{width:120px !important; height: auto!important}</style></span><p style="text-align:right"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><field key="account_city" path-id="32">[Sua Empresa.Cidade]</field>,&nbsp;<field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></p><p style="text-align:right"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">Proposta #&nbsp;<field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.Código]</field></span></p><p>&nbsp;</p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#e74c3c"><span style="font-size:36px"><strong>Proposta</strong><br />Comercial</span></span></span></p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">À</span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">A/C:&nbsp;<field key="contact_name" path-id="64">[Contato.Nome]</field></span></span></p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">Prezado&nbsp;<strong><field key="contact_name" path-id="64">[Contato.Nome]</field></strong>. </span></span></p><p style="text-align:justify"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">Agradecemos a oportunidade em contar com a <field key="account_name" path-id="32">[Sua Empresa.Nome]</field>. Conforme solicitação, apresentamos o orçamento abaixo discriminado:</span></span></p><p>&nbsp;</p><table border="1" cellpadding="3" cellspacing="0" class="border-white" section-code="0" section-name="Produtos" section-no-products="" style="border:2px solid #eeeeee !important; width:100%"><tbody><tr style="border-bottom:3px solid #e74c3c!important; page-break-inside:avoid"><th style="width: 189px;"><span style="color:#e74c3c"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>PRODUTO</strong></span></span></th><th style="width: 170px;"><span style="color:#e74c3c"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>QTD.</strong></span></span></th><th style="width: 89px;"><span style="color:#e74c3c"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>VLR UN.</strong></span></span></th><th style="width: 15%;"><span style="color:#e74c3c"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>DESCONTO</strong></span></span></th><th style="width: 15%;"><span style="color:#e74c3c"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>TOTAL</strong></span></span></th></tr><tr multiple-field-key="quote_section_products" style="border-bottom:3px solid #eeeeee!important; page-break-inside:avoid"><td style="text-align:center; width:189px"><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><index field-key="quote_section_products">[Produtos.Índice]</index>.&nbsp;<field key="product_name" path-id="19">[Produtos / Produto.Nome]</field></span></p><div class="imagem120"><div condition-field-key="product_image_url" condition-operation="ne" condition-value="0"><img alt="" field-key="product_image_url" field-path-id="19" height="85" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/default_company_logo.png" width="85" /></div></div></td><td style="text-align:center; width:170px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><field format="n0" formattable="number" key="quote_product_quantity" path-id="3">[Produtos.Quantidade]</field></span></td><td style="text-align:center; width:89px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">R$&nbsp;<field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unitário]</field></span></td><td style="text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><field format="n1" key="quote_product_discount" path-id="3">[Produtos.Desconto]</field>&nbsp;%</span></td><td style="text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">R$&nbsp;<field format="n2" formattable="number" key="quote_product_total" path-id="3">[Produtos.Total]</field></span></td></tr><tr><td colspan="4" style="background-color:#eeeeee; text-align:right"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>FRETE&nbsp;</strong></span></td><td style="background-color:#eeeeee; text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">R$&nbsp;&nbsp;<field format="n2" formattable="number" key="quote_freight_cost" path-id="56">[Proposta.Valor do frete]</field></span></td></tr><tr style="border-top:3px solid #ffffff!important; page-break-inside:avoid"><td colspan="4" style="background-color:#eeeeee; text-align:right"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>TOTAL&nbsp;&nbsp;</strong></span></td><td style="background-color:#eeeeee; text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></span></td></tr></tbody></table><p>&nbsp;</p><p><span style="color:null"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:18px"><strong>| GENERALIDADES</strong></span></span></span></p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><field key="quote_notes" path-id="56">[Proposta.Observações]</field></span></span></p><ul><li><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">Produtos de acordo com o estoque,&nbsp;os mesmos estão sujeitos a confirmação prévia.</span></span></li></ul><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><strong>Frete:&nbsp;</strong><field key="quote_freight_modal" path-id="56">[Proposta.Modalidade de frete]</field></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>Valor: R$&nbsp;<field format="n2" formattable="number" key="quote_amount" path-id="56">[Proposta.Valor]</field></strong></span></p><p>&nbsp;</p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">Estamos à disposição para os esclarecimentos que se fizerem necessários.</span></span></p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">Atenciosamente,</span></span></p><div class="imagem150"><p>&nbsp;</p><div condition-field-key="user_avatar_url" condition-operation="ne" condition-value="0"><img alt="" field-key="user_avatar_url" field-path-id="80" height="113" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/default_company_logo.png" width="113" /></div><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><strong><field key="user_name" path-id="80">[Proposta / Usuário.Nome]</field> </strong></span></span></p></div><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><field key="role_name" path-id="20">[Proposta / Usuário / Cargo.Nome]</field> </span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><field key="account_name" path-id="32">[Sua Empresa.Nome]</field> </span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><field key="user_email" path-id="80">[Proposta / Usuário.E-mail]</field></span></span></p>',
			'',
			0,
			'<span><span><span><span><img alt="" height="130" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/60c35864f22d4eb793e6bd078e40d81b.png" width="800" /></span></span></span></span>',
			35, 20, 20, 20, 20)



	--QUOTES FORMS: INDÚSTRIA
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)
		
	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1133, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1131, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1135, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1134, 1, 40)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1136, 1, 10, @ID_FormularioProduto)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco, 1128, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 7, 'quote_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1110, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 20, 0, 'Produtos', @ID_FormularioBloco)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1367, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1366, 1, 40)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1117, 1, 50)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1122, 1, 60)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1121, 1, 70)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1365, 1, 80, 1)



	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@AccountId, 7, @ID_Formulario, '[MODELO 4] Indústria', @UserId, 0, 1, 1117, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_Formulario, @ID_FormularioBloco, @ID_FormularioProduto)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Capa',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}.border-td {border: none !important;}.border-td td, .border-td th {border: 1px solid;}tr {page-break-inside: avoid}</style><div style="position:relative"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="1122.5" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/05c7683ac8684b01acbf0c988c57e9ef.png" width="800" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span><div style="position:absolute; top:620px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:92px">&nbsp;</td><td style="width:483px"><p><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="68" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/845b2c0a288943909161b1d0b0b3e07b.png" width="126" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p><span style="color:#ffffff"><span style="font-size:22px"><span style="font-family:Verdana,Geneva,sans-serif"><strong><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></strong></span></span></span></p><p><span style="color:#ffffff"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field format="d" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p>&nbsp;</p></td><td style="width:214px">&nbsp;</td></tr></tbody></table></div></div>',
			'', 0, '', 0, 0, 0, 0, 10)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Corpo',
			'<style type="text/css">.border-blue, .border-blue td, .border-blue th {border: 2px solid #016aa3!important;}</style><style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}.border-td {border: none !important;}.border-td td, .border-td th {border: 1px solid;}tr {page-break-inside: avoid}</style><style type="text/css">p {font-family:Verdana,Geneva,sans-serif;}</style><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="width:395px"><p>&nbsp;</p></td><td style="text-align:right; vertical-align:top; width:320px"><p><span style="color:#016aa3"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field key="account_city" path-id="32">[Sua Empresa.Cidade]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span><span style="color:#016aa3">,<span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span>&nbsp;<span><field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p></td></tr></tbody></table><p style="text-align:center">&nbsp;</p><p style="text-align:center"><span style="font-size:16px"><span style="color:#016aa3"><strong>ORÇAMENTO #<span><span><span><span><span><span><field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.Código]</field></span></span></span></span></span></span></strong></span></span></p><p style="text-align:center">&nbsp;</p><p style="text-align:center">&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="width:269px"><p><span style="font-size:12px"><strong>Razão Social</strong></span></p></td><td><p><span style="font-size:12px"><strong>CNPJ</strong></span></p></td><td><p><span style="font-size:12px"><strong>Cidade - UF</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td style="width:269px"><p><span style="font-size:12px"><field key="contact_legal_name" path-id="1">[Cliente.Razão social]</field></span></p></td><td style="width:163px"><p><span style="font-size:12px"><field key="contact_cnpj" path-id="1">[Cliente.CNPJ]</field></span></p></td><td style="width:280px"><p><span style="font-size:12px"><field key="city_name" path-id="60">[Cliente / Cidade.Nome]</field>&nbsp;-&nbsp;<field key="state_short" path-id="18">[Cliente / Cidade / Estado.Sigla]</field></span></p></td></tr><tr><td colspan="2" rowspan="1"><p><span style="font-size:12px"><strong>Endereço</strong></span></p></td><td><p><span style="font-size:12px"><strong>CEP</strong></span></p></td></tr><tr><td colspan="2" rowspan="1" style="width:278px"><p><span style="font-size:12px"><field key="contact_street_address" path-id="1">[Cliente.Endereço]</field></span></p></td><td style="width:280px"><p><span style="font-size:12px"><field format="00000-000" formattable="number" key="contact_zipcode" path-id="1">[Cliente.CEP]</field></span></p></td></tr><tr style="border-top:2px solid #016aa3 !important"><td><p><span style="font-size:12px"><strong>Contato</strong></span></p></td><td><p><span style="font-size:12px"><strong>Telefone</strong></span></p></td><td><p><span style="font-size:12px"><strong>E-mail</strong></span></p></td></tr><tr><td style="width:269px"><p><span style="font-size:12px"><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></p></td><td style="width:163px"><p field-path-id="1" multiple-field-key="contact_phones"><span style="font-size:12px"><field key="contact_phones" path-id="1">[Cliente.Telefones]</field></span></p></td><td style="width:280px"><p><span style="font-size:12px"><field key="contact_email" path-id="1">[Cliente.E-mail]</field></span></p></td></tr><tr style="border-top:2px solid #016aa3 !important"><td colspan="2" rowspan="1" style="width:269px"><p><span style="font-size:12px"><strong>Nome Fantasia</strong></span></p></td><td style="width:280px"><p><span style="font-size:12px"><strong>Ramo de Atividade</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td colspan="2" rowspan="1" style="width:269px"><p><span style="font-size:12px"><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></p><p>&nbsp;</p></td><td style="width:280px"><p><span style="font-size:12px"><field key="contact_line_of_business_name" path-id="16">[Cliente / Segmento do cliente.Nome]</field></span></p></td></tr></tbody></table><p>&nbsp;</p><p>&nbsp;</p><table border="1" cellpadding="1" cellspacing="1" class="border-blue" section-code="0" section-name="Produto" section-no-products="" style="width:100%"><tbody multiple-field-key="quote_section_products"><tr><td style="background-color:#99ccff; width:135px"><p style="text-align:center"><span style="font-size:12px"><strong>Código</strong></span></p></td><td style="background-color:#99ccff; width:201px"><p style="text-align:center"><span style="font-size:12px"><strong>Produto</strong></span></p></td><td style="background-color:#99ccff; width:172px"><p style="text-align:center"><span style="font-size:12px"><strong>Modelo&nbsp;</strong></span></p></td><td style="background-color:#99ccff; width:162px"><p style="text-align:center"><span style="font-size:12px"><strong>NCM</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td style="width:135px"><p style="text-align:center"><span style="font-size:12px"><field key="product_code" path-id="19">[Produtos / Produto.Código]</field></span></p></td><td style="width:201px"><p style="text-align:center"><span style="font-size:12px"><field key="product_name" path-id="19">[Produtos / Produto.Nome]</field></span></p></td><td style="width:172px"><p style="text-align:center"><span style="font-size:12px">DVHU-7</span></p></td><td style="width:162px"><p style="text-align:center">100610</p></td></tr><tr><td colspan="2" rowspan="1" style="width:135px"><p style="text-align:center"><span style="font-size:12px"><strong>Peso</strong></span></p></td><td colspan="2" rowspan="1" style="width:170px"><p style="text-align:center"><span style="font-size:12px"><strong>Dimensões (CxLxA) mm</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td colspan="2" rowspan="1" style="width:135px"><p style="text-align:center"><span style="font-size:12px">120 kg</span></p></td><td colspan="2" rowspan="1" style="width:170px"><p style="text-align:center"><span style="font-size:12px">2m&nbsp;x&nbsp;3m&nbsp;x&nbsp;0,5m</span></p></td></tr><tr><td style="width:135px"><p style="text-align:center"><span style="font-size:12px"><strong>ST</strong></span></p></td><td style="width:201px"><p style="text-align:center"><span style="font-size:12px"><strong>IVA</strong></span></p></td><td style="width:172px"><p style="text-align:center"><span style="font-size:12px"><strong>ICMS</strong></span></p></td><td style="width:162px"><p style="text-align:center"><span style="font-size:12px"><strong>IPI</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td style="width:135px"><p style="text-align:center"><span style="font-size:12px">1%</span></p></td><td style="width:201px"><p style="text-align:center"><span style="font-size:12px">2%</span></p></td><td style="width:172px"><p style="text-align:center"><span style="font-size:12px">18%</span></p></td><td style="width:162px"><p style="text-align:center"><span style="font-size:12px">3%</span></p></td></tr><tr><td style="width:135px"><p style="text-align:center"><span style="font-size:12px"><strong>Valor Unitário</strong></span></p></td><td style="width:201px"><p style="text-align:center"><span style="font-size:12px"><strong>Quantidade</strong></span></p></td><td style="width:172px"><p style="text-align:center"><span style="font-size:12px"><strong>Desconto</strong></span></p></td><td style="width:162px"><p style="text-align:center"><span style="font-size:12px"><strong>Valor Total</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td style="width:135px"><p style="text-align:center"><span style="font-size:12px">&nbsp;R$&nbsp;<field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unitário]</field></span></p></td><td style="width:201px"><p style="text-align:center"><span style="font-size:12px"><field format="n0" formattable="number" key="quote_product_quantity" path-id="3">[Produtos.Quantidade]</field></span></p></td><td style="width:172px"><p style="text-align:center"><span style="font-size:12px"><field format="n1" key="quote_product_discount" path-id="3">[Produtos.Desconto]</field> %</span></p></td><td style="width:162px"><p style="text-align:center"><span style="font-size:12px">&nbsp;<strong>R$&nbsp;<field format="n2" formattable="number" key="quote_product_total" path-id="3">[Produtos.Total]</field></strong></span></p></td></tr><tr class="no-border" style="border-left:2px solid #ffffff !important; border-right:2px solid #ffffff !important; line-height:0.5"><th colspan="4" style="width: 135px">&nbsp;</th></tr></tbody><tbody><tr><td colspan="4" style="background-color:#016aa3; width:135px"><p style="text-align:center"><strong><span style="color:#ffffff">Valor Total:&nbsp;R$&nbsp;<span><field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></span></span></strong></p></td></tr></tbody></table><p>&nbsp;</p><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="text-align:center; width:126px"><p style="text-align:left"><span style="font-size:12px"><strong>Frete</strong></span></p></td><td style="text-align:center; width:152px"><p style="text-align:left"><span style="font-size:12px"><strong>Valor do Frete</strong></span></p></td><td style="text-align:center; width:158px"><p style="text-align:left"><span style="font-size:12px"><strong>Valor Total</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td style="text-align:center; width:126px"><p style="text-align:left"><span style="font-size:12px"><field key="quote_freight_modal" path-id="56">[Proposta.Modalidade de frete]</field></span></p></td><td style="text-align:center; width:152px"><p style="text-align:left"><span style="font-size:12px">R$&nbsp;<field format="n2" formattable="number" key="quote_freight_cost" path-id="56">[Proposta.Valor do frete]</field></span></p></td><td style="text-align:center; width:158px"><p style="text-align:left"><span style="font-size:12px">R$&nbsp;<field format="n2" formattable="number" key="quote_amount" path-id="56">[Proposta.Valor]</field></span></p></td></tr></tbody></table><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="text-align:center; width:333px"><p style="text-align:left"><span style="font-size:12px"><strong>Forma de pagamento</strong></span></p></td><td style="text-align:center; width:348px"><p style="text-align:left"><span style="font-size:12px"><strong>Prazo de entrega</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td style="text-align:center; width:333px"><p style="text-align:left"><span style="font-size:12px"><field key="quote_payment_method" path-id="56">[Proposta.Método de pagamento]</field></span></p></td><td style="text-align:center; width:348px"><p style="text-align:left"><span style="font-size:12px"><field key="quote_delivery_time" path-id="56">[Proposta.Prazo de entrega]</field></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td colspan="2" style="width:333px"><p><span style="font-size:12px"><strong>Observações</strong></span></p><p><span style="font-size:12px"><field key="quote_notes" path-id="56">[Proposta.Observações]</field></span></p></td></tr></tbody></table><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class=";border-white no-border" style="width:100%"><tbody><tr><td style="border-right:2px solid #016aa3 !important; width:110px"><p><span style="font-size:12px"><span style="color:#016aa3"><strong>Emitida por:</strong></span></span></p><p><span style="font-size:12px"><span style="color:#016aa3"><strong>E-mail:</strong></span></span></p><p><span style="font-size:12px"><span style="color:#016aa3"><strong>Telefone:</strong></span></span></p></td><td style="vertical-align:top; width:605px"><p><span style="font-size:12px">&nbsp;&nbsp;<field key="user_name" path-id="80">[Proposta / Usuário.Nome]</field></span></p><p><span style="font-size:12px">&nbsp;&nbsp;<field key="user_email" path-id="80">[Proposta / Usuário.E-mail]</field></span></p><p><span style="font-size:12px">&nbsp;&nbsp;<field key="user_phone" path-id="80">[Proposta / Usuário.Telefone]</field></span></p></td></tr></tbody></table>',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}.border-td {border: none !important;}.border-td td, .border-td th {border: 1px solid;}tr {page-break-inside: avoid}</style><div style="position:relative"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="198" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/d0928e3c8587480ebd7ba542002cec4e.png" width="800" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span><div style="position:absolute; top:30px">&nbsp;<table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="width:67px">&nbsp;</td><td style="vertical-align:top; width:158px"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="78" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/845b2c0a288943909161b1d0b0b3e07b.png" width="144" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></td><td style="vertical-align:top; width:443px"><p><span style="color:#016aa3"><span style="font-size:14px"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><strong><span><span><span><span><span><span><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></span></span></span></span></span></strong></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p><span style="font-size:11px"><span style="color:#016aa3"><span><span><span><span><span><field key="account_street_address" path-id="32">[Sua Empresa.Endereço]</field></span></span></span></span></span></span></span></p><p><span style="font-size:11px"><span style="color:#016aa3"><strong>CNPJ:</strong>&nbsp;<span><span><span><span><span><field key="account_register" path-id="32">[Sua Empresa.CNPJ]</field></span></span></span></span></span></span></span></p><p><span style="font-size:11px"><span style="color:#016aa3"><span><span><span><span><span><field key="account_phone" path-id="32">[Sua Empresa.Telefone]</field></span></span></span></span></span></span></span></p><div><div>&nbsp;</div></div></td><td style="width:122px">&nbsp;</td></tr></tbody></table><p>&nbsp;</p></div></div>',
			53,
			'',
			0, 15, 5, 5, 20)



	--QUOTES FORMS: PRODUTOS E SERVIÇOS
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)
		
	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1131, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1133, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1134, 1, 30)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1136, 1, 10, @ID_FormularioProduto)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco, 1128, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 7, 'quote_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1110, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1119, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1364, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 40, 0, 'Produtos', @ID_FormularioBloco)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)
		
	SET @ID_FormularioProduto2 = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto2, 1131, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto2, 1133, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto2, 1134, 1, 30)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco2 = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco2, 1136, 1, 10, @ID_FormularioProduto2)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco2, 1128, 1, 20)


	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 50, 1, 'Serviços', @ID_FormularioBloco2)


	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1117, 1, 60)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@AccountId, 34, 'quote_installment_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco3 = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco3, 1188, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco3, 1186, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco3, 1187, 1, 30)



	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1185, 1, 70, @ID_FormularioBloco3)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1122, 1, 80)



	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@AccountId, 7, @ID_Formulario, '[MODELO 5] Produtos e Serviços', @UserId, 0, 1, 1117, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_Formulario, @ID_FormularioBloco, @ID_FormularioBloco2, @ID_FormularioBloco3, @ID_FormularioProduto, @ID_FormularioProduto2)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Capa',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><div style="position:relative"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="1122.5" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/d44f29c193424b93b48ad1bf6e57f496.png" style="float:left" width="800" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span><div style="position:absolute; top:240px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:281px">&nbsp;</td><td style="width:449px"><p><span style="color:#385d2c"><span style="font-family:Verdana,Geneva,sans-serif"><strong><span style="font-size:36px">PROPOSTA</span></strong></span></span></p><p><span style="color:#385d2c"><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:22px">Serviços &amp; Produtos</span></span></span></p><p>&nbsp;</p><p><span style="color:#385d2c"><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:12px"><strong><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="61" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/dd92ae76c50c49808622e05a3c795eb3.png" width="113" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></strong></span></span></span></p><p style="text-align:center">&nbsp;</p><p><span style="color:#b4d44e"><span style="font-size:22px"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p></td><td style="width:60px">&nbsp;</td></tr></tbody></table></div><div style="position:absolute; top:560px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:281px">&nbsp;</td><td style="width:449px"><p><strong><span style="color:#ffffff"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field format="d" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></strong></p><p><span style="color:#ffffff"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><strong>Proposta n°:&nbsp;</strong><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.Código]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p><span style="color:#ffffff"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><strong>Validade:&nbsp;</strong><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field format="d" formattable="date" key="quote_expiration_date" path-id="56">[Proposta.Data de validade]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p>&nbsp;</p></td><td style="width:60px">&nbsp;</td></tr></tbody></table></div></div>',
			'', 0, '', 0, 0, 0, 0, 10)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Corpo',
			'<style type="text/css">p {font-family:Verdana,Geneva,sans-serif;}</style><style type="text/css">.border-white, .border-white td, .border-white th {border: 1px solid #ffffff!important;}</style><style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}.border-td {border: none !important;}.border-td td, .border-td th {border: 1px solid;}tr {page-break-inside: avoid}</style><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr style="border-bottom:2px solid #385d2c !important"><td style="width:344px"><p><span style="font-size:12px"><strong>Direcionado para</strong></span></p><p><span style="font-size:12px"><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></p></td><td style="text-align:right; vertical-align:top; width:352px"><p><span style="font-size:12px"><strong><field key="account_city" path-id="32">[Sua Empresa.Cidade]</field>,&nbsp;<field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></strong></span></p><p><span style="font-size:12px"><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></p></td></tr><tr><td style="width:344px">&nbsp;</td><td style="width:352px">&nbsp;</td></tr><tr style="border-top:2px solid #385d2c !important"><td style="width:344px"><p><span style="font-size:12px"><strong>Validade da Proposta</strong></span></p><p><span style="font-size:12px"><field format="dd/MM/yyyy" formattable="date" key="quote_expiration_date" path-id="56">[Proposta.Data de validade]</field></span></p></td><td style="width:352px"><p style="text-align:right"><span style="font-size:12px"><strong>Proposta</strong>&nbsp;</span></p><p style="text-align:right"><span style="font-size:12px">n°&nbsp;<field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.Código]</field></span></p></td></tr></tbody></table><p>&nbsp;</p><p style="text-align:center"><span style="font-size:18px"><strong><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field key="quote_title" path-id="56">[Proposta.Título]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></strong></span></p><p style="text-align:center">&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="border-white" section-code="0" section-name="Produtos" section-no-products="" style="width:100%"><tbody><tr><td style="background-color:#b3d44e; vertical-align:middle; width:53px"><div><div><div><div><div><div><div><div><p style="text-align:center"><img alt="" height="51" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/3a5e4ff9d181427a8d7630324721856a.png" width="50" /></p></div></div></div></div></div></div></div></div></td><td colspan="3" rowspan="1" style="background-color:#d6e488; width:283px"><p style="text-align:center"><span style="font-size:18px"><span style="color:#385d2c"><strong>Produtos&nbsp; &nbsp; &nbsp; </strong></span></span><span style="font-size:20px"><span style="color:#385d2c"><strong>&nbsp;</strong></span></span></p></td></tr><tr><td colspan="2" rowspan="1" style="background-color:#eeeeee; width:53px"><p style="text-align:center"><span style="font-size:12px"><strong>Produto</strong></span></p></td><td style="background-color:#eeeeee; width:131px"><p style="text-align:center"><span style="font-size:12px"><strong>Quantidade</strong></span></p></td><td style="background-color:#eeeeee; width:205px"><p style="text-align:center"><span style="font-size:12px"><strong>Valor Unitário</strong></span></p></td></tr><tr multiple-field-key="quote_section_products" style="border-bottom:2px solid #eeeeee !important; page-break-inside:avoid"><td colspan="2" rowspan="1" style="width:53px"><p style="text-align:center"><span style="font-size:12px"><field key="product_name" path-id="19">[Produtos / Produto.Nome]</field></span></p></td><td style="width:131px"><p style="text-align:center"><span style="font-size:12px"><field format="n0" formattable="number" key="quote_product_quantity" path-id="3">[Produtos.Quantidade]</field></span></p></td><td style="width:205px"><p style="text-align:center"><span style="font-size:12px">R$&nbsp;<field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unitário]</field><span style="color:#c0392b"><field format="n2" formattable="number" key="quote_product_total" path-id="3" style="display: none;">[Produtos.Total]</field></span></span></p></td></tr><tr><td colspan="4" style="background-color:#eeeeee; width:53px"><p style="text-align:right"><strong>Total: R$&nbsp;<span><span><span><span><span><field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></span></span></span></span></span></strong>&nbsp;</p></td></tr></tbody></table><p>&nbsp;</p><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="border-white" section-code="1" section-name="Serviços" section-no-products="" style="width:100%"><tbody><tr><td style="background-color:#b3d44e; vertical-align:middle; width:53px"><div><div><div><div><div><div><div><div><p style="text-align:center"><img alt="" height="51" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/175093b7b71d4982a89daeaefd4600d8.png" width="50" /></p></div></div></div></div></div></div></div></div></td><td colspan="2" rowspan="1" style="background-color:#d6e488; width:283px"><p style="text-align:center"><span style="font-size:18px"><span style="color:#385d2c"><strong>Serviços&nbsp; &nbsp; &nbsp; &nbsp;</strong></span></span></p></td></tr><tr><td colspan="2" rowspan="1" style="background-color:#eeeeee; width:53px"><p style="text-align:center"><span style="font-size:12px"><strong>Serviço</strong></span></p></td><td style="background-color:#eeeeee; width:205px"><p style="text-align:center"><span style="font-size:12px"><strong>Valor Unitário</strong></span></p></td></tr><tr multiple-field-key="quote_section_products" style="border-bottom:2px solid #eeeeee !important; page-break-inside:avoid"><td colspan="2" rowspan="1" style="width:53px"><p style="text-align:center"><span style="font-size:12px"><field key="product_name" path-id="19">[Produtos / Produto.Nome]</field><span style="color:#c0392b"><field format="n3" formattable="number" key="quote_product_quantity" path-id="3" style="display: none;">[Produtos.Quantidade]</field></span></span></p></td><td style="width:205px"><p style="text-align:center"><span style="font-size:12px">R$&nbsp;<field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unitário]</field><span style="color:#c0392b"><field format="n2" formattable="number" key="quote_product_total" path-id="3" style="display: none;">[Produtos.Total]</field></span></span></p></td></tr><tr><td colspan="3" style="background-color:#eeeeee; width:53px"><p style="text-align:right"><span style="font-size:12px"><strong>Total: R$&nbsp;<field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></strong>&nbsp;</span></p></td></tr></tbody></table><p><field format="n2" formattable="number" key="quote_amount" path-id="56">[Proposta.Valor]</field></p><p>&nbsp;</p><p><span style="font-size:12px"><strong>Parcelas:</strong></span></p><table border="0" cellpadding="0" class="no-border" style="width:100%"><tbody><tr><td style="background-color:#d6e488; text-align:center; width:93px"><span style="font-size:12px"><span style="color:#385d2c"><span style="font-family:Verdana,Geneva,sans-serif"><strong>PARCELA</strong></span></span></span></td><td style="background-color:#d6e488; text-align:center; width:369px"><span style="font-size:12px"><span style="color:#385d2c"><span style="font-family:Verdana,Geneva,sans-serif"><strong>DATA</strong></span></span></span></td><td style="background-color:#d6e488; text-align:center; width:181px"><span style="font-size:12px"><span style="color:#385d2c"><span style="font-family:Verdana,Geneva,sans-serif"><strong>VALOR (R$)</strong></span></span></span></td></tr><tr multiple-field-key="quote_installments" style="border-bottom:2px solid #d6e488 !important"><td style="text-align:center; width:93px"><span style="font-size:12px"><span style="font-family:Verdana,Geneva,sans-serif"><index field-key="quote_installments"></index></span></span></td><td style="text-align:center; width:369px"><p><span style="font-size:12px"><span style="font-family:Verdana,Geneva,sans-serif"><field key="quote_installment"></field> <span style="color:#c0392b"><field key="quote_installment_fixed" path-id="69" style="display: none;">[Proposta / Parcela.Fixar parcela]</field></span><field format="d" formattable="date" key="quote_installment_date" path-id="69">[Proposta / Parcela.Data]</field></span></span></p></td><td style="text-align:center; width:181px"><span style="font-size:12px"><span style="font-family:Verdana,Geneva,sans-serif">R$ <field format="n2" formattable="number" key="quote_installment_amount" path-id="69">[Proposta / Parcela.Valor]</field></span></span></td></tr></tbody></table><p>&nbsp;</p><p><span style="font-size:12px"><strong>Forma de Pagamento:&nbsp;</strong><field key="quote_payment_method" path-id="56">[Proposta.Método de pagamento]</field></span></p><p>&nbsp;</p><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr style="border-bottom:2px solid #385d2c !important"><td style="width:686px"><p style="text-align:right"><span style="font-size:12px"><strong><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></strong></span></p><p style="text-align:right"><span style="font-size:12px"><field key="account_phone" path-id="32">[Sua Empresa.Telefone]</field></span></p><p style="text-align:right"><span style="font-size:12px"><field key="account_street_address" path-id="32">[Sua Empresa.Endereço]</field></span></p></td></tr><tr><td style="text-align:right; width:686px">&nbsp;</td></tr><tr style="border-top:2px solid #385d2c !important"><td style="width:686px"><p style="text-align:right"><span style="font-size:12px"><field key="user_name" path-id="80">[Proposta / Usuário.Nome]</field></span></p><p style="text-align:right"><span style="font-size:12px"><field key="user_phone" path-id="80">[Proposta / Usuário.Telefone]</field></span></p><p style="text-align:right"><span style="font-size:12px"><field key="user_email" path-id="80">[Proposta / Usuário.E-mail]</field></span></p></td></tr></tbody></table>',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><div style="position:relative"><span style="font-size:11px"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><img alt="" height="147" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/afb99ff2ed6b411e82fb2a81dcf04777.png" width="800" /></span></span></span></span></span></span><div style="position:absolute; top:34px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="line-height:1.3; width:100%"><tbody><tr><td style="width:246px">&nbsp;</td><td style="width:415px"><span style="font-size:11px"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><img alt="" height="43" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/BC511860B9AF/Images/362f8953b0ce47ff818213f4f39c4d2f.png" width="78" /></span></span></span></span></span></span><div><div><span style="font-size:11px"><span style="font-family:Verdana,Geneva,sans-serif"><strong><span><span><span><span><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></span></span></span></strong></span></span></div><div><span style="font-size:10px"><span style="font-family:Verdana,Geneva,sans-serif"><strong>CNPJ:</strong></span></span><span style="font-size:11px"><span style="font-family:Verdana,Geneva,sans-serif"><strong>&nbsp;</strong></span></span><span style="font-size:10px"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field key="account_register" path-id="32">[Sua Empresa.CNPJ]</field></span></span></span></span></span></span></div></div></td><td style="width:122px">&nbsp;</td></tr></tbody></table></div></div>',
			40,
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><div style="position:relative"><p style="text-align:right"><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:10px"><span><span><span><span><span><span><span><img alt="" height="147" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/8cfabefebe954d7b811001d0130ba668.png" width="800" /></span></span></span></span></span></span></span></span></span></p><div style="position:absolute; top:30px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="text-align:right; width:126px">&nbsp;</td><td style="width:534px"><p style="text-align:right"><strong><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:10px"><span><span><span><span><span><span><span><field key="account_website" path-id="32">[Sua Empresa.Site]</field></span></span></span></span></span></span></span></span></span></strong></p><p style="text-align:right"><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:10px"><span><span><span><span><span><span><span><field key="account_phone" path-id="32">[Sua Empresa.Telefone]</field></span></span></span></span></span></span></span></span></span></p><div><div style="text-align:right"><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:10px"><span><span><span><span><span><span><span><field key="account_street_address" path-id="32">[Sua Empresa.Endereço]</field></span></span></span></span></span></span></span></span></span></div></div></td><td style="width:123px">&nbsp;</td></tr></tbody></table></div></div>',
			40, 15, 10, 5, 20)



	--USER FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 24, 'user_form', 'Usuários', 1, 16)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1054, 1, 10, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1220, 1, 20, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1159, 1, 30, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1158, 1, 40, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1221, 1, 50, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1283, 1, 60, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1284, 1, 70, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1163, 1, 80, 1, 0)



	--TEAM FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 30, 'team_form', 'Equipes', 1, 17)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1162, 1, 10, 1, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1285, 1, 20, 1, 0)




	--ACCOUNT FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@AccountId, 15, 'account_form', 'Sua empresa', 1, 15)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1212, 1, 10, 1, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1219, 1, 20, 1, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1213, 1, 30, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1214, 1, 40, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1215, 1, 50, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1286, 1, 60, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1216, 1, 70, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1217, 1, 80, 1, 0)




	--ACCOUNT QUICK FORMS
	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@AccountId, 37, @ID_FormularioRapido_Segmento)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@AccountId, 35, @ID_FormularioRapido_Origem)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@AccountId, 38, @ID_FormularioRapido_Cargo)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@AccountId, 39, @ID_FormularioRapido_Departamento)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@AccountId, 40, @ID_FormularioRapido_QtdFuncionarios)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@AccountId, 25, @ID_FormularioRapido_Cidade)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@AccountId, 23, @ID_FormularioRapido_Marcador)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@AccountId, 11, @ID_FormularioRapido_Produto_Grupo)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@AccountId, 10, @ID_FormularioRapido_Produto)


	--Product part Forms
	INSERT INTO Formulario (ID_ClientePloomes, Chave, ID_Entidade, Descricao, Editavel, ID_Criador, DataCriacao, Suspenso, FilterForm, BaseNameId)
		VALUES ( @AccountId, 'product_part_form', 41, 'Vínculos', 1, 0, GETDATE(), 0, 0, 12)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1478, 1, 0, 0, 0, 1, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, 1418, 1, 2, 1, 0, 0, NULL, 1)

	INSERT INTO Formulario_Secao (ID_Formulario, Descricao, Ordem)
		VALUES (@ID_Formulario, 'Valores', 6)

	SET @ID_Secao = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, @ID_Secao, 1144, 1, 7, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1145, 1, 8, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1146, 1, 9, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1147, 1, 10, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1148, 1, 11, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1149, 1, 12, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1150, 1, 13, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1387, 1, 14, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1143, 1, 15, 0, 0, 1, NULL, 1)
	
	INSERT INTO Formulario_Secao_Language (SectionId, LanguageId, [Name])
		VALUES (@ID_Secao, 1, 'Valores'), 
			   (@ID_Secao, 2, 'Values'),
			   (@ID_Secao, 3, 'Valores'),
			   (@ID_Secao, 4, 'Valores')

			   

	--Product Part quick form

	INSERT INTO Formulario (ID_ClientePloomes, Chave, ID_Entidade, Descricao, Editavel, ID_Criador, DataCriacao, Suspenso, FilterForm, BaseNameId)
		VALUES(@AccountId, 'product_part_quick_form', 41,'Vínculos (mini)',1,0,GETDATE(),0,0, 13)

	SET @ID_Formulario = SCOPE_IDENTITY()


	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1478, 1, 1, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1418, 1, 2, 1, 1, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1144, 1, 3, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1145, 1, 8, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1146, 1, 9, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, 1147, 1, 10, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1148, 1, 11, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1149, 1, 12, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1150, 1, 13, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1387, 1, 14, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1143, 1, 15, 0, 0, 1, NULL, 1)


	--FIELDS LINKS
	INSERT INTO Campo_Vinculo (ID_ClientePloomes, ID_CampoOrigem, Fixo_CampoOrigem, ID_CampoDestino, Fixo_CampoDestino)
		VALUES (@AccountId, 1027, 1, 1049, 1)


	--INFORME EXEMPLO
	INSERT INTO Informe (ID_ClientePloomes, Conteudo, ID_Criador) VALUES (@AccountId, 'Use o sistema de mensagens para se comunicar com sua equipe!', @UserId)


	--TAREFAS EXEMPLO
	DECLARE @ID_Tarefa INT
	
	INSERT INTO Tarefa (Titulo, ID_Criador) VALUES ('Criar cliente', @UserId)
	SET @ID_Tarefa = SCOPE_IDENTITY()
	INSERT INTO Tarefa_Conclusao (ID_Tarefa, DataRecorrencia, SemHorario, ID_Classe, Pending, ID_Criador, ID_ClientePloomes) VALUES (@ID_Tarefa, GETDATE(), 1, 1, 1, @UserId, @AccountId)
	INSERT INTO Tarefa_Usuario (ID_Tarefa, ID_Usuario) VALUES (@ID_Tarefa, @UserId)

	INSERT INTO Tarefa (Titulo, ID_Criador) VALUES ('Criar negócio', @UserId)
	SET @ID_Tarefa = SCOPE_IDENTITY()
	INSERT INTO Tarefa_Conclusao (ID_Tarefa, DataRecorrencia, SemHorario, ID_Classe, Pending, ID_Criador, ID_ClientePloomes) VALUES (@ID_Tarefa, GETDATE(), 1, 1, 1, @UserId, @AccountId)
	INSERT INTO Tarefa_Usuario (ID_Tarefa, ID_Usuario) VALUES (@ID_Tarefa, @UserId)

	INSERT INTO Tarefa (Titulo, ID_Criador) VALUES ('Criar proposta', @UserId)
	SET @ID_Tarefa = SCOPE_IDENTITY()
	INSERT INTO Tarefa_Conclusao (ID_Tarefa, DataRecorrencia, SemHorario, ID_Classe, Pending, ID_Criador, ID_ClientePloomes) VALUES (@ID_Tarefa, GETDATE(), 1, 1, 1, @UserId, @AccountId)
	INSERT INTO Tarefa_Usuario (ID_Tarefa, ID_Usuario) VALUES (@ID_Tarefa, @UserId)



	--STATUS DE VENDAS

	INSERT INTO Venda_Status (ID_ClientePloomes, Descricao, Ordem, ID_Criador, CSS_Icon)
		VALUES (@AccountId, 'Pedido recebido', 1, @UserId, 'icon-spinner')

	INSERT INTO Venda_Status (ID_ClientePloomes, Descricao, Ordem, ID_Criador, CSS_Icon)
		VALUES (@AccountId, 'Produto na transportadora', 2, @UserId, 'icon-truck')

	INSERT INTO Venda_Status (ID_ClientePloomes, Descricao, Ordem, ID_Criador, CSS_Icon)
		VALUES (@AccountId, 'Produto entregue', 3, @UserId, 'icon-ok')

	INSERT INTO Cliente_Relacao (ID_ClientePloomes, Descricao, ID_Criador)
		VALUES (@AccountId, 'Cliente', @UserId)

	INSERT INTO Cliente_Relacao (ID_ClientePloomes, Descricao, ID_Criador)
		VALUES (@AccountId, 'Parceiro', @UserId)

	INSERT INTO Cliente_Relacao (ID_ClientePloomes, Descricao, ID_Criador)
		VALUES (@AccountId, 'Revendedor', @UserId)

	INSERT INTO Cliente_Relacao (ID_ClientePloomes, Descricao, ID_Criador)
		VALUES (@AccountId, 'Fornecedor', @UserId)




	--RELATÓRIOS
	DECLARE @PanelId INT, @ChartId INT, @TableId INT, @TableFieldId INT, @FilterId INT, @FilterFieldId INT

	--VENDAS
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@AccountId, 'Vendas', @UserId)

	SET @PanelId = SCOPE_IDENTITY()

	--VENDAS: VALOR
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Valor em vendas neste mês', 'width-33-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#27c24c"]}',
			0, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador)
		VALUES (@AccountId, 'Valor em vendas neste mês', '$filter=((date(Date)+eq+$thismonth))', 4, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador)
		VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto)
		VALUES (@FilterFieldId, '$thismonth')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 4, 'Valor em vendas neste mês', @FilterId, '$select=Id,Date,Amount', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1172, 1, 0)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Valor em vendas neste mês', '#27c24c', 2, NULL, 0)


	--VENDAS: TICKET MÉDIO
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Ticket médio neste mês', 'width-33-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"MMMM yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#27c24c"]}',
			2, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador)
		VALUES (@AccountId, 'Ticket médio neste mês', '$filter=((date(Date)+eq+$thismonth))', 4, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador)
		VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto)
		VALUES (@FilterFieldId, '$thismonth')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 4, 'Ticket médio neste mês', @FilterId, '$select=Id,Date,Amount', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1172, 1, 0)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Ticket médio neste mês', '#27c24c', 3, 4, 0)


	--VENDAS: QTD
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Nº de vendas neste mês', 'width-33-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#27c24c"]}',
			1, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador)
		VALUES (@AccountId, 'Nº de vendas neste mês', '$filter=((date(Date)+eq+$thismonth))', 4, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador)
		VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto)
		VALUES (@FilterFieldId, '$thismonth')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 4, 'Nº de vendas neste mês', @FilterId, '$select=Id', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1294, 1, 0)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1294, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Nº de vendas neste mês', '#27c24c', 1, NULL, 0)


	--VENDAS: ÚLTIMOS 6 MESES
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 1, 'Vendas realizadas nos últimos 6 meses', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"MMMM yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#27c24c"]}',
			3, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador)
		VALUES (@AccountId, 'Vendas realizadas nos últimos 6 meses', '$filter=((date(Date)+eq+$lastnmonths(6)))', 4, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador)
		VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto)
		VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 4, 'Vendas realizadas nos últimos 6 meses', @FilterId, '$select=Id,Date,Amount', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1172, 1, 0)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Vendas realizadas nos últimos 6 meses', '#27c24c', 2, 4, 0)



	--VENDAS: SEGMENTO
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por segmento - últimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"sortAscending":false,"sortColumn":1,"currentSort":"desc"}',
			4, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Por segmento - últimos 6 meses', '$filter=((Contact/LineOfBusinessId+ne+null+and+date(Date)+eq+$lastnmonths(6)))', 4, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1024, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1189, 1, 1)

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1024, 1, 2)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 4, 'Por segmento - últimos 6 meses', @FilterId, '$select=Id,Amount&$expand=Contact($select=Id,LineOfBusiness;$expand=LineOfBusiness($select=Id,Name))', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1024, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1189, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1024, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por segmento - últimos 6 meses', '#333', 2, NULL, 0)



	--VENDAS: ORIGEM
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por origem - últimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"sortAscending":false,"sortColumn":1,"currentSort":"desc"}',
			5, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Por origem - últimos 6 meses', '$filter=((Contact/OriginId+ne+null+and+date(Date)+eq+$lastnmonths(6)))', 4, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1025, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1189, 1, 1)

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1025, 1, 2)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 4, 'Por origem - últimos 6 meses', @FilterId, '$select=Id,Amount&$expand=Contact($select=Id,Origin;$expand=Origin($select=Id,Name))', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1025, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1189, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1025, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por origem - últimos 6 meses', '#333', 2, NULL, 0)



	--VENDAS: CLIENTE
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por cliente - últimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			6, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Por cliente - últimos 6 meses', '$filter=((date(Date)+eq+$lastnmonths(6)))', 4, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 4, 'Por cliente - últimos 6 meses', @FilterId, '$select=Id,Amount&$expand=Contact($select=Id,Name,Editable)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1189, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1189, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por cliente - últimos 6 meses', '#333333', 2, NULL, 0)




	--VENDAS: VENDEDOR
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por vendedor - últimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			7, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Por vendedor - últimos 6 meses', '$filter=((OwnerId+ne+null+and+date(Date)+eq+$lastnmonths(6)))', 4, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1183, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 4, 'Por vendedor - últimos 6 meses', @FilterId, '$select=Id,Amount&$expand=Owner($select=Id,Name,AvatarUrl)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1183, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por vendedor - últimos 6 meses', '#333', 2, NULL, 0)



	--VENDAS: PRODUTO
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por produto - últimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			8, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Por produto - últimos 6 meses', '$filter=((date(Order/Date)+eq+$lastnmonths(6)))', 20, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1207, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 20, 'Por produto - últimos 6 meses', @FilterId, '$select=Id,OrderId,Total&$expand=Product($select=Id,Name)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1200, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1204, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por produto - últimos 6 meses', '#333', 2, NULL, 0)



	--VENDAS: GRUPO DE PRODUTO
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por grupo de produto - últimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			9, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Por grupo de produto - últimos 6 meses', '$filter=((date(Order/Date)+eq+$lastnmonths(6)))', 20, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1207, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 20, 'Por grupo de produto - últimos 6 meses', @FilterId, '$select=Id,OrderId,Total&$expand=Product($select=Id,Group;$expand=Group($select=Id,Name))', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1107, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1200, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1204, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por grupo de produto - últimos 6 meses', '#333', 2, NULL, 0)



	--VENDAS: CIDADE
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por cidade - últimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			10, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Por cidade - últimos 6 meses', '$filter=((Contact/CityId+ne+null+and+date(Date)+eq+$lastnmonths(6)))', 4, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1040, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1189, 1, 1)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 4, 'Por cidade - últimos 6 meses', @FilterId, '$select=Id,Amount&$expand=Contact($select=Id,City;$expand=City($select=Id,Name))', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1040, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1189, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por cidade - últimos 6 meses', '#333', 2, NULL, 0)




	--VENDAS: ESTADO
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por estado - últimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			11, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Por estado - últimos 6 meses', '$filter=((Contact/CityId+ne+null+and+date(Date)+eq+$lastnmonths(6)))', 4, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1040, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1189, 1, 1)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 4, 'Por estado - últimos 6 meses', @FilterId, '$select=Id,Amount&$expand=Contact($select=Id,City;$expand=City($select=Id,State;$expand=State($select=Id,Name)))', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1059, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1189, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1040, 1, 2)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1057, 1, 3)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por estado - últimos 6 meses', '#333', 2, NULL, 0)


	
	--PROPOSTAS
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@AccountId, 'Propostas', @UserId)

	SET @PanelId = SCOPE_IDENTITY()

	--PROPOSTAS: GERADAS ÚLTIMOS 12 MESES 1
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 1, 'Propostas geradas nos últimos 12 meses', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"MMMM yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#786fb1"]}',
			0, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Propostas geradas nos últimos 12 meses', '$filter=((date(Date)+eq+$lastnmonths(12)))', 7, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1110, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(12)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 7, 'Propostas geradas nos últimos 12 meses', @FilterId, '$select=Id,Date', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1110, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Propostas geradas nos últimos 12 meses', '#786fb1', 1, 4, 0)



	--PROPOSTAS: GERADAS ÚLTIMOS 12 MESES 2
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Propostas geradas nos últimos 12 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#786fb1"]}',
			1, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Propostas geradas nos últimos 12 meses', '$filter=((date(Date)+eq+$lastnmonths(12)))', 7, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1110, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(12)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 7, 'Propostas geradas nos últimos 12 meses', @FilterId, '$select=Id', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Propostas geradas nos últimos 12 meses', '#786fb1', 1, NULL, 0)




	--PROPOSTAS: ANDAMENTO
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Dessas, estão em andamento:', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#67878f"]}',
			2, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Dessas, estão em andamento:', '$filter=((date(Date)+eq+$lastnmonths(12)+and+Deal/StatusId+eq+1))', 7, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1110, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(12)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 1)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 7, 'Dessas, estão em andamento:', @FilterId, '$select=Id', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Dessas, estão em andamento:', '#67878f', 1, NULL, 0)



	--PROPOSTAS: GANHAS
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Dessas, foram ganhas:', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#27c24c"]}',
			3, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Dessas, foram ganhas:', '$filter=((date(Date)+eq+$lastnmonths(12)+and+Deal/StatusId+eq+2))', 7, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1110, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(12)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 2)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 7, 'Dessas, foram ganhas:', @FilterId, '$select=Id', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Dessas, foram ganhas:', '#27c24c', 1, NULL, 0)



	--PROPOSTAS: PERDIDAS
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Dessas, foram perdidas:', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#f05050"]}',
			4, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Dessas, foram perdidas:', '$filter=((date(Date)+eq+$lastnmonths(12)+and+Deal/StatusId+eq+3))', 7, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1110, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(12)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 3)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 7, 'Dessas, foram perdidas:', @FilterId, '$select=Id', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Dessas, foram perdidas:', '#f05050', 1, NULL, 0)



	--NEGÓCIOS
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@AccountId, 'Negócios', @UserId)

	SET @PanelId = SCOPE_IDENTITY()

	--NEGÓCIOS: INICIADOS NESTE MÊS POR QTD
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Nº de negócios iniciados neste mês', 'width-33-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"MMMM yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#92aab0"]}',
			0, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Nº de negócios iniciados neste mês', '$filter=((date(StartDate)+eq+$thismonth))', 2, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$thismonth')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 2, 'Nº de negócios iniciados neste mês', @FilterId, '$select=Id,StartDate', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1050, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Nº de negócios iniciados neste mês', '#92aab0', 1, 4, 0)




	--NEGÓCIOS: VALOR DOS INICIADOS NESTE MÊS
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Valor em negócios iniciados neste mês', 'width-33-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#92aab0"]}',
			1, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Valor em negócios iniciados neste mês', '$filter=((date(StartDate)+eq+$thismonth))', 2, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$thismonth')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 2, 'Valor em negócios iniciados neste mês', @FilterId, '$select=Id,Amount', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1053, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Valor em negócios iniciados neste mês', '#92aab0', 2, NULL, 0)



	--NEGÓCIOS: VALOR MÉDIO DOS INICIADOS NESTE MÊS
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Valor médio dos negócios deste mês', 'width-33-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#92aab0"]}',
			2, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Valor médio dos negócios deste mês', '$filter=((date(StartDate)+eq+$thismonth))', 2, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$thismonth')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 2, 'Valor médio dos negócios deste mês', @FilterId, '$select=Id,Amount', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1053, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Valor médio dos negócios deste mês', '#92aab0', 3, NULL, 0)



	--NEGÓCIOS: INICIADOS NOS ÚLTIMOS 6 MESES
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 1, 'Negócios iniciados nos últimos 6 meses', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"MMMM yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#92aab0"]}',
			3, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Negócios iniciados nos últimos 6 meses', '$filter=((date(StartDate)+eq+$lastnmonths(6)))', 2, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 2, 'Negócios iniciados nos últimos 6 meses', @FilterId, '$select=Id,StartDate', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1050, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Negócios iniciados nos últimos 6 meses', '#92aab0', 1, 4, 0)



	--NEGÓCIOS: POR RESPONSÁVEL
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por responsável - últimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333333"],"sort":"event","allowHtml":true,"sortAscending":false,"sortColumn":1,"currentSort":"desc"}',
			4, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Por responsável - últimos 6 meses', '$filter=((date(StartDate)+eq+$lastnmonths(6)+and+OwnerId+ne+null))', 2, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1049, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 2, 'Por responsável - últimos 6 meses', @FilterId, '$select=Id,Owner&$expand=Owner($select=Id,Name,AvatarUrl)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1049, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por responsável - últimos 6 meses', '#333333', 1, NULL, 0)




	--NEGÓCIOS: POR ORIGEM
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por origem - últimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"sortAscending":false,"sortColumn":1,"currentSort":"desc"}',
			5, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Por origem - últimos 6 meses', '$filter=((date(StartDate)+eq+$lastnmonths(6)+and+OriginId+ne+null))', 2, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1179, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 2, 'Por origem - últimos 6 meses', @FilterId, '$select=Id,Origin&$expand=Origin($select=Id,Name)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1179, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por origem - últimos 6 meses', '#333', 1, NULL, 0)
	


	--CLIENTES
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@AccountId, 'Clientes', @UserId)

	SET @PanelId = SCOPE_IDENTITY()

	--CLIENTES: CADASTRADOS NOS ÚLTIMOS 6 MESES
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 1, 'Clientes cadastrados nos últimos 6 meses', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"MMMM yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#23b7e5"]}',
			0, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Clientes cadastrados nos últimos 6 meses', '$filter=((date(CreateDate)+eq+$lastnmonths(6)))', 1, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1097, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 1, 'Clientes cadastrados nos últimos 6 meses', @FilterId, '$select=Id,CreateDate', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1097, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1291, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Clientes cadastrados nos últimos 6 meses', '#23b7e5', 1, 4, 0)


	--CLIENTES: DIVISÃO POR SITUAÇÃO
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 4, 'Divisão dos clientes por situação', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category"}',
			1, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Divisão dos clientes por situação', '$filter=true', 1, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 1, 'Divisão dos clientes por situação', @FilterId, '$select=Id,Status&$expand=Status($select=Id,Name)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1020, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1291, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Divisão dos clientes por situação', '#1caad6', 1, NULL, 0)



	--CLIENTES: DIVISÃO POR ORIGEM
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 4, 'Divisão dos clientes por origem', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category"}',
			2, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Divisão dos clientes por origem', '$filter=((OriginId+ne+null))', 1, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1025, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 1, 'Divisão dos clientes por origem', @FilterId, '$select=Id,Origin&$expand=Origin($select=Id,Name)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1025, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1291, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Divisão dos clientes por origem', '#18a9d6', 1, NULL, 0)



	--CLIENTES: SEGMENTOS
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Segmentos dos clientes', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"sortAscending":false,"sortColumn":1,"currentSort":"desc"}',
			3, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Segmentos dos clientes', '$filter=((LineOfBusinessId+ne+null))', 1, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1024, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 1, 'Segmentos dos clientes', @FilterId, '$select=Id,LineOfBusiness&$expand=LineOfBusiness($select=Id,Name)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1024, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1291, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Segmentos dos clientes', '#333', 1, NULL, 0)



	--CLIENTES: ESTADOS
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Estados dos clientes', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"sortAscending":false,"sortColumn":1,"currentSort":"desc"}',
			4, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Estados dos clientes', '$filter=((CityId+ne+null))', 1, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1040, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 1, 'Estados dos clientes', @FilterId, '$select=Id&$expand=City($select=Id,State;$expand=State($select=Id,Name))', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1291, 1, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1059, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1040, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1057, 1, 2)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Estados dos clientes', '#333', 1, NULL, 0)
	


	--REGISTRO DE CONTATO
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@AccountId, 'Interações', @UserId)

	SET @PanelId = SCOPE_IDENTITY()

	--REGISTROS DE CONTATO: ÚLTIMOS 30 DIAS
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 1, 'Interações nos últimos 30 dias', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"dd/MM/yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#37bc9b"]}',
			0, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Interações nos últimos 30 dias', '$filter=((date(Date)+eq+$last30days))', 36, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1093, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$last30days')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 36, 'Interações nos últimos 30 dias', @FilterId, '$select=Id,Date', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1093, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1298, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Interações nos últimos 30 dias', '#37bc9b', 1, 1, 0)


	--REGISTROS DE CONTATO: ÚLTMOS 60 DIAS POR DIA DA SEMANA
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 4, 'Por dia da semana - últimos 60 dias', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category"}',
			1, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Por dia da semana - 60 últimos dias', '$filter=((date(Date)+eq+$lastndays(60)))', 36, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1093, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastndays(60)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 36, 'Por dia da semana - últimos 60 dias', @FilterId, '$select=Id,Date', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1093, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1298, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por dia da semana - últimos 60 dias', '#35bd9b', 1, 3, 0)


	--REGISTROS DE CONTATO: ÚLTIMOS 60 DIAS POR CIDADE
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por cidade - últimos 60 dias', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			2, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Por cidade - últimos 60 dias', '$filter=((date(Date)+eq+$lastndays(60)+and+Contact/CityId+ne+null))', 36, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1093, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastndays(60)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1040, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1091, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 36, 'Por cidade - últimos 60 dias', @FilterId, '$select=Id&$expand=Contact($select=Id,City;$expand=City($select=Id,Name))', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1298, 1, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1040, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1091, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por cidade - últimos 60 dias', '#333', 1, NULL, 0)

	

	--FUNIL DE VENDAS
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@AccountId, 'Funil de vendas', @UserId)

	SET @PanelId = SCOPE_IDENTITY()

	--FUNIL DE VENDAS: ANALISE HISTÓRICA
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId, DealPipelineId, ViewId)
		VALUES (@PanelId, 9, 'Análise histórica do funil de vendas (últimos 6 meses por padrão)', 'full-width', '{}',
			0, @UserId, @ID_Funil, 2)

	--FUNIL DE VENDAS: MOTIVOS DE PERDA
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 4, 'Motivos de perda - últimos 6 meses', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category"}',
			1, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Motivos de perda - últimos 6 meses', '$filter=((date(FinishDate)+eq+$lastnmonths(6)+and+StatusId+eq+3))', 2, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1051, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 3)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 2, 'Motivos de perda - últimos 6 meses', @FilterId, '$select=Id&$expand=LossReason($select=Id,Name)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1080, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Motivos de perda - últimos 6 meses', '#f05050', 1, NULL, 0)


	--FUNIL DE VENDAS: SITUAÇÃO ATUAL
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId, DealPipelineId)
		VALUES (@PanelId, 8, 'Situação atual do funil', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333","#333","#333","#333"],"sort":"event"}',
			2, @UserId, @ID_Funil)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Média de dias no estágio', '$filter=((StatusId+eq+1))+and+PipelineId+eq+' + CONVERT(NVARCHAR(10), @ID_Funil), 2, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 1)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1303, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, @ID_Funil)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 2, 'Média de dias no estágio', @FilterId, '$select=Id,DaysInStage&$expand=Stage($select=Id,Name)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1048, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1082, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Média de dias no estágio', '#333', 3, NULL, 3)


	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Valor médio', '$filter=((StatusId+eq+1))+and+PipelineId+eq+' + CONVERT(NVARCHAR(10), @ID_Funil), 2, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 1)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1303, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, @ID_Funil)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 2, 'Valor médio', @FilterId, '$select=Id,Amount&$expand=Stage($select=Id,Name)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1048, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1053, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Valor médio', '#333', 3, NULL, 2)
	

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Potencial em valor', '$filter=((StatusId+eq+1))+and+PipelineId+eq+' + CONVERT(NVARCHAR(10), @ID_Funil), 2, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 1)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1303, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, @ID_Funil)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 2, 'Potencial em valor', @FilterId, '$select=Id,Amount&$expand=Stage($select=Id,Name)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1048, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1053, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Potencial em valor', '#333', 2, NULL, 1)


	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Quantidade de negócios', '$filter=((StatusId+eq+1))+and+PipelineId+eq+' + CONVERT(NVARCHAR(10), @ID_Funil), 2, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 1)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1303, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, @ID_Funil)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 2, 'Quantidade de negócios', @FilterId, '$select=Id,Amount&$expand=Stage($select=Id,Name)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1048, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Quantidade de negócios', '#333', 1, NULL, 0)



	--PRODUTIVIDADE
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@AccountId, 'Produtividade', @UserId)

	SET @PanelId = SCOPE_IDENTITY()

	--PRODUTIVIDADE POR PESSOA
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por pessoa - últimos 30 dias', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#23876e","#ff902b","#59747a","#625a94","#27c24c"],"sort":"event","allowHtml":true,"currentSort":"asc","sortAscending":true,"sortColumn":0}',
			0, @UserId)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Quantidade de Interações', '$filter=((date(Date)+eq+$last30days))', 36, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1093, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$last30days')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 36, 'Quantidade de Interações', @FilterId, '$select=Id&$expand=Creator($select=Id,Name,AvatarUrl)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1175, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1298, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Quantidade de Interações', '#23876e', 1, NULL, 0)


	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Leads criados', '$filter=((date(CreateDate)+eq+$last30days+and+OwnerId+ne+null))', 3, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1257, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$last30days')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1246, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 3, 'Leads criados', @FilterId, '$select=Id&$expand=Owner($select=Id,Name,AvatarUrl)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1246, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1293, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Leads criados', '#ff902b', 1, NULL, 1)


	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Negócios iniciados', '$filter=((date(StartDate)+eq+$last30days+and+OwnerId+ne+null))',2, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$last30days')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1049, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 2, 'Negócios iniciados', @FilterId, '$select=Id&$expand=Owner($select=Id,Name,AvatarUrl)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1049, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Negócios iniciados', '#59747a', 1, NULL, 2)


	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Propostas geradas', '$filter=((date(Date)+eq+$last30days+and+Deal/OwnerId+ne+null))', 7, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1110, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$last30days')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1049, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 7, 'Propostas geradas', @FilterId, '$select=Id&$expand=Deal($select=Id,Owner;$expand=Owner($select=Id,Name,AvatarUrl))', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1049, 1, 0)
	SET @TableFieldId = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1109, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Propostas geradas', '#625a94', 1, NULL, 3)


	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Total em vendas', '$filter=((date(Date)+eq+$last30days+and+OwnerId+ne+null))', 4, 0, @UserId)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$last30days')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1183, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@AccountId, 4, 'Total em vendas', @FilterId, '$select=Id,Amount&$expand=Owner($select=Id,Name,AvatarUrl)', 0, @UserId)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1183, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	--Task table
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Todas', '$filter=true', 12, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 12, 'Todas', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1009, 1, 0, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1009, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1001, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1003, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1004, 1, 3)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Total em vendas', '#27c24c', 2, NULL, 4)


	INSERT INTO Produto_Parte_Group VALUES ('Opcionais', 1, @UserId, GETDATE(), NULL, NULL, 'False', @AccountId, 21)


	--Insert the Panel Goal

	INSERT INTO Panel_Goal (AccountId,CreateDate,CreatorId,Name,Suspended,UpdateDate,UpdaterId) VALUES (@AccountId,GETDATE(),@UserId,'Metas',0,NULL,NULL)

	--Logs@Changes table
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@AccountId, 'Todos', '$filter=true', 91, 0, @UserId)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@AccountId, 91, 'Todos', @ID_FiltroGeral, @UserId)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1487, 1, 0, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1488, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1486, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1483, 1, 3)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1490, 1, 4)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1489, 1, 5)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1484, 1, 6)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1485, 1, 7)

	INSERT INTO Tarefa_Classe_Account (AccountId, TypeId, Listable)
	SELECT @AccountId, TC.ID, 1
		FROM Tarefa_Classe TC


	--Insert configs in Fields
	INSERT INTO CampoFixo2_ClientePloomes (ID_ClientePloomes, ID_Campo, Obrigatorio, Unico, Bloqueado, Expandido, FiltroFormulario, FormulaEditor, Oculto, ColumnSize, UseCheckbox, FilterId)
		VALUES (@AccountId, 1496, 1, 0, 0, 1, 0, 0, 0, 1, 1, NULL)

	--Retorna a chave do usuário para o login automático
	UPDATE Usuario SET Chave = STUFF(CONVERT(NVARCHAR(128), HASHBYTES('SHA2_512', CONVERT(NVARCHAR(10), ID) + CONVERT(VARCHAR(8), GETDATE(), 108) + 'AD9484845F7A4FC40AREDDINOSAUR2C3AEEE3265B942F1B13F6' + CONVERT(NVARCHAR(2), DAY(GETDATE())) + CONVERT(NVARCHAR(4), YEAR(GETDATE())) + CONVERT(NVARCHAR(2), MONTH(GETDATE()))), 2), 50, 0, CONVERT(NVARCHAR(10), ID))
		WHERE ID = @UserId


	-- Add last update date 
	INSERT INTO Campo_Tabela_LastUpdate (AccountId,EntityId,LastUpdateDate) VALUES (@AccountId, 24, GETDATE())
	INSERT INTO Campo_Tabela_LastUpdate (AccountId,EntityId,LastUpdateDate) VALUES (@AccountId, 33, GETDATE())
	INSERT INTO Campo_Tabela_LastUpdate (AccountId,EntityId,LastUpdateDate) VALUES (@AccountId, 77, GETDATE())
	INSERT INTO Campo_Tabela_LastUpdate (AccountId,EntityId,LastUpdateDate) VALUES (@AccountId, 81, GETDATE())
	INSERT INTO Campo_Tabela_LastUpdate (AccountId,EntityId,LastUpdateDate) VALUES (@AccountId, 93, GETDATE())
	INSERT INTO Campo_Tabela_LastUpdate (AccountId,EntityId,LastUpdateDate) VALUES (@AccountId, 63, GETDATE())


	SELECT U.Chave, PC.URL_Login, @AccountId AS ID_ClientePloomes, @UserId AS ID_Usuario, @AutomationUserId AS ID_UsuarioAutomacao
		FROM Usuario U INNER JOIN Ploomes_Cliente PC ON U.ID_ClientePloomes = PC.ID
		WHERE U.ID = @UserId
END
GO

ALTER PROCEDURE [dbo].[Ploomes_Cliente_Insert_Gratis]
	@NomeEmpresa NVARCHAR(150),
	@NomeUsuario NVARCHAR(150),
	@Telefone NVARCHAR(80),
	@Email NVARCHAR(200),
	@Senha NVARCHAR(250),
	@ID_ClienteCRM INT = NULL,
	@ID_OportunidadeCRM INT = NULL,
	@TrackGA_CRM DATETIME = NULL,
	@TrackGA_Propostas DATETIME = NULL,
	@WebsiteOrigem NVARCHAR(50) = NULL,
	@ParceiroOrigem NVARCHAR(50) = NULL,
	@ID_SegmentoCRM INT = NULL,
	@TrackingCookie NVARCHAR(500) = NULL,
	@HostSetId INT = 1,
    @ID_ClientePloomes INT = NULL OUTPUT,
    @ID_Usuario INT = NULL OUTPUT,
    @ID_UsuarioAutomacao INT = NULL OUTPUT
AS BEGIN
	DECLARE @MailBody NVARCHAR(MAX)
	DECLARE @ChaveIntegracao NVARCHAR(300)
	
	INSERT INTO Ploomes_Cliente (Nome, Email, Telefone, DataCriacao, Expira, ID_Plano, ID_TipoPlano, Cultura, ID_Moeda,
			ID_ClienteCRM, ID_OportunidadeCRM, ID_SegmentoCRM, TrackGA_CRM, TrackGA_Propostas, WebsiteOrigem, ParceiroOrigem,
			TrackingCookie, Vendas, Cotacoes, Documentos, Leads, URL_Login, HostSetId, DiasBoleto_Pagamento, DocumentsUrl, FirstLoginTypeId, ConfiguracoesIniciais, WhatsAppExtension, ReportsModule)
		VALUES (@NomeEmpresa, @Email, @Telefone, GETDATE(), DATEADD(d, 14, GETDATE()), 2, 3, 'pt-BR', 1, @ID_ClienteCRM,
			@ID_OportunidadeCRM, @ID_SegmentoCRM, @TrackGA_CRM, @TrackGA_Propostas, @WebsiteOrigem, @ParceiroOrigem,
			@TrackingCookie, 1, 1, 1, 0, 'https://app.ploomes.com/Public/Login.aspx?uk=', @HostSetId, 7, 'https://documents.ploomes.com/', 1, 1, 1, 0)
		
	SET @ID_ClientePloomes = SCOPE_IDENTITY()

	INSERT INTO Usuario (ID_ClientePloomes, Email, Senha, Nome, ID_Perfil, SenhaInicial)
		VALUES (@ID_ClientePloomes, CONVERT(NVARCHAR(200), @Email), @Senha, CONVERT(NVARCHAR(100), @NomeUsuario), 1, 1)
			
	SET @ID_Usuario = SCOPE_IDENTITY()

	INSERT INTO Usuario (ID_ClientePloomes, Email, Senha, Nome, AvatarUrl, ID_Perfil, Integracao, IntegracaoNativa, Cortesia, Chave)
		VALUES (@ID_ClientePloomes, 'noreply@ploomes.com', '-', 'Automa��o', 'https://stgploomescrmprd01.blob.core.windows.net/crm-prd/automation.png', 1, 1, 1, 1,
			STUFF(CONVERT(NVARCHAR(128), HASHBYTES('SHA2_512', CONVERT(NVARCHAR(10), @ID_ClientePloomes) + CONVERT(VARCHAR(8), GETDATE(), 108) + 'AD9484845F7A4FC40AREDDINOSAUR2C3AEEE3265B942F1B13F6' + CONVERT(NVARCHAR(2), DAY(GETDATE())) + CONVERT(NVARCHAR(4), YEAR(GETDATE())) + CONVERT(NVARCHAR(2), MONTH(GETDATE()))), 2), 50, 0, CONVERT(NVARCHAR(10), @ID_ClientePloomes)))
			
	SET @ID_UsuarioAutomacao = SCOPE_IDENTITY()

	INSERT INTO Usuario_Suspenso_Historico (ID_Usuario, Suspenso, ID_Atualizador, Pagamento_Contabiliza) VALUES (@ID_Usuario, 0, @ID_Usuario, 1)

	INSERT INTO Field (
       AccountId,
	   [Key],
	   FieldId,
	   [Dynamic]
	)
	SELECT @ID_ClientePloomes, CF.Chave, CF.ID, 0 FROM CampoFixo2 CF WHERE EXISTS(SELECT 1 FROM CampoFixo2_Cultura CFC WHERE CF.ID = CFC.ID_Campo)

	--GHOST CONTACT
	INSERT INTO Cliente (ID_ClientePloomes, Nome, ID_Tipo, ID_Status, ID_Criador, DataCriacao, Suspenso, Ghost)
		VALUES (@ID_ClientePloomes, '', 0, 0, @ID_Usuario, GETDATE(), 1, 1)
		
	UPDATE Ploomes_Cliente
		SET ID_Criador = @ID_Usuario, ID_UsuarioAutomacao = @ID_UsuarioAutomacao,
			ChaveIntegracao = STUFF(CONVERT(NVARCHAR(128), HASHBYTES('SHA2_512', CONVERT(NVARCHAR(10), ID) + 'AD9484845F7A4FBLUECOW40A2C3AEEE3265B942F1B13F6'), 2), 50, 0, CONVERT(NVARCHAR(10), ID)),
			ChaveSecreta = STUFF(CONVERT(NVARCHAR(128), HASHBYTES('SHA2_512', CONVERT(NVARCHAR(10), ID) + '44828273F95B188AREDDINOSAUR174B97B49819EC46668DEA6B'), 2), 50, 0, CONVERT(NVARCHAR(10), ID)),
			Pasta = CONVERT(NVARCHAR(12), STUFF(CONVERT(NVARCHAR(128), HASHBYTES('SHA2_512', CONVERT(NVARCHAR(10), ID) + '4UIOJHGR8NB77FF95B188'), 2), 4, 0, CONVERT(NVARCHAR(10), ID)))
		WHERE ID = @ID_ClientePloomes

	SELECT @ChaveIntegracao = ChaveIntegracao
		FROM Ploomes_Cliente
		WHERE ID = @ID_ClientePloomes

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, SingularUnitName, PluralUnitName, GenderId)
		VALUES (@ID_ClientePloomes, 2, 'Neg�cio', 'Neg�cios', 1)

	EXEC ReplaceEntityTexts @ID_ClientePloomes, 2

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, SingularUnitName, PluralUnitName, GenderId)
		VALUES (@ID_ClientePloomes, 44, 'Funil', 'Funis', 1)

	EXEC ReplaceEntityTexts @ID_ClientePloomes, 44

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, SingularUnitName, PluralUnitName, GenderId)
		VALUES (@ID_ClientePloomes, 75, 'Produto de cliente', 'Produtos de cliente', 1)

	EXEC ReplaceEntityTexts @ID_ClientePloomes, 75

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, SingularUnitName, PluralUnitName, GenderId)
		VALUES (@ID_ClientePloomes, 96, 'Cole��o', 'Cole��es', 1)

	EXEC ReplaceEntityTexts @ID_ClientePloomes, 96

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, SingularUnitName, PluralUnitName, GenderId)
		VALUES (@ID_ClientePloomes, 97, 'Arquivo', 'Arquivos', 1)

	EXEC ReplaceEntityTexts @ID_ClientePloomes, 97

	INSERT INTO Lead_MotivoDescarte (ID_ClientePloomes, Descricao, ID_Criador, BaseNameId) VALUES (@ID_ClientePloomes, 'Dados incorretos', @ID_Usuario, 22)
	INSERT INTO Lead_MotivoDescarte (ID_ClientePloomes, Descricao, ID_Criador, BaseNameId) VALUES (@ID_ClientePloomes, 'N�o era um cliente em potencial', @ID_Usuario, 23)
	INSERT INTO Lead_MotivoDescarte (ID_ClientePloomes, Descricao, ID_Criador, BaseNameId) VALUES (@ID_ClientePloomes, 'N�o existe', @ID_Usuario, 24)
	INSERT INTO Lead_MotivoDescarte (ID_ClientePloomes, Descricao, ID_Criador, BaseNameId) VALUES (@ID_ClientePloomes, 'N�o tem interesse', @ID_Usuario, 25)

	INSERT INTO Lead_Status (ID_ClientePloomes, Descricao, ID_Criador, CSS_Icon, CSS_Icon_SPA, BaseNameId) VALUES (@ID_ClientePloomes, 'Fim da fila', @ID_Usuario, 'bluecow-clock icon-helper text-muted', 'fa-arrow-alt-down', 20)

	DECLARE @ID_Funil INT
	INSERT INTO Oportunidade_Funil (ID_ClientePloomes, Descricao, PassaTodosEstagios, ProibidoVoltarEstagios, AdicionaPropostas, ID_Criador, IconId, Color, SingularUnitName, PluralUnitName, GenderId)
		VALUES (@ID_ClientePloomes, 'Funil de vendas', 0, 0, 1, @ID_Usuario, 2, '#92aab0', 'Neg�cio', 'Neg�cios', 1)

	SET @ID_Funil = SCOPE_IDENTITY()

	INSERT INTO Oportunidade_MotivoPerda (ID_ClientePloomes, Descricao, PipelineId, ID_Criador) VALUES (@ID_ClientePloomes, 'Vit�ria da concorr�ncia', @ID_Funil, @ID_Usuario)
	INSERT INTO Oportunidade_MotivoPerda (ID_ClientePloomes, Descricao, PipelineId, ID_Criador) VALUES (@ID_ClientePloomes, 'Sem recursos financeiros', @ID_Funil, @ID_Usuario)
	INSERT INTO Oportunidade_MotivoPerda (ID_ClientePloomes, Descricao, PipelineId, ID_Criador) VALUES (@ID_ClientePloomes, 'Desinteresse pelos produtos', @ID_Funil, @ID_Usuario)

	INSERT INTO Oportunidade_Status (ID_ClientePloomes, ID_Funil, Descricao, Ordem, ID_Criador) VALUES (@ID_ClientePloomes, @ID_Funil, 'Primeiros contatos', 1, @ID_Usuario)
	INSERT INTO Oportunidade_Status (ID_ClientePloomes, ID_Funil, Descricao, Ordem, ID_Criador) VALUES (@ID_ClientePloomes, @ID_Funil, 'Frio', 2, @ID_Usuario)
	INSERT INTO Oportunidade_Status (ID_ClientePloomes, ID_Funil, Descricao, Ordem, ID_Criador) VALUES (@ID_ClientePloomes, @ID_Funil, 'Morno', 3, @ID_Usuario)
	INSERT INTO Oportunidade_Status (ID_ClientePloomes, ID_Funil, Descricao, Ordem, ID_Criador) VALUES (@ID_ClientePloomes, @ID_Funil, 'Quente', 4, @ID_Usuario)
	INSERT INTO Oportunidade_Status (ID_ClientePloomes, ID_Funil, Descricao, Ordem, ID_Criador) VALUES (@ID_ClientePloomes, @ID_Funil, 'Fechamento', 5, @ID_Usuario)

	INSERT INTO Cliente_Status (ID_ClientePloomes, Descricao, CSS_Label, CSS_Icon, CSS_Color, Img, Prospeccao, ID_Criador) VALUES (@ID_ClientePloomes, 'Prospec��o', 'motivblue', 'icon-spinner', 'text-info', 'prospect.png', 1, @ID_Usuario)
	INSERT INTO Cliente_Status (ID_ClientePloomes, Descricao, CSS_Label, CSS_Icon, CSS_Color, Img, ID_Criador) VALUES (@ID_ClientePloomes, 'Ativo', 'motivsuccess', 'icon-ok', 'text-success', 'active.png', @ID_Usuario)
	INSERT INTO Cliente_Status (ID_ClientePloomes, Descricao, CSS_Label, CSS_Icon, CSS_Color, Img, ID_Criador) VALUES (@ID_ClientePloomes, 'Inativo', 'motivred', 'icon-minus-sign', 'text-danger', 'inactive.png', @ID_Usuario)
	INSERT INTO Cliente_Status (ID_ClientePloomes, Descricao, CSS_Label, CSS_Icon, CSS_Color, Img, Descartado, ID_Criador) VALUES (@ID_ClientePloomes, 'Descartado', 'motivdark', 'icon-trash', NULL, 'discarded.png', 1, @ID_Usuario)

	INSERT INTO Assinatura_Status (ID_ClientePloomes, Descricao, Ordem, ID_Criador) VALUES (@ID_ClientePloomes, 'Ativas', 1, @ID_Usuario)
	INSERT INTO Assinatura_Status (ID_ClientePloomes, Descricao, Ordem, ID_Criador) VALUES (@ID_ClientePloomes, 'Canceladas', 2, @ID_Usuario)

	INSERT INTO Usuario_Perfil (ID_ClientePloomes, Descricao, Cliente_Ve, Cliente_Edita, Cliente_Tarefa_Ve, Cliente_Tarefa_Edita,
			Cliente_Oportunidade_Ve, Cliente_Oportunidade_Edita, Cliente_Oportunidade_Tarefa_Ve, Cliente_Oportunidade_Tarefa_Edita,
			Cliente_Venda_Ve, Cliente_Venda_Edita, Lead_Ve, Lead_Edita, ExportaExcel, Origem_Cria, Cargo_Cria, Produto_Cria,
			Motivo_Cria, Cidade_Cria, Etiqueta_Cria, Comissao_Cria, Cliente_Exclui, Oportunidade_Exclui, Venda_Exclui, Lead_Exclui,
			ID_Criador)
		VALUES (@ID_ClientePloomes, 'Funcion�rio', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, @ID_Usuario)

	INSERT INTO Usuario_Perfil (ID_ClientePloomes, Descricao, Cliente_Ve, Cliente_Edita, Cliente_Tarefa_Ve, Cliente_Tarefa_Edita,
			Cliente_Oportunidade_Ve, Cliente_Oportunidade_Edita, Cliente_Oportunidade_Tarefa_Ve, Cliente_Oportunidade_Tarefa_Edita,
			Cliente_Venda_Ve, Cliente_Venda_Edita, Lead_Ve, Lead_Edita, ExportaExcel, Origem_Cria, Cargo_Cria, Produto_Cria,
			Motivo_Cria, Cidade_Cria, Etiqueta_Cria, Comissao_Cria, Cliente_Exclui, Oportunidade_Exclui, Venda_Exclui, Lead_Exclui,
			ID_Criador)
		VALUES (@ID_ClientePloomes, 'Gestor Geral', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, @ID_Usuario)

	INSERT INTO Usuario_Perfil (ID_ClientePloomes, Descricao, Cliente_Ve, Cliente_Edita, Cliente_Tarefa_Ve, Cliente_Tarefa_Edita,
			Cliente_Oportunidade_Ve, Cliente_Oportunidade_Edita, Cliente_Oportunidade_Tarefa_Ve, Cliente_Oportunidade_Tarefa_Edita,
			Cliente_Venda_Ve, Cliente_Venda_Edita, Lead_Ve, Lead_Edita, ExportaExcel, Origem_Cria, Cargo_Cria, Produto_Cria,
			Motivo_Cria, Cidade_Cria, Etiqueta_Cria, Comissao_Cria, Cliente_Exclui, Oportunidade_Exclui, Venda_Exclui, Lead_Exclui,
			ID_Criador)
		VALUES (@ID_ClientePloomes, 'Gestor de Equipe', 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, @ID_Usuario)

	INSERT INTO Usuario_Perfil (ID_ClientePloomes, Descricao, Cliente_Ve, Cliente_Edita, Cliente_Tarefa_Ve, Cliente_Tarefa_Edita,
			Cliente_Oportunidade_Ve, Cliente_Oportunidade_Edita, Cliente_Oportunidade_Tarefa_Ve, Cliente_Oportunidade_Tarefa_Edita,
			Cliente_Venda_Ve, Cliente_Venda_Edita, Lead_Ve, Lead_Edita, ExportaExcel, Origem_Cria, Cargo_Cria, Produto_Cria,
			Motivo_Cria, Cidade_Cria, Etiqueta_Cria, Comissao_Cria, Cliente_Exclui, Oportunidade_Exclui, Venda_Exclui, Lead_Exclui,
			ID_Criador)
		VALUES (@ID_ClientePloomes, 'Vendedor', 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 2, 3, 1, 1, 1, 1, 1, 1, 1, 0, 3, 3, 3, 3, @ID_Usuario)

	INSERT INTO Usuario_Perfil (ID_ClientePloomes, Descricao, Cliente_Ve, Cliente_Edita, Cliente_Tarefa_Ve, Cliente_Tarefa_Edita,
			Cliente_Oportunidade_Ve, Cliente_Oportunidade_Edita, Cliente_Oportunidade_Tarefa_Ve, Cliente_Oportunidade_Tarefa_Edita,
			Cliente_Venda_Ve, Cliente_Venda_Edita, Lead_Ve, Lead_Edita, ExportaExcel, Origem_Cria, Cargo_Cria, Produto_Cria,
			Motivo_Cria, Cidade_Cria, Etiqueta_Cria, Comissao_Cria, Cliente_Exclui, Oportunidade_Exclui, Venda_Exclui, Lead_Exclui,
			ID_Criador)
		VALUES (@ID_ClientePloomes, 'Representante', 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 4, @ID_Usuario)

	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Presidente', @ID_Usuario)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Diretor', @ID_Usuario)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Gerente', @ID_Usuario)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Coordenador', @ID_Usuario)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Supervisor', @ID_Usuario)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Analista', @ID_Usuario)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Assistente', @ID_Usuario)
	INSERT INTO Cargo (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Estagi�rio', @ID_Usuario)

	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Administrativo', @ID_Usuario)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Financeiro', @ID_Usuario)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Recursos Humanos', @ID_Usuario)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Comercial', @ID_Usuario)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Operacional', @ID_Usuario)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Marketing', @ID_Usuario)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'P�s-vendas', @ID_Usuario)
	INSERT INTO Departamento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Suprimentos', @ID_Usuario)

	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Agricultura / Pecu�ria', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Arquitetura e Urbanismo', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Banc�rio / Financeiro', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Com�rcio Varejista', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Concession�ria / Auto Pe�as', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Consultoria', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Energia/ Eletricidade', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Ind�stria', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Gr�fica/ Editora', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Incorporadora', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Imprensa', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Log�stica / Armaz�m', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Constru��o Civil', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, '�rg�o P�blico', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Publicidade / Propaganda', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Restaurante', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Sindicato / Associa��o / ONG', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Telecomunica��es', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Turismo / Hotelaria', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Contabilidade / Auditoria', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Educa��o/ Idiomas', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Engenharia', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Tecnologia da Informa��o', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Jur�dica', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Metal�rgica / Sider�rgica', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Outros Servi�os', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Representa��o Comercial', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Supermercado', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Seguros', @ID_Usuario)
	INSERT INTO Cliente_Segmento (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Transportes', @ID_Usuario)

	INSERT INTO Cliente_Origem (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Indica��o', @ID_Usuario)
	INSERT INTO Cliente_Origem (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Site', @ID_Usuario)
	INSERT INTO Cliente_Origem (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Telefone', @ID_Usuario)
	INSERT INTO Cliente_Origem (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Facebook', @ID_Usuario)
	INSERT INTO Cliente_Origem (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Linkedin', @ID_Usuario)
	INSERT INTO Cliente_Origem (ID_ClientePloomes, Descricao, ID_Criador) VALUES (@ID_ClientePloomes, 'Marketing Pago', @ID_Usuario)


	--ABAS
	DECLARE @ID_FiltroGeral INT, @ID_FiltroGeralCampo INT, @ID_Tabela INT, @ID_TabelaCampo INT

	--ABA DE CLIENTES EMPRESAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Empresas', '$filter=((TypeId+eq+1))', 1, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1042, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 1, 'Empresas', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1016, 1, 0, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1027, 1, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1027, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1040, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1040, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1093, 1, 3)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1164, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1020, 1, 4)


	--ABA DE CLIENTES PESSOAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Pessoas', '$filter=((TypeId+eq+2))', 1, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1042, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 2)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 1, 'Pessoas', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1016, 1, 0, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1021, 1, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1021, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1032, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1032, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1022, 1, 3)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1030, 1, 4)


	--ABA DE PRODUTOS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Produtos do cliente', '$filter=true', 75, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@ID_ClientePloomes, 75, 'Produtos do cliente', @ID_FiltroGeral, @ID_Usuario, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1374, 1, 0, 1)


	--ABA DE PRODUTOS DE CLIENTES
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Produtos de clientes', '$filter=true', 75, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel) VALUES (@ID_ClientePloomes, 75, 'Produtos de clientes', @ID_FiltroGeral, @ID_Usuario, 0)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1373, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1374, 1, 1, 0)


	--ABA DE CONTATOS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Contatos do cliente', '$filter=true', 1, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@ID_ClientePloomes, 1, 'Contatos do cliente', @ID_FiltroGeral, @ID_Usuario, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1016, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1032, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1030, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1022, 1, 3, 0)


	--ABA DE NEG�CIOS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Neg�cios do cliente', '$filter=true', 2, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@ID_ClientePloomes, 2, 'Neg�cios do cliente', @ID_FiltroGeral, @ID_Usuario, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1046, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1050, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1053, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1265, 1, 3, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1049, 1, 4, 0)


	--ABA DE VENDAS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Vendas do cliente', '$filter=true', 4, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@ID_ClientePloomes, 4, 'Vendas do cliente', @ID_FiltroGeral, @ID_Usuario, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1171, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1172, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1173, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1177, 1, 3, 0)


	--ABA DE PRODUTOS DE VENDAS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Produtos de vendas do cliente', '$filter=true', 20, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@ID_ClientePloomes, 20, 'Produtos de vendas do cliente', @ID_FiltroGeral, @ID_Usuario, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1200, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1203, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1201, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1204, 1, 3, 0)


	--ABA DE PROPOSTAS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Propostas do cliente', '$filter=true', 7, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@ID_ClientePloomes, 7, 'Propostas do cliente', @ID_FiltroGeral, @ID_Usuario, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1110, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1117, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1124, 1, 3, 0)


	--ABA DE PRODUTOS DE PROPOSTAS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Produtos de propostas do cliente', '$filter=true', 14, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@ID_ClientePloomes, 14, 'Produtos de propostas do cliente', @ID_FiltroGeral, @ID_Usuario, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1130, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1133, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1131, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1134, 1, 3, 0)


	--ABA DE DOCUMENTOS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Documentos do cliente', '$filter=true', 66, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@ID_ClientePloomes, 66, 'Documentos do cliente', @ID_FiltroGeral, @ID_Usuario, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1328, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1329, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1331, 1, 2, 0)


	--ABA DE PRODUTOS DE DOCUMENTOS DO CLIENTE
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Produtos de documentos do cliente', '$filter=true', 68, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador, Listavel, PertenceAPaginaCliente) VALUES (@ID_ClientePloomes, 68, 'Produtos de documentos do cliente', @ID_FiltroGeral, @ID_Usuario, 0, 1)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1316, 1, 0, 1)


	--ABA DE OPORTUNIDADES EM ABERTO
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Em aberto', '$filter=StatusId+eq+1', 2, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 2, 'Em aberto', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1046, 1, 0, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1047, 1, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1047, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1049, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1049, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1053, 1, 3)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1048, 1, 4)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1082, 1, 5)

	INSERT INTO Oportunidade_Funil_Tabela (ID_Funil, ID_Tabela) VALUES (@ID_Funil, @ID_Tabela)


	--ABA DE OPORTUNIDADES GANHAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Ganhas', '$filter=StatusId+eq+2', 2, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 2)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 2, 'Ganhas', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1046, 1, 0, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1047, 1, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1047, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1049, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1049, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1053, 1, 3)

	INSERT INTO Oportunidade_Funil_Tabela (ID_Funil, ID_Tabela) VALUES (@ID_Funil, @ID_Tabela)


	--ABA DE OPORTUNIDADES PERDIDAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Perdidas', '$filter=StatusId+eq+3', 2, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 3)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 2, 'Perdidas', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1046, 1, 0, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1047, 1, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1047, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1049, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1049, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1053, 1, 3)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1080, 1, 4)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1080, 1, 1)

	INSERT INTO Oportunidade_Funil_Tabela (ID_Funil, ID_Tabela) VALUES (@ID_Funil, @ID_Tabela)


	--ABA DE PROPOSTAS EM ABERTO
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Propostas em aberto', '$filter=Deal/StatusId+eq+1', 7, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 1)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_FiltroGeralCampo, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 7, 'Propostas em aberto', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1112, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1047, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1047, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1115, 1, 3)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1115, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1117, 1, 4)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1110, 1, 5)
	
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1048, 1, 6)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)


	--ABA DE PROPOSTAS GANHAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Propostas ganhas', '$filter=Deal/StatusId+eq+2', 7, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 2)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_FiltroGeralCampo, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 7, 'Propostas ganhas', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1112, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1047, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1047, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1117, 1, 3)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1110, 1, 4)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1051, 1, 5)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)


	--ABA DE PROPOSTAS PERDIDAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Propostas perdidas', '$filter=Deal/StatusId+eq+3', 7, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 3)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_FiltroGeralCampo, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 7, 'Propostas perdidas', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1112, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1047, 1, 2)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1047, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1117, 1, 3)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1110, 1, 4)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1051, 1, 5)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1080, 1, 6)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1109, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1080, 1, 2)


	--ABA DE PRODUTOS DE PROPOSTAS EM ABERTO
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Propostas em aberto', '$filter=Deal/StatusId+eq+1', 14, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 1)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_FiltroGeralCampo, 1263, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 14, 'Propostas em aberto', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1138, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1140, 1, 1, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1138, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1102, 1, 2, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1130, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1133, 1, 3, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1131, 1, 4, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1135, 1, 5, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1134, 1, 6, 0)


	--ABA DE PRODUTOS DE PROPOSTAS GANHAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Propostas ganhas', '$filter=Deal/StatusId+eq+2', 14, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 2)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_FiltroGeralCampo, 1263, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 14, 'Propostas ganhas', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1138, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1140, 1, 1, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1138, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1102, 1, 2, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1130, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1133, 1, 3, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1131, 1, 4, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1135, 1, 5, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1134, 1, 6, 0)


	--ABA DE PRODUTOS DE PROPOSTAS PERDIDAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Propostas perdidas', '$filter=Deal/StatusId+eq+3', 14, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1265, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 3)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_FiltroGeralCampo, 1263, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 14, 'Propostas perdidas', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1111, 1, 0, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1138, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1140, 1, 1, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1138, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1102, 1, 2, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1130, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1133, 1, 3, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1131, 1, 4, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1135, 1, 5, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1134, 1, 6, 0)


	--ABA DE VENDAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Vendas', '$filter=true', 4, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 4, 'Vendas', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito, Crescente) VALUES (@ID_Tabela, 1171, 1, 0, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1189, 1, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1173, 1, 2)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1172, 1, 3)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1208, 1, 4)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1177, 1, 5)


	--ABA DE PRODUTOS DE VENDAS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Produtos de vendas', '$filter=true', 20, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 20, 'Produtos de vendas', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito, Crescente) VALUES (@ID_Tabela, 1171, 1, 0, 1, 0)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1207, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1189, 1, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1207, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1200, 1, 2)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1203, 1, 3)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1201, 1, 4)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1205, 1, 5)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1204, 1, 6)


	--ABA DE DOCUMENTOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Documentos', '$filter=true', 66, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, Url, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 66, 'Documentos', '$select=Name,Id,DocumentNumber,Date&$expand=Contact($select=Id,Name)', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Crescente) VALUES (@ID_Tabela, 1328, 1, 0, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1306, 1, 1, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1308, 1, 2)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1329, 1, 3)


	--ABA DE LEADS DISPON�VEIS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Leads dispon�veis', '$filter=((Status/Id+ne+4+and+Status/Id+ne+5+and+Status/Id+ne+6))', 3, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1254, 1, 1, 2)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 4)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1254, 1, 1, 2)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 5)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1254, 1, 1, 2)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 6)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 3, 'Leads dispon�veis', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1240, 1, 10)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1243, 1, 20)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1247, 1, 30)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1245, 1, 40)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1246, 1, 50)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1254, 1, 60)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1256, 1, 70)


	--ABA DE LEADS DISPON�VEIS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Leads descartados', '$filter=((Status/Id+eq+4))', 3, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1254, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 4)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 3, 'Leads descartados', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1240, 1, 10)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1243, 1, 20)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1247, 1, 30)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1245, 1, 40)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1246, 1, 50)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1254, 1, 60)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1256, 1, 70)


	--ABA DE LEADS DISPON�VEIS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Leads convertidos', '$filter=((Status/Id+eq+5+or++Status/Id+eq+6))', 3, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1254, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 5)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1254, 1, 2, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@ID_FiltroGeralCampo, 6)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 3, 'Leads convertidos', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1240, 1, 10)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1243, 1, 20)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1247, 1, 30)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1245, 1, 40)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1246, 1, 50)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1254, 1, 60)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1256, 1, 70)


	--ABA DE PRODUTOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Produtos', '$filter=true', 10, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 10, 'Produtos', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1259, 1, 0, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1102, 1, 1, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1107, 1, 2, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1167, 1, 3, 0)


	--ABA DE GRUPOS DE PRODUTOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Grupos de produtos', '$filter=true', 11, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 11, 'Grupos de produtos', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1108, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1168, 1, 1, 0)


	--ABA DE FAM�LIAS DE PRODUTOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Fam�lias de produtos', '$filter=true', 43, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 43, 'Fam�lias de produtos', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1169, 1, 0, 1)


	--ABA DE LISTAS DE PRODUTOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Listas de produtos', '$filter=true', 76, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 76, 'Listas de produtos', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1388, 1, 0, 1)


	--ABA DE REGISTROS DE INTERA��O
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Registros de intera��o', '$filter=true', 36, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 36, 'Registros de intera��o', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1091, 1, 0, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Crescente) VALUES (@ID_Tabela, 1093, 1, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1165, 1, 2)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1096, 1, 3)


	--ABA DE USU�RIOS ATIVOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Usu�rios ativos', '$filter=not+Suspended', 24, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1348, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorBooleano) VALUES (@ID_FiltroGeralCampo, 0)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 24, 'Usu�rios ativos', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1055, 1, 10)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1054, 1, 20)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1220, 1, 30)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1158, 1, 40)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1159, 1, 50)



	--ABA DE USU�RIOS INATIVOS
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Usu�rios inativos', '$filter=Suspended', 24, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, Numero_Grupo, ID_Operador) VALUES (@ID_FiltroGeral, 1348, 1, 1, 1)
	SET @ID_FiltroGeralCampo = SCOPE_IDENTITY()
	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorBooleano) VALUES (@ID_FiltroGeralCampo, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 24, 'Usu�rios inativos', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1055, 1, 10)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1054, 1, 20)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1220, 1, 30)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1158, 1, 40)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1159, 1, 50)



	--FORMS
	DECLARE @ID_Formulario INT, @ID_FormularioRapido_Segmento INT, @ID_FormularioRapido_Origem INT,
		@ID_FormularioRapido_Cargo INT, @ID_FormularioRapido_Departamento INT, @ID_FormularioRapido_Cidade INT,
		@ID_FormularioRapido_Marcador INT, @ID_Formulario_Empresa INT, @ID_FormularioRapido_Empresa INT, @ID_FormularioRapido_QtdFuncionarios INT,
		@ID_Formulario_Pessoa INT, @ID_FormularioRapido_Pessoa INT,
		@ID_Formulario_Lead INT,
		@ID_Formulario_Produto INT, @ID_Formulario_Produto_Grupo INT, @ID_Formulario_Produto_Familia INT,
		@ID_FormularioRapido_Produto INT, @ID_FormularioRapido_Produto_Grupo INT,
		@ID_Secao INT


	--LINE OF BUSINESS QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@ID_ClientePloomes, 37, 'contact_line_of_business_quick_form')

	SET @ID_FormularioRapido_Segmento = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Segmento, 1098, 1, 10, 0)



	--ORIGIN QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@ID_ClientePloomes, 35, 'contact_origin_quick_form')

	SET @ID_FormularioRapido_Origem = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Origem, 1087, 1, 10, 0)



	--ROLE QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@ID_ClientePloomes, 38, 'role_quick_form')

	SET @ID_FormularioRapido_Cargo = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Cargo, 1099, 1, 10, 0)



	--DEPARTMENT QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@ID_ClientePloomes, 39, 'department_quick_form')

	SET @ID_FormularioRapido_Departamento = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Departamento, 1100, 1, 10, 0)



	--NUMBER OF EMPLOYEES QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@ID_ClientePloomes, 40, 'contact_number_of_employees_quick_form')

	SET @ID_FormularioRapido_QtdFuncionarios = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_QtdFuncionarios, 1101, 1, 10, 0)



	--CITY QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@ID_ClientePloomes, 25, 'city_quick_form')

	SET @ID_FormularioRapido_Cidade = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Cidade, 1056, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Cidade, 1058, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Cidade, 1057, 1, 30, 0)



	--TAG QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@ID_ClientePloomes, 23, 'tag_quick_form')

	SET @ID_FormularioRapido_Marcador = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Marcador, 1044, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Marcador, 1045, 1, 20, 0)



	--PRODUCT GROUP QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@ID_ClientePloomes, 11, 'product_group_quick_form')

	SET @ID_FormularioRapido_Produto_Grupo = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Produto_Grupo, 1108, 1, 10, 0)



	--PRODUCT QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 10, 'product_quick_form', 'Produtos (mini)', 1, 9)

	SET @ID_FormularioRapido_Produto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Produto, 1102, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Produto, 1107, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Produto, 1103, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Produto, 1106, 1, 40, 0)



	--COMPANY QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 1, 'contact_company_quick_form', 'Empresas (mini)', 1, 2)

	SET @ID_FormularioRapido_Empresa = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Empresa, 1016, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Empresa, 1024, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Empresa, 1025, 1, 50, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Empresa, 1043, 1, 60, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Empresa, 1030, 1, 70, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Empresa, 1022, 1, 80, 0)



	--PERSON QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 1, 'contact_person_quick_form', 'Pessoas (mini)', 1, 4)

	SET @ID_FormularioRapido_Pessoa = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Pessoa, 1016, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Pessoa, 1032, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Pessoa, 1033, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Pessoa, 1030, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioRapido_Pessoa, 1022, 1, 50, 0)



	--TASK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@ID_ClientePloomes, 12, 'task_form')

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Secao (ID_Formulario, Ordem)
		VALUES (@ID_Formulario, 10)

	SET @ID_Secao = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1001, 1, 10, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1002, 1, 20, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1003, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1004, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1005, 1, 50, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_Formulario, @ID_Secao, 1006, 1, 60, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_Formulario, @ID_Secao, 1007, 1, 65, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1008, 1, 70, 1)

	INSERT INTO Formulario_Secao (ID_Formulario, Ordem)
		VALUES (@ID_Formulario, 20)

	SET @ID_Secao = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1009, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1010, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1013, 1, 30, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1011, 1, 40, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1014, 1, 50, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1012, 1, 60, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, @ID_Secao, 1015, 1, 70, 1)



	--COMPANY FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 1, 'contact_company_form', 'Empresas', 1, 1)

	SET @ID_Formulario_Empresa = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1016, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1017, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1024, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1025, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1018, 1, 50, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1022, 1, 60, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, 1043, 1, 70, 1)

	INSERT INTO Formulario_Secao (ID_Formulario, Descricao, Ordem)
		VALUES (@ID_Formulario_Empresa, 'Localiza��o', 80)

	SET @ID_Secao = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1036, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1037, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1038, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1039, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1040, 1, 50, 0)

	INSERT INTO Formulario_Secao_Language (SectionId, LanguageId, [Name])
		VALUES (@ID_Secao, 1, 'Localização'), 
			   (@ID_Secao, 2, 'Localization'),
			   (@ID_Secao, 3, 'Localização'),
			   (@ID_Secao, 4, 'Localización')

	INSERT INTO Formulario_Secao (ID_Formulario, Descricao, Ordem)
		VALUES (@ID_Formulario_Empresa, 'Outras informa��es', 90)

	SET @ID_Secao = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1030, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1031, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1027, 1, 70, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1023, 1, 100, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Empresa, @ID_Secao, 1029, 1, 120, 1)

	INSERT INTO Formulario_Secao_Language (SectionId, LanguageId, [Name])
		VALUES (@ID_Secao, 1, 'Outras informações'), 
			   (@ID_Secao, 2, 'Other informations'),
			   (@ID_Secao, 3, 'Outras Informações'),
			   (@ID_Secao, 4, 'Otras informaciones')

	--PERSON FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 1, 'contact_person_form', 'Pessoas', 1, 3)

	SET @ID_Formulario_Pessoa = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, 1016, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, 1021, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, 1022, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, 1030, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, 1032, 1, 50, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, 1033, 1, 60, 0)

	INSERT INTO Formulario_Secao (ID_Formulario, Descricao, Ordem)
		VALUES (@ID_Formulario_Pessoa, 'Outras informa��es', 70)

	SET @ID_Secao = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, @ID_Secao, 1019, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, @ID_Secao, 1028, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, @ID_Secao, 1027, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Pessoa, @ID_Secao, 1029, 1, 40, 1)
	
	INSERT INTO Formulario_Secao_Language (SectionId, LanguageId, [Name])
		VALUES (@ID_Secao, 1, 'Outras informações'), 
			   (@ID_Secao, 2, 'Other informations'),
			   (@ID_Secao, 3, 'Outras Informações'),
			   (@ID_Secao, 4, 'Otras informaciones')


	--CONTACT PRODUCT FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 75, 'contact_product_form', 'Produtos de clientes', 1, 5)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1373, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1374, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente)
		VALUES (@ID_Formulario, 1425, 1, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1426, 1, 1)


	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, FilterForm, BaseNameId)
		VALUES (@ID_ClientePloomes, 75, 'contact_product_filter_form', 'Filtro de produtos de clientes', 1, 1, 6)



	--CONTACT PRODUCT QUICK FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 75, 'contact_product_quick_form', 'Produtos de clientes (mini)', 1, 28)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1373, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1374, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente)
		VALUES (@ID_Formulario, 1425, 1, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1426, 1, 1)



	--INTERACTION RECORD FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 36, 'interaction_record_form', 'Registros de intera��o', 1, 18)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem,  Expandido)
		VALUES (@ID_Formulario, 1091, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1092, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1093, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1095, 1, 40, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1096, 1, 50, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1094, 1, 60, 1)



	--INTERACTION RECORD EDIT FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave)
		VALUES (@ID_ClientePloomes, 36, 'interaction_record_edit_form')

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1093, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1095, 1, 40, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1096, 1, 50, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1094, 1, 60, 1)



	--LEAD FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 3, 'lead_form', 'Leads', 1, 7)

	SET @ID_Formulario_Lead = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Lead, 1240, 1, 10, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1241, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1242, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Lead, 1243, 1, 40, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1244, 1, 50, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1245, 1, 60, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1246, 1, 70, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1247, 1, 80, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario_Lead, 1256, 1, 90, 1)



	--PRODUCT FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 10, 'product_form', 'Produtos', 1, 8)

	SET @ID_Formulario_Produto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto, 1102, 1, 10, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto, 1103, 1, 20, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto, 1107, 1, 30, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto, 1104, 1, 40, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto, 1106, 1, 50, 0, 0)


	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, FilterForm, BaseNameId)
		VALUES (@ID_ClientePloomes, 10, 'product_filter_form', 'Filtro de produtos da base', 1, 1, 14)



	--PRODUCT GROUP FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 11, 'product_group_form', 'Grupos de produtos', 1, 10)

	SET @ID_Formulario_Produto_Grupo = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto_Grupo, 1108, 1, 10, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto_Grupo, 1168, 1, 20, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto_Grupo, 1263, 1, 30, 0, 0)



	--PRODUCT FAMILY FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 43, 'product_family_form', 'Fam�lias de produtos', 1, 11)

	SET @ID_Formulario_Produto_Familia = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario_Produto_Familia, 1169, 1, 10, 0, 1)



	--PRODUCT LIST FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel)
		VALUES (@ID_ClientePloomes, 76, 'product_list_form', 'Listas de produtos', 1)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1388, 1, 10, 0, 1)


	--ORDER FORM
	DECLARE @ID_FormularioVenda INT, @ID_FormularioBloco INT, @ID_FormularioBloco2 INT, @ID_FormularioBloco3 INT,
	@ID_FormularioProduto INT, @ID_FormularioProduto2 INT, @ID_FormularioProduto3 INT,
	@ID_FormularioParte INT, @ID_Modelo INT
	
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel)
		VALUES (@ID_ClientePloomes, 20, 'order_product_form', 'Produtos das vendas', 0)

	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioProduto, 1200, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioProduto, 1201, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioProduto, 1202, 1, 30, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioProduto, 1203, 1, 35, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioProduto, 1205, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioProduto, 1202, 1, 50, 0, 2)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioProduto, 1204, 1, 55, 0, 2)


	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel)
		VALUES (@ID_ClientePloomes, 5, 'order_section_form', 'Se��es das vendas', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1198, 1, 10, 1, @ID_FormularioProduto)
	

	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel)
		VALUES (@ID_ClientePloomes, 4, 'order_form', 'Vendas', 0)

	SET @ID_FormularioVenda = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1190, 1, 20, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1191, 1, 30, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1172, 1, 40, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1183, 1, 50, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1192, 1, 60, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1189, 1, 10, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, ID_FormularioRapido, Codigo_Bloco)
		VALUES (@ID_FormularioVenda, 1196, 1, 70, 1, @ID_FormularioBloco, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1193, 1, 80, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_FormularioVenda, 1194, 1, 90, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioVenda, 1195, 1, 100, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Numero_Grupo)
		VALUES (@ID_FormularioVenda, 1173, 1, 105, 0, 1)

	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, HTML, Margem_Superior, Margem_Inferior, Margem_Lateral, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@ID_ClientePloomes, 4, @ID_FormularioVenda, 'Modelo padr�o', @ID_Usuario, 1,
			N'<table border="0" cellpadding="0" cellspacing="0" style="width:758px"> <tbody> <tr> <td style="padding-bottom: 10px; width: 385px; border-top-color: rgb(255, 255, 255); border-right-color: rgb(255, 255, 255); border-left-color: rgb(255, 255, 255); border-bottom: 2px solid #aaa;"><span style="font-size:0.875em"><span style="color:#808080"><field key="order_date" format="dd/MM/yyyy">[Venda.Data]</field></span></span></td> <td style="padding-bottom: 10px; text-align: right; width: 370px; border-top-color: rgb(255, 255, 255); border-right-color: rgb(255, 255, 255); border-left-color: rgb(255, 255, 255); border-bottom: 2px solid #aaa;"><font color="#808080"><span style="font-size:11.375px">Venda&nbsp;</span></font><span style="font-size:1.000em"><strong><field key="order_number" class="h-card" draggable="true">[Venda.N&uacute;mero]</field></strong></span>&nbsp;</td> </tr> </tbody> </table> <div style="height: 5px">&nbsp;</div> <table border="0" cellpadding="0" cellspacing="0" style="width:758px"> <tbody> <tr> <td style="width: 114px; vertical-align: middle; border-color: white;"> <div style="border: 1px solid #aaa; display: inline-block; line-height: 0; height: 98px; width: 98px;"><img alt="" field-key="account_logo_url" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/default_company_logo.png" width="98" /></div> </td> <td style="width: 641px; vertical-align: top; border-color: white;"> <p><span style="font-size:1.000em"><strong><field key="account_name" class="h-card" draggable="true">[Sua Empresa.Nome]</field></strong></span></p> <div style="display: block;"><span style="font-size:0.875em"><field key="account_phone" class="h-card" draggable="true">[Sua Empresa.Telefone]</field></span></div> <div style="display: block;"><span style="font-size:0.875em"><field key="account_email" class="h-card" draggable="true">[Sua Empresa.E-mail]</field></span></div> <div style="display: block;"><span style="font-size:0.875em"><field key="account_street_address" class="h-card" draggable="true">[Sua Empresa.Endere&ccedil;o]</field></span></div> <div style="display: block;"><span style="font-size:0.875em"><field key="account_website" class="h-card" draggable="true">[Sua Empresa.Website]</field></span></div> </td> </tr> </tbody> </table> <div style="height: 5px">&nbsp;</div> <div style="border-bottom: 2px solid #aaa; height: 2px;">&nbsp;</div> <div style="height: 5px">&nbsp;</div> <table border="0" cellpadding="0" cellspacing="0" style="width:758px"> <tbody> <tr> <td style="width: 482px; border-color: white;"> <p><span style="font-size:1.000em"><strong>Cliente:&nbsp;<field key="contact_name" class="h-card" draggable="true">[Cliente.Nome]</field></strong></span></p> <div style="display:block;"><field key="contact_cnpj" class="h-card" draggable="true">[Cliente.CPF / CNPJ]</field></div> <div style="display:block;"><field key="contact_street_address" class="h-card" draggable="true">[Cliente.Endere&ccedil;o]</field></div> <div style="display:block;"><field key="contact_neighborhood" class="h-card" draggable="true">[Cliente.Bairro]</field></div> <div style="display:block;"><field key="city_name" class="h-card" draggable="true">[Cliente.Cidade]</field>&nbsp;<field key="state_short" class="h-card" draggable="true">[Cliente.UF]</field></div> <div style="display:block;"><field key="contact_zipcode" format="00000-000" class="h-card" draggable="true">[Cliente.CEP]</field></div> </td> </tr> </tbody> </table> <div style="height: 5px">&nbsp;</div> <div style="border-bottom: 2px solid #aaa; height: 2px;">&nbsp;</div> <div style="height: 5px">&nbsp;</div> <div style="font-size:0.875em"> <p>&nbsp;</p> </div> <table section-code="0" section-name="Lista de produtos/servi�os" border="1" cellpadding="4" cellspacing="0" style="border-color:#aaa; width:758px"> <tbody> <tr style="background-color: rgb(238, 238, 238); border-color: #aaa"> <th style="border-top-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-left-color: rgb(170, 170, 170); border-right: 0px; break-inside: avoid; width: 43px;"><span style="font-size:0.875em">Item</span></th> <th style="border-top-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-right: 0px; border-left: 0px; break-inside: avoid; width: 123px; text-align: left;"><span style="font-size:0.875em">Grupo</span></th> <th style="border-top-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-right: 0px; border-left: 0px; break-inside: avoid; width: 140px; text-align: left;"><span style="font-size:0.875em">Produto/Servi&ccedil;o</span></th> <th style="border-top-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-right: 0px; border-left: 0px; break-inside: avoid; width: 61px; text-align: left;"><span style="font-size:0.875em">Qtd.</span></th> <th style="border-top-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-right: 0px; border-left: 0px; break-inside: avoid; width: 99px; text-align: left;"><span style="font-size:0.875em">Valor unit&aacute;rio</span></th> <th style="border-top-color: rgb(170, 170, 170); border-right-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-left: 0px; break-inside: avoid; width: 108px; text-align: left;"><span style="font-size:0.875em">Desconto</span></th> <th style="border-top-color: rgb(170, 170, 170); border-right-color: rgb(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-left: 0px; break-inside: avoid; width: 125px; text-align: right;"><span style="font-size:0.875em">Total</span></th> </tr> <tr multiple-field-key="order_section_products" class="h-card" draggable="true"> <td style="border-color: rgb(170, 170, 170); break-inside: avoid; width: 43px; text-align: center;"><span style="font-size:0.875em"><index field-key="order_section_products">1</index></span></td> <td style="border-color: rgb(170, 170, 170); break-inside: avoid; width: 122px;"><span style="font-size:0.875em"><field key="product_group_name" class="h-card" draggable="true">[Grupo do Produto.Nome]</field></span></td> <td style="border-color: rgb(170, 170, 170); break-inside: avoid; width: 139px;"><span style="font-size:0.875em"><field key="product_name" class="h-card" draggable="true">[Produto.Nome]</field></span></td> <td style="border-color: rgb(170, 170, 170); break-inside: avoid; width: 60px;"><span style="font-size:0.875em"><field key="order_product_quantity" class="h-card" draggable="true">[Produto.Quantidade]</field></span></td> <td style="border-color: rgb(170, 170, 170); break-inside: avoid; width: 98px;"><span style="font-size:0.875em"><field key="order_product_currency" class="h-card" draggable="true">[Produto.Moeda]</field>&nbsp;<field key="order_product_unit_price" format="n2" class="h-card" draggable="true">[Produto.Valor unit&aacute;rio]</field></span></td> <td style="border-color: rgb(170, 170, 170); break-inside: avoid; width: 107px;"><condition field-key="order_product_discount" operation=">" value="0"><span style="font-size:0.875em"><field key="order_product_discount" format="n1" class="h-card" draggable="true">[Produto.Desconto]</field>%</span></condition></td> <td style="border-color: rgb(170, 170, 170); break-inside: avoid; width: 125px; text-align: right;"><span style="font-size:0.875em"><field key="order_product_currency" class="h-card" draggable="true">[Produto.Moeda]</field>&nbsp;<field key="order_product_total" format="n2" class="h-card" draggable="true">[Produto.Total]</field></span></td> </tr> <condition field-key="order_discount" operation=">" value="0"> <tr style="background-color: rgb(238, 238, 238)"> <td colspan="6" rowspan="1" style="border-color: rgb(170, 170, 170); break-inside: avoid; width: 614px; text-align: right;"><span style="font-size:0.875em">Desconto:</span></td> <td style="border-color: rgb(170, 170, 170); break-inside: avoid; width: 125px; text-align: right;"><span style="font-size:0.875em"><field key="order_discount" format="n1" class="h-card" draggable="true">[Venda.Desconto]</field>%</span></td> </tr> </condition> <tr style="background-color: rgb(238, 238, 238)"> <td colspan="6" rowspan="1" style="border-color: rgb(170, 170, 170); break-inside: avoid; width: 614px; text-align: right;"><span style="font-size:0.875em"><strong>Total:</strong></span></td> <td style="border-color: rgb(170, 170, 170); break-inside: avoid; width: 125px; text-align: right;"><span style="font-size:0.875em"><strong><field key="order_currency" class="h-card" draggable="true">[Venda.Moeda]</field>&nbsp;<field key="order_amount" format="n2" class="h-card" draggable="true">[Venda.Valor]</field></strong></span></td> </tr> </tbody> </table> <p>&nbsp;</p> <p><span style="font-size:0.875em"><strong>Informa&ccedil;&otilde;es da venda</strong></span></p> <p><span style="font-size:0.875em"><field key="order_description" class="h-card" draggable="true">[Venda.Informa&ccedil;&otilde;es]</field></span></p> <p>&nbsp;</p> <div style="height: 5px">&nbsp;</div> <div style="border-bottom: 2px solid #aaa; height: 2px;">&nbsp;</div> <div style="height: 5px">&nbsp;</div> <p><span style="font-size:0.875em"><strong>Respons&aacute;vel</strong></span></p> <div style="font-size:0.875em"> <p><span><field key="user_name" class="h-card" draggable="true">[Respons&aacute;vel.Nome]</field></span></p> <p><span><field key="user_email" class="h-card" draggable="true">[Respons&aacute;vel.E-mail]</field></span></p> <p><span><field key="user_phone" class="h-card" draggable="true">[Respons&aacute;vel.Telefone]</field></span></p> </div>',
			10, 10, 5, 'True', 1173, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_FormularioVenda, @ID_FormularioBloco, @ID_FormularioProduto)



	--QUOTES FORMS: PADR�O
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1131, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1133, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1135, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1134, 1, 40)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1136, 1, 10, @ID_FormularioProduto)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco, 1128, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 7, 'quote_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1110, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1115, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 30, 0, 'Produtos', @ID_FormularioBloco)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1117, 1, 40)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1122, 1, 50)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1121, 1, 60)



	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@ID_ClientePloomes, 7, @ID_Formulario, '[MODELO 0] Padr�o', @ID_Usuario, 1, 1, 1117, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_Formulario, @ID_FormularioBloco, @ID_FormularioProduto)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Se��o 1',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><style type="text/css">p {font-family:Trebuchet MS,Helvetica,sans-serif}</style><div style="position:relative"><span><span><span><span><span><span><img alt="" height="1122.5" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/b9d0c0c75db243f09025d99f09d8fea6.png" width="800" /></span></span></span></span></span></span><div style="position:absolute; top:300px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:77px">&nbsp;</td><td style="width:619px"><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:23px"><span style="font-size:48px"><strong>PROPOSTA<br />COMERCIAL</strong></span></span></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><span style="font-size:23px"><span><span><span><span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></span></span></span></span></span></p><p style="text-align:center">&nbsp;</p></td><td style="width:97px">&nbsp;</td></tr></tbody></table></div></div>',
			'', 0, '', 0, 0, 0, 0, 10)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Se��o 2',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><style type="text/css">p {font-family:Trebuchet MS,Helvetica,sans-serif;}</style><p>&nbsp;</p><div style="height:5px">&nbsp;</div><div style="border-bottom:5px solid #331f4d; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="background-color:#331f4d; border-color:#ffffff; text-align:center; width:193px"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><span style="color:#ffffff"><span><span><field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></strong></span></span></td><td style="background-color:#eeeeee; border-color:#cccccc; text-align:right; width:446px"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999">Proposta n�&nbsp;<span><span><span><field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.C�digo]</field></span>&nbsp;&nbsp;</span></span></span></span></span></td></tr></tbody></table><p style="text-align:center">&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><strong><span style="font-size:14px"><span><span><span><span><span><span><span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></span></span></span></span></span></span></strong></span></span></p><p style="text-align:center">&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><span style="font-size:14px"><strong>A/C:</strong> <span><span><span><span><span><span><span><span><span><span><span><field key="contact_name" path-id="64">[Contato.Nome]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p field-path-id="64" multiple-field-key="contact_phones"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><span style="font-size:14px"><strong>Telefone:</strong> <span><span><span><span><span><span><span><span><span><span><span><field key="contact_phones" path-id="64">[Contato.Telefones]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><span style="font-size:14px"><strong>E-mail:</strong>&nbsp;<span><span><span><span><span><span><span><span><span><span><span><field key="contact_email" path-id="64">[Contato.E-mail]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p>&nbsp;</p><p>&nbsp;</p><p><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><span style="color:#331f4d">Seguem condi��es da proposta comercial:</span></strong></span></span></p><p>&nbsp;</p><table border="2" cellpadding="3" cellspacing="0" class="no-border" section-code="0" section-name="Produtos" section-no-products="" style="width:100%"><tbody><tr style="border-bottom:2px solid #331f4d !important; page-break-inside:avoid"><th style="width: 87px; background-color: rgb(238, 238, 238); border-color: rgb(238, 238, 238);"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px">Item</span></span></span></th><th style="width: 168px; background-color: rgb(238, 238, 238); border-color: rgb(238, 238, 238);"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px">Nome</span></span></span></th><th style="width: 98px; background-color: rgb(238, 238, 238); border-color: rgb(238, 238, 238);"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px">Quantidade</span></span></span></th><th style="width: 15%; background-color: rgb(238, 238, 238); border-color: rgb(238, 238, 238);"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px">Valor unit�rio</span></span></span></th><th style="width: 15%; background-color: rgb(238, 238, 238); border-color: rgb(238, 238, 238);"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px">Desconto</span></span></span></th><th style="width: 15%; background-color: rgb(238, 238, 238); border-color: rgb(238, 238, 238);"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px">Total</span></span></span></th></tr><tr multiple-field-key="quote_section_products" style="border-bottom:2px solid #eeeeee !important; page-break-inside:avoid"><td style="background-color:#ffffff; border-color:#bbbbbb; text-align:center; width:87px"><span style="font-size:12px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><index field-key="quote_section_products">[Produtos.�ndice]</index></span></span></span></span></td><td style="background-color:#ffffff; border-color:#bbbbbb; text-align:center; width:168px"><span style="font-size:12px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><field key="product_name" path-id="19">[Produtos / Produto.Nome]</field></span></span></span></span></td><td style="background-color:#ffffff; border-color:#bbbbbb; text-align:center; width:98px"><span style="font-size:12px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><field format="n0" formattable="number" key="quote_product_quantity" path-id="3">[Produtos.Quantidade]</field></span></span></span></span></td><td style="background-color:#ffffff; border-color:#bbbbbb; text-align:center"><span style="font-size:12px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">R$&nbsp; <span><span><field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unit�rio]</field></span></span></span></span></td><td style="background-color:#ffffff; border-color:#bbbbbb; text-align:center"><span style="font-size:12px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><field format="n1" key="quote_product_discount" path-id="3">[Produtos.Desconto]</field></span></span>%</span></span></td><td style="background-color:#ffffff; border-color:#bbbbbb; text-align:center"><span style="font-size:12px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span>R$&nbsp;</span></span> <span><span><field format="n2" formattable="number" key="quote_product_total" path-id="3">[Produtos.Total]</field></span></span></span></span></td></tr><tr style="page-break-inside:avoid"><td colspan="5" rowspan="1" style="background-color:#eeeeee; border-color:#bbbbbb; text-align:right; width:73px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><strong>Total&nbsp; &nbsp;</strong></span></span></td><td style="background-color:#eeeeee; border-color:#bbbbbb; text-align:center"><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:12px">R$<span style="font-size:14px"> </span><span><span><field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></span></span></span></span></p></td></tr></tbody></table><p><span style="color:#c0392b"><field format="n2" formattable="number" key="quote_amount" path-id="56" style="display: none;">[Proposta.Valor]</field></span></p><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" style="width:100%"><tbody><tr><td style="background-color:#eeeeee; border-bottom:2px solid #331f4d !important; border-color:#ffffff"><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px"><strong>&nbsp;Forma de Pagamento</strong></span></span></span></p></td></tr><tr><td style="background-color:#eeeeee; border-color:#ffffff"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><span><span><span><span><span><span><span><span><span><span><span>&nbsp;<span><field key="quote_payment_method" path-id="56">[Proposta.M�todo de pagamento]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></td></tr><tr><td style="background-color:#ffffff; border-color:#ffffff">&nbsp;</td></tr><tr><td style="background-color:#eeeeee; border-bottom:2px solid #331f4d !important; border-color:#ffffff"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#331f4d"><span style="font-size:14px"><strong>&nbsp;Prazo de Entrega</strong></span></span></span></td></tr><tr><td style="background-color:#eeeeee; border-color:#ffffff"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><span><span><span><span><span><span><span><span><span><span><span>&nbsp;<span><field key="quote_delivery_time" path-id="56">[Proposta.Prazo de entrega]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></td></tr></tbody></table><p>&nbsp;</p><div style="height:5px">&nbsp;</div><div style="border-bottom:4px solid #eeeeee; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div>',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="width:57px">&nbsp;</td><td style="width:179px">&nbsp;</td><td style="width:6px">&nbsp;</td><td style="width:541px">&nbsp;</td></tr><tr><td style="width:57px">&nbsp;</td><td style="width:179px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><img alt="" height="84" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/d4bbf421917a4eb09d4071aab7025555.png" width="156" /></span></span></span></td><td style="width:6px">&nbsp;</td><td style="width:541px"><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:#331f4d"><span><span><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></span></span></strong></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><strong>CNPJ:</strong> <span><span><field key="account_register" path-id="32">[Sua Empresa.CNPJ]</field></span></span></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><span><span><field key="account_phone" path-id="32">[Sua Empresa.Telefone]</field></span></span></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#999999"><span><span><field key="account_city" path-id="32">[Sua Empresa.Cidade]</field></span></span> - <span><span><field key="account_street_address_line2" path-id="32">[Sua Empresa.Complemento]</field></span></span></span></span></p></td></tr></tbody></table>',
			29, '', 0, 15, 0, 20, 20)



	--QUOTES FORMS: SERVI�O SIMPLES
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1133, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1134, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1136, 1, 10, @ID_FormularioProduto)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco, 1128, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 7, 'quote_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1110, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1119, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 30, 0, 'Servi�os', @ID_FormularioBloco)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1118, 1, 40)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1122, 1, 50)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1117, 1, 60)



	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@ID_ClientePloomes, 7, @ID_Formulario, '[MODELO 1] Servi�o Simples', @ID_Usuario, 0, 1, 1117, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_Formulario, @ID_FormularioBloco, @ID_FormularioProduto)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Capa',
			'<div style="background-image:url(''https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/21747d940bfe4d7bae311227975158ff.png''); background-size:cover; height:1122.5px; overflow:hidden; position:relative; text-align:center; width:100%"><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p><strong><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:48px"><span style="color:#26668c">PROPOSTA</span></span></span></strong></p><div style="border-bottom:3px solid #26668c; height:2px; margin-left:auto; margin-right:auto; width:350px">&nbsp;</div><p><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:48px"><span style="color:#26668c">COMERCIAL</span></span></span></p><div style="bottom:170px; left:0; position:absolute; right:0; text-align:center"><span><span><span><span><span><span><span><span><span><span><img alt="" height="52" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/d4bbf421917a4eb09d4071aab7025555.png" width="96" /></span></span></span></span></span></span></span></span></span></span></div></div>',
			'', 0, '', 0, 0, 0, 0, 10)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Corpo',
			'<style type="text/css">.border-gray, .border-gray td, .border-gray th {border: 1px solid #bfced1!important;}</style><style type="text/css">p {font-family:Verdana,Geneva,sans-serif;}</style><p><strong style="color:#26668c; font-size:20px"><span style="font-family:Verdana,Geneva,sans-serif">Proposta comercial</span></strong></p><p>&nbsp;</p><table border="0" cellpadding="0" cellspacing="1" class="border-gray" style="width:100%"><tbody><tr><td style="border-bottom:1px solid #bfced1; border-left:1px solid #ffffff !important; border-top:1px solid #ffffff !important; padding-bottom:10px; padding-right:10px; padding-top:10px; width:493px"><p><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:1.125em">Direcionada para:</span></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:1.125em"><strong><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></strong></span></span></p></td><td style="background-color:#f6f8f8; border-style:solid; border-width:1px; padding:10px; text-align:right; width:159px"><p><span style="font-size:12px"><span style="font-family:Verdana,Geneva,sans-serif">Data</span></span></p><p><span style="font-size:12px"><span style="font-family:Verdana,Geneva,sans-serif"><strong><span><span><span><span><field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span></strong></span></span></p></td></tr></tbody></table><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="border-color:#ffffff!important; width:346px"><p><span style="font-family:Verdana,Geneva,sans-serif"><strong>Validade da proposta</strong></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field format="d" formattable="date" key="quote_expiration_date" path-id="56">[Proposta.Data de validade]</field></span></span></span></span></span></p></td><td style="border-color:#ffffff!important; text-align:right; width:291px"><p><span style="font-family:Verdana,Geneva,sans-serif"><strong>N�mero da proposta</strong></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.C�digo]</field></span></span></span></span></span></p></td></tr></tbody></table><p>&nbsp;</p><table border="0" cellpadding="5" cellspacing="0" class="border-gray" section-code="0" section-name="Servi�os" section-no-products="" style="width:100%"><tbody><tr><th style="padding: 5px; width: 1px; text-align: left; background-color: rgb(38, 102, 140); border-top: 1px solid rgb(191, 206, 209);">&nbsp;</th><th colspan="3" rowspan="1" style="padding: 10px; width: 424px; text-align: left; background-color: rgb(246, 248, 248); border-top: 1px solid rgb(191, 206, 209);"><span style="font-family:Verdana,Geneva,sans-serif">Servi�o</span></th><th style="padding: 10px; width: 156px; border-top: 1px solid rgb(191, 206, 209); border-right: 1px solid rgb(191, 206, 209); background-color: rgb(246, 248, 248);"><span style="font-family:Verdana,Geneva,sans-serif">Valor</span></th></tr><tr multiple-field-key="quote_section_products" style="page-break-inside:avoid"><td colspan="4" style="border-style:solid; border-width:1px; padding:10px; text-align:left; width:179px"><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:1.000em"><span><span><span><span><index field-key="quote_section_products">[Produtos.�ndice]</index></span></span></span></span>.&nbsp;<span><span><span><span><field key="product_name" path-id="19">[Produtos / Produto.Nome]</field></span></span></span></span></span></span></td><td style="border-style:solid; border-width:1px; padding:10px; text-align:right; width:156px"><p style="text-align:center"><span style="font-family:Verdana,Geneva,sans-serif">R$&nbsp;<span><span><span><span><field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unit�rio]</field></span></span></span></span></span><span style="color:#c0392b"><span style="font-family:Verdana,Geneva,sans-serif"><field format="n2" formattable="number" key="quote_product_total" path-id="3" style="display: none;">[Produtos.Total]</field></span></span></p></td></tr><tr><td colspan="3" rowspan="1" style="border-bottom:1px solid #ffffff!important; border-left:1px solid #ffffff!important; padding:10px; text-align:center; width:290px"><p><span style="font-family:Verdana,Geneva,sans-serif">Forma de pagamento</span></p></td><td style="border-bottom:1px solid #bfced1; border-left:1px solid #bfced1; border-right:1px solid #bfced1; border-top-style:none; padding:10px; text-align:center; width:134px"><span style="font-family:Verdana,Geneva,sans-serif">Desconto</span></td><td style="border-bottom:1px solid #bfced1; border-left:1px solid #bfced1; border-right:1px solid #bfced1; border-top-style:none; padding:10px; text-align:center; width:156px"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field format="n1" key="quote_discount" path-id="56">[Proposta.Desconto]</field></span></span></span></span>&nbsp;%</span></td></tr><tr><td colspan="3" rowspan="1" style="border-bottom:1px solid #ffffff!important; border-left:1px solid #ffffff!important; padding:10px; text-align:center; width:290px"><span style="font-family:Verdana,Geneva,sans-serif"><strong><span><span><span><span><field key="quote_payment_method" path-id="56">[Proposta.M�todo de pagamento]</field></span></span></span></span></strong></span></td><td style="background-color:#f6f8f8; border-bottom:1px solid #bfced1; border-left:1px solid #bfced1; border-right:1px solid #bfced1; padding:10px; text-align:center; width:134px"><span style="font-family:Verdana,Geneva,sans-serif"><strong>Total</strong></span></td><td style="background-color:#f6f8f8; border-bottom:1px solid #bfced1; border-right:1px solid #bfced1; padding:10px; text-align:center; width:156px"><span style="font-family:Verdana,Geneva,sans-serif"><strong>R$&nbsp;<span><span><span><span><field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></span></span></span></span></strong></span></td></tr></tbody></table><p>&nbsp;</p><p><strong>R$&nbsp;<field format="n2" formattable="number" key="quote_amount" path-id="56">[Proposta.Valor]</field></strong></p><p>&nbsp;</p><table border="0" cellpadding="10" cellspacing="0" class="border-gray" style="width:100%"><tbody><tr><th style="width: 330px; text-align: left; background-color: rgb(246, 248, 248); border-left: 10px solid rgb(38, 102, 140); border-bottom: 1px solid rgb(191, 206, 209); border-top: 1px solid rgb(191, 206, 209);"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></span></span></span></span></th><th style="width: 312px; text-align: left; background-color: rgb(246, 248, 248); border-width: 1px 1px 1px 10px; border-style: solid; border-color: rgb(191, 206, 209) rgb(191, 206, 209) rgb(191, 206, 209) rgb(38, 102, 140);"><span style="font-family:Verdana,Geneva,sans-serif">Respons�vel</span></th></tr><tr><td style="border-color:#ffffff !important; text-align:left; width:330px"><p><span style="font-family:Verdana,Geneva,sans-serif"><strong><span><span><span><span><field key="account_website" path-id="32">[Sua Empresa.Site]</field></span></span></span></span></strong></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field key="account_street_address" path-id="32">[Sua Empresa.Endere�o]</field></span></span></span></span></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field key="account_phone" path-id="32">[Sua Empresa.Telefone]</field></span></span></span></span></span></p></td><td style="border-color:#ffffff !important; text-align:left; width:312px"><p><span style="font-family:Verdana,Geneva,sans-serif"><strong><span><span><span><span><field key="user_name" path-id="80">[Proposta / Usu�rio.Nome]</field></span></span></span></span></strong></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field key="user_email" path-id="80">[Proposta / Usu�rio.E-mail]</field></span></span></span></span></span></p><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field key="user_phone" path-id="80">[Proposta / Usu�rio.Telefone]</field></span></span></span></span></span></p></td></tr></tbody></table>',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><table border="1" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="text-align:right; width:90px">&nbsp;</td><td style="text-align:right; width:643px"><p>&nbsp;</p><p>&nbsp;</p></td><td style="width:57px">&nbsp;</td></tr><tr><td style="text-align:right; width:90px">&nbsp;</td><td style="text-align:right; width:643px"><span><span><span><span><img alt="" height="54" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/d4bbf421917a4eb09d4071aab7025555.png" width="100" /></span></span></span></span></td><td style="width:57px">&nbsp;</td></tr></tbody></table>',
			27, '', 0, 15, 5, 20, 20)



	--QUOTES FORMS: PROJETOS
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1131, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1133, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1135, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1134, 1, 40)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1136, 1, 10, @ID_FormularioProduto)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco, 1128, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 7, 'quote_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1110, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1368, 1, 20, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1119, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1365, 1, 40, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 50, 0, 'Produtos', @ID_FormularioBloco)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1117, 1, 60)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1122, 1, 70)



	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@ID_ClientePloomes, 7, @ID_Formulario, '[MODELO 2] Projeto', @ID_Usuario, 0, 1, 1117, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_Formulario, @ID_FormularioBloco, @ID_FormularioProduto)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Se��o 1',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><style type="text/css">p {font-family:Trebuchet MS,Helvetica,sans-serif}</style><div style="position:relative"><span><span><span><span><span><span><span><img alt="" height="1122.5" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/872e5d57f8da4a5c9f662d2ddae345d5.png" width="800" /></span></span></span></span></span></span></span><div style="position:absolute; top:136px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:60px">&nbsp;</td><td style="width:633px"><p><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><span><span><span><img alt="" height="92" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/dd92ae76c50c49808622e05a3c795eb3.png" style="float:right" width="170" /></span></span></span></span></span></span></span></span></p></td><td style="width:97px">&nbsp;</td></tr></tbody></table></div><div style="position:absolute; top:580px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:60px">&nbsp;</td><td style="width:645px"><p style="text-align:right"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span><span><span><span><span><span><field key="deal_title" path-id="24">[Neg�cio.T�tulo]</field></span></span></span></span></span></span></span></span></span></p><p style="text-align:right"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><span style="color:#ffffff"><span><span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></span></strong></span></span></p><p>&nbsp;</p><div style="height:5px">&nbsp;</div><div style="border-bottom:2px solid #aaaaaa; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div><p>&nbsp;</p><p style="text-align:right"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span><span><span><span><span><span><field key="account_city" path-id="32">[Sua Empresa.Cidade]</field></span></span></span></span></span></span>,&nbsp;<span><span><span><span><span><field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span></span><br /><span><span><span><span><span><span><field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56" style="display: none;">[Proposta.Data]</field></span></span></span></span></span></span></span></span></span></p><p style="text-align:right">&nbsp;</p><p style="text-align:right"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span><span><span><span><span><span><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></span></span></span></span></span></span></span></span></p><p style="text-align:right"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><strong><span><span><span><span><span><span><field key="user_name" path-id="80">[Proposta / Usu�rio.Nome]</field></span></span></span></span></span></span></strong></span></span></span></p><p style="text-align:right"><span style="font-size:16px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span><span><span><span><span><span><field key="user_email" path-id="80">[Proposta / Usu�rio.E-mail]</field></span></span></span></span></span></span></span></span></span></p><p style="text-align:right">&nbsp;</p><p style="text-align:right">&nbsp;</p><p style="text-align:right">&nbsp;</p><p style="margin-left:196.35pt; text-align:right"><span style="color:#aaaaaa"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>Essa proposta � confidencial e endere�ada<br />exclusivamente para&nbsp; <span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span>.<br />N�o deve ser divulgada, utilizada ou duplicada,<br />em parte ou no todo, para qualquer outra finalidade<br />al�m da avalia��o do neg�cio</em></span></span></span></p></td><td style="width:89px">&nbsp;</td></tr></tbody></table></div></div>',
			'', 0, '', 0, 0, 0, 0, 10)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Se��o 2',
			'<style type="text/css">p {font-family:Trebuchet MS,Helvetica,sans-serif}</style><style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="background-color:#333333"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span style="font-size:20px"><strong>&nbsp;|&nbsp;<span><span><span><span><span><span><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></span></span></span></span></span></strong></span></span></span></td></tr></tbody></table><p>&nbsp;</p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:1.125em"><strong>SOBRE N�S - ATUANDO DESDE 1996</strong></span></span></p><p>&nbsp;</p><p style="text-align:justify"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:11.375px; line-height:18.2px"><em>Aqui podemos contar um pouco sobre a hist�ria de nossa empresa. Temos diversos anos de experi�ncia e excel�ncia. Nossos clientes atestam a qualidade do servi�o que prestamos.</em></span></span></p><p>&nbsp;</p><p style="text-align:justify"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:11.375px; line-height:18.2px"><em>Buscamos&nbsp;sempre entender a necessidade do cliente afundo antes de partirmos para qualquer tipo de solu��o. Aprendizado corre em nossas veias e colocamos o cliente sempre em primeiro lugar.&nbsp;</em></span></span></p><p>&nbsp;</p><p style="text-align:justify">&nbsp;</p><p style="text-align:justify"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><span><span><img alt="" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/893121A5CEA3/Imagem/80095ac51e304c7694ec98f204ebf35f.jpg" width="646" /></span></span></span></span></span></span></span></p><p style="text-align:justify">&nbsp;</p><p style="text-align:justify"><span style="font-size:14px"><strong><span style="font-family:Trebuchet MS,Helvetica,sans-serif">Conhe�a alguns de nossos Clientes:</span></strong></span></p><p style="text-align:justify">&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:644px"><tbody><tr><td style="width:22px">&nbsp;</td><td style="text-align:center; width:127px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>Tech Software</em></span></span></td><td style="text-align:center; width:165px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>Rio Engenharia</em></span></span></td></tr><tr><td style="width:22px">&nbsp;</td><td style="text-align:center; width:127px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>JSM Construtora</em></span></span></td><td style="text-align:center; width:165px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>Inovatti Pisos</em></span></span></td></tr><tr><td style="width:22px">&nbsp;</td><td style="text-align:center; width:127px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>Nativa Group</em></span></span></td><td style="text-align:center; width:165px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>Hello Ingredientes</em></span></span></td></tr><tr><td style="width:22px">&nbsp;</td><td style="text-align:center; width:127px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>HSO Empreendimentos</em></span></span></td><td style="text-align:center; width:165px"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><em>RollTech</em></span></span></td></tr></tbody></table><p>&nbsp;</p><p style="text-align:center">&nbsp;</p><p>&nbsp;</p><table border="0" cellpadding="2" cellspacing="0" class="no-border" style="width:644px"><tbody><tr><td style="border-color:#ffffff; width:552px"><p><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>Descri��o do projeto</strong></span></span></p><p><span style="font-size:12px"><span><span><span><field key="quote_description" path-id="56">[Proposta.Descri��o]</field></span></span></span></span></p></td></tr></tbody></table>',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><table border="1" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="text-align:right; width:90px">&nbsp;</td><td style="text-align:right; width:645px">&nbsp;</td><td style="width:55px">&nbsp;</td></tr><tr><td style="text-align:right; width:90px">&nbsp;</td><td style="text-align:right; width:645px"><span><span><span><img alt="" height="60" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/dd92ae76c50c49808622e05a3c795eb3.png" width="111" /></span></span></span></td><td style="width:55px">&nbsp;</td></tr></tbody></table><p>&nbsp;</p><div style="height:5px">&nbsp;</div><div style="border-bottom:2px solid #aaaaaa; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div>',
			32,
			'<div style="height:5px">&nbsp;</div><div style="border-bottom:2px solid #aaaaaa; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div><p style="text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><field key="account_street_address" path-id="32">[Sua Empresa.Endere�o]</field>&nbsp;-&nbsp;<field key="account_city" path-id="32">[Sua Empresa.Cidade]</field></span></p><p style="text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><field key="account_website" path-id="32">[Sua Empresa.Site]</field></strong>&nbsp;</span></p><p style="text-align:center">&nbsp;</p><p style="text-align:center">&nbsp;</p>',
			24, 15, 5, 20, 20)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Se��o 3',
			'<style type="text/css">p {font-family:Trebuchet MS,Helvetica,sans-serif}</style><style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="background-color:#333333"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span style="font-size:20px"><strong>&nbsp;| PROPOSTA COMERCIAL</strong></span></span></span></td></tr></tbody></table><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif">&nbsp;</span></p><table border="0" cellpadding="1" cellspacing="1" style="width:100%"><tbody><tr><td style="border-color:#ffffff; vertical-align:top"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><span style="font-size:1.000em">Cliente:</span></strong>&nbsp;<span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></td><td style="border-color:#ffffff; text-align:right; width:390px"><p><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:1.000em"><strong>N�mero da proposta</strong>:</span>&nbsp;#<span><span><span><span><field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.C�digo]</field></span></span></span></span></span></span></p><p><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:1.000em">Data:</span>&nbsp;<span><span><span><span><field format="d" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span><br /><span style="font-size:0.875em"><em><strong>Validade:</strong><em>&nbsp;</em><span><span><span><span><field format="d" formattable="date" key="quote_expiration_date" path-id="56">[Proposta.Data de validade]</field></span></span></span></span></em></span></span></span></p></td></tr></tbody></table><p>&nbsp;</p><p><strong><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:1.000em">OBSERVA��ES</span></span></span></strong></p><p>&nbsp;</p><p><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><field key="quote_notes" path-id="56">[Proposta.Observa��es]</field></span></span></span></span></span></span></p><p>&nbsp;</p><p>&nbsp;</p><table border="0" cellpadding="2" cellspacing="0" class="no-border" section-code="0" section-name="Produtos" style="width:100%"><tbody><tr style="background-color:#849daa; border-bottom:2px solid #333333 !important; border-style:none; color:white"><td style="background-color:#ffffff; border-style:none; padding:10px; text-align:center; width:199px"><span style="color:#333333"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">&nbsp; <strong>Projeto</strong></span></span></span></td><td style="background-color:#ffffff; border-style:none; padding:10px; text-align:center; width:43px"><span style="color:#333333"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>Qtd.</strong></span></span></span></td><td style="background-color:#ffffff; border-style:none; padding:10px; text-align:center; width:135px"><span style="color:#333333"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>Valor unit�rio (R$)</strong></span></span></span></td><td style="background-color:#ffffff; border-style:none; padding:10px; text-align:center; width:92px"><span style="color:#333333"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>Desconto (%)</strong></span></span></span></td><td style="background-color:#ffffff; border-style:none; padding:10px; text-align:center; width:122px"><span style="color:#333333"><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>Total (R$)</strong></span></span></span></td></tr><tr multiple-field-key="quote_section_products" style="border-bottom:2px solid #eeeeee !important; page-break-inside:avoid"><td style="border-style:none; padding:10px; text-align:center; width:199px"><span style="font-size:12px"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><field key="product_name" path-id="19">[Produtos / Produto.Nome]</field></span></span></span></span></span></span></span></td><td style="border-style:none; padding:10px; text-align:center; width:43px"><span style="font-size:12px"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><field format="n0" formattable="number" key="quote_product_quantity" path-id="3">[Produtos.Quantidade]</field></span></span></span></span></span></span></span></td><td style="border-style:none; padding:10px; text-align:center; width:135px"><span style="font-size:12px"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unit�rio]</field></span></span></span></span></span></span></span></td><td style="border-style:none; padding:10px; text-align:center; width:92px"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:0.875em"><span style="font-size:12px"><span><span><span><span><field format="n1" key="quote_product_discount" path-id="3">[Produtos.Desconto]</field></span></span></span></span></span></span></span></span></td><td style="border-style:none; padding:10px; text-align:center; width:122px"><span style="font-size:12px"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><field format="n2" formattable="number" key="quote_product_total" path-id="3">[Produtos.Total]</field></span></span></span></span></span></span></span></td></tr><tr><td colspan="3" rowspan="1" style="border-style:none; padding:10px; text-align:right; width:412px">&nbsp;</td><td style="border-style:none; color:white; padding:10px; text-align:center; width:92px"><strong><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">TOTAL (R$)</span></span></strong></td><td style="border-style:none; color:white; padding:10px; text-align:center; width:122px"><span style="color:#000000"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></span></span></span></span></span></span></td></tr></tbody></table><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:#000000">Valor Final</span></strong></span></span></p><p><strong>R$&nbsp;<field format="n2" formattable="number" key="quote_amount" path-id="56">[Proposta.Valor]</field></strong></p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><strong><span style="color:#000000">Forma de pagamento</span></strong></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#000000"><span><span><span><field key="quote_payment_method" path-id="56">[Proposta.M�todo de pagamento]</field></span></span></span></span></span></p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><span style="color:#000000"><span><span><span><field key="user_name" path-id="80">[Proposta / Usu�rio.Nome]</field></span></span></span></span></strong></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><field key="user_email" path-id="80">[Proposta / Usu�rio.E-mail]</field></span></span></span></span></p>',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><table border="1" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="text-align:right; width:90px">&nbsp;</td><td style="text-align:right; width:645px">&nbsp;</td><td style="width:55px">&nbsp;</td></tr><tr><td style="text-align:right; width:90px">&nbsp;</td><td style="text-align:right; width:645px"><span><span><span><span><img alt="" height="60" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/dd92ae76c50c49808622e05a3c795eb3.png" width="111" /></span></span></span></span></td><td style="width:55px">&nbsp;</td></tr></tbody></table><p>&nbsp;</p><div style="height:5px">&nbsp;</div><div style="border-bottom:2px solid #aaaaaa; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div>',
			32,
			'<div style="height:5px">&nbsp;</div><div style="border-bottom:2px solid #aaaaaa; height:2px">&nbsp;</div><div style="height:5px">&nbsp;</div><p style="text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><field key="account_street_address" path-id="32">[Sua Empresa.Endere�o]</field></span>&nbsp;-&nbsp;<span><field key="account_city" path-id="32">[Sua Empresa.Cidade]</field></span></span></p><p style="text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong><span><field key="account_website" path-id="32">[Sua Empresa.Site]</field></span></strong>&nbsp;</span></p><p style="text-align:center">&nbsp;</p><p style="text-align:center">&nbsp;</p>',
			24, 15, 5, 20, 30)



	--QUOTES FORMS: PRODUTOS
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1131, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1133, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1135, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1134, 1, 40)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1136, 1, 10, @ID_FormularioProduto)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco, 1128, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 7, 'quote_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1110, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1115, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 30, 0, 'Produtos', @ID_FormularioBloco)

		INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1366, 1, 40)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1365, 1, 50, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1367, 1, 60)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1117, 1, 70)



	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@ID_ClientePloomes, 7, @ID_Formulario, '[MODELO 3] Produtos', @ID_Usuario, 0, 1, 1117, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_Formulario, @ID_FormularioBloco, @ID_FormularioProduto)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Se��o 1',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><div style="position:relative"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="1122.5" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/c95a1b9ef3a9449eb16413a083a37b90.png" style="float:left" width="800" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span><div style="position:absolute; top:460px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:93px">&nbsp;</td><td style="width:635px"><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><strong><span style="font-size:36px">Proposta&nbsp;</span></strong></span></span><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span style="font-size:36px">Comercial</span></span></span></p><p style="text-align:center">&nbsp;</p><p style="text-align:center">&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span style="font-size:22px"><strong><span><span><span><span><span><span><span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></span></span></span></span></span></strong></span></span></span></p><p><span style="font-size:14px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#ffffff"><span><span><span><span><span><span><span><span><span><span><field format="d" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></p></td><td style="width:60px">&nbsp;</td></tr></tbody></table></div><div style="position:absolute; top:940px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:93px">&nbsp;</td><td style="width:610px"><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="76" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/845b2c0a288943909161b1d0b0b3e07b.png" style="float:right" width="140" /></span></span></span></span></span></span></span></span></span></span></span></span></span></td><td style="width:87px">&nbsp;</td></tr></tbody></table></div></div>',
			'', 0, '', 0, 0, 0, 0, 10)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Se��o 2',
			'<style type="text/css">.imagem150 img{width:150px !important; height: auto!important}</style><style type="text/css">p {font-family:Trebuchet MS,Helvetica,sans-serif}</style><style type="text/css">.border-white, .border-white td, .border-white th {border:2px solid #eeeeee!important;}</style><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><style type="text/css">.imagem120 img{width:120px !important; height: auto!important}</style></span><p style="text-align:right"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><field key="account_city" path-id="32">[Sua Empresa.Cidade]</field>,&nbsp;<field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></p><p style="text-align:right"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">Proposta #&nbsp;<field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.C�digo]</field></span></p><p>&nbsp;</p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="color:#e74c3c"><span style="font-size:36px"><strong>Proposta</strong><br />Comercial</span></span></span></p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">�</span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">A/C:&nbsp;<field key="contact_name" path-id="64">[Contato.Nome]</field></span></span></p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">Prezado&nbsp;<strong><field key="contact_name" path-id="64">[Contato.Nome]</field></strong>. </span></span></p><p style="text-align:justify"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">Agradecemos a oportunidade em contar com a <field key="account_name" path-id="32">[Sua Empresa.Nome]</field>. Conforme solicita��o, apresentamos o or�amento abaixo discriminado:</span></span></p><p>&nbsp;</p><table border="1" cellpadding="3" cellspacing="0" class="border-white" section-code="0" section-name="Produtos" section-no-products="" style="border:2px solid #eeeeee !important; width:100%"><tbody><tr style="border-bottom:3px solid #e74c3c!important; page-break-inside:avoid"><th style="width: 189px;"><span style="color:#e74c3c"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>PRODUTO</strong></span></span></th><th style="width: 170px;"><span style="color:#e74c3c"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>QTD.</strong></span></span></th><th style="width: 89px;"><span style="color:#e74c3c"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>VLR UN.</strong></span></span></th><th style="width: 15%;"><span style="color:#e74c3c"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>DESCONTO</strong></span></span></th><th style="width: 15%;"><span style="color:#e74c3c"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>TOTAL</strong></span></span></th></tr><tr multiple-field-key="quote_section_products" style="border-bottom:3px solid #eeeeee!important; page-break-inside:avoid"><td style="text-align:center; width:189px"><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><index field-key="quote_section_products">[Produtos.�ndice]</index>.&nbsp;<field key="product_name" path-id="19">[Produtos / Produto.Nome]</field></span></p><div class="imagem120"><div condition-field-key="product_image_url" condition-operation="ne" condition-value="0"><img alt="" field-key="product_image_url" field-path-id="19" height="85" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/default_company_logo.png" width="85" /></div></div></td><td style="text-align:center; width:170px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><field format="n0" formattable="number" key="quote_product_quantity" path-id="3">[Produtos.Quantidade]</field></span></td><td style="text-align:center; width:89px"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">R$&nbsp;<field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unit�rio]</field></span></td><td style="text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><field format="n1" key="quote_product_discount" path-id="3">[Produtos.Desconto]</field>&nbsp;%</span></td><td style="text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">R$&nbsp;<field format="n2" formattable="number" key="quote_product_total" path-id="3">[Produtos.Total]</field></span></td></tr><tr><td colspan="4" style="background-color:#eeeeee; text-align:right"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>FRETE&nbsp;</strong></span></td><td style="background-color:#eeeeee; text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif">R$&nbsp;&nbsp;<field format="n2" formattable="number" key="quote_freight_cost" path-id="56">[Proposta.Valor do frete]</field></span></td></tr><tr style="border-top:3px solid #ffffff!important; page-break-inside:avoid"><td colspan="4" style="background-color:#eeeeee; text-align:right"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>TOTAL&nbsp;&nbsp;</strong></span></td><td style="background-color:#eeeeee; text-align:center"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></span></td></tr></tbody></table><p>&nbsp;</p><p><span style="color:null"><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:18px"><strong>| GENERALIDADES</strong></span></span></span></p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><field key="quote_notes" path-id="56">[Proposta.Observa��es]</field></span></span></p><ul><li><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">Produtos de acordo com o estoque,&nbsp;os mesmos est�o sujeitos a confirma��o pr�via.</span></span></li></ul><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><strong>Frete:&nbsp;</strong><field key="quote_freight_modal" path-id="56">[Proposta.Modalidade de frete]</field></span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><strong>Valor: R$&nbsp;<field format="n2" formattable="number" key="quote_amount" path-id="56">[Proposta.Valor]</field></strong></span></p><p>&nbsp;</p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">Estamos � disposi��o para os esclarecimentos que se fizerem necess�rios.</span></span></p><p>&nbsp;</p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px">Atenciosamente,</span></span></p><div class="imagem150"><p>&nbsp;</p><div condition-field-key="user_avatar_url" condition-operation="ne" condition-value="0"><img alt="" field-key="user_avatar_url" field-path-id="80" height="113" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/default_company_logo.png" width="113" /></div><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><strong><field key="user_name" path-id="80">[Proposta / Usu�rio.Nome]</field> </strong></span></span></p></div><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><field key="role_name" path-id="20">[Proposta / Usu�rio / Cargo.Nome]</field> </span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><field key="account_name" path-id="32">[Sua Empresa.Nome]</field> </span></span></p><p><span style="font-family:Trebuchet MS,Helvetica,sans-serif"><span style="font-size:14px"><field key="user_email" path-id="80">[Proposta / Usu�rio.E-mail]</field></span></span></p>',
			'',
			0,
			'<span><span><span><span><img alt="" height="130" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/60c35864f22d4eb793e6bd078e40d81b.png" width="800" /></span></span></span></span>',
			35, 20, 20, 20, 20)



	--QUOTES FORMS: IND�STRIA
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)
		
	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1133, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1131, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1135, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1134, 1, 40)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1136, 1, 10, @ID_FormularioProduto)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco, 1128, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 7, 'quote_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1110, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 20, 0, 'Produtos', @ID_FormularioBloco)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1367, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1366, 1, 40)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1117, 1, 50)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1122, 1, 60)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1121, 1, 70)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido)
		VALUES (@ID_Formulario, 1365, 1, 80, 1)



	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@ID_ClientePloomes, 7, @ID_Formulario, '[MODELO 4] Ind�stria', @ID_Usuario, 0, 1, 1117, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_Formulario, @ID_FormularioBloco, @ID_FormularioProduto)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Capa',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}.border-td {border: none !important;}.border-td td, .border-td th {border: 1px solid;}tr {page-break-inside: avoid}</style><div style="position:relative"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="1122.5" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/05c7683ac8684b01acbf0c988c57e9ef.png" width="800" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span><div style="position:absolute; top:620px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:92px">&nbsp;</td><td style="width:483px"><p><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="68" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/845b2c0a288943909161b1d0b0b3e07b.png" width="126" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p><span style="color:#ffffff"><span style="font-size:22px"><span style="font-family:Verdana,Geneva,sans-serif"><strong><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></strong></span></span></span></p><p><span style="color:#ffffff"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field format="d" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p>&nbsp;</p></td><td style="width:214px">&nbsp;</td></tr></tbody></table></div></div>',
			'', 0, '', 0, 0, 0, 0, 10)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Corpo',
			'<style type="text/css">.border-blue, .border-blue td, .border-blue th {border: 2px solid #016aa3!important;}</style><style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}.border-td {border: none !important;}.border-td td, .border-td th {border: 1px solid;}tr {page-break-inside: avoid}</style><style type="text/css">p {font-family:Verdana,Geneva,sans-serif;}</style><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="width:395px"><p>&nbsp;</p></td><td style="text-align:right; vertical-align:top; width:320px"><p><span style="color:#016aa3"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field key="account_city" path-id="32">[Sua Empresa.Cidade]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span><span style="color:#016aa3">,<span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span>&nbsp;<span><field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p></td></tr></tbody></table><p style="text-align:center">&nbsp;</p><p style="text-align:center"><span style="font-size:16px"><span style="color:#016aa3"><strong>OR�AMENTO #<span><span><span><span><span><span><field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.C�digo]</field></span></span></span></span></span></span></strong></span></span></p><p style="text-align:center">&nbsp;</p><p style="text-align:center">&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="width:269px"><p><span style="font-size:12px"><strong>Raz�o Social</strong></span></p></td><td><p><span style="font-size:12px"><strong>CNPJ</strong></span></p></td><td><p><span style="font-size:12px"><strong>Cidade - UF</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td style="width:269px"><p><span style="font-size:12px"><field key="contact_legal_name" path-id="1">[Cliente.Raz�o social]</field></span></p></td><td style="width:163px"><p><span style="font-size:12px"><field key="contact_cnpj" path-id="1">[Cliente.CNPJ]</field></span></p></td><td style="width:280px"><p><span style="font-size:12px"><field key="city_name" path-id="60">[Cliente / Cidade.Nome]</field>&nbsp;-&nbsp;<field key="state_short" path-id="18">[Cliente / Cidade / Estado.Sigla]</field></span></p></td></tr><tr><td colspan="2" rowspan="1"><p><span style="font-size:12px"><strong>Endere�o</strong></span></p></td><td><p><span style="font-size:12px"><strong>CEP</strong></span></p></td></tr><tr><td colspan="2" rowspan="1" style="width:278px"><p><span style="font-size:12px"><field key="contact_street_address" path-id="1">[Cliente.Endere�o]</field></span></p></td><td style="width:280px"><p><span style="font-size:12px"><field format="00000-000" formattable="number" key="contact_zipcode" path-id="1">[Cliente.CEP]</field></span></p></td></tr><tr style="border-top:2px solid #016aa3 !important"><td><p><span style="font-size:12px"><strong>Contato</strong></span></p></td><td><p><span style="font-size:12px"><strong>Telefone</strong></span></p></td><td><p><span style="font-size:12px"><strong>E-mail</strong></span></p></td></tr><tr><td style="width:269px"><p><span style="font-size:12px"><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></p></td><td style="width:163px"><p field-path-id="1" multiple-field-key="contact_phones"><span style="font-size:12px"><field key="contact_phones" path-id="1">[Cliente.Telefones]</field></span></p></td><td style="width:280px"><p><span style="font-size:12px"><field key="contact_email" path-id="1">[Cliente.E-mail]</field></span></p></td></tr><tr style="border-top:2px solid #016aa3 !important"><td colspan="2" rowspan="1" style="width:269px"><p><span style="font-size:12px"><strong>Nome Fantasia</strong></span></p></td><td style="width:280px"><p><span style="font-size:12px"><strong>Ramo de Atividade</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td colspan="2" rowspan="1" style="width:269px"><p><span style="font-size:12px"><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></p><p>&nbsp;</p></td><td style="width:280px"><p><span style="font-size:12px"><field key="contact_line_of_business_name" path-id="16">[Cliente / Segmento do cliente.Nome]</field></span></p></td></tr></tbody></table><p>&nbsp;</p><p>&nbsp;</p><table border="1" cellpadding="1" cellspacing="1" class="border-blue" section-code="0" section-name="Produto" section-no-products="" style="width:100%"><tbody multiple-field-key="quote_section_products"><tr><td style="background-color:#99ccff; width:135px"><p style="text-align:center"><span style="font-size:12px"><strong>C�digo</strong></span></p></td><td style="background-color:#99ccff; width:201px"><p style="text-align:center"><span style="font-size:12px"><strong>Produto</strong></span></p></td><td style="background-color:#99ccff; width:172px"><p style="text-align:center"><span style="font-size:12px"><strong>Modelo&nbsp;</strong></span></p></td><td style="background-color:#99ccff; width:162px"><p style="text-align:center"><span style="font-size:12px"><strong>NCM</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td style="width:135px"><p style="text-align:center"><span style="font-size:12px"><field key="product_code" path-id="19">[Produtos / Produto.C�digo]</field></span></p></td><td style="width:201px"><p style="text-align:center"><span style="font-size:12px"><field key="product_name" path-id="19">[Produtos / Produto.Nome]</field></span></p></td><td style="width:172px"><p style="text-align:center"><span style="font-size:12px">DVHU-7</span></p></td><td style="width:162px"><p style="text-align:center">100610</p></td></tr><tr><td colspan="2" rowspan="1" style="width:135px"><p style="text-align:center"><span style="font-size:12px"><strong>Peso</strong></span></p></td><td colspan="2" rowspan="1" style="width:170px"><p style="text-align:center"><span style="font-size:12px"><strong>Dimens�es (CxLxA) mm</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td colspan="2" rowspan="1" style="width:135px"><p style="text-align:center"><span style="font-size:12px">120 kg</span></p></td><td colspan="2" rowspan="1" style="width:170px"><p style="text-align:center"><span style="font-size:12px">2m&nbsp;x&nbsp;3m&nbsp;x&nbsp;0,5m</span></p></td></tr><tr><td style="width:135px"><p style="text-align:center"><span style="font-size:12px"><strong>ST</strong></span></p></td><td style="width:201px"><p style="text-align:center"><span style="font-size:12px"><strong>IVA</strong></span></p></td><td style="width:172px"><p style="text-align:center"><span style="font-size:12px"><strong>ICMS</strong></span></p></td><td style="width:162px"><p style="text-align:center"><span style="font-size:12px"><strong>IPI</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td style="width:135px"><p style="text-align:center"><span style="font-size:12px">1%</span></p></td><td style="width:201px"><p style="text-align:center"><span style="font-size:12px">2%</span></p></td><td style="width:172px"><p style="text-align:center"><span style="font-size:12px">18%</span></p></td><td style="width:162px"><p style="text-align:center"><span style="font-size:12px">3%</span></p></td></tr><tr><td style="width:135px"><p style="text-align:center"><span style="font-size:12px"><strong>Valor Unit�rio</strong></span></p></td><td style="width:201px"><p style="text-align:center"><span style="font-size:12px"><strong>Quantidade</strong></span></p></td><td style="width:172px"><p style="text-align:center"><span style="font-size:12px"><strong>Desconto</strong></span></p></td><td style="width:162px"><p style="text-align:center"><span style="font-size:12px"><strong>Valor Total</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td style="width:135px"><p style="text-align:center"><span style="font-size:12px">&nbsp;R$&nbsp;<field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unit�rio]</field></span></p></td><td style="width:201px"><p style="text-align:center"><span style="font-size:12px"><field format="n0" formattable="number" key="quote_product_quantity" path-id="3">[Produtos.Quantidade]</field></span></p></td><td style="width:172px"><p style="text-align:center"><span style="font-size:12px"><field format="n1" key="quote_product_discount" path-id="3">[Produtos.Desconto]</field> %</span></p></td><td style="width:162px"><p style="text-align:center"><span style="font-size:12px">&nbsp;<strong>R$&nbsp;<field format="n2" formattable="number" key="quote_product_total" path-id="3">[Produtos.Total]</field></strong></span></p></td></tr><tr class="no-border" style="border-left:2px solid #ffffff !important; border-right:2px solid #ffffff !important; line-height:0.5"><th colspan="4" style="width: 135px">&nbsp;</th></tr></tbody><tbody><tr><td colspan="4" style="background-color:#016aa3; width:135px"><p style="text-align:center"><strong><span style="color:#ffffff">Valor Total:&nbsp;R$&nbsp;<span><field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></span></span></strong></p></td></tr></tbody></table><p>&nbsp;</p><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="text-align:center; width:126px"><p style="text-align:left"><span style="font-size:12px"><strong>Frete</strong></span></p></td><td style="text-align:center; width:152px"><p style="text-align:left"><span style="font-size:12px"><strong>Valor do Frete</strong></span></p></td><td style="text-align:center; width:158px"><p style="text-align:left"><span style="font-size:12px"><strong>Valor Total</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td style="text-align:center; width:126px"><p style="text-align:left"><span style="font-size:12px"><field key="quote_freight_modal" path-id="56">[Proposta.Modalidade de frete]</field></span></p></td><td style="text-align:center; width:152px"><p style="text-align:left"><span style="font-size:12px">R$&nbsp;<field format="n2" formattable="number" key="quote_freight_cost" path-id="56">[Proposta.Valor do frete]</field></span></p></td><td style="text-align:center; width:158px"><p style="text-align:left"><span style="font-size:12px">R$&nbsp;<field format="n2" formattable="number" key="quote_amount" path-id="56">[Proposta.Valor]</field></span></p></td></tr></tbody></table><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="text-align:center; width:333px"><p style="text-align:left"><span style="font-size:12px"><strong>Forma de pagamento</strong></span></p></td><td style="text-align:center; width:348px"><p style="text-align:left"><span style="font-size:12px"><strong>Prazo de entrega</strong></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td style="text-align:center; width:333px"><p style="text-align:left"><span style="font-size:12px"><field key="quote_payment_method" path-id="56">[Proposta.M�todo de pagamento]</field></span></p></td><td style="text-align:center; width:348px"><p style="text-align:left"><span style="font-size:12px"><field key="quote_delivery_time" path-id="56">[Proposta.Prazo de entrega]</field></span></p></td></tr><tr style="border-bottom:2px solid #016aa3 !important"><td colspan="2" style="width:333px"><p><span style="font-size:12px"><strong>Observa��es</strong></span></p><p><span style="font-size:12px"><field key="quote_notes" path-id="56">[Proposta.Observa��es]</field></span></p></td></tr></tbody></table><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class=";border-white no-border" style="width:100%"><tbody><tr><td style="border-right:2px solid #016aa3 !important; width:110px"><p><span style="font-size:12px"><span style="color:#016aa3"><strong>Emitida por:</strong></span></span></p><p><span style="font-size:12px"><span style="color:#016aa3"><strong>E-mail:</strong></span></span></p><p><span style="font-size:12px"><span style="color:#016aa3"><strong>Telefone:</strong></span></span></p></td><td style="vertical-align:top; width:605px"><p><span style="font-size:12px">&nbsp;&nbsp;<field key="user_name" path-id="80">[Proposta / Usu�rio.Nome]</field></span></p><p><span style="font-size:12px">&nbsp;&nbsp;<field key="user_email" path-id="80">[Proposta / Usu�rio.E-mail]</field></span></p><p><span style="font-size:12px">&nbsp;&nbsp;<field key="user_phone" path-id="80">[Proposta / Usu�rio.Telefone]</field></span></p></td></tr></tbody></table>',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}.border-td {border: none !important;}.border-td td, .border-td th {border: 1px solid;}tr {page-break-inside: avoid}</style><div style="position:relative"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="198" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/d0928e3c8587480ebd7ba542002cec4e.png" width="800" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span><div style="position:absolute; top:30px">&nbsp;<table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="width:67px">&nbsp;</td><td style="vertical-align:top; width:158px"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="78" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/845b2c0a288943909161b1d0b0b3e07b.png" width="144" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></td><td style="vertical-align:top; width:443px"><p><span style="color:#016aa3"><span style="font-size:14px"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><strong><span><span><span><span><span><span><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></span></span></span></span></span></strong></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p><span style="font-size:11px"><span style="color:#016aa3"><span><span><span><span><span><field key="account_street_address" path-id="32">[Sua Empresa.Endere�o]</field></span></span></span></span></span></span></span></p><p><span style="font-size:11px"><span style="color:#016aa3"><strong>CNPJ:</strong>&nbsp;<span><span><span><span><span><field key="account_register" path-id="32">[Sua Empresa.CNPJ]</field></span></span></span></span></span></span></span></p><p><span style="font-size:11px"><span style="color:#016aa3"><span><span><span><span><span><field key="account_phone" path-id="32">[Sua Empresa.Telefone]</field></span></span></span></span></span></span></span></p><div><div>&nbsp;</div></div></td><td style="width:122px">&nbsp;</td></tr></tbody></table><p>&nbsp;</p></div></div>',
			53,
			'',
			0, 15, 5, 5, 20)



	--QUOTES FORMS: PRODUTOS E SERVI�OS
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)
		
	SET @ID_FormularioProduto = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1131, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1133, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto, 1134, 1, 30)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco, 1136, 1, 10, @ID_FormularioProduto)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco, 1128, 1, 20)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 7, 'quote_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1110, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1119, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1364, 1, 30)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 40, 0, 'Produtos', @ID_FormularioBloco)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 14, 'quote_product_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)
		
	SET @ID_FormularioProduto2 = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto2, 1131, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto2, 1133, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioProduto2, 1134, 1, 30)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 8, 'quote_section_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco2 = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_FormularioBloco2, 1136, 1, 10, @ID_FormularioProduto2)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco2, 1128, 1, 20)


	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Codigo_Bloco, Descricao_Bloco, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1126, 1, 50, 1, 'Servi�os', @ID_FormularioBloco2)


	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1117, 1, 60)



	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Editavel)
		VALUES (@ID_ClientePloomes, 34, 'quote_installment_' + CONVERT(NVARCHAR(36), NEWID()) + '_form', 0)

	SET @ID_FormularioBloco3 = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco3, 1188, 1, 10)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco3, 1186, 1, 20)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_FormularioBloco3, 1187, 1, 30)



	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, ID_FormularioRapido)
		VALUES (@ID_Formulario, 1185, 1, 70, @ID_FormularioBloco3)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem)
		VALUES (@ID_Formulario, 1122, 1, 80)



	INSERT INTO Cotacao_Modelo (ID_ClientePloomes, ID_Entidade, ID_Formulario, Titulo, ID_Criador, Padrao, NovoFormato, ID_CampoParcelas, Fixo_CampoParcelas)
		VALUES (@ID_ClientePloomes, 7, @ID_Formulario, '[MODELO 5] Produtos e Servi�os', @ID_Usuario, 0, 1, 1117, 1)

	SET @ID_Modelo = SCOPE_IDENTITY()

	UPDATE Formulario SET TemplateId = @ID_Modelo WHERE ID IN (@ID_Formulario, @ID_FormularioBloco, @ID_FormularioBloco2, @ID_FormularioBloco3, @ID_FormularioProduto, @ID_FormularioProduto2)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Capa',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><div style="position:relative"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="1122.5" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/d44f29c193424b93b48ad1bf6e57f496.png" style="float:left" width="800" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span><div style="position:absolute; top:240px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:281px">&nbsp;</td><td style="width:449px"><p><span style="color:#385d2c"><span style="font-family:Verdana,Geneva,sans-serif"><strong><span style="font-size:36px">PROPOSTA</span></strong></span></span></p><p><span style="color:#385d2c"><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:22px">Servi�os &amp; Produtos</span></span></span></p><p>&nbsp;</p><p><span style="color:#385d2c"><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:12px"><strong><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><img alt="" height="61" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/dd92ae76c50c49808622e05a3c795eb3.png" width="113" /></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></strong></span></span></span></p><p style="text-align:center">&nbsp;</p><p><span style="color:#b4d44e"><span style="font-size:22px"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p></td><td style="width:60px">&nbsp;</td></tr></tbody></table></div><div style="position:absolute; top:560px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:800px"><tbody><tr><td style="width:281px">&nbsp;</td><td style="width:449px"><p><strong><span style="color:#ffffff"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field format="d" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></strong></p><p><span style="color:#ffffff"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><strong>Proposta n�:&nbsp;</strong><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.C�digo]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p><span style="color:#ffffff"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><strong>Validade:&nbsp;</strong><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field format="d" formattable="date" key="quote_expiration_date" path-id="56">[Proposta.Data de validade]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></p><p>&nbsp;</p></td><td style="width:60px">&nbsp;</td></tr></tbody></table></div></div>',
			'', 0, '', 0, 0, 0, 0, 10)

	INSERT INTO Document_Page (DocumentTemplateId, Name, BodySourceCode, HeaderSourceCode, HeaderHeight, FooterSourceCode, FooterHeight, SideMargin, TopMargin, BottomMargin, Ordination)
		VALUES (@ID_Modelo, 'Corpo',
			'<style type="text/css">p {font-family:Verdana,Geneva,sans-serif;}</style><style type="text/css">.border-white, .border-white td, .border-white th {border: 1px solid #ffffff!important;}</style><style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}.border-td {border: none !important;}.border-td td, .border-td th {border: 1px solid;}tr {page-break-inside: avoid}</style><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr style="border-bottom:2px solid #385d2c !important"><td style="width:344px"><p><span style="font-size:12px"><strong>Direcionado para</strong></span></p><p><span style="font-size:12px"><field key="contact_name" path-id="1">[Cliente.Nome]</field></span></p></td><td style="text-align:right; vertical-align:top; width:352px"><p><span style="font-size:12px"><strong><field key="account_city" path-id="32">[Sua Empresa.Cidade]</field>,&nbsp;<field format="dd \de MMMM \de yyyy" formattable="date" key="quote_date" path-id="56">[Proposta.Data]</field></strong></span></p><p><span style="font-size:12px"><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></p></td></tr><tr><td style="width:344px">&nbsp;</td><td style="width:352px">&nbsp;</td></tr><tr style="border-top:2px solid #385d2c !important"><td style="width:344px"><p><span style="font-size:12px"><strong>Validade da Proposta</strong></span></p><p><span style="font-size:12px"><field format="dd/MM/yyyy" formattable="date" key="quote_expiration_date" path-id="56">[Proposta.Data de validade]</field></span></p></td><td style="width:352px"><p style="text-align:right"><span style="font-size:12px"><strong>Proposta</strong>&nbsp;</span></p><p style="text-align:right"><span style="font-size:12px">n�&nbsp;<field format="n0" formattable="number" key="quote_number" path-id="56">[Proposta.C�digo]</field></span></p></td></tr></tbody></table><p>&nbsp;</p><p style="text-align:center"><span style="font-size:18px"><strong><span><span><span><span><span><span><span><span><span><span><span><span><span><span><field key="quote_title" path-id="56">[Proposta.T�tulo]</field></span></span></span></span></span></span></span></span></span></span></span></span></span></span></strong></span></p><p style="text-align:center">&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="border-white" section-code="0" section-name="Produtos" section-no-products="" style="width:100%"><tbody><tr><td style="background-color:#b3d44e; vertical-align:middle; width:53px"><div><div><div><div><div><div><div><div><p style="text-align:center"><img alt="" height="51" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/3a5e4ff9d181427a8d7630324721856a.png" width="50" /></p></div></div></div></div></div></div></div></div></td><td colspan="3" rowspan="1" style="background-color:#d6e488; width:283px"><p style="text-align:center"><span style="font-size:18px"><span style="color:#385d2c"><strong>Produtos&nbsp; &nbsp; &nbsp; </strong></span></span><span style="font-size:20px"><span style="color:#385d2c"><strong>&nbsp;</strong></span></span></p></td></tr><tr><td colspan="2" rowspan="1" style="background-color:#eeeeee; width:53px"><p style="text-align:center"><span style="font-size:12px"><strong>Produto</strong></span></p></td><td style="background-color:#eeeeee; width:131px"><p style="text-align:center"><span style="font-size:12px"><strong>Quantidade</strong></span></p></td><td style="background-color:#eeeeee; width:205px"><p style="text-align:center"><span style="font-size:12px"><strong>Valor Unit�rio</strong></span></p></td></tr><tr multiple-field-key="quote_section_products" style="border-bottom:2px solid #eeeeee !important; page-break-inside:avoid"><td colspan="2" rowspan="1" style="width:53px"><p style="text-align:center"><span style="font-size:12px"><field key="product_name" path-id="19">[Produtos / Produto.Nome]</field></span></p></td><td style="width:131px"><p style="text-align:center"><span style="font-size:12px"><field format="n0" formattable="number" key="quote_product_quantity" path-id="3">[Produtos.Quantidade]</field></span></p></td><td style="width:205px"><p style="text-align:center"><span style="font-size:12px">R$&nbsp;<field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unit�rio]</field><span style="color:#c0392b"><field format="n2" formattable="number" key="quote_product_total" path-id="3" style="display: none;">[Produtos.Total]</field></span></span></p></td></tr><tr><td colspan="4" style="background-color:#eeeeee; width:53px"><p style="text-align:right"><strong>Total: R$&nbsp;<span><span><span><span><span><field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></span></span></span></span></span></strong>&nbsp;</p></td></tr></tbody></table><p>&nbsp;</p><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="border-white" section-code="1" section-name="Servi�os" section-no-products="" style="width:100%"><tbody><tr><td style="background-color:#b3d44e; vertical-align:middle; width:53px"><div><div><div><div><div><div><div><div><p style="text-align:center"><img alt="" height="51" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/175093b7b71d4982a89daeaefd4600d8.png" width="50" /></p></div></div></div></div></div></div></div></div></td><td colspan="2" rowspan="1" style="background-color:#d6e488; width:283px"><p style="text-align:center"><span style="font-size:18px"><span style="color:#385d2c"><strong>Servi�os&nbsp; &nbsp; &nbsp; &nbsp;</strong></span></span></p></td></tr><tr><td colspan="2" rowspan="1" style="background-color:#eeeeee; width:53px"><p style="text-align:center"><span style="font-size:12px"><strong>Servi�o</strong></span></p></td><td style="background-color:#eeeeee; width:205px"><p style="text-align:center"><span style="font-size:12px"><strong>Valor Unit�rio</strong></span></p></td></tr><tr multiple-field-key="quote_section_products" style="border-bottom:2px solid #eeeeee !important; page-break-inside:avoid"><td colspan="2" rowspan="1" style="width:53px"><p style="text-align:center"><span style="font-size:12px"><field key="product_name" path-id="19">[Produtos / Produto.Nome]</field><span style="color:#c0392b"><field format="n3" formattable="number" key="quote_product_quantity" path-id="3" style="display: none;">[Produtos.Quantidade]</field></span></span></p></td><td style="width:205px"><p style="text-align:center"><span style="font-size:12px">R$&nbsp;<field format="n2" formattable="number" key="quote_product_unit_price" path-id="3">[Produtos.Valor unit�rio]</field><span style="color:#c0392b"><field format="n2" formattable="number" key="quote_product_total" path-id="3" style="display: none;">[Produtos.Total]</field></span></span></p></td></tr><tr><td colspan="3" style="background-color:#eeeeee; width:53px"><p style="text-align:right"><span style="font-size:12px"><strong>Total: R$&nbsp;<field format="n2" formattable="number" key="quote_section_total" path-id="2">[Bloco.Total]</field></strong>&nbsp;</span></p></td></tr></tbody></table><p><field format="n2" formattable="number" key="quote_amount" path-id="56">[Proposta.Valor]</field></p><p>&nbsp;</p><p><span style="font-size:12px"><strong>Parcelas:</strong></span></p><table border="0" cellpadding="0" class="no-border" style="width:100%"><tbody><tr><td style="background-color:#d6e488; text-align:center; width:93px"><span style="font-size:12px"><span style="color:#385d2c"><span style="font-family:Verdana,Geneva,sans-serif"><strong>PARCELA</strong></span></span></span></td><td style="background-color:#d6e488; text-align:center; width:369px"><span style="font-size:12px"><span style="color:#385d2c"><span style="font-family:Verdana,Geneva,sans-serif"><strong>DATA</strong></span></span></span></td><td style="background-color:#d6e488; text-align:center; width:181px"><span style="font-size:12px"><span style="color:#385d2c"><span style="font-family:Verdana,Geneva,sans-serif"><strong>VALOR (R$)</strong></span></span></span></td></tr><tr multiple-field-key="quote_installments" style="border-bottom:2px solid #d6e488 !important"><td style="text-align:center; width:93px"><span style="font-size:12px"><span style="font-family:Verdana,Geneva,sans-serif"><index field-key="quote_installments"></index></span></span></td><td style="text-align:center; width:369px"><p><span style="font-size:12px"><span style="font-family:Verdana,Geneva,sans-serif"><field key="quote_installment"></field> <span style="color:#c0392b"><field key="quote_installment_fixed" path-id="69" style="display: none;">[Proposta / Parcela.Fixar parcela]</field></span><field format="d" formattable="date" key="quote_installment_date" path-id="69">[Proposta / Parcela.Data]</field></span></span></p></td><td style="text-align:center; width:181px"><span style="font-size:12px"><span style="font-family:Verdana,Geneva,sans-serif">R$ <field format="n2" formattable="number" key="quote_installment_amount" path-id="69">[Proposta / Parcela.Valor]</field></span></span></td></tr></tbody></table><p>&nbsp;</p><p><span style="font-size:12px"><strong>Forma de Pagamento:&nbsp;</strong><field key="quote_payment_method" path-id="56">[Proposta.M�todo de pagamento]</field></span></p><p>&nbsp;</p><p>&nbsp;</p><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr style="border-bottom:2px solid #385d2c !important"><td style="width:686px"><p style="text-align:right"><span style="font-size:12px"><strong><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></strong></span></p><p style="text-align:right"><span style="font-size:12px"><field key="account_phone" path-id="32">[Sua Empresa.Telefone]</field></span></p><p style="text-align:right"><span style="font-size:12px"><field key="account_street_address" path-id="32">[Sua Empresa.Endere�o]</field></span></p></td></tr><tr><td style="text-align:right; width:686px">&nbsp;</td></tr><tr style="border-top:2px solid #385d2c !important"><td style="width:686px"><p style="text-align:right"><span style="font-size:12px"><field key="user_name" path-id="80">[Proposta / Usu�rio.Nome]</field></span></p><p style="text-align:right"><span style="font-size:12px"><field key="user_phone" path-id="80">[Proposta / Usu�rio.Telefone]</field></span></p><p style="text-align:right"><span style="font-size:12px"><field key="user_email" path-id="80">[Proposta / Usu�rio.E-mail]</field></span></p></td></tr></tbody></table>',
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><div style="position:relative"><span style="font-size:11px"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><img alt="" height="147" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/afb99ff2ed6b411e82fb2a81dcf04777.png" width="800" /></span></span></span></span></span></span><div style="position:absolute; top:34px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="line-height:1.3; width:100%"><tbody><tr><td style="width:246px">&nbsp;</td><td style="width:415px"><span style="font-size:11px"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><img alt="" height="43" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/BC511860B9AF/Images/362f8953b0ce47ff818213f4f39c4d2f.png" width="78" /></span></span></span></span></span></span><div><div><span style="font-size:11px"><span style="font-family:Verdana,Geneva,sans-serif"><strong><span><span><span><span><field key="account_name" path-id="32">[Sua Empresa.Nome]</field></span></span></span></span></strong></span></span></div><div><span style="font-size:10px"><span style="font-family:Verdana,Geneva,sans-serif"><strong>CNPJ:</strong></span></span><span style="font-size:11px"><span style="font-family:Verdana,Geneva,sans-serif"><strong>&nbsp;</strong></span></span><span style="font-size:10px"><span style="font-family:Verdana,Geneva,sans-serif"><span><span><span><span><field key="account_register" path-id="32">[Sua Empresa.CNPJ]</field></span></span></span></span></span></span></div></div></td><td style="width:122px">&nbsp;</td></tr></tbody></table></div></div>',
			40,
			'<style type="text/css">.no-border, .no-border td, .no-border th {border: none !important;}</style><div style="position:relative"><p style="text-align:right"><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:10px"><span><span><span><span><span><span><span><img alt="" height="147" src="https://stgploomescrmprd01.blob.core.windows.net/crm-prd/5A0109196493/Images/8cfabefebe954d7b811001d0130ba668.png" width="800" /></span></span></span></span></span></span></span></span></span></p><div style="position:absolute; top:30px"><table border="0" cellpadding="1" cellspacing="1" class="no-border" style="width:100%"><tbody><tr><td style="text-align:right; width:126px">&nbsp;</td><td style="width:534px"><p style="text-align:right"><strong><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:10px"><span><span><span><span><span><span><span><field key="account_website" path-id="32">[Sua Empresa.Site]</field></span></span></span></span></span></span></span></span></span></strong></p><p style="text-align:right"><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:10px"><span><span><span><span><span><span><span><field key="account_phone" path-id="32">[Sua Empresa.Telefone]</field></span></span></span></span></span></span></span></span></span></p><div><div style="text-align:right"><span style="font-family:Verdana,Geneva,sans-serif"><span style="font-size:10px"><span><span><span><span><span><span><span><field key="account_street_address" path-id="32">[Sua Empresa.Endere�o]</field></span></span></span></span></span></span></span></span></span></div></div></td><td style="width:123px">&nbsp;</td></tr></tbody></table></div></div>',
			40, 15, 10, 5, 20)



	--USER FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 24, 'user_form', 'Usu�rios', 1, 16)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1054, 1, 10, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1220, 1, 20, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1159, 1, 30, 0, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1158, 1, 40, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1221, 1, 50, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1283, 1, 60, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1284, 1, 70, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1163, 1, 80, 1, 0)



	--TEAM FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 30, 'team_form', 'Equipes', 1, 17)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1162, 1, 10, 1, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1285, 1, 20, 1, 0)




	--ACCOUNT FORM
	INSERT INTO Formulario (ID_ClientePloomes, ID_Entidade, Chave, Descricao, Editavel, BaseNameId)
		VALUES (@ID_ClientePloomes, 15, 'account_form', 'Sua empresa', 1, 15)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1212, 1, 10, 1, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1219, 1, 20, 1, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1213, 1, 30, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1214, 1, 40, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1215, 1, 50, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1286, 1, 60, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1216, 1, 70, 0, 0)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Expandido, Permanente)
		VALUES (@ID_Formulario, 1217, 1, 80, 1, 0)




	--ACCOUNT QUICK FORMS
	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@ID_ClientePloomes, 37, @ID_FormularioRapido_Segmento)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@ID_ClientePloomes, 35, @ID_FormularioRapido_Origem)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@ID_ClientePloomes, 38, @ID_FormularioRapido_Cargo)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@ID_ClientePloomes, 39, @ID_FormularioRapido_Departamento)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@ID_ClientePloomes, 40, @ID_FormularioRapido_QtdFuncionarios)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@ID_ClientePloomes, 25, @ID_FormularioRapido_Cidade)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@ID_ClientePloomes, 23, @ID_FormularioRapido_Marcador)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@ID_ClientePloomes, 11, @ID_FormularioRapido_Produto_Grupo)

	INSERT INTO Campo_Tabela_ClientePloomes (ID_ClientePloomes, ID_Tabela, ID_FormularioRapido)
		VALUES (@ID_ClientePloomes, 10, @ID_FormularioRapido_Produto)


	--Product part Forms
	INSERT INTO Formulario (ID_ClientePloomes, Chave, ID_Entidade, Descricao, Editavel, ID_Criador, DataCriacao, Suspenso, FilterForm, BaseNameId)
		VALUES ( @ID_ClientePloomes, 'product_part_form', 41, 'V�nculos', 1, 0, GETDATE(), 0, 0, 12)

	SET @ID_Formulario = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1478, 1, 0, 0, 0, 1, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, 1418, 1, 2, 1, 0, 0, NULL, 1)

	INSERT INTO Formulario_Secao (ID_Formulario, Descricao, Ordem)
		VALUES (@ID_Formulario, 'Valores', 6)

	SET @ID_Secao = SCOPE_IDENTITY()

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, @ID_Secao, 1144, 1, 7, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1145, 1, 8, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1146, 1, 9, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1147, 1, 10, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1148, 1, 11, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1149, 1, 12, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1150, 1, 13, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Secao, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, @ID_Secao, 1387, 1, 14, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1143, 1, 15, 0, 0, 1, NULL, 1)

	INSERT INTO Formulario_Secao_Language (SectionId, LanguageId, [Name])
		VALUES (@ID_Secao, 1, 'Valores'), 
			   (@ID_Secao, 2, 'Values'),
			   (@ID_Secao, 3, 'Valores'),
			   (@ID_Secao, 4, 'Valores')

	--Product Part quick form

	INSERT INTO Formulario (ID_ClientePloomes, Chave, ID_Entidade, Descricao, Editavel, ID_Criador, DataCriacao, Suspenso, FilterForm, BaseNameId)
		VALUES(@ID_ClientePloomes, 'product_part_quick_form', 41,'V�nculos (mini)',1,0,GETDATE(),0,0, 13)

	SET @ID_Formulario = SCOPE_IDENTITY()


	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1478, 1, 1, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1418, 1, 2, 1, 1, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1144, 1, 3, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1145, 1, 8, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1146, 1, 9, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES(@ID_Formulario, 1147, 1, 10, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1148, 1, 11, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1149, 1, 12, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1150, 1, 13, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1387, 1, 14, 0, 0, 0, NULL, 1)

	INSERT INTO Formulario_Campo (ID_Formulario, ID_Campo, Fixo, Ordem, Permanente, Obrigatorio, Expandido, Numero_Grupo, Unico)
		VALUES (@ID_Formulario, 1143, 1, 15, 0, 0, 1, NULL, 1)


	--FIELDS LINKS
	INSERT INTO Campo_Vinculo (ID_ClientePloomes, ID_CampoOrigem, Fixo_CampoOrigem, ID_CampoDestino, Fixo_CampoDestino)
		VALUES (@ID_ClientePloomes, 1027, 1, 1049, 1)


	--INFORME EXEMPLO
	INSERT INTO Informe (ID_ClientePloomes, Conteudo, ID_Criador) VALUES (@ID_ClientePloomes, 'Use o sistema de mensagens para se comunicar com sua equipe!', @ID_Usuario)


	--TAREFAS EXEMPLO
	DECLARE @ID_Tarefa INT
	
	INSERT INTO Tarefa (Titulo, ID_Criador) VALUES ('Criar cliente', @ID_Usuario)
	SET @ID_Tarefa = SCOPE_IDENTITY()
	INSERT INTO Tarefa_Conclusao (ID_Tarefa, DataRecorrencia, SemHorario) VALUES (@ID_Tarefa, GETDATE(), 1)
	INSERT INTO Tarefa_Usuario (ID_Tarefa, ID_Usuario) VALUES (@ID_Tarefa, @ID_Usuario)

	INSERT INTO Tarefa (Titulo, ID_Criador) VALUES ('Criar neg�cio', @ID_Usuario)
	SET @ID_Tarefa = SCOPE_IDENTITY()
	INSERT INTO Tarefa_Conclusao (ID_Tarefa, DataRecorrencia, SemHorario) VALUES (@ID_Tarefa, GETDATE(), 1)
	INSERT INTO Tarefa_Usuario (ID_Tarefa, ID_Usuario) VALUES (@ID_Tarefa, @ID_Usuario)

	INSERT INTO Tarefa (Titulo, ID_Criador) VALUES ('Criar proposta', @ID_Usuario)
	SET @ID_Tarefa = SCOPE_IDENTITY()
	INSERT INTO Tarefa_Conclusao (ID_Tarefa, DataRecorrencia, SemHorario) VALUES (@ID_Tarefa, GETDATE(), 1)
	INSERT INTO Tarefa_Usuario (ID_Tarefa, ID_Usuario) VALUES (@ID_Tarefa, @ID_Usuario)



	--STATUS DE VENDAS

	INSERT INTO Venda_Status (ID_ClientePloomes, Descricao, Ordem, ID_Criador, CSS_Icon)
		VALUES (@ID_ClientePloomes, 'Pedido recebido', 1, @ID_Usuario, 'icon-spinner')

	INSERT INTO Venda_Status (ID_ClientePloomes, Descricao, Ordem, ID_Criador, CSS_Icon)
		VALUES (@ID_ClientePloomes, 'Produto na transportadora', 2, @ID_Usuario, 'icon-truck')

	INSERT INTO Venda_Status (ID_ClientePloomes, Descricao, Ordem, ID_Criador, CSS_Icon)
		VALUES (@ID_ClientePloomes, 'Produto entregue', 3, @ID_Usuario, 'icon-ok')

	INSERT INTO Cliente_Relacao (ID_ClientePloomes, Descricao, ID_Criador)
		VALUES (@ID_ClientePloomes, 'Cliente', @ID_Usuario)

	INSERT INTO Cliente_Relacao (ID_ClientePloomes, Descricao, ID_Criador)
		VALUES (@ID_ClientePloomes, 'Parceiro', @ID_Usuario)

	INSERT INTO Cliente_Relacao (ID_ClientePloomes, Descricao, ID_Criador)
		VALUES (@ID_ClientePloomes, 'Revendedor', @ID_Usuario)

	INSERT INTO Cliente_Relacao (ID_ClientePloomes, Descricao, ID_Criador)
		VALUES (@ID_ClientePloomes, 'Fornecedor', @ID_Usuario)




	--RELAT�RIOS
	DECLARE @PanelId INT, @ChartId INT, @TableId INT, @TableFieldId INT, @FilterId INT, @FilterFieldId INT

	--VENDAS
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@ID_ClientePloomes, 'Vendas', @ID_Usuario)

	SET @PanelId = SCOPE_IDENTITY()

	--VENDAS: VALOR
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Valor em vendas neste m�s', 'width-33-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#27c24c"]}',
			0, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 'Valor em vendas neste m�s', '$filter=((date(Date)+eq+$thismonth))', 4, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador)
		VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto)
		VALUES (@FilterFieldId, '$thismonth')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 4, 'Valor em vendas neste m�s', @FilterId, '$select=Id,Date,Amount', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1172, 1, 0)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Valor em vendas neste m�s', '#27c24c', 2, NULL, 0)


	--VENDAS: TICKET M�DIO
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Ticket m�dio neste m�s', 'width-33-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"MMMM yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#27c24c"]}',
			2, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 'Ticket m�dio neste m�s', '$filter=((date(Date)+eq+$thismonth))', 4, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador)
		VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto)
		VALUES (@FilterFieldId, '$thismonth')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 4, 'Ticket m�dio neste m�s', @FilterId, '$select=Id,Date,Amount', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1172, 1, 0)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Ticket m�dio neste m�s', '#27c24c', 3, 4, 0)


	--VENDAS: QTD
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'N� de vendas neste m�s', 'width-33-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#27c24c"]}',
			1, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 'N� de vendas neste m�s', '$filter=((date(Date)+eq+$thismonth))', 4, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador)
		VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto)
		VALUES (@FilterFieldId, '$thismonth')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 4, 'N� de vendas neste m�s', @FilterId, '$select=Id', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1294, 1, 0)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1294, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'N� de vendas neste m�s', '#27c24c', 1, NULL, 0)


	--VENDAS: �LTIMOS 6 MESES
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 1, 'Vendas realizadas nos �ltimos 6 meses', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"MMMM yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#27c24c"]}',
			3, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 'Vendas realizadas nos �ltimos 6 meses', '$filter=((date(Date)+eq+$lastnmonths(6)))', 4, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador)
		VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto)
		VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 4, 'Vendas realizadas nos �ltimos 6 meses', @FilterId, '$select=Id,Date,Amount', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1172, 1, 0)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem)
		VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Vendas realizadas nos �ltimos 6 meses', '#27c24c', 2, 4, 0)



	--VENDAS: SEGMENTO
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por segmento - �ltimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"sortAscending":false,"sortColumn":1,"currentSort":"desc"}',
			4, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Por segmento - �ltimos 6 meses', '$filter=((Contact/LineOfBusinessId+ne+null+and+date(Date)+eq+$lastnmonths(6)))', 4, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1024, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1189, 1, 1)

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1024, 1, 2)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 4, 'Por segmento - �ltimos 6 meses', @FilterId, '$select=Id,Amount&$expand=Contact($select=Id,LineOfBusiness;$expand=LineOfBusiness($select=Id,Name))', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1024, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1189, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1024, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por segmento - �ltimos 6 meses', '#333', 2, NULL, 0)



	--VENDAS: ORIGEM
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por origem - �ltimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"sortAscending":false,"sortColumn":1,"currentSort":"desc"}',
			5, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Por origem - �ltimos 6 meses', '$filter=((Contact/OriginId+ne+null+and+date(Date)+eq+$lastnmonths(6)))', 4, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1025, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1189, 1, 1)

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1025, 1, 2)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 4, 'Por origem - �ltimos 6 meses', @FilterId, '$select=Id,Amount&$expand=Contact($select=Id,Origin;$expand=Origin($select=Id,Name))', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1025, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1189, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1025, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por origem - �ltimos 6 meses', '#333', 2, NULL, 0)



	--VENDAS: CLIENTE
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por cliente - �ltimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			6, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Por cliente - �ltimos 6 meses', '$filter=((date(Date)+eq+$lastnmonths(6)))', 4, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 4, 'Por cliente - �ltimos 6 meses', @FilterId, '$select=Id,Amount&$expand=Contact($select=Id,Name,Editable)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1189, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1189, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por cliente - �ltimos 6 meses', '#333333', 2, NULL, 0)




	--VENDAS: VENDEDOR
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por vendedor - �ltimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			7, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Por vendedor - �ltimos 6 meses', '$filter=((OwnerId+ne+null+and+date(Date)+eq+$lastnmonths(6)))', 4, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1183, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 4, 'Por vendedor - �ltimos 6 meses', @FilterId, '$select=Id,Amount&$expand=Owner($select=Id,Name,AvatarUrl)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1183, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por vendedor - �ltimos 6 meses', '#333', 2, NULL, 0)



	--VENDAS: PRODUTO
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por produto - �ltimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			8, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Por produto - �ltimos 6 meses', '$filter=((date(Order/Date)+eq+$lastnmonths(6)))', 20, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1207, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 20, 'Por produto - �ltimos 6 meses', @FilterId, '$select=Id,OrderId,Total&$expand=Product($select=Id,Name)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1200, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1204, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por produto - �ltimos 6 meses', '#333', 2, NULL, 0)



	--VENDAS: GRUPO DE PRODUTO
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por grupo de produto - �ltimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			9, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Por grupo de produto - �ltimos 6 meses', '$filter=((date(Order/Date)+eq+$lastnmonths(6)))', 20, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1207, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 20, 'Por grupo de produto - �ltimos 6 meses', @FilterId, '$select=Id,OrderId,Total&$expand=Product($select=Id,Group;$expand=Group($select=Id,Name))', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1107, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1200, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1204, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por grupo de produto - �ltimos 6 meses', '#333', 2, NULL, 0)



	--VENDAS: CIDADE
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por cidade - �ltimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			10, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Por cidade - �ltimos 6 meses', '$filter=((Contact/CityId+ne+null+and+date(Date)+eq+$lastnmonths(6)))', 4, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1040, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1189, 1, 1)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 4, 'Por cidade - �ltimos 6 meses', @FilterId, '$select=Id,Amount&$expand=Contact($select=Id,City;$expand=City($select=Id,Name))', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1040, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1189, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por cidade - �ltimos 6 meses', '#333', 2, NULL, 0)




	--VENDAS: ESTADO
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por estado - �ltimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			11, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Por estado - �ltimos 6 meses', '$filter=((Contact/CityId+ne+null+and+date(Date)+eq+$lastnmonths(6)))', 4, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1040, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1189, 1, 1)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 4, 'Por estado - �ltimos 6 meses', @FilterId, '$select=Id,Amount&$expand=Contact($select=Id,City;$expand=City($select=Id,State;$expand=State($select=Id,Name)))', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1059, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1189, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1040, 1, 2)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1057, 1, 3)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por estado - �ltimos 6 meses', '#333', 2, NULL, 0)


	
	--PROPOSTAS
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@ID_ClientePloomes, 'Propostas', @ID_Usuario)

	SET @PanelId = SCOPE_IDENTITY()

	--PROPOSTAS: GERADAS �LTIMOS 12 MESES 1
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 1, 'Propostas geradas nos �ltimos 12 meses', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"MMMM yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#786fb1"]}',
			0, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Propostas geradas nos �ltimos 12 meses', '$filter=((date(Date)+eq+$lastnmonths(12)))', 7, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1110, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(12)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 7, 'Propostas geradas nos �ltimos 12 meses', @FilterId, '$select=Id,Date', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1110, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Propostas geradas nos �ltimos 12 meses', '#786fb1', 1, 4, 0)



	--PROPOSTAS: GERADAS �LTIMOS 12 MESES 2
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Propostas geradas nos �ltimos 12 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#786fb1"]}',
			1, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Propostas geradas nos �ltimos 12 meses', '$filter=((date(Date)+eq+$lastnmonths(12)))', 7, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1110, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(12)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 7, 'Propostas geradas nos �ltimos 12 meses', @FilterId, '$select=Id', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Propostas geradas nos �ltimos 12 meses', '#786fb1', 1, NULL, 0)




	--PROPOSTAS: ANDAMENTO
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Dessas, est�o em andamento:', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#67878f"]}',
			2, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Dessas, est�o em andamento:', '$filter=((date(Date)+eq+$lastnmonths(12)+and+Deal/StatusId+eq+1))', 7, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1110, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(12)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 1)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 7, 'Dessas, est�o em andamento:', @FilterId, '$select=Id', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Dessas, est�o em andamento:', '#67878f', 1, NULL, 0)



	--PROPOSTAS: GANHAS
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Dessas, foram ganhas:', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#27c24c"]}',
			3, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Dessas, foram ganhas:', '$filter=((date(Date)+eq+$lastnmonths(12)+and+Deal/StatusId+eq+2))', 7, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1110, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(12)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 2)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 7, 'Dessas, foram ganhas:', @FilterId, '$select=Id', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Dessas, foram ganhas:', '#27c24c', 1, NULL, 0)



	--PROPOSTAS: PERDIDAS
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Dessas, foram perdidas:', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#f05050"]}',
			4, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Dessas, foram perdidas:', '$filter=((date(Date)+eq+$lastnmonths(12)+and+Deal/StatusId+eq+3))', 7, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1110, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(12)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 3)
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 7, 'Dessas, foram perdidas:', @FilterId, '$select=Id', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Dessas, foram perdidas:', '#f05050', 1, NULL, 0)



	--NEG�CIOS
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@ID_ClientePloomes, 'Neg�cios', @ID_Usuario)

	SET @PanelId = SCOPE_IDENTITY()

	--NEG�CIOS: INICIADOS NESTE M�S POR QTD
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'N� de neg�cios iniciados neste m�s', 'width-33-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"MMMM yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#92aab0"]}',
			0, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'N� de neg�cios iniciados neste m�s', '$filter=((date(StartDate)+eq+$thismonth))', 2, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$thismonth')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 2, 'N� de neg�cios iniciados neste m�s', @FilterId, '$select=Id,StartDate', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1050, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'N� de neg�cios iniciados neste m�s', '#92aab0', 1, 4, 0)




	--NEG�CIOS: VALOR DOS INICIADOS NESTE M�S
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Valor em neg�cios iniciados neste m�s', 'width-33-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#92aab0"]}',
			1, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Valor em neg�cios iniciados neste m�s', '$filter=((date(StartDate)+eq+$thismonth))', 2, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$thismonth')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 2, 'Valor em neg�cios iniciados neste m�s', @FilterId, '$select=Id,Amount', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1053, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Valor em neg�cios iniciados neste m�s', '#92aab0', 2, NULL, 0)



	--NEG�CIOS: VALOR M�DIO DOS INICIADOS NESTE M�S
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 7, 'Valor m�dio dos neg�cios deste m�s', 'width-33-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,##0.00","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#92aab0"]}',
			2, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Valor m�dio dos neg�cios deste m�s', '$filter=((date(StartDate)+eq+$thismonth))', 2, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$thismonth')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 2, 'Valor m�dio dos neg�cios deste m�s', @FilterId, '$select=Id,Amount', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1053, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Valor m�dio dos neg�cios deste m�s', '#92aab0', 3, NULL, 0)



	--NEG�CIOS: INICIADOS NOS �LTIMOS 6 MESES
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 1, 'Neg�cios iniciados nos �ltimos 6 meses', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"MMMM yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#92aab0"]}',
			3, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Neg�cios iniciados nos �ltimos 6 meses', '$filter=((date(StartDate)+eq+$lastnmonths(6)))', 2, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 2, 'Neg�cios iniciados nos �ltimos 6 meses', @FilterId, '$select=Id,StartDate', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1050, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Neg�cios iniciados nos �ltimos 6 meses', '#92aab0', 1, 4, 0)



	--NEG�CIOS: POR RESPONS�VEL
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por respons�vel - �ltimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333333"],"sort":"event","allowHtml":true,"sortAscending":false,"sortColumn":1,"currentSort":"desc"}',
			4, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Por respons�vel - �ltimos 6 meses', '$filter=((date(StartDate)+eq+$lastnmonths(6)+and+OwnerId+ne+null))', 2, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1049, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 2, 'Por respons�vel - �ltimos 6 meses', @FilterId, '$select=Id,Owner&$expand=Owner($select=Id,Name,AvatarUrl)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1049, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por respons�vel - �ltimos 6 meses', '#333333', 1, NULL, 0)




	--NEG�CIOS: POR ORIGEM
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por origem - �ltimos 6 meses', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"sortAscending":false,"sortColumn":1,"currentSort":"desc"}',
			5, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Por origem - �ltimos 6 meses', '$filter=((date(StartDate)+eq+$lastnmonths(6)+and+OriginId+ne+null))', 2, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1179, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 2, 'Por origem - �ltimos 6 meses', @FilterId, '$select=Id,Origin&$expand=Origin($select=Id,Name)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1179, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por origem - �ltimos 6 meses', '#333', 1, NULL, 0)
	


	--CLIENTES
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@ID_ClientePloomes, 'Clientes', @ID_Usuario)

	SET @PanelId = SCOPE_IDENTITY()

	--CLIENTES: CADASTRADOS NOS �LTIMOS 6 MESES
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 1, 'Clientes cadastrados nos �ltimos 6 meses', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"MMMM yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#23b7e5"]}',
			0, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Clientes cadastrados nos �ltimos 6 meses', '$filter=((date(CreateDate)+eq+$lastnmonths(6)))', 1, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1097, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 1, 'Clientes cadastrados nos �ltimos 6 meses', @FilterId, '$select=Id,CreateDate', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1097, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1291, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Clientes cadastrados nos �ltimos 6 meses', '#23b7e5', 1, 4, 0)


	--CLIENTES: DIVIS�O POR SITUA��O
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 4, 'Divis�o dos clientes por situa��o', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category"}',
			1, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Divis�o dos clientes por situa��o', '$filter=true', 1, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 1, 'Divis�o dos clientes por situa��o', @FilterId, '$select=Id,Status&$expand=Status($select=Id,Name)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1020, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1291, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Divis�o dos clientes por situa��o', '#1caad6', 1, NULL, 0)



	--CLIENTES: DIVIS�O POR ORIGEM
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 4, 'Divis�o dos clientes por origem', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category"}',
			2, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Divis�o dos clientes por origem', '$filter=((OriginId+ne+null))', 1, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1025, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 1, 'Divis�o dos clientes por origem', @FilterId, '$select=Id,Origin&$expand=Origin($select=Id,Name)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1025, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1291, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Divis�o dos clientes por origem', '#18a9d6', 1, NULL, 0)



	--CLIENTES: SEGMENTOS
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Segmentos dos clientes', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"sortAscending":false,"sortColumn":1,"currentSort":"desc"}',
			3, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Segmentos dos clientes', '$filter=((LineOfBusinessId+ne+null))', 1, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1024, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 1, 'Segmentos dos clientes', @FilterId, '$select=Id,LineOfBusiness&$expand=LineOfBusiness($select=Id,Name)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1024, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1291, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Segmentos dos clientes', '#333', 1, NULL, 0)



	--CLIENTES: ESTADOS
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Estados dos clientes', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"sortAscending":false,"sortColumn":1,"currentSort":"desc"}',
			4, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Estados dos clientes', '$filter=((CityId+ne+null))', 1, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1040, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 1, 'Estados dos clientes', @FilterId, '$select=Id&$expand=City($select=Id,State;$expand=State($select=Id,Name))', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1291, 1, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1059, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1040, 1, 1)
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1057, 1, 2)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Estados dos clientes', '#333', 1, NULL, 0)
	


	--REGISTRO DE CONTATO
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@ID_ClientePloomes, 'Intera��es', @ID_Usuario)

	SET @PanelId = SCOPE_IDENTITY()

	--REGISTROS DE CONTATO: �LTIMOS 30 DIAS
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 1, 'Intera��es nos �ltimos 30 dias', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"format":"dd/MM/yyyy"},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#37bc9b"]}',
			0, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Intera��es nos �ltimos 30 dias', '$filter=((date(Date)+eq+$last30days))', 36, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1093, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$last30days')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 36, 'Intera��es nos �ltimos 30 dias', @FilterId, '$select=Id,Date', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1093, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1298, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Intera��es nos �ltimos 30 dias', '#37bc9b', 1, 1, 0)


	--REGISTROS DE CONTATO: �LTMOS 60 DIAS POR DIA DA SEMANA
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 4, 'Por dia da semana - �ltimos 60 dias', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category"}',
			1, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Por dia da semana - 60 �ltimos dias', '$filter=((date(Date)+eq+$lastndays(60)))', 36, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1093, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastndays(60)')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 36, 'Por dia da semana - �ltimos 60 dias', @FilterId, '$select=Id,Date', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1093, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1298, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por dia da semana - �ltimos 60 dias', '#35bd9b', 1, 3, 0)


	--REGISTROS DE CONTATO: �LTIMOS 60 DIAS POR CIDADE
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por cidade - �ltimos 60 dias', 'width-50-percent', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333"],"sort":"event","allowHtml":true,"currentSort":"desc","sortAscending":false,"sortColumn":1}',
			2, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Por cidade - �ltimos 60 dias', '$filter=((date(Date)+eq+$lastndays(60)+and+Contact/CityId+ne+null))', 36, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1093, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastndays(60)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1040, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1091, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 36, 'Por cidade - �ltimos 60 dias', @FilterId, '$select=Id&$expand=Contact($select=Id,City;$expand=City($select=Id,Name))', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1298, 1, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1040, 1, 0)

	SET @TableFieldId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1091, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Por cidade - �ltimos 60 dias', '#333', 1, NULL, 0)

	

	--FUNIL DE VENDAS
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@ID_ClientePloomes, 'Funil de vendas', @ID_Usuario)

	SET @PanelId = SCOPE_IDENTITY()

	--FUNIL DE VENDAS: ANALISE HIST�RICA
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId, DealPipelineId, ViewId)
		VALUES (@PanelId, 9, 'An�lise hist�rica do funil de vendas (�ltimos 6 meses por padr�o)', 'full-width', '{}',
			0, @ID_Usuario, @ID_Funil, 2)

	--FUNIL DE VENDAS: MOTIVOS DE PERDA
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 4, 'Motivos de perda - �ltimos 6 meses', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category"}',
			1, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Motivos de perda - �ltimos 6 meses', '$filter=((date(FinishDate)+eq+$lastnmonths(6)+and+StatusId+eq+3))', 2, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1051, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$lastnmonths(6)')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 3)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 2, 'Motivos de perda - �ltimos 6 meses', @FilterId, '$select=Id&$expand=LossReason($select=Id,Name)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1080, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Motivos de perda - �ltimos 6 meses', '#f05050', 1, NULL, 0)


	--FUNIL DE VENDAS: SITUA��O ATUAL
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId, DealPipelineId)
		VALUES (@PanelId, 8, 'Situa��o atual do funil', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#333","#333","#333","#333"],"sort":"event"}',
			2, @ID_Usuario, @ID_Funil)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'M�dia de dias no est�gio', '$filter=((StatusId+eq+1))+and+PipelineId+eq+' + CONVERT(NVARCHAR(10), @ID_Funil), 2, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 1)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1303, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, @ID_Funil)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 2, 'M�dia de dias no est�gio', @FilterId, '$select=Id,DaysInStage&$expand=Stage($select=Id,Name)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1048, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1082, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'M�dia de dias no est�gio', '#333', 3, NULL, 3)


	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Valor m�dio', '$filter=((StatusId+eq+1))+and+PipelineId+eq+' + CONVERT(NVARCHAR(10), @ID_Funil), 2, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 1)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1303, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, @ID_Funil)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 2, 'Valor m�dio', @FilterId, '$select=Id,Amount&$expand=Stage($select=Id,Name)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1048, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1053, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Valor m�dio', '#333', 3, NULL, 2)
	

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Potencial em valor', '$filter=((StatusId+eq+1))+and+PipelineId+eq+' + CONVERT(NVARCHAR(10), @ID_Funil), 2, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 1)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1303, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, @ID_Funil)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 2, 'Potencial em valor', @FilterId, '$select=Id,Amount&$expand=Stage($select=Id,Name)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1048, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1053, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Potencial em valor', '#333', 2, NULL, 1)


	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Quantidade de neg�cios', '$filter=((StatusId+eq+1))+and+PipelineId+eq+' + CONVERT(NVARCHAR(10), @ID_Funil), 2, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1265, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, 1)

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1303, 1, 0, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorInteiro) VALUES (@FilterFieldId, @ID_Funil)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 2, 'Quantidade de neg�cios', @FilterId, '$select=Id,Amount&$expand=Stage($select=Id,Name)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1048, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Quantidade de neg�cios', '#333', 1, NULL, 0)



	--PRODUTIVIDADE
	INSERT INTO Panel (AccountId, Name, CreatorId) VALUES (@ID_ClientePloomes, 'Produtividade', @ID_Usuario)

	SET @PanelId = SCOPE_IDENTITY()

	--PRODUTIVIDADE POR PESSOA
	INSERT INTO Panel_Chart (PanelId, TypeId, Name, SizeClass, Options, Ordination, CreatorId)
		VALUES (@PanelId, 5, 'Por pessoa - �ltimos 30 dias', 'full-width', '{"height":250,"width":"100%","legend":"bottom","vAxis":{"gridlines":{"color":"#edf1f2"},"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"},"viewWindowMode":"pretty","baselineColor":"#C0D0E0","format":"#,###","minValue":0},"hAxis":{"textStyle":{"fontName":"''Source Sans Pro'', ''Open Sans'', ''Helvetica Neue'', Helvetica, Arial, sans-serif","fontSize":"13","color":"#606060"}},"tooltip":{"isHtml":true},"focusTarget":"category","colors":["#23876e","#ff902b","#59747a","#625a94","#27c24c"],"sort":"event","allowHtml":true,"currentSort":"asc","sortAscending":true,"sortColumn":0}',
			0, @ID_Usuario)

	SET @ChartId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Quantidade de Intera��es', '$filter=((date(Date)+eq+$last30days))', 36, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1093, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$last30days')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 36, 'Quantidade de Intera��es', @FilterId, '$select=Id&$expand=Creator($select=Id,Name,AvatarUrl)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1175, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1298, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Quantidade de Intera��es', '#23876e', 1, NULL, 0)


	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Leads criados', '$filter=((date(CreateDate)+eq+$last30days+and+OwnerId+ne+null))', 3, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1257, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$last30days')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1246, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 3, 'Leads criados', @FilterId, '$select=Id&$expand=Owner($select=Id,Name,AvatarUrl)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1246, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1293, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Leads criados', '#ff902b', 1, NULL, 1)


	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Neg�cios iniciados', '$filter=((date(StartDate)+eq+$last30days+and+OwnerId+ne+null))',2, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1050, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$last30days')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1049, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 2, 'Neg�cios iniciados', @FilterId, '$select=Id&$expand=Owner($select=Id,Name,AvatarUrl)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1049, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1292, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Neg�cios iniciados', '#59747a', 1, NULL, 2)


	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Propostas geradas', '$filter=((date(Date)+eq+$last30days+and+Deal/OwnerId+ne+null))', 7, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1110, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$last30days')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1049, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')
	INSERT INTO FiltroGeral_Campo_Campo (ID_FiltroCampo, ID_Campo, Fixo, Ordem) VALUES (@FilterFieldId, 1109, 1, 1)

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 7, 'Propostas geradas', @FilterId, '$select=Id&$expand=Deal($select=Id,Owner;$expand=Owner($select=Id,Name,AvatarUrl))', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1295, 1, 1)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1049, 1, 0)
	SET @TableFieldId = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@TableFieldId, 1109, 1, 1)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Propostas geradas', '#625a94', 1, NULL, 3)


	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Total em vendas', '$filter=((date(Date)+eq+$last30days+and+OwnerId+ne+null))', 4, 0, @ID_Usuario)

	SET @FilterId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1172, 1, 1, 1, 1)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, '$last30days')

	INSERT INTO FiltroGeral_Campo (ID_Filtro, ID_Campo, Fixo, DataRelativa, Numero_Grupo, ID_Operador) VALUES (@FilterId, 1183, 1, 0, 1, 2)

	SET @FilterFieldId = SCOPE_IDENTITY()

	INSERT INTO FiltroGeral_Campo_Valor (ID_FiltroCampo, ValorTexto) VALUES (@FilterFieldId, 'null')

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, Url, Listavel, ID_Criador)
		VALUES (@ID_ClientePloomes, 4, 'Total em vendas', @FilterId, '$select=Id,Amount&$expand=Owner($select=Id,Name,AvatarUrl)', 0, @ID_Usuario)

	SET @TableId = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1183, 1, 0)
	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@TableId, 1173, 1, 1)

	--Task table
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Todas', '$filter=true', 12, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 12, 'Todas', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1009, 1, 0, 1)
	SET @ID_TabelaCampo = SCOPE_IDENTITY()
	INSERT INTO Tabela_Campo_Campo (ID_TabelaCampo, ID_Campo, Fixo, Ordem) VALUES (@ID_TabelaCampo, 1009, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1001, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1003, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1004, 1, 3)

	INSERT INTO Panel_Chart_Metric (ChartId, TableId, Name, Color, AggregatorId, ModifierId, Ordination)
		VALUES (@ChartId, @TableId, 'Total em vendas', '#27c24c', 2, NULL, 4)


	INSERT INTO Produto_Parte_Group VALUES ('Opcionais', 1, @ID_Usuario, GETDATE(), NULL, NULL, 'False', @ID_ClientePloomes, 21)


	--Insert the Panel Goal

	INSERT INTO Panel_Goal (AccountId,CreateDate,CreatorId,Name,Suspended,UpdateDate,UpdaterId) VALUES (@ID_ClientePloomes,GETDATE(),@ID_Usuario,'Metas',0,NULL,NULL)

	--Logs@Changes table
	INSERT INTO FiltroGeral (ID_ClientePloomes, Nome, Url, ID_Entidade, Listavel, ID_Criador) VALUES (@ID_ClientePloomes, 'Todos', '$filter=true', 91, 0, @ID_Usuario)
	SET @ID_FiltroGeral = SCOPE_IDENTITY()

	INSERT INTO Tabela (ID_ClientePloomes, ID_Entidade, Descricao, ID_Filtro, ID_Criador) VALUES (@ID_ClientePloomes, 91, 'Todos', @ID_FiltroGeral, @ID_Usuario)
	SET @ID_Tabela = SCOPE_IDENTITY()

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem, Negrito) VALUES (@ID_Tabela, 1487, 1, 0, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1488, 1, 1)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1486, 1, 2)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1483, 1, 3)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1490, 1, 4)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1489, 1, 5)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1484, 1, 6)

	INSERT INTO Tabela_Campo (ID_Tabela, ID_Campo, Fixo, Ordem) VALUES (@ID_Tabela, 1485, 1, 7)

	INSERT INTO Tarefa_Classe_Account (AccountId, TypeId, Listable)
	SELECT @ID_ClientePloomes, TC.ID, 1
		FROM Tarefa_Classe TC


	--Insert configs in Fields
	INSERT INTO CampoFixo2_ClientePloomes (ID_ClientePloomes, ID_Campo, Obrigatorio, Unico, Bloqueado, Expandido, FiltroFormulario, FormulaEditor, Oculto, ColumnSize, UseCheckbox, FilterId)
		VALUES (@ID_ClientePloomes, 1496, 1, 0, 0, 1, 0, 0, 0, 1, 1, NULL)

	--Retorna a chave do usu�rio para o login autom�tico
	UPDATE Usuario SET Chave = STUFF(CONVERT(NVARCHAR(128), HASHBYTES('SHA2_512', CONVERT(NVARCHAR(10), ID) + CONVERT(VARCHAR(8), GETDATE(), 108) + 'AD9484845F7A4FC40AREDDINOSAUR2C3AEEE3265B942F1B13F6' + CONVERT(NVARCHAR(2), DAY(GETDATE())) + CONVERT(NVARCHAR(4), YEAR(GETDATE())) + CONVERT(NVARCHAR(2), MONTH(GETDATE()))), 2), 50, 0, CONVERT(NVARCHAR(10), ID))
		WHERE ID = @ID_Usuario


	-- Add last update date 
	INSERT INTO Campo_Tabela_LastUpdate (AccountId,EntityId,LastUpdateDate) VALUES (@ID_ClientePloomes, 24, GETDATE())
	INSERT INTO Campo_Tabela_LastUpdate (AccountId,EntityId,LastUpdateDate) VALUES (@ID_ClientePloomes, 33, GETDATE())
	INSERT INTO Campo_Tabela_LastUpdate (AccountId,EntityId,LastUpdateDate) VALUES (@ID_ClientePloomes, 77, GETDATE())
	INSERT INTO Campo_Tabela_LastUpdate (AccountId,EntityId,LastUpdateDate) VALUES (@ID_ClientePloomes, 81, GETDATE())
	INSERT INTO Campo_Tabela_LastUpdate (AccountId,EntityId,LastUpdateDate) VALUES (@ID_ClientePloomes, 93, GETDATE())
	INSERT INTO Campo_Tabela_LastUpdate (AccountId,EntityId,LastUpdateDate) VALUES (@ID_ClientePloomes, 63, GETDATE())


	SELECT U.Chave, PC.URL_Login, @ID_ClientePloomes AS ID_ClientePloomes, @ID_Usuario AS ID_Usuario, @ID_UsuarioAutomacao AS ID_UsuarioAutomacao
		FROM Usuario U INNER JOIN Ploomes_Cliente PC ON U.ID_ClientePloomes = PC.ID
		WHERE U.ID = @ID_Usuario
END
GO

GO
ALTER VIEW [dbo].[SVw_Formulario_Secao] AS
	SELECT S.*, U.ID as ID_Usuario,
			CONVERT(BIT, CASE
				WHEN U.ID_Perfil = 1 THEN 0
				WHEN NOT EXISTS(SELECT 1 FROM Formulario_Secao_AllowedUser FSU WHERE FSU.SectionId = S.ID)
					AND NOT EXISTS(SELECT 1 FROM Formulario_Secao_AllowedTeam FST WHERE FST.SectionId = S.ID)
					AND NOT EXISTS(SELECT 1 FROM Formulario_Secao_AllowedUserProfile FSP WHERE FSP.SectionId = S.ID) THEN 0
				WHEN EXISTS(SELECT 1 FROM Formulario_Secao_AllowedUser WHERE SectionId = S.ID AND UserId = U.ID) THEN 0
				WHEN EXISTS(SELECT 1 FROM Formulario_Secao_AllowedUserProfile WHERE SectionId = S.ID AND ProfileId = U.ID_Perfil) THEN 0
				WHEN EXISTS(SELECT 1 FROM Formulario_Secao_AllowedTeam FST INNER JOIN Equipe_Usuario EU ON FST.SectionId = S.ID AND FST.TeamId = EU.ID_Equipe AND EU.ID_Usuario = U.ID) THEN 0
				ELSE 1
			END) as [Hidden],
			ISNULL(FSL.Name, S.Descricao) as Name
		FROM Formulario_Secao S CROSS JOIN Usuario U
			LEFT JOIN Formulario_Secao_Language FSL ON FSL.SectionId = S.ID AND FSL.LanguageId = U.LanguageId
GO

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)