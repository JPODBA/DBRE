ALTER TABLE [Integrations].[dbo].[Lookup] ALTER COLUMN [SankhyaItemId] BIGINT;
ALTER TABLE [Integrations].[dbo].[Lookup] ALTER COLUMN [SankhyaItemFk] BIGINT;
ALTER TABLE [Integrations].[dbo].[Integration] ALTER COLUMN [LastImportedId] BIGINT;
ALTER TABLE [Integrations].[dbo].[Integration] ALTER COLUMN [LastSubItemId] BIGINT;
ALTER TABLE [Integrations].[dbo].[Sankhya_Tipo_Operacao] ALTER COLUMN [CODTIPOPER] BIGINT;

ALTER TABLE [Queue].[dbo].[Integration_Queue] ALTER COLUMN [ItemId] BIGINT;
ALTER TABLE [Queue].[dbo].[Integration_Queue] ALTER COLUMN [PairedItemId] BIGINT;

ALTER TABLE [Temp].[dbo].[Sankhya_Grupo_Produto] ALTER COLUMN [CODGRUPOPROD] BIGINT;
ALTER TABLE [Temp].[dbo].[Sankhya_Grupo_Produto] ALTER COLUMN [CODGRUPAI] BIGINT;

DROP INDEX IF EXISTS [IX_Lookup_IDM02] ON [Integrations].[dbo].[Lookup];  
DROP INDEX IF EXISTS [IX_Lookup_ID01]  ON [Integrations].[dbo].[Lookup];  
DROP INDEX IF EXISTS [IX_Lookup_ID02]  ON [Integrations].[dbo].[Lookup];  
DROP INDEX IF EXISTS [IX_Lookup_IDM01] ON [Integrations].[dbo].[Lookup];  
DROP INDEX IF EXISTS [IX_Lookup_IDM]   ON [Integrations].[dbo].[Lookup];  

CREATE NONCLUSTERED INDEX [IX_Lookup_IDM02] ON [dbo].[Lookup] ([Id] ASC, [AccountId] ASC, [RuleId] ASC, [SankhyaItemId] ASC, [SankhyaItemFk] ASC)  INCLUDE (PloomesItemId) WITH (FILLFACTOR = 100) ;  
CREATE NONCLUSTERED INDEX [IX_Lookup_ID01] ON [dbo].[Lookup] ([IntegrationId] ASC, [EntityId] ASC, [SankhyaItemId] ASC) WITH (FILLFACTOR = 100);  
CREATE NONCLUSTERED INDEX [IX_Lookup_ID02] ON [dbo].[Lookup] ([PloomesItemId] ASC) WITH (FILLFACTOR = 100) ;  
CREATE NONCLUSTERED INDEX [IX_Lookup_IDM01] ON [dbo].[Lookup] ([SankhyaItemId] ASC, [SankhyaItemFk] ASC, [RuleId] ASC, [AccountId] ASC, [Id] ASC) WITH (FILLFACTOR = 100) ;  
CREATE NONCLUSTERED INDEX [IX_Lookup_IDM] ON [dbo].[Lookup] ([SankhyaItemId] ASC, [EntityId] ASC, [SankhyaItemFk] ASC, [IntegrationId] ASC) WITH (FILLFACTOR = 100);  

sp_helpINDEX 'Lookup'
sp_help 'Sankhya_Grupo_Produto'