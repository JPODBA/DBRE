use Ploomes_CRM
go

UPDATE Account_Integration SET StatusId = 3 Where IntegrationId = 12 AND AccountId IN (SELECT A.ID FROM Account A
INNER JOIN HostSet HS
ON A.HostSetId = HS.Id
WHERE HS.ShardId = 4)

UPDATE Account_Integration SET StatusId = 3 Where IntegrationId = 12 AND AccountId IN (SELECT A.ID FROM Account A
INNER JOIN HostSet HS
ON A.HostSetId = HS.Id
WHERE HS.ShardId = 6)


UPDATE Account_Integration SET StatusId = 3 Where IntegrationId = 12 AND AccountId IN (SELECT A.ID FROM Account A
INNER JOIN HostSet HS
ON A.HostSetId = HS.Id
WHERE HS.ShardId = 2)

UPDATE Account_Integration SET StatusId = 3 Where IntegrationId = 12 AND AccountId IN (SELECT A.ID FROM Account A
INNER JOIN HostSet HS
ON A.HostSetId = HS.Id
WHERE HS.ShardId = 8)