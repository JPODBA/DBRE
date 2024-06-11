RESTORE DATABASE Ploomes_Reports_Analitics --new database name
FROM 
	URL = N'https://stsqlanalyprd01.blob.core.windows.net/bkfullsqlanaly01/Ploomes_Reports_2023_08_27_11:00.bak'
WITH RECOVERY,
Move 'Ploomes_Reports'		    to 'D:\SQL\Ploomes_Reports.mdf',
Move 'Ploomes_Reports_log'    to 'D:\SQL\Ploomes_Reports_log.ldf',
Move 'Ploomes_CRM_INDEX'      to 'D:\SQL\Ploomes_CRM_INDEX.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO


/*
CREATE CREDENTIAL [https://stsqlanalyprd01.blob.core.windows.net/bkfullsqlanaly01]				 WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-20T22:57:31Z&st=2022-07-20T14:57:31Z&spr=https&sig=w%2BWeQrCCoEagBo4goHkqgX04Eko1lFSqADUbKqcuF4k%3D'
CREATE CREDENTIAL [https://stsqlanalyprd01.blob.core.windows.net/bkdiferencialsqlanaly01]  WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-20T22:57:31Z&st=2022-07-20T14:57:31Z&spr=https&sig=w%2BWeQrCCoEagBo4goHkqgX04Eko1lFSqADUbKqcuF4k%3D'
CREATE CREDENTIAL [https://stsqlanalyprd01.blob.core.windows.net/bkloglsqlanaly01]				 WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-20T22:57:31Z&st=2022-07-20T14:57:31Z&spr=https&sig=w%2BWeQrCCoEagBo4goHkqgX04Eko1lFSqADUbKqcuF4k%3D'
GO