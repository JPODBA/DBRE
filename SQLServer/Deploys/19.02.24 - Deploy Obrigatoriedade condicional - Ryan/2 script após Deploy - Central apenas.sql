use Ploomes_CRM
go

UPDATE HostSet
SET FrontendApiUrl = 'https://frontend-api-s7.ploomes.com/api/'
WHERE ShardId = 7
go
UPDATE HostSet
SET FrontendApiUrl = 'https://frontend-api-s1.ploomes.com/api/'
WHERE ShardId = 1