use Ploomes_CRM_Logs
go 

CREATE INDEX [AutomationAttempt_IDM01] ON [Ploomes_CRM_Logs].[dbo].[AutomationAttempt] ([Executing], [Periodic]) 
INCLUDE ([Id], [AutomationId], [AutomationUserKey], [ItemId], [DateTime], [CurrentAttempt], [IterationCount], [AccountId], [ExecutingDate]) 
go 
Sp_helpindex 'WebhookAttempt'
go 

-- Lock
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


--drop index if exists TableSyncAttempt.IX_TableSyncAttempt_ExecutingDate
--drop index if exists ChangeReportAttempt.IX_ChangeReportAttempt_ExecutingDate
--drop index if exists IdentityProviderAttempt.IX_IdentityProviderAttempt_ExecutingDate
--drop index if exists WebhookAttempt.IX_WebhookAttempt_ExecutingDate


drop index if exists AutomationAttempt.AutomationAttempt_DBA02
drop index if exists WebhookAttempt.IX_WebhookAttempt_ExecutingDate


sp_helpindex 'WebhookAttempt'
IX_WebhookAttempt_ExecutingDate (Executing(-), ExecutingDate)

(@AttemptId int)UPDATE CustomerHealthAttempt SET ExecutingDate = GETDATE(), Executing = 1 WHERE Id = @AttemptId
(@WebhookAttemptSecondsIntervalMultiplier int,@Threads int,@ThreadNumber int)SELECT TOP 5 A.* FROM WebhookAttempt A WHERE A.WebhookId % @Threads = @ThreadNumber - 1 AND A.Executing = 0 AND NOT EXISTS(SELECT 1 FROM WebhookAttempt WHERE WebhookId = A.WebhookId AND Executing = 1) 
AND DATEDIFF(second, A.DateTime, GETDATE()) >= ((A.CurrentAttempt - 1) * @WebhookAttemptSecondsIntervalMultiplier) ORDER BY A.Id