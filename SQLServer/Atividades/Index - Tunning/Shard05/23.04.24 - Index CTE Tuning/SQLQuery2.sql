USE [Ploomes_CRM]
GO
CREATE NONCLUSTERED INDEX ix_Relatorio_Suspenso_ID_Oportunidade
ON [dbo].[Relatorio] ([Suspenso])
INCLUDE ([ID_Oportunidade])