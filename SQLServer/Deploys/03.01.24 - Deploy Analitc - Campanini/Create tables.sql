use Ploomes_Reports
go 
CREATE TABLE [dbo].[FixedFieldsBlackList](
    [Id] [int] NOT NULL,
    [FieldKey] [nvarchar](100) NOT NULL
CONSTRAINT [PK_FixedFieldsBlackList] PRIMARY KEY CLUSTERED 
(
[Id] ASC
));

CREATE TABLE [dbo].[IntegrationFieldsBlackList](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [IntegrationCustomFieldId] [int] NOT NULL
 CONSTRAINT [PK_IntegrationFieldsBlackList] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
));