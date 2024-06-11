USE BA_DBA;  
GO 
IF (OBJECT_ID('PR_DBA_LOG_DISPARALOGS')is null)exec ('Create proc PR_DBA_LOG_DISPARALOGS as return')
GO
ALTER PROC PR_DBA_LOG_DISPARALOGS
	@debug bit = 0
AS
/************************************************************************
 Autor:  DBA\João Paulo 
 Data de criação: 10/10/2022
 Data de Atualização: 10/05/2023
 Funcionalidade: Cria um histórico de utilização de uso de CPU e memória. 
 Sabendo que memória sempre vai estar no máximo. Todavia, se a CPU passar de 70%
 dispara 3 jobs de geração de logs. 
*************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @cpuUsage		 float,   -- % CPU usage
			    @memoryUsage float,   -- % memory usage
					@TimeOut		 Time, 
					@TimeNow		 Time


	/* Criar condição dentro de um While e consultando uma tabela administrativa para ligar ou não o loop e apenas executar 
	as procedures, não precisando mais JOBs ou ter uma condição especifica. 
	Vai ser um LIGA e Desliga baseado em um check na tabela e um update de liga e desliga. 
	*/

	SELECT @TimeOut = '21:30', @TimeNow = GETDATE()

	WHILE (@TimeOut >= @TimeNow) 
	BEGIN
		
		WAITFOR DELAY '00:00:01'; 
		
		PRINT 'CRIANDO OS LOGS'

		EXEC BA_DBA.DBO.PR_DBA_LOG_MEMORIA;  
		EXEC BA_DBA.DBO.PR_DBA_LOG_BATCH;  
		EXEC BA_DBA.DBO.PR_DBA_LOG_CPU ;  

		WAITFOR DELAY '00:00:05'; 	
		
		SELECT @TimeNow = GETDATE()
					
	END -- WHILE 

	Print 'Fora do horário'

	--Delete from DBA_LOG_DISPARALOGS where HoraMonitor < CONVERT(CHAR(8),DATEADD(DAY, -2, GETDATE()),112)

END
GO 
IF(OBJECT_ID('DBA_LOG_DISPARALOGS') IS NULL) 
BEGIN
CREATE TABLE DBA_LOG_DISPARALOGS (
	CPUPorcentEmUSo			float, 
	memoryPorcentEmUSo	float, 
	HoraMonitor					datetime, 
	Iniciou_Jobs				Bit
)
END
GO

--DROP TABLE IF EXISTS DBA_LOG_DISPARALOGS
--SELECT * FROM DBA_LOG_DISPARALOGS
--EXEC BA_DBA.DBO.PR_DBA_LOG_DISPARALOGS
--DELETE FROM DBA_LOG_DISPARALOGS
