---- PRD004 -- 71 

CREATE CREDENTIAL [https://stsqlprdbr04.blob.core.windows.net/bkdiferencialsqlprd04]  WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2022-11-02&ss=b&srt=so&sp=rwlacitfx&se=2100-01-29T23:34:34Z&st=2024-01-29T15:34:34Z&spr=https&sig=7d5ZsNTHLUulFDCbt4CoX3tVsMuZiL80mNEzHc2yf2k%3D'
CREATE CREDENTIAL [https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04]					WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2022-11-02&ss=b&srt=so&sp=rwlacitfx&se=2100-01-29T23:34:34Z&st=2024-01-29T15:34:34Z&spr=https&sig=7d5ZsNTHLUulFDCbt4CoX3tVsMuZiL80mNEzHc2yf2k%3D'
CREATE CREDENTIAL [https://stsqlprdbr04.blob.core.windows.net/bklogsqlprd04]					WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2022-11-02&ss=b&srt=so&sp=rwlacitfx&se=2100-01-29T23:34:34Z&st=2024-01-29T15:34:34Z&spr=https&sig=7d5ZsNTHLUulFDCbt4CoX3tVsMuZiL80mNEzHc2yf2k%3D'
GO


Select  'DROP CREDENTIAL ' + name from sys.credentials where credential_id in (65536,65537,65538)
Select  'DROP CREDENTIAL [' + name+']' from sys.credentials where credential_id in (65536,65537,65538)

DROP CREDENTIAL [https://stsqlprdbr04.blob.core.windows.net/bkdiferencialsqlprd04]
DROP CREDENTIAL [https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04]
DROP CREDENTIAL [https://stsqlprdbr04.blob.core.windows.net/bklogsqlprd04]


RESTORE DATABASE Ploomes_IdentityProvider --new database name
FROM 
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2024_01_14_11:00_part01.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2024_01_14_11:00_part02.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2024_01_14_11:00_part03.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2024_01_14_11:00_part04.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2024_01_14_11:00_part05.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2024_01_14_11:00_part06.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2024_01_14_11:00_part07.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkfullsqlprd04/Ploomes_IdentityProvider_2024_01_14_11:00_part08.bak'
WITH NORECOVERY,
Move 'Ploomes_IdentityProvider'				to 'F:\IDP\Ploomes_IdentityProvider.mdf',
Move 'Ploomes_IdentityProvider_log'   to 'F:\IDP\Ploomes_IdentityProvider_log.ldf',
Move 'Ploomes_IdentityProvider_INDEX' to 'F:\IDP\Ploomes_IdentityProvider_INDEX.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO


RESTORE DATABASE Ploomes_IdentityProvider --new database name
FROM 
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkdiferencialsqlprd04/_2024_01_18_20:00_part01.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkdiferencialsqlprd04/_2024_01_18_20:00_part02.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkdiferencialsqlprd04/_2024_01_18_20:00_part03.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkdiferencialsqlprd04/_2024_01_18_20:00_part04.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkdiferencialsqlprd04/_2024_01_18_20:00_part05.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkdiferencialsqlprd04/_2024_01_18_20:00_part06.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkdiferencialsqlprd04/_2024_01_18_20:00_part07.bak',
	URL = N'https://stsqlprdbr04.blob.core.windows.net/bkdiferencialsqlprd04/_2024_01_18_20:00_part08.bak'
WITH RECOVERY,
Move 'Ploomes_IdentityProvider'				to 'F:\IDP\Ploomes_IdentityProvider.mdf',
Move 'Ploomes_IdentityProvider_log'   to 'F:\IDP\Ploomes_IdentityProvider_log.ldf',
Move 'Ploomes_IdentityProvider_INDEX' to 'F:\IDP\Ploomes_IdentityProvider_INDEX.ndf',
NOUNLOAD, REPLACE, STATS = 1
GO