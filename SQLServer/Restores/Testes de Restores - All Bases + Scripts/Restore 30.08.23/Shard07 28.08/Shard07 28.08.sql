RESTORE DATABASE Ploomes_CRM --new database name
FROM 
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2023_12_10_11:00_part1.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2023_12_10_11:00_part2.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2023_12_10_11:00_part3.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2023_12_10_11:00_part4.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2023_12_10_11:00_part5.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2023_12_10_11:00_part6.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2023_12_10_11:00_part7.bak',
  URL = N'https://stsqlprdbrs7.blob.core.windows.net/bkfullsqlprds7/Ploomes_CRM_2023_12_10_11:00_part8.bak'
WITH RECOVERY,
Move 'Ploomes_CRM_BKP'		  to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_BKP_log'  to 'G:\data\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'F:\data\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'F:\data\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'F:\data\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'F:\data\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO



