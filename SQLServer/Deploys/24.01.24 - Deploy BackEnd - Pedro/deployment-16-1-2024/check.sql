/*
    Script de verificação do deployment 16-1-2024
*/
USE Ploomes_CRM;
GO

-- check 1
-- Precisa retornar a coluna criada AllowAutomationsEdition
SELECT TOP 1 [AllowAutomationsEdition] FROM Ploomes_Cliente;

-- check 2
-- Precisa retornar a coluna criada TimeSpanFromCreationToExecutionInMilliseconds
SELECT TOP 1 [TimeSpanFromCreationToExecutionInMilliseconds] FROM WebHook_Log;

-- check 3
-- removido do pacote