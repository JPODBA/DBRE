Select top 10 * from BA_DBA.dbo.DBA_MONITOR_MISSING_INDEX order by user_seeks desc
Select top 10 * from BA_DBA.dbo.DBA_MONITOR_MISSING_INDEX order by avg_user_impact desc

go 
use Ploomes_CRM
go
sp_helpindex '[Campo_Valor_Cotacao]'
sp_help '[Campo_Valor_Cotacao]'

CREATE INDEX [IX_Campo_Valor_Cotacao_IDM01] ON [Ploomes_CRM].[dbo].[Campo_Valor_Cotacao] ([ValorInteiro]) INCLUDE ([ID_Cotacao], [ID_Campo]) 
CREATE INDEX [IX_Ploomes_Cliente_Integration_CustomField_IDM01] ON [Ploomes_CRM].[dbo].[Ploomes_Cliente_Integration_CustomField] ([CustomFieldId]) INCLUDE ([FieldId]) on INDEX_02
CREATE INDEX [IX_Campo_Valor_Oportunidade_IDM01] ON [Ploomes_CRM].[dbo].[Campo_Valor_Oportunidade] ([ID_Oportunidade]) 
INCLUDE ([ID_Campo], [ValorTexto], [ValorTextoMultilinha], [ValorInteiro], [ValorDecimal], [ValorDataHora], [ValorBooleano],
[ID_OpcaoValor], [ID_UsuarioValor], [ID_ProdutoValor], [AttachmentValueId], [ContactValueId], [CurrencyValueId], [AttachmentItemValueId]) on INDEX_02