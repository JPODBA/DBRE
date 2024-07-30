USE BA_DBA;  
GO 
IF (OBJECT_ID('PR_DBA_LOG_MEMORIA')is null)exec ('Create proc PR_DBA_LOG_MEMORIA as return')
GO
CREATE OR ALTER PROC PR_DBA_LOG_MEMORIA
	@debug bit = 1
AS
/************************************************************************
 Autor:  DBA\Jo�o Paulo 
 Data de cria��o: 01/01/2022
 Data de Atualiza��o: 01/02/2023
 Funcionalidade: Makes a daily survey of resources requesting memory. 
*************************************************************************/
BEGIN 
	SET NOCOUNT ON

	DECLARE @TIME DATETIME = GETDATE() 
	SELECT @TIME = CONVERT(CHAR(17), @TIME, 121)+'00'
	--SELECT @TIME
	

	INSERT BA_DBA.DBO.DBA_LOG_MEMORIA
	SELECT
		mg.session_id,            -- Pega a sess�o que est� solicitando 
		mg.request_time,				  -- Hor�rio de Requisi��o do recurso. 
		mg.grant_time,            -- Hora que o SQL Liberou o Recurso. 
		mg.requested_memory_kb,   -- Mem�ria que a API pediu.
		mg.granted_memory_kb,     -- Mem�ria que foi concedida pelo SQl
		mg.max_used_memory_kb,    -- Mem�ria que REALMENTE Foi utilizada. 
		mg.query_cost,						-- Custo da opera��o. Que � um valor de 0 a 100. Onde o valor 100 seria o pior caso. 
		null,											-- Plano de execuss�o para JOINs com outros logs. 
		t.text ,									-- Query texto. 
		null											-- PLano de execu��o. 
	FROM sys.dm_exec_query_memory_grants AS mg
	CROSS APPLY sys.dm_exec_sql_text(mg.sql_handle) AS t
	CROSS APPLY sys.dm_exec_query_plan(mg.plan_handle) AS qp
	WHERE NOT EXISTS (SELECT 1 
										FROM BA_DBA.DBO.DBA_LOG_MEMORIA DBA (NOLOCK) 
										WHERE DBA.session_id = MG.session_id
											AND DBA.Query_Text = T.text COLLATE Latin1_General_CI_AI
											AND DBA.request_time >= @TIME)
	ORDER BY 1 DESC OPTION (MAXDOP 4)
	Select @@ROWCOUNT

	DELETE FROM BA_DBA.DBO.DBA_LOG_MEMORIA WHERE request_time <= CONVERT(CHAR(8),DATEADD(DAY, -2, GETDATE()),112)
	
	
END
GO 
--drop table if exists BA_DBA.DBO.DBA_LOG_MEMORIA
IF (OBJECT_ID('BA_DBA.DBO.DBA_LOG_MEMORIA') IS NULL) 
BEGIN
CREATE TABLE BA_DBA.DBO.DBA_LOG_MEMORIA (
	session_id						 smallint ,          
	request_time					 DATETIME,				
	grant_time						 DATETIME,          
	requested_memory_kb    INT, 
	granted_memory_kb      INT,     
	max_used_memory_kb     INT,  
	query_cost             FLOAT,					
	sql_handle             varbinary(64),					
	Query_Text             NVarchar(max) COLLATE Latin1_General_CI_AI,									
	query_plan						 xml 
)
END
GO
/*
 SELECT count(1), Query_text
 FROM BA_DBA.DBO.DBA_LOG_MEMORIA (nolock) 
 Where  requested_memory_kb >= 1000
	and max_used_memory_kb >= 1000
 group by Query_text
 Order by 1 desc
				1382904
 select 22233128 / 1024 / 1024
 SELECT  top 100 * 
 FROM BA_DBA.DBO.DBA_LOG_MEMORIA (nolock) 
 where request_time >= '20240726'
 order by 4 desc
 
 Delete from BA_DBA.DBO.DBA_LOG_MEMORIA
--EXEC BA_DBA.DBO.PR_BA_DBA.DBO.DBA_LOG_MEMORIA

 */
