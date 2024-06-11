
-- SHARD01 --
CREATE INDEX [ix_Campo_Valor_Cliente_IDM01] ON [Ploomes_CRM].[dbo].[Campo_Valor_Cliente] ([ID_Campo], [ValorTexto]) INCLUDE ([ID_Cliente]) on index_02

CREATE INDEX [ix_Campo_Valor_ContactProduct_IDM01] ON [Ploomes_CRM].[dbo].[Campo_Valor_ContactProduct] ([ContactProductId]) INCLUDE ([Id], [FieldId], [StringValue], 
[BigStringValue], [IntegerValue], [DecimalValue], [DateTimeValue], [BoolValue], [ObjectValueId], [UserValueId], [ProductValueId], [AttachmentValueId], 
[ContactValueId], [CurrencyValueId], [AttachmentItemValueId]) on index_02

CREATE INDEX [ix_Campo_Valor_ContactProduct_IDM02] ON [Ploomes_CRM].[dbo].[Campo_Valor_ContactProduct] ([ContactProductId]) INCLUDE ([IntegerValue])  on index_02

GO 


-- SHARD02 --

CREATE INDEX [ix_Ploomes_Cliente_IDM01] ON [Ploomes_CRM].[dbo].[Ploomes_Cliente] ([Suspenso]) INCLUDE ([ID], [ID_Plano]) ON INDEX_02
CREATE INDEX [ix_WebHook_IDM] ON [Ploomes_CRM].[dbo].[WebHook] ([AccountId], [EntityId], [ActionId], [Active], [Suspended], [SecondaryEntityId]) 
INCLUDE ([Id], [CallbackUrl], [ValidationKey], [CreatorId], [CreateDate], [UpdaterId], [UpdateDate], [UserWebhook]) ON INDEX_02

-- SHARD04 --
CREATE INDEX [AutomationAttempt_IDM] ON [Ploomes_CRM_Logs].[dbo].[AutomationAttempt] ([Executing], [Periodic]) 
INCLUDE ([AutomationId], [AutomationUserKey], [ItemId], [DateTime], [CurrentAttempt], [IterationCount], [AccountId], [ExecutingDate]) 


-- SHARD05 --
CREATE INDEX [IX_AutomationAttempt_IDM01] ON [Ploomes_CRM_Logs].[dbo].[AutomationAttempt] ([Executing], [Periodic]) 
INCLUDE ([AutomationId], [AutomationUserKey], [ItemId], [DateTime], [CurrentAttempt], [IterationCount], [AccountId], [ExecutingDate]) 

CREATE INDEX [IX_Document_Page_IDM01] ON [Ploomes_CRM].[dbo].[Document_Page] ([OrderId]) 
INCLUDE ([DocumentTemplateId], [QuoteId], [Name], [BodySourceCode], [HeaderSourceCode], 
[HeaderHeight], [FooterSourceCode], [FooterHeight], [SideMargin], [TopMargin], [BottomMargin], [Ordination], [DocumentId]) ON INDEX_02

CREATE INDEX [ix_Ploomes_Cliente_IDM01] ON [Ploomes_CRM].[dbo].[Ploomes_Cliente] ([Suspenso]) INCLUDE ([ID_Plano]) ON INDEX_02
							
CREATE INDEX [ix_Ploomes_Cliente_SupportAccess_Request_IDM01] 
ON [Ploomes_CRM].[dbo].[Ploomes_Cliente_SupportAccess_Request] ([AccountId], [SupportUserId], [Approved], [Revoked],[ExpirationDate]) ON INDEX_02


-- SHARD06 --
CREATE INDEX [IX_WebhookAttempt_IDM01] ON [Ploomes_CRM_Logs].[dbo].[WebhookAttempt] ([WebhookId], [Executing]) 
CREATE INDEX [IX_AutomationAttempt_IDM02] ON [Ploomes_CRM_Logs].[dbo].[AutomationAttempt] ([Executing], [Periodic], [AccountId]) 
CREATE INDEX [IX_WebHook_IDM01] ON [Ploomes_CRM].[dbo].[WebHook] ([AccountId], [EntityId], [ActionId], [Active], [Suspended], [SecondaryEntityId]) 
INCLUDE ([CallbackUrl], [ValidationKey], [CreatorId], [CreateDate], [UpdaterId], [UpdateDate], [UserWebhook]) ON INDEX_02

-- Shankya --

CREATE INDEX [Integration_IDM] ON [Integrations].[dbo].[Integration] ([NextSearchDate], [LastUpdate]) ON INDEX_02


-- Central -- 
CREATE INDEX [Account_IDM] ON [Ploomes_CRM].[dbo].[Account] ([WhiteLabel], [WhiteLabelUrl]) 
INCLUDE ([Id], [Name], [HostSetId], [WhiteLabelBrandColor], [WhiteLabelDarkColor], [WhiteLabelActionColor], [WhiteLabelNeutralColor], [WhiteLabelUseCustomLogo], 
[WhiteLabelLoginLogoUrl], [WhiteLabelIconLogoUrl]) ON INDEX_02