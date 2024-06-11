EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'Integrations'
GO
use [master];
GO
USE [master]
GO
ALTER DATABASE [Integrations] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
/****** Object:  Database [Temp]    Script Date: 24/05/2024 16:15:14 ******/
DROP DATABASE [Integrations]
GO

EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'Temp'
GO
use [master];
GO
USE [master]
GO
ALTER DATABASE Temp SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
/****** Object:  Database [Temp]    Script Date: 24/05/2024 16:15:14 ******/
DROP DATABASE Temp
GO


EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'Queue'
GO
use [master];
GO
USE [master]
GO
ALTER DATABASE Queue SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
/****** Object:  Database [Temp]    Script Date: 24/05/2024 16:15:14 ******/
DROP DATABASE Queue
GO


EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'logs'
GO
use [master];
GO
USE [master]
GO
ALTER DATABASE logs SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
/****** Object:  Database [Temp]    Script Date: 24/05/2024 16:15:14 ******/
DROP DATABASE logs
GO