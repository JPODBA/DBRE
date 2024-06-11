CREATE CREDENTIAL [https://stsqlprdbrs8.blob.core.windows.net/bkfullsqlprds8] 
WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2022-11-02&ss=b&srt=so&sp=rwlacitfx&se=2100-07-21T02:40:37Z&st=2023-07-20T18:40:37Z&spr=https&sig=RGMM%2F6qSR4V4vmEkTCVfIIkFlgo5oooO9teCJs073JY%3D'
CREATE CREDENTIAL [https://stsqlprdbrs8.blob.core.windows.net/bkdiferencialsqlprds8]				 
WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2022-11-02&ss=b&srt=so&sp=rwlacitfx&se=2100-07-21T02:40:37Z&st=2023-07-20T18:40:37Z&spr=https&sig=RGMM%2F6qSR4V4vmEkTCVfIIkFlgo5oooO9teCJs073JY%3D'
GO


RESTORE DATABASE Shard08 --new database name
FROM 
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkfullsqlprds8/Ploomes_CRM_2024_02_25_11:00_part1.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkfullsqlprds8/Ploomes_CRM_2024_02_25_11:00_part2.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkfullsqlprds8/Ploomes_CRM_2024_02_25_11:00_part3.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkfullsqlprds8/Ploomes_CRM_2024_02_25_11:00_part4.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkfullsqlprds8/Ploomes_CRM_2024_02_25_11:00_part5.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkfullsqlprds8/Ploomes_CRM_2024_02_25_11:00_part6.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkfullsqlprds8/Ploomes_CRM_2024_02_25_11:00_part7.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkfullsqlprds8/Ploomes_CRM_2024_02_25_11:00_part8.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		      to 'j:\DATA\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'j:\DATA\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'j:\DATA\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'j:\DATA\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'j:\DATA\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'j:\DATA\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Shard08 --new database name
FROM 
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkdiferencialsqlprds8/Ploomes_CRM_2024_02_29_06:00_part1.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkdiferencialsqlprds8/Ploomes_CRM_2024_02_29_06:00_part2.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkdiferencialsqlprds8/Ploomes_CRM_2024_02_29_06:00_part3.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkdiferencialsqlprds8/Ploomes_CRM_2024_02_29_06:00_part4.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkdiferencialsqlprds8/Ploomes_CRM_2024_02_29_06:00_part5.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkdiferencialsqlprds8/Ploomes_CRM_2024_02_29_06:00_part6.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkdiferencialsqlprds8/Ploomes_CRM_2024_02_29_06:00_part7.bak',
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkdiferencialsqlprds8/Ploomes_CRM_2024_02_29_06:00_part8.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		      to 'j:\DATA\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'j:\DATA\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'j:\DATA\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'j:\DATA\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'j:\DATA\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'j:\DATA\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO



