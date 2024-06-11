
begin tran

use Ploomes_CRM
go

-- CRIAR UMA TABELA TEMPORÁRIA
CREATE TABLE [dbo].[Cotacao_Modelo_Query_Temp](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TemplateId] [int] NOT NULL,
	[RootODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[SelfODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[SectionsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[ProductsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
	[PartsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Cotacao_Modelo_Query_Temp] PRIMARY KEY CLUSTERED ([Id] ASC) ON [PRIMARY]
) ON [PRIMARY]
GO

-- SETAR IDENTITY PARA INSERIR OS NOVOS IDS
SET IDENTITY_INSERT [dbo].[Cotacao_Modelo_Query_Temp] ON
GO

-- INSERIR NOVOS IDS NA TABELA TEMP
INSERT INTO Cotacao_Modelo_Query_Temp (Id, TemplateId, RootODataQuery, SelfODataQuery, SectionsODataQuery, ProductsODataQuery, PartsODataQuery)
SELECT Id + 80000000, TemplateId, RootODataQuery, SelfODataQuery, SectionsODataQuery, ProductsODataQuery, PartsODataQuery
FROM Cotacao_Modelo_Query

Declare @id int
SELECT @id = MAX(ID) + 1 FROM Cotacao_Modelo_Query_Temp

DBCC CHECKIDENT ('Cotacao_Modelo_Query_Temp', RESEED, @id)

-- VOLTAR O IDENTITY
SET IDENTITY_INSERT [dbo].[Cotacao_Modelo_Query_Temp] OFF
GO

-- ATUALIZAR TODO MUNDO PARA APONTAR PARA O NOVO ID
UPDATE Cotacao_Modelo
SET QueryId = QueryId + 80000000
WHERE QueryId IS NOT NULL


Select * from Cotacao_Modelo_Query_Temp order by Id desc
Select * from Cotacao_Modelo_Query order by Id desc -- 8477
Select * from Cotacao_Modelo_Query_Old order by Id desc -- 8477



-- RENOMEAR A TABELA ANTIGA PARA OLD E A NOVA PARA SER ORIGINAL
EXEC sp_rename 'dbo.Cotacao_Modelo_Query', 'Cotacao_Modelo_Query_Old'
EXEC sp_rename 'dbo.Cotacao_Modelo_Query_Temp', 'Cotacao_Modelo_Query'

-- RENOMEAR AS PKs PARA TEREM O NOME CORRETO
EXEC sp_rename 'dbo.PK_Cotacao_Modelo_Query', 'PK_Cotacao_Modelo_Query_Old', 'OBJECT'
EXEC sp_rename 'dbo.PK_Cotacao_Modelo_Query_Temp', 'PK_Cotacao_Modelo_Query', 'OBJECT'

EXEC sp_rename 'Cotacao_Modelo_Query_Old.IX_Cotacao_Modelo_Query_TemplateId', 'IX_Cotacao_Modelo_Query_TemplateId_Old', 'INDEX';


-- CRIAR INDEX E TRIGGER QUE EXISTEM NA TABELA ORIGINAL
CREATE NONCLUSTERED INDEX [IX_Cotacao_Modelo_Query_TemplateId] ON [dbo].[Cotacao_Modelo_Query]
(
	[TemplateId] ASC
)WITH (FILLFACTOR = 100) ON [PRIMARY]
GO


commit 
rollback