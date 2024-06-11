
/* ---- Central ----- */

RESTORE DATABASE Ploomes_CRM --new database name
FROM URL = 'https://stsqlprdbr01.blob.core.windows.net/bkfullsqlprd01/Ploomes_CRM_2022_12_18_11:00.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		 to 'F:\Teste_Data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log' to 'G:\Teste_Log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Ploomes_CRM --new database name
FROM URL = 'https://stsqlprdbr01.blob.core.windows.net/bkdiferencialsqlprd01/Ploomes_CRM_2022_12_23_06:00.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		 to 'F:\Teste_Data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log' to 'G:\Teste_Log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

/* ---- Shard01 ----- */	 
RESTORE DATABASE Ploomes_CRM_Shard01 --new database name
FROM 
	URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2022_10_26_05:29_part1.bak',
  URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2022_10_26_05:29_part2.bak',
  URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2022_10_26_05:29_part3.bak',
  URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2022_10_26_05:29_part4.bak',
  URL = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM_2022_10_26_05:29_part5.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		 to 'F:\Teste_Data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log' to 'G:\Teste_Log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

DECLARE @DATA CHAR(16), @DIR VARCHAR(150), @COMANDO VARCHAR(120), @COMANDO2 VARCHAR(120), @COMANDO3 VARCHAR(120), @COMANDO4 VARCHAR(120), @COMANDO5 VARCHAR(120)
SET @DATA = FORMAT(GETDATE(), 'yyyy_MM_dd_hh:mm')
SET @DIR = N'https://stsqlprdbr02.blob.core.windows.net/bkfullsqlprd02/Ploomes_CRM'
SET @COMANDO = @DIR+'_' + @DATA+'_part1.bak'
SET @COMANDO2 = @DIR+'_' + @DATA+'_part2.bak'
SET @COMANDO3 = @DIR+'_' + @DATA+'_part3.bak'
SET @COMANDO4 = @DIR+'_' + @DATA+'_part4.bak'
SET @COMANDO5 = @DIR+'_' + @DATA+'_part5.bak'

select @COMANDO 
select @COMANDO2
select @COMANDO3
select @COMANDO4
select @COMANDO5



/* ---- Shard02 ----- */

RESTORE DATABASE Ploomes_CRM --new database name
FROM 
	URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_12_18_11:00_part1.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_12_18_11:00_part2.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_12_18_11:00_part3.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_12_18_11:00_part4.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_12_18_11:00_part5.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_12_18_11:00_part6.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_12_18_11:00_part7.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/Ploomes_CRM_2022_12_18_11:00_part8.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		 to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log' to 'G:\log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Ploomes_CRM --new database name
FROM 
	URL = N'https://stsqlprdbr03.blob.core.windows.net/bkdiferencialsqlprd03/Ploomes_CRM_2022_12_23_06:00_diff_part1.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkdiferencialsqlprd03/Ploomes_CRM_2022_12_23_06:00_diff_part2.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkdiferencialsqlprd03/Ploomes_CRM_2022_12_23_06:00_diff_part3.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkdiferencialsqlprd03/Ploomes_CRM_2022_12_23_06:00_diff_part4.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkdiferencialsqlprd03/Ploomes_CRM_2022_12_23_06:00_diff_part5.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkdiferencialsqlprd03/Ploomes_CRM_2022_12_23_06:00_diff_part6.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkdiferencialsqlprd03/Ploomes_CRM_2022_12_23_06:00_diff_part7.bak',
  URL = N'https://stsqlprdbr03.blob.core.windows.net/bkdiferencialsqlprd03/Ploomes_CRM_2022_12_23_06:00_diff_part8.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		 to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log' to 'G:\log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

DECLARE @DATA CHAR(16), 
				@DIR VARCHAR(150), 
				@COMANDO VARCHAR(120), 
				@COMANDO2 VARCHAR(120),
				@COMANDO3 VARCHAR(120),
				@COMANDO4 VARCHAR(120),
				@COMANDO5 VARCHAR(120),
				@COMANDO6 VARCHAR(120),
				@COMANDO7 VARCHAR(120),
				@COMANDO8 VARCHAR(120)

SET @DATA = FORMAT(GETDATE(), 'yyyy_MM_dd_hh:mm')
SET @DIR = N'https://stsqlprdbr03.blob.core.windows.net/bkfullsqlprd03/'
SET @COMANDO  = @DIR+'Ploomes_CRM_' + @DATA+'_part1.bak'
SET @COMANDO2 = @DIR+'Ploomes_CRM_' + @DATA+'_part2.bak'
SET @COMANDO3 = @DIR+'Ploomes_CRM_' + @DATA+'_part3.bak'
SET @COMANDO4 = @DIR+'Ploomes_CRM_' + @DATA+'_part4.bak'
SET @COMANDO5 = @DIR+'Ploomes_CRM_' + @DATA+'_part5.bak'
SET @COMANDO6 = @DIR+'Ploomes_CRM_' + @DATA+'_part6.bak'
SET @COMANDO7 = @DIR+'Ploomes_CRM_' + @DATA+'_part7.bak'
SET @COMANDO8 = @DIR+'Ploomes_CRM_' + @DATA+'_part8.bak'

declare @Tbl as table (campo varchar(max))

insert @Tbl
Select @COMANDO 	
insert @Tbl
select @COMANDO2	
insert @Tbl
select @COMANDO3	
insert @Tbl
select @COMANDO4	
insert @Tbl
select @COMANDO5	
insert @Tbl
select @COMANDO6	
insert @Tbl
select @COMANDO7	
insert @Tbl
select @COMANDO8	

Select * from @Tbl


/* ---- Shard03 ----- */

RESTORE DATABASE Ploomes_CRM_Shard03 --new database name
FROM 
	URL = N'https://stsqlprdwe01.blob.core.windows.net/bkfulllsqlprdwe01/Ploomes_CRM_2022_10_26_05:34.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		 to 'F:\Teste_Data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log' to 'G:\Teste_Log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO


DECLARE @DATA CHAR(16), @DIR VARCHAR(150), @COMANDO VARCHAR(120)
SET @DATA = FORMAT(GETDATE(), 'yyyy_MM_dd_hh:mm')
SET @DIR = N'https://stsqlprdwe01.blob.core.windows.net/bkfulllsqlprdwe01/Ploomes_CRM'
SET @COMANDO = @DIR+'_' + @DATA+'.bak'

select @COMANDO



/* ---- Shard04 ----- */

RESTORE DATABASE Ploomes_CRM_Shard04 --new database name
FROM 
	URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2022_10_26_05:39_part1.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2022_10_26_05:39_part2.bak',
  URL = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/Ploomes_CRM_2022_10_26_05:39_part3.bakk'
WITH RECOVERY,
Move 'Ploomes_CRM'		 to 'F:\Teste_Data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log' to 'G:\Teste_Log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO



DECLARE @DATA CHAR(16), 
				@DIR VARCHAR(150), 
				@COMANDO VARCHAR(120), 
				@COMANDO2 VARCHAR(120), 
				@COMANDO3 VARCHAR(120)

SET @DATA = FORMAT(GETDATE(), 'yyyy_MM_dd_hh:mm')
SET @DIR = N'https://stsqlprdbr05.blob.core.windows.net/bkfulllsqlprd05/'
SET @COMANDO  = @DIR+'Ploomes_CRM_' + @DATA+'_part1.bak'
SET @COMANDO2 = @DIR+'Ploomes_CRM_' + @DATA+'_part2.bak'
SET @COMANDO3 = @DIR+'Ploomes_CRM_' + @DATA+'_part3.bak'

select @COMANDO  
select @COMANDO2
select @COMANDO3


/* ---- Shard05 ----- */

RESTORE DATABASE Ploomes_CRM_Shard05 --new database name
FROM 
	URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part1.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part2.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part3.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part4.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part5.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part6.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part7.bak',
  URL = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/Ploomes_CRM_2022_10_26_05:41_part8.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		 to 'F:\Teste_Data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log' to 'G:\Teste_Log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO


DECLARE @DATA CHAR(16), 
				@DIR VARCHAR(150), 
				@COMANDO VARCHAR(120), 
				@COMANDO2 VARCHAR(120),
				@COMANDO3 VARCHAR(120),
				@COMANDO4 VARCHAR(120),
				@COMANDO5 VARCHAR(120),
				@COMANDO6 VARCHAR(120),
				@COMANDO7 VARCHAR(120),
				@COMANDO8 VARCHAR(120)

SET @DATA = FORMAT(GETDATE(), 'yyyy_MM_dd_hh:mm')
SET @DIR = N'https://stsqlprdbr06.blob.core.windows.net/bkfullsqlprd06/'
SET @COMANDO  = @DIR+'Ploomes_CRM_' + @DATA+'_part1.bak'
SET @COMANDO2 = @DIR+'Ploomes_CRM_' + @DATA+'_part2.bak'
SET @COMANDO3 = @DIR+'Ploomes_CRM_' + @DATA+'_part3.bak'
SET @COMANDO4 = @DIR+'Ploomes_CRM_' + @DATA+'_part4.bak'
SET @COMANDO5 = @DIR+'Ploomes_CRM_' + @DATA+'_part5.bak'
SET @COMANDO6 = @DIR+'Ploomes_CRM_' + @DATA+'_part6.bak'
SET @COMANDO7 = @DIR+'Ploomes_CRM_' + @DATA+'_part7.bak'
SET @COMANDO8 = @DIR+'Ploomes_CRM_' + @DATA+'_part8.bak'

Select @COMANDO


/* ---- Shard06 ----- */

--Select 'DROP CREDENTIAL [' + name +']' from sys.credentials
--Select * from sys.credentials

RESTORE DATABASE Ploomes_CRM --new database name
FROM 
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_01_22_11:00_part1.bak',
  URL = N'https://stsqlprdbr07.blob.core.windows.net/bkfullsqlprd07/Ploomes_CRM_2023_01_22_11:00_part2.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		 to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log' to 'G:\log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Ploomes_CRM --new database name
FROM 
	URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_01_24_06:00_part1.bak',
  URL = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/Ploomes_CRM_2023_01_24_06:00_part2.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		 to 'F:\data\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log' to 'G:\log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO


/* ---- Integrações ----- */

RESTORE DATABASE Ploomes_Callback_INT --new database name
FROM 
	URL = N'https://stsqlintprdbr01.blob.core.windows.net/bkfullsqlintprdbr01/Ploomes_Callback_2022_10_26_05:43.bak'
WITH RECOVERY,
Move 'Ploomes_Callback'		  to 'F:\Teste_Data\Ploomes_CRM.mdf',
Move 'Ploomes_Callback_log' to 'G:\Teste_Log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO


/* ---- ModuloAnalitics ----- */

RESTORE DATABASE Ploomes_Reports_Analitics --new database name
FROM 
	URL = N'https://stsqlanalyprd01.blob.core.windows.net/bkfullsqlanaly01/Ploomes_Reports_2022_10_26_05:46.bak'
WITH RECOVERY,
Move 'Ploomes_Reports'		  to 'F:\Teste_Data\Ploomes_CRM.mdf',
Move 'Ploomes_Reports_log'  to 'G:\Teste_Log\Ploomes_Log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

DECLARE @DATA CHAR(16), @DIR VARCHAR(150), @COMANDO VARCHAR(120)
SET @DATA = FORMAT(GETDATE(), 'yyyy_MM_dd_hh:mm')
SET @DIR = N'https://stsqlanalyprd01.blob.core.windows.net/bkfullsqlanaly01/Ploomes_Reports'
SET @COMANDO = @DIR+'_' + @DATA+'.bak'

select @COMANDO

sp_helpdb 'Ploomes_Reports'
