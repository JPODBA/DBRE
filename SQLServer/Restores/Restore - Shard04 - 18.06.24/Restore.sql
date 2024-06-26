CREATE CREDENTIAL [https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05]  WITH  IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:35:44Z&st=2022-08-19T17:35:44Z&spr=https&sig=%2FT%2FcQwZBnrlJVCoSoUUAEzcIurM7OQjFG6NRB1Y860s%3D'
CREATE CREDENTIAL [https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05]				WITH  IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:35:44Z&st=2022-08-19T17:35:44Z&spr=https&sig=%2FT%2FcQwZBnrlJVCoSoUUAEzcIurM7OQjFG6NRB1Y860s%3D'
CREATE CREDENTIAL [https://stsqlprdbr05.blob.core.windows.net/bklogsqlprd05]					WITH  IDENTITY = 'SHARED ACCESS SIGNATURE' ,SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:35:44Z&st=2022-08-19T17:35:44Z&spr=https&sig=%2FT%2FcQwZBnrlJVCoSoUUAEzcIurM7OQjFG6NRB1Y860s%3D'
GO

RESTORE DATABASE EMG --new database name
FROM 
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part1.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part2.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part3.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part4.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part5.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part6.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part7.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part8.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part9.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part10.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part11.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part12.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part13.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part14.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2024_06_16_11:00_part15.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		      to 'E:\Data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'E:\Data\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'E:\Data\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'E:\Data\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'E:\Data\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'E:\Data\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE EMG --new database name
FROM 
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part1.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part2.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part3.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part4.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part5.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part6.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part7.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part8.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part9.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part10.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part11.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part12.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part13.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkdiferencialsqlprd05/Ploomes_CRM_2024_06_17_08:00_Diff_part14.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		      to 'E:\Data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'E:\Data\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'E:\Data\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'E:\Data\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'E:\Data\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'E:\Data\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO