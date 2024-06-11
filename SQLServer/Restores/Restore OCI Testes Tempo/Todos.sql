RESTORE DATABASE Ploomes_CRM --new database name
FROM 
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2024_05_12_11:00_part1.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2024_05_12_11:00_part2.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2024_05_12_11:00_part3.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2024_05_12_11:00_part4.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2024_05_12_11:00_part5.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2024_05_12_11:00_part6.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2024_05_12_11:00_part7.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2024_05_12_11:00_part8.bak'
WITH NORECOVERY,
Move 'Ploomes_CRM'		      to 'D:\MSSQLSERVER\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'G:\MSSQLSERVER\Log\Ploomes_Log.ldf',
Move 'INDEX_41C92DC0'       to 'D:\MSSQLSERVER\INDEX_41C92DC0.ndf',
Move 'INDEX_02_6390D417'    to 'D:\MSSQLSERVER\INDEX_02_6390D417.ndf',
Move 'INDEX_03_58E8110F'    to 'D:\MSSQLSERVER\INDEX_03_58E8110F.ndf',
Move 'INDEX_04_7426A13'		  to 'D:\MSSQLSERVER\INDEX_04_7426A13.ndf',
Move 'Ploomes_CRM_INDEX'    to 'D:\MSSQLSERVER\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'D:\MSSQLSERVER\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'D:\MSSQLSERVER\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'D:\MSSQLSERVER\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Ploomes_CRM --new database name
FROM 
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part1.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part2.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part3.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part4.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part5.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part6.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part7.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part8.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part9.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part10.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part11.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part12.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part13.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part14.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2024_05_16_08:00_diff_part15.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		      to 'D:\MSSQLSERVER\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'G:\MSSQLSERVER\Log\Ploomes_Log.ldf',
Move 'INDEX_41C92DC0'       to 'D:\MSSQLSERVER\INDEX_41C92DC0.ndf',
Move 'INDEX_02_6390D417'    to 'D:\MSSQLSERVER\INDEX_02_6390D417.ndf',
Move 'INDEX_03_58E8110F'    to 'D:\MSSQLSERVER\INDEX_03_58E8110F.ndf',
Move 'INDEX_04_7426A13'		  to 'D:\MSSQLSERVER\INDEX_04_7426A13.ndf',
Move 'Ploomes_CRM_INDEX'    to 'D:\MSSQLSERVER\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'D:\MSSQLSERVER\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'D:\MSSQLSERVER\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'D:\MSSQLSERVER\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Ploomes_CRM_Logs --new database name
FROM 
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_Logs_OCI_TESTE.bak'
WITH RECOVERY,
Move 'Ploomes_CRM_Logs'		  to 'G:\MSSQLSERVER\Data\Ploomes_CRM_Logs.mdf',
Move 'Ploomes_CRM_Logs_log' to 'G:\MSSQLSERVER\Log\Ploomes_CRM_Logs_log.ldf',
--Move 'XTP'									to 'G:\MSSQLSERVER\Log\Ploomes_CRM_Logs_log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO