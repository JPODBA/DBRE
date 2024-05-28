-- Missing_Index 12/07
-- Shard01
CREATE INDEX [IX_Marcador_Item_IDM] ON [Ploomes_CRM].[dbo].[Marcador_Item] ([ID_Cliente]) INCLUDE ([ID], [ID_Marcador], [ID_Relatorio], [ID_Nota], [ID_Tarefa], [ID_Oportunidade], [ID_Lead], [EmailId]) 
CREATE INDEX [IX_Campo_Valor_Cliente_IDM] ON [Ploomes_CRM].[dbo].[Campo_Valor_Cliente] ([ID_Cliente], [ValorTexto]) INCLUDE ([ID_Campo]) 

-- Shard02
use Ploomes_CRM_Logs
go
CREATE INDEX [IX_AutomationAttempt_IDM01] ON [Ploomes_CRM_Logs].[dbo].[AutomationAttempt] ([Executing], [Periodic], [AccountId]) 
CREATE INDEX [IX_AutomationAttempt_IDM02] ON [Ploomes_CRM_Logs].[dbo].[AutomationAttempt] ([AutomationId], [ItemId]) 
--sp_helpdb 'PLoomes_CRM'
GO
-- Shard03
USe Ploomes_CRM
go
CREATE INDEX [IX_Field_IDM02] ON [Ploomes_CRM].[dbo].[Field] ([FieldId], [Dynamic]) INCLUDE ([AccountId], [Key]) on INDEX_02
GO
-- Shard04
USe Ploomes_CRM
go
CREATE INDEX [IX_AutomationAttempt_IDM03] ON [Ploomes_CRM_Logs].[dbo].[AutomationAttempt] ([Executing], [Periodic]) 
INCLUDE ([AutomationId], [AutomationUserKey], [ItemId], [DateTime], [CurrentAttempt], [IterationCount], [AccountId], [ExecutingDate]) 
CREATE INDEX [ix_Usuario_IDM02] ON [Ploomes_CRM].[dbo].[Usuario] ([Suspenso], [ExportationKey],[ExportationKeyExpiringDate]) 
INCLUDE ([ID_ClientePloomes], [Email], [Senha], [Chave], [Integracao], [Chave_Importacao], [Chave_Importacao_Validade], [ChaveSecreta], 
[IntegracaoNativa], [MultiFactorAuthenticationCode], [MultiFactorAuthenticationCodeCreateDate], [Requests], [LastRequestDate], [ResetPassword], 
[LoginTimeBlocked], [ForgotPassword], [ForgotPasswordVerificationHash], [GoogleAuthenticatorSecretKey], [GoogleAuthenticatorConfigured], [LimitPageSize], [NoLogin]) on INDEX_02
GO 
-- Shard05
CREATE INDEX [IX_Ploomes_Cliente_Integration_IDM] ON [Ploomes_CRM].[dbo].[Ploomes_Cliente_Integration] ([StatusId], [SyncCache]) INCLUDE ([AccountId], [IntegrationId], [IntegrationUserId], [CreatorId]) on INDEX_02
CREATE INDEX [IX_Usuario_IDM01] ON [Ploomes_CRM].[dbo].[Usuario] ([Suspenso]) on INDEX_02
GO 
-- Shard06
CREATE INDEX [IX_Cliente_IDM01] ON [Ploomes_CRM].[dbo].[Cliente] ([Suspenso]) INCLUDE ([ID_ClientePloomes], [ID_Tipo], [ID_Cliente], [Email]) on INDEX_02
GO
-- CENTRL 
CREATE INDEX [IX_Account_SupportAccess_Request_Notification_IDM01] ON [Ploomes_CRM].[dbo].[Account_SupportAccess_Request_Notification] ([Read]) INCLUDE ([Id], [RequestId]) 
GO
-- Shankya 
CREATE INDEX [IX_Lookup_IDM01] ON [Integrations].[dbo].[Lookup] ([SankhyaItemId], [SankhyaItemFk], [RuleId], [AccountId],[Id]) 