RESTORE DATABASE Ploomes_CRM --new database name
FROM 
  URL = N'https://stsqlprdus01.blob.core.windows.net/bkpfullploomes01/Ploomes_CRM_2024_08_04_11:00_part1.bak',
  URL = N'https://stsqlprdus01.blob.core.windows.net/bkpfullploomes01/Ploomes_CRM_2024_08_04_11:00_part2.bak',
  URL = N'https://stsqlprdus01.blob.core.windows.net/bkpfullploomes01/Ploomes_CRM_2024_08_04_11:00_part3.bak',
  URL = N'https://stsqlprdus01.blob.core.windows.net/bkpfullploomes01/Ploomes_CRM_2024_08_04_11:00_part4.bak',
  URL = N'https://stsqlprdus01.blob.core.windows.net/bkpfullploomes01/Ploomes_CRM_2024_08_04_11:00_part5.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		      to 'F:\DATA\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'F:\DATA\Ploomes_Log.ldf',
Move 'Ploomes_CRM_INDEX'    to 'F:\DATA\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'F:\DATA\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'F:\DATA\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'F:\DATA\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Ploomes_CRM --new database name
FROM 
  URL = N'https://stsqlprdus01.blob.core.windows.net/bkpdifploomes01/Ploomes_CRM_DIFF_2024_08_08_06:00_part1.bak',
  URL = N'https://stsqlprdus01.blob.core.windows.net/bkpdifploomes01/Ploomes_CRM_DIFF_2024_08_08_06:00_part2.bak'
WITH RECOVERY,																																			 
Move 'Ploomes_CRM'		      to 'F:\DATA\Ploomes_CRM.mdf',														 
Move 'Ploomes_CRM_log'      to 'F:\DATA\Ploomes_Log.ldf',														 
Move 'Ploomes_CRM_INDEX'    to 'F:\DATA\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'F:\DATA\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'F:\DATA\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'F:\DATA\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO


CREATE CREDENTIAL [https://stsqlprdus01.blob.core.windows.net/bkpfullploomes01] 
WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2022-11-02&ss=b&srt=so&sp=rwlacitfx&se=2100-11-24T05:33:01Z&st=2023-11-23T21:33:01Z&spr=https&sig=ZI%2FDaM%2FvSoi05%2FV90i6M%2BcaxMhhhrNpW8ckgU2KPHGk%3D'
CREATE CREDENTIAL [https://stsqlprdus01.blob.core.windows.net/bkpdifploomes01]				 
WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2022-11-02&ss=b&srt=so&sp=rwlacitfx&se=2100-11-24T05:33:01Z&st=2023-11-23T21:33:01Z&spr=https&sig=ZI%2FDaM%2FvSoi05%2FV90i6M%2BcaxMhhhrNpW8ckgU2KPHGk%3D'
GO