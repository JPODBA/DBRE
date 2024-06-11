-- check up 1
-- Tem que retornar 74, 15 e 22
SELECT TOP 3 EntityId FROM [Mapping_Table] (NOLOCK)
WHERE ID IN (14, 1, 8);