use Ploomes_CRM
GO
-- 
DROP INDEX IF EXISTS [IX_Relatorio_ID_Oportunidade_ID_Cliente] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_CallStatusId] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [Timeline_DBA02] ON [dbo].[Timeline];  
DROP INDEX IF EXISTS [IX_Usuario_Responsavel_ID_Usuario] ON [dbo].[Usuario_Responsavel];  
DROP INDEX IF EXISTS [IX_Usuario_Responsavel_IDM01] ON [dbo].[Usuario_Responsavel];  

CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_Oportunidade_ID_Cliente] ON [dbo].[Relatorio] ([ID_Oportunidade] ASC, [ID_Cliente] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_CallStatusId] ON [dbo].[Relatorio] ([CallStatusId] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [Timeline_DBA02] ON [dbo].[Timeline] ([ID_ClientePloomes] ASC, [Principal] ASC)  INCLUDE (Cliente, DataHora, Documento, ID_Cliente, ID_Documento, ID_Oportunidade, ID_Responsavel, ID_ResponsavelSecundario, ID_TipoResponsavel, ID_TipoResponsavelSecundario, ID_Usuario, ID_Venda, Oportunidade, Usuario, Venda) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_ID_Usuario] ON [dbo].[Usuario_Responsavel] ([ID_Usuario] ASC, [ID_Responsavel] ASC)  INCLUDE (ID_Item) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_IDM01] ON [dbo].[Usuario_Responsavel] ([ID_Usuario] ASC, [ID_Item] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  

go 

-- Saindo Ploomes_CRM_INDEX > [Ploomes_CRM_INDEX_03]
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Cliente2] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Cliente3] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Oportunidade_ID_Campo_Texto] ON [dbo].[Campo_Valor_Oportunidade];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Order_Product_Order_ProductId2] ON [dbo].[Campo_Valor_Order_Product];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Produto_ID_Produto3] ON [dbo].[Campo_Valor_Produto];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Quote_Product_QuoteProductId] ON [dbo].[Campo_Valor_Quote_Product];  

CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Cliente2] ON [dbo].[Campo_Valor_Cliente] ([ID_Cliente] ASC)  INCLUDE (AttachmentValueId, ContactValueId, CurrencyValueId, ID, ID_Campo, ID_OpcaoValor, ID_ProdutoValor, ID_UsuarioValor, ValorBooleano, ValorDataHora, ValorDecimal, ValorInteiro, ValorTexto, ValorTextoMultilinha) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Cliente3] ON [dbo].[Campo_Valor_Cliente] ([ID_Cliente] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, ContactValueId, CurrencyValueId, ID, ID_Campo, ID_OpcaoValor, ID_ProdutoValor, ID_UsuarioValor, ValorBooleano, ValorDataHora, ValorDecimal, ValorInteiro, ValorTexto, ValorTextoMultilinha) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Oportunidade_ID_Campo_Texto] ON [dbo].[Campo_Valor_Oportunidade] ([ID_Campo] ASC, [ValorTexto] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Order_Product_Order_ProductId2] ON [dbo].[Campo_Valor_Order_Product] ([Order_ProductId] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, BigStringValue, BoolValue, ContactValueId, CurrencyValueId, DateTimeValue, DecimalValue, FieldId, Id, IntegerValue, ObjectValueId, ProductValueId, StringValue, UserValueId) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Produto_ID_Produto3] ON [dbo].[Campo_Valor_Produto] ([ID_Produto] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, ContactValueId, CurrencyValueId, ID, ID_Campo, ID_OpcaoValor, ID_ProdutoValor, ID_UsuarioValor, ValorBooleano, ValorDataHora, ValorDecimal, ValorInteiro, ValorTexto, ValorTextoMultilinha) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Quote_Product_QuoteProductId] ON [dbo].[Campo_Valor_Quote_Product] ([Quote_ProductId] ASC)  INCLUDE (AttachmentItemValueId, AttachmentValueId, BigStringValue, BoolValue, ContactValueId, CurrencyValueId, DateTimeValue, DecimalValue, FieldId, Id, IntegerValue, ObjectValueId, ProductValueId, StringValue, UserValueId) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_03];  

go 

DROP INDEX IF EXISTS [IX_Anexo_ID_Tarefa2] ON [dbo].[Anexo];  
DROP INDEX IF EXISTS [IX_Campo_Valor_ID_CotacaoRevisaoTabela] ON [dbo].[Campo_Valor];  
DROP INDEX IF EXISTS [IX_Campo_Valor_ID_CotacaoRevisaoTabelaProdutoParte] ON [dbo].[Campo_Valor];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Campo_Booleano] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Campo_DataHora] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Campo_Decimal] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Campo_Inteiro] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Campo_Texto] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cliente_ID_Cliente] ON [dbo].[Campo_Valor_Cliente];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cotacao_ID_Campo_DataHora] ON [dbo].[Campo_Valor_Cotacao];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cotacao_ID_Campo_Inteiro] ON [dbo].[Campo_Valor_Cotacao];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cotacao_ID_Campo_Texto] ON [dbo].[Campo_Valor_Cotacao];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cotacao_ID_Cotacao] ON [dbo].[Campo_Valor_Cotacao];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cotacao_ID_Cotacao2] ON [dbo].[Campo_Valor_Cotacao];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Cotacao_ValorTexto] ON [dbo].[Campo_Valor_Cotacao];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Oportunidade_ID_Campo_Booleano] ON [dbo].[Campo_Valor_Oportunidade];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Oportunidade_ID_Campo_DataHora] ON [dbo].[Campo_Valor_Oportunidade];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Oportunidade_ID_Campo_Decimal] ON [dbo].[Campo_Valor_Oportunidade];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Oportunidade_ID_Campo_Inteiro] ON [dbo].[Campo_Valor_Oportunidade];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Oportunidade_ID_Oportunidade] ON [dbo].[Campo_Valor_Oportunidade];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Oportunidade_ID_Oportunidade2] ON [dbo].[Campo_Valor_Oportunidade];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Order_FieldId] ON [dbo].[Campo_Valor_Order];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Order_IntegerValue] ON [dbo].[Campo_Valor_Order];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Order_OrderId2] ON [dbo].[Campo_Valor_Order];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Order_StringValue] ON [dbo].[Campo_Valor_Order];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Order_Product_Order_ProductId] ON [dbo].[Campo_Valor_Order_Product];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Order_Product_StringValue2] ON [dbo].[Campo_Valor_Order_Product];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Produto_ID_Produto2] ON [dbo].[Campo_Valor_Produto];  
DROP INDEX IF EXISTS [IX_Campo_Valor_Quote_Product_Quote_ProductId] ON [dbo].[Campo_Valor_Quote_Product];  
DROP INDEX IF EXISTS [IX_Cliente_Email] ON [dbo].[Cliente];  
DROP INDEX IF EXISTS [IX_Cliente_ID_ClientePloomes4] ON [dbo].[Cliente];  
DROP INDEX IF EXISTS [IX_Cliente_ID_ClientePloomes5] ON [dbo].[Cliente];  
DROP INDEX IF EXISTS [IX_Cliente_Suspenso] ON [dbo].[Cliente];  
DROP INDEX IF EXISTS [IX_Cliente_Suspenso2] ON [dbo].[Cliente];  
DROP INDEX IF EXISTS [IX_CSH_Cli_St_DtCri_DtAt] ON [dbo].[Cliente_Status_Historico];  
DROP INDEX IF EXISTS [IX_Log_Acao] ON [dbo].[Log_Acao];  
DROP INDEX IF EXISTS [IX_Notificacao_ID_Item] ON [dbo].[Notificacao];  
DROP INDEX IF EXISTS [IX_Notificacao_ID_Usuario] ON [dbo].[Notificacao];  
DROP INDEX IF EXISTS [IX_Notificacao_ID_Usuario2] ON [dbo].[Notificacao];  
DROP INDEX IF EXISTS [IX_Oportunidade_Status_Historico_ID_Oportunidade] ON [dbo].[Oportunidade_Status_Historico];  
DROP INDEX IF EXISTS [IX_OSH_Op_St_DtCri] ON [dbo].[Oportunidade_Status_Historico];  
DROP INDEX IF EXISTS [IX_OSH_Op_St_StNv_DtCri_DtAt] ON [dbo].[Oportunidade_Status_Historico];  
DROP INDEX IF EXISTS [IX_Relatorio_ID_Cliente] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_ID_Cliente_DBA01] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_ID_ClientePloomes] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_ID_Criador] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_ID_Criador2] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_ID_Oportunidade] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_ID_TarefaConclusao] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_ID_TipoResponsavel2] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_ID_TipoResponsavel3] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_ID_TipoResponsavel4] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_Suspenso] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_Suspenso2] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_Suspenso3] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_Suspenso4] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Relatorio_ID_Cliente_DBA02] ON [dbo].[Relatorio];  
DROP INDEX IF EXISTS [IX_Tarefa_Conclusao_DataRecorrencia] ON [dbo].[Tarefa_Conclusao];  
DROP INDEX IF EXISTS [IX_Timeline_ID_Cliente] ON [dbo].[Timeline];  
DROP INDEX IF EXISTS [IX_Timeline_ID_ClientePloomes] ON [dbo].[Timeline];  
DROP INDEX IF EXISTS [IX_Timeline_ID_Oportunidade] ON [dbo].[Timeline];  
DROP INDEX IF EXISTS [IX_Timeline_ID_TipoItem] ON [dbo].[Timeline];  
DROP INDEX IF EXISTS [IX_Timeline_ID_Usuario] ON [dbo].[Timeline];  
DROP INDEX IF EXISTS [IX_Timeline_ID_Venda] ON [dbo].[Timeline];  
DROP INDEX IF EXISTS [IX_Usuario_Responsavel_ID_Responsavel] ON [dbo].[Usuario_Responsavel];  
DROP INDEX IF EXISTS [IX_Usuario_Responsavel_ID_Tipo] ON [dbo].[Usuario_Responsavel];  
DROP INDEX IF EXISTS [IX_Usuario_Responsavel_ID_Tipo2] ON [dbo].[Usuario_Responsavel]; 


go 

CREATE NONCLUSTERED INDEX [IX_Anexo_ID_Tarefa2] ON [dbo].[Anexo] ([ID_Tarefa] ASC, [Listable] ASC)  INCLUDE (Arquivo, AttachmentItemId, Bytes, ChatId, ID, ID_Cliente, ID_ClientePloomes, ID_CotacaoRevisao, ID_Documento, ID_Email, ID_EmailTemplate, ID_Item, ID_Lead, ID_Nota, ID_Oportunidade, ID_Produto, ID_ProdutoFamilia, ID_ProdutoGrupo, ID_Relatorio, ID_TipoItem, ID_Usuario, ID_Venda, IsSensitiveData, MessageId, Tipo, Url) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_ID_CotacaoRevisaoTabela] ON [dbo].[Campo_Valor] ([ID_CotacaoRevisaoTabela] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_ID_CotacaoRevisaoTabelaProdutoParte] ON [dbo].[Campo_Valor] ([ID_CotacaoRevisaoTabelaProdutoParte] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Campo_Booleano] ON [dbo].[Campo_Valor_Cliente] ([ID_Campo] ASC, [ValorBooleano] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Campo_DataHora] ON [dbo].[Campo_Valor_Cliente] ([ID_Campo] ASC, [ValorDataHora] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Campo_Decimal] ON [dbo].[Campo_Valor_Cliente] ([ID_Campo] ASC, [ValorDecimal] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Campo_Inteiro] ON [dbo].[Campo_Valor_Cliente] ([ID_Campo] ASC, [ValorInteiro] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Campo_Texto] ON [dbo].[Campo_Valor_Cliente] ([ID_Campo] ASC, [ValorTexto] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cliente_ID_Cliente] ON [dbo].[Campo_Valor_Cliente] ([ID_Cliente] ASC, [ID_Campo] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cotacao_ID_Campo_DataHora] ON [dbo].[Campo_Valor_Cotacao] ([ID_Campo] ASC, [ValorDataHora] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cotacao_ID_Campo_Inteiro] ON [dbo].[Campo_Valor_Cotacao] ([ID_Campo] ASC, [ValorInteiro] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cotacao_ID_Campo_Texto] ON [dbo].[Campo_Valor_Cotacao] ([ID_Campo] ASC, [ValorTexto] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cotacao_ID_Cotacao] ON [dbo].[Campo_Valor_Cotacao] ([ID_Cotacao] ASC, [ID_Campo] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cotacao_ID_Cotacao2] ON [dbo].[Campo_Valor_Cotacao] ([ID_Cotacao] ASC, [ValorDecimal] ASC)  INCLUDE (ID_Campo) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Cotacao_ValorTexto] ON [dbo].[Campo_Valor_Cotacao] ([ValorTexto] ASC)  INCLUDE (ID_Campo, ID_Cotacao) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Oportunidade_ID_Campo_Booleano] ON [dbo].[Campo_Valor_Oportunidade] ([ID_Campo] ASC, [ValorBooleano] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Oportunidade_ID_Campo_DataHora] ON [dbo].[Campo_Valor_Oportunidade] ([ID_Campo] ASC, [ValorDataHora] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Oportunidade_ID_Campo_Decimal] ON [dbo].[Campo_Valor_Oportunidade] ([ID_Campo] ASC, [ValorDecimal] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Oportunidade_ID_Campo_Inteiro] ON [dbo].[Campo_Valor_Oportunidade] ([ID_Campo] ASC, [ValorInteiro] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Oportunidade_ID_Oportunidade] ON [dbo].[Campo_Valor_Oportunidade] ([ID_Oportunidade] ASC, [ID_Campo] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Oportunidade_ID_Oportunidade2] ON [dbo].[Campo_Valor_Oportunidade] ([ID_Oportunidade] ASC, [ValorTexto] ASC)  INCLUDE (ID_Campo) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Order_FieldId] ON [dbo].[Campo_Valor_Order] ([FieldId] ASC, [BoolValue] ASC)  INCLUDE (OrderId) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Order_IntegerValue] ON [dbo].[Campo_Valor_Order] ([FieldId] ASC, [IntegerValue] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Order_OrderId2] ON [dbo].[Campo_Valor_Order] ([OrderId] ASC)  INCLUDE (DateTimeValue, FieldId) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Order_StringValue] ON [dbo].[Campo_Valor_Order] ([FieldId] ASC, [StringValue] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Order_Product_Order_ProductId] ON [dbo].[Campo_Valor_Order_Product] ([Order_ProductId] ASC, [FieldId] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Order_Product_StringValue2] ON [dbo].[Campo_Valor_Order_Product] ([StringValue] ASC)  INCLUDE (FieldId, Order_ProductId) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Produto_ID_Produto2] ON [dbo].[Campo_Valor_Produto] ([ID_Produto] ASC)  INCLUDE (ContactValueId, ID, ID_Campo, ID_OpcaoValor, ID_UsuarioValor, ValorBooleano, ValorDecimal, ValorInteiro, ValorTexto) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Campo_Valor_Quote_Product_Quote_ProductId] ON [dbo].[Campo_Valor_Quote_Product] ([Quote_ProductId] ASC, [FieldId] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Cliente_Email] ON [dbo].[Cliente] ([Email] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Cliente_ID_ClientePloomes4] ON [dbo].[Cliente] ([ID_ClientePloomes] ASC, [Suspenso] ASC, [Nome] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Cliente_ID_ClientePloomes5] ON [dbo].[Cliente] ([ID_ClientePloomes] ASC, [ID_Responsavel] ASC, [Suspenso] ASC, [Nome] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Cliente_Suspenso] ON [dbo].[Cliente] ([Suspenso] ASC)  INCLUDE (Data_PrimeiraTarefa, DataCriacao, ID, ID_ClientePloomes, ID_Responsavel, ID_Segmento, ID_Tipo, Nome, OrdemTarefas) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Cliente_Suspenso2] ON [dbo].[Cliente] ([ID_ClientePloomes] ASC, [Suspenso] ASC)  INCLUDE (Data_PrimeiraTarefa, DataCriacao, ID, ID_Responsavel, ID_Segmento, ID_Tipo, Nome) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_CSH_Cli_St_DtCri_DtAt] ON [dbo].[Cliente_Status_Historico] ([ID_Cliente] ASC, [ID_Status] ASC, [DataCriacao] DESC, [DataAtualizacao] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Log_Acao] ON [dbo].[Log_Acao] ([ID_Usuario] ASC, [DataHora] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Notificacao_ID_Item] ON [dbo].[Notificacao] ([ID_Item] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Notificacao_ID_Usuario] ON [dbo].[Notificacao] ([ID_Usuario] ASC, [Visto] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Notificacao_ID_Usuario2] ON [dbo].[Notificacao] ([ID_Usuario] ASC, [DataHora] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Oportunidade_Status_Historico_ID_Oportunidade] ON [dbo].[Oportunidade_Status_Historico] ([ID_Oportunidade] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_OSH_Op_St_DtCri] ON [dbo].[Oportunidade_Status_Historico] ([ID_Oportunidade] ASC, [ID_Status] ASC, [DataCriacao] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_OSH_Op_St_StNv_DtCri_DtAt] ON [dbo].[Oportunidade_Status_Historico] ([ID_Oportunidade] ASC, [ID_Status] ASC, [ID_StatusNovo] ASC, [DataCriacao] DESC, [DataAtualizacao] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_Cliente] ON [dbo].[Relatorio] ([ID_Cliente] ASC, [ID_Oportunidade] ASC, [Data] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_Cliente_DBA01] ON [dbo].[Relatorio] ([ID_Cliente] ASC, [Suspenso] ASC, [ID] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_ClientePloomes] ON [dbo].[Relatorio] ([ID_ClientePloomes] ASC, [ID_Responsavel] ASC, [ID_TipoResponsavel] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_Criador] ON [dbo].[Relatorio] ([ID_ClientePloomes] ASC, [ID_Criador] ASC, [Suspenso] ASC, [Data] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_Criador2] ON [dbo].[Relatorio] ([ID_Criador] ASC, [Suspenso] ASC)  INCLUDE (Data, ID) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_Oportunidade] ON [dbo].[Relatorio] ([ID_Oportunidade] ASC, [ID_Criador] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_TarefaConclusao] ON [dbo].[Relatorio] ([ID_TarefaConclusao] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_TipoResponsavel2] ON [dbo].[Relatorio] ([ID_ClientePloomes] ASC, [ID_TipoResponsavel] ASC, [ID_Cliente] ASC, [Suspenso] ASC, [Data] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_TipoResponsavel3] ON [dbo].[Relatorio] ([ID_ClientePloomes] ASC, [ID_TipoResponsavel] ASC, [ID_Oportunidade] ASC, [Suspenso] ASC, [Data] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_TipoResponsavel4] ON [dbo].[Relatorio] ([ID_ClientePloomes] ASC, [ID_TipoResponsavel] ASC, [ID_Responsavel] ASC, [ID_Criador] ASC, [Suspenso] ASC, [Data] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_Suspenso] ON [dbo].[Relatorio] ([Suspenso] ASC)  INCLUDE (Data, ID, ID_Criador) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_Suspenso2] ON [dbo].[Relatorio] ([Suspenso] ASC)  INCLUDE (Data, ID, ID_Classe, ID_Criador) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_Suspenso3] ON [dbo].[Relatorio] ([Suspenso] ASC, [ID_Classe] ASC, [DataCriacao] ASC)  INCLUDE (ID, ID_Criador) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_Suspenso4] ON [dbo].[Relatorio] ([Suspenso] ASC)  INCLUDE (Data, DataCriacao, ID, ID_Criador) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Relatorio_ID_Cliente_DBA02] ON [dbo].[Relatorio] ([ID_Oportunidade] ASC, [Suspenso] ASC, [ID] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Tarefa_Conclusao_DataRecorrencia] ON [dbo].[Tarefa_Conclusao] ([DataRecorrencia] DESC)  INCLUDE (Concluido, ID_ClientePloomes, ID_Responsavel, ID_Tarefa, ID_TipoResponsavel) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Timeline_ID_Cliente] ON [dbo].[Timeline] ([ID_Cliente] ASC, [DataHora] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Timeline_ID_ClientePloomes] ON [dbo].[Timeline] ([ID_ClientePloomes] ASC, [ID_TipoResponsavel] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Timeline_ID_Oportunidade] ON [dbo].[Timeline] ([ID_Oportunidade] ASC, [DataHora] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Timeline_ID_TipoItem] ON [dbo].[Timeline] ([ID_TipoItem] ASC, [ID_Item] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Timeline_ID_Usuario] ON [dbo].[Timeline] ([ID_Usuario] ASC, [DataHora] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Timeline_ID_Venda] ON [dbo].[Timeline] ([ID_Venda] ASC, [DataHora] DESC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_ID_Responsavel] ON [dbo].[Usuario_Responsavel] ([ID_Responsavel] ASC, [ID_Usuario] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_04];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_ID_Tipo] ON [dbo].[Usuario_Responsavel] ([ID_Tipo] ASC, [ID_Usuario] ASC, [ID_Responsavel] ASC, [ID_Item] ASC) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  
CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_ID_Tipo2] ON [dbo].[Usuario_Responsavel] ([ID_Tipo] ASC, [ID_Item] ASC)  INCLUDE (ID, ID_Responsavel, ID_Usuario) WITH (FILLFACTOR = 100) ON [Ploomes_CRM_INDEX_02];  