use Ploomes_CRM
go
ALTER VIEW [dbo].[SVw_Produto_Grupo] AS
	SELECT G.*, P.Produto_Edita as Edita, P.Produto_Exclui as Exclui, U.ID as ID_Usuario, ISNULL(G.DataAtualizacao,G.DataCriacao) as LastUpdateDate
		FROM Produto_Grupo G INNER JOIN Usuario U ON G.ID_ClientePloomes = U.ID_ClientePloomes
			INNER JOIN (
			SELECT G.ID, U.ID as ID_Usuario
				FROM Produto_Grupo G INNER JOIN Usuario U ON G.ID_ClientePloomes = U.ID_ClientePloomes
				WHERE U.ID_Perfil = 1 AND G.Suspenso = 0

			UNION ALL

			SELECT G.ID, U.ID as ID_Usuario
				FROM Produto_Grupo G INNER JOIN Usuario U ON G.ID_ClientePloomes = U.ID_ClientePloomes
				WHERE U.ID_Perfil <> 1 AND NOT EXISTS(SELECT 1 FROM Produto_Grupo_Permissao_Usuario WHERE ID_Grupo = G.ID)
					AND NOT EXISTS(SELECT 1 FROM Produto_Grupo_Permissao_Equipe WHERE ID_Grupo = G.ID)
					AND G.Suspenso = 0

			UNION ALL

			(SELECT G.ID, U.ID as ID_Usuario
				FROM Produto_Grupo G INNER JOIN Usuario U ON G.ID_ClientePloomes = U.ID_ClientePloomes
				WHERE U.ID_Perfil <> 1 AND EXISTS(SELECT 1 FROM Produto_Grupo_Permissao_Usuario WHERE ID_Grupo = G.ID AND ID_Usuario = U.ID)
					AND G.Suspenso = 0

			UNION

			SELECT G.ID, U.ID as ID_Usuario
				FROM Produto_Grupo G INNER JOIN Usuario U ON G.ID_ClientePloomes = U.ID_ClientePloomes
					INNER JOIN Equipe_Usuario EU ON U.ID = EU.ID_Usuario
				WHERE U.ID_Perfil <> 1 AND EXISTS(SELECT 1 FROM Produto_Grupo_Permissao_Equipe WHERE ID_Grupo = G.ID AND ID_Equipe = EU.ID_Equipe)
					AND G.Suspenso = 0)

			/*UNION

			SELECT G.ID, UR.ID_Usuario
				FROM Produto_Grupo G INNER JOIN Usuario_Responsavel UR ON ISNULL(G.ID_Responsavel, 0) = UR.ID_Responsavel AND UR.ID_Tipo = 11 AND G.ID = ISNULL(UR.ID_Item, G.ID)
					WHERE NOT EXISTS(SELECT 1 FROM Usuario_Responsavel WHERE ID_Usuario = UR.ID_Usuario AND ID_Responsavel = UR.ID_Responsavel AND ID_Tipo = UR.ID_Tipo AND ID_Item IS NULL AND UR.ID_Item > 0 AND ID <> UR.ID)
						AND NOT EXISTS(SELECT 1 FROM Usuario_Responsavel WHERE ID_Usuario = UR.ID_Usuario AND ID_Responsavel = UR.ID_Responsavel AND ID_Tipo = UR.ID_Tipo AND ISNULL(UR.ID_Item, 0) = ISNULL(ID_Item, 0) AND ID > UR.ID)*/
		) as G1 ON G.ID = G1.ID AND G1.ID_Usuario = U.ID
			LEFT JOIN Usuario_Perfil P ON U.ID_Perfil = P.ID


GO
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)