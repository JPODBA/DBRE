select * from DBA_MONITOR_MISSING_INDEX order by 6 desc
go
CREATE INDEX [Integration_Queue_IDM] ON [Queue].[dbo].[Integration_Queue] ([IntegrationId],[Status]) 
CREATE INDEX [Sankhya_Tipo_Operacao_IDM] ON [Integrations].[dbo].[Sankhya_Tipo_Operacao] ([IntegrationId],[RuleId]) INCLUDE ([CODTIPOPER]) 
CREATE INDEX [Integration_MappingV2_IDM] ON [Integrations].[dbo].[Integration_MappingV2] ([IntegrationId], [GoesToPloomes],[SankhyaFieldKey]) INCLUDE ([RuleId]) 