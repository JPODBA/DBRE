RESTORE DATABASE Central --new database name
FROM URL = 'https://stsqlprdbr01.blob.core.windows.net/bkfullsqlprd01/Ploomes_CRM_2023_08_20_11:00.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		   to 'G:\p\Central\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'     to 'G:\p\Central\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO


CREATE CREDENTIAL [https://stsqlprdbr01.blob.core.windows.net/bkdiferencialsqlprd01] WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:29:03Z&st=2022-08-19T17:29:03Z&spr=https&sig=tZuIoxW6rLW9Zytw2%2BJcw91rzpiWYX5l%2BKkJN2d8k4s%3D'
CREATE CREDENTIAL [https://stsqlprdbr01.blob.core.windows.net/bkfullsqlprd01]        WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:29:03Z&st=2022-08-19T17:29:03Z&spr=https&sig=tZuIoxW6rLW9Zytw2%2BJcw91rzpiWYX5l%2BKkJN2d8k4s%3D'
CREATE CREDENTIAL [https://stsqlprdbr01.blob.core.windows.net/bkloglsqlprd01]				 WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:29:03Z&st=2022-08-19T17:29:03Z&spr=https&sig=tZuIoxW6rLW9Zytw2%2BJcw91rzpiWYX5l%2BKkJN2d8k4s%3D'
GO