SELECT TOP 1 [PloomesItemId] FROM [Integrations].[dbo].[Lookup] 
WHERE [Id] > 102511 AND [AccountId] = 2210 AND [RuleId] = 2 AND [SankhyaItemId] = 1 AND [SankhyaItemFk] = 1


SELECT TOP 1 [SankhyaItemId],[SankhyaItemFk] FROM [Integrations].[dbo].[Lookup]
WHERE [Id] > 102511 AND [AccountId] = 2210 AND [RuleId] = 2 AND [PloomesItemId] = 48789


SELECT TOP 1 [PloomesItemId] FROM [Integrations].[dbo].[Lookup] 
WHERE [Id] > 102511 AND [AccountId] = 2210 AND [RuleId] = 1 AND [SankhyaItemId] = 453


sp_helpindex 'Lookup'

CREATE INDEX IX_Lookup_IDM02
ON [Integrations].[dbo].[Lookup]
(
	[Id], [AccountId], [RuleId], [SankhyaItemId], [SankhyaItemFk] 
) include ([PloomesItemId])
GO

--drop index if exists [Lookup].Lookup_IDM
CREATE INDEX IX_Lookup_IDM
ON [Integrations].[dbo].[Lookup]
(SankhyaItemId, EntityId, SankhyaItemFk, IntegrationId) 
GO