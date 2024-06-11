/*
Script de deploy do calendar no shard 5 para as contas novas criadas com os modelos trial
*/

USE Ploomes_CRM;

INSERT INTO INTEGRATION(Id, Name, [Key], TypeId, ImageUrl, BaseUrl, IntegrationUserAvatarUrl, RedirectUrl, ProfileConfigurable, SelectUrl)
SELECT 27, Name + ' (Beta)', [Key], 1, ImageUrl, 'https://ploomescb2callback-gcalendar.ploomes.com/', IntegrationUserAvatarUrl, RedirectUrl + 'codusuario=[CODUSUARIO]', ProfileConfigurable, SelectUrl FROM INTEGRATION WHERE ID = 12;

INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (131,27,'event_id',12,1)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (131,131,'pt-BR','Id (GoogleCalendar)')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10131,131,'en-US','Id (GoogleCalendar)')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20131,131,'pt-PT','Id (GoogleCalendar)')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (132,27,'owner_email',12,1)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (132,132,'pt-BR','E-mail do criador (Google Calendar)')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10132,132,'en-US','Creator e-mail (Google Calendar)')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20132,132,'pt-PT','E-mail do criador (Google Calendar)')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (133,27,'gcalendar_task_organizer',12,4)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (133,133,'pt-BR','Organizador da tarefa')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10133,133,'en-US','Creator e-mail (Google Calendar)')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20133,133,'pt-PT','E-mail do criador (Google Calendar)')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (134,27,'access_token',24,1)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (134,134,'pt-BR','Access token')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10134,134,'en-US','Access token')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20134,134,'pt-PT','Access token')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (135,27,'refresh_token',24,1)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (135,135,'pt-BR','Refresh token')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10135,135,'en-US','Refresh token')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20135,135,'pt-PT','Refresh token')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (136,27,'access_token_expiring_date',24,8)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (136,136,'pt-BR','Validade do token')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10136,136,'en-US','Token validity')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20136,136,'pt-PT','Validade do token')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (137,27,'email_integration',24,1)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (137,137,'pt-BR','Email de integracao')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10137,137,'en-US','Integration email')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20137,137,'pt-PT','Email de integracao')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (138,27,'calendar_id',24,7)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (138,138,'pt-BR','Calendário')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10138,138,'en-US','Calendar')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20138,138,'pt-PT','Calendário')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (139,27,'calendar_name',24,1)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (139,139,'pt-BR','Nome do calendário')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10139,139,'en-US','Calendar name')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20139,139,'pt-PT','Nome do calendário')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (140,27,'webhook_id',24,1)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (140,140,'pt-BR','Id do WebHook')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10140,140,'en-US','WebHook id')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20140,140,'pt-PT','Id do WebHook')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (141,27,'webhook_resource_id',24,1)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (141,141,'pt-BR','Id de recurso do WebHook')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10141,141,'en-US','WebHook resource id')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20141,141,'pt-PT','Id de recurso do WebHook')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (142,27,'webhook_validity',24,4)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (142,142,'pt-BR','Validade do WebHook')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10142,142,'en-US','WebHook validity')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20142,142,'pt-PT','Validade do WebHook')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (143,27,'token_sincronization',24,1)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (143,143,'pt-BR','Sincronização do token')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10143,143,'en-US','Token sincronization')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20143,143,'pt-PT','Sincronização do token')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (144,27,'integration_status',24,4)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (144,144,'pt-BR','Status integração')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10144,144,'en-US','Integration status')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20144,144,'pt-PT','Status integração')
INSERT INTO Integration_CustomField (Id, IntegrationId, [Key], EntityId, TypeId) VALUES (145,27,'integration_autorized',24,4)
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (145,145,'pt-BR','Integração autorizada')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (10145,145,'en-US','Integration authorized')
INSERT INTO Integration_CustomField_Language (Id, CustomFieldID, Language, Name) VALUES (20145,145,'pt-PT','Integração autorizada')

INSERT INTO Integration_Language (Id, IntegrationId, Language, Description) VALUES (27,27,'pt-BR','Sincronize suas tarefas com o seu calendário do Google.<br><span class="font-bold">Eventos recorrentes</span> do Google Calendar <span class="font-bold">não</span> são suportados por esta integração. Os eventos recorrentes do Ploomes, por outro lado, <span class="font-bold">são.</span> Esta integração funciona apenas para e-mails que possuam uma conta com o Google. Crie uma conta gratuita <a style="color: red;" target="_blank" href="https://mail.google.com">aqui</a>.')
INSERT INTO Integration_Language (Id, IntegrationId, Language, Description) VALUES (10027,27,'en-US','Sync your tasks with Google Calendar.<br>This integration <span class="font-bold">doesn''t</span> support Google Calendar''s <span class="font-bold">recurring events</span> feature. Ploomes recurring events <span class="font-bold">will work</span> with this integration. Only e-mails used as Google accounts are able to activate this integration. Create a free account <a style="color: red;" target="_blank" href="https://mail.google.com">here</a>.')
INSERT INTO Integration_Language (Id, IntegrationId, Language, Description) VALUES (20027,27,'pt-PT','Sincronize as suas tarefas com o seu calendário do Google.<br><span class="font-bold">Eventos recorrentes</span> do Google Calendar <span class="font-bold">não</span> são suportados por esta integração. Os eventos recorrentes do Ploomes, por outro lado, <span class="font-bold">são.</span> Esta integração funciona apenas para e-mails que possuam uma conta com o Google. Crie uma conta gratuita <a style="color: red;" target="_blank" href="https://mail.google.com">aqui</a>.')

INSERT INTO Integration_Webhook(Id, IntegrationId, EntityId, ActionId, CallbackUrl, UserWebhook) VALUES (53, 27, 12, 1, 'changedploomestask', 0)
INSERT INTO Integration_Webhook(Id, IntegrationId, EntityId, ActionId, CallbackUrl, UserWebhook) VALUES (54, 27, 12, 2, 'changedploomestask', 0)
INSERT INTO Integration_Webhook(Id, IntegrationId, EntityId, ActionId, CallbackUrl, UserWebhook) VALUES (55, 27, 12, 3, 'changedploomestask', 0)
INSERT INTO Integration_Webhook(Id, IntegrationId, EntityId, ActionId, CallbackUrl, UserWebhook) VALUES (56, 27, 24, 1, 'firstsync', 0)
INSERT INTO Integration_Webhook(Id, IntegrationId, EntityId, ActionId, CallbackUrl, UserWebhook) VALUES (57, 27, 24, 2, 'firstsync', 0)

ALTER VIEW [dbo].[SVw_Integration] AS  
 SELECT I.*, IL.Description, U.ID as ViewUserId  
  FROM Integration I INNER JOIN Integration_Language IL ON I.Id = IL.IntegrationId  
   INNER JOIN Usuario U ON IL.Language = U.Cultura  
   LEFT JOIN Ploomes_Cliente PC ON U.ID_ClientePloomes = PC.ID  
   WHERE ((PC.ID <> 3000022 AND PC.ID <> 3000023 AND PC.ID <> 1 AND (PC.AccountModelId NOT IN (137, 139, 140, 141, 142, 143, 144, 145, 146) OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao < '2023-11-08')) AND I.ID <> 27) OR ((PC.ID = 3000022 OR PC.ID = 3000023 OR PC.ID = 1 OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao >= '2023-11-08')) AND I.ID <> 12))
GO

ALTER VIEW [dbo].[SVw_Ploomes_Cliente_Integration] AS  
 SELECT PCI.*, Usu.Chave as IntegrationUserKey, U.ID as ViewUserId  
  FROM Ploomes_Cliente_Integration PCI INNER JOIN Usuario U ON PCI.AccountId = U.ID_ClientePloomes  
   LEFT JOIN Usuario Usu ON PCI.IntegrationUserId = Usu.ID  
   INNER JOIN Integration I ON PCI.IntegrationId = I.Id AND I.TypeId = 1  
	WHERE I.ID <> 27
 UNION ALL  
  
 SELECT PCI.*, Usu.Chave as IntegrationUserKey, U.ID as ViewUserId  
  FROM Ploomes_Cliente_Integration PCI INNER JOIN Usuario U ON PCI.CreatorId = U.ID  
   INNER JOIN Usuario Usu ON PCI.IntegrationUserId = Usu.ID  
   INNER JOIN Integration I ON PCI.IntegrationId = I.Id AND I.TypeId = 2  
   INNER JOIN Ploomes_Cliente PC ON PCI.AccountId = PC.ID
  WHERE I.ID <> 27 AND (PCI.AccountId <> 3000022 AND PCI.AccountId <> 3000023 AND PCI.AccountId <> 1 AND ((PC.AccountModelId NOT IN (137, 139, 140, 141, 142, 143, 144, 145, 146) OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao < '2023-11-08')))
 UNION ALL  
  
 SELECT PCI.*, U.Chave as IntegrationUserKey, U.ID as ViewUserId  
  FROM Ploomes_Cliente_Integration PCI INNER JOIN Usuario U ON PCI.IntegrationUserId = U.ID AND U.IntegracaoNativa = 1  
   INNER JOIN Integration I ON PCI.IntegrationId = I.Id AND I.TypeId = 2
   INNER JOIN Ploomes_Cliente PC ON PCI.AccountId = PC.ID
   WHERE I.ID <> 27 AND (PCI.AccountId <> 3000022 AND PCI.AccountId <> 3000023 AND PCI.AccountId <> 1  AND ((PC.AccountModelId NOT IN (137, 139, 140, 141, 142, 143, 144, 145, 146) OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao < '2023-11-08')))
 UNION ALL
  SELECT PCI.*, Usu.Chave as IntegrationUserKey, U.ID as ViewUserId  
  FROM Ploomes_Cliente_Integration PCI INNER JOIN Usuario U ON PCI.AccountId = U.ID_ClientePloomes  
   LEFT JOIN Usuario Usu ON PCI.IntegrationUserId = Usu.ID  
   INNER JOIN Integration I ON PCI.IntegrationId = I.Id AND I.TypeId = 1  
   INNER JOIN Ploomes_Cliente PC ON PCI.AccountId = PC.ID
	WHERE I.ID = 27 AND (PCI.AccountId = 3000022 OR PCI.AccountId = 3000023 OR PCI.AccountId = 1 OR (PC.AccountModelId IN (137, 139, 140, 141, 142, 143, 144, 145, 146) AND PC.DataCriacao >= '2023-11-08'))
GO

ALTER VIEW [dbo].[Vw_Self] AS
	SELECT S.*,
			CONVERT(BIT, IIF(PC.ID_Plano = 2 AND CAST(PC.Expira as DATE) < CAST(GETDATE() as DATE), 1, 0)) as ContaExpirada,
			CONVERT(BIT, IIF(PC.ID_Plano = 2 AND CAST(PC.Expira as DATE) < CAST(GETDATE() as DATE) AND EXISTS(SELECT 1 FROM Ploomes_Cliente_Bloqueio WHERE ID_ClientePloomes = PC.ID), 1, 0)) as ContaBloqueada,
			0 as ContagemTarefas2,
			0 as ContagemEmails2,
			S.ContagemLeads as ContagemLeads2,
			ISNULL(ISNULL((SELECT MAX(DataHora) FROM Log_Logon L WHERE L.ID_Usuario = S.ID AND L.ID <> (SELECT MAX(ID) FROM Log_Logon WHERE ID_Usuario = S.ID)), (SELECT MAX(DataHora) FROM Log_Logon L WHERE L.ID_Usuario = S.ID)), GETDATE()) as UltimoLogin,
			(SELECT TOP 1 ID FROM Usuario_Agenda_Integracao WHERE ID_Usuario = S.ID) as ID_AgendaIntegracao,
			(SELECT TOP 1 ITVU.ID FROM Integracao_TotalVoice_Usuario ITVU INNER JOIN Integracao_TotalVoice ITV ON ITVU.ID_Integracao = ITV.ID AND ITV.Suspenso = 'False' WHERE ITVU.ID_Usuario = S.ID) as ID_TotalVoiceIntegracao,
			(SELECT TOP 1 ID FROM Usuario_Email_Integracao WHERE ID_Usuario = S.ID) as ID_EmailIntegracao,
			CONVERT(BIT, IIF(EXISTS(SELECT 1 FROM Vw_Oportunidade_Funil WHERE ID_Usuario = S.ID), 1, 0)) as PossuiFunis,
			CONVERT(BIT, IIF(EXISTS(SELECT 1 FROM Usuario_Agenda_Integracao WHERE ID_Usuario = S.ID AND ID_Calendario IS NOT NULL) OR EXISTS(SELECT 1 FROM Ploomes_Cliente_Integration WHERE IntegrationId IN (7, 12) AND CreatorId = S.ID AND StatusId = 1 AND Enabled = 1) OR EXISTS (SELECT 1 FROM Campo_Valor_Usuario CVU INNER JOIN Ploomes_Cliente_Integration_CustomField PCICF ON PCICF.CustomFieldId IN (103,144) WHERE CVU.ID_Campo = PCICF.FieldId AND CVU.ID_Usuario = S.ID), 1, 0)) as HasTasksIntegration,
			CONVERT(BIT, IIF(EXISTS(SELECT 1 FROM Ploomes_Usuario_SupportUser WHERE SupportUserId = S.ID), 1, 0)) as IsSupportUser,
			IIF(PC.PipelineUserUsabilityId = 3, S.PipelineUserUsabilityId, PC.PipelineUserUsabilityId) as PipelineUserUsabilityId2,
			IIF(PC.QuoteTemplateUserUsabilityId = 3, S.QuoteTemplateUserUsabilityId, PC.QuoteTemplateUserUsabilityId) as QuoteTemplateUserUsabilityId2,
			IIF(PC.OrderTemplateUserUsabilityId = 3, S.OrderTemplateUserUsabilityId, PC.OrderTemplateUserUsabilityId) as OrderTemplateUserUsabilityId2,
			IIF(PC.DocumentTemplateUserUsabilityId = 3, S.DocumentTemplateUserUsabilityId, PC.DocumentTemplateUserUsabilityId) as DocumentTemplateUserUsabilityId2,
			CONVERT(BIT, IIF(S.ID = PC.ID_Criador, 1, 0)) as CriadorConta
		FROM Usuario S LEFT JOIN Ploomes_Cliente PC ON S.ID_ClientePloomes = PC.ID
		WHERE S.Suspenso = 'False'
GO

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)