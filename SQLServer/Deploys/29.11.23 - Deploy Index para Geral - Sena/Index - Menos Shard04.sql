use Ploomes_CRM
go

CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_Contato] ON [dbo].[Oportunidade]
(
    ID_Contato ASC
)WITH (FILLFACTOR = 100) ON [INDEX_03]
GO