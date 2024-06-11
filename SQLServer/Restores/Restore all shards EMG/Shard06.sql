/* ---- Shard06 ----- */

CREATE CREDENTIAL [https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07] 
WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwltfx&se=2090-11-11T02:29:59Z&st=2022-11-10T18:29:59Z&spr=https&sig=WO6n8%2FLO5HuQTJV7FjGvCATbv0XUTSFi37YsARxjemQ%3D'
CREATE CREDENTIAL [https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07]				 
WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwltfx&se=2090-11-11T02:29:59Z&st=2022-11-10T18:29:59Z&spr=https&sig=WO6n8%2FLO5HuQTJV7FjGvCATbv0XUTSFi37YsARxjemQ%3D'
GO

RESTORE DATABASE Shard06 --new database name
FROM 
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part1.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part2.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part3.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part4.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part5.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part6.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part7.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part8.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part9.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part10.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part11.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part12.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part13.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part14.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part15.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part16.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part17.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part18.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part19.bak',
  URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2024_02_25_11:00_part20.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		    to 'I:\Shard06\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'I:\Shard06\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'I:\Shard06\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'I:\Shard06\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'I:\Shard06\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'I:\Shard06\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Shard06 --new database name
FROM 
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part1.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part2.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part3.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part4.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part5.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part6.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part7.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part8.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part9.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part10.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part11.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part12.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part13.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part14.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part15.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part16.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part17.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part18.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part19.bak',
  URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2024_02_29_06:00_diff_part20.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		      to 'I:\Shard06\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'I:\Shard06\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'I:\Shard06\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'I:\Shard06\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'I:\Shard06\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'I:\Shard06\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO

INSERT INTO [Shard06].[Ploomes_CRM].[dbo].[Ploomes_Cliente_Integration_DynamicMappedField] 
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
FROM 
    [Shard06].[dbo].[Ploomes_Cliente_Integration_DynamicMappedField]
WHERE 
    [Ploomes_Cliente_Integration_DynamicMappedField].[AccountIntegrationId] IN (10001945, 10003535)