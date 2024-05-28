-- Simple
BACKUP DATABASE BA_DBA TO DISK = 'D:\SQL\BKP\BA_DBA.BAK' WITH INIT, STATS = 1
GO


/*Fragmenting and dividing Backup for very large Databases. */
DECLARE @DATA CHAR(16), 
				@DIR VARCHAR(500), 
				@COMANDO  VARCHAR(200), 
				@COMANDO2 VARCHAR(200)

--este
SET @DATA = FORMAT(GETDATE(), 'yyyy_MM_dd_hh:mm')
SET @DIR = N'https://BlobDBA.blob.core.windows.net/bkpfull/'
SET @COMANDO  = @DIR+'BA_DBA' + @DATA+'_part1.bak'
SET @COMANDO2 = @DIR+'BA_DBA' + @DATA+'_part2.bak'


BACKUP DATABASE Ploomes_CRM
TO URL =  @COMANDO,
 URL =  @COMANDO2
 WITH MAXTRANSFERSIZE = 4194304, BLOCKSIZE = 65536, CHECKSUM, FORMAT, STATS = 5;
go


/*Fragmenting and dividing Backup for very large Databases. Differencial */

DECLARE @DATA CHAR(16), 
				@DIR VARCHAR(500), 
				@COMANDO  VARCHAR(200), 
				@COMANDO2 VARCHAR(200)


SET @DATA = FORMAT(GETDATE(), 'yyyy_MM_dd_hh:mm')
SET @DIR = N'https://BlobDBA.blob.core.windows.net/bkpDiff/'
SET @COMANDO  = @DIR+'BA_DBA' + @DATA+'_diff_part1.bak'
SET @COMANDO2 = @DIR+'BA_DBA' + @DATA+'_diff_part2.bak'


BACKUP DATABASE Ploomes_CRM
TO URL =  @COMANDO,
 URL =  @COMANDO2
 WITH  DIFFERENTIAL, -- Diff
 MAXTRANSFERSIZE=4194304, BLOCKSIZE=65536, 
 CHECKSUM, FORMAT, STATS = 1;
go