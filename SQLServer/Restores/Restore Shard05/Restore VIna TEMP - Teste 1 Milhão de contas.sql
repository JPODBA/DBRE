use BA_DBA
GO
--kill 198  
--sp_Who2
--sp_helpdb 'Ploomes_CRM'
--RESTORE FILELISTONLY FROM DISK = 'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_05_07_11:00_part1.bak' 
RESTORE DATABASE Ploomes_CRM --new database name
FROM 
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_07_09_11:00_part1.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_07_09_11:00_part2.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_07_09_11:00_part3.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_07_09_11:00_part4.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_07_09_11:00_part5.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_07_09_11:00_part6.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_07_09_11:00_part7.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2023_07_09_11:00_part8.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		    to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'G:\log\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'F:\data\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'F:\data\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'F:\data\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'F:\data\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO



RESTORE DATABASE Ploomes_CRM --new database name
FROM 
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkdiferencialsqlprd06/Ploomes_CRM_2023_07_14_06:00_diff_part1.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkdiferencialsqlprd06/Ploomes_CRM_2023_07_14_06:00_diff_part2.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkdiferencialsqlprd06/Ploomes_CRM_2023_07_14_06:00_diff_part3.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkdiferencialsqlprd06/Ploomes_CRM_2023_07_14_06:00_diff_part4.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkdiferencialsqlprd06/Ploomes_CRM_2023_07_14_06:00_diff_part5.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkdiferencialsqlprd06/Ploomes_CRM_2023_07_14_06:00_diff_part6.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkdiferencialsqlprd06/Ploomes_CRM_2023_07_14_06:00_diff_part7.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		    to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'G:\log\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'F:\data\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'F:\data\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'F:\data\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'F:\data\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO
