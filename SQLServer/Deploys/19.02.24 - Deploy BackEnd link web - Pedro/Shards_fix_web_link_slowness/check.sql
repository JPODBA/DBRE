/*
SCRIPT DE VERIFICAÇÃO DA BRANCH fix_web_link_slowness 
*/
USE Ploomes_CRM
GO

-- Só verifica se a tabela foi criada certo, não precisa retornar nada
SELECT Id, AccountId, [Key], [Type] FROM External_Shared_Keys