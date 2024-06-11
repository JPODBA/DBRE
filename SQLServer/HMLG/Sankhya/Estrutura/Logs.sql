USE [Logs]
GO
/****** Object:  User [jackson.matsuura]    Script Date: 24/05/2024 16:10:36 ******/
CREATE USER [jackson.matsuura] FOR LOGIN [jackson.matsuura] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [tiago.rodrigues]    Script Date: 24/05/2024 16:10:36 ******/
CREATE USER [tiago.rodrigues] FOR LOGIN [tiago.rodrigues] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [jackson.matsuura]
GO
ALTER ROLE [db_datareader] ADD MEMBER [jackson.matsuura]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [jackson.matsuura]
GO
ALTER ROLE [db_datareader] ADD MEMBER [tiago.rodrigues]
GO
/****** Object:  Table [dbo].[Exporter_Logs]    Script Date: 24/05/2024 16:10:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exporter_Logs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IntegrationQueueId] [int] NOT NULL,
	[Body] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Exporter_Logs] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Importer_Logs]    Script Date: 24/05/2024 16:10:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Importer_Logs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IntegrationQueueId] [int] NOT NULL,
	[Body] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[Importer_Logs] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[System_Logs]    Script Date: 24/05/2024 16:10:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[System_Logs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IntegraionId] [int] NULL,
	[DateTime] [datetime] NULL,
	[LogType] [int] NULL,
	[Message] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SankhyaTransactionId] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RequestJson] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResponseJson] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FriendlyErrorMessage] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ApiId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER AUTHORIZATION ON [dbo].[System_Logs] TO  SCHEMA OWNER 
GO
ALTER TABLE [dbo].[System_Logs] ADD  DEFAULT (getdate()) FOR [DateTime]
GO
/****** Object:  StoredProcedure [dbo].[sp_Delete_Logs]    Script Date: 24/05/2024 16:10:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Tiago Rodrigues Silva>
-- Create date: <2023-01-23>
-- Description:	<Procedure para apagar logs mais antigos do que 6 meses>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Delete_Logs]
AS
BEGIN
	DELETE FROM [Logs].[dbo].[Exporter_Logs] where [IntegrationQueueId] in (SELECT Id FROM [Queue].[dbo].[Integration_Queue] WHERE [CreateDate] < dateadd(month, -6, getdate()));
	DELETE FROM [Logs].[dbo].[Importer_Logs] where [IntegrationQueueId] in (SELECT Id FROM [Queue].[dbo].[Integration_Queue] WHERE [CreateDate] < dateadd(month, -6, getdate()));
	DELETE FROM [Logs].[dbo].[System_Logs] WHERE [DateTime] < dateadd(month, -6, getdate());
END
GO
ALTER AUTHORIZATION ON [dbo].[sp_Delete_Logs] TO  SCHEMA OWNER 
GO
