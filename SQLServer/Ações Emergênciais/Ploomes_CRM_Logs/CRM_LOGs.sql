USE Master
GO

/****** Object:  Database [Ploomes_CRM_Logs]    Script Date: 13/12/2023 15:07:16 ******/
CREATE DATABASE EMG
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Ploomes_CRM_Logs_EMG',     FILENAME = N'I:\Data\Ploomes_CRM_Logs_EMG.mdf' , SIZE = 512KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Ploomes_CRM_Logs_EMG_log', FILENAME = N'I:\Log\Ploomes_CRM_Logs_EMG_log.ldf' , SIZE = 512KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO


USE EMG
GO
/****** Object:  User [datadog]    Script Date: 13/12/2023 15:07:00 ******/
CREATE USER [datadog] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [fellipe.sena]    Script Date: 13/12/2023 15:07:00 ******/
CREATE USER [fellipe.sena] FOR LOGIN [fellipe.sena] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [matheus.campanini]    Script Date: 13/12/2023 15:07:00 ******/
CREATE USER [matheus.campanini] FOR LOGIN [matheus.campanini] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [pedro.freidinger]    Script Date: 13/12/2023 15:07:00 ******/
CREATE USER [pedro.freidinger] FOR LOGIN [pedro.freidinger] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ploomes_api2]    Script Date: 13/12/2023 15:07:00 ******/
CREATE USER [ploomes_api2] FOR LOGIN [ploomes_api2] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ploomes_central]    Script Date: 13/12/2023 15:07:00 ******/
CREATE USER [ploomes_central] FOR LOGIN [ploomes_central] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ploomes_dbsync]    Script Date: 13/12/2023 15:07:00 ******/
CREATE USER [ploomes_dbsync] FOR LOGIN [ploomes_dbsync] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ploomes_shooter]    Script Date: 13/12/2023 15:07:00 ******/
CREATE USER [ploomes_shooter] FOR LOGIN [ploomes_shooter] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [vinicius.sampaio]    Script Date: 13/12/2023 15:07:00 ******/
CREATE USER [vinicius.sampaio] FOR LOGIN [vinicius.sampaio] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [fellipe.sena]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [fellipe.sena]
GO
ALTER ROLE [db_datareader] ADD MEMBER [matheus.campanini]
GO
ALTER ROLE [db_datareader] ADD MEMBER [pedro.freidinger]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [pedro.freidinger]
GO
ALTER ROLE [db_owner] ADD MEMBER [ploomes_api2]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ploomes_api2]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ploomes_api2]
GO
ALTER ROLE [db_owner] ADD MEMBER [ploomes_central]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ploomes_central]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ploomes_central]
GO
ALTER ROLE [db_owner] ADD MEMBER [ploomes_dbsync]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ploomes_dbsync]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ploomes_dbsync]
GO
ALTER ROLE [db_owner] ADD MEMBER [ploomes_shooter]
GO
ALTER ROLE [db_datareader] ADD MEMBER [ploomes_shooter]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [ploomes_shooter]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [vinicius.sampaio]
GO
ALTER ROLE [db_datareader] ADD MEMBER [vinicius.sampaio]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [vinicius.sampaio]
GO
/****** Object:  Table [dbo].[API]    Script Date: 13/12/2023 15:07:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[API](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[UserId] [int] NOT NULL,
	[Url] [nvarchar](1000) NOT NULL,
	[Method] [nvarchar](10) NOT NULL,
	[ElapsedMilliseconds] [bigint] NOT NULL,
	[ResponseException] [nvarchar](50) NULL,
	[ResponseInnerException] [nvarchar](1000) NULL,
	[RequestBody] [nvarchar](max) NULL,
 CONSTRAINT [PK_API] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AutomationAttempt]    Script Date: 13/12/2023 15:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutomationAttempt](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AutomationId] [int] NOT NULL,
	[AutomationUserKey] [nvarchar](300) NOT NULL,
	[ItemId] [int] NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Executing] [bit] NOT NULL,
	[CurrentAttempt] [int] NOT NULL,
	[IterationCount] [int] NOT NULL,
	[Periodic] [bit] NOT NULL,
	[AccountId] [int] NULL,
	[ExecutingDate] [datetime] NULL,
 CONSTRAINT [PK_AutomationAttempt] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChangeLogAttempt]    Script Date: 13/12/2023 15:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChangeLogAttempt](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[ItemId] [int] NOT NULL,
	[ActionId] [int] NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[OldObject] [nvarchar](max) NULL,
	[NewObject] [nvarchar](max) NULL,
	[Executing] [bit] NOT NULL,
	[CurrentAttempt] [int] NOT NULL,
	[ExecutingDate] [datetime] NULL,
	[AutomationLogId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChangeReportAttempt]    Script Date: 13/12/2023 15:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChangeReportAttempt](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[ItemId] [int] NOT NULL,
	[ActionId] [int] NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[OldObject] [nvarchar](max) NULL,
	[NewObject] [nvarchar](max) NULL,
	[Executing] [bit] NOT NULL,
	[CurrentAttempt] [int] NOT NULL,
	[ExecutingDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChangeReportAttempt_ERROR]    Script Date: 13/12/2023 15:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChangeReportAttempt_ERROR](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[ItemId] [int] NOT NULL,
	[ActionId] [int] NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[OldObject] [nvarchar](max) NULL,
	[NewObject] [nvarchar](max) NULL,
	[Executing] [bit] NOT NULL,
	[CurrentAttempt] [int] NOT NULL,
	[ExecutingDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerHealthAttempt]    Script Date: 13/12/2023 15:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerHealthAttempt](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[ActionUserId] [int] NOT NULL,
	[ActionId] [int] NOT NULL,
	[ActionName] [nvarchar](50) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Executing] [bit] NOT NULL,
	[CurrentAttempt] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[Entity] [nvarchar](50) NOT NULL,
	[ItemId] [int] NOT NULL,
	[OldObject] [nvarchar](max) NULL,
	[NewObject] [nvarchar](max) NULL,
	[ExecutingDate] [datetime] NULL,
 CONSTRAINT [PK_CustomerHealthAttempt] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Event]    Script Date: 13/12/2023 15:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Event](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[ActionUserId] [int] NOT NULL,
	[ActionId] [int] NOT NULL,
	[ActionName] [nvarchar](50) NOT NULL,
	[ControllerName] [nvarchar](50) NOT NULL,
	[EntityId] [int] NOT NULL,
	[SecondaryEntityId] [int] NULL,
	[OldObject] [nvarchar](max) NULL,
	[NewObject] [nvarchar](max) NULL,
	[IterationCount] [int] NOT NULL,
	[Webhooks] [bit] NULL,
	[SaveChanges] [bit] NULL,
	[NewFullObject] [nvarchar](max) NULL,
	[TableSync] [bit] NULL,
	[DateTime] [datetime] NULL,
	[AutomationLogId] [int] NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Event_ERROR]    Script Date: 13/12/2023 15:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Event_ERROR](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[ActionUserId] [int] NOT NULL,
	[ActionId] [int] NOT NULL,
	[ActionName] [nvarchar](50) NOT NULL,
	[ControllerName] [nvarchar](50) NOT NULL,
	[EntityId] [int] NOT NULL,
	[SecondaryEntityId] [int] NULL,
	[OldObject] [nvarchar](max) NULL,
	[NewObject] [nvarchar](max) NULL,
	[IterationCount] [int] NOT NULL,
	[Webhooks] [bit] NULL,
	[SaveChanges] [bit] NULL,
	[NewFullObject] [nvarchar](max) NULL,
	[TableSync] [bit] NULL,
	[DateTime] [datetime] NULL,
	[AutomationLogId] [int] NULL,
 CONSTRAINT [PK_Event_ERROR] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IdentityProviderAttempt]    Script Date: 13/12/2023 15:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IdentityProviderAttempt](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NOT NULL,
	[ItemId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	[ActionId] [int] NOT NULL,
	[NewObject] [nvarchar](max) NULL,
	[Executing] [bit] NOT NULL,
	[CurrentAttempt] [int] NOT NULL,
	[ExecutingDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShooterLock]    Script Date: 13/12/2023 15:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShooterLock](
	[ShooterTypeId] [int] NOT NULL,
	[ShooterThreadId] [int] NOT NULL,
	[ShooterTotalThreads] [int] NOT NULL,
	[ExecutingDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ShooterLock] PRIMARY KEY CLUSTERED 
(
	[ShooterTypeId] ASC,
	[ShooterThreadId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SocketEvent]    Script Date: 13/12/2023 15:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SocketEvent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Executing] [bit] NOT NULL,
	[AccountId] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[ActionName] [nvarchar](50) NOT NULL,
	[ItemId] [int] NULL,
	[NewVal] [nvarchar](max) NULL,
	[ExecutingDate] [datetime] NULL,
 CONSTRAINT [PK_SocketEvent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TableSyncAttempt]    Script Date: 13/12/2023 15:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableSyncAttempt](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[ItemId] [int] NOT NULL,
	[FilterId] [int] NULL,
	[FilterUrl] [nvarchar](max) NULL,
	[Executing] [bit] NOT NULL,
	[CurrentAttempt] [int] NOT NULL,
	[ExecutingDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WebhookAttempt]    Script Date: 13/12/2023 15:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebhookAttempt](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[ActionUserId] [int] NOT NULL,
	[WebhookId] [int] NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Executing] [bit] NOT NULL,
	[CurrentAttempt] [int] NOT NULL,
	[EntityId] [int] NOT NULL,
	[Entity] [nvarchar](50) NOT NULL,
	[SecondaryEntityId] [int] NULL,
	[ActionId] [int] NOT NULL,
	[Action] [nvarchar](50) NOT NULL,
	[CallbackUrl] [nvarchar](1000) NOT NULL,
	[ValidationKey] [nvarchar](50) NULL,
	[OldObject] [nvarchar](max) NULL,
	[NewObject] [nvarchar](max) NULL,
	[WebhookCreatorId] [int] NULL,
	[ExecutingDate] [datetime] NULL,
 CONSTRAINT [PK_WebhookAttempt] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[API] ADD  CONSTRAINT [DF_Table_1_DataHora]  DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [dbo].[AutomationAttempt] ADD  CONSTRAINT [DF_AutomationAttempt_DateTime]  DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [dbo].[AutomationAttempt] ADD  CONSTRAINT [DF_AutomationAttempt_Executing]  DEFAULT ((0)) FOR [Executing]
GO
ALTER TABLE [dbo].[AutomationAttempt] ADD  CONSTRAINT [DF_AutomationAttempt_CurrentAttempt]  DEFAULT ((1)) FOR [CurrentAttempt]
GO
ALTER TABLE [dbo].[AutomationAttempt] ADD  CONSTRAINT [DF_AutomationAttempt_IterationCount]  DEFAULT ((0)) FOR [IterationCount]
GO
ALTER TABLE [dbo].[AutomationAttempt] ADD  CONSTRAINT [DF_AutomationAttempt_Periodic]  DEFAULT ((0)) FOR [Periodic]
GO
ALTER TABLE [dbo].[ChangeLogAttempt] ADD  CONSTRAINT [DF_ChangeLogAttempt_Executing]  DEFAULT ((0)) FOR [Executing]
GO
ALTER TABLE [dbo].[ChangeLogAttempt] ADD  CONSTRAINT [DF_ChangeLogAttempt_CurrentAttempt]  DEFAULT ((1)) FOR [CurrentAttempt]
GO
ALTER TABLE [dbo].[ChangeReportAttempt] ADD  CONSTRAINT [DF_ChangeReportAttempt_Executing]  DEFAULT ((0)) FOR [Executing]
GO
ALTER TABLE [dbo].[ChangeReportAttempt] ADD  CONSTRAINT [DF_ChangeReportAttempt_CurrentAttempt]  DEFAULT ((1)) FOR [CurrentAttempt]
GO
ALTER TABLE [dbo].[CustomerHealthAttempt] ADD  CONSTRAINT [DF_CustomerHealthAttempt_DateTime]  DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [dbo].[CustomerHealthAttempt] ADD  CONSTRAINT [DF_CustomerHealthAttempt_Executing]  DEFAULT ((0)) FOR [Executing]
GO
ALTER TABLE [dbo].[CustomerHealthAttempt] ADD  CONSTRAINT [DF_CustomerHealthAttempt_CurrentAttempt]  DEFAULT ((1)) FOR [CurrentAttempt]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [DF_Event_IterationCount]  DEFAULT ((0)) FOR [IterationCount]
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [DF_Event_Webhooks]  DEFAULT ((1)) FOR [Webhooks]
GO
ALTER TABLE [dbo].[Event_ERROR] ADD  CONSTRAINT [DF_Event_ERROR_IterationCount]  DEFAULT ((0)) FOR [IterationCount]
GO
ALTER TABLE [dbo].[Event_ERROR] ADD  CONSTRAINT [DF_Event_ERROR_Webhooks]  DEFAULT ((1)) FOR [Webhooks]
GO
ALTER TABLE [dbo].[IdentityProviderAttempt] ADD  CONSTRAINT [DF_IdentityProviderAttempt_Executing]  DEFAULT ((0)) FOR [Executing]
GO
ALTER TABLE [dbo].[IdentityProviderAttempt] ADD  CONSTRAINT [DF_IdentityProviderAttempt_CurrentAttempt]  DEFAULT ((1)) FOR [CurrentAttempt]
GO
ALTER TABLE [dbo].[ShooterLock] ADD  CONSTRAINT [DF_ShooterLock_ExecutingDate]  DEFAULT (getdate()) FOR [ExecutingDate]
GO
ALTER TABLE [dbo].[SocketEvent] ADD  CONSTRAINT [DF_SocketEvent_DateTime]  DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [dbo].[SocketEvent] ADD  CONSTRAINT [DF_SocketEvent_Executing]  DEFAULT ((0)) FOR [Executing]
GO
ALTER TABLE [dbo].[TableSyncAttempt] ADD  CONSTRAINT [DF_TableSyncAttempt_Executing]  DEFAULT ((0)) FOR [Executing]
GO
ALTER TABLE [dbo].[TableSyncAttempt] ADD  CONSTRAINT [DF_TableSyncAttempt_CurrentAttempt]  DEFAULT ((1)) FOR [CurrentAttempt]
GO
ALTER TABLE [dbo].[WebhookAttempt] ADD  CONSTRAINT [DF_WebhookAttempt_DateTime]  DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [dbo].[WebhookAttempt] ADD  CONSTRAINT [DF_WebhookAttempt_Executing]  DEFAULT ((0)) FOR [Executing]
GO
ALTER TABLE [dbo].[WebhookAttempt] ADD  CONSTRAINT [DF_WebhookAttempt_CurrentAttempt]  DEFAULT ((1)) FOR [CurrentAttempt]
GO
