USE BA_DBA;  
GO 
IF (OBJECT_ID('PR_DBA_CONFIGURACAOINSTANCIA')is null)exec ('Create proc PR_DBA_CONFIGURACAOINSTANCIA as return')
GO
alter procedure PR_DBA_CONFIGURACAOINSTANCIA
as
/************************************************************************
 Autor: Equipe DBA\João Paulo Oliveira
 Data de criação: 08/05/2023
 Data de Atualização: 
 Funcionalidade: Retorna as configurações gerais da instância
*************************************************************************/

IF (OBJECT_ID ('BA_DBA..DBA_MONITOR_CONFIGURACAODBA')is null) 
Begin
	--Print  'Entrou'
	create table BA_DBA.DBO.DBA_MONITOR_CONFIGURACAODBA	(
		Name Varchar(50), 
		minimum bigint, 
		maximum bigint,
		config_Value int, 
		run_value int 
		)
End

Declare @exec as table (vExec varchar(1000))
--create table @exec (vExec varchar(1000))

Delete from BA_DBA.DBO.DBA_MONITOR_CONFIGURACAODBA

insert BA_DBA.DBO.DBA_MONITOR_CONFIGURACAODBA
EXEC sp_configure


insert @exec
Select 'EXEC sys.sp_configure N'''+Name+''', N'''+Convert(varchar(50),config_Value)+''';'	From BA_DBA.DBO.DBA_MONITOR_CONFIGURACAODBA;
select * from @exec


--Select * From BA_DBA.DBO.DBA_MONITOR_CONFIGURACAODBA
--Select count(1) From BA_DBA.DBO.DBA_MONITOR_CONFIGURACAODBA

