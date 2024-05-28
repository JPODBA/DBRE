CREATE NONCLUSTERED INDEX [IX_Oportunidade_ID_Funil2] ON [dbo].[Oportunidade]
(
    [ID_Funil] ASC,
    [ID_Status2] ASC
)
INCLUDE([ID_Responsavel])  ON [INDEX_03]
GO

######### SHARD 01 ##########

DROP INDEX [IX_Usuario_Responsavel_ID_Usuario] ON [dbo].[Usuario_Responsavel]
GO

CREATE NONCLUSTERED INDEX [IX_Usuario_Responsavel_ID_Usuario] ON [dbo].[Usuario_Responsavel]
(
    [ID_Usuario] ASC,
    [ID_Responsavel] ASC
) INCLUDE(ID_Item)  ON [PRIMARY]
GO
--INCLUDE ID_Item 
