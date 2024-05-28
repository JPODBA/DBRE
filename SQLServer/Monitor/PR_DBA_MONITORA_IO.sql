USE BA_DBA;  
GO 
IF (OBJECT_ID('PR_DBA_MONITORA_IO')is null)exec ('Create proc PR_DBA_MONITORA_IO as return')
GO
ALTER PROC PR_DBA_MONITORA_IO
	@debug bit = 1
AS
/************************************************************************
 Autor: Equipe DBA\João Paulo Oliveira
 Data de criação: 24/08/2022
 Data de Atualização: 01/02/2023
 Funcionalidade: Faz um levantemento diário dos picos de IO instancia. 
*************************************************************************/
BEGIN
	Set NoCount ON
	
	/*
	we will tell you something along the lines of:

	Excellent: < 1ms
	Very good: < 5ms
	Good: 5 – 10ms
	Poor(É ok): 10 – 20ms
	Bad: 20 – 100ms
	Really bad: 100 – 500ms
	OMG!: > 500ms

	Medimos a latencia aqui. 
	*/

	/*Como a ideia é rodar apenas 2 vezes por dia a principio. */
	DECLARE @TimeExec time = '12:00', 
					@TimeNow Time

	Select @TimeNow = Getdate()

	If (@TimeNow >= '12:25')
	Begin
		Select @TimeExec = '18:30'
	END

	If (@TimeNow >= @TimeExec)
	Begin

		Insert BA_DBA.dbo.DBA_MONITOR_DISK_IO_LATENCIA
		SELECT  
			LEFT(physical_name, 1)																													 AS drive,
			CAST(SUM(io_stall_read_ms) / (1.0 + SUM(num_of_reads)) AS NUMERIC(10,1))				 AS 'avg_read_disk_latency_ms',
			CAST(SUM(io_stall_write_ms)/ (1.0 + SUM(num_of_writes)) AS NUMERIC(10,1))				 AS 'avg_write_disk_latency_ms',
			CAST((SUM(io_stall))/(1.0 + SUM(num_of_reads + num_of_writes)) AS NUMERIC(10,1)) AS 'avg_disk_latency_ms',
			Getdate()																																				 As Data,
			@@SERVERNAME																																	   AS Servername
		FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS divfs
		JOIN sys.master_files													AS mf ON mf.database_id = divfs.database_id AND mf.file_id = divfs.file_id
		GROUP BY LEFT(physical_name, 1)
		ORDER BY avg_disk_latency_ms DESC;

	END -- IF


END -- PROC
GO
--Alter Table BA_DBA.dbo.DBA_MONITOR_DISK_IO_LATENCIA add Data datetime
IF (OBJECT_ID('BA_DBA..DBA_MONITOR_DISK_IO_LATENCIA')IS NULL)BEGIN
Create Table BA_DBA.dbo.DBA_MONITOR_DISK_IO_LATENCIA (
	Drive											Char(2),
	avg_read_disk_latency_ms  Decimal(10,2),
	avg_write_disk_latency_ms Decimal(10,2),
	avg_disk_latency_ms				Decimal(10,2),
	Data											datetime,
	Servername								Varchar(50)
)
END
GO
--exec BA_DBA.dbo.PR_DBA_MONITORA_IO



/*

Select * From BA_DBA.dbo.DBA_MONITOR_DISK_IO_LATENCIA

SELECT 
  OBJECT_NAME(ddius.object_id) AS object_name,
  --CASE WHEN ( SUM(user_updates + user_seeks + user_scans + user_lookups) = 0 ) THEN NULL
  --  ELSE ( CAST(SUM(user_seeks + user_scans + user_lookups) AS DECIMAL)/ CAST(SUM(user_updates + user_seeks + user_scans + user_lookups) AS DECIMAL) )
  --END AS RatioOfReads,
  --CASE WHEN ( SUM(user_updates + user_seeks + user_scans + user_lookups) = 0 ) THEN NULL
  --  ELSE ( CAST(SUM(user_updates) AS DECIMAL) / CAST(SUM(user_updates + user_seeks + user_scans + user_lookups) AS DECIMAL) )
  --END AS RatioOfWrites,
  SUM(user_updates + user_seeks + user_scans + user_lookups) AS TotalReadOperations,
  SUM(user_updates) AS TotalWriteOperations
FROM sys.dm_db_index_usage_stats AS ddius
JOIN sys.indexes AS i ON ddius.object_id = i.object_id AND ddius.index_id = i.index_id
WHERE i.type_desc IN ( 'CLUSTERED', 'HEAP' ) --only works in Current db
GROUP BY ddius.object_id
ORDER BY 2 desc

Select * from DBA_MONITOR_DISK_IO_LATENCIA

Select 
	Drive as Disco, 
	avg(avg_read_disk_latency_ms) as read_disk_latency,
	avg(avg_write_disk_latency_ms) as write_disk_latency,
	avg(avg_disk_latency_ms) as disk_latency
from BA_DBA.dbo.DBA_MONITOR_DISK_IO_LATENCIA
group by Drive


SELECT 
    Drive as Disco, 
    AVG(avg_read_disk_latency_ms) as read_disk_latency,
    AVG(avg_write_disk_latency_ms) as write_disk_latency,
    AVG(avg_disk_latency_ms) as disk_latency, 
    FORMAT(Data, 'yyyy-MM') as Mes
FROM BA_DBA.dbo.DBA_MONITOR_DISK_IO_LATENCIA
WHERE Data >= '2024-01-01'
	and Drive = 'F'
GROUP BY Drive, FORMAT(Data, 'yyyy-MM')

SELECT 
    Drive as Disco, 
    AVG(avg_read_disk_latency_ms) as read_disk_latency,
    AVG(avg_write_disk_latency_ms) as write_disk_latency,
    AVG(avg_disk_latency_ms) as disk_latency, 
    FORMAT(Data, 'yyyy-MM') as Mes
FROM BA_DBA.dbo.DBA_MONITOR_DISK_IO_LATENCIA
WHERE Data >= '2024-01-01'
	and Drive = 'F'
GROUP BY Drive, FORMAT(Data, 'yyyy-MM')



*/