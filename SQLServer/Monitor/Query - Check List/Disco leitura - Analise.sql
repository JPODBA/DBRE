-- Média Geral
Select 
	Drive as Disco, 
	avg(avg_read_disk_latency_ms) as read_disk_latency,
	avg(avg_write_disk_latency_ms) as write_disk_latency,
	avg(avg_disk_latency_ms) as disk_latency
from BA_DBA.dbo.DBA_MONITOR_DISK_IO_LATENCIA
group by Drive


-- Média por Mês
SELECT 
    Drive as Disco, 
    AVG(avg_read_disk_latency_ms) as read_disk_latency,
    AVG(avg_write_disk_latency_ms) as write_disk_latency,
    AVG(avg_disk_latency_ms) as disk_latency, 
    FORMAT(Data, 'yyyy-MM') as Mes
FROM BA_DBA.dbo.DBA_MONITOR_DISK_IO_LATENCIA
WHERE Data >= '2024-03-01'
	and Drive = 'F'
GROUP BY Drive, FORMAT(Data, 'yyyy-MM')

-- Média por Dia (Abril)
SELECT 
    Drive as Disco, 
    AVG(avg_read_disk_latency_ms) as read_disk_latency,
    AVG(avg_write_disk_latency_ms) as write_disk_latency,
    AVG(avg_disk_latency_ms) as disk_latency
    --FORMAT(Data, 'yyyy-MM-dd') as Mes
FROM BA_DBA.dbo.DBA_MONITOR_DISK_IO_LATENCIA
WHERE Data <= '2024-04-09 12:00'
	and data >= 
 	and Drive = 'F'
GROUP BY Drive

SELECT 
    Drive as Disco, 
    AVG(avg_read_disk_latency_ms) as read_disk_latency,
    AVG(avg_write_disk_latency_ms) as write_disk_latency,
    AVG(avg_disk_latency_ms) as disk_latency
    --FORMAT(Data, 'yyyy-MM-dd') as Mes
FROM BA_DBA.dbo.DBA_MONITOR_DISK_IO_LATENCIA
WHERE Data > '2024-04-09 12:00'
 	and Drive = 'F'
GROUP BY Drive


--FORMAT(Data, 'yyyy-MM-dd')

Select * from BA_DBA.dbo.DBA_MONITOR_DISK_IO_LATENCIA where Drive = 'F' order by data desc

/*
Métricas de qualidade de leitura de Disco Segundo a Microsoft. 

Excellent: < 1ms
Very good: < 5ms
Good: 5 – 10ms
Poor(É ok): 10 – 20ms
Bad: 20 – 100ms
Really bad: 100 – 500ms
OMG!: > 500ms

Medimos a latencia aqui. 
*/

