EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'max server memory', 120000; -- Padrão de Shard Ploo, não instância.
RECONFIGURE;
GO

SELECT SERVERPROPERTY('Collation');
GO 

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'cost threshold for parallelism', 50;
RECONFIGURE;
GO 

sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO  
sp_configure 'Ole Automation Procedures', 1;  
GO  
RECONFIGURE;  
GO 

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'optimize for ad hoc workloads', 1;
RECONFIGURE;



GO