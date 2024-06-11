SELECT [TypeId] 'TYPE ID ORIGINAL', * 
FROM [Temp].[dbo].[Sankhya_Field] 
WHERE [IntegrationId] = 2743 and [Key] = 'OBSERVACAO' 
AND [SankhyaEntityId] in (54004, 54020);

BEGIN TRAN
UPDATE [Temp].[dbo].[Sankhya_Field] SET [TypeId] = 2 WHERE [IntegrationId] = 2743 and [Key] = 'OBSERVACAO' AND [SankhyaEntityId] in (54004, 54020);
--COMMIT
--Não é ROLLOUT -- É Rollback para retornar o estado original dentro de um TRAN. No SQL Server. 