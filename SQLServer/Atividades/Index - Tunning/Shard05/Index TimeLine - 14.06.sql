USE [Ploomes_CRM]
GO
CREATE NONCLUSTERED INDEX [Timeline_DBA02]
ON [dbo].[Timeline] ([ID_ClientePloomes],[Principal])
INCLUDE ([ID_Cliente],[ID_Oportunidade],[ID_Usuario],[Cliente],[Oportunidade],[Usuario],[DataHora],[Venda],[ID_Venda],[ID_Responsavel],[ID_TipoResponsavel],
[ID_ResponsavelSecundario],[ID_TipoResponsavelSecundario],[ID_Documento],[Documento])
GO

CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_IDM01]
ON [dbo].[Usuario_Responsavel] ([ID_Usuario],[ID_Item])