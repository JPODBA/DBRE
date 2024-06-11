use Ploomes_CRM
go
ALTER VIEW [dbo].[SVw_FiltroGeral] AS
	SELECT F.*, CONVERT(BIT, IIF(U.ID = F.ID_Criador, 1, 0)) as Edita, U.ID as ID_Usuario
		FROM FiltroGeral F INNER JOIN Usuario U ON F.ID_ClientePloomes = U.ID_ClientePloomes
			AND U.ID = F.ID_Criador
		WHERE F.Suspenso = 'False'

	UNION

	SELECT F.*, CONVERT(BIT, IIF(U.ID = F.ID_Criador, 1, 0)) as Edita, U.ID as ID_Usuario
		FROM FiltroGeral F INNER JOIN Usuario U ON F.ID_ClientePloomes = U.ID_ClientePloomes
			AND NOT EXISTS(SELECT 1 FROM FiltroGeral_Permissao_Usuario WHERE ID_Filtro = F.ID)
			AND NOT EXISTS(SELECT 1 FROM FiltroGeral_Permissao_Equipe WHERE ID_Filtro = F.ID)
		WHERE F.Suspenso = 'False'

	UNION

	SELECT F.*, CONVERT(BIT, IIF(U.ID = F.ID_Criador, 1, 0)) as Edita, U.ID as ID_Usuario
		FROM FiltroGeral F INNER JOIN Usuario U ON F.ID_ClientePloomes = U.ID_ClientePloomes
			AND EXISTS(SELECT 1 FROM FiltroGeral_Permissao_Usuario WHERE ID_Filtro = F.ID AND ID_Usuario = U.ID)
		WHERE F.Suspenso = 'False'

	UNION

	SELECT F.*, CONVERT(BIT, IIF(U.ID = F.ID_Criador, 1, 0)) as Edita, U.ID as ID_Usuario
		FROM FiltroGeral F INNER JOIN Usuario U ON F.ID_ClientePloomes = U.ID_ClientePloomes
			AND EXISTS(
				SELECT 1
					FROM FiltroGeral_Permissao_Equipe FPE
						INNER JOIN Equipe_Usuario EU ON FPE.ID_Equipe = EU.ID_Equipe
							AND FPE.ID_Filtro = F.ID AND EU.ID_Usuario = U.ID
			)
		WHERE F.Suspenso = 'False'