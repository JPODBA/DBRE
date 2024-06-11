USE [Integrations]
GO
/****** Object:  User [ LogApiReadOnly]    Script Date: 24/05/2024 16:09:59 ******/
CREATE USER [ LogApiReadOnly] FOR LOGIN [ LogApiReadOnly] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [jackson.matsuura]    Script Date: 24/05/2024 16:09:59 ******/
CREATE USER [jackson.matsuura] FOR LOGIN [jackson.matsuura] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [QueryApiReadOnly]    Script Date: 24/05/2024 16:09:59 ******/
CREATE USER [QueryApiReadOnly] FOR LOGIN [QueryApiReadOnly] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [tiago.rodrigues]    Script Date: 24/05/2024 16:09:59 ******/
CREATE USER [tiago.rodrigues] FOR LOGIN [tiago.rodrigues] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ LogApiReadOnly]
GO
ALTER ROLE [db_owner] ADD MEMBER [jackson.matsuura]
GO
ALTER ROLE [db_datareader] ADD MEMBER [jackson.matsuura]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [jackson.matsuura]
GO
ALTER ROLE [db_datareader] ADD MEMBER [QueryApiReadOnly]
GO
ALTER ROLE [db_datareader] ADD MEMBER [tiago.rodrigues]
GO
/****** Object:  Table [dbo].[Integration_MappingV2]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Integration_MappingV2](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IntegrationId] [int] NOT NULL,
	[RuleId] [int] NOT NULL,
	[Ordination] [int] NOT NULL,
	[SankhyaFieldKey] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FieldKey] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MapType] [int] NULL,
	[PhoneTypeId] [int] NULL,
	[BlockFieldEdition] [bit] NOT NULL,
	[SuggestedMappingId] [int] NULL,
	[GoesToPloomes] [bit] NOT NULL,
	[GoesToSankhya] [bit] NOT NULL,
	[SelectedDirection] [int] NULL,
	[OptionTableId] [int] NULL,
 CONSTRAINT [PK_Integration_MappingV2_ID] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Integration_MappingV2] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Rule]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rule](
	[Id] [int] NOT NULL,
	[Label] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EntityId] [int] NOT NULL,
	[SankhyaEntityId] [int] NOT NULL,
	[CanGoToPloomes] [bit] NOT NULL,
	[CanGoToSankhya] [bit] NOT NULL,
	[StepId] [int] NULL,
	[Ordination] [int] NULL,
	[PloomesEntityName] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SankhyaEntityName] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HasDynamicMappedFields] [bit] NULL,
	[ParentRuleId] [int] NULL,
	[CanCreate] [bit] NULL,
	[CanEdit] [bit] NULL,
	[CanCancel] [bit] NULL,
	[IsFake] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Rule] TO  SCHEMA OWNER 
GO
/****** Object:  View [dbo].[Mapping_View]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Mapping_View] AS
SELECT I.[Id], I.[RuleId], R.[EntityId], R.[SankhyaEntityId], I.[SankhyaFieldKey], I.[FieldKey], I.[MapType], I.[IntegrationId], I.[OptionTableId]
FROM [Integrations].[dbo].[Integration_MappingV2] as I INNER JOIN 
[Integrations].[dbo].[Rule] as R ON I.[RuleId] = R.[Id]
GO
ALTER AUTHORIZATION ON [dbo].[Mapping_View] TO  SCHEMA OWNER 
GO
/****** Object:  View [dbo].[Import_Fields_View]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Import_Fields_View] AS
SELECT [IntegrationId], [RuleId], STRING_AGG([SankhyaFieldKey], ',') as Fields FROM (
  select distinct [SankhyaFieldKey], [RuleId], [IntegrationId] from [Integrations].[dbo].[Integration_MappingV2]
  WHERE [GoesToPloomes] = 1 and [SankhyaFieldKey] not in (
    'DTALTER','DHALTER' --will be reinserted in all rules
   ,'GruposBusca' -- GrupoProduto Fake Field
   ,'TipoPloomes' -- Parceiro Cliente PF and Contato Fake Field
   ,'DevFinanceiro','DevRestricoes' -- CabecalhoNota Fake Fields
   ,'DevEstoque','DevUnidade','DevControle','DevProdIntegrado','ProdIntegrado' --ItemNova Fake Fields
   ,'DevValorUnitario','ValorUnitario','TotalProduto','DevImpostos','IcmsAliq' --ItemNova Fake Fields
   ,'IcmsValor','IpiAliq','IpiValor' --ItemNova Fake Fields
   ) 
  ) T 
  group by [RuleId],[IntegrationId]
GO
ALTER AUTHORIZATION ON [dbo].[Import_Fields_View] TO  SCHEMA OWNER 
GO
/****** Object:  View [dbo].[Import_Mapping_View]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Import_Mapping_View] AS
SELECT M.[Id],M.[IntegrationId],M.[RuleId],M.[SankhyaFieldKey],M.[FieldKey],M.[PhoneTypeId], M.[OptionTableId], F.[TypeId],F.[Multiple] FROM
[Integrations].[dbo].[Integration_MappingV2] as M INNER JOIN 
[Integrations].[dbo].[Rule] as R ON 
	R.[Id] = M.[RuleId] INNER JOIN 
[Temp].[dbo].[Sankhya_field] as F ON 
	F.[IntegrationId] = M.[IntegrationId] AND 
	F.[SankhyaEntityId] = R.[SankhyaEntityId] AND  
	F.[Key] = M.[SankhyaFieldKey]
WHERE (M.[GoesToPloomes] = 1 OR ([RuleId] = 5 AND [SankhyaFieldKey] = 'GruposBusca') OR ([RuleId] IN (2, 6) AND [SankhyaFieldKey] = 'TipoPloomes'))
GO
ALTER AUTHORIZATION ON [dbo].[Import_Mapping_View] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContextKey] [nvarchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[__MigrationHistory] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Configuration]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Configuration](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Key] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StringValue] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IntegerValue] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Configuration] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Integration]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Integration](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[WebhookValidationKey] [char](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Active] [bit] NOT NULL,
	[IntegrationUserKey] [char](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BearerToken] [varchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [int] NOT NULL,
	[NextSearchDate] [datetime] NOT NULL,
	[SearchTimeWindowStart] [datetime] NULL,
	[SearchTimeWindowEnd] [datetime] NULL,
	[LastImportedId] [int] NULL,
	[AppToken] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastSubItemId] [int] NULL,
	[ReplacedIn] [datetime] NULL,
	[Halted] [bit] NOT NULL,
	[LastSuccessRefresh] [datetime] NULL,
	[LastUpdate] [datetime] NULL,
	[CompanyName] [varchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TimeZoneOffSet] [int] NOT NULL,
	[InitialSyncLoading] [bit] NULL,
	[HaltMessage] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastFieldsMetadataUpdateDate] [datetime] NULL,
	[LastErrorMessage] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserId] [int] NULL,
	[StartLookupId] [int] NULL,
	[RetryCount] [int] NULL,
	[IsSql] [bit] NOT NULL,
	[CanConvert] [bit] NOT NULL,
	[HasDhalter] [bit] NOT NULL,
	[Version] [int] NULL,
	[TaxCapability] [int] NULL,
	[EnabledOn] [datetime] NULL,
	[ActivatedOn] [datetime] NULL,
	[ActiveSince] [datetime] NULL,
	[BaseIntegration] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Integration] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Integration_Field]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Integration_Field](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IntegrationId] [int] NOT NULL,
	[TemplateFieldId] [int] NOT NULL,
	[FieldKey] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Integration_Field] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Integration_Field_Mapping]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Integration_Field_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IntegrationId] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[Ordination] [int] NOT NULL,
	[FieldKey] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SankhyaFieldKey] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Integration_Field_Mapping] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Integration_RuleV2]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Integration_RuleV2](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IntegrationId] [int] NULL,
	[RuleId] [int] NULL,
	[GoesToPloomes] [bit] NULL,
	[GoesToSankhya] [bit] NULL,
	[Saved] [bit] NULL,
	[TriggerOptionIdOnImportInsert] [int] NULL,
	[TriggerOptionIdOnImportUpdate] [int] NULL,
	[TriggerOptionIdOnExportInsert] [int] NULL,
	[TriggerOptionIdOnExportUpdate] [int] NULL,
	[PloomesToSankhya] [bit] NULL,
	[PloomesCreationFilterId] [int] NULL,
	[SankhyaCreationFilterSQL] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DocumentLinkEnabled] [bit] NULL,
	[DocumentLinkPipelineId] [int] NULL,
	[DocumentLinkStageId] [int] NULL,
 CONSTRAINT [PK_Integration_RuleV2_ID] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Integration_RuleV2] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Lookup]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lookup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SankhyaItemId] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[PloomesItemId] [int] NOT NULL,
	[SankhyaItemFk] [int] NULL,
	[IntegrationId] [int] NOT NULL,
	[RuleId] [int] NULL,
	[PairedBy] [int] NULL,
	[AccountId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Lookup] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[RunControl]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RunControl](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ControlId] [int] NOT NULL,
	[DateTimeValue] [datetime] NULL,
	[IntValue] [int] NULL,
	[StringValue] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[RunControl] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Sankhya_Tipo_Operacao]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sankhya_Tipo_Operacao](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IntegrationId] [int] NOT NULL,
	[CODTIPOPER] [int] NOT NULL,
	[DESCROPER] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TIPMOV] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DHALTER] [datetime] NOT NULL,
	[RuleId] [int] NULL,
	[TemplateId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Sankhya_Tipo_Operacao] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Step]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Step](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ordination] [int] NULL,
 CONSTRAINT [PK_STEP_ID] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Step] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Suggested_MappingV2]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Suggested_MappingV2](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RuleId] [int] NOT NULL,
	[Ordination] [int] NOT NULL,
	[SankhyaFieldKey] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsKeyField] [bit] NULL,
	[FieldKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Label] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AllowedDirections] [int] NOT NULL,
	[InfoMessageRight] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InfoMessageLeft] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SelectedDirection] [int] NULL,
 CONSTRAINT [PK_Suggested_MappingV2_ID] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Suggested_MappingV2] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[TRIGGER]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRIGGER](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RuleId] [int] NULL,
	[PloomesToSankhya] [bit] NULL,
	[Ordination] [int] NULL,
	[TriggerType] [int] NULL,
	[SuggestedFilter] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_TRIGGER_ID] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[TRIGGER] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[TRIGGER_OPTION]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRIGGER_OPTION](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TriggerId] [int] NULL,
	[Description] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ordination] [int] NULL,
	[Filterable] [bit] NULL,
 CONSTRAINT [PK_TRIGGEROPTION_ID] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[TRIGGER_OPTION] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[vw_QueueForAdmin]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vw_QueueForAdmin](
	[Id] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[Body] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastTryError] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RequestJson] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResponseJson] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_dbo.vw_QueueForAdmin] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[vw_QueueForAdmin] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[vw_QueueForNotAdmin]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vw_QueueForNotAdmin](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IntegrationId] [int] NOT NULL,
	[PloomesToSankhya] [bit] NULL,
	[ItemId] [int] NULL,
	[StatusId] [int] NULL,
	[ActionId] [int] NULL,
	[EntityUpdateDate] [datetime] NULL,
	[UserId] [int] NULL,
	[FriendlyErrorMessage] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NextRetryDate] [datetime] NULL,
	[RetryCount] [int] NULL,
	[SankhyaEntityName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PloomesEntityName] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_dbo.vw_QueueForNotAdmin] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[vw_QueueForNotAdmin] TO  SCHEMA OWNER 
GO
/****** Object:  Index [Integration_IDM]    Script Date: 24/05/2024 16:09:59 ******/
CREATE NONCLUSTERED INDEX [Integration_IDM] ON [dbo].[Integration]
(
	[NextSearchDate] ASC,
	[LastUpdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Integration_IDM02]    Script Date: 24/05/2024 16:09:59 ******/
CREATE NONCLUSTERED INDEX [IX_Integration_IDM02] ON [dbo].[Integration]
(
	[AccountId] ASC,
	[ReplacedIn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Integration_IDM03]    Script Date: 24/05/2024 16:09:59 ******/
CREATE NONCLUSTERED INDEX [IX_Integration_IDM03] ON [dbo].[Integration]
(
	[ReplacedIn] ASC,
	[Halted] ASC,
	[Status] ASC,
	[NextSearchDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Integration_MappingV2_IDM]    Script Date: 24/05/2024 16:09:59 ******/
CREATE NONCLUSTERED INDEX [Integration_MappingV2_IDM] ON [dbo].[Integration_MappingV2]
(
	[IntegrationId] ASC,
	[GoesToPloomes] ASC,
	[SankhyaFieldKey] ASC
)
INCLUDE([RuleId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Lookup_ID01]    Script Date: 24/05/2024 16:09:59 ******/
CREATE NONCLUSTERED INDEX [IX_Lookup_ID01] ON [dbo].[Lookup]
(
	[IntegrationId] ASC,
	[EntityId] ASC,
	[SankhyaItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Lookup_ID02]    Script Date: 24/05/2024 16:09:59 ******/
CREATE NONCLUSTERED INDEX [IX_Lookup_ID02] ON [dbo].[Lookup]
(
	[PloomesItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Lookup_IDM]    Script Date: 24/05/2024 16:09:59 ******/
CREATE NONCLUSTERED INDEX [IX_Lookup_IDM] ON [dbo].[Lookup]
(
	[SankhyaItemId] ASC,
	[EntityId] ASC,
	[SankhyaItemFk] ASC,
	[IntegrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Lookup_IDM01]    Script Date: 24/05/2024 16:09:59 ******/
CREATE NONCLUSTERED INDEX [IX_Lookup_IDM01] ON [dbo].[Lookup]
(
	[SankhyaItemId] ASC,
	[SankhyaItemFk] ASC,
	[RuleId] ASC,
	[AccountId] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Lookup_IDM02]    Script Date: 24/05/2024 16:09:59 ******/
CREATE NONCLUSTERED INDEX [IX_Lookup_IDM02] ON [dbo].[Lookup]
(
	[Id] ASC,
	[AccountId] ASC,
	[RuleId] ASC,
	[SankhyaItemId] ASC,
	[SankhyaItemFk] ASC
)
INCLUDE([PloomesItemId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Sankhya_Tipo_Operacao_IDM]    Script Date: 24/05/2024 16:09:59 ******/
CREATE NONCLUSTERED INDEX [Sankhya_Tipo_Operacao_IDM] ON [dbo].[Sankhya_Tipo_Operacao]
(
	[IntegrationId] ASC,
	[RuleId] ASC
)
INCLUDE([CODTIPOPER]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Id]    Script Date: 24/05/2024 16:09:59 ******/
CREATE NONCLUSTERED INDEX [IX_Id] ON [dbo].[vw_QueueForAdmin]
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Integration] ADD  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[Integration] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Integration] ADD  DEFAULT (getdate()) FOR [NextSearchDate]
GO
ALTER TABLE [dbo].[Integration] ADD  DEFAULT ((0)) FOR [Halted]
GO
ALTER TABLE [dbo].[Integration] ADD  DEFAULT ((-3)) FOR [TimeZoneOffSet]
GO
ALTER TABLE [dbo].[Integration] ADD  CONSTRAINT [DEFAULT_INTEGRATION_ISSQL]  DEFAULT ((0)) FOR [IsSql]
GO
ALTER TABLE [dbo].[Integration] ADD  CONSTRAINT [DEFAULT_INTEGRATION_CANCONVERT]  DEFAULT ((0)) FOR [CanConvert]
GO
ALTER TABLE [dbo].[Integration] ADD  CONSTRAINT [DEFAULT_INTEGRATION_HASDHALTER]  DEFAULT ((0)) FOR [HasDhalter]
GO
ALTER TABLE [dbo].[Integration_MappingV2] ADD  CONSTRAINT [DEFAULT_Integration_MappingV2_BLOCKFIELDEDITION]  DEFAULT ((0)) FOR [BlockFieldEdition]
GO
ALTER TABLE [dbo].[Rule] ADD  DEFAULT ((0)) FOR [CanGoToPloomes]
GO
ALTER TABLE [dbo].[Rule] ADD  DEFAULT ((0)) FOR [CanGoToSankhya]
GO
ALTER TABLE [dbo].[Integration_Field_Mapping]  WITH CHECK ADD FOREIGN KEY([IntegrationId])
REFERENCES [dbo].[Integration] ([Id])
GO
ALTER TABLE [dbo].[vw_QueueForAdmin]  WITH CHECK ADD  CONSTRAINT [FK_dbo.vw_QueueForAdmin_dbo.vw_QueueForNotAdmin_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[vw_QueueForNotAdmin] ([Id])
GO
ALTER TABLE [dbo].[vw_QueueForAdmin] CHECK CONSTRAINT [FK_dbo.vw_QueueForAdmin_dbo.vw_QueueForNotAdmin_Id]
GO
/****** Object:  StoredProcedure [dbo].[ActivateDraft]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActivateDraft]
  @accountId INT,
  @draftId INT,
  @newStatus INT,
  @utcNow DATETIME,
  @affectedRows INT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN
    BEGIN TRY

	  --Get the Active IntegrationId from the Integration Table
	  DECLARE @oldIntegrationId INT
      SET @oldIntegrationId = (SELECT TOP 1 [Id] FROM [Integrations].[dbo].[Integration] WHERE [AccountId] = @accountId AND [ReplacedIn] is null AND [Status] >= 800 order by [Id] desc)
      IF (@oldIntegrationId IS NULL)
        BEGIN
          SET @affectedRows = -1;
  		  ROLLBACK TRANSACTION
	  	  RETURN @affectedRows
        END

	  -- Activate the Draft
	  UPDATE D SET D.[Active] = 1, D.[LastImportedId] = -999, D.[LastSubItemId] = -999,
	    D.[AccountId] = @accountId, D.[Status] = @newStatus, D.[NextSearchDate] = @utcNow, D.[LastUpdate] = @utcNow,
	    D.[SearchTimeWindowStart] = S.[SearchTimeWindowEnd], D.[SearchTimeWindowEnd] = S.[SearchTimeWindowEnd], D.[LastSuccessRefresh] = S.[LastSuccessRefresh]
  		FROM [Integrations].[dbo].[Integration] AS D INNER JOIN [Integrations].[dbo].[Integration] AS S
		ON S.[Id] = @oldIntegrationId AND D.[Id] = @draftId AND D.[AccountId] = -S.[AccountId] AND D.[ReplacedIn] IS NULL AND D.[Status] < @newStatus
	  SET @affectedRows = @@ROWCOUNT

	  IF @affectedRows > 0
		BEGIN -- Deactivate the Active 
	  	  UPDATE [Integrations].[dbo].[Integration] SET [ReplacedIn] = @utcNow WHERE [Id] = @oldIntegrationId AND [AccountId] = @accountId AND [ReplacedIn] IS NULL
	  	  COMMIT TRANSACTION
		END
	  ELSE
		BEGIN 
	  	  ROLLBACK TRANSACTION
		END

	  RETURN @affectedRows
    END TRY
    BEGIN CATCH   
      ROLLBACK TRANSACTION
	  THROW
    END CATCH
END;
GO
ALTER AUTHORIZATION ON [dbo].[ActivateDraft] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[AddNewIntegration]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddNewIntegration]
  @accountId INT,
  @webhookValidationKey VARCHAR(32),
  @integrationUserKey VARCHAR(128),
  @appToken VARCHAR(200),
  @status INT,
  @nextSearchDate DATETIME,
  @userId INT,
  @isSQL BIT,
  @canConvert BIT,
  @hasDhalter BIT,
  @newIntegrationId INT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN
    BEGIN TRY
	  --Get the last Id from the LookUpTable
	  DECLARE @lookupId int
      SET @lookupId = (SELECT MAX([Id]) FROM [Integrations].[dbo].[Lookup])      
      IF (@lookupId IS NULL)
        BEGIN
          SET @lookupId = 0;
        END     

      --Create the Integration Configuration
	  INSERT INTO [Integration]	
	    ([AccountId],[WebhookValidationKey],[Active],[IntegrationUserKey],[AppToken],[Status],[NextSearchDate],[UserId],[StartLookupId],[IsSql],[CanConvert],[HasDhalter])
		VALUES
		(@accountId, @webhookValidationKey, 0, @integrationUserKey, @appToken, @status, @nextSearchDate, @userId, @lookupId, @isSQL, @canConvert, @hasDhalter)
	  SET @newIntegrationId = SCOPE_IDENTITY()
      
	  --Create the Rules
      INSERT INTO [Integration_RuleV2]
        ([IntegrationId],[RuleId],[GoesToPloomes],[GoesToSankhya])
		VALUES
		(@newIntegrationId, 1, 1, 1)
		,(@newIntegrationId, 2, 1, 1)
		,(@newIntegrationId, 3, 1, 0)
		,(@newIntegrationId, 4, 1, 0)
		,(@newIntegrationId, 5, 1, 0)
		,(@newIntegrationId, 6, 1, 1)
		,(@newIntegrationId, 7, 1, 1)
		,(@newIntegrationId, 8, 1, 1)
		,(@newIntegrationId, 9, 1, 0) -- "Sub-rule" of 8
		,(@newIntegrationId, 10, 1, 1) -- SubRule of 7
		,(@newIntegrationId, 11, 1, 1) -- SubRule of 8
		--,(@newIntegrationId, 12, 1, 0) -- SubRule of 9 -- Will not be used
		--,(@newIntegrationId, 13, 1, 0) -- Not avaivable yet (reserved for Financeiro), will be used?
		,(@newIntegrationId, 14, 1, 1) -- Fake Rule for Total Bloco
		,(@newIntegrationId, 15, 1, 1) -- Fake Rule for Total Bloco
      --TODO: Create the Mappings
      INSERT INTO [Integration_MappingV2]
        ([IntegrationId],[RuleId],[Ordination],[MapType],[SelectedDirection],[SuggestedMappingId],[SankhyaFieldKey],[FieldKey],[PhoneTypeId],[GoesToSankhya],[GoesToPloomes],[BlockFieldEdition])
        VALUES
        (@newIntegrationId, 1, 1, 4, 1, 137, 'CODPARC', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 1, 2, 3, 3, 138, 'NOMEPARC', 'contact_name', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 3, 4, 3, 139, 'ATIVO', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 1, 4, 3, 3, 140, 'TIPPESSOA', 'contact_type', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 5, 3, 3, 143, 'CGC_CPF', 'contact_cnpj', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 6, 4, 3, 144, 'CLASSIFICMS', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 1, 7, 3, 3, 145, 'RAZAOSOCIAL', 'contact_legal_name', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 8, 3, 3, 151, 'CODEND', 'contact_street_address', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 9, 3, 3, 146, 'NUMEND', 'contact_street_address_number', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 10, 3, 3, 147, 'COMPLEMENTO', 'contact_street_address_line2', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 11, 3, 3, 152, 'CODBAI', 'contact_neighborhood', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 12, 3, 3, 142, 'CODCID', 'contact_city', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 13, 3, 3, 148, 'CEP', 'contact_zipcode', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 14, 11, 3, 149, 'TELEFONE', 'contact_phones', 1, 1, 1, 0),
        (@newIntegrationId, 1, 15, 11, 3, 184, 'FAX', 'contact_phones', 2, 1, 1, 0),
        (@newIntegrationId, 1, 16, 3, 3, 150, 'EMAIL', 'contact_email', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 17, 3, 3, 141, 'CODVEND', 'contact_owner', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 1, 4, 3, 123, 'CODPARC', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 2, 2, 4, 1, 124, 'CODCONTATO', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 2, 3, 3, 3, 126, 'NOMECONTATO', 'contact_name', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 4, 4, 3, 125, 'ATIVO', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 2, 5, 4, 3, 1003, 'TipoPloomes', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 2, 6, 3, 3, 1094, 'CPF', 'contact_cpf', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 7, 3, 3, 127, 'CARGO', 'contact_role', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 8, 3, 3, 135, 'CODEND', 'contact_street_address', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 9, 3, 3, 129, 'NUMEND', 'contact_street_address_number', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 10, 3, 3, 130, 'COMPLEMENTO', 'contact_street_address_line2', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 11, 3, 3, 136, 'CODBAI', 'contact_neighborhood', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 12, 3, 3, 128, 'CODCID', 'contact_city', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 13, 3, 3, 131, 'CEP', 'contact_zipcode', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 14, 11, 3, 187, 'CELULAR', 'contact_phones', 2, 1, 1, 0),
        (@newIntegrationId, 2, 15, 11, 3, 186, 'FAX', 'contact_phones', 4, 1, 1, 0),
        (@newIntegrationId, 2, 16, 11, 3, 132, 'TELEFONE', 'contact_phones', 1, 1, 1, 0),
        (@newIntegrationId, 2, 17, 3, 3, 134, 'EMAIL', 'contact_email', NULL, 1, 1, 0),
        (@newIntegrationId, 3, 1, 4, 1, 216, 'CODPROD', 'product_code', NULL, 0, 1, 0),
        (@newIntegrationId, 3, 2, 3, 1, 157, 'DESCRPROD', 'product_name', NULL, 0, 1, 0),
        (@newIntegrationId, 3, 3, 4, 1, 158, 'ATIVO', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 3, 4, 3, 1, 159, 'CODGRUPOPROD', 'product_group', NULL, 0, 1, 0),
        (@newIntegrationId, 3, 5, 3, 1, 160, 'CODVOL', 'product_measurement_unit', NULL, 0, 1, 0),
        (@newIntegrationId, 3, 6, 4, 1, 161, 'MARCA', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 3, 7, 4, 1, 162, 'REFFORN', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 3, 8, 4, 1, 163, 'USOPROD', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 3, 9, 4, 1, 164, 'ORIGPROD', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 4, 1, 4, 1, 153, 'CODVEND', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 4, 2, 3, 1, 154, 'APELIDO', 'user_name', NULL, 0, 1, 0),
        (@newIntegrationId, 4, 3, 3, 1, 155, 'EMAIL', 'user_email', NULL, 0, 1, 0),
        (@newIntegrationId, 5, 1, 4, 1, 181, 'CODGRUPOPROD', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 5, 2, 3, 1, 183, 'DESCRGRUPOPROD', 'product_group_name', NULL, 0, 1, 0),
        (@newIntegrationId, 5, 3, 4, 1, 182, 'CODGRUPAI', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 5, 4, 4, 1, 188, 'GruposBusca', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 6, 1, 4, 1, 165, 'CODPARC', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 6, 2, 3, 3, 166, 'NOMEPARC', 'contact_name', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 3, 4, 3, 167, 'ATIVO', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 6, 4, 3, 3, 168, 'TIPPESSOA', 'contact_type', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 5, 4, 3, 1002, 'TipoPloomes', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 6, 6, 3, 3, 171, 'CGC_CPF', 'contact_cpf', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 7, 4, 3, 172, 'CLASSIFICMS', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 6, 8, 3, 3, 173, 'RAZAOSOCIAL', 'contact_legal_name', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 9, 3, 3, 179, 'CODEND', 'contact_street_address', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 10, 3, 3, 174, 'NUMEND', 'contact_street_address_number', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 11, 3, 3, 175, 'COMPLEMENTO', 'contact_street_address_line2', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 12, 3, 3, 180, 'CODBAI', 'contact_neighborhood', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 13, 3, 3, 170, 'CODCID', 'contact_city', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 14, 3, 3, 176, 'CEP', 'contact_zipcode', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 15, 11, 3, 177, 'TELEFONE', 'contact_phones', 1, 1, 1, 0),
        (@newIntegrationId, 6, 16, 11, 3, 185, 'FAX', 'contact_phones', 2, 1, 1, 0),
        (@newIntegrationId, 6, 17, 3, 3, 178, 'EMAIL', 'contact_email', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 18, 3, 3, 169, 'CODVEND', 'contact_owner', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 1, 4, 1, 217, 'NUNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 2, 4, 3, 218, 'NUMNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 3, 4, 3, 219, 'SERIENOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 4, 3, 3, 223, 'CODPARC', 'quote_contact', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 5, 3, 3, 226, 'CODVEND', 'quote_owner', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 6, 3, 3, 233, 'CODCONTATO', 'quote_person', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 7, 4, 3, 220, 'CODEMP', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 8, 4, 3, 224, 'CODTIPOPER', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 9, 4, 3, 225, 'CODTIPVENDA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 10, 4, 3, 221, 'CODCENCUS', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 11, 4, 3, 227, 'CODNAT', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 12, 4, 1, 228, 'STATUSNOTA', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 7, 13, 3, 3, 222, 'DTNEG', 'quote_date', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 14, 4, 3, 229, 'DTFATUR', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 15, 4, 3, 230, 'DTPREVENT', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 16, 4, 3, 1066, 'VLRNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 17, 3, 3, 231, 'PERCDESC', 'quote_discount', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 18, 4, 3, 232, 'CODMOEDA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 19, 4, 3, 234, 'CODPARCTRANSP', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 20, 4, 1, 1004, 'DevFinanceiro', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 7, 21, 4, 1, 1005, 'DevRestricoes', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 8, 1, 4, 1, 189, 'NUNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 2, 4, 3, 190, 'NUMNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 3, 4, 3, 191, 'SERIENOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 4, 3, 3, 195, 'CODPARC', 'order_contact', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 5, 3, 3, 198, 'CODVEND', 'order_owner', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 6, 3, 3, 205, 'CODCONTATO', 'order_person', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 7, 4, 3, 192, 'CODEMP', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 8, 4, 3, 196, 'CODTIPOPER', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 9, 4, 3, 197, 'CODTIPVENDA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 10, 4, 3, 193, 'CODCENCUS', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 11, 4, 3, 199, 'CODNAT', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 12, 4, 1, 200, 'STATUSNOTA', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 8, 13, 3, 3, 194, 'DTNEG', 'order_date', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 14, 4, 3, 201, 'DTFATUR', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 15, 4, 3, 202, 'DTPREVENT', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 16, 4, 3, 1067, 'VLRNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 17, 3, 3, 203, 'PERCDESC', 'order_discount', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 18, 4, 3, 204, 'CODMOEDA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 19, 4, 3, 206, 'CODPARCTRANSP', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 20, 4, 1, 1006, 'DevFinanceiro', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 8, 21, 4, 1, 1007, 'DevRestricoes', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 1, 4, 1, 235, 'SEQUENCIA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 10, 2, 3, 3, 236, 'CODPROD', 'quote_product_product', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 3, 4, 1, 1068, 'DevUnidade', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 4, 4, 3, 237, 'CODVOL', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 10, 5, 3, 3, 238, 'QTDNEG', 'quote_product_quantity', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 6, 4, 3, 239, 'CODLOCALORIG', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 10, 7, 4, 1, 1069, 'DevControle', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 8, 4, 3, 240, 'CONTROLE', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 10, 9, 4, 1, 1008, 'DevEstoque', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 10, 4, 1, 1070, 'DevValorUnitario', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 11, 4, 1, 1071, 'ValorUnitario', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 12, 3, 3, 241, 'VLRUNIT', 'quote_product_unit_price', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 13, 3, 3, 242, 'PERCDESC', 'quote_product_discount', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 14, 3, 3, 243, 'VLRTOT', 'quote_product_total', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 15, 4, 1, 1072, 'DevImpostos', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 16, 4, 1, 1073, 'IcmsAliq', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 17, 4, 1, 1074, 'IcmsValor', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 18, 4, 1, 1075, 'IpiAliq', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 19, 4, 1, 1076, 'IpiValor', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 20, 4, 1, 1077, 'DevProdIntegrado', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 21, 4, 1, 1078, 'ProdIntegrado', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 22, 4, 1, 1079, 'TotalProduto', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 1, 4, 1, 207, 'SEQUENCIA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 11, 2, 3, 3, 208, 'CODPROD', 'order_product_product', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 3, 4, 1, 1081, 'DevUnidade', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 4, 4, 3, 209, 'CODVOL', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 11, 5, 3, 3, 210, 'QTDNEG', 'order_product_quantity', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 6, 4, 3, 211, 'CODLOCALORIG', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 11, 7, 4, 1, 1082, 'DevControle', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 8, 4, 3, 212, 'CONTROLE', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 11, 9, 4, 1, 1009, 'DevEstoque', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 10, 4, 1, 1083, 'DevValorUnitario', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 11, 4, 1, 1084, 'ValorUnitario', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 12, 3, 3, 213, 'VLRUNIT', 'order_product_unit_price', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 13, 3, 3, 214, 'PERCDESC', 'order_product_discount', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 14, 3, 3, 215, 'VLRTOT', 'order_product_total', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 15, 4, 1, 1085, 'DevImpostos', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 16, 4, 1, 1086, 'IcmsAliq', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 17, 4, 1, 1087, 'IcmsValor', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 18, 4, 1, 1088, 'IpiAliq', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 19, 4, 1, 1089, 'IpiValor', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 20, 4, 1, 1090, 'DevProdIntegrado', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 21, 4, 1, 1091, 'ProdIntegrado', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 22, 4, 1, 1092, 'TotalProduto', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 14, 1, 4, 1, 1095, 'TotalBloco', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 15, 1, 4, 1, 1096, 'TotalBloco', NULL, NULL, 0, 0, 0)
      COMMIT TRANSACTION
	  RETURN @newIntegrationId
    END TRY
    BEGIN CATCH   
      ROLLBACK TRANSACTION
	  THROW
    END CATCH
END;
GO
ALTER AUTHORIZATION ON [dbo].[AddNewIntegration] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[CreateConfig_2]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreateConfig_2]
  @accountId INT,
  @webhookValidationKey VARCHAR(32),
  @integrationUserKey VARCHAR(128),
  @appToken VARCHAR(200),
  @status INT,
  @nextSearchDate DATETIME,
  @userId INT,
  @isSQL BIT,
  @canConvert BIT,
  @hasDhalter BIT,
  @taxCapability INT,
  @createdOn DATETIME,
  @timeZoneOffSet int,
  @newIntegrationId INT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN
    BEGIN TRY
	  --Get the last Id from the LookUpTable
	  DECLARE @lookupId int
      SET @lookupId = (SELECT MAX([Id]) FROM [Integrations].[dbo].[Lookup])      
      IF (@lookupId IS NULL)
        BEGIN
          SET @lookupId = 0;
        END     

      --Create the Integration Configuration
	  INSERT INTO [Integration]	--[Version] 1, [TaxCapability] @taxCapability, EnabledOn @createdOn
	    ([AccountId],[WebhookValidationKey],[Active],[IntegrationUserKey],[AppToken],[Status],[NextSearchDate],[UserId],[StartLookupId],[IsSql],[CanConvert],[HasDhalter],[Version],[TaxCapability],[EnabledOn],[TimeZoneOffSet])
		VALUES
		(@accountId, @webhookValidationKey, 0, @integrationUserKey, @appToken, @status, @nextSearchDate, @userId, @lookupId, @isSQL, @canConvert, @hasDhalter,1, @taxCapability, @createdOn, @timeZoneOffSet)
	  SET @newIntegrationId = SCOPE_IDENTITY()

	  --Create the Rules
      INSERT INTO [Integration_RuleV2]
        ([IntegrationId],[RuleId],[GoesToPloomes],[GoesToSankhya])
		VALUES
		(@newIntegrationId, 1, 1, 1)
		,(@newIntegrationId, 2, 1, 1)
		,(@newIntegrationId, 3, 1, 0)
		,(@newIntegrationId, 4, 1, 0)
		,(@newIntegrationId, 5, 1, 0)
		,(@newIntegrationId, 6, 1, 1)
		,(@newIntegrationId, 7, 1, 1)
		,(@newIntegrationId, 8, 1, 1)
		,(@newIntegrationId, 9, 1, 0) -- "Sub-rule" of 8
		,(@newIntegrationId, 10, 1, 1) -- SubRule of 7
		,(@newIntegrationId, 11, 1, 1) -- SubRule of 8
		--,(@newIntegrationId, 12, 1, 0) -- SubRule of 9 -- Will not be used
		--,(@newIntegrationId, 13, 1, 0) -- Not avaivable yet (reserved for Financeiro), will be used?
		,(@newIntegrationId, 14, 1, 1) -- Fake Rule for Total Bloco
		,(@newIntegrationId, 15, 1, 1) -- Fake Rule for Total Bloco
      --TODO: Create the Mappings
      INSERT INTO [Integration_MappingV2]
        ([IntegrationId],[RuleId],[Ordination],[MapType],[SelectedDirection],[SuggestedMappingId],[SankhyaFieldKey],[FieldKey],[PhoneTypeId],[GoesToSankhya],[GoesToPloomes],[BlockFieldEdition])
        VALUES
        (@newIntegrationId, 1, 1, 4, 1, 137, 'CODPARC', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 1, 2, 3, 3, 138, 'NOMEPARC', 'contact_name', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 3, 4, 3, 139, 'ATIVO', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 1, 4, 3, 3, 140, 'TIPPESSOA', 'contact_type', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 5, 3, 3, 143, 'CGC_CPF', 'contact_cnpj', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 6, 4, 3, 144, 'CLASSIFICMS', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 1, 7, 3, 3, 145, 'RAZAOSOCIAL', 'contact_legal_name', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 8, 3, 3, 151, 'CODEND', 'contact_street_address', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 9, 3, 3, 146, 'NUMEND', 'contact_street_address_number', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 10, 3, 3, 147, 'COMPLEMENTO', 'contact_street_address_line2', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 11, 3, 3, 152, 'CODBAI', 'contact_neighborhood', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 12, 3, 3, 142, 'CODCID', 'contact_city', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 13, 3, 3, 148, 'CEP', 'contact_zipcode', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 14, 11, 3, 149, 'TELEFONE', 'contact_phones', 1, 1, 1, 0),
        (@newIntegrationId, 1, 15, 11, 3, 184, 'FAX', 'contact_phones', 2, 1, 1, 0),
        (@newIntegrationId, 1, 16, 3, 3, 150, 'EMAIL', 'contact_email', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 17, 3, 3, 141, 'CODVEND', 'contact_owner', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 1, 4, 3, 123, 'CODPARC', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 2, 2, 4, 1, 124, 'CODCONTATO', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 2, 3, 3, 3, 126, 'NOMECONTATO', 'contact_name', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 4, 4, 3, 125, 'ATIVO', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 2, 5, 4, 3, 1003, 'TipoPloomes', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 2, 6, 3, 3, 1094, 'CPF', 'contact_cpf', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 7, 3, 3, 127, 'CARGO', 'contact_role', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 8, 3, 3, 135, 'CODEND', 'contact_street_address', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 9, 3, 3, 129, 'NUMEND', 'contact_street_address_number', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 10, 3, 3, 130, 'COMPLEMENTO', 'contact_street_address_line2', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 11, 3, 3, 136, 'CODBAI', 'contact_neighborhood', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 12, 3, 3, 128, 'CODCID', 'contact_city', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 13, 3, 3, 131, 'CEP', 'contact_zipcode', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 14, 11, 3, 187, 'CELULAR', 'contact_phones', 2, 1, 1, 0),
        (@newIntegrationId, 2, 15, 11, 3, 186, 'FAX', 'contact_phones', 4, 1, 1, 0),
        (@newIntegrationId, 2, 16, 11, 3, 132, 'TELEFONE', 'contact_phones', 1, 1, 1, 0),
        (@newIntegrationId, 2, 17, 3, 3, 134, 'EMAIL', 'contact_email', NULL, 1, 1, 0),
        (@newIntegrationId, 3, 1, 4, 1, 216, 'CODPROD', 'product_code', NULL, 0, 1, 0),
        (@newIntegrationId, 3, 2, 3, 1, 157, 'DESCRPROD', 'product_name', NULL, 0, 1, 0),
        (@newIntegrationId, 3, 3, 4, 1, 158, 'ATIVO', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 3, 4, 3, 1, 159, 'CODGRUPOPROD', 'product_group', NULL, 0, 1, 0),
        (@newIntegrationId, 3, 5, 3, 1, 160, 'CODVOL', 'product_measurement_unit', NULL, 0, 1, 0),
        (@newIntegrationId, 3, 6, 4, 1, 161, 'MARCA', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 3, 7, 4, 1, 162, 'REFFORN', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 3, 8, 4, 1, 163, 'USOPROD', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 3, 9, 4, 1, 164, 'ORIGPROD', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 4, 1, 4, 1, 153, 'CODVEND', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 4, 2, 3, 1, 154, 'APELIDO', 'user_name', NULL, 0, 1, 0),
        (@newIntegrationId, 4, 3, 3, 1, 155, 'EMAIL', 'user_email', NULL, 0, 1, 0),
        (@newIntegrationId, 5, 1, 4, 1, 181, 'CODGRUPOPROD', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 5, 2, 3, 1, 183, 'DESCRGRUPOPROD', 'product_group_name', NULL, 0, 1, 0),
        (@newIntegrationId, 5, 3, 4, 1, 182, 'CODGRUPAI', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 5, 4, 4, 1, 188, 'GruposBusca', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 6, 1, 4, 1, 165, 'CODPARC', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 6, 2, 3, 3, 166, 'NOMEPARC', 'contact_name', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 3, 4, 3, 167, 'ATIVO', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 6, 4, 3, 3, 168, 'TIPPESSOA', 'contact_type', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 5, 4, 3, 1002, 'TipoPloomes', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 6, 6, 3, 3, 171, 'CGC_CPF', 'contact_cpf', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 7, 4, 3, 172, 'CLASSIFICMS', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 6, 8, 3, 3, 173, 'RAZAOSOCIAL', 'contact_legal_name', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 9, 3, 3, 179, 'CODEND', 'contact_street_address', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 10, 3, 3, 174, 'NUMEND', 'contact_street_address_number', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 11, 3, 3, 175, 'COMPLEMENTO', 'contact_street_address_line2', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 12, 3, 3, 180, 'CODBAI', 'contact_neighborhood', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 13, 3, 3, 170, 'CODCID', 'contact_city', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 14, 3, 3, 176, 'CEP', 'contact_zipcode', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 15, 11, 3, 177, 'TELEFONE', 'contact_phones', 1, 1, 1, 0),
        (@newIntegrationId, 6, 16, 11, 3, 185, 'FAX', 'contact_phones', 2, 1, 1, 0),
        (@newIntegrationId, 6, 17, 3, 3, 178, 'EMAIL', 'contact_email', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 18, 3, 3, 169, 'CODVEND', 'contact_owner', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 1, 4, 1, 217, 'NUNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 2, 4, 3, 218, 'NUMNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 3, 4, 3, 219, 'SERIENOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 4, 3, 3, 223, 'CODPARC', 'quote_contact', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 5, 3, 3, 226, 'CODVEND', 'quote_owner', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 6, 3, 3, 233, 'CODCONTATO', 'quote_person', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 7, 4, 3, 220, 'CODEMP', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 8, 4, 3, 224, 'CODTIPOPER', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 9, 4, 3, 225, 'CODTIPVENDA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 10, 4, 3, 221, 'CODCENCUS', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 11, 4, 3, 227, 'CODNAT', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 12, 4, 1, 228, 'STATUSNOTA', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 7, 13, 3, 3, 222, 'DTNEG', 'quote_date', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 14, 4, 3, 229, 'DTFATUR', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 15, 4, 3, 230, 'DTPREVENT', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 16, 4, 3, 1066, 'VLRNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 17, 3, 3, 231, 'PERCDESC', 'quote_discount', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 18, 4, 3, 232, 'CODMOEDA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 19, 4, 3, 234, 'CODPARCTRANSP', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 20, 4, 1, 1004, 'DevFinanceiro', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 7, 21, 4, 1, 1005, 'DevRestricoes', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 8, 1, 4, 1, 189, 'NUNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 2, 4, 3, 190, 'NUMNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 3, 4, 3, 191, 'SERIENOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 4, 3, 3, 195, 'CODPARC', 'order_contact', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 5, 3, 3, 198, 'CODVEND', 'order_owner', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 6, 3, 3, 205, 'CODCONTATO', 'order_person', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 7, 4, 3, 192, 'CODEMP', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 8, 4, 3, 196, 'CODTIPOPER', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 9, 4, 3, 197, 'CODTIPVENDA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 10, 4, 3, 193, 'CODCENCUS', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 11, 4, 3, 199, 'CODNAT', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 12, 4, 1, 200, 'STATUSNOTA', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 8, 13, 3, 3, 194, 'DTNEG', 'order_date', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 14, 4, 3, 201, 'DTFATUR', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 15, 4, 3, 202, 'DTPREVENT', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 16, 4, 3, 1067, 'VLRNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 17, 3, 3, 203, 'PERCDESC', 'order_discount', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 18, 4, 3, 204, 'CODMOEDA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 19, 4, 3, 206, 'CODPARCTRANSP', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 20, 4, 1, 1006, 'DevFinanceiro', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 8, 21, 4, 1, 1007, 'DevRestricoes', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 1, 4, 1, 235, 'SEQUENCIA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 10, 2, 3, 3, 236, 'CODPROD', 'quote_product_product', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 3, 4, 1, 1068, 'DevUnidade', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 4, 4, 3, 237, 'CODVOL', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 10, 5, 3, 3, 238, 'QTDNEG', 'quote_product_quantity', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 6, 4, 3, 239, 'CODLOCALORIG', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 10, 7, 4, 1, 1069, 'DevControle', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 8, 4, 3, 240, 'CONTROLE', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 10, 9, 4, 1, 1008, 'DevEstoque', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 10, 4, 1, 1070, 'DevValorUnitario', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 11, 4, 1, 1071, 'ValorUnitario', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 12, 3, 3, 241, 'VLRUNIT', 'quote_product_unit_price', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 13, 3, 3, 242, 'PERCDESC', 'quote_product_discount', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 14, 3, 3, 243, 'VLRTOT', 'quote_product_total', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 15, 4, 1, 1072, 'DevImpostos', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 16, 4, 1, 1073, 'IcmsAliq', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 17, 4, 1, 1074, 'IcmsValor', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 18, 4, 1, 1075, 'IpiAliq', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 19, 4, 1, 1076, 'IpiValor', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 20, 4, 1, 1077, 'DevProdIntegrado', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 21, 4, 1, 1078, 'ProdIntegrado', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 22, 4, 1, 1079, 'TotalProduto', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 1, 4, 1, 207, 'SEQUENCIA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 11, 2, 3, 3, 208, 'CODPROD', 'order_product_product', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 3, 4, 1, 1081, 'DevUnidade', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 4, 4, 3, 209, 'CODVOL', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 11, 5, 3, 3, 210, 'QTDNEG', 'order_product_quantity', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 6, 4, 3, 211, 'CODLOCALORIG', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 11, 7, 4, 1, 1082, 'DevControle', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 8, 4, 3, 212, 'CONTROLE', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 11, 9, 4, 1, 1009, 'DevEstoque', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 10, 4, 1, 1083, 'DevValorUnitario', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 11, 4, 1, 1084, 'ValorUnitario', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 12, 3, 3, 213, 'VLRUNIT', 'order_product_unit_price', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 13, 3, 3, 214, 'PERCDESC', 'order_product_discount', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 14, 3, 3, 215, 'VLRTOT', 'order_product_total', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 15, 4, 1, 1085, 'DevImpostos', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 16, 4, 1, 1086, 'IcmsAliq', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 17, 4, 1, 1087, 'IcmsValor', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 18, 4, 1, 1088, 'IpiAliq', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 19, 4, 1, 1089, 'IpiValor', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 20, 4, 1, 1090, 'DevProdIntegrado', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 21, 4, 1, 1091, 'ProdIntegrado', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 22, 4, 1, 1092, 'TotalProduto', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 14, 1, 4, 1, 1095, 'TotalBloco', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 15, 1, 4, 1, 1096, 'TotalBloco', NULL, NULL, 0, 0, 0)
      COMMIT TRANSACTION
	  RETURN @newIntegrationId
    END TRY
    BEGIN CATCH   
      ROLLBACK TRANSACTION
	  THROW
    END CATCH
END;
GO
ALTER AUTHORIZATION ON [dbo].[CreateConfig_2] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[CreateConfig1]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateConfig1]
  @accountId INT,
  @webhookValidationKey VARCHAR(32),
  @integrationUserKey VARCHAR(128),
  @appToken VARCHAR(200),
  @status INT,
  @nextSearchDate DATETIME,
  @userId INT,
  @isSQL BIT,
  @canConvert BIT,
  @hasDhalter BIT,
  @taxCapability INT,
  @createdOn DATETIME,
  @newIntegrationId INT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN
    BEGIN TRY
	  --Get the last Id from the LookUpTable
	  DECLARE @lookupId int
      SET @lookupId = (SELECT MAX([Id]) FROM [Integrations].[dbo].[Lookup])      
      IF (@lookupId IS NULL)
        BEGIN
          SET @lookupId = 0;
        END     

      --Create the Integration Configuration
	  INSERT INTO [Integration]	--[Version] 1, [TaxCapability] @taxCapability, EnabledOn @createdOn
	    ([AccountId],[WebhookValidationKey],[Active],[IntegrationUserKey],[AppToken],[Status],[NextSearchDate],[UserId],[StartLookupId],[IsSql],[CanConvert],[HasDhalter],[Version],[TaxCapability],[EnabledOn])
		VALUES
		(@accountId, @webhookValidationKey, 0, @integrationUserKey, @appToken, @status, @nextSearchDate, @userId, @lookupId, @isSQL, @canConvert, @hasDhalter,1, @taxCapability, @createdOn)
	  SET @newIntegrationId = SCOPE_IDENTITY()
      
	  --Create the Rules
      INSERT INTO [Integration_RuleV2]
        ([IntegrationId],[RuleId],[GoesToPloomes],[GoesToSankhya])
		VALUES
		(@newIntegrationId, 1, 1, 1)
		,(@newIntegrationId, 2, 1, 1)
		,(@newIntegrationId, 3, 1, 0)
		,(@newIntegrationId, 4, 1, 0)
		,(@newIntegrationId, 5, 1, 0)
		,(@newIntegrationId, 6, 1, 1)
		,(@newIntegrationId, 7, 1, 1)
		,(@newIntegrationId, 8, 1, 1)
		,(@newIntegrationId, 9, 1, 0) -- "Sub-rule" of 8
		,(@newIntegrationId, 10, 1, 1) -- SubRule of 7
		,(@newIntegrationId, 11, 1, 1) -- SubRule of 8
		--,(@newIntegrationId, 12, 1, 0) -- SubRule of 9 -- Will not be used
		--,(@newIntegrationId, 13, 1, 0) -- Not avaivable yet (reserved for Financeiro), will be used?
		,(@newIntegrationId, 14, 1, 1) -- Fake Rule for Total Bloco
		,(@newIntegrationId, 15, 1, 1) -- Fake Rule for Total Bloco
      --TODO: Create the Mappings
      INSERT INTO [Integration_MappingV2]
        ([IntegrationId],[RuleId],[Ordination],[MapType],[SelectedDirection],[SuggestedMappingId],[SankhyaFieldKey],[FieldKey],[PhoneTypeId],[GoesToSankhya],[GoesToPloomes],[BlockFieldEdition])
        VALUES
        (@newIntegrationId, 1, 1, 4, 1, 137, 'CODPARC', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 1, 2, 3, 3, 138, 'NOMEPARC', 'contact_name', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 3, 4, 3, 139, 'ATIVO', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 1, 4, 3, 3, 140, 'TIPPESSOA', 'contact_type', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 5, 3, 3, 143, 'CGC_CPF', 'contact_cnpj', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 6, 4, 3, 144, 'CLASSIFICMS', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 1, 7, 3, 3, 145, 'RAZAOSOCIAL', 'contact_legal_name', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 8, 3, 3, 151, 'CODEND', 'contact_street_address', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 9, 3, 3, 146, 'NUMEND', 'contact_street_address_number', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 10, 3, 3, 147, 'COMPLEMENTO', 'contact_street_address_line2', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 11, 3, 3, 152, 'CODBAI', 'contact_neighborhood', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 12, 3, 3, 142, 'CODCID', 'contact_city', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 13, 3, 3, 148, 'CEP', 'contact_zipcode', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 14, 11, 3, 149, 'TELEFONE', 'contact_phones', 1, 1, 1, 0),
        (@newIntegrationId, 1, 15, 11, 3, 184, 'FAX', 'contact_phones', 2, 1, 1, 0),
        (@newIntegrationId, 1, 16, 3, 3, 150, 'EMAIL', 'contact_email', NULL, 1, 1, 0),
        (@newIntegrationId, 1, 17, 3, 3, 141, 'CODVEND', 'contact_owner', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 1, 4, 3, 123, 'CODPARC', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 2, 2, 4, 1, 124, 'CODCONTATO', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 2, 3, 3, 3, 126, 'NOMECONTATO', 'contact_name', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 4, 4, 3, 125, 'ATIVO', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 2, 5, 4, 3, 1003, 'TipoPloomes', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 2, 6, 3, 3, 1094, 'CPF', 'contact_cpf', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 7, 3, 3, 127, 'CARGO', 'contact_role', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 8, 3, 3, 135, 'CODEND', 'contact_street_address', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 9, 3, 3, 129, 'NUMEND', 'contact_street_address_number', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 10, 3, 3, 130, 'COMPLEMENTO', 'contact_street_address_line2', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 11, 3, 3, 136, 'CODBAI', 'contact_neighborhood', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 12, 3, 3, 128, 'CODCID', 'contact_city', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 13, 3, 3, 131, 'CEP', 'contact_zipcode', NULL, 1, 1, 0),
        (@newIntegrationId, 2, 14, 11, 3, 187, 'CELULAR', 'contact_phones', 2, 1, 1, 0),
        (@newIntegrationId, 2, 15, 11, 3, 186, 'FAX', 'contact_phones', 4, 1, 1, 0),
        (@newIntegrationId, 2, 16, 11, 3, 132, 'TELEFONE', 'contact_phones', 1, 1, 1, 0),
        (@newIntegrationId, 2, 17, 3, 3, 134, 'EMAIL', 'contact_email', NULL, 1, 1, 0),
        (@newIntegrationId, 3, 1, 4, 1, 216, 'CODPROD', 'product_code', NULL, 0, 1, 0),
        (@newIntegrationId, 3, 2, 3, 1, 157, 'DESCRPROD', 'product_name', NULL, 0, 1, 0),
        (@newIntegrationId, 3, 3, 4, 1, 158, 'ATIVO', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 3, 4, 3, 1, 159, 'CODGRUPOPROD', 'product_group', NULL, 0, 1, 0),
        (@newIntegrationId, 3, 5, 3, 1, 160, 'CODVOL', 'product_measurement_unit', NULL, 0, 1, 0),
        (@newIntegrationId, 3, 6, 4, 1, 161, 'MARCA', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 3, 7, 4, 1, 162, 'REFFORN', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 3, 8, 4, 1, 163, 'USOPROD', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 3, 9, 4, 1, 164, 'ORIGPROD', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 4, 1, 4, 1, 153, 'CODVEND', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 4, 2, 3, 1, 154, 'APELIDO', 'user_name', NULL, 0, 1, 0),
        (@newIntegrationId, 4, 3, 3, 1, 155, 'EMAIL', 'user_email', NULL, 0, 1, 0),
        (@newIntegrationId, 5, 1, 4, 1, 181, 'CODGRUPOPROD', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 5, 2, 3, 1, 183, 'DESCRGRUPOPROD', 'product_group_name', NULL, 0, 1, 0),
        (@newIntegrationId, 5, 3, 4, 1, 182, 'CODGRUPAI', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 5, 4, 4, 1, 188, 'GruposBusca', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 6, 1, 4, 1, 165, 'CODPARC', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 6, 2, 3, 3, 166, 'NOMEPARC', 'contact_name', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 3, 4, 3, 167, 'ATIVO', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 6, 4, 3, 3, 168, 'TIPPESSOA', 'contact_type', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 5, 4, 3, 1002, 'TipoPloomes', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 6, 6, 3, 3, 171, 'CGC_CPF', 'contact_cpf', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 7, 4, 3, 172, 'CLASSIFICMS', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 6, 8, 3, 3, 173, 'RAZAOSOCIAL', 'contact_legal_name', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 9, 3, 3, 179, 'CODEND', 'contact_street_address', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 10, 3, 3, 174, 'NUMEND', 'contact_street_address_number', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 11, 3, 3, 175, 'COMPLEMENTO', 'contact_street_address_line2', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 12, 3, 3, 180, 'CODBAI', 'contact_neighborhood', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 13, 3, 3, 170, 'CODCID', 'contact_city', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 14, 3, 3, 176, 'CEP', 'contact_zipcode', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 15, 11, 3, 177, 'TELEFONE', 'contact_phones', 1, 1, 1, 0),
        (@newIntegrationId, 6, 16, 11, 3, 185, 'FAX', 'contact_phones', 2, 1, 1, 0),
        (@newIntegrationId, 6, 17, 3, 3, 178, 'EMAIL', 'contact_email', NULL, 1, 1, 0),
        (@newIntegrationId, 6, 18, 3, 3, 169, 'CODVEND', 'contact_owner', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 1, 4, 1, 217, 'NUNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 2, 4, 3, 218, 'NUMNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 3, 4, 3, 219, 'SERIENOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 4, 3, 3, 223, 'CODPARC', 'quote_contact', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 5, 3, 3, 226, 'CODVEND', 'quote_owner', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 6, 3, 3, 233, 'CODCONTATO', 'quote_person', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 7, 4, 3, 220, 'CODEMP', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 8, 4, 3, 224, 'CODTIPOPER', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 9, 4, 3, 225, 'CODTIPVENDA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 10, 4, 3, 221, 'CODCENCUS', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 11, 4, 3, 227, 'CODNAT', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 12, 4, 1, 228, 'STATUSNOTA', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 7, 13, 3, 3, 222, 'DTNEG', 'quote_date', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 14, 4, 3, 229, 'DTFATUR', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 15, 4, 3, 230, 'DTPREVENT', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 16, 4, 3, 1066, 'VLRNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 17, 3, 3, 231, 'PERCDESC', 'quote_discount', NULL, 1, 1, 0),
        (@newIntegrationId, 7, 18, 4, 3, 232, 'CODMOEDA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 19, 4, 3, 234, 'CODPARCTRANSP', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 7, 20, 4, 1, 1004, 'DevFinanceiro', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 7, 21, 4, 1, 1005, 'DevRestricoes', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 8, 1, 4, 1, 189, 'NUNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 2, 4, 3, 190, 'NUMNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 3, 4, 3, 191, 'SERIENOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 4, 3, 3, 195, 'CODPARC', 'order_contact', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 5, 3, 3, 198, 'CODVEND', 'order_owner', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 6, 3, 3, 205, 'CODCONTATO', 'order_person', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 7, 4, 3, 192, 'CODEMP', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 8, 4, 3, 196, 'CODTIPOPER', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 9, 4, 3, 197, 'CODTIPVENDA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 10, 4, 3, 193, 'CODCENCUS', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 11, 4, 3, 199, 'CODNAT', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 12, 4, 1, 200, 'STATUSNOTA', NULL, NULL, 0, 1, 0),
        (@newIntegrationId, 8, 13, 3, 3, 194, 'DTNEG', 'order_date', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 14, 4, 3, 201, 'DTFATUR', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 15, 4, 3, 202, 'DTPREVENT', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 16, 4, 3, 1067, 'VLRNOTA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 17, 3, 3, 203, 'PERCDESC', 'order_discount', NULL, 1, 1, 0),
        (@newIntegrationId, 8, 18, 4, 3, 204, 'CODMOEDA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 19, 4, 3, 206, 'CODPARCTRANSP', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 8, 20, 4, 1, 1006, 'DevFinanceiro', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 8, 21, 4, 1, 1007, 'DevRestricoes', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 1, 4, 1, 235, 'SEQUENCIA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 10, 2, 3, 3, 236, 'CODPROD', 'quote_product_product', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 3, 4, 1, 1068, 'DevUnidade', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 4, 4, 3, 237, 'CODVOL', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 10, 5, 3, 3, 238, 'QTDNEG', 'quote_product_quantity', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 6, 4, 3, 239, 'CODLOCALORIG', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 10, 7, 4, 1, 1069, 'DevControle', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 8, 4, 3, 240, 'CONTROLE', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 10, 9, 4, 1, 1008, 'DevEstoque', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 10, 4, 1, 1070, 'DevValorUnitario', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 11, 4, 1, 1071, 'ValorUnitario', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 12, 3, 3, 241, 'VLRUNIT', 'quote_product_unit_price', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 13, 3, 3, 242, 'PERCDESC', 'quote_product_discount', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 14, 3, 3, 243, 'VLRTOT', 'quote_product_total', NULL, 1, 1, 0),
        (@newIntegrationId, 10, 15, 4, 1, 1072, 'DevImpostos', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 16, 4, 1, 1073, 'IcmsAliq', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 17, 4, 1, 1074, 'IcmsValor', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 18, 4, 1, 1075, 'IpiAliq', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 19, 4, 1, 1076, 'IpiValor', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 20, 4, 1, 1077, 'DevProdIntegrado', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 21, 4, 1, 1078, 'ProdIntegrado', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 10, 22, 4, 1, 1079, 'TotalProduto', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 1, 4, 1, 207, 'SEQUENCIA', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 11, 2, 3, 3, 208, 'CODPROD', 'order_product_product', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 3, 4, 1, 1081, 'DevUnidade', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 4, 4, 3, 209, 'CODVOL', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 11, 5, 3, 3, 210, 'QTDNEG', 'order_product_quantity', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 6, 4, 3, 211, 'CODLOCALORIG', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 11, 7, 4, 1, 1082, 'DevControle', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 8, 4, 3, 212, 'CONTROLE', NULL, NULL, 1, 1, 0),
        (@newIntegrationId, 11, 9, 4, 1, 1009, 'DevEstoque', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 10, 4, 1, 1083, 'DevValorUnitario', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 11, 4, 1, 1084, 'ValorUnitario', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 12, 3, 3, 213, 'VLRUNIT', 'order_product_unit_price', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 13, 3, 3, 214, 'PERCDESC', 'order_product_discount', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 14, 3, 3, 215, 'VLRTOT', 'order_product_total', NULL, 1, 1, 0),
        (@newIntegrationId, 11, 15, 4, 1, 1085, 'DevImpostos', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 16, 4, 1, 1086, 'IcmsAliq', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 17, 4, 1, 1087, 'IcmsValor', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 18, 4, 1, 1088, 'IpiAliq', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 19, 4, 1, 1089, 'IpiValor', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 20, 4, 1, 1090, 'DevProdIntegrado', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 21, 4, 1, 1091, 'ProdIntegrado', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 11, 22, 4, 1, 1092, 'TotalProduto', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 14, 1, 4, 1, 1095, 'TotalBloco', NULL, NULL, 0, 0, 0),
        (@newIntegrationId, 15, 1, 4, 1, 1096, 'TotalBloco', NULL, NULL, 0, 0, 0)
      COMMIT TRANSACTION
	  RETURN @newIntegrationId
    END TRY
    BEGIN CATCH   
      ROLLBACK TRANSACTION
	  THROW
    END CATCH
END;


GO
ALTER AUTHORIZATION ON [dbo].[CreateConfig1] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[CreateDraft]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateDraft]
  @accountId INT,
  @status INT,
  @nextSearchDate DATETIME,
  @userId INT,
  @newIntegrationId INT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN
    BEGIN TRY

	  --Get the Active IntegrationId from the Integration Table
	  DECLARE @oldIntegrationId INT
      SET @oldIntegrationId = (SELECT TOP 1 [Id] FROM [Integrations].[dbo].[Integration] WHERE [AccountId] = @accountId AND [ReplacedIn] is null AND [Status] >= 800 order by [Id] desc)
      IF (@oldIntegrationId IS NULL)
        BEGIN
          SET @newIntegrationId = 0;
		  RETURN @newIntegrationId
        END

      --Clone the Integration Configuration
	  INSERT INTO [Integrations].[dbo].[Integration]	
	    ([AccountId],[WebhookValidationKey],[Active],[IntegrationUserKey],[AppToken],[Status],[NextSearchDate],[UserId],[TimeZoneOffSet],[StartLookupId],[IsSql],[CanConvert],[HasDhalter])
      SELECT -[AccountId],[WebhookValidationKey],0,[IntegrationUserKey],[AppToken],@status,@nextSearchDate,@userId,[TimeZoneOffSet],[StartLookupId],[IsSql],[CanConvert],[HasDhalter] FROM [Integrations].[dbo].[Integration] WHERE [Id] = @oldIntegrationId And [AccountId] = @accountId AND [ReplacedIn] is null AND [Status] >= 800
	  SET @newIntegrationId = SCOPE_IDENTITY()

	  --Clone the Rules
	  INSERT INTO [Integrations].[dbo].[Integration_RuleV2]
        ([IntegrationId],[RuleId],[GoesToPloomes],[GoesToSankhya],[Saved],[TriggerOptionIdOnImportInsert],[TriggerOptionIdOnImportUpdate],[TriggerOptionIdOnExportInsert],[TriggerOptionIdOnExportUpdate],[PloomesToSankhya],[PloomesCreationFilterId],[SankhyaCreationFilterSQL],[DocumentLinkEnabled],[DocumentLinkPipelineId],[DocumentLinkStageId])
	  SELECT 
		@newIntegrationId,[RuleId],[GoesToPloomes],[GoesToSankhya],[Saved],[TriggerOptionIdOnImportInsert],[TriggerOptionIdOnImportUpdate],[TriggerOptionIdOnExportInsert],[TriggerOptionIdOnExportUpdate],[PloomesToSankhya],[PloomesCreationFilterId],[SankhyaCreationFilterSQL],[DocumentLinkEnabled],[DocumentLinkPipelineId],[DocumentLinkStageId]
			FROM [Integrations].[dbo].[Integration_RuleV2] WHERE [IntegrationId] = @oldIntegrationId

      --Clone mappings
	  INSERT INTO [Integrations].[dbo].[Integration_MappingV2]
        ([IntegrationId],[RuleId],[Ordination],[SankhyaFieldKey],[FieldKey],[MapType],[PhoneTypeId],[BlockFieldEdition],[SuggestedMappingId],[GoesToPloomes],[GoesToSankhya],[SelectedDirection])
	  SELECT 
        @newIntegrationId,[RuleId],[Ordination],[SankhyaFieldKey],[FieldKey],[MapType],[PhoneTypeId],[BlockFieldEdition],[SuggestedMappingId],[GoesToPloomes],[GoesToSankhya],[SelectedDirection]
	  FROM [Integrations].[dbo].[Integration_MappingV2] WHERE [IntegrationId] = @oldIntegrationId	  

	  --Clone Tops
	  INSERT INTO [Integrations].[dbo].[Sankhya_Tipo_Operacao]
        ([IntegrationId],[CODTIPOPER],[DESCROPER],[TIPMOV],[DHALTER],[RuleId],[TemplateId])
	  SELECT 
        @newIntegrationId,[CODTIPOPER],[DESCROPER],[TIPMOV],[DHALTER],[RuleId],[TemplateId]
	  FROM [Integrations].[dbo].[Sankhya_Tipo_Operacao] WHERE [IntegrationId] = @oldIntegrationId	  

	  --Clone Metatada
	  INSERT INTO [Temp].[dbo].[Sankhya_Field]
        ([IntegrationId],[SankhyaEntityId],[Key],[TypeId],[Name],[Multiple],[ReadOnly],[Required],[Options],[IsFake],[SankhyaType])
	  SELECT 
        @newIntegrationId,[SankhyaEntityId],[Key],[TypeId],[Name],[Multiple],[ReadOnly],[Required],[Options],[IsFake],[SankhyaType]
	  FROM [Temp].[dbo].[Sankhya_Field] WHERE [IntegrationId] = @oldIntegrationId	  

	  --Clone TipoEndereco
	  --INSERT INTO [Temp].[dbo].[Sankhya_TipoEndereco]
        --([IntegrationId],[TIPO],[DESCRICAO])
	  --SELECT 
        --@newIntegrationId,[TIPO],[DESCRICAO]
	  --FROM [Temp].[dbo].[Sankhya_TipoEndereco] WHERE [IntegrationId] = @oldIntegrationId

 	  --Clone GrupoProduto
	  --INSERT INTO [Temp].[dbo].[Sankhya_Grupo_Produto]
        --([IntegrationId],[CODGRUPOPROD],[DESCRGRUPOPROD],[CODGRUPAI],[GruposBusca],[DESCGRUPAI])
	  --SELECT 
        --@newIntegrationId,[CODGRUPOPROD],[DESCRGRUPOPROD],[CODGRUPAI],[GruposBusca],[DESCGRUPAI]
	  --FROM [Temp].[dbo].[Sankhya_Grupo_Produto] WHERE [IntegrationId] = @oldIntegrationId

  	  --Clone Options Entities [Temp].[dbo].[Sankhya_Entities_to_Options]
	  --INSERT INTO [Temp].[dbo].[Sankhya_Entities_to_Options]
        --([IntegrationId],[SankhyaEntityId],[CODIGO],[DESCRICAO],[EXTRAINFO])
	  --SELECT 
        --@newIntegrationId,[SankhyaEntityId],[CODIGO],[DESCRICAO],[EXTRAINFO]
	  --FROM [Temp].[dbo].[Sankhya_Entities_to_Options] WHERE [IntegrationId] = @oldIntegrationId

      COMMIT TRANSACTION
	  RETURN @newIntegrationId
    END TRY
    BEGIN CATCH   
      ROLLBACK TRANSACTION
	  THROW
    END CATCH
END;
GO
ALTER AUTHORIZATION ON [dbo].[CreateDraft] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[CreateDraft1]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateDraft1]
  @accountId INT,
  @status INT,
  @nextSearchDate DATETIME,
  @userId INT,
  @createdOn DATETIME,
  @newIntegrationId INT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN
    BEGIN TRY

	  --Get the Active IntegrationId from the Integration Table
	  DECLARE @oldIntegrationId INT
      SET @oldIntegrationId = (SELECT TOP 1 [Id] FROM [Integrations].[dbo].[Integration] WHERE [AccountId] = @accountId AND [ReplacedIn] is null AND [Status] >= 800 order by [Id] desc)
      IF (@oldIntegrationId IS NULL)
        BEGIN
          SET @newIntegrationId = 0;
		  RETURN @newIntegrationId
        END

      --Clone the Integration Configuration
	  INSERT INTO [Integrations].[dbo].[Integration]	
	    ([AccountId],[WebhookValidationKey],[Active],[IntegrationUserKey],[AppToken],[Status],[NextSearchDate],[UserId],[TimeZoneOffSet],[StartLookupId],[IsSql],[CanConvert],[HasDhalter],[Version],[TaxCapability],[EnabledOn],[BaseIntegration])
      SELECT -[AccountId],[WebhookValidationKey],0,[IntegrationUserKey],[AppToken],@status,@nextSearchDate,@userId,[TimeZoneOffSet],[StartLookupId],[IsSql],[CanConvert],[HasDhalter],1,[TaxCapability], @createdOn, @oldIntegrationId FROM [Integrations].[dbo].[Integration] WHERE [Id] = @oldIntegrationId And [AccountId] = @accountId AND [ReplacedIn] is null AND [Status] >= 800
	  SET @newIntegrationId = SCOPE_IDENTITY()

	  --Clone the Rules
	  INSERT INTO [Integrations].[dbo].[Integration_RuleV2]
        ([IntegrationId],[RuleId],[GoesToPloomes],[GoesToSankhya],[Saved],[TriggerOptionIdOnImportInsert],[TriggerOptionIdOnImportUpdate],[TriggerOptionIdOnExportInsert],[TriggerOptionIdOnExportUpdate],[PloomesToSankhya],[PloomesCreationFilterId],[SankhyaCreationFilterSQL],[DocumentLinkEnabled],[DocumentLinkPipelineId],[DocumentLinkStageId])
	  SELECT 
		@newIntegrationId,[RuleId],[GoesToPloomes],[GoesToSankhya],[Saved],[TriggerOptionIdOnImportInsert],[TriggerOptionIdOnImportUpdate],[TriggerOptionIdOnExportInsert],[TriggerOptionIdOnExportUpdate],[PloomesToSankhya],[PloomesCreationFilterId],[SankhyaCreationFilterSQL],[DocumentLinkEnabled],[DocumentLinkPipelineId],[DocumentLinkStageId]
			FROM [Integrations].[dbo].[Integration_RuleV2] WHERE [IntegrationId] = @oldIntegrationId

      --Clone mappings
	  INSERT INTO [Integrations].[dbo].[Integration_MappingV2]
        ([IntegrationId],[RuleId],[Ordination],[SankhyaFieldKey],[FieldKey],[MapType],[PhoneTypeId],[BlockFieldEdition],[SuggestedMappingId],[GoesToPloomes],[GoesToSankhya],[SelectedDirection])
	  SELECT 
        @newIntegrationId,[RuleId],[Ordination],[SankhyaFieldKey],[FieldKey],[MapType],[PhoneTypeId],[BlockFieldEdition],[SuggestedMappingId],[GoesToPloomes],[GoesToSankhya],[SelectedDirection]
	  FROM [Integrations].[dbo].[Integration_MappingV2] WHERE [IntegrationId] = @oldIntegrationId	  

	  --Clone Tops
	  INSERT INTO [Integrations].[dbo].[Sankhya_Tipo_Operacao]
        ([IntegrationId],[CODTIPOPER],[DESCROPER],[TIPMOV],[DHALTER],[RuleId],[TemplateId])
	  SELECT 
        @newIntegrationId,[CODTIPOPER],[DESCROPER],[TIPMOV],[DHALTER],[RuleId],[TemplateId]
	  FROM [Integrations].[dbo].[Sankhya_Tipo_Operacao] WHERE [IntegrationId] = @oldIntegrationId	  

	  --Clone Metatada
	  INSERT INTO [Temp].[dbo].[Sankhya_Field]
        ([IntegrationId],[SankhyaEntityId],[Key],[TypeId],[Name],[Multiple],[ReadOnly],[Required],[Options],[IsFake],[SankhyaType])
	  SELECT 
        @newIntegrationId,[SankhyaEntityId],[Key],[TypeId],[Name],[Multiple],[ReadOnly],[Required],[Options],[IsFake],[SankhyaType]
	  FROM [Temp].[dbo].[Sankhya_Field] WHERE [IntegrationId] = @oldIntegrationId	  

	  --Clone TipoEndereco
	  --INSERT INTO [Temp].[dbo].[Sankhya_TipoEndereco]
        --([IntegrationId],[TIPO],[DESCRICAO])
	  --SELECT 
        --@newIntegrationId,[TIPO],[DESCRICAO]
	  --FROM [Temp].[dbo].[Sankhya_TipoEndereco] WHERE [IntegrationId] = @oldIntegrationId

 	  --Clone GrupoProduto
	  --INSERT INTO [Temp].[dbo].[Sankhya_Grupo_Produto]
        --([IntegrationId],[CODGRUPOPROD],[DESCRGRUPOPROD],[CODGRUPAI],[GruposBusca],[DESCGRUPAI])
	  --SELECT 
        --@newIntegrationId,[CODGRUPOPROD],[DESCRGRUPOPROD],[CODGRUPAI],[GruposBusca],[DESCGRUPAI]
	  --FROM [Temp].[dbo].[Sankhya_Grupo_Produto] WHERE [IntegrationId] = @oldIntegrationId

  	  --Clone Options Entities [Temp].[dbo].[Sankhya_Entities_to_Options]
	  --INSERT INTO [Temp].[dbo].[Sankhya_Entities_to_Options]
        --([IntegrationId],[SankhyaEntityId],[CODIGO],[DESCRICAO],[EXTRAINFO])
	  --SELECT 
        --@newIntegrationId,[SankhyaEntityId],[CODIGO],[DESCRICAO],[EXTRAINFO]
	  --FROM [Temp].[dbo].[Sankhya_Entities_to_Options] WHERE [IntegrationId] = @oldIntegrationId

      COMMIT TRANSACTION
	  RETURN @newIntegrationId
    END TRY
    BEGIN CATCH   
      ROLLBACK TRANSACTION
	  THROW
    END CATCH
END;

--
--
--
--
GO
ALTER AUTHORIZATION ON [dbo].[CreateDraft1] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[RefreshTops]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RefreshTops]
  @integrationId INT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN
    BEGIN TRY	  

	  --Copy old TOPs info to the new ones, delete Old Tops and change the [IntegrationId] of the new Tops
	  UPDATE D SET D.[RuleId] = S.[RuleId], D.[TemplateId] = S.[TemplateId]
	  FROM [Integrations].[dbo].[Sankhya_Tipo_Operacao] AS D INNER JOIN [Integrations].[dbo].[Sankhya_Tipo_Operacao] AS S
	  on S.[IntegrationId] = @integrationId AND S.[RuleId] IS NOT NULL AND S.[TemplateId] IS NOT NULL AND D.[IntegrationId] = -@integrationId AND D.[CODTIPOPER]  = S.[CODTIPOPER]  
	  DELETE FROM [Integrations].[dbo].[Sankhya_Tipo_Operacao] WHERE [IntegrationId] = @integrationId
	  UPDATE [Integrations].[dbo].[Sankhya_Tipo_Operacao] SET [IntegrationId] = @integrationId WHERE [IntegrationId] = -@integrationId

      COMMIT TRANSACTION
    END TRY
    BEGIN CATCH   
      ROLLBACK TRANSACTION
	  THROW
    END CATCH
END;
GO
ALTER AUTHORIZATION ON [dbo].[RefreshTops] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[RessurectConfig]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RessurectConfig]
  @accountId INT,
  @webhookValidationKey VARCHAR(32),
  @integrationUserKey VARCHAR(128),
  @appToken VARCHAR(200),
  @status INT,
  @nextSearchDate DATETIME,
  @userId INT,
  @isSQL BIT,
  @canConvert BIT,
  @hasDhalter BIT,
  @newIntegrationId INT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN
    BEGIN TRY

	--Get the newest Id from the Integration Table
	  DECLARE @oldIntegrationId INT
      SET @oldIntegrationId = (SELECT TOP 1 [Id] FROM [Integrations].[dbo].[Integration] WHERE [AccountId] = @accountId AND [ReplacedIn] is not null AND [Status] >= 800 order by [Id] desc)
      IF (@oldIntegrationId IS NULL)
        BEGIN
          SET @newIntegrationId = 0;
		  RETURN @newIntegrationId
        END

	  --Get the last Id from the LookUpTable
	  DECLARE @lookupId int
      SET @lookupId = (SELECT MAX([Id]) FROM [Integrations].[dbo].[Lookup])      
      IF (@lookupId IS NULL)
        BEGIN
          SET @lookupId = 0;
        END

      --Recriate the Integration Configuration
	  INSERT INTO [Integrations].[dbo].[Integration]	
	    ([AccountId],[WebhookValidationKey],[Active],[IntegrationUserKey],[AppToken],[Status],[NextSearchDate],[UserId],[StartLookupId],[IsSql],[CanConvert],[HasDhalter])
      SELECT [AccountId],@webhookValidationKey,0,@integrationUserKey,@appToken, @status,@nextSearchDate,@userId,@lookupId,@isSQL, @canConvert,@hasDhalter FROM [Integrations].[dbo].[Integration] WHERE [Id] = @oldIntegrationId And [AccountId] = @accountId AND [ReplacedIn] is not null
	  SET @newIntegrationId = SCOPE_IDENTITY()

	  --Clone the Rules (as not [Saved])
	  INSERT INTO [Integrations].[dbo].[Integration_RuleV2]
        ([IntegrationId],[RuleId],[GoesToPloomes],[GoesToSankhya],[TriggerOptionIdOnImportInsert],[TriggerOptionIdOnImportUpdate],[TriggerOptionIdOnExportInsert],[TriggerOptionIdOnExportUpdate],[PloomesToSankhya],[PloomesCreationFilterId],[SankhyaCreationFilterSQL],[DocumentLinkEnabled],[DocumentLinkPipelineId],[DocumentLinkStageId])
	  SELECT 
		@newIntegrationId,[RuleId],[GoesToPloomes],[GoesToSankhya],[TriggerOptionIdOnImportInsert],[TriggerOptionIdOnImportUpdate],[TriggerOptionIdOnExportInsert],[TriggerOptionIdOnExportUpdate],[PloomesToSankhya],[PloomesCreationFilterId],[SankhyaCreationFilterSQL],[DocumentLinkEnabled],[DocumentLinkPipelineId],[DocumentLinkStageId]
	  FROM [Integrations].[dbo].[Integration_RuleV2] WHERE [IntegrationId] = @oldIntegrationId

      --Clone mappings
	  INSERT INTO [Integrations].[dbo].[Integration_MappingV2]
        ([IntegrationId],[RuleId],[Ordination],[SankhyaFieldKey],[FieldKey],[MapType],[PhoneTypeId],[BlockFieldEdition],[SuggestedMappingId],[GoesToPloomes],[GoesToSankhya],[SelectedDirection])
	  SELECT 
        @newIntegrationId,[RuleId],[Ordination],[SankhyaFieldKey],[FieldKey],[MapType],[PhoneTypeId],[BlockFieldEdition],[SuggestedMappingId],[GoesToPloomes],[GoesToSankhya],[SelectedDirection]
	  FROM [Integrations].[dbo].[Integration_MappingV2] WHERE [IntegrationId] = @oldIntegrationId


	  --Clone Tops
	  INSERT INTO [Integrations].[dbo].[Sankhya_Tipo_Operacao]
        ([IntegrationId],[CODTIPOPER],[DESCROPER],[TIPMOV],[DHALTER],[RuleId],[TemplateId])
	  SELECT 
        @newIntegrationId,[CODTIPOPER],[DESCROPER],[TIPMOV],[DHALTER],[RuleId],[TemplateId]
	  FROM [Integrations].[dbo].[Sankhya_Tipo_Operacao] WHERE [IntegrationId] = @oldIntegrationId	  

	  --Clone Metatada
	  INSERT INTO [Temp].[dbo].[Sankhya_Field]
        ([IntegrationId],[SankhyaEntityId],[Key],[TypeId],[Name],[Multiple],[ReadOnly],[Required],[Options],[IsFake],[SankhyaType])
	  SELECT 
        @newIntegrationId,[SankhyaEntityId],[Key],[TypeId],[Name],[Multiple],[ReadOnly],[Required],[Options],[IsFake],[SankhyaType]
	  FROM [Temp].[dbo].[Sankhya_Field] WHERE [IntegrationId] = @oldIntegrationId	  

      COMMIT TRANSACTION
	  RETURN @newIntegrationId
    END TRY
    BEGIN CATCH   
      ROLLBACK TRANSACTION
	  THROW
    END CATCH
END;
GO
ALTER AUTHORIZATION ON [dbo].[RessurectConfig] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[RessurectConfig1]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RessurectConfig1]
  @accountId INT,
  @webhookValidationKey VARCHAR(32),
  @integrationUserKey VARCHAR(128),
  @appToken VARCHAR(200),
  @status INT,
  @nextSearchDate DATETIME,
  @userId INT,
  @isSQL BIT,
  @canConvert BIT,
  @hasDhalter BIT,
  @taxCapability INT,
  @createdOn DATETIME,
  @newIntegrationId INT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN
    BEGIN TRY

	--Get the newest Id from the Integration Table
	  DECLARE @oldIntegrationId INT
      SET @oldIntegrationId = (SELECT TOP 1 [Id] FROM [Integrations].[dbo].[Integration] WHERE [AccountId] = @accountId AND [ReplacedIn] is not null AND [Status] >= 800 order by [Id] desc)
      IF (@oldIntegrationId IS NULL)
        BEGIN
          SET @newIntegrationId = 0;
		  RETURN @newIntegrationId
        END

	  --Get the last Id from the LookUpTable
	  DECLARE @lookupId int
      SET @lookupId = (SELECT MAX([Id]) FROM [Integrations].[dbo].[Lookup])      
      IF (@lookupId IS NULL)
        BEGIN
          SET @lookupId = 0;
        END

      --Recriate the Integration Configuration
	  INSERT INTO [Integrations].[dbo].[Integration]	
	    ([AccountId],[WebhookValidationKey],[Active],[IntegrationUserKey],[AppToken],[Status],[NextSearchDate],[UserId],[StartLookupId],[IsSql],[CanConvert],[HasDhalter],[Version],[TaxCapability],[EnabledOn],[BaseIntegration])
      SELECT [AccountId],@webhookValidationKey,0,@integrationUserKey,@appToken, @status,@nextSearchDate,@userId,@lookupId,@isSQL, @canConvert,@hasDhalter,1, @taxCapability, @createdOn, @oldIntegrationId FROM [Integrations].[dbo].[Integration] WHERE [Id] = @oldIntegrationId And [AccountId] = @accountId AND [ReplacedIn] is not null
	  SET @newIntegrationId = SCOPE_IDENTITY()
      
	  --Clone the Rules (as not [Saved])
	  INSERT INTO [Integrations].[dbo].[Integration_RuleV2]
        ([IntegrationId],[RuleId],[GoesToPloomes],[GoesToSankhya],[TriggerOptionIdOnImportInsert],[TriggerOptionIdOnImportUpdate],[TriggerOptionIdOnExportInsert],[TriggerOptionIdOnExportUpdate],[PloomesToSankhya],[PloomesCreationFilterId],[SankhyaCreationFilterSQL],[DocumentLinkEnabled],[DocumentLinkPipelineId],[DocumentLinkStageId])
	  SELECT 
		@newIntegrationId,[RuleId],[GoesToPloomes],[GoesToSankhya],[TriggerOptionIdOnImportInsert],[TriggerOptionIdOnImportUpdate],[TriggerOptionIdOnExportInsert],[TriggerOptionIdOnExportUpdate],[PloomesToSankhya],[PloomesCreationFilterId],[SankhyaCreationFilterSQL],[DocumentLinkEnabled],[DocumentLinkPipelineId],[DocumentLinkStageId]
	  FROM [Integrations].[dbo].[Integration_RuleV2] WHERE [IntegrationId] = @oldIntegrationId

      --Clone mappings
	  INSERT INTO [Integrations].[dbo].[Integration_MappingV2]
        ([IntegrationId],[RuleId],[Ordination],[SankhyaFieldKey],[FieldKey],[MapType],[PhoneTypeId],[BlockFieldEdition],[SuggestedMappingId],[GoesToPloomes],[GoesToSankhya],[SelectedDirection])
	  SELECT 
        @newIntegrationId,[RuleId],[Ordination],[SankhyaFieldKey],[FieldKey],[MapType],[PhoneTypeId],[BlockFieldEdition],[SuggestedMappingId],[GoesToPloomes],[GoesToSankhya],[SelectedDirection]
	  FROM [Integrations].[dbo].[Integration_MappingV2] WHERE [IntegrationId] = @oldIntegrationId
      

	  --Clone Tops
	  INSERT INTO [Integrations].[dbo].[Sankhya_Tipo_Operacao]
        ([IntegrationId],[CODTIPOPER],[DESCROPER],[TIPMOV],[DHALTER],[RuleId],[TemplateId])
	  SELECT 
        @newIntegrationId,[CODTIPOPER],[DESCROPER],[TIPMOV],[DHALTER],[RuleId],[TemplateId]
	  FROM [Integrations].[dbo].[Sankhya_Tipo_Operacao] WHERE [IntegrationId] = @oldIntegrationId	  

	  --Clone Metatada
	  INSERT INTO [Temp].[dbo].[Sankhya_Field]
        ([IntegrationId],[SankhyaEntityId],[Key],[TypeId],[Name],[Multiple],[ReadOnly],[Required],[Options],[IsFake],[SankhyaType])
	  SELECT 
        @newIntegrationId,[SankhyaEntityId],[Key],[TypeId],[Name],[Multiple],[ReadOnly],[Required],[Options],[IsFake],[SankhyaType]
	  FROM [Temp].[dbo].[Sankhya_Field] WHERE [IntegrationId] = @oldIntegrationId	  

      COMMIT TRANSACTION
	  RETURN @newIntegrationId
    END TRY
    BEGIN CATCH   
      ROLLBACK TRANSACTION
	  THROW
    END CATCH
END;

--
--
--
--
GO
ALTER AUTHORIZATION ON [dbo].[RessurectConfig1] TO  SCHEMA OWNER 
GO
/****** Object:  StoredProcedure [dbo].[RessurectConfig2]    Script Date: 24/05/2024 16:09:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RessurectConfig2]  
  @accountId INT,  
  @webhookValidationKey VARCHAR(32),  
  @integrationUserKey VARCHAR(128),  
  @appToken VARCHAR(200),  
  @status INT,  
  @nextSearchDate DATETIME,  
  @userId INT,  
  @isSQL BIT,  
  @canConvert BIT,  
  @hasDhalter BIT,  
  @taxCapability INT,  
  @createdOn DATETIME,  
  @timeZoneOffSet int,  
  @newIntegrationId INT OUTPUT  
AS  
BEGIN  
  SET NOCOUNT ON;  
  BEGIN TRAN  
    BEGIN TRY  

 --Get the newest Id from the Integration Table  
   DECLARE @oldIntegrationId INT  
      SET @oldIntegrationId = (SELECT TOP 1 [Id] FROM [Integrations].[dbo].[Integration] WHERE [AccountId] = @accountId AND [ReplacedIn] is not null AND [Status] >= 800 order by [Id] desc)  
      IF (@oldIntegrationId IS NULL)  
        BEGIN  
          SET @newIntegrationId = 0;  
    RETURN @newIntegrationId  
        END  

   --Get the last Id from the LookUpTable  
   DECLARE @lookupId int  
      SET @lookupId = (SELECT MAX([Id]) FROM [Integrations].[dbo].[Lookup])        
      IF (@lookupId IS NULL)  
        BEGIN  
          SET @lookupId = 0;  
        END  

      --Recriate the Integration Configuration  
      INSERT INTO [Integrations].[dbo].[Integration]     
     ([AccountId],[WebhookValidationKey],[Active],[IntegrationUserKey],[AppToken],[Status],[NextSearchDate],[UserId],[StartLookupId],[IsSql],[CanConvert],[HasDhalter],[Version],[TaxCapability],[EnabledOn],[BaseIntegration],[TimeZoneOffSet])    
      SELECT [AccountId],@webhookValidationKey,0,@integrationUserKey,@appToken, @status,@nextSearchDate,@userId,@lookupId,@isSQL, @canConvert,@hasDhalter,1, @taxCapability, @createdOn, @oldIntegrationId, @timeZoneOffSet FROM [Integrations].[dbo].[Integration] WHERE [Id] =  
 @oldIntegrationId And [AccountId] = @accountId AND [ReplacedIn] is not null    
   SET @newIntegrationId = SCOPE_IDENTITY()  


   --Clone the Rules (as not [Saved])  
   INSERT INTO [Integrations].[dbo].[Integration_RuleV2]  
        ([IntegrationId],[RuleId],[GoesToPloomes],[GoesToSankhya],[TriggerOptionIdOnImportInsert],[TriggerOptionIdOnImportUpdate],[TriggerOptionIdOnExportInsert],[TriggerOptionIdOnExportUpdate],[PloomesToSankhya],[PloomesCreationFilterId],[SankhyaCreationFilterSQL],[DocumentLinkEnabled],[DocumentLinkPipelineId],[DocumentLinkStageId])  
   SELECT   
  @newIntegrationId,[RuleId],[GoesToPloomes],[GoesToSankhya],[TriggerOptionIdOnImportInsert],[TriggerOptionIdOnImportUpdate],[TriggerOptionIdOnExportInsert],[TriggerOptionIdOnExportUpdate],[PloomesToSankhya],[PloomesCreationFilterId],[SankhyaCreationFilterSQL],[DocumentLinkEnabled],[DocumentLinkPipelineId],[DocumentLinkStageId]  
   FROM [Integrations].[dbo].[Integration_RuleV2] WHERE [IntegrationId] = @oldIntegrationId  

      --Clone mappings  
   INSERT INTO [Integrations].[dbo].[Integration_MappingV2]  
        ([IntegrationId],[RuleId],[Ordination],[SankhyaFieldKey],[FieldKey],[MapType],[PhoneTypeId],[BlockFieldEdition],[SuggestedMappingId],[GoesToPloomes],[GoesToSankhya],[SelectedDirection])  
   SELECT   
        @newIntegrationId,[RuleId],[Ordination],[SankhyaFieldKey],[FieldKey],[MapType],[PhoneTypeId],[BlockFieldEdition],[SuggestedMappingId],[GoesToPloomes],[GoesToSankhya],[SelectedDirection]  
   FROM [Integrations].[dbo].[Integration_MappingV2] WHERE [IntegrationId] = @oldIntegrationId  


   --Clone Tops  
   INSERT INTO [Integrations].[dbo].[Sankhya_Tipo_Operacao]  
        ([IntegrationId],[CODTIPOPER],[DESCROPER],[TIPMOV],[DHALTER],[RuleId],[TemplateId])  
   SELECT   
        @newIntegrationId,[CODTIPOPER],[DESCROPER],[TIPMOV],[DHALTER],[RuleId],[TemplateId]  
   FROM [Integrations].[dbo].[Sankhya_Tipo_Operacao] WHERE [IntegrationId] = @oldIntegrationId     

   --Clone Metatada  
   INSERT INTO [Temp].[dbo].[Sankhya_Field]  
        ([IntegrationId],[SankhyaEntityId],[Key],[TypeId],[Name],[Multiple],[ReadOnly],[Required],[Options],[IsFake],[SankhyaType])  
   SELECT   
        @newIntegrationId,[SankhyaEntityId],[Key],[TypeId],[Name],[Multiple],[ReadOnly],[Required],[Options],[IsFake],[SankhyaType]  
   FROM [Temp].[dbo].[Sankhya_Field] WHERE [IntegrationId] = @oldIntegrationId     

      COMMIT TRANSACTION  
   RETURN @newIntegrationId  
    END TRY  
    BEGIN CATCH     
      ROLLBACK TRANSACTION  
   THROW  
    END CATCH  
END;  
GO
ALTER AUTHORIZATION ON [dbo].[RessurectConfig2] TO  SCHEMA OWNER 
GO
