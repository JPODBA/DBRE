CREATE CREDENTIAL [https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7] 
WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2022-11-02&ss=b&srt=so&sp=rwlacitfx&se=2100-07-21T03:35:52Z&st=2023-07-20T19:35:52Z&spr=https&sig=0jD1aeo9ChHxAal0uOO53q656z8GBQQPryRZiohyG%2FY%3D'
CREATE CREDENTIAL [https://stsqlprdbrs7.blob.core.windows.net/bkdiferencialsqlprds7]				 
WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2022-11-02&ss=b&srt=so&sp=rwlacitfx&se=2100-07-21T03:35:52Z&st=2023-07-20T19:35:52Z&spr=https&sig=0jD1aeo9ChHxAal0uOO53q656z8GBQQPryRZiohyG%2FY%3D'
GO

RESTORE DATABASE Shard07 --new database name
FROM 
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2024_02_25_11:00_part1.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2024_02_25_11:00_part2.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2024_02_25_11:00_part3.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2024_02_25_11:00_part4.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2024_02_25_11:00_part5.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2024_02_25_11:00_part6.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2024_02_25_11:00_part7.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2024_02_25_11:00_part8.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM_BKP'		to 'i:\Shard07\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_BKP_log'  to 'i:\Shard07\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'i:\Shard07\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'i:\Shard07\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'i:\Shard07\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'i:\Shard07\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Shard07 --new database name
FROM 
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkdiferencialsqlprds7/Ploomes_CRM_2024_02_29_06:00_diff_part1.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkdiferencialsqlprds7/Ploomes_CRM_2024_02_29_06:00_diff_part2.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkdiferencialsqlprds7/Ploomes_CRM_2024_02_29_06:00_diff_part3.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkdiferencialsqlprds7/Ploomes_CRM_2024_02_29_06:00_diff_part4.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkdiferencialsqlprds7/Ploomes_CRM_2024_02_29_06:00_diff_part5.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkdiferencialsqlprds7/Ploomes_CRM_2024_02_29_06:00_diff_part6.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkdiferencialsqlprds7/Ploomes_CRM_2024_02_29_06:00_diff_part7.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkdiferencialsqlprds7/Ploomes_CRM_2024_02_29_06:00_diff_part8.bak'
WITH RECOVERY,
Move 'Ploomes_CRM_BKP'		to 'i:\Shard07\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_BKP_log'  to 'i:\Shard07\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'i:\Shard07\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'i:\Shard07\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'i:\Shard07\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'i:\Shard07\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO

INSERT INTO [Shard07].[Ploomes_CRM].[dbo].[Ploomes_Cliente_Integration_DynamicMappedField] 
    ([AccountIntegrationId],
    [EntityId],
    [ExternalFieldKey],
    [ExternalFieldName],
    [FieldKey],
    [FieldPathId],
    [MapperId],
    [DynamicMapEntityId]) 
SELECT 
    [AccountIntegrationId],
    [EntityId],
    [ExternalFieldKey],
    [ExternalFieldName],
    [FieldKey],
    [FieldPathId],
    [MapperId],
    [DynamicMapEntityId]
FROM [Shard07].[dbo].[Ploomes_Cliente_Integration_DynamicMappedField]
WHERE [Ploomes_Cliente_Integration_DynamicMappedField].[AccountIntegrationId] IN (10003905, 60000057, 10001464, 10001579)