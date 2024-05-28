USE Ploomes_CRM
GO

SET NOCOUNT ON

IF (OBJECT_ID ('BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG') is null)
begin
  print	'Criando a tabela'
	create table BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG (datamin date)
End

--Delete from BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG

Declare 
	@data_min datetime = null, 
	@Data_Max datetime = null,
	@debug bit = 1


Select @Data_Max = max(datetime) from Automation_Log (nolock)
Where datetime <= CONVERT(DATE, DATEADD(MONTH, -6, GETDATE()), 121)

Select Count(1) from Automation_Log (nolock)
Where datetime <= CONVERT(DATE, DATEADD(MONTH, -6, GETDATE()), 121)
--10452861


-- Pega o Max pois é a ultima
SELECT @data_min = max(datamin) FROM BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG

If (@data_min is null)
Begin 
	print 'Data Nula - Dando valor min'
	Select @data_min = min(datetime) from Automation_Log (nolock)
			
	insert BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG (datamin)
	select @data_min
End

DROP TABLE IF EXISTS #Delete_Automation
CREATE TABLE #Delete_Automation (id int)
CREATE CLUSTERED INDEX DBA_PK ON #Delete_Automation (ID)

If (@debug = 1)
Begin 
	Select @data_min, @Data_Max
	select * from BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG (nolock)
	--return
End

While @data_min <= @Data_Max
Begin 
	Print '---- INICIANDO ' + convert(varchar(8), @data_min, 112) + '----------------------------------------------' 
	--return
	Exec BA_DBA.dbo.pr_dba_cronometro 
	
	while exists (Select 1 From Automation_Log (nolock) Where DateTime <= @data_min)
	Begin
		Select 'While na data ' + CONVERT(varchar(16), @data_min, 112)

		Declare @RowCont int

		 -- Faz o insert de 5000 ID ----------------------------------
		exec BA_DBA.dbo.pr_dba_cronometro

		insert #Delete_Automation (id)
		Select top 5000 Id From Automation_Log (nolock)
		Where DateTime <= @data_min

		Exec BA_DBA.dbo.pr_dba_cronometro 'Insert #Delete_Automation'
		 -- Faz o insert de 5000 ID ----------------------------------

		-- Fazendo o delete no quente ----------------------------------------
		Exec BA_DBA.dbo.pr_dba_cronometro
		
		DELETE D
		From Automation_Log			  D 
		Join #Delete_Automation   j on j.id = D.id	
		Select @RowCont = @@ROWCOUNT 
		Select 'Quantidade Linhas Deletadas:'+CONVERT(varchar(100), @RowCont) +'' 

		Exec BA_DBA.dbo.pr_dba_cronometro 'Deletando o quente (Automation_Log)'
		-- Fazendo o delete no quente ----------------------------------------


		-- Delete  #Delete_Automation -----------------------------------
		Exec BA_DBA.dbo.pr_dba_cronometro
		Delete #Delete_Automation 
		Exec BA_DBA.dbo.pr_dba_cronometro 'Delete #Delete_Automation'
		 -- Delete  #Delete_Automation ----------------------------------
		
	End -- While Select 1 

	Print '---- FINALIZANDO ' + convert(varchar(8), @data_min, 112) + '----------------------------------------------' 
	insert BA_DBA.dbo.DBA_LOG_DELETEAUTOMATIONLOG (datamin)
	select @data_min

	Select @data_min = @data_min + 1
	
	If (@debug = 1)
	Begin 
		Select 'Debug Fora do while. Datamin Após + 1. E o Count Tem que ser 0', @data_min, count(1) From #Delete_Automation		
	End

	Exec BA_DBA.dbo.pr_dba_cronometro  '!!!!!!!!!!!!!!!!!!! FINALIZADO !!!!!!!!!!!!!!!!!!' 
	PRINT ''

end -- while @data_min
