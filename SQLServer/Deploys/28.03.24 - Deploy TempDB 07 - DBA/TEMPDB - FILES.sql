-- Para DataFiles crescerem na mesma proporção. 
DBCC TRACEON (1117,-1)
DBCC TRACEON (1118,-1)
DBCC TRACESTATUS (-1) 
GO
sp_helpdb 'tempdb'
Go 
USE [master];
GO
Alter database [tempdb] modify file (NAME = tempdev, SIZE=8Gb, FILEGROWTH=128MB,  filename = 'H:\Data\tempdb.ndf');
Alter database [tempdb] modify file (NAME = templog, SIZE=8Gb, FILEGROWTH=128MB,  filename = 'H:\Log\templog.ldf');
Alter database [tempdb] modify file (NAME = temp2,   SIZE=8Gb, FILEGROWTH=128MB,  filename = 'H:\Data\tempdb_mssql_2.ndf');
Alter database [tempdb] modify file (NAME = temp3,   SIZE=8Gb, FILEGROWTH=128MB,  filename = 'H:\Data\tempdb_mssql_3.ndf');
Alter database [tempdb] modify file (NAME = temp4,   SIZE=8Gb, FILEGROWTH=128MB,  filename = 'H:\Data\tempdb_mssql_4.ndf');