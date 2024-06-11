USe Master
go

DECLARE @DATA CHAR(16), @DIR VARCHAR(150), @COMANDO VARCHAR(120), @COMANDO2 VARCHAR(120)
SET @DATA = FORMAT(GETDATE(), 'yyyy_MM_dd_hh:mm')
SET @DIR = N'https://stsqlprdbr07.blob.core.windows.net/bkdiferencialsqlprd07/'
SET @COMANDO =  @DIR+'Ploomes_CRM_EMER_part1.bak'
SET @COMANDO2 = @DIR+'Ploomes_CRM_EMER_part2.bak'

BACKUP DATABASE Ploomes_CRM
TO 
 URL =  @COMANDO,
 URL =  @COMANDO2
 WITH MAXTRANSFERSIZE = 4194304, BLOCKSIZE = 65536, CHECKSUM, FORMAT, STATS = 5;
go

USE [Ploomes_CRM]
GO
CREATE NONCLUSTERED INDEX IX_Oportunidade_ID_Suspenso
ON [dbo].[Oportunidade] ([Suspenso],[ID_Funil])
INCLUDE ([ID_ClientePloomes],[ID_Cliente])
GO

