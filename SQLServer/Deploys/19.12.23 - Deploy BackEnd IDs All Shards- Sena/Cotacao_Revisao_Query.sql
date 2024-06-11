begin tran

use Ploomes_CRM
go

-- CRIAR UMA TABELA TEMPORÁRIA
CREATE TABLE [dbo].[Cotacao_Revisao_Query_Temp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[QuoteId] [int] NOT NULL,
	[RootODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[SelfODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[SectionsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[ProductsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[PartsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Cotacao_Revisao_Query_Temp] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY]
GO

-- SETAR IDENTITY PARA INSERIR OS NOVOS IDS
SET IDENTITY_INSERT [dbo].[Cotacao_Revisao_Query_Temp] ON
GO

-- INSERIR NOVOS IDS NA TABELA TEMP
INSERT INTO Cotacao_Revisao_Query_Temp (Id, QuoteId, RootODataQuery, SelfODataQuery, SectionsODataQuery, ProductsODataQuery, PartsODataQuery)
SELECT Id + 400000000, QuoteId, RootODataQuery, SelfODataQuery, SectionsODataQuery, ProductsODataQuery, PartsODataQuery
FROM Cotacao_Revisao_Query

Declare @id int
SELECT @id = MAX(ID) + 1 FROM Cotacao_Revisao_Query_Temp

DBCC CHECKIDENT ('Cotacao_Revisao_Query_Temp', RESEED, @id)

-- VOLTAR O IDENTITY
SET IDENTITY_INSERT [dbo].[Cotacao_Revisao_Query_Temp] OFF
GO

-- ATUALIZAR TODO MUNDO PARA APONTAR PARA O NOVO ID
UPDATE Cotacao_Revisao
SET QueryId = QueryId + 400000000
WHERE QueryId IS NOT NULL

Select * from Cotacao_Revisao_Query_Temp order by Id desc
Select top 10 * from Cotacao_Revisao_Query order by Id desc -- 8477
Select top 10 * from Cotacao_Revisao_Query_old order by Id desc -- 8477

-- RENOMEAR A TABELA ANTIGA PARA OLD E A NOVA PARA SER ORIGINAL
EXEC sp_rename 'dbo.Cotacao_Revisao_Query', 'Cotacao_Revisao_Query_Old'
EXEC sp_rename 'dbo.Cotacao_Revisao_Query_Temp', 'Cotacao_Revisao_Query'

-- RENOMEAR AS PKs PARA TEREM O NOME CORRETO
EXEC sp_rename 'dbo.PK_Cotacao_Revisao_Query', 'PK_Cotacao_Revisao_Query_Old', 'OBJECT'
EXEC sp_rename 'dbo.PK_Cotacao_Revisao_Query_Temp', 'PK_Cotacao_Revisao_Query', 'OBJECT'

EXEC sp_rename 'Cotacao_Revisao_Query_Old.IX_Cotacao_Revisao_Query_QuoteId', 'IX_Cotacao_Revisao_Query_QuoteId_Old', 'INDEX';


-- CRIAR INDEX E TRIGGER QUE EXISTEM NA TABELA ORIGINAL
CREATE NONCLUSTERED INDEX [IX_Cotacao_Revisao_Query_QuoteId] ON [dbo].[Cotacao_Revisao_Query]
(
	[QuoteId] ASC
)WITH (FILLFACTOR = 100) ON [PRIMARY]
GO

commit
rollback