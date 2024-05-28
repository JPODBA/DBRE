DROP INDEX IF EXISTS [IX_Campo_GoogleSheets_ID_Campo] ON [dbo].[Campo_GoogleSheets];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_Equipe_ID_ClientePloomes] ON [dbo].[Campo_Permissao_Equipe];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_Exhibition_Team_AccountId] ON [dbo].[Campo_Permissao_Exhibition_Team];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_Exhibition_User_AccountId] ON [dbo].[Campo_Permissao_Exhibition_User];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_Exhibition_UserProfile_AccountId] ON [dbo].[Campo_Permissao_Exhibition_UserProfile];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_PerfilUsuario_ID_ClientePloomes] ON [dbo].[Campo_Permissao_PerfilUsuario];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_Usuario_ID_ClientePloomes] ON [dbo].[Campo_Permissao_Usuario];  
DROP INDEX IF EXISTS [IX_Campo_Tabela_Caminho_ID_TabelaOrigem] ON [dbo].[Campo_Tabela_Caminho];  
DROP INDEX IF EXISTS [IX_Campo_Vinculo_ID_CampoDestino] ON [dbo].[Campo_Vinculo];  
DROP INDEX IF EXISTS [IX_CampoFixo2_ClientePloomes_Formula_ID_Campo] ON [dbo].[CampoFixo2_ClientePloomes_Formula];  
DROP INDEX IF EXISTS [IX_CampoFixo2_Cultura_ID_Campo] ON [dbo].[CampoFixo2_Cultura];  
DROP INDEX IF EXISTS [IX_CampoFixo2_ID_Tabela] ON [dbo].[CampoFixo2];  
DROP INDEX IF EXISTS [IX_Equipe_Usuario_ID_Equipe] ON [dbo].[Equipe_Usuario];  
DROP INDEX IF EXISTS [IX_Equipe_Usuario_ID_Usuario] ON [dbo].[Equipe_Usuario];  
DROP INDEX IF EXISTS [IX_Ploomes_Usuario_SupportUser_SupportUser_SupportUserId] ON [dbo].[Ploomes_Usuario_SupportUser];  
DROP INDEX IF EXISTS [IX_Usuario_Chave] ON [dbo].[Usuario];  
DROP INDEX IF EXISTS [IX_Usuario_ID_ClientePloomes] ON [dbo].[Usuario];  




CREATE NONCLUSTERED INDEX [IX_Campo_GoogleSheets_ID_Campo] ON [dbo].[Campo_GoogleSheets] ([ID_Campo] ASC) WITH (FILLFACTOR = 100)																																						 ON [INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Equipe_ID_ClientePloomes] ON [dbo].[Campo_Permissao_Equipe] ([ID_ClientePloomes] ASC, [ID_Campo] ASC, [Fixo] ASC) WITH (FILLFACTOR = 100)											 ON [INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Exhibition_Team_AccountId] ON [dbo].[Campo_Permissao_Exhibition_Team] ([AccountId] ASC, [FieldId] ASC, [FieldFixed] ASC) WITH (FILLFACTOR = 100)							 ON [INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Exhibition_User_AccountId] ON [dbo].[Campo_Permissao_Exhibition_User] ([AccountId] ASC, [FieldId] ASC, [FieldFixed] ASC) WITH (FILLFACTOR = 100)							 ON [INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Exhibition_UserProfile_AccountId] ON [dbo].[Campo_Permissao_Exhibition_UserProfile] ([AccountId] ASC, [FieldId] ASC, [FieldFixed] ASC) WITH (FILLFACTOR = 100) ON [INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_PerfilUsuario_ID_ClientePloomes] ON [dbo].[Campo_Permissao_PerfilUsuario] ([ID_ClientePloomes] ASC, [ID_Campo] ASC, [Fixo] ASC) WITH (FILLFACTOR = 100)				 ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Usuario_ID_ClientePloomes] ON [dbo].[Campo_Permissao_Usuario] ([ID_ClientePloomes] ASC, [ID_Campo] ASC, [Fixo] ASC) WITH (FILLFACTOR = 100)										 ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Tabela_Caminho_ID_TabelaOrigem] ON [dbo].[Campo_Tabela_Caminho] ([ID_TabelaOrigem] ASC, [ID_TabelaDestino] ASC, [Padrao] DESC) WITH (FILLFACTOR = 100)									 ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Vinculo_ID_CampoDestino] ON [dbo].[Campo_Vinculo] ([ID_CampoDestino] ASC, [Fixo_CampoDestino] ASC)  INCLUDE (Fixo_CampoOrigem, ID_CampoOrigem) WITH (FILLFACTOR = 100)	 ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_CampoFixo2_ClientePloomes_Formula_ID_Campo] ON [dbo].[CampoFixo2_ClientePloomes_Formula] ([ID_Campo] ASC, [ID_ClientePloomes] ASC) WITH (FILLFACTOR = 100)									   ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_CampoFixo2_Cultura_ID_Campo] ON [dbo].[CampoFixo2_Cultura] ([ID_Campo] ASC) WITH (FILLFACTOR = 100)																																						 ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_CampoFixo2_ID_Tabela] ON [dbo].[CampoFixo2] ([ID_Tabela] ASC, [DisplayProperty] DESC) WITH (FILLFACTOR = 100)																																	 ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Equipe_Usuario_ID_Equipe] ON [dbo].[Equipe_Usuario] ([ID_Equipe] ASC, [ID_Usuario] ASC) WITH (FILLFACTOR = 100)																																 ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Equipe_Usuario_ID_Usuario] ON [dbo].[Equipe_Usuario] ([ID_Usuario] ASC) WITH (FILLFACTOR = 100)																																								 ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Ploomes_Usuario_SupportUser_SupportUser_SupportUserId] ON [dbo].[Ploomes_Usuario_SupportUser] ([SupportUserId] ASC) WITH (FILLFACTOR = 100)																		 ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Chave] ON [dbo].[Usuario] ([Chave] ASC) WITH (FILLFACTOR = 100)																																																				 ON [INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Usuario_ID_ClientePloomes] ON [dbo].[Usuario] ([ID_ClientePloomes] ASC, [ID_Perfil] ASC) WITH (FILLFACTOR = 100)																															 ON [INDEX_03];  