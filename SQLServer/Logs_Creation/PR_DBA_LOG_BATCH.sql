USE BA_DBA;  
GO 
IF (OBJECT_ID('PR_DBA_LOG_BATCH')is null)exec ('Create proc PR_DBA_LOG_BATCH as return')
GO
ALTER PROC PR_DBA_LOG_BATCH
	@debug bit = 1
AS
/************************************************************************
 Autor:  DBA\João Paulo 
 Data de criação: 05/10/2022
 Data de Atualização: 01/02/2023 
 Funcionalidade: Makes a survey of the resources that SQL requests for Batches. 
*************************************************************************/
BEGIN 
	SET NOCOUNT ON
		
	DECLARE @TIME DATETIME = GETDATE() 
	SELECT @TIME = DATEADD(MINUTE, -2, @TIME)
	--SELECT @TIME

	
	DROP TABLE IF EXISTS #DBA_LOG_BATCH
	CREATE TABLE #DBA_LOG_BATCH (
		SessionID				SMALLINT     ,  
		batch_text			NVARCHAR(MAX) COLLATE Latin1_General_CI_AI,
		statement_text	NVARCHAR(MAX) COLLATE Latin1_General_CI_AI,
		XML_Plan				XML					 ,
		StarTime				DATETIME		 ,
		Status					NVARCHAR(100) COLLATE Latin1_General_CI_AI,
		user1						INT					 ,
		blocking				SMALLINT		 ,
		Wait_Time				INT					 ,
		Wait						NVARCHAR(100) COLLATE Latin1_General_CI_AI,
		Cpu_Time				INT					 ,
		LogicalReads		BIGINT			 ,
		Memory					INT
	)


	/*Troubleshooting CPU*/
	-- Examining SQL Server processes by Batch
	Insert #DBA_LOG_BATCH
	SELECT 
		r.session_id							as SessionID
		,st.TEXT									AS batch_text
		,SUBSTRING(st.TEXT, statement_start_offset / 2 + 1, (
				(
					CASE 
						WHEN r.statement_end_offset = - 1
							THEN (LEN(CONVERT(NVARCHAR(max), st.TEXT)) * 2)
						ELSE r.statement_end_offset
						END
					) - r.statement_start_offset
				) / 2 + 1)						AS statement_text
		,null						AS 'XML Plan'
		,r.start_time							AS StarTime, 
		r.status									as Status, 
		r.user_id									as user1, 
		r.blocking_session_id			as blocking,
		r.wait_time								as Wait_Time, 
		r.last_wait_type					as Wait,
		r.cpu_time								as Cpu_Time,
		r.logical_reads					  as LogicalReads,
		r.granted_query_memory		as Memory
	FROM sys.dm_exec_requests r
	CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
	CROSS APPLY sys.dm_exec_query_plan(r.plan_handle) AS qp	
	ORDER BY cpu_time DESC

	DELETE FROM #DBA_LOG_BATCH WHERE batch_text LIKE '%DBA%'

	INSERT DBA_LOG_BATCH
	SELECT R.* 
	FROM #DBA_LOG_BATCH R
	WHERE NOT EXISTS (SELECT 1 
										FROM DBA_LOG_BATCH DBA (NOLOCK) 
										WHERE DBA.SessionID = r.SessionID
											AND DBA.batch_text = R.batch_text
											and DBa.StarTime >= @TIME)


	DELETE FROM DBA_LOG_BATCH WHERE StarTime < CONVERT(CHAR(8), DATEADD(HOUR, -2, GETDATE()), 112)


												

END
GO 
IF (OBJECT_ID('DBA_LOG_BATCH') IS NULL) 
BEGIN
CREATE TABLE DBA_LOG_BATCH (
	SessionID				SMALLINT     ,  
	batch_text			NVARCHAR(MAX),
	statement_text	NVARCHAR(MAX),
	XML_Plan				XML					 ,
	StarTime				DATETIME		 ,
	Status					NVARCHAR(100),
	user1						INT					 ,
	blocking				SMALLINT		 ,
	Wait_Time				INT					 ,
	Wait						NVARCHAR(100),
	Cpu_Time				INT					 ,
	LogicalReads		BIGINT			 ,
	Memory					INT
)
END
GO


/*
-- Select * from DBA_LOG_BATCH (nolock) order by SessionID desc
-- DELETE from DBA_LOG_BATCH
-- EXEC BA_DBA.DBO.PR_DBA_LOG_BATCH

testing
declare @i int = 0 
Select @i = 0
select @i
while (@i < 10)
Begin
	Print 'entrou'
	EXEC BA_DBA.DBO.PR_DBA_LOG_BATCH
	waitfor delay '00:00:03'

	Select @i = @i + 1
	select @i

end

DROP TABLE IF EXISTS #Valida_ID_Repetido

Select 
	SessionID, 
	count(*) as Count1
INTO #Valida_ID_Repetido
from DBA_LOG_BATCH (nolock)
group by SessionID
having count(*) > 1
use ba_Dba

select * from #Valida_ID_Repetido

select * from BA_DBA.dbo.DBA_LOG_BATCH order by 5 desc
*/
