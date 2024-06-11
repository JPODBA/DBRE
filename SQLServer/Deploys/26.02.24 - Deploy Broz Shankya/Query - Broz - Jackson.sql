--Para confirmar que as Integrações 1599 e 1950 são mesmo integrações anteriores da account 4004364 (pra não apagar filas de outras accounts).
SELECT [Id],[AccountId] 
FROM [Integrations].[dbo].[Integration] 
WHERE [Id] IN (1599, 1950) AND [AccountId] = 4004364

Para "limpar" a fila da Integração 1599:
UPDATE [Queue].[dbo].[Integration_Queue] 
SET [Status] = 77 
WHERE [Status] < 4 and [IntegrationId] = 1599

Para "limpar" a fila da Integração 1950
UPDATE [Queue].[dbo].[Integration_Queue] 
SET [Status] = 77 
WHERE [Status] < 4 and [IntegrationId] = 1950

Para desintegrar qualquer outra integração da account 4004364 que ainda esteja habilitada/ativa (menos a 2022):
UPDATE [Integrations].[dbo].[Integration] 
SET [ReplacedIn] = '2024-02-23 17:18:19'
WHERE [AccountId] = 4004364 AND [Id] != 2022 AND [ReplacedIn] IS NULL
horário do que, vc diz?


UPDATE [Queue].[dbo].[Integration_Queue] 
SET [Status] = 77 
WHERE [Status] < 4 and [IntegrationId] = 2022