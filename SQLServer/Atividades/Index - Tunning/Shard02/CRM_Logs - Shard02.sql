    SELECT TOP 10
    convert(char(8),getdate(),112) [data],
    --''+@@SERVERNAME+'' [servidor],
    DB_NAME(dm_mid.database_id) [db],
    OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) [tabela],
    dm_migs.avg_user_impact, --*(dm_migs.user_seeks+dm_migs.user_scans) as  Avg_Estimated_Impact,
    dm_migs.user_seeks,
    dm_migs.user_scans,
    dm_migs.last_user_seek AS Last_User_Seek,
    left(dm_mid.equality_columns,500),
    left(dm_mid.inequality_columns,500),
    left(dm_mid.included_columns,500),
    'CREATE INDEX [' + OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id)+'_IDM]'+ --'_'
    + ' ON ' + dm_mid.statement
    + ' (' + ISNULL (dm_mid.equality_columns,'')
    + CASE WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns IS NOT NULL THEN ',' ELSE
    '' END
    + ISNULL (dm_mid.inequality_columns, '')
    + ')'
    + ISNULL (' INCLUDE (' + dm_mid.included_columns + ') WITH (ONLINE=ON)', ' WITH (ONLINE=ON)') AS Create_Statement
    FROM sys.dm_db_missing_index_groups dm_mig
    INNER JOIN sys.dm_db_missing_index_group_stats dm_migs ON dm_migs.group_handle = dm_mig.index_group_handle
    INNER JOIN sys.dm_db_missing_index_details dm_mid      ON dm_mig.index_handle = dm_mid.index_handle
    WHERE dm_mid.database_ID = DB_ID()
      and OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) not like '%sys%'
    ORDER BY last_user_seek  DESC

		CREATE INDEX [WebhookAttempt_IDM] ON [Ploomes_CRM_Logs].[dbo].[WebhookAttempt] ([WebhookId], [Executing]) WITH (ONLINE=ON)
    