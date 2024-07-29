--####  Central_22 ############################################################################################################

RESTORE DATABASE Central_22 --new database name
FROM URL = 'https://stsqlprdbr01.blob.core.windows.net/bkfullsqlprd01/Ploomes_CRM_2024_07_21_11:00.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		  to 'J:\Data_22\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'  to 'J:\Data_22\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Central_22 --new database name
FROM URL = 'https://stsqlprdbr01.blob.core.windows.net/bkdiferencialsqlprd01/Ploomes_CRM_2024_07_22_06:00.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		     to 'J:\Data_22\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'     to 'J:\Data_22\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

--####  Central_23 ############################################################################################################
RESTORE DATABASE Central_23 --new database name
FROM URL = 'https://stsqlprdbr01.blob.core.windows.net/bkfullsqlprd01/Ploomes_CRM_2024_07_21_11:00.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		  to 'J:\Data_23\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'  to 'J:\Data_23\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO


RESTORE DATABASE Central_23 --new database name
FROM URL = 'https://stsqlprdbr01.blob.core.windows.net/bkdiferencialsqlprd01/Ploomes_CRM_2024_07_23_06:00.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		     to 'J:\Data_23\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'     to 'J:\Data_23\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

--####  Central_24 ############################################################################################################

RESTORE DATABASE Central_24 --new database name
FROM URL = 'https://stsqlprdbr01.blob.core.windows.net/bkfullsqlprd01/Ploomes_CRM_2024_07_21_11:00.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		  to 'J:\Data_24\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'  to 'J:\Data_24\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Central_24 --new database name
FROM URL = 'https://stsqlprdbr01.blob.core.windows.net/bkdiferencialsqlprd01/Ploomes_CRM_2024_07_24_06:00.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		     to 'J:\Data_24\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'     to 'J:\Data_24\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO