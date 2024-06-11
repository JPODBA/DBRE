/* ---- Shard06 ----- */


--Select 'DROP CREDENTIAL [' + name +']' from sys.credentials
Select * from sys.credentials

RESTORE DATABASE Ploomes_CRM --new database name
FROM 
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part1.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part2.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part3.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part4.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part5.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part6.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part7.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part8.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part9.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part10.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part11.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part12.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part13.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part14.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part15.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part16.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part17.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part18.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part19.bak',
  URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part20.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		 to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log' to 'G:\log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Ploomes_CRM --new database name
FROM 
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part1.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part2.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part3.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part4.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part5.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part6.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part7.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part8.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part9.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part10.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part11.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part12.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part13.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part14.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part15.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part16.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part17.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part18.bak',
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part19.bak',
  URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_04_30_11:00_diff_part20.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		 to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log' to 'G:\log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO
