begin tran

use Ploomes_CRM
go

-- CRIAR UMA TABELA TEMPORÁRIA
CREATE TABLE [dbo].[Venda_Query_Temp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[RootODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[SelfODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[SectionsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[ProductsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[PartsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Venda_Query_Temp] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY]
GO

-- SETAR IDENTITY PARA INSERIR OS NOVOS IDS
SET IDENTITY_INSERT [dbo].[Venda_Query_Temp] ON
GO

-- INSERIR NOVOS IDS NA TABELA TEMP
INSERT INTO Venda_Query_Temp (Id, OrderId, RootODataQuery, SelfODataQuery, SectionsODataQuery, ProductsODataQuery, PartsODataQuery)
SELECT Id + 400000000, OrderId, RootODataQuery, SelfODataQuery, SectionsODataQuery, ProductsODataQuery, PartsODataQuery
FROM Venda_Query

Declare @id int
SELECT @id = MAX(ID) + 1 FROM Venda_Query_Temp

DBCC CHECKIDENT ('Venda_Query_Temp', RESEED, @id)

-- VOLTAR O IDENTITY
SET IDENTITY_INSERT [dbo].[Venda_Query_Temp] OFF
GO

-- ATUALIZAR TODO MUNDO PARA APONTAR PARA O NOVO ID
UPDATE Venda
SET QueryId = QueryId + 400000000
WHERE QueryId IS NOT NULL

SELECT TOP 10 * FROM Venda where queryid is not null order by queryid desc

-- RENOMEAR A TABELA ANTIGA PARA OLD E A NOVA PARA SER ORIGINAL
EXEC sp_rename 'dbo.Venda_Query', 'Venda_Query_Old'
EXEC sp_rename 'dbo.Venda_Query_Temp', 'Venda_Query'

-- RENOMEAR AS PKs PARA TEREM O NOME CORRETO
EXEC sp_rename 'dbo.PK_Venda_Query', 'PK_Venda_Query_Old', 'OBJECT'
EXEC sp_rename 'dbo.PK_Venda_Query_Temp', 'PK_Venda_Query', 'OBJECT'

EXEC sp_rename 'Venda_Query_Old.IX_Venda_Query_OrderId', 'IX_Venda_Query_OrderId_Old', 'INDEX';


-- CRIAR INDEX E TRIGGER QUE EXISTEM NA TABELA ORIGINAL
CREATE NONCLUSTERED INDEX [IX_Venda_Query_OrderId] ON [dbo].[Venda_Query]
(
	[OrderId] ASC
)WITH (FILLFACTOR = 100) ON [PRIMARY]
GO
SELECT TOP 10 * FROM Venda_Query_Temp ORDER BY ID DESC

SELECT TOP 10 * FROM Venda_Query ORDER BY ID DESC
SELECT TOP 10 * FROM Venda_Query_Old ORDER BY ID DESC


commit
rollback