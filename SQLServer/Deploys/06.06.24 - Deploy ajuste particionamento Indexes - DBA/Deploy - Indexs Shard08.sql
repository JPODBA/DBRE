use Ploomes_CRM
go

DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Cliente2] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Cliente3] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Quote_Product_QuoteProductId] ON [dbo].[Campo_Valor_Quote_Product];  


CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Cliente2] ON [dbo].[Campo_Valor_Cliente] ([ID_Cliente] ASC)  INCLUDE (AttachmentValueId, ContactValueId, CurrencyValueId, ID, ID_Campo, ID_OpcaoValor, ID_ProdutoValor, ID_UsuarioValor, ValorBooleano, ValorDataHora, ValorDecimal, ValorInteiro, ValorTexto, ValorTextoMultilinha) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Cliente3] ON [dbo].[Campo_Valor_Cliente] ([ID_Cliente] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, ContactValueId, CurrencyValueId, ID, ID_Campo, ID_OpcaoValor, ID_ProdutoValor, ID_UsuarioValor, ValorBooleano, ValorDataHora, ValorDecimal, ValorInteiro, ValorTexto, ValorTextoMultilinha) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Quote_Product_QuoteProductId] ON [dbo].[Campo_Valor_Quote_Product] ([Quote_ProductId] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, BigStringValue, BoolValue, ContactValueId, CurrencyValueId, DateTimeValue, DecimalValue, FieldId, Id, IntegerValue, ObjectValueId, ProductValueId, StringValue, UserValueId) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  