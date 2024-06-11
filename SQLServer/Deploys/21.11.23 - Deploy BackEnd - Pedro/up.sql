USE Ploomes_CRM;

-- up 1
-- https://app.asana.com/0/626405171214145/1205717402190788/f
ALTER VIEW [dbo].[DVw_Tarefa] AS
	SELECT T.ID, T.Titulo, T.Descricao, T.ID_Classe, T.ID_Tipo, T1.ID_Cliente, Cli.Nome as NomeCliente, T1.ID_Oportunidade, T.ID_Lembrete, T.Repetir, T.ID_Intervalo, T.ID_Criador, T.DataCriacao, ISNULL(T.DataAtualizacao, T.DataCriacao) as UltimaAtualizacao,
				T.ID_Atualizador, T.DataAtualizacao, T.Suspenso, TC.ID as ID_Recorrencia, TC.DataRecorrencia, TC.SemHorario, TC.Duracao, T1.Concluido, TC.DataConclusao,
				TC.Lembrete_Email_Enviado, ISNULL(TC.Cria_Evento_Agenda_Participante, 0) as Cria_Evento_Agenda_Participante,
				TC.Endereco, TC.Latitude, TC.Longitude, TC.ID_Integracao,
				(SELECT TOP 1 ID FROM Relatorio WHERE ID_TarefaConclusao = TC.ID AND Suspenso = 'False' ORDER BY ID DESC) as ID_Relatorio,
				CONVERT(BIT,
					ISNULL(CASE
						WHEN TC.ID_Integracao IS NOT NULL AND NOT EXISTS(SELECT 1 FROM Usuario_Agenda_Integracao WHERE ID_Usuario = TC.ID_Integracao_Usuario)
							AND EXISTS(SELECT 1 FROM Tarefa_Usuario TU INNER JOIN Usuario_Agenda_Integracao UAI ON TU.ID_Usuario = UAI.ID_Usuario WHERE TU.ID_Tarefa = T.ID)
							THEN 0
						WHEN T.ID_Criador = U.ID THEN 1
						WHEN EXISTS(SELECT 1 FROM Tarefa_Usuario WHERE ID_Tarefa = T.ID AND ID_Usuario = U.ID) THEN 1
						WHEN T.ID_Oportunidade IS NOT NULL THEN (SELECT TOP 1 O.Edita FROM SVw_Oportunidade O WHERE O.ID = T.ID_Oportunidade AND O.ID_Usuario = U.ID)
						WHEN T.ID_Cliente IS NOT NULL THEN (SELECT TOP 1 Cli.Edita FROM SVw_Cliente Cli WHERE Cli.ID = T.ID_Cliente AND Cli.ID_Usuario = U.ID)
						ELSE 0
					END, IIF(T.ID_Criador = U.ID, 1, 0))
				) as Edita,
				CONVERT(BIT, IIF(EXISTS(SELECT 1 FROM Tarefa_Usuario WHERE ID_Tarefa = T.ID AND ID_Usuario = U.ID), 1, 0)) as Finaliza,
				DATEADD(MINUTE, TC.Duracao, TC.DataRecorrencia) as DataRecorrenciaFim,
				U.ID as ID_Usuario, TC.ID_Finalizador as FinisherId, TC.OriginTaskId
		FROM (
			SELECT TC.ID, TC.ID_Cliente, TC.ID_Oportunidade, TC.Concluido,
					U.ID as ID_Usuario
				FROM Tarefa T INNER JOIN Tarefa_Conclusao TC ON T.ID = TC.ID_Tarefa
					INNER JOIN Usuario U ON U.ID_ClientePloomes = TC.ID_ClientePloomes
					INNER JOIN Usuario_Responsavel UR ON ISNULL(TC.ID_Responsavel, 0) = UR.ID_Responsavel AND TC.ID_TipoResponsavel = UR.ID_Tipo AND UR.ID_Usuario = U.ID
				WHERE T.Suspenso = 'True'
		
			UNION

			SELECT TC.ID, TC.ID_Cliente, TC.ID_Oportunidade, TC.Concluido,
					U.ID as ID_Usuario
				FROM Tarefa T INNER JOIN Tarefa_Conclusao TC ON T.ID = TC.ID_Tarefa
					INNER JOIN Usuario U ON U.ID_ClientePloomes = TC.ID_ClientePloomes
				WHERE T.Suspenso = 'True' AND EXISTS(SELECT 1 FROM Tarefa_Usuario WHERE ID_Tarefa = T.ID AND ID_Usuario = U.ID)
					--AND T.ID_Cliente IS NULL AND T.ID_Oportunidade IS NULL
			
			UNION

			SELECT TC.ID, TC.ID_Cliente, TC.ID_Oportunidade, TC.Concluido,
					U.ID as ID_Usuario
				FROM Tarefa T INNER JOIN Tarefa_Conclusao TC ON T.ID = TC.ID_Tarefa
					INNER JOIN Usuario U ON U.ID_ClientePloomes = TC.ID_ClientePloomes AND U.IntegracaoNativa = 1
				WHERE T.Suspenso = 'True'
		) as T1 INNER JOIN Tarefa_Conclusao TC ON T1.ID = TC.ID
			INNER JOIN Tarefa T ON TC.ID_Tarefa = T.ID
			INNER JOIN Usuario U ON T1.ID_Usuario = U.ID
			LEFT JOIN Cliente Cli ON T1.ID_Cliente = Cli.ID
GO

-- up 4
-- https://app.asana.com/0/626405171214145/1205848706270115/f
UPDATE CampoFixo2
SET NaoNulavel = 1
WHERE ID = 1094;

-- up 5
-- https://app.asana.com/0/626405171214145/1205729891858660/f
declare @permissionString NVARCHAR(MAX) = 'OtherOptionsCreatePermission';
update CampoFixo2 set PermissaoCriacaoOpcoes = @permissionString where chave = 'contact_relationship';
update Campo_Tabela set OptionsCreationPermissionPropertyName = @permissionString where id = 46;

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)