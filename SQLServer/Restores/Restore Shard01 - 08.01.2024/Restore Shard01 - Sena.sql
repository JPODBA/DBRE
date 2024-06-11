CREATE CREDENTIAL [https://stsqlprdbr02.blob.core.windows.net/bkdiferencialsqlprd02]  WITH IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-21T04:04:02Z&st=2022-07-20T20:04:02Z&spr=https&sig=mwOfPRDSIyDfaVUUXTwm7Iawq%2FFJ0PPfaGEcnWpD%2Fak%3D'
CREATE CREDENTIAL [https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02]					WITH IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-21T04:04:02Z&st=2022-07-20T20:04:02Z&spr=https&sig=mwOfPRDSIyDfaVUUXTwm7Iawq%2FFJ0PPfaGEcnWpD%2Fak%3D'
CREATE CREDENTIAL [https://stsqlprdbr02.blob.core.windows.net/bkloglsqlprd02]					WITH IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-21T04:04:02Z&st=2022-07-20T20:04:02Z&spr=https&sig=mwOfPRDSIyDfaVUUXTwm7Iawq%2FFJ0PPfaGEcnWpD%2Fak%3D'
GO

RESTORE DATABASE Shard01 --new database name
FROM 
  URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2024_01_07_11:00_part1.bak',
  URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2024_01_07_11:00_part2.bak',
  URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2024_01_07_11:00_part3.bak',
  URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2024_01_07_11:00_part4.bak',
  URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2024_01_07_11:00_part5.bak'
WITH RECOVERY,
Move 'PloomesCRM'		        to 'F:\Shard01\Ploomes_CRM.mdf',
Move 'PloomesCRM_log'       to 'F:\Shard01\Ploomes_CRM_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'F:\Shard01\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'F:\Shard01\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'F:\Shard01\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'F:\Shard01\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO