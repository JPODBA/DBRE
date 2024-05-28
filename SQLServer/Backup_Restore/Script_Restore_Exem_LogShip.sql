--RESTORE FILELISTONLY FROM disk = 'C:\Restore\BA_DBA.bak'
--go

RESTORE DATABASE BA_DBA
FROM DISK = 'C:\Restore\BA_DBA.bak'
WITH
	MOVE 'BA_DBA_data'	TO 'D:\Data\BA_DBA_data.MDF',
	MOVE 'BA_DBA_log'		TO 'D:\Data\BA_DBA_log.LDF',
replace, 
NORECOVERY, 
stats = 1
GO
/* It can be 1 or N files. It will depend on the restore point - The database must be in bulk logged mode*/
RESTORE LOG BA_DBA FROM DISK = 'C:\Restore\Restore_LOG\BA_DBALog_0237hs.TLG' WITH NORECOVERY;
go 
RESTORE LOG BA_DBA FROM DISK = 'C:\Restore\Restore_LOG\BA_DBALog_0300hs.TLG' WITH NORECOVERY;
go 
RESTORE LOG BA_DBA FROM DISK = 'C:\Restore\Restore_LOG\BA_DBALog_0330hs.TLG' WITH NORECOVERY;
go
RESTORE LOG BA_DBA FROM DISK = 'C:\Restore\Restore_LOG\BA_DBALog_0400hs.TLG' WITH NORECOVERY;
go
RESTORE LOG BA_DBA FROM DISK = 'C:\Restore\Restore_LOG\BA_DBALog_0430hs.TLG' WITH NORECOVERY;
GO
RESTORE LOG BA_DBA FROM DISK = 'C:\Restore\Restore_LOG\BA_DBALog_0500hs.TLG' WITH NORECOVERY;
GO
RESTORE LOG BA_DBA FROM DISK = 'C:\Restore\Restore_LOG\BA_DBALog_0530hs.TLG' WITH NORECOVERY;
GO
RESTORE LOG BA_DBA FROM DISK = 'C:\Restore\Restore_LOG\BA_DBALog_0600hs.TLG' WITH RECOVERY;
GO
-- Teste of sucess
Select top 1 * from BA_DBA..Teste (nolock) order by 1 desc