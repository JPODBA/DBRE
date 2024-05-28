-- OBS --------------------------------------------------------
-- OBS --------------------------------------------------------

-- 1) QUANDO O @datasrc ESTIVER SETADO, PARA OS CASOS DE INSTÂNCIA DO SQL SERVER, O @srvproduct NÃO PODE SER ESPECIFICADO.
-- 2) PARA OS SERVIDORES HOSPEDADOS NA MESMA MÁQUINA(INSTÂNCIA), NÃO HÁ NECESSIDADE DE ALTERAR O HOST.
-- 3) CHECAR O CONNECTION TIMEOUT E O QUERY TIMEOUT DOS LINKEDSERVERS. PADRÃO 60 SEGUNDOS.
-- 4) COLOCAR O LOGIN do LINKEDSERVER COMO SysADMIN.

-- OBS --------------------------------------------------------
-- OBS --------------------------------------------------------

CREATE LOGIN linkedserver WITH PASSWORD = 'lemonjuice', CHECK_POLICY = OFF, DEFAULT_DATABASE = master
EXEC master..sp_addsrvrolemember @loginame = N'linkedserver', @rolename = N'sysadmin'

-- Para Dropar depois de criar. O ideal é sempre criar por necessidade. 
select 
--*
'exec sp_dropserver '''+ srvname +''', ''droplogins'' '
from master.dbo.sysservers
where srvid > 0
order by srvname

drop login linkedserver

-- Para criar o comando de forma geral. 
select 
*
--'exec sp_dropserver '''+ srvname +''', ''droplogins'' '
from master.dbo.sysservers
where srvid > 0
order by srvname

--exec sp_dropserver 'SHARD01', 'droplogins'
--exec sp_dropserver 'SHARD02', 'droplogins'
--exec sp_dropserver 'SHARD03', 'droplogins'
--exec sp_dropserver 'SHARD04', 'droplogins' 
--exec sp_dropserver 'SHARD05', 'droplogins' 
--exec sp_dropserver 'SHARD06', 'droplogins' 
--exec sp_dropserver 'SHARD07', 'droplogins' 
--exec sp_dropserver 'SHARD08', 'droplogins' 
--exec sp_dropserver 'SHARD09', 'droplogins'
--exec sp_dropserver 'SHARD11', 'droplogins' 

-- Exemplo de criação 
EXEC master.dbo.sp_addlinkedserver   @server = N'SHARD02', @srvproduct=N'', @provider=N'SQLOLEDB', @datasrc=N'172.16.0.23';
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SHARD02', @useself=N'False', @locallogin=NULL, @rmtuser=N'linkedserver', @rmtpassword='lemonjuice';
GO