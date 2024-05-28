create index Oportunidade_DBA01 on Oportunidade (id_Cliente, Suspenso) ON [INDEX_03];
create index Oportunidade_Funil_DBA01 on Oportunidade_Funil (Suspenso) include (id_ClientePloomes) ON [INDEX_03];

drop index if exists Oportunidade_Funil.Oportunidade_DBA01
--Select * from BA_DBA.dbo.DBA_ROLLBACK_DEPLOY_INDEX where tabela like '%Oportunidade'

--sp_helpindex 'Oportunidade'
--sp_helpindex 'Tarefa_Conclusao'
--sp_helpindex 'Produto'
--sp_helpindex 'Usuario'
--sp_helpindex 'Ploomes_Cliente'
--sp_helpindex 'Cliente'

CREATE NONCLUSTERED INDEX [IX_Oportunidade_Client_Dt_Vlr]         ON [dbo].[Oportunidade] ([ID_Cliente] ASC, [DataCriacao] DESC, [Valor] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_Cliente]            ON [dbo].[Oportunidade] ([ID_Cliente] ASC, [ID_Status] ASC)              WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_ClientePloomes]     ON [dbo].[Oportunidade] ([ID_ClientePloomes] ASC, [ID_Status] ASC, [ID_Responsavel] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_Estagio]            ON [dbo].[Oportunidade] ([ID_ClientePloomes] ASC, [ID_Responsavel] ASC, [ID_Estagio] ASC, [ID_Status2] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_Funil]              ON [dbo].[Oportunidade] ([ID_ClientePloomes] ASC, [ID_Responsavel] ASC, [ID_Funil] ASC, [ID_Status2] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_OportunidadeOrigem] ON [dbo].[Oportunidade] ([ID_ClientePloomes] ASC, [ID_Responsavel] ASC, [ID_OportunidadeOrigem] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_Responsavel]				ON [dbo].[Oportunidade] ([ID_Responsavel] ASC)                          WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Oportunidade]					ON [dbo].[Oportunidade] ([ID_OportunidadeOrigem] ASC)                   WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_OrdemTarefas]					ON [dbo].[Oportunidade] ([OrdemTarefas] ASC, [Data_PrimeiraTarefa] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Suspenso]							ON [dbo].[Oportunidade] ([Suspenso] ASC, [ID_Funil] ASC)                    INCLUDE (ID_Cliente, ID_ClientePloomes) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Suspenso2]							ON [dbo].[Oportunidade] ([Suspenso] ASC, [ID_Funil] ASC)                    INCLUDE (ID_Cliente, ID_ClientePloomes, ID_Responsavel) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Suspenso3]							ON [dbo].[Oportunidade] ([Suspenso] ASC, [ID_Funil] ASC, [ID_Status2] ASC)  INCLUDE (ID_Cliente, ID_ClientePloomes, ID_Responsavel) WITH (FILLFACTOR = 100) ON [INDEX_03];  