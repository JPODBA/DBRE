/*
Script de verificação do calendar no shard 5 para as contas novas criadas com os modelos trial
*/

USE Ploomes_CRM;

-- Precisa retornar ao menos 1
SELECT COUNT(*) FROM INTEGRATION WHERE ID = 27;

-- Precisa retornar ao menos 15
SELECT COUNT(*) FROM Integration_CustomField WHERE IntegrationId = 27;

-- Precisa retornar ao menos 45
SELECT COUNT(*) FROM Integration_CustomField_Language WHERE ID > 131;

-- Precisa retornar ao menos 3
SELECT COUNT(*) FROM Integration_Language WHERE IntegrationId = 27;

-- Precisa retornar ao menos 5
SELECT COUNT(*) FROM Integration_Webhook WHERE IntegrationId = 27;

-- Precisa retornar algo sem dar erro nos 3 selects
SELECT TOP 1 * FROM SVw_Integration;
SELECT TOP 1 * FROM SVw_Ploomes_Cliente_Integration;
SELECT TOP 1 * FROM Vw_Self;