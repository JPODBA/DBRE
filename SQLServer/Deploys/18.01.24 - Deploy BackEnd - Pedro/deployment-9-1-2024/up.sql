/*
    Script de subida do deployment-9-1-2024
*/
USE Ploomes_CRM
GO

-- up 1
-- https://app.asana.com/0/626405171214145/1206120410738299/f
ALTER TABLE Ploomes_Cliente
ADD WhiteLabelName [nvarchar](100) COLLATE Latin1_General_CI_AI NULL
GO

-- up 2
-- https://app.asana.com/0/1177167803525649/1204440597237062/f
ALTER TABLE Cliente ADD [LastInteractionRecordId] [int] NULL
ALTER TABLE Cliente ADD [LastOrderId] [int] NULL
ALTER TABLE Cliente ADD [LastDocumentId] [int] NULL
ALTER TABLE Cliente ADD [LastDealId] [int] NULL
GO

ALTER VIEW [dbo].[DVw_Cliente] AS
	SELECT C.*, Cd.ID_UF, Cd.ID_Pais,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', '') as Registro,
		IIF(C.ID_Tipo = 1, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', ''), NULL) as CNPJFiltro,
		IIF(C.ID_Tipo = 2, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', ''), NULL) as CPFFiltro,
		ISNULL(C.DataAtualizacao, C.DataCriacao) as UltimaAtualizacao,
		NULL as ID_PrimeiraTarefa,
		(CASE
			WHEN C.LastInteractionRecordId IS NULL THEN (SELECT TOP 1 R.ID FROM Relatorio R WHERE R.ID_Cliente = C.ID AND R.Suspenso = 'False' ORDER BY R.ID DESC)
			ELSE C.LastInteractionRecordId END) as ID_UltimoRelatorio,
		(CASE
			WHEN C.LastOrderId IS NULL THEN (SELECT TOP 1 V.ID FROM Venda V WHERE V.ID_Cliente = C.ID AND V.Suspenso = 'False' ORDER BY V.ID DESC)
			ELSE C.LastOrderId END) as ID_UltimaVenda,
		(CASE
			WHEN C.LastDealId IS NULL THEN (SELECT TOP 1 O.ID FROM Oportunidade O WHERE O.ID_Cliente = C.ID AND O.Suspenso = 'False' ORDER BY O.ID DESC)
			ELSE C.LastDealId END) as ID_UltimaOportunidade,
		(CASE
			WHEN C.LastDocumentId IS NULL THEN (SELECT TOP 1 D.ID FROM Document D WHERE D.ContactId = C.ID AND D.Suspended = 'False' ORDER BY D.ID DESC)
			ELSE C.LastDocumentId END) as ID_UltimoDocumento,
		CONVERT(BIT, CASE
			WHEN P.Cliente_Edita = 1
				THEN 1
			WHEN P.Cliente_Edita BETWEEN 2 AND 3
					AND C.ID_Responsavel = U.ID
				THEN 1
			WHEN P.Cliente_Edita BETWEEN 2 AND 3
					AND EXISTS(SELECT 1 FROM Cliente_Colaborador_Usuario WHERE ID_Cliente = C.ID AND ID_Usuario = U.ID)
				THEN 1
			WHEN P.Cliente_Edita = 2
					AND EXISTS (
						SELECT 1
							FROM Equipe_Usuario EU
							WHERE EU.ID_Usuario = U.ID
								AND EXISTS(
									SELECT 1
										FROM Equipe_Usuario
										WHERE ID_Equipe = EU.ID_Equipe
											AND ID_Usuario = C.ID_Responsavel
								)
					)
				THEN 1
			ELSE 0
		END) as Edita,
		CONVERT(BIT, CASE
			WHEN P.Cliente_Exclui = 1
				THEN 1
			WHEN P.Cliente_Exclui BETWEEN 2 AND 3
					AND C.ID_Responsavel = U.ID
				THEN 1
			WHEN P.Cliente_Exclui BETWEEN 2 AND 3
					AND EXISTS(SELECT 1 FROM Cliente_Colaborador_Usuario WHERE ID_Cliente = C.ID AND ID_Usuario = U.ID)
				THEN 1
			WHEN P.Cliente_Exclui = 2
					AND EXISTS (
						SELECT 1
							FROM Equipe_Usuario EU
							WHERE EU.ID_Usuario = U.ID
								AND EXISTS(
									SELECT 1
										FROM Equipe_Usuario
										WHERE ID_Equipe = EU.ID_Equipe
											AND ID_Usuario = C.ID_Responsavel
								)
					)
				THEN 1
			ELSE 0
		END) as Exclui,
		U.ID as ID_Usuario,
		IIF(CONVERT(DATE, DATEADD(YEAR,(DATEDIFF(YEAR,C.DataFundacao,GETDATE())),C.DataFundacao)) >= CONVERT(DATE,GETDATE()),DATEADD(YEAR,(DATEDIFF(YEAR,C.DataFundacao,GETDATE()) - 1),C.DataFundacao),DATEADD(YEAR,(DATEDIFF(YEAR,C.DataFundacao,GETDATE())),C.DataFundacao) ) AS PreviousAnniversary,
		IIF(CONVERT(DATE,DATEADD(YEAR,(DATEDIFF(YEAR,C.DataFundacao,GETDATE())),C.DataFundacao)) >= CONVERT(DATE,GETDATE()),DATEADD(YEAR,(DATEDIFF(YEAR,C.DataFundacao,GETDATE())),C.DataFundacao),DATEADD(YEAR,(DATEDIFF(YEAR,C.DataFundacao,GETDATE()))+1,C.DataFundacao) ) AS NextAnniversary
		FROM Cliente C INNER JOIN Usuario U ON C.ID_ClientePloomes = U.ID_ClientePloomes
			INNER JOIN (
				SELECT C.ID, C.ID_ClientePloomes, UR.ID_Usuario
					FROM Cliente C INNER JOIN Usuario_Responsavel UR ON ISNULL(C.ID_Responsavel, 0) = UR.ID_Responsavel AND UR.ID_Tipo = 1

				UNION

				SELECT C.ID, C.ID_ClientePloomes, CCU.ID_Usuario
					FROM Cliente C INNER JOIN Cliente_Colaborador_Usuario CCU ON C.ID = CCU.ID_Cliente
			) as C1 ON C.ID = C1.ID AND C1.ID_Usuario = U.ID AND C.ID_ClientePloomes = C1.ID_ClientePloomes
			LEFT JOIN Usuario_Perfil P ON U.ID_Perfil = P.ID
			LEFT JOIN Cidade Cd ON C.ID_Cidade = Cd.ID
		WHERE C.Suspenso = 'True'
GO

ALTER VIEW [dbo].[SVw_Cliente] AS
	SELECT C.*, Cd.ID_UF, Cd.ID_Pais,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', '') as Registro,
		IIF(C.ID_Tipo = 1, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', ''), NULL) as CNPJFiltro,
		IIF(C.ID_Tipo = 2, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', ''), NULL) as CPFFiltro,
		ISNULL(C.DataAtualizacao, C.DataCriacao) as UltimaAtualizacao,
		NULL as ID_PrimeiraTarefa,
		CONVERT(BIT, IIF(C.Data_PrimeiraTarefa IS NOT NULL, 1, 0)) as HasScheduledTasks,
		(CASE 
			WHEN C.LastInteractionRecordId IS NULL THEN (SELECT TOP 1 R.ID FROM Relatorio R WHERE R.ID_Cliente = C.ID AND R.Suspenso = 'False' ORDER BY R.ID DESC)
			ELSE C.LastInteractionRecordId END) as ID_UltimoRelatorio,
		(CASE
			WHEN C.LastOrderId IS NULL THEN (SELECT TOP 1 V.ID FROM Venda V WHERE V.ID_Cliente = C.ID AND V.Suspenso = 'False' ORDER BY V.ID DESC)
			ELSE C.LastOrderId END) as ID_UltimaVenda,
		(CASE
			WHEN C.LastDealId IS NULL THEN (SELECT TOP 1 O.ID FROM Oportunidade O WHERE O.ID_Cliente = C.ID AND O.Suspenso = 'False' ORDER BY O.ID DESC)
			ELSE C.LastDealId END) as ID_UltimaOportunidade,
		(CASE
			WHEN C.LastDocumentId IS NULL THEN (SELECT TOP 1 D.ID FROM Document D WHERE D.ContactId = C.ID AND D.Suspended = 'False' ORDER BY D.ID DESC)
			ELSE C.LastDocumentId END) as ID_UltimoDocumento,
		CONVERT(BIT, CASE
			WHEN P.Cliente_Edita = 1
				THEN 1
			WHEN P.Cliente_Edita BETWEEN 2 AND 3
					AND C.ID_Responsavel = U.ID
				THEN 1
			WHEN P.Cliente_Edita BETWEEN 2 AND 3
					AND EXISTS(SELECT 1 FROM Cliente_Colaborador_Usuario WHERE ID_Cliente = C.ID AND ID_Usuario = U.ID)
				THEN 1
			WHEN P.Cliente_Edita = 2
					AND EXISTS (
						SELECT 1
							FROM Equipe_Usuario EU
							WHERE EU.ID_Usuario = U.ID
								AND EXISTS(
									SELECT 1
										FROM Equipe_Usuario
										WHERE ID_Equipe = EU.ID_Equipe
											AND ID_Usuario = C.ID_Responsavel
								)
					)
				THEN 1
			ELSE 0
		END) as Edita,
		CONVERT(BIT, CASE
			WHEN P.Cliente_Exclui = 1
				THEN 1
			WHEN P.Cliente_Exclui BETWEEN 2 AND 3
					AND C.ID_Responsavel = U.ID
				THEN 1
			WHEN P.Cliente_Exclui BETWEEN 2 AND 3
					AND EXISTS(SELECT 1 FROM Cliente_Colaborador_Usuario WHERE ID_Cliente = C.ID AND ID_Usuario = U.ID)
				THEN 1
			WHEN P.Cliente_Exclui = 2
					AND EXISTS (
						SELECT 1
							FROM Equipe_Usuario EU
							WHERE EU.ID_Usuario = U.ID
								AND EXISTS(
									SELECT 1
										FROM Equipe_Usuario
										WHERE ID_Equipe = EU.ID_Equipe
											AND ID_Usuario = C.ID_Responsavel
								)
					)
				THEN 1
			ELSE 0
		END) as Exclui,
		U.ID as ID_Usuario,
		IIF(CONVERT(DATE, DATEADD(YEAR,(DATEDIFF(YEAR,C.DataFundacao,GETDATE())),C.DataFundacao)) >= CONVERT(DATE,GETDATE()),DATEADD(YEAR,(DATEDIFF(YEAR,C.DataFundacao,GETDATE()) - 1),C.DataFundacao),DATEADD(YEAR,(DATEDIFF(YEAR,C.DataFundacao,GETDATE())),C.DataFundacao) ) AS PreviousAnniversary,
		IIF(CONVERT(DATE,DATEADD(YEAR,(DATEDIFF(YEAR,C.DataFundacao,GETDATE())),C.DataFundacao)) >= CONVERT(DATE,GETDATE()),DATEADD(YEAR,(DATEDIFF(YEAR,C.DataFundacao,GETDATE())),C.DataFundacao),DATEADD(YEAR,(DATEDIFF(YEAR,C.DataFundacao,GETDATE()))+1,C.DataFundacao) ) AS NextAnniversary
		FROM Cliente C INNER JOIN Usuario U ON C.ID_ClientePloomes = U.ID_ClientePloomes
			INNER JOIN (
				SELECT C.ID, C.ID_ClientePloomes, UR.ID_Usuario
					FROM Cliente C INNER JOIN Usuario_Responsavel UR ON ISNULL(C.ID_Responsavel, 0) = UR.ID_Responsavel AND UR.ID_Tipo = 1

				UNION

				SELECT C.ID, C.ID_ClientePloomes, CCU.ID_Usuario
					FROM Cliente C INNER JOIN Cliente_Colaborador_Usuario CCU ON C.ID = CCU.ID_Cliente
			) as C1 ON C.ID = C1.ID AND C1.ID_Usuario = U.ID AND C.ID_ClientePloomes = C1.ID_ClientePloomes
			LEFT JOIN Usuario_Perfil P ON U.ID_Perfil = P.ID
			LEFT JOIN Cidade Cd ON C.ID_Cidade = Cd.ID
		WHERE C.Suspenso = 'False'
GO

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)