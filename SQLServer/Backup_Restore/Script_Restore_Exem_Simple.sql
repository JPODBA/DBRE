--Exec SyncroSpark.dbo.PR_UPDATE_SUB_METAS @contaId = 1, @Sub_Meta = 'Estudo 2 Horas por dia Tech Skills', @Done = 0;
--restore filelistonly From disk = 'D:\SQL\BKP\AdventureWorks2022.BAK'
RESTORE DATABASE AdventureWorks2022 FROM DISK = 'D:\SQL\BKP\AdventureWorks2022.BAK' 
WITH RECOVERY,
Move 'AdventureWorks2022'		  to 'D:\SQL\DATA\AdventureWorks2022.mdf',
Move 'AdventureWorks2022_log' to 'D:\SQL\DATA\AdventureWorks2022_log.ldf',
NOUNLOAD, REPLACE, STATS = 1