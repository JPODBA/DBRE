/*
SCRIPT DE VERIFICAÇÃO DA BRANCH fix_web_link_slowness
*/
USE Ploomes_CRM
GO

-- só verifica se a tabela foi criada corretamente, não precisa retornar nada
SELECT Id, AccountId, [Key], [Type] FROM External_Shared_Keys

-- precisa retornar 1 entrada
SELECT * FROM Mapping_Table WHERE ID = 20

-- Precisa retornar 3 entradas
SELECT * FROM Mapping_Column WHERE ID IN (307, 308, 309)