use ploomes_CRM
GO 

ALTER TABLE Ploomes_Cliente ADD [ModuleId] [int] NULL
ALTER TABLE Ploomes_Cliente ADD 	[ModulePartnersId] [int] NULL
ALTER TABLE Ploomes_Cliente ADD 	[MaximumGetRequestsPerMinute] [int] NULL
ALTER TABLE Ploomes_Cliente ADD 	[MaximumNotGetRequestsPerMinute] [int] NULL
GO
ALTER VIEW [dbo].[AVw_Self] AS
	SELECT U.*, CONVERT(BIT, IIF(PC.ID_Plano = 2 AND CAST(PC.Expira as DATE) < CAST(GETDATE() as DATE), 1, 0)) as ContaExpirada,
			PC.MultiFactorAuthenticationTypeId, PC.MultiFactorAuthenticationExpirationSeconds, PC.MaximumRequestsPerMinute, PC.SSO, PC.UseOnlyExternalLogin, PC.MaximumGetRequestsPerMinute, PC.MaximumNotGetRequestsPerMinute
		FROM Usuario U LEFT JOIN Ploomes_Cliente PC ON U.ID_ClientePloomes = PC.ID
		WHERE U.Suspenso = 'False'
GO
CREATE TABLE [dbo].[Ploomes_Cliente_Module](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[WorkflowModule] [bit] NULL,
	[PublicFormModule] [bit] NULL,
	[AutomationDocumentsModule] [bit] NULL,
	[DocumentModule] [bit] NULL,
	[QuoteModule] [bit] NULL,
	[OrderModule] [bit] NULL,
	[CPQModule] [bit] NULL,
	[AnalyticsModule] [bit] NULL,
	[ContactProductModule] [bit] NULL,
	[LibraryModule] [bit] NULL,
	[APIModule] [bit] NULL,
	[WhiteLabelModule] [bit] NULL,
	[ProductsModule] [bit] NULL,
	[DealsModule] [bit] NULL,
 CONSTRAINT [PK_Ploomes_Cliente_Module] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Ploomes_Cliente_Module_AccountId] ON [dbo].[Ploomes_Cliente_Module]
(
	[AccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Ploomes_Cliente_Module_Partners](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[WorkflowModule] [bit] NULL,
	[PublicFormModule] [bit] NULL,
	[AutomationDocumentsModule] [bit] NULL,
	[CPQModule] [bit] NULL,
	[AnalyticsModule] [bit] NULL,
	[ContactProductModule] [bit] NULL,
	[LibraryModule] [bit] NULL,
	[APIModule] [bit] NULL,
	[WhiteLabelModule] [bit] NULL,
 CONSTRAINT [PK_Ploomes_Cliente_Module_Partners] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Ploomes_Cliente_Module_Partners_AccountId] ON [dbo].[Ploomes_Cliente_Module_Partners]
(
	[AccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
CREATE VIEW [dbo].[SSvw_Ploomes_Cliente_Module] AS
	SELECT PCM.*, S.ID as ViewServiceId
		FROM Ploomes_Cliente_Module PCM INNER JOIN Servicos S ON S.Contas = 'True'
GO
CREATE VIEW [dbo].[SSvw_Ploomes_Cliente_Module_Partners] AS
	SELECT PCM.*, S.ID as ViewServiceId
		FROM Ploomes_Cliente_Module_Partners PCM INNER JOIN Servicos S ON S.Contas = 'True'
GO
CREATE VIEW [dbo].[SVw_Ploomes_Cliente_Module] AS
	SELECT PCM.*, U.ID as UserId
		FROM Ploomes_Cliente_Module PCM CROSS JOIN Usuario U
GO
CREATE VIEW [dbo].[SVw_Ploomes_Cliente_Module_Partners] AS
	SELECT PCMP.*, U.ID as UserId
		FROM Ploomes_Cliente_Module_Partners PCMP CROSS JOIN Usuario U
GO
