RESTORE DATABASE Ploomes_CRM_Shard03 --new database name
FROM 
	URL = N'https://stsqlprdwe01.blob.core.windows.net/bkfulllsqlprdwe01/Ploomes_CRM_2023_08_27_11:00.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		      to 'D:\SQL\DATA\Ploomes_CRM_Shard03.mdf',
Move 'Ploomes_CRM_log'	    to 'D:\SQL\DATAloomes_CRM_Shard03_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'D:\SQL\DATA\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'D:\SQL\DATA\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'D:\SQL\DATA\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'D:\SQL\DATA\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO

/*
CREATE CREDENTIAL [https://stsqlprdwe01.blob.core.windows.net/bkdiferencialsqlprdwe01]  WITH IDENTITY = 'SHARED ACCESS SIGNATURE',SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-22T05:29:07Z&st=2022-07-21T21:29:07Z&spr=https&sig=Bj25ufvnc7OgkGhGRMSzBrKs6bR1AJLgF1pVVRbWg%2BA%3D'
CREATE CREDENTIAL [https://stsqlprdwe01.blob.core.windows.net/bkfulllsqlprdwe01]				WITH IDENTITY = 'SHARED ACCESS SIGNATURE',SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-22T05:29:07Z&st=2022-07-21T21:29:07Z&spr=https&sig=Bj25ufvnc7OgkGhGRMSzBrKs6bR1AJLgF1pVVRbWg%2BA%3D'
CREATE CREDENTIAL [https://stsqlprdwe01.blob.core.windows.net/bklogsqlprdwe01]					WITH IDENTITY = 'SHARED ACCESS SIGNATURE',SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2100-07-22T05:29:07Z&st=2022-07-21T21:29:07Z&spr=https&sig=Bj25ufvnc7OgkGhGRMSzBrKs6bR1AJLgF1pVVRbWg%2BA%3D'
GO

select * from sys.credentials
