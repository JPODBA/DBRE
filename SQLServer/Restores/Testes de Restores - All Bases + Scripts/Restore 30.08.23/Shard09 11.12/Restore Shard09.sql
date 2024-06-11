CREATE CREDENTIAL [https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9] 
WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2022-11-02&ss=b&srt=so&sp=rwlacitfx&se=2100-07-26T22:38:20Z&st=2023-07-26T14:38:20Z&spr=https&sig=Oa1u09Ktvu7dyvIOOCEwc776O9FOQSD%2FIWe51xXtXc8%3D'
CREATE CREDENTIAL [https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9]				 
WITH IDENTITY = 'SHARED ACCESS SIGNATURE'   ,SECRET = 'sv=2022-11-02&ss=b&srt=so&sp=rwlacitfx&se=2100-07-26T22:38:20Z&st=2023-07-26T14:38:20Z&spr=https&sig=Oa1u09Ktvu7dyvIOOCEwc776O9FOQSD%2FIWe51xXtXc8%3D'
GO

RESTORE DATABASE Shard09 --new database name
FROM 
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2023_12_31_11:00_part1.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2023_12_31_11:00_part2.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2023_12_31_11:00_part3.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2023_12_31_11:00_part4.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2023_12_31_11:00_part5.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2023_12_31_11:00_part6.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2023_12_31_11:00_part7.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkfullsqlprds9/Ploomes_CRM_2023_12_31_11:00_part8.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		      to 'F:\Shard09\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'F:\Shard09\Ploomes_Log.ldf',
Move 'INDEX_41C92DC0'       to 'F:\Shard09\INDEX_41C92DC0.ndf',
Move 'INDEX_02_6390D417'    to 'F:\Shard09\INDEX_02_6390D417.ndf',
Move 'INDEX_03_58E8110F'    to 'F:\Shard09\INDEX_03_58E8110F.ndf',
Move 'INDEX_04_7426A13'		  to 'F:\Shard09\INDEX_04_7426A13.ndf',
Move 'Ploomes_CRM_INDEX'    to 'F:\Shard09\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'F:\Shard09\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'F:\Shard09\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'F:\Shard09\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO


--SET @DIR = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/'
RESTORE DATABASE Shard09 --new database name
FROM 
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part1.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part2.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part3.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part4.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part5.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part6.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part7.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part8.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part9.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part10.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part11.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part12.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part13.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part14.bak',
  URL = N'https://stsqlprdbrs9.blob.core.windows.net/bkdiferencialsqlprds9/Ploomes_CRM_2023_12_20_06:00_diff_part15.bak'
WITH RECOVERY,
Move 'Ploomes_CRM'		      to 'F:\Shard09\Ploomes_CRM.mdf',
Move 'Ploomes_CRM_log'      to 'F:\Shard09\Ploomes_Log.ldf',
Move 'INDEX_41C92DC0'       to 'F:\Shard09\INDEX_41C92DC0.ndf',
Move 'INDEX_02_6390D417'    to 'F:\Shard09\INDEX_02_6390D417.ndf',
Move 'INDEX_03_58E8110F'    to 'F:\Shard09\INDEX_03_58E8110F.ndf',
Move 'INDEX_04_7426A13'		  to 'F:\Shard09\INDEX_04_7426A13.ndf',
Move 'Ploomes_CRM_INDEX'    to 'F:\Shard09\Ploomes_CRM_INDEX.ndf',
Move 'Ploomes_CRM_INDEX_02' to 'F:\Shard09\Ploomes_CRM_INDEX_02.ndf',
Move 'Ploomes_CRM_INDEX_03' to 'F:\Shard09\Ploomes_CRM_INDEX_03.ndf',
Move 'Ploomes_CRM_INDEX_04' to 'F:\Shard09\Ploomes_CRM_INDEX_04.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO