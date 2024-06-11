
sp_helpdb 'Ploomes_CRM'
--/* ---- Central ----- */

--RESTORE DATABASE Ploomes_CRM_Test --new database name
--FROM URL = 'https://stsqlprdbr01.blob.core.windows.net/bkfullsqlprd01/Ploomes_CRM_2022_11_06_11:00.bak'
--WITH RECOVERY,
--Move 'Ploomes_CRM'		   to '/var/opt/mssql/data/Ploomes_CRM.mdf',
--Move 'Ploomes_CRM_log'   to '/var/opt/mssql/data/Ploomes_CRM_LOG.ldf',
--NOUNLOAD, REPLACE, STATS = 1
--GO

CREATE CREDENTIAL [https://stsqlprdbr03.blob.core.windows.net/bkdiferencialsqlprd03] WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:33:25Z&st=2022-08-19T17:33:25Z&spr=https&sig=Y%2BxK3Y72KrkZE%2F0PhaDtGlT0iVE6ZFQI6qO7hAZdyoc%3D'
CREATE CREDENTIAL [https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03]				 WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:33:25Z&st=2022-08-19T17:33:25Z&spr=https&sig=Y%2BxK3Y72KrkZE%2F0PhaDtGlT0iVE6ZFQI6qO7hAZdyoc%3D'
CREATE CREDENTIAL [https://stsqlprdbr03.blob.core.windows.net/bklogsqlprd03]				 WITH  IDENTITY = 'SHARED ACCESS SIGNATURE'  ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:33:25Z&st=2022-08-19T17:33:25Z&spr=https&sig=Y%2BxK3Y72KrkZE%2F0PhaDtGlT0iVE6ZFQI6qO7hAZdyoc%3D'
GO

RESTORE DATABASE Ploomes_CRM_DBA --new database name
FROM 
	URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_11_06_11:00_part1.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_11_06_11:00_part2.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_11_06_11:00_part3.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_11_06_11:00_part4.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_11_06_11:00_part5.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_11_06_11:00_part6.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_11_06_11:00_part7.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_11_06_11:00_part8.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		   to '/var/opt/mssql/data/Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'   to '/var/opt/mssql/data/Ploomes_CRM_LOG.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO