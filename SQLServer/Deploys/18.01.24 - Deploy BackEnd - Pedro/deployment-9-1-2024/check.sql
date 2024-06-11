/*
    Script de verificação do deployment-9-1-2024
*/
USE Ploomes_CRM
GO

-- check do up 1
-- Deve retornar ao menos NULL
SELECT TOP 1 WhiteLabelName FROM Ploomes_Cliente

-- check do up 2
-- deve retornar ao menos null
SELECT TOP 1 LastInteractionRecordId, LastOrderId, LastDocumentId, LastDealId FROM Cliente
-- devem retornar algo
SELECT TOP 1 * FROM DVw_Cliente ORDER BY 1
SELECT TOP 1 * FROM SVw_Cliente ORDER BY 1