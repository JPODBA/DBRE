declare @id as table (id int)

insert @id
SELECT TOP 20 Id 
FROM [Queue].[dbo].[Integration_Queue] WITH (INDEX(IX_Integration_Queue_DBA01))
WHERE [PloomesToSankhya] = 0  
 AND (STATUS = 1 OR ([Status] < 4 AND [NextRetryDate] < '2023-07-04 13:49:38.143')) ORDER BY [Id]

-- Update pego no monitor
UPDATE [Queue].[dbo].[Integration_Queue] SET [Status] = 3,[NextRetryDate] = '2023-07-04 14:09:38.143' 
WHERE Id IN (SELECT * from @id)

-- Index criado para o Update
CREATE NONCLUSTERED INDEX IX_Integration_Queue_DBA01
ON [Queue].[dbo].[Integration_Queue] 
([PloomesToSankhya], [Status], [NextRetryDate]) include (id)

UPDATE STATISTICS [Queue].[dbo].[Integration_Queue] IX_Integration_Queue_DBA02;  

---------------------------------------------------------------------------------------------------------------------


-- Não precisa de index, ao menos, execuções foi bem rápido. 
SELECT [Id], [EntityId], [ItemId], [ActionId], [CreateDate], [Body], [RetryCount], [Status], [RuleId], [IntegrationId] 
FROM [Queue].[dbo].[Integration_Queue] 
WHERE [Status] = 3 
	AND [NextRetryDate] >= '20230704' 
ORDER BY [Id]





SELECT TOP 1 Id 
FROM [Queue].[dbo].[Integration_Queue] 
WHERE [PloomesToSankhya] = 0 AND [IntegrationId] NOT IN (1,2,3) AND (STATUS = 1 OR ([Status] < 4 AND [NextRetryDate] < '20230704')) 
ORDER BY [Id]

CREATE NONCLUSTERED INDEX IX_Integration_Queue_DBA01
ON [Queue].[dbo].[Integration_Queue] 
([PloomesToSankhya], [Status], [NextRetryDate]) include (id)

CREATE NONCLUSTERED INDEX IX_Integration_Queue_DBA02
ON [Queue].[dbo].[Integration_Queue] 
([PloomesToSankhya], [IntegrationId], [Status], [NextRetryDate]) include (id)


UPDATE [Queue].[dbo].[Integration_Queue] SET [Status] = 3, [NextRetryDate] = '{nextRetryDate}'
WHERE Id IN 
(
  SELECT TOP 1 Id 
  FROM [Queue].[dbo].[Integration_Queue]  --WITH (INDEX(IX_Integration_Queue_DBA02))
  WHERE [PloomesToSankhya] = 0 AND [IntegrationId] NOT IN (1,2,3) AND (STATUS = 1 OR ([Status] < 4 AND [NextRetryDate] < '20230704')) 
  ORDER BY [Id]
);  

SELECT [Id], [EntityId], [ItemId], [ActionId], [CreateDate], [Body], [RetryCount], [Status], [RuleId], [IntegrationId] 
FROM [Queue].[dbo].[Integration_Queue] 
WHERE [Status] = 3 AND [NextRetryDate] = '{nextRetryDate}' ORDER BY [Id]