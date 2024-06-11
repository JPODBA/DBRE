use Ploomes_CRM
go
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Cliente3] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Quote_Product_Quote_ProductId2] ON [dbo].[Campo_Valor_Quote_Product];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Quote_Product_QuoteProductId] ON [dbo].[Campo_Valor_Quote_Product];  
DROP INDEX IF EXISTS [IX_Webhook_Log_WebhookId] ON [dbo].[WebHook_Log];  
go 
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Cliente3] ON [dbo].[Campo_Valor_Cliente] ([ID_Cliente] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, ContactValueId, CurrencyValueId, ID, ID_Campo, ID_OpcaoValor, ID_ProdutoValor, ID_UsuarioValor, ValorBooleano, ValorDataHora, ValorDecimal, ValorInteiro, ValorTexto, ValorTextoMultilinha) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Quote_Product_Quote_ProductId2] ON [dbo].[Campo_Valor_Quote_Product] ([Quote_ProductId] ASC)  INCLUDE (AttachmentValueId, BigStringValue, BoolValue, ContactValueId, CurrencyValueId, DateTimeValue, DecimalValue, FieldId, Id, IntegerValue, ObjectValueId, ProductValueId, StringValue, UserValueId) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Quote_Product_QuoteProductId] ON [dbo].[Campo_Valor_Quote_Product] ([Quote_ProductId] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, BigStringValue, BoolValue, ContactValueId, CurrencyValueId, DateTimeValue, DecimalValue, FieldId, Id, IntegerValue, ObjectValueId, ProductValueId, StringValue, UserValueId) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Webhook_Log_WebhookId] ON [dbo].[WebHook_Log] ([WebhookId] ASC, [DateTime] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  

Go

DROP INDEX IF EXISTS [IX_Automation_Log_ActionId] ON [dbo].[Automation_Log];  
DROP INDEX IF EXISTS [IX_Automation_Log_AutomationId] ON [dbo].[Automation_Log];  
DROP INDEX IF EXISTS [IX_Automation_Log_AutomationId2] ON [dbo].[Automation_Log];  
DROP INDEX IF EXISTS [IX_Automation_Log_DateTime] ON [dbo].[Automation_Log];  
DROP INDEX IF EXISTS [IX_Automation_Log_DealId] ON [dbo].[Automation_Log];  
DROP INDEX IF EXISTS [IX_Automation_Log_AccountId] ON [dbo].[Automation_Log];  
DROP INDEX IF EXISTS [IX_Automation_Log_AccountId_DBA] ON [dbo].[Automation_Log];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Cliente2] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Usuario_Responsavel_ID_Tipo2] ON [dbo].[Usuario_Responsavel];  
go 

CREATE NONCLUSTERED INDEX [IX_Automation_Log_ActionId] ON [dbo].[Automation_Log] ([ActionId] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Automation_Log_AutomationId] ON [dbo].[Automation_Log] ([AutomationId] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Automation_Log_AutomationId2] ON [dbo].[Automation_Log] ([AutomationId] ASC)  INCLUDE (ActionId, DateTime, DealId, Id, Success) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Automation_Log_DateTime] ON [dbo].[Automation_Log] ([DateTime] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Automation_Log_DealId] ON [dbo].[Automation_Log] ([DealId] ASC, [DateTime] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Automation_Log_AccountId] ON [dbo].[Automation_Log] ([AccountId] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Automation_Log_AccountId_DBA] ON [dbo].[Automation_Log] ([AccountId] ASC, [Suspended] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Cliente2] ON [dbo].[Campo_Valor_Cliente] ([ID_Cliente] ASC)  INCLUDE (AttachmentValueId, ContactValueId, CurrencyValueId, ID, ID_Campo, ID_OpcaoValor, ID_ProdutoValor, ID_UsuarioValor, ValorBooleano, ValorDataHora, ValorDecimal, ValorInteiro, ValorTexto, ValorTextoMultilinha) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_ID_Tipo2] ON [dbo].[Usuario_Responsavel] ([ID_Tipo] ASC, [ID_Item] ASC)  INCLUDE (ID, ID_Responsavel, ID_Usuario) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  

go 

DROP INDEX IF EXISTS [IX_Automation_Suspended] ON [dbo].[Automation_Log];  
DROP INDEX IF EXISTS [IX_Campo_Valor_ID_Campo] ON [dbo].[Campo_Valor];  
DROP INDEX IF EXISTS [IX_Campo_Valor_SVw_Campo_Valor_01] ON [dbo].[Campo_Valor];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Produto_ID_Produto3] ON [dbo].[Campo_Valor_Produto];  
DROP INDEX IF EXISTS [IX_Timeline_IDM01] ON [dbo].[Timeline];  
DROP INDEX IF EXISTS [IX_Usuario_Responsavel_ID_Item] ON [dbo].[Usuario_Responsavel];  
DROP INDEX IF EXISTS [IX_Usuario_Responsavel_ID_Responsavel] ON [dbo].[Usuario_Responsavel];  
DROP INDEX IF EXISTS [IX_Usuario_Responsavel_ID_Usuario] ON [dbo].[Usuario_Responsavel];  
DROP INDEX IF EXISTS [IX_Usuario_Responsavel_ID_Tipo] ON [dbo].[Usuario_Responsavel];  
DROP INDEX IF EXISTS [IX_Usuario_Responsavel_Svw_Oportunidade_01] ON [dbo].[Usuario_Responsavel];  
DROP INDEX IF EXISTS [IX_Usuario_Responsavel_SVw_Tarefa_01] ON [dbo].[Usuario_Responsavel];  

go 

CREATE NONCLUSTERED INDEX [IX_Automation_Suspended] ON [dbo].[Automation_Log] ([Suspended] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_ID_Campo] ON [dbo].[Campo_Valor] ([ID_Campo] ASC, [Valor] ASC, [ID_Item] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_SVw_Campo_Valor_01] ON [dbo].[Campo_Valor] ([ID_Campo] ASC, [AttachmentValueId] ASC, [ContactValueId] ASC, [ID_Produto] ASC, [ID_UsuarioValor] ASC, [ID_OpcaoValor] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Produto_ID_Produto3] ON [dbo].[Campo_Valor_Produto] ([ID_Produto] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, ContactValueId, CurrencyValueId, ID, ID_Campo, ID_OpcaoValor, ID_ProdutoValor, ID_UsuarioValor, ValorBooleano, ValorDataHora, ValorDecimal, ValorInteiro, ValorTexto, ValorTextoMultilinha) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Timeline_IDM01] ON [dbo].[Timeline] ([ID_ClientePloomes] ASC, [Principal] ASC, [ID_TipoResponsavel] ASC)  INCLUDE (Cliente, DataHora, Documento, ID_Cliente, ID_Documento, ID_Oportunidade, ID_ResponsavelSecundario, ID_TipoResponsavelSecundario, ID_Usuario, ID_Venda, Oportunidade, Usuario, Venda) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_ID_Item] ON [dbo].[Usuario_Responsavel] ([ID_Tipo] ASC, [ID_Item] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_ID_Responsavel] ON [dbo].[Usuario_Responsavel] ([ID_Responsavel] ASC, [ID_Usuario] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_ID_Usuario] ON [dbo].[Usuario_Responsavel] ([ID_Usuario] ASC, [ID_Responsavel] ASC)  INCLUDE (ID_Item) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_ID_Tipo] ON [dbo].[Usuario_Responsavel] ([ID_Tipo] ASC, [ID_Usuario] ASC, [ID_Responsavel] ASC, [ID_Item] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_Svw_Oportunidade_01] ON [dbo].[Usuario_Responsavel] ([ID_Usuario] ASC, [ID_Responsavel] ASC, [ID_Tipo] ASC, [ID_Item] ASC, [ID] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_SVw_Tarefa_01] ON [dbo].[Usuario_Responsavel] ([ID_Responsavel] ASC, [ID_Tipo] ASC, [ID_Usuario] ASC, [ID_Item] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  