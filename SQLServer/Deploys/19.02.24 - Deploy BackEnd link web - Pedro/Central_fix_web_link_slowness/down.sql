/*
SCRIPT DE ROLLBACK DA BRANCH fix_web_link_slowness
*/
USE Ploomes_CRM
GO

DROP TABLE [dbo].[External_Shared_Keys]
DELETE FROM Mapping_Table WHERE ID = 20
DELETE FROM Mapping_Column WHERE ID IN (307, 308, 309)