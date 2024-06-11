
RESTORE DATABASE Ploomes_Callback --new database name
FROM 
	URL = N'https://stsqlintprdbr01.blob.core.windows.net/bkfullsqlintprdbr01/Ploomes_Callback_2023_09_01_11:24.bak'
WITH RECOVERY,
Move 'Ploomes_Callback'		  to 'F:\data\Ploomes_Callback.mdf',
Move 'Ploomes_Callback_log' to 'G:\log\Ploomes_Callback_log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO
