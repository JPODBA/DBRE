BACKUP DATABASE BA_DBA
TO URL =  N'https://stsqlprdbrs8.blob.core.windows.net/bkfullsqlprds8/BA_DBA.bak'
WITH CHECKSUM, FORMAT, STATS = 1;

RESTORE DATABASE BA_DBA --new database name
FROM 
  URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkfullsqlprds8/BA_DBA.bak'
WITH RECOVERY,
Move 'BA_DBA'	  to 'D:\SQL\DATA\DATA_TESTE\BA_DBA.mdf',
Move 'BA_DBA_log' to 'D:\SQL\DATA\DATA_TESTE\BA_DBA_log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO



--restore filelistonly From URL = N'https://stsqlprdbrs8.blob.core.windows.net/bkfullsqlprds8/BA_DBA.bak'