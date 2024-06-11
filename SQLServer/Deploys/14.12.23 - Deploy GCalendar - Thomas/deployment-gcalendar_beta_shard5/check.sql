/*
Script de verificação do calendar no shard 5 para as contas novas criadas com os modelos trial
*/

USE Ploomes_CRM;

-- Precisa retornar algo sem dar erro nos 3 selects
SELECT TOP 1 * FROM SVw_Integration;
SELECT TOP 1 * FROM SVw_Ploomes_Cliente_Integration;