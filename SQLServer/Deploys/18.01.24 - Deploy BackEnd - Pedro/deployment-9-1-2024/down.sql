/*
    Script de rollback do deployment-9-1-2024
*/
USE Ploomes_CRM
GO

-- down do up 1
ALTER TABLE Ploomes_Cliente
DROP COLUMN WhiteLabelName
GO

-- down do up 2
ALTER TABLE Cliente DROP COLUMN [LastInteractionRecordId]
ALTER TABLE Cliente DROP COLUMN [LastOrderId]
ALTER TABLE Cliente DROP COLUMN [LastDocumentId]
ALTER TABLE Cliente DROP COLUMN [LastDealId]
GO

ALTER VIEW [dbo].[SVw_Cliente] AS
	SELECT C.*, Cd.ID_UF, Cd.ID_Pais,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', '') as Registro,
		IIF(C.ID_Tipo = 1, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', ''), NULL) as CNPJFiltro,
		IIF(C.ID_Tipo = 2, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', ''), NULL) as CPFFiltro,
		ISNULL(C.DataAtualizacao, C.DataCriacao) as UltimaAtualizacao,
		NULL as ID_PrimeiraTarefa,
		CONVERT(BIT, IIF(C.Data_PrimeiraTarefa IS NOT NULL, 1, 0)) as HasScheduledTasks,
		(SELECT TOP 1 R.ID FROM Relatorio R WHERE R.ID_Cliente = C.ID AND R.Suspenso = 'False' ORDER BY R.ID DESC) as ID_UltimoRelatorio,
		(SELECT TOP 1 V.ID FROM Venda V WHERE V.ID_Cliente = C.ID AND V.Suspenso = 'False' ORDER BY V.ID DESC) as ID_UltimaVenda,
		(SELECT TOP 1 O.ID FROM Oportunidade O WHERE O.ID_Cliente = C.ID AND O.Suspenso = 'False' ORDER BY O.ID DESC) as ID_UltimaOportunidade,
		(SELECT TOP 1 D.ID FROM Document D WHERE D.ContactId = C.ID AND D.Suspended = 'False' ORDER BY D.ID DESC) as LastDocumentId,
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

ALTER VIEW [dbo].[DVw_Cliente] AS
	SELECT C.*, Cd.ID_UF, Cd.ID_Pais,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', '') as Registro,
		IIF(C.ID_Tipo = 1, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', ''), NULL) as CNPJFiltro,
		IIF(C.ID_Tipo = 2, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.CNPJ, '.', ''), '-', ''), '/', ''), ' ', ''), '_', ''), NULL) as CPFFiltro,
		ISNULL(C.DataAtualizacao, C.DataCriacao) as UltimaAtualizacao,
		NULL as ID_PrimeiraTarefa,
		(SELECT TOP 1 R.ID FROM Relatorio R WHERE R.ID_Cliente = C.ID AND R.Suspenso = 'False' ORDER BY R.ID DESC) as ID_UltimoRelatorio,
		(SELECT TOP 1 V.ID FROM Venda V WHERE V.ID_Cliente = C.ID AND V.Suspenso = 'False' ORDER BY V.ID DESC) as ID_UltimaVenda,
		(SELECT TOP 1 O.ID FROM Oportunidade O WHERE O.ID_Cliente = C.ID AND O.Suspenso = 'False' ORDER BY O.ID DESC) as ID_UltimaOportunidade,
		(SELECT TOP 1 D.ID FROM Document D WHERE D.ContactId = C.ID AND D.Suspended = 'False' ORDER BY D.ID DESC) as LastDocumentId,
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

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)