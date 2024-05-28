use Ploomes_CRM
go

SELECT
	sc.name AS SchemaName,
	ob.name AS Table_name,
	id.name AS Index_name,
	us.user_seeks,
	us.user_scans,
	us.user_updates,
	(us.user_seeks + us.user_scans + us.user_lookups) [totalAcesso],
	us.last_user_scan,
	us.last_user_seek,
	us.last_user_lookup
FROM sys.dm_db_index_usage_stats us
JOIN sys.objects  ob ON us.OBJECT_ID = ob.OBJECT_ID
JOIN sys.indexes  id ON id.index_id = us.index_id AND us.OBJECT_ID = id.OBJECT_ID
JOIN sys.schemas  sc ON sc.schema_id = ob.schema_id
WHERE  id.name not like 'PK%'
	--AND id.name not like 'UK%'
	--AND us.user_seeks = 0
	and ob.name like 'produto_grupo'
ORDER BY
		id.name DESC



--CREATE NONCLUSTERED INDEX [IX_Cliente_OrdemTarefas] ON [dbo].[Cliente] ([OrdemTarefas] ASC, [Data_PrimeiraTarefa] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
--CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_ID_Responsavel] ON [dbo].[Usuario_Responsavel] ([ID_Responsavel] ASC, [ID_Usuario] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
--CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_IDM01] ON [dbo].[Usuario_Responsavel] ([ID_Usuario] ASC, [ID_Item] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
--CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_ID_Item] ON [dbo].[Usuario_Responsavel] ([ID_Tipo] ASC, [ID_Item] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
--CREATE NONCLUSTERED INDEX [IX_Venda_ChaveExterna] ON [dbo].[Venda] ([ChaveExterna] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
--CREATE NONCLUSTERED INDEX [IX_Cidade_Pais] ON [dbo].[Cidade] ([ID_Pais] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
--CREATE NONCLUSTERED INDEX [IX_Produto_ID_ClientePloomes3] ON [dbo].[Produto] ([ID_ClientePloomes] ASC, [ID_Grupo] ASC, [Descricao] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  

CREATE NONCLUSTERED INDEX [IX_Anexo_ID_Nota] ON [dbo].[Anexo] ([ID_Nota] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
CREATE NONCLUSTERED INDEX [IX_Anexo_ID_ProdutoFamilia] ON [dbo].[Anexo] ([ID_ProdutoFamilia] ASC) WITH (FILLFACTOR = 100) ON [INDEX];  
CREATE NONCLUSTERED INDEX [Anexo_IDM] ON [dbo].[Anexo] ([ID_Relatorio] ASC)  INCLUDE (Arquivo, AttachmentItemId, Bytes, ChatId, ID_Cliente, 
ID_ClientePloomes, ID_CotacaoRevisao, ID_Criador, ID_Documento, ID_Email, ID_EmailTemplate, ID_Item, ID_Lead, ID_Nota, ID_Oportunidade, ID_Produto, ID_ProdutoFamilia, ID_ProdutoGrupo, 
ID_Tarefa, ID_TipoItem, ID_Usuario, ID_Venda, IsSensitiveData, Listable, MessageId, Tipo, Url) WITH (FILLFACTOR = 100) ON [INDEX]; 

CREATE INDEX [IX_Ploomes_Cliente_Integration_CustomField] ON [Ploomes_CRM].[dbo].[Ploomes_Cliente_Integration_CustomField] ([CustomFieldId]) INCLUDE ([FieldId]) ON [INDEX]; 
CREATE INDEX [IX_Oportunidade_Funil] ON [Ploomes_CRM].[dbo].[Oportunidade_Funil] ([Suspenso]) INCLUDE ([ID_ClientePloomes]) ON [INDEX]; 
CREATE INDEX [IX_Oportunidade_Funil_IDM02] ON [Ploomes_CRM].[dbo].[Oportunidade_Funil] ([Suspenso]) ON [INDEX]; 

CREATE INDEX [IX_Cliente_IDM01] ON [Ploomes_CRM].[dbo].[Cliente] ([Nome], [Suspenso]) ON [INDEX]; 
CREATE INDEX [IX_Marcador_IDM01] ON [Ploomes_CRM].[dbo].[Marcador] ([ID_TipoItem], [Suspenso],[Marcador]) INCLUDE ([Cor]) ON [INDEX]; 
CREATE INDEX [IX_Cliente_IDM] ON [Ploomes_CRM].[dbo].[Cliente] ([Nome]) ON [INDEX]; 
CREATE INDEX [IX_Oportunidade_Funil_IDM] ON [Ploomes_CRM].[dbo].[Oportunidade_Funil] ([Suspenso]) INCLUDE ([PassaTodosEstagios], [ProibidoVoltarEstagios], [GanhaNoUltimoEstagio], [VenceOportunidades], [PerdeOportunidades]) ON [INDEX]; 
CREATE INDEX [IX_Campo_Valor_Oportunidade_IDM] ON [Ploomes_CRM].[dbo].[Campo_Valor_Oportunidade] ([ID_Campo], [ValorInteiro]) INCLUDE ([ID_Oportunidade]) ON [INDEX]; 
CREATE INDEX [IX_Cotacao_IDM] ON [Ploomes_CRM].[dbo].[Cotacao] ([Suspenso]) INCLUDE ([ID_Oportunidade], [ID_UltimaRevisao]) ON [INDEX]; 
CREATE INDEX [IX_Marcador_Item_IDM01] ON [Ploomes_CRM].[dbo].[Marcador_Item] ([ID_Marcador]) INCLUDE ([ID_Oportunidade]) ON [INDEX]; 
CREATE INDEX [IX_Cotacao_Revisao_IDM] ON [Ploomes_CRM].[dbo].[Cotacao_Revisao] ([Suspenso], [ID_ClientePloomes],[ID]) INCLUDE ([ID_Cotacao], [Data], [ID_NivelAprovacao]) ON [INDEX]; 
CREATE INDEX [IX_Notificacao_IDM] ON [Ploomes_CRM].[dbo].[Notificacao] ([ID_Usuario], [AccountId]) INCLUDE ([ID_UsuarioRealizador], [DataHora], [ID_Tipo], [ID_Item], [ID_Comentario], [Visto], [DaysToExpire], [StringTargetId]) ON [INDEX]; 
CREATE INDEX [IX_Marcador_IDM] ON [Ploomes_CRM].[dbo].[Marcador] ([ID_TipoItem], [Suspenso],[Marcador]) ON [INDEX]; 
