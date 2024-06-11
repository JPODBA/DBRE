/* ---- Shard06 ----- */


--Select 'DROP CREDENTIAL [' + name +']' from sys.credentials
Select * from sys.credentials

RESTORE DATABASE EMG --new database name
FROM 
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part1.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part2.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part3.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part4.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part5.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part6.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part7.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part8.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part9.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part10.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part11.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part12.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part13.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part14.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part15.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part16.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part17.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part18.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part19.bak',
  URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_05_21_11:00_part20.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		      to 'D:\Data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'D:\Data\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'D:\Data\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'D:\Data\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'D:\Data\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'D:\Data\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO


RESTORE DATABASE EMG --new database name
FROM 
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part1.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part2.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part3.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part4.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part5.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part6.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part7.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part8.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part9.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part10.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part11.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part12.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part13.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part14.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part15.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part16.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part17.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part18.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part19.bak',
  URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_05_26_06:00_diff_part20.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		      to 'D:\Data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'D:\Data\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'D:\Data\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'D:\Data\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'D:\Data\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'D:\Data\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO
