USE Ploomes_CRM;

-- Check do up 1
-- Precisa retornar algo
SELECT TOP 1 * FROM DVw_Tarefa;

-- Check do up 4
-- Precisa retornar o valor 1
SELECT NaoNulavel FROM CampoFixo2 WHERE ID = 1094;

-- Check do up 5
-- Precisa retornar OtherOptionsCreatePermission nos dois selects
SELECT PermissaoCriacaoOpcoes FROM CampoFixo2 WHERE Chave = 'contact_relationship';
SELECT OptionsCreationPermissionPropertyName FROM Campo_Tabela WHERE ID = 46;