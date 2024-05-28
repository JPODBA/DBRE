DROP INDEX IF EXISTS [IX_Oportunidade_Funil_ID_ClientePloomes] ON [dbo].[Oportunidade_Funil];  
DROP INDEX IF EXISTS [IX_Oportunidade_Funil_AllowedDocumentTemplate_PipelineId] ON [dbo].[Oportunidade_Funil_AllowedDocumentTemplate];  
DROP INDEX IF EXISTS [IX_Oportunidade_Funil_Permissao_Equipe_ID_Equipe] ON [dbo].[Oportunidade_Funil_Permissao_Equipe];  
DROP INDEX IF EXISTS [IX_Oportunidade_Funil_Permissao_Equipe_ID_Funil] ON [dbo].[Oportunidade_Funil_Permissao_Equipe];  
DROP INDEX IF EXISTS [IX_Oportunidade_Funil_Permissao_Usuario_ID_Funil] ON [dbo].[Oportunidade_Funil_Permissao_Usuario];  
DROP INDEX IF EXISTS [IX_Oportunidade_Funil_Permissao_Usuario_ID_Usuario] ON [dbo].[Oportunidade_Funil_Permissao_Usuario];  
DROP INDEX IF EXISTS [IX_Oportunidade_Funil_Tabela_ID_Tabela] ON [dbo].[Oportunidade_Funil_Tabela];  
DROP INDEX IF EXISTS [IX_Oportunidade_Funil_Tabela_ID_Funil] ON [dbo].[Oportunidade_Funil_Tabela];  

CREATE NONCLUSTERED INDEX [IX_Oportunidade_Funil_ID_ClientePloomes] ON [dbo].[Oportunidade_Funil] ([ID_ClientePloomes] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Funil_AllowedDocumentTemplate_PipelineId] ON [dbo].[Oportunidade_Funil_AllowedDocumentTemplate] ([PipelineId] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Funil_Permissao_Equipe_ID_Equipe] ON [dbo].[Oportunidade_Funil_Permissao_Equipe] ([ID_Equipe] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Funil_Permissao_Equipe_ID_Funil] ON [dbo].[Oportunidade_Funil_Permissao_Equipe] ([ID_Funil] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Funil_Permissao_Usuario_ID_Funil] ON [dbo].[Oportunidade_Funil_Permissao_Usuario] ([ID_Funil] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Funil_Permissao_Usuario_ID_Usuario] ON [dbo].[Oportunidade_Funil_Permissao_Usuario] ([ID_Usuario] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Funil_Tabela_ID_Tabela] ON [dbo].[Oportunidade_Funil_Tabela] ([ID_Tabela] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Funil_Tabela_ID_Funil] ON [dbo].[Oportunidade_Funil_Tabela] ([ID_Funil] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  