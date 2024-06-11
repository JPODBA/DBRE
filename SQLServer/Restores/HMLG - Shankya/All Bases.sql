RESTORE DATABASE Integrations --new database name
FROM 
	URL = N'https://stsqlprdbr08.blob.core.windows.net/bkfullsqlprd08/Integrations_2024_05_05_08:00.bak'
WITH RECOVERY,
Move 'Integrations'		    to 'F:\DATA\Integrations.mdf',
Move 'Integrations_log'	  to 'F:\DATA\Integrations_log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE logs --new database name
FROM 
	URL = N'https://stsqlprdbr08.blob.core.windows.net/bkfullsqlprd08/Logs_2024_05_05_08:00.bak'
WITH RECOVERY,
Move 'logs'		    to 'F:\DATA\logs.mdf',
Move 'logs_log'	  to 'F:\DATA\logs_log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Queue --new database name
FROM 
	URL = N'https://stsqlprdbr08.blob.core.windows.net/bkfullsqlprd08/Queue_2024_05_05_08:00_Part1.bak',
	URL = N'https://stsqlprdbr08.blob.core.windows.net/bkfullsqlprd08/Queue_2024_05_05_08:00_Part2.bak'
WITH RECOVERY,
Move 'Queue'		    to 'F:\DATA\Queue.mdf',
Move 'Queue_log'	  to 'F:\DATA\Queue_log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

RESTORE DATABASE Temp --new database name
FROM 
	URL = N'https://stsqlprdbr08.blob.core.windows.net/bkfullsqlprd08/Temp_2024_05_05_08:00.bak'
WITH RECOVERY,
Move 'Temp'		    to 'D:\SQL\DATA\Temp.mdf',
Move 'Temp_log'	  to 'D:\SQL\DATA\Temp_log.ldf',
NOUNLOAD, REPLACE, STATS = 1
GO

/*

CREATE CREDENTIAL [https://stsqlprdbr08.blob.core.windows.net/bkdiferencialsqlprd08]  WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2090-02-28T02:00:29Z&st=2023-02-27T18:00:29Z&spr=https&sig=WLp8w44O%2Fte6f36VC0bimrWz2CMQgKZgslzD%2FiYhcmo%3D'
CREATE CREDENTIAL [https://stsqlprdbr08.blob.core.windows.net/bkfullsqlprd08]					WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = 'sv=2021-06-08&ss=b&srt=so&sp=rwlacitfx&se=2090-02-28T02:00:29Z&st=2023-02-27T18:00:29Z&spr=https&sig=WLp8w44O%2Fte6f36VC0bimrWz2CMQgKZgslzD%2FiYhcmo%3D'
