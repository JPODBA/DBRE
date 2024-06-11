USE Ploomes_CRM
GO
ALTER TRIGGER [dbo].[Tg_Automation_NextRunTime]
	ON [dbo].[Automation]
	AFTER INSERT, UPDATE
AS BEGIN

	IF EXISTS(SELECT 1 FROM inserted i LEFT JOIN deleted d ON i.Id = d.Id WHERE ISNULL(i.LastRunTime, '1900-01-01') <> ISNULL(d.LastRunTime, '1900-01-01')
			OR ISNULL(i.TriggerRepeatStartDateTime, '1900-01-01') <> ISNULL(d.TriggerRepeatStartDateTime, '1900-01-01'))
		BEGIN

		UPDATE Automation SET NextRunTime = IIF(A.LastRunTime IS NULL AND A.TriggerRepeatStartDateTime IS NOT NULL, A.TriggerRepeatStartDateTime, DATEADD(MINUTE, ISNULL(DATEPART(MINUTE, A.TriggerRepeatStartDateTime), 0), DATEADD(HOUR, ISNULL(DATEPART(HOUR, A.TriggerRepeatStartDateTime), 0),
					CASE WHEN IU.Datepart = 'day' THEN DATEADD(DAY, IU.DatepartLength * A.TriggerRepeatIntervalLength, CAST(CAST(A.LastRunTime as DATE) as DATETIME))
						WHEN IU.Datepart = 'month' THEN DATEADD(MONTH, IU.DatepartLength * A.TriggerRepeatIntervalLength, CAST(CAST(A.LastRunTime as DATE) as DATETIME)) END )))
			FROM Automation A INNER JOIN inserted i ON A.Id = i.Id
				LEFT JOIN IntervalUnit IU ON A.TriggerRepeatIntervalUnitId = IU.Id
			WHERE A.TriggerId = 17 AND A.Suspended = 0

	END
END
GO

ALTER TRIGGER [dbo].[Tg_Notificacao_Insert]
	ON [dbo].[Notificacao]
	AFTER INSERT
AS BEGIN
	UPDATE Usuario SET ContagemNotificacoes = ContagemNotificacoes + 1
		FROM Usuario U INNER JOIN inserted i ON U.ID = i.ID_Usuario
	UPDATE Notificacao SET MobileNotificationPushed = 1
		FROM Usuario U INNER JOIN inserted i ON U.ID = i.ID_Usuario AND U.Mobile_PushNotificationToken IS NULL
			INNER JOIN Notificacao N ON i.ID = N.ID

	UPDATE N
	SET AccountId = U.ID_ClientePloomes
	FROM Usuario U 
		INNER JOIN inserted i ON U.ID = i.ID_Usuario
		INNER JOIN Notificacao N ON i.ID = N.ID
END
GO


ALTER TRIGGER [dbo].[Tg_Oportunidade_Update]
	ON [dbo].[Oportunidade]
	AFTER UPDATE
AS BEGIN
	DECLARE @ID_Cliente INT, @ID_StatusNovo INT, @ID_StatusAntigo INT, @ID_MotivoPerdaAntigo INT, @ID_MotivoPerdaNovo INT,
		@ValorNovo DECIMAL(18,2), @ValorAntigo DECIMAL(18,2), @ID_Venda INT, @ID_ResponsavelNovo INT,
		@ID_ResponsavelAntigo INT,
		@ID_MoedaNova INT, @ID_MoedaAntiga INT, @ID_Oportunidade INT, @ID_Atualizador INT, @MotivoSuspenso BIT,
		@Suspenso BIT, @ComissaoAntiga FLOAT, @ComissaoNova FLOAT, @ID_ComissionadoNovo INT, @ID_ComissionadoAntigo INT

	SELECT @ID_Cliente = ID_Cliente, @ID_StatusNovo = ID_Status, @ValorNovo = Valor, @ID_MoedaNova = ID_Moeda, @ID_MotivoPerdaNovo = ID_MotivoPerda,
			@ID_Oportunidade = ID, @ID_ResponsavelNovo = ID_Responsavel, @ID_Atualizador = ID_Atualizador, @Suspenso = Suspenso,
			@ComissaoNova = Comissao, @ID_ComissionadoNovo = ID_Comissionado
		FROM inserted
	SELECT @ID_StatusAntigo = ID_Status, @ValorAntigo = Valor, @ID_MoedaAntiga = ID_Moeda, @ID_MotivoPerdaAntigo = ID_MotivoPerda,
			@ID_ResponsavelAntigo = ID_Responsavel, @ComissaoAntiga = Comissao, @ID_ComissionadoAntigo = ID_Comissionado
		FROM deleted

	SELECT @MotivoSuspenso = Suspenso
		FROM Oportunidade_MotivoPerda WHERE ID = @ID_MotivoPerdaAntigo

	IF @ID_StatusNovo <> @ID_StatusAntigo OR @ID_StatusAntigo = 2 AND @ID_MotivoPerdaAntigo <> @ID_MotivoPerdaNovo AND @MotivoSuspenso = 'False' BEGIN
		DECLARE @OrdemAntiga INT, @OrdemNova INT
		SELECT @OrdemAntiga = Ordem FROM Oportunidade_Status WHERE ID = @ID_StatusAntigo
		SELECT @OrdemNova = Ordem FROM Oportunidade_Status WHERE ID = @ID_StatusNovo
		SELECT @ID_Venda = ID FROM Venda WHERE ID_Oportunidade = @ID_Oportunidade AND Suspenso = 'False'

		UPDATE Oportunidade_Status_Historico SET ID_StatusNovo = @ID_StatusNovo,
				Valor = @ValorNovo, ID_Moeda = @ID_MoedaNova,
				ID_Atualizador = @ID_Atualizador, DataAtualizacao = GETDATE(),
				ID_MotivoPerda = @ID_MotivoPerdaNovo, ID_Venda = @ID_Venda
			WHERE ID_Oportunidade = @ID_Oportunidade AND ID_StatusNovo IS NULL AND ID_Status = @ID_StatusAntigo

		IF @OrdemAntiga > @OrdemNova
			UPDATE OSH SET OSH.Invalido = 'True'
				FROM Oportunidade_Status_Historico OSH INNER JOIN Oportunidade_Status St ON OSH.ID_Status = St.ID
				WHERE OSH.ID_Oportunidade = @ID_Oportunidade AND St.Ordem >= @OrdemNova

		INSERT INTO Oportunidade_Status_Historico (ID_Oportunidade, ID_Status, ID_Criador)
			VALUES (@ID_Oportunidade, @ID_StatusNovo, @ID_Atualizador)

		IF @ID_StatusAntigo = 1
			UPDATE Venda SET Suspenso = 'True'
				FROM Venda V INNER JOIN Ploomes_Cliente PC ON V.ID_ClientePloomes = PC.ID
				WHERE V.ID_Oportunidade = @ID_Oportunidade AND PC.Vendas = 0

		IF @ID_StatusNovo BETWEEN 1 AND 2
			UPDATE Oportunidade SET Termino = GETDATE() WHERE ID = @ID_Oportunidade
	END

	IF @ValorNovo <> @ValorAntigo OR @ID_MoedaNova <> @ID_MoedaAntiga BEGIN
		UPDATE Oportunidade_Valor_Historico SET Valor = @ValorAntigo, ID_Moeda = @ID_MoedaAntiga,
				ID_MoedaNova = @ID_MoedaNova, ValorNovo = @ValorNovo, ID_Atualizador = @ID_Atualizador,
				DataAtualizacao = GETDATE()
			WHERE ID_Oportunidade = @ID_Oportunidade AND ValorNovo IS NULL

		INSERT INTO Oportunidade_Valor_Historico (ID_Oportunidade, ID_Moeda, Valor, ID_Criador)
			VALUES (@ID_Oportunidade, @ID_MoedaNova, @ValorNovo, ISNULL(@ID_Atualizador, 0))

		SELECT @ID_Venda = ID FROM Venda WHERE ID_Oportunidade = @ID_Oportunidade AND Suspenso = 'False'
		UPDATE Venda SET Valor = @ValorNovo * ISNULL(TaxaConversao, 1) WHERE ID = @ID_Venda
	END

	IF @ComissaoNova <> @ComissaoAntiga OR @ComissaoNova IS NULL AND @ComissaoAntiga IS NOT NULL OR @ComissaoNova IS NOT NULL AND @ComissaoAntiga IS NULL BEGIN
		SELECT @ID_Venda = ID FROM Venda WHERE ID_Oportunidade = @ID_Oportunidade AND Suspenso = 'False'
		UPDATE Venda SET Comissao = @ComissaoNova WHERE ID = @ID_Venda
	END

	IF @ID_ComissionadoNovo <> @ID_ComissionadoAntigo OR @ID_ComissionadoNovo IS NULL AND @ID_ComissionadoAntigo IS NOT NULL OR @ID_ComissionadoNovo IS NOT NULL AND @ID_ComissionadoAntigo IS NULL BEGIN
		SELECT @ID_Venda = ID FROM Venda WHERE ID_Oportunidade = @ID_Oportunidade AND Suspenso = 'False'
		UPDATE Venda SET ID_Comissionado = @ID_ComissionadoNovo WHERE ID = @ID_Venda
	END

	IF ISNULL(@ID_ResponsavelAntigo, 0) <> @ID_ResponsavelNovo AND @ID_ResponsavelNovo <> @ID_Atualizador
		INSERT INTO Notificacao (ID_Usuario, ID_UsuarioRealizador, ID_Tipo, ID_Item)
			VALUES (@ID_ResponsavelNovo, @ID_Atualizador, 15, @ID_Oportunidade)

	IF @Suspenso = 'True'
		DELETE Notificacao
			FROM Notificacao INNER JOIN Notificacao_Tipo T ON Notificacao.ID_Tipo = T.ID
			WHERE Notificacao.ID_Item = @ID_Oportunidade AND T.ID_Entidade = 6

	DECLARE @Prospeccao BIT, @ID_ClientePloomes INT, @ID_StatusCliente INT, @ID_StatusInativo INT,
		@ID_TipoCliente INT, @ID_ClientePai INT, @ID_StatusAtivo INT

	SELECT @Prospeccao = CS.Prospeccao, @ID_ClientePloomes = Cli.ID_ClientePloomes,
			@ID_StatusCliente = CS.ID, @ID_TipoCliente = Cli.ID_Tipo,
			@ID_ClientePai = Cli.ID_Cliente
		FROM Cliente Cli INNER JOIN Cliente_Status CS ON Cli.ID_Status = CS.ID
		WHERE Cli.ID = @ID_Cliente

	SELECT @ID_StatusInativo = St.ID
		FROM Cliente_Status St
		WHERE St.ID_ClientePloomes = @ID_ClientePloomes
			AND St.Descricao = 'Inativo'
			AND St.Suspenso = 'False'

	SELECT @ID_StatusAtivo = St.ID
		FROM Cliente_Status St
		WHERE St.ID_ClientePloomes = @ID_ClientePloomes
			AND St.Descricao = 'Ativo'
			AND St.Suspenso = 'False'

	IF @ID_StatusNovo = 1 AND (@Prospeccao = 'True' OR @ID_StatusCliente = @ID_StatusInativo)
	BEGIN
		IF @ID_TipoCliente = 2 AND @ID_ClientePai IS NOT NULL
			UPDATE Cliente SET ID_Status = @ID_StatusAtivo WHERE ID = @ID_ClientePai
		ELSE
			UPDATE Cliente SET ID_Status = @ID_StatusAtivo WHERE ID = @ID_Cliente
	END
END
GO

ALTER TRIGGER [dbo].[Tg_Venda_Update]
	ON [dbo].[Venda]
	AFTER UPDATE
AS BEGIN
	DECLARE @ID_StatusNovo INT, @ID_StatusAntigo INT, @ID_Venda INT, @ID_Atualizador INT

	SELECT @ID_StatusNovo = ID_Status, @ID_Atualizador = ID_Atualizador, @ID_Venda = ID
		FROM inserted

	SELECT @ID_StatusAntigo = ID_Status
		FROM deleted

	IF @ID_StatusNovo <> @ID_StatusAntigo BEGIN
		DECLARE @OrdemAntiga INT, @OrdemNova INT
		SELECT @OrdemAntiga = Ordem FROM Venda_Status WHERE ID = @ID_StatusAntigo
		SELECT @OrdemNova = Ordem FROM Venda_Status WHERE ID = @ID_StatusNovo

		UPDATE Venda_Status_Historico SET ID_StatusNovo = @ID_StatusNovo,
				ID_Atualizador = @ID_Atualizador, DataAtualizacao = GETDATE()
			WHERE ID_Venda = @ID_Venda AND ID_StatusNovo IS NULL AND ID_Status = @ID_StatusAntigo

		IF @OrdemAntiga > @OrdemNova
			UPDATE VSH SET VSH.Invalido = 'True'
				FROM Venda_Status_Historico VSH INNER JOIN Venda_Status St ON VSH.ID_Status = St.ID
				WHERE VSH.ID_Venda = @ID_Venda AND St.Ordem >= @OrdemNova

		INSERT INTO Venda_Status_Historico (ID_Venda, ID_Status, ID_Criador)
			VALUES (@ID_Venda, @ID_StatusNovo, @ID_Atualizador)

		DECLARE @Email_Cliente NVARCHAR(80), @Nome_ClientePloomes NVARCHAR(200),
			@Codigo INT, @URL NVARCHAR(300), @Profile NVARCHAR(20)

		SELECT @Email_Cliente = Cli.Email, @Nome_ClientePloomes = PC.Nome, @Codigo = V.Codigo,
				@URL = ISNULL(PC.URL_Vendas + '?k=' + V.Chave, 'https://www.ploomes.com/CRM/Public/Vendas/?i=' + PC.ChaveIntegracao + '&k=' + V.Chave),
				@Profile = IIF(PC.Habilitado_EmailAutomatico = 'True', CONVERT(NVARCHAR(20), PC.ID), 'PloomesCRM')
			FROM Venda V INNER JOIN Cliente Cli ON V.ID_Cliente = Cli.ID
				INNER JOIN Ploomes_Cliente PC ON Cli.ID_ClientePloomes = PC.ID
			WHERE V.ID = @ID_Venda AND PC.Habilitado_EmailAutomatico = 'True'

		IF @Email_Cliente IS NOT NULL BEGIN
			DECLARE @Subject NVARCHAR(200), @MailBody NVARCHAR(MAX)

			SET @Subject = @Nome_ClientePloomes + ': atualização no estágio da ordem de venda #' + CONVERT(NVARCHAR(50), @Codigo)
			SET @MailBody = 'Olá!' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'Sua ordem de venda #' + CONVERT(NVARCHAR(50), @Codigo) + ' foi atualizada.' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'Acesse o link ' + @URL + ' para ver mais detalhes.'

			/*EXEC msdb.dbo.sp_send_dbmail
				@profile_name = @Profile,
				@recipients = @Email_Cliente,
				@subject = @Subject,
				@body = @MailBody,
				@body_format = 'HTML'*/
		END
	END
END
GO

ALTER TABLE Cotacao_Revisao_Tabela_Produto_Parte
DROP COLUMN [QuoteId]
GO

ALTER TABLE Document_Product_Part
DROP COLUMN [DocumentId]
GO

ALTER TABLE Venda_Tabela_Produto_Parte
DROP COLUMN [OrderId]
GO


ALTER VIEW [dbo].[Vw_PesquisaGeral] AS
	SELECT DISTINCT T.*
		FROM (
			SELECT 1 as ID_Entidade, Cli.ID as ID_Item, Cli.Nome as BuscaTexto, NULL as BuscaInteiro, Cli.ID as ID_Cliente, Cli.Nome as NomeCliente, NULL as ID_Oportunidade, NULL as ID_CotacaoRevisao,
					NULL as ID_Venda, NULL as ID_Lead, NULL as ID_Usuario, Cli2.ID_Usuario as ID_UsuarioView, 40 as Ordem
				FROM SVw_Cliente Cli2 INNER JOIN Cliente Cli ON Cli2.ID = Cli.ID
				WHERE Cli.Suspenso = 'False'

			UNION ALL

			SELECT 1 as ID_Entidade, Cli.ID as ID_Item, Cli.RazaoSocial as BuscaTexto, NULL as BuscaInteiro, Cli.ID as ID_Cliente, Cli.Nome as NomeCliente, NULL as ID_Oportunidade, NULL as ID_CotacaoRevisao,
					NULL as ID_Venda, NULL as ID_Lead, NULL as ID_Usuario, Cli2.ID_Usuario as ID_UsuarioView, 50 as Ordem
				FROM SVw_Cliente Cli2 INNER JOIN Cliente Cli ON Cli2.ID = Cli.ID
				WHERE Cli.Suspenso = 'False'

			UNION ALL

			SELECT 1 as ID_Entidade, Cli.ID as ID_Item, Cli.Email as BuscaTexto, NULL as BuscaInteiro, Cli.ID as ID_Cliente, Cli.Nome as NomeCliente, NULL as ID_Oportunidade, NULL as ID_CotacaoRevisao,
					NULL as ID_Venda, NULL as ID_Lead, NULL as ID_Usuario, Cli2.ID_Usuario as ID_UsuarioView, 60 as Ordem
				FROM SVw_Cliente Cli2 INNER JOIN Cliente Cli ON Cli2.ID = Cli.ID
				WHERE Cli.Suspenso = 'False'

			UNION ALL

			SELECT 1 as ID_Entidade, Cli.ID as ID_Item, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Cli.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', '') as BuscaTexto, NULL as BuscaInteiro, Cli.ID as ID_Cliente, Cli.Nome as NomeCliente, NULL as ID_Oportunidade, NULL as ID_CotacaoRevisao,
					NULL as ID_Venda, NULL as ID_Lead, NULL as ID_Usuario, Cli2.ID_Usuario as ID_UsuarioView, 70 as Ordem
				FROM SVw_Cliente Cli2 INNER JOIN Cliente Cli ON Cli2.ID = Cli.ID
				WHERE Cli.Suspenso = 'False'

			UNION ALL

			SELECT 1 as ID_Entidade, Cli.ID as ID_Item, NULL as BuscaTexto, TRY_CONVERT(BIGINT, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Cli.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', '')) as BuscaInteiro, Cli.ID as ID_Cliente, Cli.Nome as NomeCliente, NULL as ID_Oportunidade, NULL as ID_CotacaoRevisao,
					NULL as ID_Venda, NULL as ID_Lead, NULL as ID_Usuario, Cli2.ID_Usuario as ID_UsuarioView, 30 as Ordem
				FROM SVw_Cliente Cli2 INNER JOIN Cliente Cli ON Cli2.ID = Cli.ID
				WHERE Cli.Suspenso = 'False'

			UNION ALL

			SELECT 1 as ID_Entidade, Cli.ID as ID_Item, Cli.IdentityDocument as BuscaTexto, NULL as BuscaInteiro, Cli.ID as ID_Cliente, Cli.Nome as NomeCliente, NULL as ID_Oportunidade, NULL as ID_CotacaoRevisao,
					NULL as ID_Venda, NULL as ID_Lead, NULL as ID_Usuario, Cli2.ID_Usuario as ID_UsuarioView, 120 as Ordem
				FROM SVw_Cliente Cli2 INNER JOIN Cliente Cli ON Cli2.ID = Cli.ID
				WHERE Cli.Suspenso = 'False'

			UNION ALL

			SELECT 2 as ID_Entidade, O.ID as ID_Item, O.Titulo as BuscaTexto, NULL as BuscaInteiro, O.ID_Cliente, Cli.Nome as NomeCliente, O.ID as ID_Oportunidade, NULL as ID_CotacaoRevisao,
					NULL as ID_Venda, NULL as ID_Lead, NULL as ID_Usuario, O2.ID_Usuario as ID_UsuarioView, 80 as Ordem
				FROM SVw_Oportunidade O2 INNER JOIN Oportunidade O ON O2.ID = O.ID
					LEFT JOIN Cliente Cli ON O.ID_Cliente = Cli.ID
				WHERE O.Suspenso = 'False'

			UNION ALL

			SELECT 2 as ID_Entidade, O.ID as ID_Item, Cli.Nome as BuscaTexto, NULL as BuscaInteiro, O.ID_Cliente, Cli.Nome as NomeCliente, O.ID as ID_Oportunidade, NULL as ID_CotacaoRevisao,
					NULL as ID_Venda, NULL as ID_Lead, NULL as ID_Usuario, O2.ID_Usuario as ID_UsuarioView, 90 as Ordem
				FROM SVw_Oportunidade O2 INNER JOIN Oportunidade O ON O2.ID = O.ID
					INNER JOIN Cliente Cli ON O.ID_Cliente = Cli.ID
				WHERE O.Suspenso = 'False'

			UNION ALL

			SELECT 3 as ID_Entidade, V.ID as ID_Item, NULL as BuscaTexto, V.Codigo as BuscaInteiro, V.ID_Cliente, Cli.Nome as NomeCliente, V.ID_Oportunidade, NULL as ID_CotacaoRevisao,
					V.ID as ID_Venda, NULL as ID_Lead, NULL as ID_Usuario, V.ID_Usuario as ID_UsuarioView, 20 as Ordem
				FROM SVw_Venda V INNER JOIN Usuario U ON V.ID_Usuario = U.ID
					INNER JOIN Ploomes_Cliente PC ON U.ID_ClientePloomes = PC.ID
					LEFT JOIN Cliente Cli ON V.ID_Cliente = Cli.ID
				WHERE V.Suspenso = 'False' AND PC.Vendas = 'True'

			UNION ALL

			SELECT 4 as ID_Entidade, CR.ID as ID_Item, NULL as BuscaTexto, C.Codigo as BuscaInteiro, O.ID_Cliente, Cli.Nome as NomeCliente, O.ID as ID_Oportunidade, CR.ID as ID_CotacaoRevisao,
					NULL as ID_Venda, NULL as ID_Lead, NULL as ID_Usuario, O2.ID_Usuario as ID_UsuarioView, 10 as Ordem
				FROM SVw_Oportunidade O2 INNER JOIN Oportunidade O ON O2.ID = O.ID
					INNER JOIN Cotacao C ON O.ID = C.ID_Oportunidade
					INNER JOIN Cotacao_Revisao CR ON C.ID = CR.ID_Cotacao
					INNER JOIN Usuario U ON O2.ID_Usuario = U.ID
					INNER JOIN Ploomes_Cliente PC ON U.ID_ClientePloomes = PC.ID
					LEFT JOIN Cliente Cli ON O.ID_Cliente = Cli.ID
				WHERE C.Suspenso = 'False' AND PC.Cotacoes = 'True'

			UNION ALL

			SELECT 5 as ID_Entidade, L.ID as ID_Item, L.Empresa as BuscaTexto, NULL as BuscaInteiro, NULL as ID_Cliente, NULL as NomeCliente, NULL as ID_Oportunidade, NULL as ID_CotacaoRevisao,
					NULL as ID_Venda, L.ID as ID_Lead, NULL as ID_Usuario, L.ID_Usuario as ID_UsuarioView, 100 as Ordem
				FROM SVw_Lead L
				WHERE L.Suspenso = 'False'

			UNION ALL

			SELECT 6 as ID_Entidade, Usu.ID as ID_Item, Usu.Nome as BuscaTexto, NULL as BuscaInteiro, NULL as ID_Cliente, NULL as NomeCliente, NULL as ID_Oportunidade, NULL as ID_CotacaoRevisao,
					NULL as ID_Venda, NULL as ID_Lead, Usu.ID as ID_Usuario, Usu.ID_Usuario as ID_UsuarioView, 110 as Ordem
				FROM Vw_Usuario Usu INNER JOIN Usuario U ON Usu.ID_Usuario = U.ID
					INNER JOIN Usuario_Perfil P ON U.ID_Perfil = P.ID AND P.Timeline_Empresa = 'True'
	) as T
GO

ALTER TABLE [CampoFixo2]
DROP COLUMN [CreateDate]
GO

ALTER TABLE [CampoFixo2_ClientePloomes]
DROP COLUMN [UpdateDate]
GO

ALTER VIEW [dbo].[SVw_Campo] AS
SELECT F.FieldId as ID, 
       F.[Key] as Chave, 
       F.[Dynamic] as Dinamico, 
       ISNULL(CL.Name, C.Descricao) as Descricao,
       C.ID_Tabela,
       C.ID_Tipo,
	   C.ID_TabelaEstrangeira,
       C.ID_TabelaEstrangeiraFixa, 
       C.Multiplo,
       IIF(C.ID_Tipo = 1, 250, NULL) as StringLength,
       C.Obrigatorio,
       CONVERT(BIT, 0) AS NaoNulavel, 
       CONVERT(BIT, 0) AS Permanente, 
       C.Unico,
       CONVERT(BIT, IIF(C.ID_Tipo NOT IN (2, 22), 1, 0)) AS Filtro, 
       C.Filtro AS FiltroFormulario, 
       CONVERT(BIT, 0) AS PulaTabelaIntermediaria, 
       CONVERT(BIT, IIF(C.ID_Tipo <> 22, 1, 0)) AS Importavel, 
       C.Expandido, 
       C.ColumnSize,
       C.Formula,
	   ISNULL(C.FormulaExternaUrl, IIF(CGS.ID IS NOT NULL, CASE WHEN db_name() = 'Ploomes_CRM_SPA' THEN 'https://api2-dev.ploomes.com/' WHEN db_name() = 'Ploomes_CRM_QA' THEN 'https://api2-qa.ploomes.com/' WHEN db_name() = 'Ploomes_CRM_PPrd2' THEN 'https://api2-pprd.ploomes.com/' ELSE 'https://app-api2.ploomes.com/' END + 'Fields@GoogleSheetsIntegrations(' + CONVERT(NVARCHAR(10), CGS.ID) + ')/CalculateValue', NULL)) AS FormulaExternaUrl,
	   ISNULL(C.FormulaExternaMethod, IIF(CGS.ID IS NOT NULL, 'POST', NULL)) AS FormulaExternaMethod, 
       ISNULL(C.FormulaExternaHeaders, IIF(CGS.ID IS NOT NULL, '{"User-Key": "' + U.Chave + '"}', NULL)) AS FormulaExternaHeaders,
	   ISNULL(C.FormulaExternaRequestBody, '{"Variables": [' + (SELECT '{"VariableId": ' + CONVERT(NVARCHAR(10), CGSV.ID) + ', "Value": ' + IIF(CVT.EFType IN ('String', 'DateTime') OR CVT.ID = 7, '"', '') + '[V' + CONVERT(NVARCHAR(10), CGSV.ID) + ']' + IIF(CVT.EFType IN ('String', 'DateTime') OR CVT.ID = 7, '"', '') + '},' FROM Campo_GoogleSheets_Variavel CGSV LEFT JOIN Campo CV ON CGSV.ID_CampoVariavel = CV.ID AND CGSV.Fixo = 'False' LEFT JOIN CampoFixo2 CFV ON CGSV.ID_CampoVariavel = CFV.ID AND CGSV.Fixo = 'True' LEFT JOIN Campo_Tipo CVT ON ISNULL(CV.ID_Tipo, CFV.ID_Tipo) = CVT.ID WHERE CGSV.ID_Integracao = CGS.ID For XML PATH, TYPE).value('.[1]', 'NVARCHAR(MAX)') + ']}') AS FormulaExternaRequestBody,
	   CGS.ID AS ID_Integracao_GoogleSheets,
	   C.Bloqueado,
       C.Oculto,
       C.Integracao,
       C.IntegrationCustomFieldId,
       IIF(C.ID_Tipo = 7 AND C.ID_TabelaEstrangeira IS NOT NULL, 'Fields@OptionsTables@Options', NULL) AS ApiUrl,
	   NULL AS PropertyName, 
       NULL AS UpdatePropertyName, 
       CONVERT(BIT, 0) AS DisplayProperty, 
       C.AutoParagraph,
	   CONVERT(BIT, CASE
						WHEN C.ID_Tipo = 19 AND C.IsMobileEdit = 1 THEN 0
						WHEN C.ID_Tipo = 22 THEN 0
						ELSE 1
					END) AS Editavel, 
       IIF(C.ID_Tipo = 7 AND C.ID_TabelaEstrangeira IS NOT NULL,'OtherOptionsCreatePermission', CT.OptionsCreationPermissionPropertyName) AS PermissaoCriacaoOpcoes,
       IIF(C.ID_TipoItem = 2, C.ID_Item, NULL) AS ID_ProdutoGrupo,
	   IIF(C.ID_TipoItem = 3, C.ID_Item, NULL) AS ID_ProdutoFamilia,
	   C.ValorTextoPadrao, 
       C.ValorTextoMultilinhaPadrao, 
       C.ValorInteiroPadrao, 
       C.ValorDecimalPadrao,
	   C.ValorDataHoraPadrao,
       C.ValorBooleanoPadrao, 
       ISNULL(CO.Chave, CFO.Chave) AS Chave_CampoOrigem, 
       ISNULL(CVn.ID_Caminho, CTC.ID) AS ID_Caminho_CampoOrigem,
	   C.FormulaEditor, 
       C.UseCheckbox, 
       C.FilterId,
	   /*CONVERT(BIT, 1) as EditaValor,
	   NULL AS [Label],
	   CONVERT(BIT, 1) as [Hidden],*/
       CONVERT(BIT, CASE WHEN U.ID_Perfil = 1 THEN 1
                                              WHEN NOT EXISTS(SELECT 1 FROM Campo_Permissao_Usuario WHERE ID_Campo = C.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 0)
                                                   AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_Equipe WHERE ID_Campo = C.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 0)
                                                   AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_PerfilUsuario WHERE ID_Campo = C.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 0) THEN 1
                                              WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Usuario WHERE ID_Campo = C.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 0 AND ID_Usuario = U.ID) THEN 1
                                              WHEN EXISTS(SELECT 1 FROM Campo_Permissao_PerfilUsuario WHERE ID_Campo = C.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 0 AND ID_Perfil = U.ID_Perfil) THEN 1
                                              WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Equipe PE INNER JOIN Equipe_Usuario EU ON PE.ID_Campo = C.ID AND PE.ID_ClientePloomes = U.ID_ClientePloomes AND PE.Fixo = 0 AND PE.ID_Equipe = EU.ID_Equipe AND EU.ID_Usuario = U.ID) THEN 1
                                              ELSE 0
                                         END) AS EditaValor,
        C.[Label],
		CONVERT(BIT, CASE WHEN U.ID_Perfil = 1 THEN 0
                                               WHEN NOT EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_User CPU WHERE CPU.FieldId = C.ID AND CPU.AccountId = U.ID_ClientePloomes AND CPU.FieldFixed = 0)
                                               	    AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_Team CPT WHERE CPT.FieldId = C.ID AND CPT.AccountId = U.ID_ClientePloomes AND CPT.FieldFixed = 0)
                                               	    AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_UserProfile CPP WHERE CPP.FieldId = C.ID AND CPP.AccountId = U.ID_ClientePloomes AND CPP.FieldFixed = 0) THEN 0
                                               WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_User CPU WHERE CPU.FieldId = C.ID AND CPU.AccountId = U.ID_ClientePloomes AND CPU.FieldFixed = 0 AND CPU.UserId = U.ID) THEN 0
                                               WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_UserProfile CPP WHERE CPP.FieldId = C.ID AND CPP.AccountId = U.ID_ClientePloomes AND CPP.FieldFixed = 0 AND CPP.ProfileId = U.ID_Perfil) THEN 0
                                               WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_Team CPT INNER JOIN Equipe_Usuario EU ON CPT.FieldId = C.ID AND CPT.AccountId = U.ID_ClientePloomes AND CPT.FieldFixed = 0 AND CPT.TeamId = EU.ID_Equipe AND EU.ID_Usuario = U.ID) THEN 0
                                               ELSE 1
                                          END) AS [Hidden],
		U.ID as ID_Usuario,
		C.FieldHideFormula,
		C.FieldDisableFormula,
		C.InlineEditTriggerDocumentGeneration,
		C.IsSensitiveData,
		C.ShowTime,
		C.IsMobileEdit,
		C.UseAttachmentUrl,
		C.ClearOnDefaultCrud,
		C.ExternalListUrl,
        NULL as InversePropertyFieldKey,
		C.SendExternalKey,
		C.ReceiveExternalKey,
		C.EnableFormatting
   FROM Field F 
  INNER JOIN Usuario U ON F.AccountId = U.ID_ClientePloomes
   INNER JOIN Campo C ON F.FieldId = C.ID AND F.[Dynamic] = 1 AND C.Suspenso = 'False'
   LEFT JOIN Campo_Language CL ON CL.FieldId = C.ID AND CL.LanguageId = U.LanguageId
   LEFT JOIN Campo_GoogleSheets CGS ON C.ID = CGS.ID_Campo
   LEFT JOIN Campo_Vinculo CVn ON CVn.ID_CampoDestino = C.ID AND CVn.Fixo_CampoDestino = 'False'
   LEFT JOIN Campo CO ON CVn.ID_CampoOrigem = CO.ID AND CVn.Fixo_CampoOrigem = 'False'
   LEFT JOIN CampoFixo2 CFO ON CVn.ID_CampoOrigem = CFO.ID AND CVn.Fixo_CampoOrigem = 'True'
   LEFT JOIN Campo_Tabela_Caminho CTC ON CTC.ID_TabelaOrigem = C.ID_Tabela AND CTC.ID_TabelaDestino = ISNULL(CO.ID_Tabela, CFO.ID_Tabela) AND CTC.Padrao = 'True'
   LEFT JOIN Campo_Tabela CT ON CT.ID = C.ID_TabelaEstrangeiraFixa


UNION ALL


SELECT F.FieldId as ID, 
       F.[Key] as Chave, 
       F.[Dynamic] as Dinamico, 
       ISNULL(CFCA.Name, CFC.Descricao) as Descricao,
       CF.ID_Tabela, 
       CF.ID_Tipo,
	    NULL AS ID_TabelaEstrangeira,
       CF.ID_TabelaEstrangeiraFixa, 
       CF.Multiplo,
       CF.StringLength,
       ISNULL(CFCP.Obrigatorio, CF.Obrigatorio) AS Obrigatorio,
       CF.NaoNulavel, 
       CONVERT(BIT, IIF(CF.Obrigatorio = 'True' AND CF.NaoNulavel = 'True', 1, 0)) AS Permanente, 
       ISNULL(CFCP.Unico, CF.Unico) AS Unico,
       CF.Filtro AS Filtro,
       ISNULL(CFCP.FiltroFormulario, CF.FiltroFormulario) AS FiltroFormulario, 
       CF.PulaTabelaIntermediaria, 
       CF.Importavel, 
       ISNULL(CFCP.Expandido, CONVERT(BIT, IIF(CF.ID_Tipo = 2, 1, 0))) AS Expandido, 
       ISNULL(CFCP.ColumnSize, CF.ColumnSize) AS ColumnSize,
       ISNULL(CFCPF.Formula, CF.Formula) AS Formula,
       CFCPF.ExternalFormulaUrl AS FormulaExternaUrl,
       CFCPF.ExternalFormulaMethod AS FormulaExternaMethod, 
       CFCPF.ExternalFormulaHeaders AS FormulaExternaHeaders,
       CFCPF.ExternalFormulaRequestBody AS FormulaExternaRequestBody,
	   NULL AS ID_Integracao_GoogleSheets,
	   ISNULL(CFCP.Bloqueado, CONVERT(BIT, 0)) AS Bloqueado,
       ISNULL(CFCP.Oculto, CONVERT(BIT, 0)) AS Oculto,
       CONVERT(BIT, 0) AS Integracao,
       NULL AS IntegrationCustomFieldId,
       CF.ApiUrl,
	   CF.PropertyName, 
       CF.UpdatePropertyName, 
       CF.DisplayProperty, 
       CONVERT(BIT, 1) AS AutoParagraph,
	   CF.Editavel, 
       CT.OptionsCreationPermissionPropertyName AS PermissaoCriacaoOpcoes, 
       NULL AS ID_ProdutoGrupo,
	   NULL AS ID_ProdutoFamilia,
	   NULL AS ValorTextoPadrao, 
       NULL AS ValorTextoMultilinhaPadrao, 
       NULL AS ValorInteiroPadrao, 
       NULL AS ValorDecimalPadrao,
	   NULL AS ValorDataHoraPadrao,
       NULL AS ValorBooleanoPadrao, 
       ISNULL(CFCO.Chave, CFCFO.Chave) AS Chave_CampoOrigem, 
       ISNULL(CFCVn.ID_Caminho, CFCTC.ID) AS ID_Caminho_CampoOrigem,
	   CONVERT(BIT, ISNULL(CFCP.FormulaEditor, 0)) AS FormulaEditor, 
       CFCP.UseCheckbox, 
       CFCP.FilterId,
	   /*CONVERT(BIT, 1) as EditaValor,
	   NULL AS [Label],
	   CONVERT(BIT, 1) as [Hidden],*/
       CONVERT(BIT, CASE WHEN U.ID_Perfil = 1 THEN 1
                                              WHEN NOT EXISTS(SELECT 1 FROM Campo_Permissao_Usuario WHERE ID_Campo = CF.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 1)
                                                   AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_Equipe WHERE ID_Campo = CF.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 1)
                                                   AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_PerfilUsuario WHERE ID_Campo = CF.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 1) THEN 1
                                              WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Usuario WHERE ID_Campo = CF.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 1 AND ID_Usuario = U.ID) THEN 1
                                              WHEN EXISTS(SELECT 1 FROM Campo_Permissao_PerfilUsuario WHERE ID_Campo = CF.ID AND ID_ClientePloomes = U.ID_ClientePloomes AND Fixo = 1 AND ID_Perfil = U.ID_Perfil) THEN 1
                                              WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Equipe PE INNER JOIN Equipe_Usuario EU ON PE.ID_Campo = CF.ID AND PE.Fixo = 1 AND PE.ID_ClientePloomes = U.ID_ClientePloomes AND PE.ID_Equipe = EU.ID_Equipe AND EU.ID_Usuario = U.ID) THEN 1
                                              ELSE 0
	                                     END) AS EditaValor,
        NULL AS [Label],
		CONVERT(BIT, CASE WHEN U.ID_Perfil = 1 THEN 0
                                               WHEN NOT EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_User CPU WHERE CPU.FieldId = CF.ID AND CPU.AccountId = U.ID_ClientePloomes AND CPU.FieldFixed = 1)
                                               	    AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_Team CPT WHERE CPT.FieldId = CF.ID AND CPT.AccountId = U.ID_ClientePloomes AND CPT.FieldFixed = 1)
                                               	    AND NOT EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_UserProfile CPP WHERE CPP.FieldId = CF.ID AND CPP.AccountId = U.ID_ClientePloomes AND CPP.FieldFixed = 1) THEN 0
                                               WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_User WHERE FieldId = CF.ID AND AccountId = U.ID_ClientePloomes AND FieldFixed = 1 AND UserId = U.ID) THEN 0
                                               WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_UserProfile WHERE FieldId = CF.ID AND AccountId = U.ID_ClientePloomes AND FieldFixed = 1 AND ProfileId = U.ID_Perfil) THEN 0
                                               WHEN EXISTS(SELECT 1 FROM Campo_Permissao_Exhibition_Team CPT INNER JOIN Equipe_Usuario EU ON CPT.FieldId = CF.ID AND CPT.AccountId = U.ID_ClientePloomes AND CPT.FieldFixed = 1 AND CPT.TeamId = EU.ID_Equipe AND EU.ID_Usuario = U.ID) THEN 0
                                               ELSE 1
                                          END) AS [Hidden],
		U.ID as ID_Usuario,
		CFCPF.FieldHideFormula,
		CFCPF.FieldDisableFormula,
		CF.InlineEditTriggerDocumentGeneration,
		NULL as IsSensitiveData,
		NULL as ShowTime,
		NULL as IsMobileEdit,
		NULL as UseAttachmentUrl,
		CONVERT(BIT, 0) as ClearOnDefaultCrud,
		NULL as ExternalListUrl,
        CF.InversePropertyFieldKey,
		CFCP.SendExternalKey,
		CFCP.ReceiveExternalKey,
		CFCP.EnableFormatting
   FROM Field F 
  INNER JOIN Usuario U ON F.AccountId = U.ID_ClientePloomes
   INNER JOIN CampoFixo2 CF ON F.FieldId = CF.ID AND F.[Dynamic] = 0
   LEFT JOIN CampoFixo2_Cultura CFC ON CF.ID = CFC.ID_Campo AND CFC.Cultura = U.Cultura
   LEFT JOIN CampoFixo2_Cultura_Account CFCA ON CFCA.FieldLanguageId = CFC.ID AND U.ID_ClientePloomes = CFCA.AccountId AND U.LanguageId = CFCA.LanguageId
   LEFT JOIN CampoFixo2_ClientePloomes CFCP ON CFCP.ID_ClientePloomes = U.ID_ClientePloomes AND CFCP.ID_Campo = CF.ID 
   LEFT JOIN CampoFixo2_ClientePloomes_Formula CFCPF ON CFCPF.ID_ClientePloomes = U.ID_ClientePloomes AND CFCPF.ID_Campo = CF.ID
   LEFT JOIN Campo_Vinculo CFCVn ON CFCVn.ID_CampoDestino = CF.ID AND CFCVn.Fixo_CampoDestino = 'True' AND CFCVn.ID_ClientePloomes = U.ID_ClientePloomes
   LEFT JOIN CampoFixo2_Vinculo CFVn ON CFVn.ID_CampoDestino = CF.ID
   LEFT JOIN Campo CFCO ON CFCVn.ID_CampoOrigem = CFCO.ID AND CFCVn.Fixo_CampoOrigem = 'False'
   LEFT JOIN CampoFixo2 CFCFO ON CFCVn.ID_CampoOrigem = CFCFO.ID AND CFCVn.Fixo_CampoOrigem = 'True' OR CFVn.ID_CampoOrigem = CFCFO.ID AND CFCVn.ID IS NULL
   LEFT JOIN Campo_Tabela_Caminho CFCTC ON CFCTC.ID_TabelaOrigem = CF.ID_Tabela AND CFCTC.ID_TabelaDestino = ISNULL(CFCO.ID_Tabela, CFCFO.ID_Tabela) AND CFCTC.Padrao = 'True'
   LEFT JOIN Campo_Tabela CT ON CT.ID = CF.ID_TabelaEstrangeiraFixa
GO

DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)