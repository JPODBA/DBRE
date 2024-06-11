RESTORE DATABASE Ploomes_CRM --new database name
FROM 
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part1.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part2.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part3.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part4.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part5.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part6.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part7.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part8.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part9.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part10.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part11.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part12.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part13.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part14.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part15.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part16.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part17.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part18.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part19.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2023_08_27_11:00_part20.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		    to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'G:\log\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'F:\data\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'F:\data\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'F:\data\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'F:\data\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO


---
--CREATE CREDENTIAL [https://stsqlprdbr03.blob.core.windows.net/bkdiferencialsqlprd03] WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:33:25Z&st=2022-08-19T17:33:25Z&spr=https&sig=Y%2BxK3Y72KrkZE%2F0PhaDtGlT0iVE6ZFQI6qO7hAZdyoc%3D'
--CREATE CREDENTIAL [https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03]				 WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:33:25Z&st=2022-08-19T17:33:25Z&spr=https&sig=Y%2BxK3Y72KrkZE%2F0PhaDtGlT0iVE6ZFQI6qO7hAZdyoc%3D'
--CREATE CREDENTIAL [https://stsqlprdbr03.blob.core.windows.net/bklogsqlprd03]				 WITH  IDENTITY = 'SHARED ACCESS SIGNATURE'  ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:33:25Z&st=2022-08-19T17:33:25Z&spr=https&sig=Y%2BxK3Y72KrkZE%2F0PhaDtGlT0iVE6ZFQI6qO7hAZdyoc%3D'
--GO