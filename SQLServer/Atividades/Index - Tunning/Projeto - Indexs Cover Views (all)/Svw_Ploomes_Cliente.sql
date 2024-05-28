--Text
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CREATE VIEW [dbo].[SVw_Ploomes_Cliente] AS

	SELECT PC.*, 
	CONVERT(BIT, IIF(EXISTS(SELECT 1 FROM RegraNegocio WHERE ID_ClientePloomes = PC.ID AND Suspenso = 'False'), 1, 0)) as RegrasNegocio,
	ISNULL((SELECT MAX(C.Codigo) FROM Cotacao C INNER JOIN Oportunidade O ON C.ID_Oportunidade = O.ID WHERE C.Suspenso = 'False' AND O.ID_ClientePloomes = PC.ID), 0) + 1 as ProximoCodigoProposta,
	ISNULL((SELECT MAX(V.Codigo) FROM Venda V WHERE V.Suspenso = 'False' AND V.ID_ClientePloomes = PC.ID), 0) + 1 as ProximoCodigoVenda,
	ISNULL((SELECT MAX(D.DocumentNumber) FROM Document D WHERE D.Suspended = 'False' AND D.AccountId = PC.ID), 0) + 1 as ProximoCodigoDocumento,
	(SELECT TOP 1 ID FROM Integracao_TotalVoice WHERE ID_ClientePloomes = PC.ID AND Suspenso = 'False') as ID_TotalVoiceIntegracao,
	(SELECT TOP 1 IEM.ID FROM Integracao_EmailMkt IEM INNER JOIN Integracao_EmailMkt_Sistema IEMS ON IEM.ID = IEMS.ID_Integracao_EmailMkt WHERE IEM.ID_ClientePloomes = PC.ID AND IEM.ID_Sistema = 1 AND IEMS.Suspenso = 'False') as ID_IntegracaoMailChimp,
	(SELECT TOP 1 ID FROM Integracao_Nutricao_Lead WHERE ID_ClientePloomes = PC.ID) as ID_IntegracaoRDStation,
	(SELECT TOP 1 ID FROM Integracao_Reev WHERE AccountId = PC.ID) as ID_IntegracaoReev,
	(SELECT TOP 1 ID FROM Integracao_Jivo WHERE AccountId = PC.ID) as ID_IntegracaoJivo,

			CONVERT(BIT, IIF(PC.ID_Criador = U.ID, PC.ConfiguracoesIniciais, 1)) as ConfiguracoesIniciais2,
			PC.Oportunidades as DealsModule, E2.SingularUnitName as DealsModuleSingularUnitName, E2.PluralUnitName as DealsModulePluralUnitName, 
			E2.GenderId as DealsModuleGenderId,E44.SingularUnitName as DealsPipelinesModuleSingularUnitName, E44.PluralUnitName as DealsPipelinesModulePluralUnitName, E44.GenderId as DealsPipelinesModuleGenderId,
			E75.SingularUnitName as ContactsProductsModuleSingularUnitName, E75.PluralUnitName as ContactsProductsModulePluralUnitName, E75.GenderId as ContactsProductsModuleGenderId,			
			PC2.Nome_Pagamento as P_Nome_Pagamento, PC2.RazaoSocial_Pagamento as P_RazaoSocial_Pagamento, PC2.Endereco_Pagamento as P_Endereco_Pagamento, PC2.Endereco_Numero_Pagamento as P_Endereco_Numero_Pagamento,
			PC2.Endereco_Complemento_Pagamento as P_Endereco_Complemento_Pagamento, PC2.Endereco_Bairro_Pagamento as P_Endereco_Bairro_Pagamento, PC2.CEP_Pagamento as P_CEP_Pagamento,
			PC2.ID_Cidade_Pagamento as P_ID_Cidade_Pagamento,
			PC2.CPF_Pagamento as P_CPF_Pagamento, PC2.CNPJ_Pagamento as P_CNPJ_Pagamento, PC2.MetodoPagamento as P_MetodoPagamento, 
			PC2.Email_Pagamento as P_Email_Pagamento, PC2.Plano_Desconto as P_Plano_Desconto,
			PC2.PeriodoContratacao as P_PeriodoContratacao, PC2.Valor_UltimoPagamento as P_Valor_UltimoPagamento,
			PC2.Valor_PagamentoAdicional as P_Valor_PagamentoAdicional,
			PC2.DiasDebito_Pagamento as P_DiasDebito_Pagamento, PC2.ID_PagarMe_Debito_Pagamento as P_ID_PagarMe_Debito_Pagamento,
			PC2.DataInicioCobranca as P_DataInicioCobranca, PC2.DataProximaFatura as P_DataProximaFatura, PC2.UsuariosCobrados, 
			CONVERT(DECIMAL(18,2), IIF(PC.MinUsuarios_Pagamento <= PC2.UsuariosCobrados AND PC2.Valor_UltimoPagamento < PC2.UsuariosCobrados * PC2.ValorUsuario + PC2.ValorProrataUsuario , PC2.ValorProrataUsuario, 0)) as ValorProrataUsuario,
			U.ID as ID_Usuario,
			E97.SingularUnitName as LibraryModuleSingularUnitName, E97.PluralUnitName as LibraryModulePluralUnitName, E97.GenderId as LibraryModuleGenderId,
			E96.SingularUnitName as AttachmentCollectionsModuleSingularUnitName, E96.PluralUnitName as AttachmentCollectionsModulePluralUnitName, E96.GenderId as AttachmentCollectionsModuleGenderId
		FROM Ploomes_Cliente PC 
		INNER JOIN Usuario U ON PC.ID = U.ID_ClientePloomes -- Usando IX_Usuario_ID_ClientePloomes
		LEFT JOIN Campo_Tabela_ClientePloomes E2  ON PC.ID = E2.ID_ClientePloomes AND E2.ID_Tabela = 2
		LEFT JOIN Campo_Tabela_ClientePloomes E44 ON PC.ID = E44.ID_ClientePloomes AND E44.ID_Tabela = 44
		LEFT JOIN Campo_Tabela_ClientePloomes E75 ON PC.ID = E75.ID_ClientePloomes AND E75.ID_Tabela = 75
		LEFT JOIN Campo_Tabela_ClientePloomes E97 ON PC.ID = E97.ID_ClientePloomes AND E97.ID_Tabela = 97
		LEFT JOIN Campo_Tabela_ClientePloomes E96 ON PC.ID = E96.ID_ClientePloomes AND E96.ID_Tabela = 96
		LEFT JOIN (
			SELECT PC2.ID, PC2.Nome_Pagamento, PC2.RazaoSocial_Pagamento, PC2.Endereco_Pagamento, PC2.Endereco_Numero_Pagamento, PC2.Endereco_Complemento_Pagamento,
					PC2.Endereco_Bairro_Pagamento, PC2.CEP_Pagamento, PC2.ID_Cidade_Pagamento, PC2.CPF_Pagamento, PC2.CNPJ_Pagamento, PC2.MetodoPagamento,
					PC2.Email_Pagamento, PC2.Plano_Desconto, PC2.PeriodoContratacao, PC2.Valor_UltimoPagamento, PC2.Valor_PagamentoAdicional,
					PC2.DiasDebito_Pagamento, PC2.ID_PagarMe_Debito_Pagamento,
					PC2.DataInicioCobranca, PC2.DataProximaFatura, PP.Valor_Usuario * ((100 - PC2.Plano_Desconto) / 100) as ValorUsuario,
					(SELECT COUNT(1) FROM Usuario WHERE ID_ClientePloomes = PC2.ID AND Suspenso = 'False' AND Cortesia = 'False') as UsuariosCobrados,
					CONVERT(DECIMAL(18,2), ISNULL(DATEDIFF(day, IIF(GETDATE() > PC2.DataInicioCobranca, GETDATE(), PC2.DataInicioCobranca), PC2.DataProximaFatura) * PC2.PeriodoContratacao * PP.Valor_Usuario * ((100 - PC2.Plano_Desconto) / 100) / DATEDIFF(day, PC2.DataInicioCobranca, PC2.DataProximaFatura), 0)) as ValorProrataUsuario
				FROM Ploomes_Cliente PC2 LEFT JOIN Ploomes_Plano PP ON PC2.ID_Plano = PP.ID
		) as PC2 ON PC.ID = PC2.ID AND U.ID_Perfil = 1

--sp_helpIndex 'Ploomes_Cliente'
Create Index IX_Ploomes_Cliente_SVw_Ploomes_Cliente01 on Ploomes_Cliente (ID, ID_Plano) on [INDEX]


SELECT 1 FROM RegraNegocio WHERE ID_ClientePloomes = 32 AND Suspenso = 'False'
--sp_helpIndex 'RegraNegocio'
Create Index IX_RegraNegocio_SVw_Ploomes_Cliente01 on RegraNegocio (ID_ClientePloomes, Suspenso) on [INDEX]


SELECT MAX(C.Codigo) FROM Cotacao C INNER JOIN Oportunidade O ON C.ID_Oportunidade = O.ID WHERE C.Suspenso = 'False' AND O.ID_ClientePloomes = 1
--sp_helpIndex 'Cotacao'
--sp_helpIndex 'Oportunidade'
Create Index IX_Cotacao_SVw_Ploomes_Cliente01 on Cotacao (ID_Oportunidade, Suspenso) include (Codigo) on [INDEX]
Create Index IX_Oportunidade_SVw_Ploomes_Cliente01 on Oportunidade (ID, ID_ClientePloomes) on [INDEX]


SELECT MAX(V.Codigo) FROM Venda V WHERE V.Suspenso = 'False' AND V.ID_ClientePloomes = 32
--sp_helpIndex 'Venda'
Create Index IX_Venda_SVw_Ploomes_Cliente01 on Venda (Suspenso, ID_ClientePloomes) include (Codigo) on [INDEX]

SELECT MAX(D.DocumentNumber) FROM Document D WHERE D.Suspended = 'False' AND D.AccountId = PC.ID
--sp_helpIndex 'Document'
Create Index IX_Document_SVw_Ploomes_Cliente01 on Document (Suspended, AccountId) include (DocumentNumber) on [INDEX]


SELECT TOP 1 ID FROM Integracao_TotalVoice WHERE ID_ClientePloomes = 32 AND Suspenso = 'False'
--sp_helpIndex 'Integracao_TotalVoice'
Create Index IX_Integracao_TotalVoice_SVw_Ploomes_Cliente01 on Integracao_TotalVoice (ID_ClientePloomes, Suspenso) include (ID) on [INDEX]


SELECT TOP 1 IEM.ID 
FROM Integracao_EmailMkt IEM 
INNER JOIN Integracao_EmailMkt_Sistema IEMS ON IEM.ID = IEMS.ID_Integracao_EmailMkt 
WHERE IEM.ID_ClientePloomes = 32 AND IEM.ID_Sistema = 1 AND IEMS.Suspenso = 'False'
--sp_helpIndex 'Integracao_EmailMkt'
--sp_helpIndex 'Integracao_EmailMkt_Sistema'

Create Index IX_Integracao_EmailMkt_SVw_Ploomes_Cliente01 on Integracao_EmailMkt (ID, ID_ClientePloomes, ID_Sistema) include (ID) on [INDEX]
Create Index IX_Integracao_EmailMkt_Sistema_SVw_Ploomes_Cliente01 on Integracao_EmailMkt_Sistema (ID_Integracao_EmailMkt, Suspenso) on [INDEX]


SELECT COUNT(1) FROM Usuario WHERE ID_ClientePloomes = 96 AND Suspenso = 'False' AND Cortesia = 'False'
--sp_helpIndex 'Usuario'
Create Index IX_Usuario_SVw_Ploomes_Cliente01 on Usuario (ID_ClientePloomes, Suspenso, Cortesia) on [INDEX]



-- Não precisa. 
SELECT TOP 1 ID FROM Integracao_Nutricao_Lead WHERE ID_ClientePloomes = 12
--sp_helpIndex 'Integracao_Nutricao_Lead'
SELECT TOP 1 ID FROM Integracao_Reev WHERE AccountId = 32
SELECT TOP 1 ID FROM Integracao_Jivo WHERE AccountId = 32

--sp_helpIndex 'Integracao_Reev'
--sp_helpIndex 'Integracao_Jivo'




