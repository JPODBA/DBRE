--Text
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CREATE VIEW [dbo].[SVw_Produto] AS
SELECT P.*, G.ID_Familia, Pf.Produto_Edita as Edita, Pf.Produto_Exclui as Exclui, U.ID as ID_Usuario,
ISNULL(P.DataAtualizacao, P.DataCriacao) as LastUpdateDate
FROM Produto P 
CROSS JOIN Usuario U
LEFT JOIN Usuario_Perfil Pf ON U.ID_Perfil = Pf.ID
LEFT JOIN Produto_Grupo G   ON P.ID_Grupo = G.ID

sp_Helpindex 'Usuario'

CREATE NONCLUSTERED Index IX_Produto_SVw_Produto_01 on Produto (ID_Grupo) on [INDEX]

CREATE NONCLUSTERED Index IX_Usuario_Perfil_SVw_Produto_01 on Usuario_Perfil (ID_Grupo) on [INDEX]