begin tran

use Ploomes_CRM
go

-- CRIAR UMA TABELA TEMPORÁRIA
CREATE TABLE [dbo].[Document_Query_Temp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DocumentId] [int] NOT NULL,
	[RootODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[SelfODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[SectionsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[ProductsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[PartsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Document_Query_Temp] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY]
GO

-- SETAR IDENTITY PARA INSERIR OS NOVOS IDS
SET IDENTITY_INSERT [dbo].[Document_Query_Temp] ON
GO

-- INSERIR NOVOS IDS NA TABELA TEMP
INSERT INTO Document_Query_Temp (Id, DocumentId, RootODataQuery, SelfODataQuery, SectionsODataQuery, ProductsODataQuery, PartsODataQuery)
SELECT Id + 400000000, DocumentId, RootODataQuery, SelfODataQuery, SectionsODataQuery, ProductsODataQuery, PartsODataQuery
FROM Document_Query

SELECT TOP 10 * FROM Document_Query_Temp ORDER BY ID DESC

Declare @id int
SELECT @id = MAX(ID) + 1 FROM Document_Query_Temp

DBCC CHECKIDENT ('Document_Query_Temp', RESEED, @id)

-- VOLTAR O IDENTITY
SET IDENTITY_INSERT [dbo].[Document_Query_Temp] OFF
GO

-- ATUALIZAR TODO MUNDO PARA APONTAR PARA O NOVO ID
UPDATE Document
SET QueryId = QueryId + 400000000
WHERE QueryId IS NOT NULL

SELECT TOP 10 QueryId, * FROM Document WHERE QueryId IS NOT NULL 


-- RENOMEAR A TABELA ANTIGA PARA OLD E A NOVA PARA SER ORIGINAL
EXEC sp_rename 'dbo.Document_Query', 'Document_Query_Old'
EXEC sp_rename 'dbo.Document_Query_Temp', 'Document_Query'

-- RENOMEAR AS PKs PARA TEREM O NOME CORRETO
EXEC sp_rename 'dbo.PK_Document_Query', 'PK_Document_Query_Old', 'OBJECT'
EXEC sp_rename 'dbo.PK_Document_Query_Temp', 'PK_Document_Query', 'OBJECT'

EXEC sp_rename 'Document_Query_Old.IX_Document_Query_DocumentId', 'IX_Document_Query_DocumentId_Old', 'INDEX';


-- CRIAR INDEX E TRIGGER QUE EXISTEM NA TABELA ORIGINAL
CREATE NONCLUSTERED INDEX [IX_Document_Query_DocumentId] ON [dbo].[Document_Query]
(
	[DocumentId] ASC
)WITH (FILLFACTOR = 100) ON [PRIMARY]
GO

SELECT TOP 10 * FROM Document_Query ORDER BY ID DESC
SELECT TOP 10 * FROM Document_Query_Old ORDER BY ID DESC

commit
rollback