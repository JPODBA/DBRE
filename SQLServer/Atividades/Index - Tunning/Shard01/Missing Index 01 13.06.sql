
USE [Ploomes_CRM]
GO
CREATE NONCLUSTERED INDEX ix_Oportunidade_ID_MotivoPerda
ON [dbo].[Oportunidade] ([ID_MotivoPerda])
INCLUDE ([ID])
GO
CREATE NONCLUSTERED INDEX ix_Oportunidade_status_Historico_ID_MotivoPerda
ON [dbo].[Oportunidade_status_Historico] ([ID_MotivoPerda])
INCLUDE ([ID])
GO
