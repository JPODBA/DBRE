CREATE CREDENTIAL [https://stsqlprdbr06.blob.core.windows.net/bkdiferencialsqlprd06]  WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-09-06T22:12:47Z&st=2022-09-06T14:12:47Z&spr=https&sig=LcsOISmfrX4KANskYfXCBV7cZmulGN5JlXjDyuMxo84%3D'
CREATE CREDENTIAL [https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06]         WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-09-06T22:12:47Z&st=2022-09-06T14:12:47Z&spr=https&sig=LcsOISmfrX4KANskYfXCBV7cZmulGN5JlXjDyuMxo84%3D'
CREATE CREDENTIAL [https://stsqlprdbr06.blob.core.windows.net/bklogsqlprd06]          WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-09-06T22:12:47Z&st=2022-09-06T14:12:47Z&spr=https&sig=LcsOISmfrX4KANskYfXCBV7cZmulGN5JlXjDyuMxo84%3D'
GO

RESTORE DATABASE Shard05 --new database name
FROM 
	URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_06_11_11:00_part1.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_06_11_11:00_part2.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_06_11_11:00_part3.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_06_11_11:00_part4.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_06_11_11:00_part5.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_06_11_11:00_part6.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_06_11_11:00_part7.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_06_11_11:00_part8.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		      to 'G:\Shard05\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'G:\Shard05\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'G:\Shard05\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'G:\Shard05\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'G:\Shard05\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'G:\Shard05\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO
