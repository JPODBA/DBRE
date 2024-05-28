SELECT TOP 10 * FROM [Queue].[dbo].[Integration_Queue]  
WHERE [IntegrationId] = 63 AND [PloomesToSankhya] = 0 and [RuleId] = 7 and [ItemId] =3121108 Order by [Id]


USE [Queue]
GO
CREATE NONCLUSTERED INDEX Integration_Queue_IDM01
ON [dbo].[Integration_Queue] ([PloomesToSankhya],[ItemId],[IntegrationId],[RuleId])

GO