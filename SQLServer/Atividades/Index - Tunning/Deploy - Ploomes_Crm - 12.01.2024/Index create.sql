use Ploomes_CRM_Logs
go 
--SELECT TOP 5 A.* 
--FROM ChangeReportAttempt A 
--WHERE A.Id % 1 = 1 - 1
----AND A.Executing = 0 
----AND A.CurrentAttempt <= 10 
--ORDER BY A.CurrentAttempt, A.Id

----sp_helpíndex 'ChangeReportAttempt'


--SELECT TOP 5 A.* 
--FROM ChangeLogAttempt A 
--WHERE A.Id % 2 = 50 - 1 
--AND A.Executing = 0 
--AND A.CurrentAttempt <= 10 
--ORDER BY A.CurrentAttempt, A.Id

--select distinct Id from ChangeLogAttempt (nolock)



CREATE INDEX IX_ChangeReportAttempt_Idm01
ON ChangeLogAttempt
(Executing, CurrentAttempt) include (id)
GO

CREATE INDEX IX_ChangeReportAttempt_Idm01
ON ChangeReportAttempt
(Executing, CurrentAttempt) include (id)
GO