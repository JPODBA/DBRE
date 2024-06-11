/*
SCRIPT DE SUBIDA DA BRANCH fix_web_link_slowness
*/
USE Ploomes_CRM
GO

CREATE TABLE [dbo].[External_Shared_Keys](
	[Id] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	[Key] [varchar](100) NOT NULL,
	[Type] [varchar](100) NOT NULL
 CONSTRAINT [PK_External_Shared_Keys] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_External_Shared_Keys] ON [dbo].[External_Shared_Keys]
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

INSERT INTO Mapping_Table VALUES (20,'External_Shared_Keys','External_Shared_Keys',0,NULL,NULL,0,1,NULL)
GO
INSERT INTO Mapping_Column VALUES (307, 20, 'AccountId', 'AccountId')
GO
INSERT INTO Mapping_Column VALUES (308, 20, 'Key', 'Key')
GO
INSERT INTO Mapping_Column VALUES (309, 20, 'Type', 'Type')
GO