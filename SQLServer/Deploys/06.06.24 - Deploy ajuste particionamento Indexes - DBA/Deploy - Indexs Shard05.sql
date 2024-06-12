use Ploomes_CRM
go 

DROP INDEX IF EXISTS [IX_Anexo_Folder_Parent_FolderId] ON [dbo].[Anexo_Folder_Parent];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_Equipe_ID_ClientePloomes] ON [dbo].[Campo_Permissao_Equipe];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_Exhibition_Team_AccountId] ON [dbo].[Campo_Permissao_Exhibition_Team];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_Exhibition_User_AccountId] ON [dbo].[Campo_Permissao_Exhibition_User];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_Exhibition_UserProfile_AccountId] ON [dbo].[Campo_Permissao_Exhibition_UserProfile];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_PerfilUsuario_ID_ClientePloomes] ON [dbo].[Campo_Permissao_PerfilUsuario];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_PerfilUsuario_ID_Campo] ON [dbo].[Campo_Permissao_PerfilUsuario];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_Usuario_ID_Campo] ON [dbo].[Campo_Permissao_Usuario];  
DROP INDEX IF EXISTS [IX_Campo_Permissao_Usuario_ID_ClientePloomes] ON [dbo].[Campo_Permissao_Usuario];  
DROP INDEX IF EXISTS [IX_Campo_Tabela_ClientePloomes_ID_Tabela] ON [dbo].[Campo_Tabela_ClientePloomes];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Cliente] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Oportunidade_ID_Oportunidade] ON [dbo].[Campo_Valor_Oportunidade];  
DROP INDEX IF EXISTS [IX_Campo_Vinculo_Fixo_CampoDestino] ON [dbo].[Campo_Vinculo];  
DROP INDEX IF EXISTS [IX_Cliente_Suspenso2] ON [dbo].[Cliente];  
DROP INDEX IF EXISTS [IX_Cotacao_ID_Oportunidade] ON [dbo].[Cotacao];  
DROP INDEX IF EXISTS [IX_Cotacao_Revisao_ID_ClientePloomes] ON [dbo].[Cotacao_Revisao];  
DROP INDEX IF EXISTS [IX_Document_ContactId] ON [dbo].[Document];  
DROP INDEX IF EXISTS [IX_Document_DealId] ON [dbo].[Document];  
DROP INDEX IF EXISTS [IX_FiltroGeral_Permissao_Equipe_ID_Filtro] ON [dbo].[FiltroGeral_Permissao_Equipe];  
DROP INDEX IF EXISTS [IX_FiltroGeral_Permissao_Usuario_ID_Filtro] ON [dbo].[FiltroGeral_Permissao_Usuario];  
DROP INDEX IF EXISTS [IX_Log_Logon_ID_Usuario] ON [dbo].[Log_Logon];  
DROP INDEX IF EXISTS [IX_Marcador_Item_ID_Oportunidade] ON [dbo].[Marcador_Item];  
DROP INDEX IF EXISTS [Oportunidade_DBA01] ON [dbo].[Oportunidade];  
DROP INDEX IF EXISTS [IX_Oportunidade_Colaborador_Usuario_ID_Oportunidade] ON [dbo].[Oportunidade_Colaborador_Usuario];  
DROP INDEX IF EXISTS [IX_Oportunidade_Colaborador_Usuario_ID_Usuario] ON [dbo].[Oportunidade_Colaborador_Usuario];  
DROP INDEX IF EXISTS [IX_Oportunidade_Funil_ID_ClientePloomes] ON [dbo].[Oportunidade_Funil];  
DROP INDEX IF EXISTS [IX_Oportunidade_Funil_Permissao_Usuario_ID_Usuario] ON [dbo].[Oportunidade_Funil_Permissao_Usuario];  
DROP INDEX IF EXISTS [IX_OSH_Op_St_DtCri] ON [dbo].[Oportunidade_Status_Historico];  
DROP INDEX IF EXISTS [IX_Ploomes_Usuario_SupportUser_SupportUser_SupportUserId] ON [dbo].[Ploomes_Usuario_SupportUser];  
DROP INDEX IF EXISTS [IX_RegraNegocio_Aprovacao_Nivel_Usuario_ID_Nivel] ON [dbo].[RegraNegocio_Aprovacao_Nivel_Usuario];  
DROP INDEX IF EXISTS [IX_Relatorio_ID_Oportunidade_DBA02] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_ID_Cliente_DBA01] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Tarefa_Usuario_ID_Usuario] ON [dbo].[Tarefa_Usuario];  
DROP INDEX IF EXISTS [IX_Usuario_Cultura] ON [dbo].[Usuario];  
DROP INDEX IF EXISTS [IX_Usuario_Chave] ON [dbo].[Usuario];  
DROP INDEX IF EXISTS [IX_Venda_ID_Cliente2] ON [dbo].[Venda];  
DROP INDEX IF EXISTS [IX_Venda_ID_Oportunidade] ON [dbo].[Venda];    

go

CREATE NONCLUSTERED INDEX [IX_Anexo_Folder_Parent_FolderId] ON [dbo].[Anexo_Folder_Parent] ([FolderId] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Equipe_ID_ClientePloomes] ON [dbo].[Campo_Permissao_Equipe] ([ID_ClientePloomes] ASC, [ID_Campo] ASC, [Fixo] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Exhibition_Team_AccountId] ON [dbo].[Campo_Permissao_Exhibition_Team] ([AccountId] ASC, [FieldId] ASC, [FieldFixed] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Exhibition_User_AccountId] ON [dbo].[Campo_Permissao_Exhibition_User] ([AccountId] ASC, [FieldId] ASC, [FieldFixed] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Exhibition_UserProfile_AccountId] ON [dbo].[Campo_Permissao_Exhibition_UserProfile] ([AccountId] ASC, [FieldId] ASC, [FieldFixed] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_PerfilUsuario_ID_ClientePloomes] ON [dbo].[Campo_Permissao_PerfilUsuario] ([ID_ClientePloomes] ASC, [ID_Campo] ASC, [Fixo] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_PerfilUsuario_ID_Campo] ON [dbo].[Campo_Permissao_PerfilUsuario] ([ID_Campo] ASC, [ID_ClientePloomes] ASC, [ID_Perfil] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Usuario_ID_Campo] ON [dbo].[Campo_Permissao_Usuario] ([ID_Campo] ASC, [ID_ClientePloomes] ASC, [ID_Usuario] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Usuario_ID_ClientePloomes] ON [dbo].[Campo_Permissao_Usuario] ([ID_ClientePloomes] ASC, [ID_Campo] ASC, [Fixo] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Tabela_ClientePloomes_ID_Tabela] ON [dbo].[Campo_Tabela_ClientePloomes] ([ID_Tabela] ASC, [ID_ClientePloomes] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Cliente] ON [dbo].[Campo_Valor_Cliente] ([ID_Cliente] ASC, [ID_Campo] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Oportunidade_ID_Oportunidade] ON [dbo].[Campo_Valor_Oportunidade] ([ID_Oportunidade] ASC, [ID_Campo] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Vinculo_Fixo_CampoDestino] ON [dbo].[Campo_Vinculo] ([Fixo_CampoDestino] ASC)  INCLUDE (Fixo_CampoOrigem, ID_Caminho, ID_CampoDestino, ID_CampoOrigem) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Cliente_Suspenso2] ON [dbo].[Cliente] ([ID_ClientePloomes] ASC, [Suspenso] ASC)  INCLUDE (Data_PrimeiraTarefa, DataCriacao, ID, ID_Responsavel, ID_Segmento, ID_Tipo, Nome) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Cotacao_ID_Oportunidade] ON [dbo].[Cotacao] ([ID_Oportunidade] ASC, [Codigo] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Cotacao_Revisao_ID_ClientePloomes] ON [dbo].[Cotacao_Revisao] ([ID_ClientePloomes] ASC, [ID_Cotacao] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Document_ContactId] ON [dbo].[Document] ([ContactId] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Document_DealId] ON [dbo].[Document] ([DealId] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_FiltroGeral_Permissao_Equipe_ID_Filtro] ON [dbo].[FiltroGeral_Permissao_Equipe] ([ID_Filtro] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_FiltroGeral_Permissao_Usuario_ID_Filtro] ON [dbo].[FiltroGeral_Permissao_Usuario] ([ID_Filtro] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Log_Logon_ID_Usuario] ON [dbo].[Log_Logon] ([ID_Usuario] ASC, [DataHora] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Marcador_Item_ID_Oportunidade] ON [dbo].[Marcador_Item] ([ID_Oportunidade] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [Oportunidade_DBA01] ON [dbo].[Oportunidade] ([ID_Cliente] ASC, [Suspenso] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Colaborador_Usuario_ID_Oportunidade] ON [dbo].[Oportunidade_Colaborador_Usuario] ([ID_Oportunidade] ASC, [ID_Usuario] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Colaborador_Usuario_ID_Usuario] ON [dbo].[Oportunidade_Colaborador_Usuario] ([ID_Usuario] ASC, [ID_Oportunidade] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Funil_ID_ClientePloomes] ON [dbo].[Oportunidade_Funil] ([ID_ClientePloomes] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Funil_Permissao_Usuario_ID_Usuario] ON [dbo].[Oportunidade_Funil_Permissao_Usuario] ([ID_Usuario] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_OSH_Op_St_DtCri] ON [dbo].[Oportunidade_Status_Historico] ([ID_Oportunidade] ASC, [ID_Status] ASC, [DataCriacao] DESC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Ploomes_Usuario_SupportUser_SupportUser_SupportUserId] ON [dbo].[Ploomes_Usuario_SupportUser] ([SupportUserId] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_RegraNegocio_Aprovacao_Nivel_Usuario_ID_Nivel] ON [dbo].[RegraNegocio_Aprovacao_Nivel_Usuario] ([ID_Nivel] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_Oportunidade_DBA02] ON [dbo].[Relatorio] ([ID_Oportunidade] ASC, [Suspenso] ASC, [ID] DESC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_Cliente_DBA01] ON [dbo].[Relatorio] ([ID_Cliente] ASC, [Suspenso] ASC, [ID] DESC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Tarefa_Usuario_ID_Usuario] ON [dbo].[Tarefa_Usuario] ([ID_Usuario] ASC, [ID_Tarefa] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Cultura] ON [dbo].[Usuario] ([Cultura] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Chave] ON [dbo].[Usuario] ([Chave] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Venda_ID_Cliente2] ON [dbo].[Venda] ([ID_Cliente] ASC, [Suspenso] ASC, [ID] DESC) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Venda_ID_Oportunidade] ON [dbo].[Venda] ([ID_Oportunidade] ASC) WITH (FILLFACTOR = 100) ON [INDEX_03];  

go

DROP INDEX IF EXISTS [IX_Campo_GoogleSheets_ID_Campo] ON [dbo].[Campo_GoogleSheets];  
DROP INDEX IF EXISTS [IX_Campo_Language_FieldId_LanguageId] ON [dbo].[Campo_Language];  
DROP INDEX IF EXISTS [IX_Campo_Tabela_Caminho_ID_TabelaOrigem] ON [dbo].[Campo_Tabela_Caminho];  
DROP INDEX IF EXISTS [IX_Campo_Vinculo_ID_CampoDestino] ON [dbo].[Campo_Vinculo];  
DROP INDEX IF EXISTS [IX_CampoFixo2_ID_Tabela] ON [dbo].[CampoFixo2];  
DROP INDEX IF EXISTS [IX_CampoFixo2_ClientePloomes_ID_ClientePloomes2] ON [dbo].[CampoFixo2_ClientePloomes];  
DROP INDEX IF EXISTS [IX_CampoFixo2_ClientePloomes_Formula_ID_Campo] ON [dbo].[CampoFixo2_ClientePloomes_Formula];  
DROP INDEX IF EXISTS [IX_CampoFixo2_Cultura_ID_Campo] ON [dbo].[CampoFixo2_Cultura];  
DROP INDEX IF EXISTS [IX_CampoFixo2_Cultura_Account_AccountId] ON [dbo].[CampoFixo2_Cultura_Account];  
DROP INDEX IF EXISTS [IX_Cliente_Colaborador_Usuario_ID_Usuario] ON [dbo].[Cliente_Colaborador_Usuario];  
DROP INDEX IF EXISTS [IX_Equipe_Usuario_ID_Equipe] ON [dbo].[Equipe_Usuario];  
DROP INDEX IF EXISTS [IX_Equipe_Usuario_ID_Usuario] ON [dbo].[Equipe_Usuario];  
DROP INDEX IF EXISTS [IX_Field_AccountId_Key] ON [dbo].[Field];  
DROP INDEX IF EXISTS [IX_Usuario_ID_ClientePloomes] ON [dbo].[Usuario];  
DROP INDEX IF EXISTS [IX_Usuario_Responsavel_ID_Tipo] ON [dbo].[Usuario_Responsavel];  

go

CREATE NONCLUSTERED INDEX [IX_Campo_GoogleSheets_ID_Campo] ON [dbo].[Campo_GoogleSheets] ([ID_Campo] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Language_FieldId_LanguageId] ON [dbo].[Campo_Language] ([FieldId] ASC, [LanguageId] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Tabela_Caminho_ID_TabelaOrigem] ON [dbo].[Campo_Tabela_Caminho] ([ID_TabelaOrigem] ASC, [ID_TabelaDestino] ASC, [Padrao] DESC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Vinculo_ID_CampoDestino] ON [dbo].[Campo_Vinculo] ([ID_CampoDestino] ASC, [Fixo_CampoDestino] ASC)  INCLUDE (Fixo_CampoOrigem, ID_CampoOrigem) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_CampoFixo2_ID_Tabela] ON [dbo].[CampoFixo2] ([ID_Tabela] ASC, [DisplayProperty] DESC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_CampoFixo2_ClientePloomes_ID_ClientePloomes2] ON [dbo].[CampoFixo2_ClientePloomes] ([ID_ClientePloomes] ASC, [ID_Campo] ASC)  INCLUDE (Bloqueado, ColumnSize, EnableFormatting, Expandido, FilterId, FiltroFormulario, FormulaEditor, Obrigatorio, Oculto, ReceiveExternalKey, SendExternalKey, Unico, UpdateDate, UseCheckbox) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_CampoFixo2_ClientePloomes_Formula_ID_Campo] ON [dbo].[CampoFixo2_ClientePloomes_Formula] ([ID_Campo] ASC, [ID_ClientePloomes] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_CampoFixo2_Cultura_ID_Campo] ON [dbo].[CampoFixo2_Cultura] ([ID_Campo] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_CampoFixo2_Cultura_Account_AccountId] ON [dbo].[CampoFixo2_Cultura_Account] ([AccountId] ASC, [FieldLanguageId] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Cliente_Colaborador_Usuario_ID_Usuario] ON [dbo].[Cliente_Colaborador_Usuario] ([ID_Usuario] ASC, [ID_Cliente] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Equipe_Usuario_ID_Equipe] ON [dbo].[Equipe_Usuario] ([ID_Equipe] ASC, [ID_Usuario] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Equipe_Usuario_ID_Usuario] ON [dbo].[Equipe_Usuario] ([ID_Usuario] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Field_AccountId_Key] ON [dbo].[Field] ([AccountId] ASC, [Key] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Usuario_ID_ClientePloomes] ON [dbo].[Usuario] ([ID_ClientePloomes] ASC, [ID_Perfil] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_ID_Tipo] ON [dbo].[Usuario_Responsavel] ([ID_Tipo] ASC, [ID_Usuario] ASC, [ID_Responsavel] ASC, [ID_Item] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  