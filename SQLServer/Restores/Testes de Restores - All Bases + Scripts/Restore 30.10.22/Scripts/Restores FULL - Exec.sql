/*
Para o restore não dar Tocos, é necessário alterar a Data dos links para a do ultimo Restore. 

*/



/* ---- Central ----- */

RESTORE DATABASE Ploomes_CRM_Central --new database name
FROM URL = 'https://stsqlprdbr01.blob.core.windows.net/bkfullsqlprd01/Ploomes_CRM_2022_10_23_11:00.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		 to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'   to 'G:\log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO



/* ---- Shard01 ----- */	 
RESTORE DATABASE Ploomes_CRM_Shard01 --new database name
FROM 
	URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2022_10_26_05:29_part1.bak',
  URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2022_10_26_05:29_part2.bak',
  URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2022_10_26_05:29_part3.bak',
  URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2022_10_26_05:29_part4.bak',
  URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2022_10_26_05:29_part5.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		   to 'F:\data\Ploomes_CRM_Shard01.mdf',
Move 'Ploomes_CRM_log'   to 'G:\log\Ploomes_CRM_Shard01_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO




/* ---- Shard02 ----- */
RESTORE DATABASE Ploomes_CRM_Shard02 --new database name
FROM 
	URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_10_26_05:25_part1.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_10_26_05:25_part2.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_10_26_05:25_part3.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_10_26_05:25_part4.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_10_26_05:25_part5.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_10_26_05:25_part6.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_10_26_05:25_part7.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_10_26_05:25_part8.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		 to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'   to 'G:\log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO



/* ---- Shard03 ----- */

RESTORE DATABASE Ploomes_CRM_Shard03 --new database name
FROM 
	URL = N'https://stsqlprdwe01.blob.core.windows.net/bkfulllsqlprdwe01/Ploomes_CRM_2022_10_23_11:00.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		   to 'F:\data\Ploomes_CRM_Shard03.mdf',
Move 'Ploomes_CRM_log'	 to 'G:\log\Ploomes_CRM_Shard03_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO


/* ---- Shard04 ----- */

RESTORE DATABASE Ploomes_CRM_Shard04 --new database name
FROM 
	URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2022_10_26_05:39_part1.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2022_10_26_05:39_part2.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2022_10_26_05:39_part3.bakk'
WITH RECOVERY,
Move 'Ploomes_CRM'		 to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'   to 'G:\log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO


/* ---- Shard05 ----- */

RESTORE DATABASE Ploomes_CRM_Shard05 --new database name
FROM 
	URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part1.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part2.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part3.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part4.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part5.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part6.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part7.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part8.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		 to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'   to 'G:\log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO


/* ---- Integrações ----- */

RESTORE DATABASE Ploomes_Callback_INT --new database name
FROM 
	URL = N'https://stsqlintprdbr01.blob.core.windows.net/bkfullsqlintprdbr01/Ploomes_Callback_2022_10_26_05:43.bak'
WITH RECOVERY,
Move 'Ploomes_Callback'		  to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_Callback_log'   to 'G:\log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO


/* ---- ModuloAnalitics ----- */

RESTORE DATABASE Ploomes_Reports_Analitics --new database name
FROM 
	URL = N'https://stsqlanalyprd01.blob.core.windows.net/bkfullsqlanaly01/Ploomes_Reports_2022_10_26_05:46.bak'
WITH RECOVERY,
Move 'Ploomes_Reports'		  to 'F:\data\Ploomes_Reports.mdf',
Move 'Ploomes_Reports_log'    to 'G:\log\Ploomes_Reports_log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO


--sp_helpdb 'Ploomes_Reports_Analitics'


--- IDENTITY PROVIDER
RESTORE DATABASE EMG --new database name
FROM 
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2023_10_26_07:35_part01.bak',
  URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2023_10_26_07:35_part02.bak',
  URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2023_10_26_07:35_part03.bak',
  URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2023_10_26_07:35_part04.bak',
  URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2023_10_26_07:35_part05.bak',
  URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2023_10_26_07:35_part06.bak',
  URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2023_10_26_07:35_part07.bak',
  URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2023_10_26_07:35_part08.bak'
WITH RECOVERY,
Move 'Ploomes_IdentityProvider'		     to 'j:\data\Ploomes_IdentityProvider.mdf',
Move 'Ploomes_IdentityProvider_log'    to 'j:\data\Ploomes_IdentityProvider_log.ldf',
Move 'Ploomes_IdentityProvider_INDEX'  to 'j:\data\Ploomes_IdentityProvider_INDEX.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO
