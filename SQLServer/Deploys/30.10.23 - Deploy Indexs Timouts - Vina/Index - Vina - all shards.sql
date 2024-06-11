use Ploomes_CRM
go
-- Já tem no 05
sp_helpindex 'CampoFixo2_ClientePloomes'
DROP INDEX [IX_CampoFixo2_ClientePloomes_ID_ClientePloomes] ON [dbo].[CampoFixo2_ClientePloomes]
GO

CREATE NONCLUSTERED INDEX [IX_CampoFixo2_ClientePloomes_ID_ClientePloomes] ON [dbo].[CampoFixo2_ClientePloomes]
(
    [ID_ClientePloomes] ASC,
    [ID_Campo] ASC
)
INCLUDE([Obrigatorio],[Unico],[Bloqueado],[Expandido],[FiltroFormulario],[FormulaEditor],[Oculto],[ColumnSize],[UseCheckbox],[FilterId],[SendExternalKey],[ReceiveExternalKey],[EnableFormatting],[UpdateDate]) 
ON [INDEX]
GO
