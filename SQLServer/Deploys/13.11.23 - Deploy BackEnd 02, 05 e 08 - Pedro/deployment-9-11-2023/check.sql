USE Ploomes_CRM;

-- Check do up 1
-- Precisa retornar algo
SELECT TOP 1 * FROM DVw_Tarefa;

-- Check do up 2 e up 3
-- Precisa retornar duas linhas
SELECT TOP 10 * FROM CampoFixo2 WHERE ID IN (1536, 1537);
-- Precisa retornar 8
SELECT COUNT(*) FROM CampoFixo2_Cultura WHERE ID IN (536, 11536, 30537, 21536, 537, 11537, 21537, 30538);
-- Precisa retornar ao menos duas linhas
SELECT TOP 10 * FROM Field WHERE [Key] IN ('user_creator', 'deal_last_stage_change_date');

-- Check do up 4
-- Precisa retornar o valor 1
SELECT NaoNulavel FROM CampoFixo2 WHERE ID = 1094;

-- Check do up 5
-- Precisa retornar OtherOptionsCreatePermission nos dois selects
SELECT PermissaoCriacaoOpcoes FROM CampoFixo2 WHERE Chave = 'contact_relationship';
SELECT OptionsCreationPermissionPropertyName FROM Campo_Tabela WHERE ID = 46;

-- Check do up 6
-- Precisa retornar uma linha
SELECT TOP 10 * FROM CampoFixo2 WHERE ID = 1538;
-- Precisa retornar 4
SELECT COUNT(*) FROM CampoFixo2_Cultura WHERE ID IN (538, 11538, 21538, 30539);
-- Precisa retornar ao menos uma linha
SELECT TOP 10 * FROM Field WHERE [Key] = 'deal_stage_ordination';