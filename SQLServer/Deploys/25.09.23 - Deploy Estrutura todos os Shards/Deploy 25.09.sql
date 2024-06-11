USE Ploomes_CRM
GO

ALTER TABLE Cotacao_Modelo
ADD [QueryId] [int] NULL

ALTER TABLE Cotacao_Revisao
ADD [QueryId] [int] NULL

ALTER TABLE Document
ADD [QueryId] [int] NULL

ALTER TABLE Venda
ADD [QueryId] [int] NULL

ALTER TABLE Ploomes_Cliente
ADD [ShouldUseNewHtmlGenerator] [bit] NULL


CREATE TABLE [dbo].[Cotacao_Modelo_Query](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TemplateId] [int] NOT NULL,
	[RootODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[SelfODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[SectionsODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[ProductsODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[PartsODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Cotacao_Modelo_Query] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Cotacao_Modelo_Query_TemplateId] ON [dbo].[Cotacao_Modelo_Query]
(
	[TemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Cotacao_Revisao_Query](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[QuoteId] [int] NOT NULL,
	[RootODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[SelfODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[SectionsODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[ProductsODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[PartsODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Cotacao_Revisao_Query] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Cotacao_Revisao_Query_QuoteId] ON [dbo].[Cotacao_Revisao_Query]
(
	[QuoteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Document_Query](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DocumentId] [int] NOT NULL,
	[RootODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[SelfODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[SectionsODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[ProductsODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[PartsODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Document_Query] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Document_Query_DocumentId] ON [dbo].[Document_Query]
(
	[DocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Venda_Query](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[RootODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[SelfODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[SectionsODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[ProductsODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
	[PartsODataQuery] [nvarchar](3000) COLLATE Latin1_General_CI_AI NULL,
 CONSTRAINT [PK_Venda_Query] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Venda_Query_OrderId] ON [dbo].[Venda_Query]
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO


CREATE VIEW [dbo].[SVw_Cotacao_Modelo_Query] AS
	SELECT CMQ.*,U.ID as ViewUserId
		FROM Cotacao_Modelo_Query CMQ CROSS JOIN Usuario U
GO

CREATE VIEW [dbo].[SVw_Cotacao_Revisao_Query] AS
	SELECT CRQ.*, U.ID as ViewUserId
		FROM Cotacao_Revisao_Query CRQ CROSS JOIN Usuario U
GO

CREATE VIEW [dbo].[SVw_Document_Query] AS
	SELECT DQ.*, U.ID as ViewUserId
		FROM Document_Query DQ CROSS JOIN Usuario U
GO

CREATE VIEW [dbo].[SVw_Venda_Query] AS
	SELECT VQ.*, U.ID as ViewUserId
		FROM Venda_Query VQ CROSS JOIN Usuario U
GO