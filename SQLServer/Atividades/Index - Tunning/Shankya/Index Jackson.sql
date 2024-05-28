

CREATE INDEX [IX_Lookup_ID01] ON [Integrations].[dbo].[Lookup] ([IntegrationId], [EntityId], SankhyaItemId)
CREATE INDEX [IX_Lookup_ID02] ON [Integrations].[dbo].[Lookup] (PloomesItemId)

CREATE INDEX [IX_Integration_Queue_ID01] ON [Queue].[dbo].[Integration_Queue] (NextRetryDate, [Status], IntegrationId)