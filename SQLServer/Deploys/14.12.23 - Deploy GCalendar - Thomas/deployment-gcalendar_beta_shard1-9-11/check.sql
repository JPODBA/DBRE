/*
Script de verificação do calendar no shard 5 para as contas novas criadas com os modelos trial
*/

USE Ploomes_CRM;

-- Precisa retornar algo sem dar erro nos 3 selects
SELECT TOP 1 * FROM SVw_Integration;
SELECT TOP 1 * FROM SVw_Ploomes_Cliente_Integration;


--select * from Ploomes_Cliente_Integration WHERE IntegrationId = 12 AND StatusId = 1 AND Authorized = 1

SELECT * FROM Account_Integration Where IntegrationId = 12 AND AccountId IN (SELECT A.ID FROM Account A
INNER JOIN HostSet HS
ON A.HostSetId = HS.Id
WHERE HS.ShardId = 9) 

UPDATE Account_Integration SET StatusId = 3 Where IntegrationId = 12 AND AccountId IN (SELECT A.ID FROM Account A
INNER JOIN HostSet HS
ON A.HostSetId = HS.Id
WHERE HS.ShardId = 9)