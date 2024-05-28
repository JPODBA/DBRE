--Text
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CREATE VIEW [dbo].[SVw_Tarefa] AS
SELECT T.ID, T.Titulo, T.Descricao, TC.ID_Classe, T1.ID_Cliente, Cli.Nome as NomeCliente, T1.ID_Oportunidade, TC.ID_Lembrete, T.Repetir, TC.ID_Intervalo, TC.ID_Criador, T.DataCriacao, T.ID_Criador as OriginalTaskCreatorId, 
ISNULL(T.DataAtualizacao, T.DataCriacao) as UltimaAtualizacao,
			T.ID_Atualizador, T.DataAtualizacao, T.Suspenso, TC.ID as ID_Recorrencia, T1.DataRecorrencia, TC.SemHorario, TC.Duracao, T1.Concluido, TC.DataConclusao,
			TC.Lembrete_Email_Enviado, ISNULL(TC.Cria_Evento_Agenda_Participante, 0) as Cria_Evento_Agenda_Participante,				TC.Endereco, TC.Latitude, TC.Longitude, TC.ID_Integracao, T1.OriginTaskId, TC.ID_Finalizador as FinisherId, T1.Pending,

			(SELECT TOP 1 ID FROM Relatorio WHERE ID_TarefaConclusao = TC.ID AND Suspenso = 'False' ORDER BY ID DESC) as ID_Relatorio,
			CONVERT(BIT,ISNULL(CASE					
			/*WHEN TC.ID_Integracao IS NOT NULL AND NOT EXISTS(SELECT 1 FROM Usuario_Agenda_Integracao WHERE ID_Usuario = TC.ID_Integracao_Usuario)	
				AND EXISTS(SELECT 1 FROM Tarefa_Usuario TU INNER JOIN Usuario_Agenda_Integracao UAI ON TU.ID_Usuario = UAI.ID_Usuario WHERE TU.ID_Tarefa = T.ID)
						THEN 0*/
					WHEN U.ID_Perfil = 1 THEN 1
					WHEN T.ID_Criador = U.ID THEN 1
					WHEN U.IntegracaoNativa = 1 THEN 1
					WHEN EXISTS(SELECT 1 FROM Tarefa_Usuario WHERE ID_Tarefa = T.ID AND ID_Usuario = U.ID) THEN 1
					WHEN T.ID_Oportunidade IS NOT NULL THEN (SELECT TOP 1 O.Edita FROM SVw_Oportunidade O WHERE O.ID = T.ID_Oportunidade AND O.ID_Usuario = U.ID)
					WHEN T.ID_Cliente IS NOT NULL THEN (SELECT TOP 1 Cli.Edita FROM SVw_Cliente Cli WHERE Cli.ID = T.ID_Cliente AND Cli.ID_Usuario = U.ID)
					ELSE 0
				END, 0)
			) as Edita,
			CONVERT(BIT, IIF(EXISTS(SELECT 1 FROM Tarefa_Usuario WHERE ID_Tarefa = T.ID AND ID_Usuario = U.ID), 1, 0)) as Finaliza,
			DATEADD(MINUTE, TC.Duracao, TC.DataRecorrencia) as DataRecorrenciaFim,
			U.ID as ID_Usuario,
			TC.ID_Responsavel,
			TC.ID_TipoResponsavel
	FROM (
		SELECT TC.ID, TC.ID_Cliente, TC.ID_Oportunidade, TC.Concluido, TC.OriginTaskId, TC.DataRecorrencia, TC.Pending,	U.ID as ID_Usuario
		FROM Tarefa T 
		INNER JOIN Tarefa_Conclusao               TC ON T.ID = TC.ID_Tarefa
		INNER JOIN Usuario												 U ON U.ID_ClientePloomes = TC.ID_ClientePloomes
		INNER JOIN Usuario_Responsavel						UR ON ISNULL(TC.ID_Responsavel, 0) = UR.ID_Responsavel AND TC.ID_TipoResponsavel = UR.ID_Tipo AND UR.ID_Usuario = U.ID AND UR.ID_Item IS NULL
		WHERE T.Suspenso = 'False'
	
	  UNION  

		SELECT TC.ID, TC.ID_Cliente, TC.ID_Oportunidade, TC.Concluido, TC.OriginTaskId, TC.DataRecorrencia, TC.Pending,	U.ID as ID_Usuario
		FROM Tarefa T 
		INNER JOIN Tarefa_Conclusao TC ON T.ID = TC.ID_Tarefa
		INNER JOIN Usuario           U ON U.ID_ClientePloomes = TC.ID_ClientePloomes				
		WHERE T.Suspenso = 'False' 
		 AND EXISTS(SELECT 1 
								FROM Tarefa_Usuario 
								WHERE ID_Tarefa = T.ID 
									AND ID_Usuario = U.ID)
				--AND T.ID_Cliente IS NULL AND T.ID_Oportunidade IS NULL

		UNION

		SELECT TC.ID, TC.ID_Cliente, TC.ID_Oportunidade, TC.Concluido, TC.OriginTaskId, TC.DataRecorrencia, TC.Pending,	U.ID as ID_Usuario
		FROM Tarefa T 
		INNER JOIN Tarefa_Conclusao TC ON T.ID = TC.ID_Tarefa
		INNER JOIN Usuario           U ON U.ID_ClientePloomes = TC.ID_ClientePloomes AND U.IntegracaoNativa = 1
		WHERE T.Suspenso = 'False'
	) as T1 
		INNER JOIN Tarefa_Conclusao TC ON T1.ID = TC.ID
		INNER JOIN Tarefa            T ON TC.ID_Tarefa = T.ID
		INNER JOIN Usuario           U ON T1.ID_Usuario = U.ID
		LEFT JOIN Cliente          Cli ON T1.ID_Cliente = Cli.ID


SELECT TOP 1 ID FROM Relatorio WHERE ID_TarefaConclusao = 97 AND Suspenso = 'False' ORDER BY ID DESC
--SP_helpindex 'Relatorio'
CREATE NONCLUSTERED Index IX_Relatorio_SVw_Tarefa02 on Relatorio (ID_TarefaConclusao, Suspenso, ID desc) on [INDEX]

SELECT 1 FROM Tarefa_Usuario WHERE ID_Tarefa = 97 AND ID_Usuario = 97
--SP_helpindex 'Relatorio'


-- Tarefa_Conclusao JOIN UNION 
CREATE NONCLUSTERED INDEX IX_Tarefa_Conclusao_SVw_Tarefa01 ON Tarefa_Conclusao ([ID_Tarefa],[ID_ClientePloomes]) INCLUDE ([DataRecorrencia],[Concluido],[ID_Cliente],[ID_Oportunidade],[OriginTaskId],[Pending])  on [INDEX]
CREATE NONCLUSTERED Index IX_Tarefa_Conclusao_SVw_Tarefa02 on Tarefa_Conclusao (ID, ID_Tarefa) on [INDEX]

-- Usuario JOIN UNION 
CREATE NONCLUSTERED Index IX_Usuario_SVw_Tarefa01 on Usuario (ID_ClientePloomes, ID, IntegracaoNativa) on [INDEX]
SP_helpindex 'Usuario'

-- Usuario_Responsavel JOIN UNION 
CREATE NONCLUSTERED Index IX_Usuario_Responsavel_SVw_Tarefa01 on Usuario_Responsavel (ID_Responsavel, ID_Tipo, ID_Usuario, ID_Item) on [INDEX]
SP_helpindex 'Usuario_Responsavel'

-- Tarefa JOIN UNION 
CREATE NONCLUSTERED Index IX_Tarefa_SVw_Tarefa01 on Tarefa (ID, Suspenso) on [INDEX]
SP_helpindex 'Tarefa'

-- Tarefa JOIN UNION 
SELECT 1 FROM Tarefa_Usuario WHERE ID_Tarefa = 97 AND ID_Usuario = 97
--SP_helpindex 'Relatorio'
CREATE NONCLUSTERED Index IX_Tarefa_Usuario_SVw_Tarefa01 on Tarefa_Usuario (ID_Tarefa, ID_Usuario) on [INDEX]
SP_helpindex 'Tarefa_Usuario'
