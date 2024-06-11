/*
    Script de verificação do deployment-9-1-2024
*/
USE Ploomes_CRM
GO

-- check do up 1
-- Deve retornar ao menos NULL
SELECT TOP 1 WhiteLabelName FROM Ploomes_Cliente (nolock)

-- check do up 2
-- deve retornar ao menos null
SELECT TOP 1 LastInteractionRecordId, LastOrderId, LastDocumentId, LastDealId FROM Cliente 
-- devem retornar algo
SELECT TOP 1 * FROM SVw_Cliente
SELECT TOP 1 * FROM DVw_Cliente d order by 1 
--where d.ID_Usuario = 117393

