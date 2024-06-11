DECLARE @DATA CHAR(16), 
				@DIR VARCHAR(150), 
				@COMANDO VARCHAR(120),
				@COMANDO2 VARCHAR(120)


SET @DATA = FORMAT(GETDATE(), 'yyyy_MM_dd_hh:mm')
SET @DIR = N'https://stsqlprdbr08.blob.core.windows.net/bkfullsqlprd08/'
SET @COMANDO  = @DIR+'Integrations_HMLG.bak'

BACKUP DATABASE Integrations
TO URL =  @COMANDO 
	 WITH CHECKSUM, FORMAT, STATS = 5;


SET @DATA = FORMAT(GETDATE(), 'yyyy_MM_dd_hh:mm')
SET @DIR = N'https://stsqlprdbr08.blob.core.windows.net/bkfullsqlprd08/'
SET @COMANDO  = @DIR+'Logs_HMLG.bak'

BACKUP DATABASE Logs
TO URL =  @COMANDO 
	 WITH CHECKSUM, FORMAT, STATS = 5;


SET @DATA = FORMAT(GETDATE(), 'yyyy_MM_dd_hh:mm')
SET @DIR = N'https://stsqlprdbr08.blob.core.windows.net/bkfullsqlprd08/'
SET @COMANDO  = @DIR+'Temp_HMLG.bak'

BACKUP DATABASE Temp
TO URL =  @COMANDO 
	 WITH CHECKSUM, FORMAT, STATS = 5;



SET @DATA = FORMAT(GETDATE(), 'yyyy_MM_dd_hh:mm')
SET @DIR = N'https://stsqlprdbr08.blob.core.windows.net/bkfullsqlprd08/'
SET @COMANDO  = @DIR+'Queue_Part1_HMLG.bak'
SET @COMANDO2 = @DIR+'Queue_Part2_HMLG.bak'


BACKUP DATABASE Queue
TO URL =  @COMANDO, URL = @COMANDO2 
	 WITH CHECKSUM, FORMAT, STATS = 5;
GO