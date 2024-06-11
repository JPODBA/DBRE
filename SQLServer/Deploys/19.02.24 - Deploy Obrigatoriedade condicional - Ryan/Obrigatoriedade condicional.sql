/*
    Script de deploy da branch feat_conditional_requirement
*/
USE Ploomes_CRM
GO

ALTER TABLE Campo ADD [RequiredFieldFormula] [nvarchar](max) COLLATE Latin1_General_CI_AI NULL
GO

ALTER TABLE CampoFixo2_ClientePloomes_Formula ADD [RequiredFieldFormula] [nvarchar](max) COLLATE Latin1_General_CI_AI NULL
GO

ALTER TABLE CampoFixo2_ClientePloomes_Formula_Variavel ADD [IsRequiredFieldVariable] [bit] NULL
GO

ALTER TABLE Campo_Formula_Variavel ADD [IsRequiredFieldVariable] [bit] NULL
GO

CREATE TABLE [dbo].[Campo_Permissao_Required_Team](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[TeamId] [int] NOT NULL,
	[FieldFixed] [bit] NOT NULL,
	[FieldId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Required_Team_AccountId] ON [dbo].[Campo_Permissao_Required_Team]
(
	[AccountId] ASC,
	[FieldId] ASC,
	[FieldFixed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Required_Team_FieldId] ON [dbo].[Campo_Permissao_Required_Team]
(
	[FieldId] ASC,
	[AccountId] ASC,
	[TeamId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Campo_Permissao_Required_User](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[FieldFixed] [bit] NOT NULL,
	[FieldId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Required_User_AccountId] ON [dbo].[Campo_Permissao_Required_User]
(
	[AccountId] ASC,
	[FieldId] ASC,
	[FieldFixed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Required_User_FieldId] ON [dbo].[Campo_Permissao_Required_User]
(
	[FieldId] ASC,
	[AccountId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Campo_Permissao_Required_UserProfile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[ProfileId] [int] NOT NULL,
	[FieldFixed] [bit] NOT NULL,
	[FieldId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Required_UserProfile_AccountId] ON [dbo].[Campo_Permissao_Required_UserProfile]
(
	[AccountId] ASC,
	[FieldId] ASC,
	[FieldFixed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Campo_Permissao_Required_UserProfile_FieldId] ON [dbo].[Campo_Permissao_Required_UserProfile]
(
	[FieldId] ASC,
	[AccountId] ASC,
	[ProfileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO

ALTER TABLE HostSet ADD [FrontendApiUrl] [nvarchar](500) COLLATE Latin1_General_CI_AI NULL
GO

-- Refresh views
DECLARE @sqlcmd NVARCHAR(MAX) = ''
SELECT @sqlcmd = @sqlcmd +  'EXEC sp_refreshview ''' + name + ''';
' 
FROM sys.objects AS so 
WHERE so.type = 'V' 

EXEC(@sqlcmd)