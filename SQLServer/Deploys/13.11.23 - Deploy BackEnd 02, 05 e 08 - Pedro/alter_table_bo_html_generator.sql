USE Ploomes_crm;
GO
-- Todos menos 08 e 07

ALTER TABLE [dbo].[Cotacao_Modelo_Query]
ALTER COLUMN [RootODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL
GO

ALTER TABLE [dbo].[Cotacao_Modelo_Query]
ALTER COLUMN [SelfODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL
GO

ALTER TABLE [dbo].[Cotacao_Modelo_Query]
ALTER COLUMN [SectionsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL
GO

ALTER TABLE [dbo].[Cotacao_Modelo_Query]
ALTER COLUMN [ProductsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL
GO

ALTER TABLE [dbo].[Cotacao_Modelo_Query]
ALTER COLUMN [PartsODataQuery] [nvarchar](4000) COLLATE Latin1_General_CI_AI NULL
GO