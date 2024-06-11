/* ---- Central ----- */

RESTORE DATABASE Central_20230219 --new database name
FROM URL = 'https://stsqlprdbr01.blob.core.windows.net/bkloglsqlprd01/Reidrated_Ploomes_CRM_2023_02_19_11:00.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		   to 'F:\Data_emg\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'   to 'G:\Log_Emg\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

