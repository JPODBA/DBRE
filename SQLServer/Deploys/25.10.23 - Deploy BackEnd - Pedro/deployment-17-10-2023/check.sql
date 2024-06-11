-- check up 1
-- Não deve retornar nada
SELECT TOP 1 * FROM Oportunidade (NOLOCK)
    WHERE ID_Status2 IN (1, 2) 
    AND ID_MotivoPerda IS NOT NULL;

-- check up 2
-- removido do pacote

-- check up 3
-- Só deve retornar 0
SELECT TOP 100 [RemoveFieldHeightLimit] FROM Campo (NOLOCK);

-- check up 4
-- deve retornar algo
SELECT TOP 1 [RemoveFieldHeightLimit] FROM [dbo].[SVw_Campo] (NOLOCK);

-- check up 5
-- Não deve retornar nada
SELECT TOP 1 * FROM Cliente_Telefone (NOLOCK) WHERE Telefone IS NULL OR Telefone = '';