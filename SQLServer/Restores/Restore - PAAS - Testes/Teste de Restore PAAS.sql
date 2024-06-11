CREATE CREDENTIAL [https://stsqlprdbr01.blob.core.windows.net/bkdiferencialsqlprd01] WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:29:03Z&st=2022-08-19T17:29:03Z&spr=https&sig=tZuIoxW6rLW9Zytw2%2BJcw91rzpiWYX5l%2BKkJN2d8k4s%3D'
CREATE CREDENTIAL [https://stsqlprdbr01.blob.core.windows.net/bkfullsqlprd01]        WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:29:03Z&st=2022-08-19T17:29:03Z&spr=https&sig=tZuIoxW6rLW9Zytw2%2BJcw91rzpiWYX5l%2BKkJN2d8k4s%3D'
CREATE CREDENTIAL [https://stsqlprdbr01.blob.core.windows.net/bkloglsqlprd01]				 WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-08-20T01:29:03Z&st=2022-08-19T17:29:03Z&spr=https&sig=tZuIoxW6rLW9Zytw2%2BJcw91rzpiWYX5l%2BKkJN2d8k4s%3D'
GO

-- Restore Direto do BLOB
RESTORE DATABASE Shard_11 --new database name
FROM 
  URL = N'https://stsqlprdus01.blob.core.windows.net/bkpfullploomes01/Ploomes_CRM_2023_12_17_11:00_part1.bak',
  URL = N'https://stsqlprdus01.blob.core.windows.net/bkpfullploomes01/Ploomes_CRM_2023_12_17_11:00_part2.bak',
  URL = N'https://stsqlprdus01.blob.core.windows.net/bkpfullploomes01/Ploomes_CRM_2023_12_17_11:00_part3.bak',
  URL = N'https://stsqlprdus01.blob.core.windows.net/bkpfullploomes01/Ploomes_CRM_2023_12_17_11:00_part4.bak',
  URL = N'https://stsqlprdus01.blob.core.windows.net/bkpfullploomes01/Ploomes_CRM_2023_12_17_11:00_part5.bak'



--https://learn.microsoft.com/en-us/sql/relational-databases/tutorial-sql-server-backup-and-restore-to-azure-blob-storage-service?view=sql-server-ver15&tabs=tsql#back-up-database
USE Ploomes_CRM;
GO
ALTER DATABASE Ploomes_CRM SET ENCRYPTION OFF;
GO
DROP DATABASE ENCRYPTION KEY
GO
USE [master]
GO
BACKUP DATABASE Ploomes_CRM 
TO  URL = N'https://stsqlprdbr01.blob.core.windows.net/bkfullsqlprd01/Ploomes_CRM_000001.bak' 
WITH  COPY_ONLY, CHECKSUM
GO



RESTORE FILELISTONLY FROM URL =  'https://stsqlprdbr01.blob.core.windows.net/bkfullsqlprd01/Ploomes_CRM_000001.bak'


RESTORE DATABASE Ploomes_CRM_TESTE_JOGADOR --new database name
FROM URL = 'https://stsqlprdbr01.blob.core.windows.net/bkfullsqlprd01/Ploomes_CRM_000001.bak'
WITH RECOVERY,
Move 'data_0'  to 'C:\SQL_PAAS\Ploomes_CRM.mdf',
Move 'log'     to 'C:\SQL_PAAS\Ploomes_Log.ldf',
Move 'XTP'     to 'C:\SQL_PAAS\XTP\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1

GO

EXEC master.dbo.sp_addlinkedserver   @server = N'DESVPASS', @srvproduct=N'', @provider=N'SQLOLEDB', @datasrc=N'sqlploomesdev01.public.7e5f223dac1b.database.windows.net,3342';
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'DESVPASS', @useself=N'False', @locallogin=NULL, @rmtuser=N'dba', @rmtpassword='Mtbr1241';
GO
select * from DESVPASS.master.sys.databases order by 1
