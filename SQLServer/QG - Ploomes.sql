WITH cteBL (session_id, blocking_these) AS 
(SELECT s.session_id, blocking_these = x.blocking_these FROM sys.dm_exec_sessions s 
CROSS APPLY    (SELECT isnull(convert(varchar(6), er.session_id),'') + ', '  
                FROM sys.dm_exec_requests as er
                WHERE er.blocking_session_id = isnull(s.session_id ,0)
                AND er.blocking_session_id <> 0 
                FOR XML PATH('') ) AS x (blocking_these)
)
SELECT s.session_id, blocked_by = r.blocking_session_id, bl.blocking_these
, batch_text = t.text, input_buffer = ib.event_info, * 
FROM sys.dm_exec_sessions s 
LEFT OUTER JOIN sys.dm_exec_requests r on r.session_id = s.session_id
INNER JOIN cteBL as bl on s.session_id = bl.session_id
OUTER APPLY sys.dm_exec_sql_text (r.sql_handle) t
OUTER APPLY sys.dm_exec_input_buffer(s.session_id, NULL) AS ib
WHERE blocking_these is not null or r.blocking_session_id > 0
ORDER BY len(bl.blocking_these) desc, r.blocking_session_id desc, r.session_id;


--sp_who2
--SP_WHOISACTIVE
--kill 125
--SELECT COUNT(1) 
--FROM Ploomes_CRM_Logs..AutomationAttempt (Nolock)

--SELECT 
--    event_time,
--    action_id, 
--    statement,
--    object_name, 
--    database_name, 
--    server_principal_name as AlteradoPor
--FROM fn_get_audit_file( 'C:\SQL_LOG_SECURITY*.sqlaudit' , DEFAULT , DEFAULT)
--order by 1 desc;

--DBCC FREESYSTEMCACHE ('ALL') 
--DBCC FREESESSIONCACHE
--DBCC FREEPROCCACHE


--SELECT s.session_id, s.login_time, s.host_name, s.program_name,
--s.login_name, s.nt_user_name, s.is_user_process
--FROM sys.dm_exec_sessions s
--WHERE s.is_user_process = 1
--	and login_name in ('ploomes_services')

--select 
--	SQL_current_Memory_usage_mb as Memoria_emUso, 
--	OS_Total_Memory_mb as TotalDisponível, 
--	OS_Available_Memory_mb as Mb_livre 
--From master.dbo.fn_CheckSQLMemory()

--use Ploomes_CRM
--go 
--select * from hostset

--SELECT
--		top 50
--    end_time,
--    avg_cpu_percent,
--    avg_instance_cpu_percent
--FROM sys.dm_db_resource_stats
----where avg_cpu_percent <= 70
--ORDER BY end_time DESC; 
--GO


--select
--  getdate() as data,
--  sum(cpu) [cpu],
--  sum(physical_io) [io],
--  sum(memusage) [mem],
--  sum(open_tran) [qtdTransAbertas],
--  count(1) [qtdConnect]
--from master.dbo.sysprocesses (NOLOCK)
--where spid > 50
--  and spid <> @@spid