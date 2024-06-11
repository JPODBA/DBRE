/*
    Script de check da branch fix_add_whitelabelname_column
*/
USE Ploomes_CRM
GO

-- check do up 1
-- Precisa retornar algo sem erros
SELECT TOP 1 [AllowAutomationsEdition] FROM Account
