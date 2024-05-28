Use Ploomes_CRM
go 
Create Index IX_Relatorio_ID_Cliente_DBA01 on Relatorio (ID_Cliente, Suspenso, ID desc) on [INDEX]
Create Index IX_Relatorio_ID_Oportunidade_DBA02 on Relatorio (ID_oportunidade, Suspenso, ID desc) on [INDEX]

--sp_helpindex 'Relatorio'

GO 
--Svw_Oportunidade
SELECT TOP 1 DATEDIFF(DAY, DataCriacao, GETDATE()) as DiasAberta FROM Oportunidade_Status_Historico WHERE ID_Oportunidade = 1 AND ID_Status = 2 ORDER BY DataCriacao DESC
sp_Helpindex 'Oportunidade_Status_Historico'



SELECT TOP 1 CR.ID_StatusAprovacao FROM Cotacao Cot INNER JOIN Cotacao_Revisao CR ON Cot.ID = CR.ID_Cotacao WHERE CR.ID_ClientePloomes = 1 AND Cot.ID_Oportunidade = 1 AND Cot.Suspenso = 'False' AND CR.Suspenso = 'False' ORDER BY Cot.Codigo DESC, CR.Numero DESC
sp_Helpindex 'Cotacao'
sp_Helpindex 'Cotacao_Revisao'
Create Index IX_Cotacao_Svw_Oportunidade01 on Cotacao (ID, ID_Oportunidade, Suspenso, Codigo desc) on [INDEX]
Create Index IX_Cotacao_Revisao_Svw_Oportunidade01 on Cotacao_Revisao (ID_Cotacao, ID_ClientePloomes, Suspenso, Numero desc) on [INDEX]



--SELECT TOP 1 R.ID FROM Relatorio R WHERE R.ID_Oportunidade = 1 AND R.Suspenso = 'False' ORDER BY R.ID DESC


SELECT TOP 1 V.ID FROM Venda V     WHERE V.ID_Oportunidade = 1 AND V.Suspenso = 'False' ORDER BY V.ID DESC
Create Index IX_Venda_Svw_Oportunidade01 on Venda (ID_Oportunidade, Suspenso, ID desc) on [INDEX]
--sp_Helpindex 'Venda'

SELECT TOP 1 D.ID FROM Document D  WHERE D.DealId = 1 AND D.Suspended = 'False' ORDER BY D.ID DESC
Create Index IX_Document_Svw_Oportunidade01 on Document (DealId, Suspended, ID desc) on [INDEX]

--sp_Helpindex 'Document'


SELECT 1 FROM Oportunidade_Colaborador_Usuario WHERE ID_Oportunidade =1AND ID_Usuario = 1 AND Sistema = 0
Create Index IX_Oportunidade_Colaborador_Usuario_Svw_Oportunidade01 on Oportunidade_Colaborador_Usuario (ID_Oportunidade, ID_Usuario, Sistema) on [INDEX]
--sp_Helpindex 'Cliente_Colaborador_Usuario'

--SELECT 1 FROM Cliente_Colaborador_Usuario WHERE ID_Cliente = 1 AND ID_Usuario =1
----sp_Helpindex 'Cliente_Colaborador_Usuario'
--SELECT TOP 1 DATEDIFF(HOUR, DataCriacao, GETDATE()) FROM Oportunidade_Status_Historico WHERE ID_Oportunidade = 1 AND ID_Status = 1 ORDER BY DataCriacao DESC
----sp_Helpindex 'Oportunidade_Status_Historico'


SELECT 1 FROM Usuario_Responsavel WHERE ID_Usuario = 20 AND ID_Responsavel = 20 AND ID_Tipo = 1 AND ID_Item IS NULL AND 1 > 0 AND ID <> 1
SELECT 1 FROM Usuario_Responsavel WHERE ID_Usuario = 20 AND ID_Responsavel = 20 AND ID_Tipo = 1 AND ISNULL(1, 0) = ISNULL(ID_Item, 0) AND ID > 1
--sp_Helpindex 'Usuario_Responsavel'
Create Index IX_Usuario_Responsavel_Svw_Oportunidade01 on Usuario_Responsavel (ID_Usuario, ID_Responsavel, ID_Tipo, ID_Item, ID desc) on [INDEX]

-----------------------------------------------------------------------------------------------------------------
--Svw_Cliente

SELECT TOP 1 R.ID FROM Relatorio    R WHERE R.ID_Cliente = 32 AND R.Suspenso = 'False' ORDER BY R.ID DESC
SELECT TOP 1 V.ID FROM Venda        V WHERE V.ID_Cliente = 32 AND V.Suspenso = 'False' ORDER BY V.ID DESC
SELECT TOP 1 O.ID FROM Oportunidade O WHERE O.ID_Cliente = 32 AND O.Suspenso = 'False' ORDER BY O.ID DESC
SELECT TOP 1 D.ID FROM Document     D WHERE  D.ContactId = 32 AND D.Suspended = 'False' ORDER BY D.ID DESC

--sp_Helpindex 'Venda'
Create Index IX_Document_Svw_Cliente01 on Document (ContactId, Suspended, ID desc) on [INDEX]
