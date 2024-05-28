/*
Missing Index Details from SQLQuery7.sql - Shard04.172.16.0.45.Ploomes_CRM (dba (366))
The Query Processor estimates that implementing the following index could improve the query cost by 100%.
*/


USE [Ploomes_CRM]
GO
CREATE NONCLUSTERED INDEX ix_Log_Acao_AccountId_DBA01
ON [dbo].[Log_Acao] ([AccountId])
INCLUDE ([ID_Usuario],[Pagina],[DataHora],[Plataforma],[IPAddress])
GO

