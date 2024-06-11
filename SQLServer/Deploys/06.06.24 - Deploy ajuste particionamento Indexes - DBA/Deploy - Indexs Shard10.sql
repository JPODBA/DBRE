use Ploomes_CRM
go
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Cliente2] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Cliente3] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cotacao_DBA01] ON [dbo].[Campo_Valor_Cotacao];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Oportunidade_IDM01] ON [dbo].[Campo_Valor_Oportunidade];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Order_Product_Order_ProductId2] ON [dbo].[Campo_Valor_Order_Product];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Produto_ID_Produto3] ON [dbo].[Campo_Valor_Produto];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Quote_Product_Quote_ProductId2] ON [dbo].[Campo_Valor_Quote_Product];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Quote_Product_QuoteProductId] ON [dbo].[Campo_Valor_Quote_Product];  
Go 
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Order_Product_Order_ProductId2] ON [dbo].[Campo_Valor_Order_Product] ([Order_ProductId] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, BigStringValue, BoolValue, ContactValueId, CurrencyValueId, DateTimeValue, DecimalValue, FieldId, Id, IntegerValue, ObjectValueId, ProductValueId, StringValue, UserValueId) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Cliente2] ON [dbo].[Campo_Valor_Cliente] ([ID_Cliente] ASC)  INCLUDE (AttachmentValueId, ContactValueId, CurrencyValueId, ID, ID_Campo, ID_OpcaoValor, ID_ProdutoValor, ID_UsuarioValor, ValorBooleano, ValorDataHora, ValorDecimal, ValorInteiro, ValorTexto, ValorTextoMultilinha) WITH (FILLFACTOR = 100) ON [INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Cliente3] ON [dbo].[Campo_Valor_Cliente] ([ID_Cliente] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, ContactValueId, CurrencyValueId, ID, ID_Campo, ID_OpcaoValor, ID_ProdutoValor, ID_UsuarioValor, ValorBooleano, ValorDataHora, ValorDecimal, ValorInteiro, ValorTexto, ValorTextoMultilinha) WITH (FILLFACTOR = 100) ON [INDEX_04];  
sp_helpindex 'Campo_Valor_Cliente'

CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cotacao_DBA01] ON [dbo].[Campo_Valor_Cotacao] ([ID_Cotacao] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, ContactValueId, CurrencyValueId, ID_Campo, ID_OpcaoValor, ID_ProdutoValor, ID_UsuarioValor, ValorBooleano, ValorDataHora, ValorDecimal, ValorInteiro, ValorTexto, ValorTextoMultilinha) WITH (FILLFACTOR = 100) ON [INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Oportunidade_IDM01] ON [dbo].[Campo_Valor_Oportunidade] ([ID_Oportunidade] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, ContactValueId, CurrencyValueId, ID_Campo, ID_OpcaoValor, ID_ProdutoValor, ID_UsuarioValor, ValorBooleano, ValorDataHora, ValorDecimal, ValorInteiro, ValorTexto, ValorTextoMultilinha) WITH (FILLFACTOR = 100) ON [INDEX_03];  

CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Produto_ID_Produto3] ON [dbo].[Campo_Valor_Produto] ([ID_Produto] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, ContactValueId, CurrencyValueId, ID, ID_Campo, ID_OpcaoValor, ID_ProdutoValor, ID_UsuarioValor, ValorBooleano, ValorDataHora, ValorDecimal, ValorInteiro, ValorTexto, ValorTextoMultilinha) WITH (FILLFACTOR = 100) ON [INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Quote_Product_Quote_ProductId2] ON [dbo].[Campo_Valor_Quote_Product] ([Quote_ProductId] ASC)  INCLUDE (AttachmentValueId, BigStringValue, BoolValue, ContactValueId, CurrencyValueId, DateTimeValue, DecimalValue, FieldId, Id, IntegerValue, ObjectValueId, ProductValueId, StringValue, UserValueId) WITH (FILLFACTOR = 100) ON [INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Quote_Product_QuoteProductId] ON [dbo].[Campo_Valor_Quote_Product] ([Quote_ProductId] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, BigStringValue, BoolValue, ContactValueId, CurrencyValueId, DateTimeValue, DecimalValue, FieldId, Id, IntegerValue, ObjectValueId, ProductValueId, StringValue, UserValueId) WITH (FILLFACTOR = 100) ON [INDEX_02];  