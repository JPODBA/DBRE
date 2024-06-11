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

-- up 2
-- https://app.asana.com/0/626405171214145/1205730634348365/f
INSERT INTO CampoFixo2 VALUES (1536,24,24,7,'user_creator','Criador do usuário',0,1,0,0,1,0,0,NULL,'Creator','CreatorId',0,NULL,NULL,0,1,1,NULL,NULL,NULL,NULL,NULL, '2023-11-01 00:00:00.000')
INSERT INTO CampoFixo2_Cultura VALUES (536, 1536, 'pt-BR', 'Criador do usuário')
INSERT INTO CampoFixo2_Cultura VALUES (11536, 1536, 'en-US', 'User creator')
INSERT INTO CampoFixo2_Cultura VALUES (30537, 1536, 'es-ES', 'Creador de usuario')
INSERT INTO CampoFixo2_Cultura VALUES (21536, 1536, 'pt-PT', 'Criador do utilizador')

INSERT INTO Field (AccountId, [Dynamic], FieldId, [Key])
SELECT PC.ID, 0, 1536, 'user_creator'
FROM Ploomes_Cliente PC

INSERT INTO Field (AccountId, [Dynamic], FieldId, [Key]) VALUES (0, 0, 1536, 'user_creator')

-- up 3
-- https://app.asana.com/0/626405171214145/1205524749250270/f
INSERT INTO CampoFixo2 VALUES (1537,2,NULL,8,'deal_last_stage_change_date','Última mudança de estágio',0,1,0,0,1,0,0,NULL,'LastStageChangeDate','LastStageChangeDate',0,NULL,NULL,0,1,1,NULL,NULL,1,NULL,NULL, '2023-11-01 00:00:00.000')
INSERT INTO CampoFixo2_Cultura VALUES (537,1537,'pt-BR','Última mudança de estágio')
INSERT INTO CampoFixo2_Cultura VALUES (11537,1537,'en-US','Last stage change')
INSERT INTO CampoFixo2_Cultura VALUES (21537,1537,'pt-PT','Última mudança de estado')
INSERT INTO CampoFixo2_Cultura VALUES (30538,1537,'es-ES','Cambio de última etapa')

INSERT INTO Field (AccountId, [Dynamic], FieldId, [Key])
SELECT PC.ID, 0, 1537, 'deal_last_stage_change_date'
FROM Ploomes_Cliente PC

INSERT INTO Field (AccountId, [Dynamic], FieldId, [Key]) VALUES (0, 0, 1537, 'deal_last_stage_change_date')

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

-- up 6
-- https://app.asana.com/0/626405171214145/1205482573461615/f
INSERT INTO CampoFixo2 VALUES (1538,31,NULL,4,'deal_stage_ordination','Ordenação do estágio',0,1,0,0,1,1,0,NULL,'Ordination','Ordination',1,NULL,NULL,0,1,1,NULL,NULL,NULL,NULL,NULL, '2023-11-06 00:00:00.000')
INSERT INTO CampoFixo2_Cultura VALUES (538,1538,'pt-BR','Ordenação do estágio')
INSERT INTO CampoFixo2_Cultura VALUES (11538,1538,'en-US','Stage ordination')
INSERT INTO CampoFixo2_Cultura VALUES (21538,1538,'pt-PT','Ordenação de estado')
INSERT INTO CampoFixo2_Cultura VALUES (30539,1538,'es-ES','Ordenamiento de etapa')
INSERT INTO Field (AccountId, [Dynamic], FieldId, [Key])
SELECT PC.ID, 0, 1538, 'deal_stage_ordination'
FROM Ploomes_Cliente PC
INSERT INTO Field (AccountId, [Dynamic], FieldId, [Key]) VALUES (0, 0, 1538, 'deal_stage_ordination')

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)