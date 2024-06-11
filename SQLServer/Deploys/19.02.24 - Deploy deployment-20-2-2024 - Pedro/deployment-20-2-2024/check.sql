/*
    Script de verificação do deployment 20-2-2024
*/
USE Ploomes_CRM;
GO

-- check 1
-- Só deve retornar registros de Leadas onde Ploomes_Cliente possua o módulo ativo
SELECT TOP 1 * FROM SVw_Lead
GO
-- check 2
-- A informação de Length da coluna Name deve vir com o valor 400
sp_help PublicForm_Field_Option
GO
-- check 3
-- Deve trazer a nova coluna criada DisabledDueToError, com o valor 0
SELECT TOP 1 DisabledDueToError,* FROM Automation
