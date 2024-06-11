/*
    Script de verificação do deployment 14-12-2023
*/
USE Ploomes_CRM;
GO

-- check do up 1
-- Precisa retornar algo sem erros
SELECT TOP 1 * FROM SVw_Formulario_Secao;