sp_helpindex 'Anexo'
sp_help 'Anexo'


drop index if exists Anexo.IX_Anexo_ID_Tarefa
drop index if exists Anexo.IX_Anexo_ID_Tarefa2
GO

CREATE INDEX [IX_Anexo_ID_Tarefa] ON [Ploomes_CRM].[dbo].[Anexo] ([ID_Tarefa], [Listable]) 
INCLUDE ([ID_TipoItem], [ID_Item], [Arquivo], [Tipo], [Bytes], [Url], [ID_Criador], [ID_Cliente], [ID_Venda], [ID_Nota], [ID_Relatorio], [ID_Email], 
[ID_Lead], [ID_Oportunidade], [ID_EmailTemplate], [ID_Documento], [ID_CotacaoRevisao], [ID_Produto], 
[ID_ProdutoGrupo], [ID_ProdutoFamilia], [ID_ClientePloomes], [ID_Usuario], [ChatId], [MessageId], [AttachmentItemId], [IsSensitiveData])