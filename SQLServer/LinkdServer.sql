-- OBS --------------------------------------------------------
-- OBS --------------------------------------------------------
-- Teste
-- 1) QUANDO O @datasrc ESTIVER SETADO, PARA OS CASOS DE INST�NCIA DO SQL SERVER, O @srvproduct N�O PODE SER ESPECIFICADO.
-- 2) PARA OS SERVIDORES HOSPEDADOS NA MESMA M�QUINA(INST�NCIA), N�O H� NECESSIDADE DE ALTERAR O HOST.
-- 3) CHECAR O CONNECTION TIMEOUT E O QUERY TIMEOUT DOS LINKEDSERVERS. PADR�O 60 SEGUNDOS.
-- 4) COLOCAR O LOGIN do LINKEDSERVER COMO SysADMIN.

-- OBS --------------------------------------------------------
-- OBS --------------------------------------------------------

CREATE LOGIN linkedserver WITH PASSWORD = 'lemonjuice', CHECK_POLICY = OFF, DEFAULT_DATABASE = master
EXEC master..sp_addsrvrolemember @loginame = N'linkedserver', @rolename = N'sysadmin'

-- Para Dropar depois de criar. O ideal � sempre criar por necessidade. 
select 
--*
'exec sp_dropserver '''+ srvname +''', ''droplogins'' '
from master.dbo.sysservers
where srvid > 0
order by srvname
--exec sp_dropserver 'E', 'droplogins' 
drop login linkedserver

-- Para criar o comando de forma geral. 
select 
'Select top 1 * From [' + srvname + '].master.sys.databases'
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
--exec sp_dropserver 'SHARD10', 'droplogins'
--exec sp_dropserver 'SHARD11', 'droplogins' 
--exec sp_dropserver 'SHARD12', 'droplogins' 

-- Exemplo de cria��o SQL-CRM-HMLG.172.22.2.6
EXEC master.dbo.sp_addlinkedserver   @server = N'SHARD10', @srvproduct=N'', @provider=N'SQLOLEDB', @datasrc=N'172.16.0.95';
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SHARD10', @useself=N'False', @locallogin=NULL, @rmtuser=N'dba', @rmtpassword='wMPVd6rXMOkxLACt3RwL';
GO
EXEC master.dbo.sp_addlinkedserver   @server = N'SHARD04', @srvproduct=N'', @provider=N'SQLOLEDB', @datasrc=N'172.26.1.184';
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SHARD04', @useself=N'False', @locallogin=NULL, @rmtuser=N'dba', @rmtpassword='Mtbr1241';
GO
EXEC master.dbo.sp_addlinkedserver   @server = N'SHARD05', @srvproduct=N'', @provider=N'SQLOLEDB', @datasrc=N'172.26.1.90';
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SHARD05', @useself=N'False', @locallogin=NULL, @rmtuser=N'dba', @rmtpassword='Mtbr1241';
GO
EXEC master.dbo.sp_addlinkedserver   @server = N'SHARD09', @srvproduct=N'', @provider=N'SQLOLEDB', @datasrc=N'172.26.0.245';
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SHARD09', @useself=N'False', @locallogin=NULL, @rmtuser=N'dba', @rmtpassword='Mtbr1241';
GO
EXEC master.dbo.sp_addlinkedserver   @server = N'SHARD12', @srvproduct=N'', @provider=N'SQLOLEDB', @datasrc=N'172.26.1.212';
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'SHARD12', @useself=N'False', @locallogin=NULL, @rmtuser=N'dba', @rmtpassword='Mtbr1241';
go
Select top 1 * From [SHARD01].master.sys.databases
Select top 1 * From [SHARD02].master.sys.databases
Select top 1 * From [SHARD04].master.sys.databases
Select top 1 * From [SHARD05].master.sys.databases
Select top 1 * From [SHARD06].master.sys.databases
Select top 1 * From [SHARD07].master.sys.databases
Select top 1 * From [SHARD08].master.sys.databases
Select top 1 * From [SHARD09].master.sys.databases
Select top 1 * From [SHARD10].master.sys.databases
Select top 1 * From [SHARD11].master.sys.databases
Select top 1 * From [SHARD12].master.sys.databases