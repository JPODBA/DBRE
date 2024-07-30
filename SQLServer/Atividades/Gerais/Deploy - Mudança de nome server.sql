EXEC sp_addserver 'DESKTOP-5TGUFBP\FOCUS_DBA', 'local';
EXEC sp_dropserver 'DESKTOP-5TGUFBP\FOCUSFORGE', 'droplogins';
Select * from Sys.servers
go 
USE master;
GO
EXEC sp_serveroption
    @server = N'DESKTOP-5TGUFBP\FOCUSFORGE_DBA',
    @optname = 'name',
    @optvalue = N'LinkToProdSQL01';
GO

Select @@SERVERNAME