-- Validação Shard06

Select
	AVG(avg_disk_latency_ms)       as Disco,
	AVG(avg_read_disk_latency_ms)  as leitura,
	AVG(avg_write_disk_latency_ms) as Escrita
From BA_DBA.dbo.DBA_DISK_IO_LATENCIA 
Where Drive = 'F'
	and convert(char(8), data, 112) <= '20230326'



Select
	AVG(avg_disk_latency_ms)       as Disco,
	AVG(avg_read_disk_latency_ms)  as leitura,
	AVG(avg_write_disk_latency_ms) as Escrita
From BA_DBA.dbo.DBA_DISK_IO_LATENCIA 
Where Drive = 'F'
	and convert(char(8), data, 112) >= '20230327'



-- Validação Shard05

Select
	AVG(avg_disk_latency_ms)       as Disco,
	AVG(avg_read_disk_latency_ms)  as leitura,
	AVG(avg_write_disk_latency_ms) as Escrita
From BA_DBA.dbo.DBA_DISK_IO_LATENCIA 
Where Drive = 'F'
	and convert(char(8), data, 112) <= '20230304'



Select
	AVG(avg_disk_latency_ms)       as Disco,
	AVG(avg_read_disk_latency_ms)  as leitura,
	AVG(avg_write_disk_latency_ms) as Escrita
From BA_DBA.dbo.DBA_DISK_IO_LATENCIA 
Where Drive = 'F'
	and convert(char(8), data, 112) >= '20230305'


--- Validação Shard004

Select
	AVG(avg_disk_latency_ms)       as Disco,
	AVG(avg_read_disk_latency_ms)  as leitura,
	AVG(avg_write_disk_latency_ms) as Escrita
From BA_DBA.dbo.DBA_DISK_IO_LATENCIA 
Where Drive = 'E'
	and convert(char(8), data, 112) <= '20230319'
		
Select
	AVG(avg_disk_latency_ms)       as Disco,
	AVG(avg_read_disk_latency_ms)  as leitura,
	AVG(avg_write_disk_latency_ms) as Escrita
From BA_DBA.dbo.DBA_DISK_IO_LATENCIA 
Where Drive = 'E'
	and convert(char(8), data, 112) >= '20230320'


--- Validação Shard002

Select
	AVG(avg_disk_latency_ms)       as Disco,
	AVG(avg_read_disk_latency_ms)  as leitura,
	AVG(avg_write_disk_latency_ms) as Escrita
From BA_DBA.dbo.DBA_DISK_IO_LATENCIA 
Where Drive = 'E'
	and convert(char(8), data, 112) <= '20230319'
		
Select
	AVG(avg_disk_latency_ms)       as Disco,
	AVG(avg_read_disk_latency_ms)  as leitura,
	AVG(avg_write_disk_latency_ms) as Escrita
From BA_DBA.dbo.DBA_DISK_IO_LATENCIA 
Where Drive = 'E'
	and convert(char(8), data, 112) >= '20230320'