/* ---- Shard04 ----- */

RESTORE DATABASE Ploomes_CRM --new database name
FROM 
	URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part1.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part2.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part3.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part4.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part5.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part6.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part7.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part8.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part9.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part10.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part11.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part12.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part13.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part14.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2023_08_13_11:00_part15.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		      to 'D:\Data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'D:\Data\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'D:\Data\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'D:\Data\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'D:\Data\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'D:\Data\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO

select * from Sys.credentials

CREATE CREDENTIAL [https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05]  WITH  IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:35:44Z&st=2022-08-19T17:35:44Z&spr=https&sig=%2FT%2FcQwZBnrlJVCoSoUUAEzcIurM7OQjFG6NRB1Y860s%3D'
CREATE CREDENTIAL [https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05]				WITH  IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:35:44Z&st=2022-08-19T17:35:44Z&spr=https&sig=%2FT%2FcQwZBnrlJVCoSoUUAEzcIurM7OQjFG6NRB1Y860s%3D'
CREATE CREDENTIAL [https://stsqlprdbr05.blob.core.windows.net/bklogsqlprd05]					WITH  IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:35:44Z&st=2022-08-19T17:35:44Z&spr=https&sig=%2FT%2FcQwZBnrlJVCoSoUUAEzcIurM7OQjFG6NRB1Y860s%3D'
GO