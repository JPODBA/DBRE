CREATE CREDENTIAL [https://BlobDBA.blob.core.windows.net/bkpfull]				 
WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'Your_Key'
GO

/*It's an example of a Differential restore coming from the Blob, but if you change it to disk, it works the same way. */

RESTORE DATABASE BA_DBA 
FROM 
	URL = N'https://BlobDBA.blob.core.windows.net/bkpfull/BA_DBA_full_part1.bak',
	URL = N'https://BlobDBA.blob.core.windows.net/bkpfull/BA_DBA_full_part2.bak'
WITH NORECOVERY,
Move 'BA_DBA'		  to 'I:\Data\BA_DBA.mdf',
Move 'BA_DBA_log' to 'I:\Data\BA_DBA_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO


RESTORE DATABASE BA_DBA 
FROM 
	URL = N'https://BlobDBA.blob.core.windows.net/bkpfull/BA_DBA_diff_part1.bak',
	URL = N'https://BlobDBA.blob.core.windows.net/bkpfull/BA_DBA_diff_part2.bak'
WITH RECOVERY,
Move 'BA_DBA'		  to 'I:\Data\BA_DBA.mdf',
Move 'BA_DBA_log' to 'I:\Data\BA_DBA_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO
