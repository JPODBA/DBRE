RESTORE DATABASE Ploomes --new database name
FROM 
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2024_01_02_01:16_part1.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2024_01_02_01:16_part2.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2024_01_02_01:16_part3.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2024_01_02_01:16_part4.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2024_01_02_01:16_part5.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2024_01_02_01:16_part6.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2024_01_02_01:16_part7.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2024_01_02_01:16_part8.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2024_01_02_01:16_part9.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2024_01_02_01:16_part10.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2024_01_02_01:16_part11.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2024_01_02_01:16_part12.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		      to 'F:\Shard05\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'F:\Shard05\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'F:\Shard05\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'F:\Shard05\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'F:\Shard05\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'F:\Shard05\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO


--- Shard05 ------ .34

CREATE CREDENTIAL [https://stsqlprdbr06.blob.core.windows.net/bkdiferencialsqlprd06]  WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-09-06T22:12:47Z&st=2022-09-06T14:12:47Z&spr=https&sig=LcsOISmfrX4KANskYfXCBV7cZmulGN5JlXjDyuMxo84%3D'
CREATE CREDENTIAL [https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06]         WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-09-06T22:12:47Z&st=2022-09-06T14:12:47Z&spr=https&sig=LcsOISmfrX4KANskYfXCBV7cZmulGN5JlXjDyuMxo84%3D'
CREATE CREDENTIAL [https://stsqlprdbr06.blob.core.windows.net/bklogsqlprd06]          WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-09-06T22:12:47Z&st=2022-09-06T14:12:47Z&spr=https&sig=LcsOISmfrX4KANskYfXCBV7cZmulGN5JlXjDyuMxo84%3D'
GO