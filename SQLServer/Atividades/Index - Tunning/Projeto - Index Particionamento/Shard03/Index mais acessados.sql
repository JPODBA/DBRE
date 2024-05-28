CREATE NONCLUSTERED INDEX [IX_Cliente_Cidade] ON [dbo].[Cliente] ([ID_Cidade] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Cliente_Email] ON [dbo].[Cliente] ([Email] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Cliente_ID_Cliente] ON [dbo].[Cliente] ([ID_Cliente] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Cliente_ID_ClientePloomes] ON [dbo].[Cliente] ([ID_ClientePloomes] ASC, [ID_Responsavel] ASC, [ID_Tipo] ASC, [ID_Status] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Cliente_ID_ClientePloomes2] ON [dbo].[Cliente] ([ID_ClientePloomes] ASC, [ID_Responsavel] ASC, [ID_Importacao] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Cliente_ID_ClientePloomes3] ON [dbo].[Cliente] ([ID_ClientePloomes] ASC, [ChaveExterna] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Cliente_ID_ClientePloomes4] ON [dbo].[Cliente] ([ID_ClientePloomes] ASC, [Suspenso] ASC, [Nome] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Cliente_ID_ClientePloomes5] ON [dbo].[Cliente] ([ID_ClientePloomes] ASC, [ID_Responsavel] ASC, [Suspenso] ASC, [Nome] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Cliente_ID_ClientePloomes6] ON [dbo].[Cliente] ([ID_ClientePloomes] ASC, [ID_Cliente] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Cliente_ID_Responsavel] ON [dbo].[Cliente] ([ID_Responsavel] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Cliente_OrdemTarefas] ON [dbo].[Cliente] ([OrdemTarefas] ASC, [Data_PrimeiraTarefa] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Cliente_Suspenso] ON [dbo].[Cliente] ([Suspenso] ASC)  INCLUDE (Data_PrimeiraTarefa, DataCriacao, ID, ID_ClientePloomes, ID_Responsavel, ID_Segmento, ID_Tipo, Nome, OrdemTarefas) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Cliente_Suspenso2] ON [dbo].[Cliente] ([ID_ClientePloomes] ASC, [Suspenso] ASC)  INCLUDE (Data_PrimeiraTarefa, DataCriacao, ID, ID_Responsavel, ID_Segmento, ID_Tipo, Nome) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [Cliente_ID_Tipo] ON [dbo].[Cliente] ([ID_Tipo] ASC, [Suspenso] ASC)  INCLUDE (ID, ID_Cliente, ID_ClientePloomes) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Cliente_Ghost] ON [dbo].[Cliente] ([ID_ClientePloomes] ASC, [Ghost] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;    

CREATE NONCLUSTERED INDEX [IX_Oportunidade_Client_Dt_Vlr] ON [dbo].[Oportunidade] ([ID_Cliente] ASC, [DataCriacao] DESC, [Valor] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_Cliente] ON [dbo].[Oportunidade] ([ID_Cliente] ASC, [ID_Status] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_ClientePloomes] ON [dbo].[Oportunidade] ([ID_ClientePloomes] ASC, [ID_Status] ASC, [ID_Responsavel] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_Estagio] ON [dbo].[Oportunidade] ([ID_ClientePloomes] ASC, [ID_Responsavel] ASC, [ID_Estagio] ASC, [ID_Status2] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_Funil] ON [dbo].[Oportunidade] ([ID_ClientePloomes] ASC, [ID_Responsavel] ASC, [ID_Funil] ASC, [ID_Status2] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_OportunidadeOrigem] ON [dbo].[Oportunidade] ([ID_ClientePloomes] ASC, [ID_Responsavel] ASC, [ID_OportunidadeOrigem] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_Responsavel] ON [dbo].[Oportunidade] ([ID_Responsavel] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Oportunidade] ON [dbo].[Oportunidade] ([ID_OportunidadeOrigem] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_OrdemTarefas] ON [dbo].[Oportunidade] ([OrdemTarefas] ASC, [Data_PrimeiraTarefa] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  

CREATE NONCLUSTERED INDEX [IX_Ploomes_Cliente_ChaveIntegracao] ON [dbo].[Ploomes_Cliente] ([ChaveIntegracao] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Ploomes_Cliente_ChaveSecreta] ON [dbo].[Ploomes_Cliente] ([ChaveSecreta] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Ploomes_Cliente_ID_ClienteCRM] ON [dbo].[Ploomes_Cliente] ([ID_ClienteCRM] ASC)  INCLUDE (ID, ResellerName, SincronizarCRM) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Ploomes_Cliente_LibraryModuleIconId] ON [dbo].[Ploomes_Cliente] ([LibraryModuleIconId] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Ploomes_Cliente_Suspenso] ON [dbo].[Ploomes_Cliente] ([Suspenso] ASC)  INCLUDE (Expira, ID, ID_Plano) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Ploomes_Cliente_WhiteLabel] ON [dbo].[Ploomes_Cliente] ([WhiteLabel] ASC, [WhiteLabelUrl] ASC)  INCLUDE (ID, LogoUrl, Nome, WhiteLabelIconLogoUrl, WhiteLabelLoginLogoUrl, WhiteLabelUseCustomLogo) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  

CREATE NONCLUSTERED INDEX [IX_Produto_ID_ClientePloomes] ON [dbo].[Produto] ([ID_ClientePloomes] ASC, [Suspenso] ASC, [ID_Grupo] ASC, [Descricao] ASC, [Codigo] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Produto_ID_ClientePloomes2] ON [dbo].[Produto] ([ID_ClientePloomes] ASC, [Suspenso] ASC, [Codigo] ASC, [Descricao] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Produto_ID_ClientePloomes3] ON [dbo].[Produto] ([ID_ClientePloomes] ASC, [ID_Grupo] ASC, [Descricao] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Produto_ID_Grupo] ON [dbo].[Produto] ([ID_Grupo] ASC, [Suspenso] ASC, [Descricao] ASC, [Codigo] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Produto_ID_Grupo2] ON [dbo].[Produto] ([ID_Grupo] ASC, [Suspenso] ASC, [Codigo] ASC, [Descricao] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  

CREATE NONCLUSTERED INDEX [IX_Tarefa_ID_Cliente] ON [dbo].[Tarefa] ([ID_Cliente] ASC, [ID_Oportunidade] ASC, [Suspenso] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Tarefa_ID_Criador] ON [dbo].[Tarefa] ([ID_Criador] ASC, [Suspenso] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Tarefa_ID_Oportunidade] ON [dbo].[Tarefa] ([ID_Oportunidade] ASC, [ID_Cliente] ASC, [Suspenso] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Tarefa_Suspenso] ON [dbo].[Tarefa] ([Suspenso] ASC)  INCLUDE (ID) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  

CREATE NONCLUSTERED INDEX [IX_Tarefa_Conclusao_DataRecorrencia] ON [dbo].[Tarefa_Conclusao] ([DataRecorrencia] DESC)  INCLUDE (Concluido, ID_ClientePloomes, ID_Responsavel, ID_Tarefa, ID_TipoResponsavel) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Tarefa_Conclusao_ID_Cliente] ON [dbo].[Tarefa_Conclusao] ([ID_Cliente] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Tarefa_Conclusao_ID_Integracao] ON [dbo].[Tarefa_Conclusao] ([ID_Tarefa] ASC, [ID_Integracao] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Tarefa_Conclusao_ID_Oportunidade] ON [dbo].[Tarefa_Conclusao] ([ID_Oportunidade] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Tarefa_Conclusao_ID_Responsavel] ON [dbo].[Tarefa_Conclusao] ([ID_ClientePloomes] ASC, [ID_Responsavel] ASC, [ID_TipoResponsavel] ASC, [Concluido] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Tarefa_Conclusao_ID_Tarefa] ON [dbo].[Tarefa_Conclusao] ([ID_Tarefa] ASC, [Concluido] ASC, [DataRecorrencia] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Tarefa_Conclusao_OriginTaskId] ON [dbo].[Tarefa_Conclusao] ([OriginTaskId] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Tarefa_Conclusao_Pending] ON [dbo].[Tarefa_Conclusao] ([ID_ClientePloomes] ASC, [Pending] DESC, [ID_Tarefa] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Tarefa_Conclusao_Sincronizar] ON [dbo].[Tarefa_Conclusao] ([Sincronizar] DESC, [ID_Integracao_Usuario] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  

CREATE NONCLUSTERED INDEX [IX_Usuario_Chave] ON [dbo].[Usuario] ([Chave] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Usuario_Chave_Importacao] ON [dbo].[Usuario] ([Chave_Importacao] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Usuario_ChaveSecreta] ON [dbo].[Usuario] ([ChaveSecreta] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Usuario_Cortesia] ON [dbo].[Usuario] ([Cortesia] ASC, [Suspenso] ASC)  INCLUDE (ID_ClientePloomes) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Usuario_Cultura] ON [dbo].[Usuario] ([Cultura] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Usuario_Email] ON [dbo].[Usuario] ([Email] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Usuario_ID_ClientePloomes] ON [dbo].[Usuario] ([ID_ClientePloomes] ASC, [ID_Perfil] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Usuario_ID_Perfil] ON [dbo].[Usuario] ([ID_Perfil] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Usuario_Mobile_OperatingSystem] ON [dbo].[Usuario] ([Mobile_OperatingSystem] ASC, [Mobile_ResetNotificationsBadge] ASC, [Mobile_PushNotificationToken] ASC)  INCLUDE (AvatarUrl, Chave, ChaveSecreta, ContagemNotificacoes, Email, ForgotPassword, ForgotPasswordVerificationHash, GoogleAuthenticatorSecretKey, ID, ID_ClientePloomes, ID_Criador, ID_Intercom, ID_Perfil, Integracao, IntegracaoNativa, Nome, Senha, SenhaInicial, ShowNPSSurvey, SincronizarIntercom, Suspenso, Telefone) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Usuario_Reset_Password] ON [dbo].[Usuario] ([ResetPassword] ASC) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Usuario_SenhaInicial] ON [dbo].[Usuario] ([SenhaInicial] ASC)  INCLUDE (Email, ID, ID_ClientePloomes, ID_Criador) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  
CREATE NONCLUSTERED INDEX [IX_Usuario_SincronizarIntercom] ON [dbo].[Usuario] ([SincronizarIntercom] ASC, [Suspenso] ASC, [Integracao] ASC)  INCLUDE (AvatarUrl, Email, ID, ID_ClientePloomes, ID_Intercom, ID_Perfil, Nome, Telefone) WITH (FILLFACTOR = 100) ON [INDEX_04];  ;  ;  ;  