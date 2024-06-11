/*
 Rodar com o registered servers em todos os shards para garantir
 que essa coluna existe em todos
*/
USE Ploomes_crm
GO
select top 1 WhiteLabelName from Ploomes_Cliente