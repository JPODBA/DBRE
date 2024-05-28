use BA_DBA
GO
IF(OBJECT_ID('PR_DBA_UPDATESTATS')is null) Exec ('Create procedure PR_DBA_UPDATESTATS as return')
GO
ALTER PROC PR_DBA_UPDATESTATS (@ba varchar(100) = null, @debug bit = 0) as
/************************************************************************
 Autor: DBA\ João Paulo Oliveira	
 Data de criação: 24/08/2022
 Data de Atualização: 
 Funcionalidade: Faz update statistics para cada datafile do BA atual.
 O otimizador de consulta usa as estatísticas para determinar quando um índice deve ser usado, como acessar esses índices, a melhor forma de unir tabelas, etc.
*************************************************************************/
begin
  Set nocount on

  Declare @DatabasesManutencao table (name varchar(100))
  
	insert @DatabasesManutencao
  select 
		name
  from master.sys.databases (nolock)
  where name = isNull(@ba, name)
		and database_id > 4
		and state = 0
  order by name

	Declare @TimeNow time, @TimeOut time

	Select @TimeOut = '08:30'

  while exists (select 1 from @DatabasesManutencao) begin
    select top 1 @ba = name from @DatabasesManutencao 

		Select @TimeNow = Getdate()
		IF (@TimeNow >= @TimeOut)Begin
			Select 'Saida de prevenção ativida.'
			Return
		END

    -- manutencao dinamica -----------------------------------
    Declare @raiserror varchar(100) = 'USE: '+@ba
    exec BA_DBA.DBO.PR_DBA_CRONOMETRO
    -- manutencao dinamica -----------------------------------

    declare @dataExec datetime = getdate()
    INSERT BA_DBA.DBO.DBA_LOGMANUTENCAO 
			(DataInicio, ba, procExecucao, erroId, erroLinha, erroMsg)
    select 
			@dataExec, @ba, OBJECT_NAME(@@PROCID), 0, 0, null
			    

    BEGIN TRY
      exec ('exec '+@ba+'.DBO.sp_updatestats')
    END TRY
    BEGIN CATCH
      UPDATE BA_DBA.DBO.DBA_LOGMANUTENCAO 
			SET DataFim = GETDATE(), 
				--ba = @ba, 
				procExecucao = ERROR_PROCEDURE(), 
				erroId = ERROR_NUMBER(), 
				erroLinha = ERROR_LINE(), 
				erroMsg = ERROR_MESSAGE() 
			WHERE DataInicio = @dataExec 
				AND ba = @ba			 
    END CATCH;

    --BEGIN TRY
    --  exec ('exec pr_updatestatsEspecifico '+@ba)
    --END TRY
    --BEGIN CATCH
    --  UPDATE BA_DBA.DBO.DBA_LOGMANUTENCAO set DataFim = GETDATE(), ba = @ba, procExecucao = ERROR_PROCEDURE(), erroId = ERROR_NUMBER(), erroLinha = ERROR_LINE(), erroMsg = ERROR_MESSAGE()
    --END CATCH;

    update BA_DBA.DBO.DBA_LOGMANUTENCAO set DataFim = GETDATE() where DataInicio = @dataExec and ba = @ba
		update BA_DBA.DBO.DBA_LOGMANUTENCAO set TempoDeExec_minutos = DATEDIFF(minute, DataInicio, DataFim) where DataInicio = @dataExec and ba = @ba and procExecucao = OBJECT_NAME(@@PROCID)
    

    Delete @DatabasesManutencao where name = @ba
    Exec BA_DBA.DBO.PR_DBA_CRONOMETRO @raiserror
  end --while

	Delete from BA_DBA.DBO.DBA_LOGMANUTENCAO where DataFim <= CONVERT(CHAR(8),DATEADD(WEEK, -2, GETDATE()),112)
end
GO
/** ----- Create table da DBA_LOGMANUTENCAO está no Script Proc Manutenção index ----------------- **/


-- DROP TABLE BA_DBA.DBO.DBA_LOGMANUTENCAO
-- EXEC BA_DBA.DBO.PR_DBA_UPDATESTATS 'BA_DBA'
-- Select * from BA_DBA.DBO.DBA_LOGMANUTENCAO
-- Delete from BA_DBA.DBO.DBA_LOGMANUTENCAO

--SELECT 
--	sp.stats_id, 
--	name, 
--	last_updated, rows, rows_sampled, steps, unfiltered_rows, modification_counter   
--FROM sys.stats AS stat   
--CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp  
----WHERE stat.object_id = object_id('oportunidade');
--where last_updated >= '2024-03-11 12:00'
--	and name not like '_WA%'
--order by name 

--Select Count(1) from sys.tables

--Select name from sys.tables order by name

--UPDATE STATISTICS Ploomes_CRM.dbo.Usuario; 
--Vw_PesquisaGeral

--UPDATE STATISTICS Ploomes_CRM.dbo.Automation_log; 

--sp_helptext 'Vw_PesquisaGeral'

--Select * from sys.objects where type = 'V' order by 1