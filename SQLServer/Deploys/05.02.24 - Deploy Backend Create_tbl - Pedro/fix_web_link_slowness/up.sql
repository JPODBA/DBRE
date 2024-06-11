/*
SCRIPT DE SUBIDA DA BRANCH fix_web_link_slowness 
*/
USE Ploomes_CRM
GO

CREATE TABLE [dbo].[External_Shared_Keys](
	[Id] [int] IDENTITY(1,1) NOT NULL,
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
) ON [PRIMARY]
GO

select * from [dbo].[External_Shared_Keys]